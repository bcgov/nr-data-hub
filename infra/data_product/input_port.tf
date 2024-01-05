locals {
  format_string = "${var.name}-input-${var.environment}"
}

data "aws_s3_bucket" "source" {
  bucket = var.source_bucket_id
}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket            = "data-product-${var.environment}"
  block_public_acls = true
}

resource "aws_s3_object" "raw" {
  bucket = module.bucket.s3_bucket_id
  key    = "raw/"
}

data "aws_iam_policy_document" "data_sync_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["datasync.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "datasync_raw_replication" {
  statement {
    sid = "SourceS3List"
    effect = "Allow"
    actions = [

      "s3:ListBucketMultipartUploads",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      data.aws_s3_bucket.source.arn,
    ]
  }
  statement {
    sid = "SourceS3Read"
    effect = "Allow"
    actions = [
      "s3:GetObjectAcl",
      "s3:GetObject",
    ]
    resources = [
      "${data.aws_s3_bucket.source.arn}/${var.source_bucket_key}*",
    ]
  }
  statement {
    sid = "DestinationS3List"
    effect = "Allow"
    actions = [
      "s3:ListBucketMultipartUploads",
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
    resources = [
      module.bucket.s3_bucket_arn,
    ]
  }
  statement {
    sid = "DestinationS3Write"
    effect = "Allow"
    actions = [
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObject",
    ]
    resources = [
      "${module.bucket.s3_bucket_arn}/${aws_s3_object.raw.key}*",
    ]
  }
}

resource "aws_iam_role" "raw_data_replication" {
  name = "${var.name}-raw-replication-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.data_sync_assume.json
  inline_policy {
    name = "datasync-replication-policy"
    policy = data.aws_iam_policy_document.datasync_raw_replication.json
  }
}

resource "aws_datasync_location_s3" "source" {
  s3_bucket_arn = data.aws_s3_bucket.source.arn
  subdirectory  = var.source_bucket_key

  s3_config {
    bucket_access_role_arn = aws_iam_role.raw_data_replication.arn
  }
}

resource "aws_datasync_location_s3" "destination" {
  s3_bucket_arn = module.bucket.s3_bucket_arn
  subdirectory  = aws_s3_object.raw.key

  s3_config {
    bucket_access_role_arn = aws_iam_role.raw_data_replication.arn
  }
}

resource "aws_datasync_task" "raw_nightly_replication" {
  name                     = "${var.name}-raw-replication-${var.environment}"
  source_location_arn      = aws_datasync_location_s3.source.arn
  destination_location_arn = aws_datasync_location_s3.destination.arn
}

resource "aws_kms_key" "trigger_datasync_task_lambda" {
  description             = "KMS Key for the lambda that triggers the datasync replication tasks"
  deletion_window_in_days = 7
}

data "aws_iam_policy_document" "trigger_datasync_task_lambda" {
  statement {
    sid = "TriggerDataSyncReplicationTask"
    actions = [
      "datasync:StartTaskExecution",
      "datasync:DescribeTaskExecution",
    ]
    resources = [
      aws_datasync_task.raw_nightly_replication.arn,
    ]
  }
  statement {
    sid = "AllowKMSKeyAccess"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.trigger_datasync_task_lambda.arn,
    ]
  }
}

data "archive_file" "trigger_datasync_task_lambda" {
  type        = "zip"
  source_file = "${path.module}/../../src/lambdas/trigger_datasync/handler.py"
  output_path = "${path.module}/builds/trigger_datasync.zip"
}

module "trigger_datasync_task_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.4.0"

  function_name = aws_datasync_task.raw_nightly_replication.name
  description   = "Lambda to replicate data from the source bucket into the data product."

  create_package         = false
  local_existing_package = data.archive_file.trigger_datasync_task_lambda.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn = aws_kms_key.trigger_datasync_task_lambda.arn

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.trigger_datasync_task_lambda.json

  environment_variables = {
    TASK_ARN = aws_datasync_task.raw_nightly_replication.arn
  }
}

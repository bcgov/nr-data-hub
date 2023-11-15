data "aws_iam_policy_document" "api_permits_get_all_lambda" {
  statement {
    sid = "AllowAthenaFederatedQueries"
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryResults",
      "athena:GetWorkGroup",
      "athena:StopQueryExecution",
      "athena:GetQueryExecution",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    sid = "AllowWriteToS3"
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
    ]
    resources = [
      module.bucket.s3_bucket_arn,
      "${module.bucket.s3_bucket_arn}/${aws_s3_object.athena_query_output.key}*",
      "${module.bucket.s3_bucket_arn}/${aws_s3_object.data_lake.key}*",
    ]
  }
  statement {
    sid = "AllowGlueAccess"
    actions = [
      "glue:GetDatabase",
      "glue:GetTable",
      "glue:GetPartitions",
    ]
    resources = [
      "arn:aws:glue:ca-central-1:${data.aws_caller_identity.current.account_id}:catalog",
      aws_glue_catalog_database.permitting.arn,
      aws_glue_catalog_table.permitting_vfcbc.arn,
      aws_glue_catalog_table.permitting_tantalis.arn,
      aws_glue_catalog_table.permitting_ats.arn,
    ]
  }
  statement {
    sid = "AllowKMSKeyAccess"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.api_permits_get_all_lambda.arn,
    ]
  }
}

resource "aws_kms_key" "api_permits_get_all_lambda" {
  description             = "KMS Key for the GET permits Lambda"
  deletion_window_in_days = 7
}

module "api_permits_get_all_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format(local.resource_environment_fs, "api-get-record")
  description   = "Lambda to get all permits from the data lake using Athena."

  create_package         = false
  local_existing_package = data.archive_file.api_permits_get_all.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn        = aws_kms_key.api_permits_get_all_lambda.arn
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.api_permits_get_all_lambda.json

  environment_variables = {
    GLUE_DATABASE_NAME           = aws_glue_catalog_database.permitting.name
    ATHENA_QUERY_OUTPUT_LOCATION = "s3://${module.bucket.s3_bucket_id}/${aws_s3_object.athena_query_output.key}"
  }
}

resource "aws_s3_object" "processed" {
  bucket = module.bucket.s3_bucket_id
  key    = "processed/"
}

resource "aws_lambda_permission" "allow_internal_bucket_to_invoke" {
  statement_id  = "AllowInvocationFromSourceS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.processing_lambda.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.bucket.s3_bucket_arn
}

resource "aws_s3_bucket_notification" "raw_bucket_notification" {
  bucket = module.bucket.s3_bucket_id

  lambda_function {
    lambda_function_arn = module.processing_lambda.lambda_function_arn
    events              = [
      "s3:ObjectCreated:*",
    ]
    filter_prefix = aws_s3_object.raw.key
  }

  depends_on = [
    aws_lambda_permission.allow_internal_bucket_to_invoke,
  ]
}

resource "aws_kms_key" "processing_lambda" {
  description             = "KMS Key for the ${var.name} data product processing lambda."
  deletion_window_in_days = 7
}

data "aws_iam_policy_document" "processing_lambda" {
  statement {
    sid = "WriteToS3"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
       "${module.bucket.s3_bucket_arn}/${aws_s3_object.processed.key}*",
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

module "processing_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.4.0"

  function_name = "${var.name}-processing-lambda-${var.environment}"
  description   = "${var.name} data product processing lambda."

  create_package         = false
  local_existing_package = var.processing_lambda_build_location

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn = aws_kms_key.processing_lambda.arn

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.processing_lambda.json

  environment_variables = {
    BUCKET_NAME = module.bucket.s3_bucket_id
    KEY = aws_s3_object.processed.key
  }
}

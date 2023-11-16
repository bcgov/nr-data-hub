resource "aws_lambda_permission" "allow_cloudwatch_to_call_write_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.write_to_data_lake_lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.permitting_raw.arn
}

data "aws_iam_policy_document" "write_to_data_lake_lambda" {
  statement {
    sid = "AccessS3"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      "${module.bucket.s3_bucket_arn}/${aws_s3_object.data_lake.key}*",
    ]
  }
  statement {
    sid = "AllowKMSKeyAccess"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.write_to_data_lake_lambda.arn,
    ]
  }
}

resource "aws_kms_key" "write_to_data_lake_lambda" {
  description             = "KMS Key for the batch write to data lake lambda"
  deletion_window_in_days = 7
}

module "write_to_data_lake_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format(local.resource_environment_fs, "write-to-data-lake-lambda")
  description   = "Lambda to write batches of SQS messages to the data lake in S3."

  create_package         = false
  local_existing_package = data.archive_file.write_to_data_lake.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn = aws_kms_key.write_to_data_lake_lambda.arn

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.write_to_data_lake_lambda.json

  environment_variables = {
    BUCKET_NAME   = module.bucket.s3_bucket_id
    DATA_LAKE_KEY = aws_s3_object.data_lake.key
  }
}

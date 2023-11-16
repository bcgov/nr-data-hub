data "aws_iam_policy_document" "write_to_dynamo_lambda" {
  statement {
    sid = "AllowDynamoDBAccess"
    actions = [
      "dynamodb:UpdateItem",
    ]
    resources = [
      aws_dynamodb_table.permit_status_table.arn,
    ]
  }
  statement {
    sid = "AllowKMSKeyAccess"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.write_to_dynamo_lambda.arn,
    ]
  }
}

resource "aws_kms_key" "write_to_dynamo_lambda" {
  description             = "KMS Key for the write to dynamo lambda"
  deletion_window_in_days = 7
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_write_to_dynamo_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.write_to_dynamo_lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.permitting_raw.arn
}

module "write_to_dynamo_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format(local.resource_environment_fs, "write-to-dynamo-lambda")
  description   = "Lambda to write permit status data to DynamoDB."

  create_package         = false
  local_existing_package = data.archive_file.write_to_dynamo.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn        = aws_kms_key.write_to_dynamo_lambda.arn
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.write_to_dynamo_lambda.json

  environment_variables = {
    DYNAMODB_TABLE_NAME = aws_dynamodb_table.permit_status_table.name
  }
}

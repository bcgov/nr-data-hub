data "aws_iam_policy_document" "dyanmo_stream_processor_lambda" {
  statement {
    sid = "AllowDynamoDBAccess"
    actions = [
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:DescribeStream",
      "dynamodb:ListStreams",
    ]
    resources = [
      aws_dynamodb_table.permit_status_table.stream_arn,
    ]
  }
    statement {
    sid = "AllowEventBridgeAccess"
    actions = [
      "events:PutEvents",
    ]
    resources = [
      aws_cloudwatch_event_bus.permitting.arn
    ]
  }
  statement {
    sid = "AllowKMSKeyAccess"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.dyanmo_stream_processor_lambda.arn,
    ]
  }
}

resource "aws_kms_key" "dyanmo_stream_processor_lambda" {
  description             = "KMS Key for the dynamo stream processor lambda"
  deletion_window_in_days = 7
}

module "dyanmo_stream_processor_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format(local.resource_environment_fs, "dynamo-stream-processor-lambda")
  description   = "Lambda to process CDC changes on the DynamoDB table."

  create_package         = false
  local_existing_package = data.archive_file.dynamo_cdc_processor.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn        = aws_kms_key.dyanmo_stream_processor_lambda.arn
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.dyanmo_stream_processor_lambda.json
}

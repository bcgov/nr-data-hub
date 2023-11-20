data "aws_iam_policy_document" "get_statuses_lambda" {
  statement {
    sid = "AllowDynamoDBAccess"
    actions = [
      "dynamodb:GetItem",
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
      aws_kms_key.api_statuses_get_all_lambda.arn,
    ]
  }
}

resource "aws_kms_key" "api_statuses_get_all_lambda" {
  description             = "KMS Key for the get statuses lambda"
  deletion_window_in_days = 7
}

module "api_statuses_get_all_lambda" {
  source = "terraform-aws-modules/lambda/aws"
  version = "6.4.0"

  function_name = format(local.resource_environment_fs, "get-statuses-lambda")
  description   = "Lambda to get permit statuses data from DynamoDB."

  create_package         = false
  local_existing_package = data.archive_file.api_statuses_get_all.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn        = aws_kms_key.api_statuses_get_all_lambda.arn
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.get_statuses_lambda.json

  environment_variables = {
    DYNAMODB_TABLE_NAME = aws_dynamodb_table.permit_status_table.name
  }
}

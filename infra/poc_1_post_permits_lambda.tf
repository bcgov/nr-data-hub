data "aws_iam_policy_document" "api_permits_post_lambda" {
  statement {
    sid = "PublishToEventBridge"
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
      aws_kms_key.api_permits_post_lambda.arn,
    ]
  }
}

resource "aws_kms_key" "api_permits_post_lambda" {
  description             = "KMS Key for the POST permits lambda"
  deletion_window_in_days = 7
}

module "api_permits_post_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.4.0"

  function_name = format(local.resource_environment_fs, "api-permits-post-lambda")
  description   = "Lambda to handle POST requests."

  create_package         = false
  local_existing_package = data.archive_file.api_permits_post.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn        = aws_kms_key.api_permits_post_lambda.arn
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.api_permits_post_lambda.json

  environment_variables = {
    EventBusName = aws_cloudwatch_event_bus.permitting.arn
  }
}

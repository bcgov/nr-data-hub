resource "aws_cloudwatch_event_target" "trigger_write_to_dynamodb" {
  arn            = module.write_to_dynamo_lambda.lambda_function_arn
  rule           = aws_cloudwatch_event_rule.permitting_raw.name
  event_bus_name = aws_cloudwatch_event_bus.permitting.name
}

resource "aws_cloudwatch_event_archive" "permitting_statuses" {
  name             = format(local.resource_environment_fs, "statuses-all")
  event_source_arn = aws_cloudwatch_event_bus.permitting.arn
  description      = "Archive to store all permitting status change events"

  event_pattern = jsonencode({
    detail-type = ["Permit Status Change"]
  })
}

data "aws_iam_policy_document" "teams_notifications" {
  statement {
    sid = "AllowAPIInvocation"
    actions = [
      "events:InvokeApiDestination",
    ]
    resources = [
      aws_cloudwatch_event_api_destination.teams_webhook.arn,
    ]
  }
}

resource "aws_iam_role" "teams_notifications" {
  name               = format(local.resource_environment_fs, "status-api-trigger")
  assume_role_policy = data.aws_iam_policy_document.eventbridge_assume.json
  inline_policy {
    name = "AllowEventBridge"
    policy = data.aws_iam_policy_document.teams_notifications.json
  }
}

resource "aws_cloudwatch_event_target" "teams_notifications" {
  arn            = aws_cloudwatch_event_api_destination.teams_webhook.arn
  rule           = aws_cloudwatch_event_rule.teams_notifications.name
  event_bus_name = aws_cloudwatch_event_bus.permitting.name

  role_arn = aws_iam_role.teams_notifications.arn

  input_transformer {
    input_paths = {
      message = "$.detail.message"
      detail_type = "$.detail-type",
    }
    input_template = "{\"text\":\"<detail_type>\\n\\n<message>\"}"
  }
}

resource "aws_cloudwatch_event_rule" "teams_notifications" {
  name           = format(local.resource_environment_fs, "teams-notifications")
  description    = "Permit Status filter"
  event_bus_name = aws_cloudwatch_event_bus.permitting.name

  event_pattern = jsonencode({
    detail-type = [
      "Project Added",
      "Permit Added to Project",
      "Permit Status Changed"
    ]
  })
}

resource "aws_cloudwatch_event_api_destination" "teams_webhook" {
  name                             = format(local.resource_environment_fs, "teams-webhook")
  description                      = "Teams webhook destination."
  invocation_endpoint              = var.webhook_url
  http_method                      = "POST"
  connection_arn                   = aws_cloudwatch_event_connection.teams_webhook.arn
}

resource "aws_cloudwatch_event_connection" "teams_webhook" {
  name               = format(local.resource_environment_fs, "teams-webhook")
  description        = "Teams connection."
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key = "Dummy"
      value = "None"
    }
  }
}

data "archive_file" "status_handler" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/status/handler.py"
  output_path = "${path.module}/builds/status_handler.zip"
}

resource "aws_cloudwatch_event_target" "status_handler" {
  arn            = module.status_handler_lambda.lambda_function_arn
  rule           = aws_cloudwatch_event_rule.permitting_data.name
  event_bus_name = aws_cloudwatch_event_bus.events.name
}

data "aws_iam_policy_document" "status_handler_lambda" {
  statement {
    sid = "PublishToEventBridge"
    actions = [
      "events:PutEvents",
    ]
    resources = [
      aws_cloudwatch_event_bus.status_events.arn
    ]
  }
  statement {
    sid = "AllowKMSKeyAccess"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.api_post_record.arn,
    ]
  }
}

resource "aws_kms_key" "status_handler_lambda" {
  description             = "KMS Key for the Status Handler Lambda"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_event_target" "status_data" {
  arn            = module.status_handler_lambda.lambda_function_arn
  rule           = aws_cloudwatch_event_rule.permitting_data.name
  event_bus_name = aws_cloudwatch_event_bus.events.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_status_handler_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.status_handler_lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.permitting_data.arn
}

module "status_handler_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format(local.resource_format_string, "status-handler-event")
  description   = "Lambda to handle status changes to permitting records, feeding notifications."

  create_package         = false
  local_existing_package = data.archive_file.status_handler.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn        = aws_kms_key.status_handler_lambda.arn
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.status_handler_lambda.json

  environment_variables = {
    EventBusName = aws_cloudwatch_event_bus.status_events.arn
  }
}

resource "aws_cloudwatch_event_bus" "status_events" {
  name = format(local.resource_format_string, "status-events")
}

data "aws_iam_policy_document" "events_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "events_target" {
  statement {
    sid = "AllowAPIInvocation"
    actions = [
      "events:InvokeApiDestination",
    ]
    resources = [
      aws_cloudwatch_event_api_destination.teams_webhook.arn,
    ]
  }
  statement {
    sid = "AllowSQSMessages"
    actions = [
      "sqs:SendMessages"
    ]
    resources = [
      aws_sqs_queue.events_dead_letter_queue.arn,
    ]
  }
}

resource "aws_sqs_queue" "events_dead_letter_queue" {
  name = format(local.resource_format_string, "events-dlq")
  visibility_timeout_seconds = 0
}

resource "aws_iam_role" "events_api_trigger" {
  name               = format(local.resource_format_string, "events-api-trigger")
  assume_role_policy = data.aws_iam_policy_document.events_assume.json
  inline_policy {
    name = "InvokeAPI"
    policy = data.aws_iam_policy_document.events_target.json
  }
}

resource "aws_cloudwatch_event_target" "webhook_notifications" {
  arn            = aws_cloudwatch_event_api_destination.teams_webhook.arn
  rule           = aws_cloudwatch_event_rule.status_events.name
  event_bus_name = aws_cloudwatch_event_bus.status_events.name

  dead_letter_config {
    arn = aws_sqs_queue.events_dead_letter_queue.arn
  }

  role_arn = aws_iam_role.events_api_trigger.arn

  input_transformer {
    input_paths = {
      source = "$.source",
    }
    input_template = "{\"text\":\"Hello World for a <source> event!\"}"
  }
}

resource "aws_cloudwatch_event_rule" "status_events" {
  name           = format(local.resource_format_string, "status-events")
  description    = "Permit Status filter"
  event_bus_name = aws_cloudwatch_event_bus.status_events.name

  event_pattern = jsonencode({
    detail-type = [
      "Permitting Status Changed"
    ]
  })
}

resource "aws_cloudwatch_event_api_destination" "teams_webhook" {
  name                             = format(local.resource_format_string, "teams-webhook")
  description                      = "Teams webhook destination."
  invocation_endpoint              = var.webhook_url
  http_method                      = "POST"
  connection_arn                   = aws_cloudwatch_event_connection.teams_webhook.arn
}

resource "aws_cloudwatch_event_connection" "teams_webhook" {
  name               = format(local.resource_format_string, "teams-status-changes")
  description        = "Teams connection."
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key = "Dummy"
      value = "None"
    }
    # invocation_http_parameters {
    #   header {
    #     key             = "Content-Type"
    #     value           = "application/json"
    #     is_value_secret = false
    #   }
    # }
  }
}

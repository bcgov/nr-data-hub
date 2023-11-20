resource "aws_cloudwatch_event_bus" "permitting" {
  name = local.environment_fs
}

resource "aws_cloudwatch_event_archive" "permitting_raw" {
  name             = format(local.resource_environment_fs, "archive-raw")
  event_source_arn = aws_cloudwatch_event_bus.permitting.arn
  description      = "Archive to store all permitting events"

  event_pattern = jsonencode({
    detail-type = [ "API POST" ]
  })
}

resource "aws_cloudwatch_event_rule" "permitting_raw" {
  name           = format(local.resource_environment_fs, "rule-raw")
  description    = "Permitting data filter"
  event_bus_name = aws_cloudwatch_event_bus.permitting.name

  event_pattern = jsonencode({
    detail-type = [ "API POST" ]
  })
}

resource "aws_cloudwatch_event_target" "permitting_raw" {
  arn            = module.write_to_data_lake_lambda.lambda_function_arn
  rule           = aws_cloudwatch_event_rule.permitting_raw.name
  event_bus_name = aws_cloudwatch_event_bus.permitting.name
}

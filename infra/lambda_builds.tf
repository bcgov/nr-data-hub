data "archive_file" "api_permits_get_all" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/permits/get_all/handler.py"
  output_path = "${path.module}/builds/api_permits_get_all.zip"
}

data "archive_file" "api_permits_post" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/permits/post/handler.py"
  output_path = "${path.module}/builds/api_permits_post.zip"
}

data "archive_file" "api_statuses_get_all" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/statuses/get_all/handler.py"
  output_path = "${path.module}/builds/api_statuses_get_all.zip"
}

data "archive_file" "api_statuses_get_by_tracking_number" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/statuses/get_by_tracking_number/handler.py"
  output_path = "${path.module}/builds/api_statuses_get_by_tracking_number.zip"
}

data "archive_file" "write_to_data_lake" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/write_to_data_lake/handler.py"
  output_path = "${path.module}/builds/write_to_data_lake.zip"
}

data "archive_file" "write_statuses_to_dynamo" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/write_statuses_to_dynamo/handler.py"
  output_path = "${path.module}/builds/write_statuses_to_dynamo.zip"
}

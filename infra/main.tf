locals {
  is_dev                 = !contains(["production", "tools", "test"], var.environment)
  format_string          = local.is_dev ? "nr-event-based-data-${var.environment}" : "nr-event-based-data"
  resource_format_string = local.is_dev ? "nr-event-based-data-%s-${var.environment}" : "nr-event-based-data-%s"
}

data "aws_caller_identity" "current" {}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket            = local.format_string
  block_public_acls = true
}

resource "aws_s3_object" "data_lake" {
  bucket = module.bucket.s3_bucket_id
  key    = "data_lake/"
}

resource "aws_s3_object" "athena_query_output" {
  bucket = module.bucket.s3_bucket_id
  key    = "athena_query_output/"
}

data "archive_file" "api_post_record" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/record/post/handler.py"
  output_path = "${path.module}/builds/api_post_record.zip"
}

data "archive_file" "write" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/write/handler.py"
  output_path = "${path.module}/builds/write.zip"
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "api_post_record" {
  statement {
    sid = "PublishToEventBridge"
    actions = [
      "events:PutEvents",
    ]
    resources = [
      aws_cloudwatch_event_bus.events.arn
    ]
  }
  statement {
    sid = "AllowGlueAccess"
    actions = [
      "glue:GetDatabase",
      "glue:GetTables",
      "glue:GetPartitions",
    ]
    resources = [
      "arn:aws:glue:ca-central-1:${data.aws_caller_identity.current.account_id}:catalog",
      aws_glue_catalog_database.permitting.arn,
      aws_glue_catalog_table.permitting_water.arn,
      aws_glue_catalog_table.permitting_infrastructure.arn,
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

resource "aws_kms_key" "api_post_record" {
  description             = "KMS Key for the Generate Lambda"
  deletion_window_in_days = 7
}

module "api_post_record_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format(local.resource_format_string, "api-post-record")
  description   = "Lambda to POST dummy data to the event driven architecture POC."

  create_package         = false
  local_existing_package = data.archive_file.api_post_record.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn        = aws_kms_key.api_post_record.arn
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.api_post_record.json

  environment_variables = {
    EventBusName = aws_cloudwatch_event_bus.events.arn
  }
}

resource "aws_cloudwatch_event_bus" "events" {
  name = local.format_string
}

resource "aws_cloudwatch_event_rule" "permitting_data" {
  name           = format(local.resource_format_string, "permitting-events")
  description    = "Permitting data filter"
  event_bus_name = aws_cloudwatch_event_bus.events.name

  event_pattern = jsonencode({
    detail-type = [
      "Permitting"
    ]
  })
}

resource "aws_cloudwatch_event_target" "permitting_data" {
  arn            = module.write_lambda.lambda_function_arn
  rule           = aws_cloudwatch_event_rule.permitting_data.name
  event_bus_name = aws_cloudwatch_event_bus.events.name
}

data "aws_iam_policy_document" "write_lambda" {
  statement {
    sid = "WriteToS3"

    actions = [
      # "s3:DeleteObject",
      # "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      # module.bucket.s3_bucket_arn,
      "${module.bucket.s3_bucket_arn}/${aws_s3_object.data_lake.key}*",
    ]
  }
  statement {
    sid = "AllowKMSKeyAccess"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.write_lambda.arn,
    ]
  }
}

resource "aws_kms_key" "write_lambda" {
  description             = "KMS Key for the Write Lambda"
  deletion_window_in_days = 7
}

module "write_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format(local.resource_format_string, "write-lambda")
  description   = "Lambda to write data to S3 in an event driven architecture POC."

  create_package         = false
  local_existing_package = data.archive_file.write.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn = aws_kms_key.write_lambda.arn

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.write_lambda.json

  environment_variables = {
    BUCKET_NAME   = module.bucket.s3_bucket_id
    DATA_LAKE_KEY = aws_s3_object.data_lake.key
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.write_lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.permitting_data.arn
}

resource "aws_glue_catalog_database" "permitting" {
  name        = format(local.resource_format_string, "permitting")
  description = "Permitting data catalog"
}

resource "aws_glue_catalog_table" "permitting_water" {
  name          = "water"
  database_name = aws_glue_catalog_database.permitting.name

  storage_descriptor {
    location      = "s3://${module.bucket.s3_bucket_id}/${aws_s3_object.data_lake.key}water"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "default-csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "serialization.format" = 1
        "separatorChar"        = ","
      }
    }

    columns {
      name    = "permit_id"
      type    = "string"
      comment = "Unique Water Permit ID."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "project_id"
      type    = "string"
      comment = "Project ID. This ID is used to identify all permits associated with a specific project."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "proximity_to_water"
      type    = "double"
      comment = "Distance of permit application location to nearest water source."
      parameters = {
        required = "false"
      }
    }
  }
}

resource "aws_glue_catalog_table" "permitting_infrastructure" {
  name          = "infrastructure"
  database_name = aws_glue_catalog_database.permitting.name

  storage_descriptor {
    location      = "s3://${module.bucket.s3_bucket_id}/${aws_s3_object.data_lake.key}infrastructure"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "default-csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "serialization.format" = 1
        "separatorChar"        = ","
      }
    }

    columns {
      name    = "permit_id"
      type    = "string"
      comment = "Unique Infrastructure Permit ID."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "project_id"
      type    = "string"
      comment = "Project ID. This ID is used to identify all permits associated with a specific project."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "shares_boundary"
      type    = "boolean"
      comment = "Flag indicating if the application location shares a boundary with another residence."
      parameters = {
        required = "false"
      }
    }
  }
}

data "archive_file" "api_get_record" {
  type        = "zip"
  source_file = "${path.module}/../src/lambdas/api/record/get/handler.py"
  output_path = "${path.module}/builds/api_get_record.zip"
}

data "aws_iam_policy_document" "api_get_record" {
  statement {
    sid = "AllowAthenaFederatedQueries"
    actions = [
      "athena:StartQueryExecution",
      "athena:GetQueryResults",
      "athena:GetWorkGroup",
      "athena:StopQueryExecution",
      "athena:GetQueryExecution",
    ]
    resources = [
      "*", # TODO: Can this be locked down further?
    ]
  }
  # TODO: This needs to be finer grained access
  statement {
    sid = "AllowWriteToS3"
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
    ]
    resources = [
      module.bucket.s3_bucket_arn,
      "${module.bucket.s3_bucket_arn}/${aws_s3_object.athena_query_output.key}*",
      "${module.bucket.s3_bucket_arn}/${aws_s3_object.data_lake.key}*",
    ]
  }
  statement {
    sid = "AllowGlueAccess"
    actions = [
      "glue:GetDatabase",
      "glue:GetTable",
      "glue:GetPartitions",
    ]
    resources = [
      "arn:aws:glue:ca-central-1:${data.aws_caller_identity.current.account_id}:catalog",
      aws_glue_catalog_database.permitting.arn,
      aws_glue_catalog_table.permitting_water.arn,
      aws_glue_catalog_table.permitting_infrastructure.arn,
    ]
  }
  statement {
    sid = "AllowKMSKeyAccess"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.api_get_record.arn,
    ]
  }
}

resource "aws_kms_key" "api_get_record" {
  description             = "KMS Key for the API GET Record Lambda"
  deletion_window_in_days = 7
}

module "api_get_record_lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format(local.resource_format_string, "api-get-record")
  description   = "Lambda to get a record from the data lake using Athena."

  create_package         = false
  local_existing_package = data.archive_file.api_get_record.output_path

  handler     = "handler.handler"
  runtime     = "python3.8"
  memory_size = 128
  timeout     = 60

  kms_key_arn        = aws_kms_key.api_get_record.arn
  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.api_get_record.json

  environment_variables = {
    GLUE_DATABASE_NAME           = aws_glue_catalog_database.permitting.name
    ATHENA_QUERY_OUTPUT_LOCATION = "s3://${module.bucket.s3_bucket_id}/${aws_s3_object.athena_query_output.key}"
  }
}

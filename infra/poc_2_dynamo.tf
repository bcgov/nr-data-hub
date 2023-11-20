resource "aws_dynamodb_table" "permit_status_table" {
  name             = format(local.resource_environment_fs, "status")
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  hash_key = "trackingnumber"

  attribute {
    name = "trackingnumber"
    type = "S"
  }
}

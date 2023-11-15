module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket            = local.environment_fs
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

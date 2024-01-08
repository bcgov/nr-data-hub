module "retro_fit_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket            = "permitting-on-prem-replication-${var.environment}"
  block_public_acls = true
}

resource "aws_s3_object" "raw" {
  bucket = module.retro_fit_bucket.s3_bucket_id
  key    = "raw/"
}

module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket            = "data-product-${var.environment}"
  block_public_acls = true
}

locals {
  environment_is_dev = !contains(["test"], var.environment)
  domain_agnostic_name = local.environment_is_dev ? "data-hub-${var.environment}" : "data-hub"
}

module "data_hub_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"

  bucket            = local.domain_agnostic_name
  block_public_acls = true
}

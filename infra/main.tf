locals {
  is_dev                 = !contains(["production", "tools", "test"], var.environment)
  environment_fs          = local.is_dev ? "permitting-${var.environment}" : "permitting"
  resource_environment_fs = local.is_dev ? "permitting-%s-${var.environment}" : "permitting"
}

data "aws_caller_identity" "current" {}

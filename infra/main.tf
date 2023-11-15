locals {
  is_dev                  = !contains(["production", "tools", "test"], var.environment)
  environment_fs          = local.is_dev ? "permitting-${var.environment}" : "permitting"
  resource_environment_fs = local.is_dev ? "permitting-%s-${var.environment}" : "permitting"
}

# Shared data
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eventbridge_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

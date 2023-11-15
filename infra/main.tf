locals {
  is_dev                 = !contains(["production", "tools", "test"], var.environment)
  format_string          = local.is_dev ? "nr-event-based-data-${var.environment}" : "nr-event-based-data"
  resource_format_string = local.is_dev ? "nr-event-based-data-%s-${var.environment}" : "nr-event-based-data-%s"
}

data "aws_caller_identity" "current" {}

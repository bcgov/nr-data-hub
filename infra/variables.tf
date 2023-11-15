variable "environment" {
  type        = string
  description = "Name of the environment"
}

variable "webhook_url" {
  type        = string
  description = "URL of the webhook to send notifications to."
}

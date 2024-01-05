variable "name" {
  type = "string"
  description = "Name of the data product."
}

variable "environment" {
  type = "string"
  description = "Name of the environment."
}

variable "source_bucket_id" {
  type = "string"
  description = "Name of the bucket to replicate data from."
}

variable "source_bucket_key" {
  type = "string"
  description = "Key denoting location of data to replicate."
}

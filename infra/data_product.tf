data "archive_file" "permitting_processing_lambda" {
  type        = "zip"
  source_file = "${path.module}/../../src/lambdas/permitting_processor/handler.py"
  output_path = "${path.module}/builds/permitting_processor.zip"
}

module "permitting_data_product_mvp" {
  source = "./data_product"

  name                             = "permitting"
  environment                      = "kane"
  source_bucket_id                 = module.retro_fit_bucket.s3_bucket_id
  source_bucket_key                = aws_s3_object.raw.key
  processing_lambda_build_location = data.archive_file.permitting_processing_lambda.output_path
}

module "permitting_data_product_mvp" {
  source = "./data-product"

  name              = "permitting"
  environment       = "kane"
  source_bucket_id  = module.retro_fit_bucket.id
  source_bucket_key = aws_s3_object.raw.key
}

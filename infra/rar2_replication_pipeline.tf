resource "aws_s3_object" "permitting" {
  bucket = module.data_hub_bucket.s3_bucket_id
  key = "permitting/"
}

resource "aws_s3_object" "source_systems" {
  bucket = module.data_hub_bucket.s3_bucket_id
  key = "${aws_s3_object.permitting.key}source_systems/"
}

resource "aws_s3_object" "rar2" {
  bucket = module.data_hub_bucket.s3_bucket_id
  key = "${aws_s3_object.source_systems.key}rar2/"
}

resource "aws_s3_object" "rar2_raw" {
  bucket = module.data_hub_bucket.s3_bucket_id
  key = "${aws_s3_object.rar2.key}raw/"
}

resource "aws_s3_object" "rar2_delivery" {
  bucket = module.data_hub_bucket.s3_bucket_id
  key = "${aws_s3_object.rar2.key}delivery/"
}

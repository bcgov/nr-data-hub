resource "aws_glue_catalog_database" "permitting" {
  name        = local.environment_fs
  description = "Permitting data catalog."
}

resource "aws_glue_catalog_table" "permitting_vfcbc" {
  name          = "vfcbc"
  database_name = aws_glue_catalog_database.permitting.name

  storage_descriptor {
    location      = "s3://${module.bucket.s3_bucket_id}/${aws_s3_object.data_lake.key}vfcbc"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "default-csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "serialization.format" = 1
        "separatorChar"        = ","
      }
    }

    columns {
      name    = "trackingnumber"
      type    = "string"
      comment = "Unique ID for a project."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "status"
      type    = "string"
      comment = "Status of the project."
      parameters = {
        required = "true"
      }
    }
  }
}

resource "aws_glue_catalog_table" "permitting_tantalis" {
  name          = "tantalis"
  database_name = aws_glue_catalog_database.permitting.name

  storage_descriptor {
    location      = "s3://${module.bucket.s3_bucket_id}/${aws_s3_object.data_lake.key}tantalis"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "default-csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "serialization.format" = 1
        "separatorChar"        = ","
      }
    }

    columns {
      name    = "trackingnumber"
      type    = "string"
      comment = "Unique ID for a project."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "landsfilenumber"
      type    = "string"
      comment = "Unique ID for the Tantalis permit."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "status"
      type    = "string"
      comment = "Status of the permit."
      parameters = {
        required = "true"
      }
    }
  }
}

resource "aws_glue_catalog_table" "permitting_ats" {
  name          = "ats"
  database_name = aws_glue_catalog_database.permitting.name

  storage_descriptor {
    location      = "s3://${module.bucket.s3_bucket_id}/${aws_s3_object.data_lake.key}ats"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "default-csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "serialization.format" = 1
        "separatorChar"        = ","
      }
    }

    columns {
      name    = "trackingnumber"
      type    = "string"
      comment = "Unique ID for a project."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "atsauthorizationnumber"
      type    = "string"
      comment = "Unique ID for the ATS permit."
      parameters = {
        required = "true"
      }
    }

    columns {
      name    = "status"
      type    = "string"
      comment = "Status of the permit."
      parameters = {
        required = "true"
      }
    }
  }
}

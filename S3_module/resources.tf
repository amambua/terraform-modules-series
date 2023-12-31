# AWS KMS Key for server-side encryption and S3 bucket for tesla
resource "aws_kms_key" "tesla_key" {
  description             = "Key used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "tesla_bucket" {
  bucket = "bootcamp32-${lower(var.aws_s3_bucket)}-${random_integer.tesla_bucket.result}" # Replace with your desired bucket name



  tags = {
    Name        = "MyS3Bucket"
    Environment = "Production"
  }
}

# Server-side encryption configuration for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.tesla_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tesla_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "random_integer" "tesla_bucket" {
  min = 1
  max = 500

  keepers = {
    # Generate a new integer each time we switch to a new Environment
    Environment = var.aws_s3_bucket
  }
}

resource "aws_s3_bucket_versioning" "versioning_tesla_bucket" {
  bucket = aws_s3_bucket.tesla_bucket.bucket

  versioning_configuration {
    status = var.bucket_versioning
  }
}


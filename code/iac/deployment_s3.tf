resource "aws_s3_bucket" "data" {
  # bucket allows public
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-data"
  force_destroy = true  
}

resource "aws_s3_object" "data_object" {
  bucket = aws_s3_bucket.data.id
  key    = "customer-master.xlsx"
  source = "resources/customer-master.xlsx"  
}
resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket" "financials" {
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-financials"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "financials" {
  bucket = aws_s3_bucket.financials.id
  acl    = "private"
}

resource "aws_s3_bucket" "operations" {
  # bucket is not encrypted
  # bucket does not have access logs
  bucket = "${local.resource_prefix.value}-operations"
  force_destroy = true  
}

resource "aws_s3_bucket_acl" "operations" {
  bucket = aws_s3_bucket.operations.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_operations" {
  bucket = aws_s3_bucket.operations.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "data_science" {
  # bucket is not encrypted
  bucket = "${local.resource_prefix.value}-data-science"
  force_destroy = true  
}

resource "aws_s3_bucket_acl" "data_science" {
  bucket = aws_s3_bucket.data_science.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_data_science" {
  bucket = aws_s3_bucket.data_science.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "data_science" {
  bucket = aws_s3_bucket.data_science.id

  target_bucket = "${aws_s3_bucket.logs.id}"
  target_prefix = "log/"
}

resource "aws_s3_bucket" "logs" {
  bucket = "${local.resource_prefix.value}-logs"
  force_destroy = true  
}

resource "aws_s3_bucket_acl" "logs" {
  bucket = aws_s3_bucket.logs.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "${aws_kms_key.logs_key.arn}"
      sse_algorithm     = "aws:kms"
    }
  }
}
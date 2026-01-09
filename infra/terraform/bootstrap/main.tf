data "aws_caller_identity" "current" {}

locals {
  project     = "cicd-2-aws-python-django"
  account_id  = data.aws_caller_identity.current.account_id
  region      = "us-east-1"

  tf_bucket   = "${local.project}-tfstate-${local.account_id}"
  tf_lock_tbl = "${local.project}-tflock"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = local.tf_bucket
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "lock" {
  name         = local.tf_lock_tbl
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "tf_bucket"     { value = aws_s3_bucket.tfstate.bucket }
output "tf_lock_table" { value = aws_dynamodb_table.lock.name }
output "region"        { value = local.region }

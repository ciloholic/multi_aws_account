##################################################
# tfstate用バケット
##################################################
resource "aws_s3_bucket" "tfstate_me8aelie" {
  bucket        = "tfstate-me8aelie"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_ownership_controls" "tfstate_me8aelie" {
  bucket = aws_s3_bucket.tfstate_me8aelie.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_me8aelie" {
  bucket = aws_s3_bucket.tfstate_me8aelie.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##################################################
# tfstate用バケット
##################################################
resource "aws_s3_bucket" "tfstate_chiehia3" {
  bucket        = "tfstate-chiehia3"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_ownership_controls" "tfstate_chiehia3" {
  bucket = aws_s3_bucket.tfstate_chiehia3.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_chiehia3" {
  bucket = aws_s3_bucket.tfstate_chiehia3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

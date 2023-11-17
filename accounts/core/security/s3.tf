##################################################
# tfstate用バケット
##################################################
resource "aws_s3_bucket" "tfstate_vue7roht" {
  bucket        = "tfstate-vue7roht"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_ownership_controls" "tfstate_vue7roht" {
  bucket = aws_s3_bucket.tfstate_vue7roht.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_vue7roht" {
  bucket = aws_s3_bucket.tfstate_vue7roht.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##################################################
# Config用バケット
##################################################
resource "aws_s3_bucket" "aws_config" {
  bucket = "aws-config-vai4yaet"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aws_config" {
  bucket = aws_s3_bucket.aws_config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "aws_config" {
  bucket = aws_s3_bucket.aws_config.id
  policy = data.aws_iam_policy_document.aws_config.json
}

# https://docs.aws.amazon.com/config/latest/developerguide/s3-bucket-policy.html
data "aws_iam_policy_document" "aws_config" {
  version = "2012-10-17"
  dynamic "statement" {
    for_each = module.aws_accounts.all
    content {
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["config.amazonaws.com"]
      }
      actions = [
        "s3:GetBucketAcl",
        "s3:ListBucket",
      ]
      resources = [aws_s3_bucket.aws_config.arn]
      # https://blog.serverworks.co.jp/config-puts3-retry
      condition {
        test     = "StringEquals"
        variable = "AWS:SourceAccount"
        values   = [statement.value]
      }
    }
  }
  dynamic "statement" {
    for_each = module.aws_accounts.all
    content {
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["config.amazonaws.com"]
      }
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.aws_config.arn}/*"]
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }
      condition {
        test     = "StringEquals"
        variable = "AWS:SourceAccount"
        values   = [statement.value]
      }
    }
  }
}

##################################################
# CloudTrail用バケット
##################################################
resource "aws_s3_bucket" "aws_cloudtrail" {
  bucket = "aws-cloudtrail-xu1doish"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aws_cloudtrail" {
  bucket = aws_s3_bucket.aws_cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.default.id
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = false
  }
}

resource "aws_s3_bucket_policy" "aws_cloudtrail" {
  bucket = aws_s3_bucket.aws_cloudtrail.id
  policy = data.aws_iam_policy_document.aws_cloudtrail.json
}

# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
data "aws_iam_policy_document" "aws_cloudtrail" {
  version = "2012-10-17"
  dynamic "statement" {
    for_each = module.aws_accounts.all
    content {
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }
      actions   = ["s3:GetBucketAcl"]
      resources = [aws_s3_bucket.aws_cloudtrail.arn]
      condition {
        test     = "StringLike"
        variable = "aws:SourceArn"
        values   = ["arn:aws:cloudtrail:*:${statement.value}:trail/*"]
      }
    }
  }
  dynamic "statement" {
    for_each = module.aws_accounts.all
    content {
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["cloudtrail.amazonaws.com"]
      }
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.aws_cloudtrail.arn}/*"]
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }
      condition {
        test     = "StringLike"
        variable = "aws:SourceArn"
        values   = ["arn:aws:cloudtrail:*:${statement.value}:trail/*"]
      }
    }
  }
}

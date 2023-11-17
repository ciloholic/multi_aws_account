resource "aws_kms_key" "default" {
  multi_region = true
}

resource "aws_kms_key_policy" "default" {
  key_id = aws_kms_key.default.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = [format("arn:aws:iam::%s:root", module.aws_accounts.security)]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [for aws_account_id in module.aws_accounts.all : "arn:aws:cloudtrail:*:${aws_account_id}:trail/*"]
    }
  }
}

resource "aws_kms_alias" "default" {
  name          = "alias/default"
  target_key_id = aws_kms_key.default.key_id
}

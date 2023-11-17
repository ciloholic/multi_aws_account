##################################################
# IAMパスワードポリシー
##################################################
resource "aws_iam_account_password_policy" "setting" {
  minimum_password_length        = 16
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

##################################################
# 管理者権限
##################################################
resource "aws_iam_role" "management_admin" {
  name               = "management-admin"
  assume_role_policy = data.aws_iam_policy_document.management_admin.json
}

data "aws_iam_policy_document" "management_admin" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [module.aws_accounts.jump]
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "management_admin" {
  role       = aws_iam_role.management_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

##################################################
# AWS Config Recorder
##################################################
resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
}

##################################################
# AWS CloudTrail
##################################################
resource "aws_iam_service_linked_role" "cloudtrail" {
  aws_service_name = "cloudtrail.amazonaws.com"
}

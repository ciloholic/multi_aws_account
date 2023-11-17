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
resource "aws_iam_role" "security_admin" {
  name               = "security-admin"
  assume_role_policy = data.aws_iam_policy_document.security_admin.json
}

data "aws_iam_policy_document" "security_admin" {
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

resource "aws_iam_role_policy_attachment" "security_admin" {
  role       = aws_iam_role.security_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

##################################################
# AWS Config Aggregator
##################################################
resource "aws_iam_role" "config_aggregator" {
  name               = "config-aggregator"
  assume_role_policy = data.aws_iam_policy_document.config_aggregator.json
}

data "aws_iam_policy_document" "config_aggregator" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "config_aggregator" {
  role       = aws_iam_role.config_aggregator.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}

##################################################
# AWS Config Recorder
##################################################
resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
}

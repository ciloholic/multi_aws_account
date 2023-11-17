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

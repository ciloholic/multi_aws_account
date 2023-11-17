##################################################
# AWS Security Hub
##################################################
resource "aws_securityhub_account" "securityhub" {
  enable_default_standards = false
  auto_enable_controls     = true
}

resource "aws_securityhub_finding_aggregator" "finding_aggregator" {
  depends_on = [aws_securityhub_account.securityhub]

  linking_mode = "ALL_REGIONS"
}

resource "aws_securityhub_standards_subscription" "cis_aws_foundations_benchmark" {
  depends_on = [aws_securityhub_account.securityhub]

  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

# ルールの無効化
# aws-vault exec security -- aws securityhub get-enabled-standards
# aws-vault exec security -- aws securityhub describe-standards-controls --standards-subscription-arn 'arn:aws:securityhub:ap-northeast-1:***:subscription/aws-foundational-security-best-practices/v/1.0.0' --query "Controls[*].StandardsControlArn" --output yaml
# aws-vault exec security -- aws securityhub describe-standards-controls --standards-subscription-arn 'arn:aws:securityhub:ap-northeast-1:***:subscription/cis-aws-foundations-benchmark/v/1.2.0' --query "Controls[*].StandardsControlArn" --output yaml
# 無効化したルールの確認
# aws-vault exec security -- aws securityhub describe-standards-controls --standards-subscription-arn "arn:aws:securityhub:ap-northeast-1:***:subscription/aws-foundational-security-best-practices/v/1.0.0" --query 'Controls[?ControlStatus==`DISABLED`]'
# aws-vault exec security -- aws securityhub describe-standards-controls --standards-subscription-arn "arn:aws:securityhub:ap-northeast-1:***:subscription/cis-aws-foundations-benchmark/v/1.2.0" --query 'Controls[?ControlStatus==`DISABLED`]'
resource "aws_securityhub_standards_control" "ensure_iam_password_policy_prevents_password_reuse" {
  depends_on = [aws_securityhub_standards_subscription.cis_aws_foundations_benchmark]

  standards_control_arn = "arn:aws:securityhub:ap-northeast-1:${module.aws_accounts.security}:control/cis-aws-foundations-benchmark/v/1.2.0/1.14"
  control_status        = "DISABLED"
  disabled_reason       = "仮想MFAを利用している為、無効化"
}

##################################################
# AWS Security Hub(バージニア北部リージョン)
##################################################
resource "aws_securityhub_account" "securityhub_us_east_1" {
  provider                 = aws.us_east_1
  enable_default_standards = false
  auto_enable_controls     = true
}

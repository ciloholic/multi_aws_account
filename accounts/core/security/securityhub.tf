##################################################
# AWS SecurityHub(東京リージョン)
##################################################
resource "aws_securityhub_account" "securityhub" {
  auto_enable_controls     = true
  enable_default_standards = false
}

resource "aws_securityhub_organization_configuration" "securityhub" {
  auto_enable           = true
  auto_enable_standards = "NONE"
}

resource "aws_securityhub_finding_aggregator" "finding_aggregator" {
  depends_on = [aws_securityhub_account.securityhub]

  linking_mode = "ALL_REGIONS"
}

# AWS Organizationsに所属するAWSアカウントのSecurityHubの有効化がTerraformで出来ないので、CLIで対応
# aws-vault exec security -- aws securityhub create-members --account-details '[{"AccountId":"<accountId>"}]'

##################################################
# AWS Security Hub(バージニア北部リージョン)
##################################################
resource "aws_securityhub_account" "securityhub_us_east_1" {
  provider = aws.us_east_1

  auto_enable_controls     = true
  enable_default_standards = false
}

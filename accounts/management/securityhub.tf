##################################################
# AWS SecurityHubの委任(東京リージョン)
##################################################
resource "aws_securityhub_organization_admin_account" "securityhub" {
  admin_account_id = module.aws_accounts.security
}

##################################################
# AWS SecurityHub(東京リージョン)
##################################################
resource "aws_securityhub_account" "securityhub" {
  auto_enable_controls     = true
  enable_default_standards = false
}

##################################################
# AWS SecurityHubの委任(バージニア北部リージョン)
##################################################
resource "aws_securityhub_organization_admin_account" "securityhub_us_east_1" {
  provider = aws.us_east_1

  admin_account_id = module.aws_accounts.security
}

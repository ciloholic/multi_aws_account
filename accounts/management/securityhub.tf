resource "aws_securityhub_organization_admin_account" "admin" {
  admin_account_id = module.aws_accounts.security
}

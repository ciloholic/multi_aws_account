resource "aws_guardduty_organization_admin_account" "admin" {
  admin_account_id = module.aws_accounts.security
}

##################################################
# AWS GuardDuty Detector
##################################################
resource "aws_guardduty_detector" "guardduty_detector" {
  enable                       = true
  finding_publishing_frequency = "SIX_HOURS"
}

##################################################
# AWS GuardDuty Detector(バージニア北部リージョン)
##################################################
resource "aws_guardduty_detector" "guardduty_detector_us_east_1" {
  provider                     = aws.us_east_1
  enable                       = true
  finding_publishing_frequency = "SIX_HOURS"
}

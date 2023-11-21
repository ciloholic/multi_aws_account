##################################################
# AWS GuardDuty Detector(東京リージョン)
##################################################
resource "aws_guardduty_detector" "guardduty_detector" {
  enable = true
}

##################################################
# AWS GuardDuty Detector(バージニア北部リージョン)
##################################################
resource "aws_guardduty_detector" "guardduty_detector_us_east_1" {
  provider = aws.us_east_1

  enable = true
}

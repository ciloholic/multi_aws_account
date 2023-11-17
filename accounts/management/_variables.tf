data "aws_s3_bucket" "aws_config" {
  provider = aws.security
  bucket   = "aws-config-vai4yaet"
}

data "aws_s3_bucket" "aws_cloudtrail" {
  provider = aws.security
  bucket   = "aws-cloudtrail-xu1doish"
}

data "aws_kms_key" "default" {
  provider = aws.security
  key_id   = "alias/default"
}

module "aws_accounts" {
  source = "../../modules/data_aws_accounts"
}

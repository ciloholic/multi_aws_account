# AWS CloudTrailの委任がTerraformで出来ないので、CLIで対応
# https://github.com/hashicorp/terraform-provider-aws/issues/29179
# aws-vault exec management -- aws organizations register-delegated-administrator --account-id 222222222222 --service-principal cloudtrail.amazonaws.com

resource "aws_cloudtrail" "cloudtrail" {
  name           = "cloudtrail"
  s3_bucket_name = data.aws_s3_bucket.aws_cloudtrail.id
  kms_key_id     = data.aws_kms_key.default.arn

  is_organization_trail = true
  is_multi_region_trail = true

  enable_logging             = true
  enable_log_file_validation = true

  include_global_service_events = true
}

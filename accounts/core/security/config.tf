##################################################
# AWS Config Aggregator
##################################################
resource "aws_config_configuration_aggregator" "config_aggregator" {
  name = "config-aggregator"

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.config_aggregator.arn
  }
}

##################################################
# AWS Config Recorder
##################################################
resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config-recorder"
  role_arn = aws_iam_service_linked_role.config.arn

  recording_group {
    all_supported                 = "true"
    include_global_resource_types = "true" # 東京リージョンのみ有効
  }
}

resource "aws_config_delivery_channel" "default" {
  depends_on = [aws_config_configuration_recorder.config_recorder]

  name           = "default"
  s3_bucket_name = aws_s3_bucket.aws_config.id
}

resource "aws_config_configuration_recorder_status" "default" {
  depends_on = [aws_config_delivery_channel.default]

  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
}

# resource "aws_config_organization_managed_rule" "s3_bucket_server_side_encryption_enabled" {
#   name            = "s3-bucket-server-side-encryption-enabled"
#   rule_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
# }

# resource "aws_config_organization_managed_rule" "guardduty_enabled_centralized" {
#   name            = "guardduty-enabled-centralized"
#   rule_identifier = "GUARDDUTY_ENABLED_CENTRALIZED"
# }

##################################################
# AWS Config Recorder(バージニア北部リージョン)
##################################################
resource "aws_config_configuration_recorder" "config_recorder_us_east_1" {
  provider = aws.us_east_1

  name     = "config-recorder"
  role_arn = aws_iam_service_linked_role.config.arn

  recording_group {
    all_supported                 = "true"
    include_global_resource_types = "false"
  }
}

resource "aws_config_delivery_channel" "default_us_east_1" {
  provider   = aws.us_east_1
  depends_on = [aws_config_configuration_recorder.config_recorder_us_east_1]

  name           = "default"
  s3_bucket_name = aws_s3_bucket.aws_config.id
}

resource "aws_config_configuration_recorder_status" "default_us_east_1" {
  provider   = aws.us_east_1
  depends_on = [aws_config_delivery_channel.default_us_east_1]

  name       = aws_config_configuration_recorder.config_recorder_us_east_1.name
  is_enabled = true
}

# resource "aws_config_organization_managed_rule" "s3_bucket_server_side_encryption_enabled_us_east_1" {
#   provider = aws.us_east_1

#   name            = "s3-bucket-server-side-encryption-enabled"
#   rule_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
# }

# resource "aws_config_organization_managed_rule" "guardduty_enabled_centralized_us_east_1" {
#   provider = aws.us_east_1

#   name            = "guardduty-enabled-centralized"
#   rule_identifier = "GUARDDUTY_ENABLED_CENTRALIZED"
# }

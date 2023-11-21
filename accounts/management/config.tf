# AWS Confignの委任がTerraformで出来ないので、CLIで対応
# aws-vault exec management -- aws organizations register-delegated-administrator --account-id 222222222222 --service-principal config.amazonaws.com
# aws-vault exec management -- aws organizations register-delegated-administrator --account-id 222222222222 --service-principal config-multiaccountsetup.amazonaws.com
# aws-vault exec management -- aws organizations list-delegated-services-for-account --account-id 222222222222 --output text | grep config

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
  s3_bucket_name = data.aws_s3_bucket.aws_config.id
}

resource "aws_config_configuration_recorder_status" "default" {
  depends_on = [aws_config_delivery_channel.default]

  name       = aws_config_configuration_recorder.config_recorder.name
  is_enabled = true
}

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
  s3_bucket_name = data.aws_s3_bucket.aws_config.id
}

resource "aws_config_configuration_recorder_status" "default_us_east_1" {
  provider   = aws.us_east_1
  depends_on = [aws_config_delivery_channel.default_us_east_1]

  name       = aws_config_configuration_recorder.config_recorder_us_east_1.name
  is_enabled = true
}

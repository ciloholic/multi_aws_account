data "aws_s3_bucket" "aws_config" {
  provider = aws.security
  bucket   = "aws-config-vai4yaet"
}

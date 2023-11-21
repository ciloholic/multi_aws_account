resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config-multiaccountsetup.amazonaws.com",
    "config.amazonaws.com",
    "guardduty.amazonaws.com",
    "inspector2.amazonaws.com",
    "securityhub.amazonaws.com",
  ]
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]
  feature_set          = "ALL"
}

# Core
resource "aws_organizations_organizational_unit" "core" {
  name      = "Core"
  parent_id = aws_organizations_organization.org.roots[0].id
}

# Workloads
resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.org.roots[0].id
}

# Core > Security
resource "aws_organizations_account" "security" {
  name              = "Security"
  email             = "test+security@example.co.jp"
  parent_id         = aws_organizations_organizational_unit.core.id
  close_on_deletion = true
}

# Core > Jump
resource "aws_organizations_account" "jump" {
  name              = "Jump"
  email             = "test+jump@example.co.jp"
  parent_id         = aws_organizations_organizational_unit.core.id
  close_on_deletion = true
}

# Workloads > Production
# resource "aws_organizations_account" "production" {
#   name              = "Production"
#   email             = "test+production@example.co.jp"
#   parent_id         = aws_organizations_organizational_unit.workloads.id
#   close_on_deletion = true
# }

##################################################
# 特定リージョン以外のアクションを制限する
##################################################
resource "aws_organizations_policy" "region_restriction" {
  name    = "region-restriction"
  content = data.aws_iam_policy_document.region_restriction.json
}

resource "aws_organizations_policy" "core_region_restriction" {
  name    = "core-region-restriction"
  content = data.aws_iam_policy_document.region_restriction.json
}

# resource "aws_organizations_policy" "workloads_region_restriction" {
#   name    = "workloads-region-restriction"
#   content = data.aws_iam_policy_document.region_restriction.json
# }

# https://docs.aws.amazon.com/ja_jp/organizations/latest/userguide/orgs_manage_policies_scps_examples_general.html
data "aws_iam_policy_document" "region_restriction" {
  statement {
    effect = "Deny"
    not_actions = [
      "a4b:*",
      "acm:*",
      "aws-marketplace-management:*",
      "aws-marketplace:*",
      "aws-portal:*",
      "budgets:*",
      "ce:*",
      "chime:*",
      "cloudfront:*",
      "config:*",
      "cur:*",
      "directconnect:*",
      "ec2:DescribeRegions",
      "ec2:DescribeTransitGateways",
      "ec2:DescribeVpnGateways",
      "fms:*",
      "globalaccelerator:*",
      "health:*",
      "iam:*",
      "importexport:*",
      "kms:*",
      "mobileanalytics:*",
      "networkmanager:*",
      "organizations:*",
      "pricing:*",
      "route53:*",
      "route53domains:*",
      "route53-recovery-cluster:*",
      "route53-recovery-control-config:*",
      "route53-recovery-readiness:*",
      "s3:GetAccountPublic*",
      "s3:ListAllMyBuckets",
      "s3:ListMultiRegionAccessPoints",
      "s3:PutAccountPublic*",
      "shield:*",
      "sts:*",
      "support:*",
      "trustedadvisor:*",
      "waf-regional:*",
      "waf:*",
      "wafv2:*",
      "wellarchitected:*",
      # AWS Chatbotを利用する為、`us-east-2`のみを許可する
      # https://docs.aws.amazon.com/ja_jp/chatbot/latest/adminguide/chatbot-troubleshooting.html#chatbot-troubleshooting-regions
      "chatbot:*",
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values = [
        "ap-northeast-1",
        "us-east-1",
        "us-east-2",
      ]
    }
  }
  # AWS CloudTrailの無効化、または設定の変更を禁止する
  statement {
    effect = "Deny"
    actions = [
      "cloudtrail:DeleteTrail",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail",
    ]
    resources = ["*"]
  }
}

resource "aws_organizations_policy_attachment" "core_region_restriction" {
  target_id = aws_organizations_organizational_unit.core.id
  policy_id = aws_organizations_policy.region_restriction.id
}

resource "aws_organizations_policy_attachment" "workloads_region_restriction" {
  target_id = aws_organizations_organizational_unit.workloads.id
  policy_id = aws_organizations_policy.region_restriction.id
}

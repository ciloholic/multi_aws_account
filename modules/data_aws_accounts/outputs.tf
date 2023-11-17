output "all" {
  description = "全てのAWSアカウント"
  value       = local.aws_account_ids
}

output "management" {
  description = "management用AWSアカウント"
  value       = local.aws_account_ids["management"]
}

output "security" {
  description = "security用AWSアカウント"
  value       = local.aws_account_ids["security"]
}

output "jump" {
  description = "jump用AWSアカウント"
  value       = local.aws_account_ids["jump"]
}

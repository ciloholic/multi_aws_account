plugin "terraform" {
  enabled = true
  version = "0.4.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "aws" {
  enabled = true
  version = "0.24.3"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

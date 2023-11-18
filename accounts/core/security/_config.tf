terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    bucket  = "tfstate-vue7roht"
    key     = "accounts/core/security/terraform.tfstate"
    profile = "security"
  }

  required_version = "1.6.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

# 東京リージョン
provider "aws" {
  region  = "ap-northeast-1"
  profile = "security"
}

# バージニア北部リージョン
provider "aws" {
  region  = "us-east-1"
  profile = "security"
  alias   = "us_east_1"
}

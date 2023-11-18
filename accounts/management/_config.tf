terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    bucket  = "tfstate-me8aelie"
    key     = "accounts/management/terraform.tfstate"
    profile = "management"
  }

  required_version = "1.6.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "security"
  alias   = "security"
}

# 東京リージョン
provider "aws" {
  region  = "ap-northeast-1"
  profile = "management"
}

# バージニア北部リージョン
provider "aws" {
  region  = "us-east-1"
  profile = "management"
  alias   = "us_east_1"
}

terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    bucket  = "tfstate-chiehia3"
    key     = "accounts/core/jump/terraform.tfstate"
    profile = "jump"
  }

  required_version = "1.5.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
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
  profile = "jump"
}

# バージニア北部リージョン
provider "aws" {
  region  = "us-east-1"
  profile = "jump"
  alias   = "us_east_1"
}

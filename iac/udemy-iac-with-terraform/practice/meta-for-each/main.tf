terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

provider "aws" {
  profile = "kzmshx_aws_test-terraform"
  region  = "ap-northeast-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/20"
}

resource "aws_subnet" "subnet" {
  for_each = {
    "192.168.1.0/24" = "ap-northeast-1a"
    "192.168.2.0/24" = "ap-northeast-1c"
    "192.168.3.0/24" = "ap-northeast-1d"
  }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.key
  availability_zone = each.value
}

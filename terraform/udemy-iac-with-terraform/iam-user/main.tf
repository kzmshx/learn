# ------------------------------
# Terraform configuration
# ------------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "tastylog-tfstate-bucket-kzmshx"
    key     = "tastylog-user.tfstate"
    region  = "ap-northeast-1"
    profile = "kzmshx_aws_test-terraform"
  }
}

# ------------------------------
# Provider
# ------------------------------
provider "aws" {
  profile = "kzmshx_aws_test-terraform"
  region  = "ap-northeast-1"
}

# ------------------------------
# Variables
# ------------------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain" {
  type = string
}

variable "user_name" {
  type = string
}

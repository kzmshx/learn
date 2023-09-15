# ------------------------------
# Terraform configuration
# ------------------------------
terraform {
  required_version = ">= 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "tastylog-tfstate-bucket-kzmshx"
    key     = "tastylog-dev.tfstate"
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

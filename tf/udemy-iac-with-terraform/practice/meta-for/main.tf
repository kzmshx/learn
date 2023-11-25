# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = "kzmshx_aws_test-terraform"
  region  = "ap-northeast-1"
}

# ---------------------------------------------
# Variables
# ---------------------------------------------
variable "obj" {
  type = object({
    name = string
    age  = number
  })
  default = {
    name = "tanaka"
    age  = 28
  }
}

variable "tuple" {
  type = tuple([
    string, number
  ])
  default = tuple(["tanaka", 28])
}

variable "list" {
  type    = list(string)
  default = ["tanaka", "sato"]
}

variable "map" {
  type = map(string)
  default = {
    "High" = "m5.2xlarge"
    "Mid"  = "m5.large"
    "Low"  = "t2.micro"
  }
}

variable "set" {
  type = set(string)
  default = [
    "tanaka",
    "sato",
    "tanaka",
    "sato"
  ]
}

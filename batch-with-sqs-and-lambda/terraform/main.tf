# ------------------------------
# Terraform Configuration
# ------------------------------
terraform {
  required_version = "~> 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.19.0"
    }
  }

  backend "s3" {}
}

# ------------------------------
# Provider Configuration
# ------------------------------
provider "aws" {
  region = var.region
}

# ------------------------------
# Locals
# ------------------------------
locals {
  project = "batch-with-sqs-and-lambda"
}

# ------------------------------
# S3 Bucket
# ------------------------------
# Input bucket
resource "aws_s3_bucket" "input" {
  bucket = "${local.project}-input-bucket"

  tags = {
    Name    = "${local.project}-input-bucket"
    Project = local.project
  }
}

resource "aws_s3_bucket_ownership_controls" "input" {
  bucket = aws_s3_bucket.input.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "input" {
  bucket = aws_s3_bucket.input.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.input]
}

# Output bucket
resource "aws_s3_bucket" "output" {
  bucket = "${local.project}-output-bucket"

  tags = {
    Name    = "${local.project}-output-bucket"
    Project = local.project
  }
}

resource "aws_s3_bucket_ownership_controls" "output" {
  bucket = aws_s3_bucket.output.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "output" {
  bucket = aws_s3_bucket.output.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.output]
}

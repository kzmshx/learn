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
# Caller Identity
# ------------------------------
data "aws_caller_identity" "this" {}

# ------------------------------
# IAM Role
# ------------------------------
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.project}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_execution_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.input.arn}/*",
      "${aws_s3_bucket.output.arn}/*",
    ]
  }

  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]
    resources = [
      aws_sqs_queue.queue.arn,
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda" {
  name   = "${local.project}-lambda"
  policy = data.aws_iam_policy_document.lambda_execution_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
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

# ------------------------------
# SQS Queue
# ------------------------------
resource "aws_sqs_queue" "queue" {
  visibility_timeout_seconds = 300
  message_retention_seconds  = 345600
  delay_seconds              = 0

  tags = {
    Name    = "${local.project}-queue"
    Project = local.project
  }
}

# ------------------------------
# Lambda Function
# ------------------------------
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0.0"

  function_name = "${local.project}-lambda"
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  source_path = {
    path = "../lambda"
  }

  environment_variables = {
    INPUT_BUCKET  = aws_s3_bucket.input.bucket
    OUTPUT_BUCKET = aws_s3_bucket.output.bucket
    SQS_QUEUE_URL = aws_sqs_queue.queue.url
  }

  create_role = false
  lambda_role = aws_iam_role.lambda.arn

  tags = {
    Name    = "${local.project}-lambda"
    Project = local.project
  }
}

resource "aws_lambda_event_source_mapping" "sqs_event_source_mapping" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = module.lambda_function.lambda_function_name
  batch_size       = 1
}

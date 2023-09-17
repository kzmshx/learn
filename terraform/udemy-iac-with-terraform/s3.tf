resource "random_string" "s3_unique_key" {
  length  = 16
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# ------------------------------
# S3 Static Bucket
# ------------------------------
resource "aws_s3_bucket" "s3_static_bucket" {
  bucket = "${var.project}-${var.environment}-static-bucket-${random_string.s3_unique_key.result}"
}

resource "aws_s3_bucket_versioning" "s3_static_bucket" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_static_bucket" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_static_bucket" {
  bucket                  = aws_s3_bucket.s3_static_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_static_bucket.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_static_bucket" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  policy = data.aws_iam_policy_document.allow_public_access.json

  depends_on = [
    aws_s3_bucket_public_access_block.s3_static_bucket
  ]
}

# ------------------------------
# S3 Deploy Bucket
# ------------------------------
resource "aws_s3_bucket" "s3_deploy_bucket" {
  bucket = "${var.project}-${var.environment}-deploy-bucket-${random_string.s3_unique_key.result}"
}

resource "aws_s3_bucket_versioning" "s3_deploy_bucket" {
  bucket = aws_s3_bucket.s3_deploy_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_deploy_bucket" {
  bucket = aws_s3_bucket.s3_deploy_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_deploy_bucket" {
  bucket                  = aws_s3_bucket.s3_deploy_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "allow_app_role_access" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_deploy_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.app_iam_role.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_deploy_bucket" {
  bucket = aws_s3_bucket.s3_deploy_bucket.id
  policy = data.aws_iam_policy_document.allow_app_role_access.json

  depends_on = [
    aws_s3_bucket_public_access_block.s3_deploy_bucket
  ]
}

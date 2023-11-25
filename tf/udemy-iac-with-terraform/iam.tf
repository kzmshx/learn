# ------------------------------
# IAM Policy Document
# ------------------------------
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ------------------------------
# IAM Role
# ------------------------------
resource "aws_iam_role" "app_iam_role" {
  name               = "${var.project}-${var.environment}-app-iam-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "app_iam_instance_profile" {
  name = aws_iam_role.app_iam_role.name
  role = aws_iam_role.app_iam_role.name
}

resource "aws_iam_policy_attachment" "app_iam_role_ec2_readonly" {
  name       = "${var.project}-${var.environment}-app-iam-role-ec2-read-only"
  roles      = [aws_iam_role.app_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "app_iam_role_ssm_managed" {
  name       = "${var.project}-${var.environment}-app-iam-role-ssm-managed"
  roles      = [aws_iam_role.app_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "app_iam_role_ssm_readonly" {
  name       = "${var.project}-${var.environment}-app-iam-role-ssm-read-only"
  roles      = [aws_iam_role.app_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "app_iam_role_s3_readonly" {
  name       = "${var.project}-${var.environment}-app-iam-role-s3-read-only"
  roles      = [aws_iam_role.app_iam_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

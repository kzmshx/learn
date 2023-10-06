output "input_bucket_name" {
  value = aws_s3_bucket.input.bucket_domain_name
}

output "output_bucket_name" {
  value = aws_s3_bucket.output.bucket_domain_name
}

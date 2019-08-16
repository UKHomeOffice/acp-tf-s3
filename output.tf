output "s3_bucket_id" {
  description = "The S3 bucket ID we just created"
  value       = aws_s3_bucket.s3_bucket.id
}

output "s3_bucket_arn" {
  description = "The S3 bucket ARN we just created"
  value       = aws_s3_bucket.s3_bucket.arn
}

output "s3_bucket_kms_key" {
  description = "The KMS key ID used for the bucket"
  value       = aws_kms_key.s3_bucket_kms_key.*.key_id
}

output "s3_bucket_kms_key_arn" {
  description = "The KMS key ARN used for the bucket"
  value       = aws_kms_key.s3_bucket_kms_key.*.arn
}


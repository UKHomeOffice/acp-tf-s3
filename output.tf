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
  value       = element(concat(aws_kms_key.s3_bucket_kms_key.*.key_id, [""]), 0)
}

output "s3_bucket_kms_key_arn" {
  description = "The KMS key ARN used for the bucket"
  value       = element(concat(aws_kms_key.s3_bucket_kms_key.*.arn, [""]), 0)
}

output "s3_bucket_whitelist_kms_key" {
  description = "KMS Key ID of the whitelist ip generated bucket"
  value       = element(concat(aws_kms_key.s3_bucket_kms_key_whitelist.*.key_id, [""]), 0)
}

output "s3_bucket_whitelist_arn_kms_key_arn" {
  description = "KMS Key ARN of the whitelist ip generated bucket"
  value       = element(concat(aws_kms_key.s3_bucket_kms_key_whitelist.*.arn, [""]), 0)
}

output "s3_bucket_whitelist_vpc_kms_key" {
  description = "KMS Key ID of the whitelist vpc generated bucket"
  value       = element(concat(aws_kms_key.s3_bucket_kms_key_whitelist_vpc.*.key_id, [""]), 0)
}

output "s3_bucket_whitelist_vpc_arn_kms_key_arn" {
  description = "KMS Key ARN of the whitelist vpc generated bucket"
  value       = element(concat(aws_kms_key.s3_bucket_kms_key_whitelist_vpc.*.arn, [""]), 0)
}

output "s3_bucket_whitelist_ip_and_vpc_kms_key" {
  description = "KMS Key ID of the whitelist ip and vpc generated bucket"
  value       = element(concat(aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.*.key_id, [""]), 0)
}

output "s3_bucket_whitelist_ip_and_vpc_kms_key_arn" {
  description = "KMS Key ARN of the whitelist ip and vpc generated bucket"
  value       = element(concat(aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.*.arn, [""]), 0)
}
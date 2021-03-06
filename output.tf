output "s3_bucket_id" {
  description = "ID of generated S3 bucket"
  value       = element(concat(aws_s3_bucket.s3_bucket.*.id, [""]), 0)
}

output "s3_bucket_arn" {
  description = "ARN of generated S3 bucket"
  value       = element(concat(aws_s3_bucket.s3_bucket.*.arn, [""]), 0)
}

output "s3_bucket_with_logging_id" {
  description = "ID of generated S3 bucket with server access logging enabled"
  value       = element(concat(aws_s3_bucket.s3_bucket_with_logging.*.id, [""]), 0)
}

output "s3_bucket_with_logging_arn" {
  description = "ARN of generated S3 bucket with server access logging enabled"
  value       = element(concat(aws_s3_bucket.s3_bucket_with_logging.*.arn, [""]), 0)
}

output "s3_website_bucket_id" {
  description = "ID of generated S3 bucket with website hosting enabled"
  value       = element(concat(aws_s3_bucket.s3_website_bucket.*.id, [""]), 0)
}

output "s3_website_bucket_arn" {
  description = "ARN of generated S3 bucket with website hosting enabled"
  value       = element(concat(aws_s3_bucket.s3_website_bucket.*.arn, [""]), 0)
}

output "s3_bucket_kms_key" {
  description = "KMS Key ID of the generated bucket"
  value       = element(concat(aws_kms_key.s3_bucket_kms_key.*.key_id, [""]), 0)
}

output "s3_bucket_kms_key_arn" {
  description = "KMS Key ARN of the generated bucket"
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

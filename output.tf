output "s3_bucket_id" {
  description = "ID of generated S3 bucket"
  value       = "${element(concat(aws_s3_bucket.s3_bucket.*.id, list("")), 0)}"
}

output "s3_bucket_arn" {
  description = "ARN of generated S3 bucket"
  value       = "${element(concat(aws_s3_bucket.s3_bucket.*.arn, list("")), 0)}"
}

output "s3_website_bucket_id" {
  description = "ID of generated S3 bucket with website hosting enabled"
  value       = "${element(concat(aws_s3_bucket.s3_website_bucket.*.id, list("")), 0)}"
}

output "s3_website_bucket_arn" {
  description = "ARN of generated S3 bucket with website hosting enabled"
  value       = "${element(concat(aws_s3_bucket.s3_website_bucket.*.arn, list("")), 0)}"
}

output "s3_bucket_kms_key" {
  description = "KMS Key ID of the generated bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key.*.key_id}"
}

output "s3_bucket_kms_key_arn" {
  description = "KMS Key ARN of the generated bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key.*.arn}"
}

output "s3_bucket_whitelist_kms_key" {
  description = "KMS Key ID of the whitelist ip generated bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key_whitelist.*.key_id}"
}

output "s3_bucket_whitelist_arn_kms_key_arn" {
  description = "KMS Key ARN of the whitelist ip generated bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key_whitelist.*.arn}"
}

output "s3_bucket_whitelist_vpc_kms_key" {
  description = "KMS Key ID of the whitelist vpc generated bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key_whitelist_vpc.*.key_id}"
}

output "s3_bucket_whitelist_vpc_arn_kms_key_arn" {
  description = "KMS Key ARN of the whitelist vpc generated bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key_whitelist_vpc.*.arn}"
}

output "s3_bucket_whitelist_ip_and_vpc_kms_key" {
  description = "KMS Key ID of the whitelist ip and vpc generated bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.*.key_id}"
}

output "s3_bucket_whitelist_ip_and_vpc_kms_key_arn" {
  description = "KMS Key ARN of the whitelist ip and vpc generated bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.*.arn}"
}

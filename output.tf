output "s3_bucket_id" {
  description = "The S3 bucket ID we just created"
  value       = "${aws_s3_bucket.s3_bucket.id}"
}

output "s3_bucket_kms_key" {
  description = "The KMS ID used for the bucket"
  value       = "${aws_kms_key.s3_bucket_kms_key.*.key_id}"
}

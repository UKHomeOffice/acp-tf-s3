provider "aws" {
  region = "eu-west-2"
}

locals {
  bucket_prefix = "acp-tf-s3-test-bucket-with-expiration"
  bucket_name   = "${local.bucket_prefix}-eu-west-2"
}

module "bucket_with_logging" {
  source              = "../.."
  block_public_access = true

  name                 = local.bucket_name
  acl                  = "private"
  environment          = "acp-test"
  bucket_iam_user      = "${local.bucket_prefix}-user"
  iam_user_policy_name = "${local.bucket_prefix}-policy"
  tags                 = { Name = local.bucket_name }

  lifecycle_expiration_enabled       = true
  lifecycle_days_to_expiration       = 90
  lifecycle_expiration_object_prefix = "archive/"
  lifecycle_expiration_object_tags = {
    "foo" = "bar"
  }
}

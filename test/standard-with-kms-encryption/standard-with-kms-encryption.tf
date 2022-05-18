provider "aws" {
  region = "eu-west-2"
}

locals {
  bucket_prefix = "acp-tf-s3-test-bucket-standard-with-kms"
  bucket_name   = "${local.bucket_prefix}-eu-west-2"
}
module "standard_bucket" {
  source              = "../.."
  block_public_access = true

  name                 = local.bucket_name
  acl                  = "private"
  environment          = "acp-test"
  kms_alias            = "${local.bucket_prefix}-kms"
  bucket_iam_user      = "${local.bucket_prefix}-user"
  iam_user_policy_name = "${local.bucket_prefix}-policy"
  versioning_enabled   = true
  tags                 = { Name = local.bucket_name }
}
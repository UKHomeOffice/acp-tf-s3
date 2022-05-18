provider "aws" {
  region = "eu-west-2"
}

locals {
  bucket_prefix       = "acp-tf-s3-test-website-with-logging"
  bucket_name         = "${local.bucket_prefix}-eu-west-2"
  audit_bucket_prefix = "acp-tf-s3-test-website-with-logging-audit"
  audit_bucket_name   = "${local.audit_bucket_prefix}-eu-west-2"
}

module "audit_bucket" {
  source              = "../.."
  block_public_access = true

  name                 = local.audit_bucket_name
  acl                  = "log-delivery-write"
  environment          = "acp-test"
  bucket_iam_user      = "${local.audit_bucket_prefix}-user"
  iam_user_policy_name = "${local.audit_bucket_prefix}-policy"
  versioning_enabled   = true
  tags                 = { Name = local.bucket_name }
}

module "website_bucket_with_logging" {
  source              = "../.."
  block_public_access = false

  name                 = local.bucket_name
  acl                  = "public-read"
  environment          = "acp-test"
  bucket_iam_user      = "${local.bucket_prefix}-user"
  iam_user_policy_name = "${local.bucket_prefix}-policy"
  versioning_enabled   = true
  # versioning_enabled   = "true"
  logging_enabled = true
  # logging_enabled      = "true"
  log_target_bucket = local.audit_bucket_name
  website_hosting   = true
  # website_hosting      = "true"
  tags = { Name = local.bucket_name }
}
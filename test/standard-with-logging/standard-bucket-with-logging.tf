provider "aws" {
  region = "eu-west-2"
}

locals {
  bucket_prefix       = "acp-tf-s3-test-bucket-with-logging"
  bucket_name         = "${local.bucket_prefix}-eu-west-2"
  audit_bucket_prefix = "acp-tf-s3-test-bucket-with-logging-audit"
  audit_bucket_name   = "${local.audit_bucket_prefix}-eu-west-2"
}

module "audit_bucket" {
  # source                  = "git::https://github.com/UKHomeOffice/acp-tf-s3?ref=v1.5.1"

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

module "bucket_with_logging" {
  # source                  = "git::https://github.com/UKHomeOffice/acp-tf-s3?ref=v1.5.1"

  source              = "../.."
  block_public_access = true

  name                 = local.bucket_name
  acl                  = "private"
  environment          = "acp-test"
  kms_alias            = "${local.bucket_prefix}-kms"
  bucket_iam_user      = "${local.bucket_prefix}-user"
  iam_user_policy_name = "${local.bucket_prefix}-policy"
  versioning_enabled   = true
  logging_enabled      = true
  log_target_bucket    = local.audit_bucket_name
  tags                 = { Name = local.bucket_name }
}
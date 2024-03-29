provider "aws" {
  region = "eu-west-2"
}

locals {
  bucket_prefix = "acp-tf-s3-test-bucket-website"
  bucket_name   = "${local.bucket_prefix}-eu-west-2"
}
# module "website_bucket" {
module "website_bucket" {
  source              = "../.."
  block_public_access = false

  name                 = local.bucket_name
  acl                  = "public-read"
  environment          = "acp-test"
  bucket_iam_user      = "${local.bucket_prefix}-user"
  iam_user_policy_name = "${local.bucket_prefix}-policy"
  versioning_enabled   = true
  website_hosting      = "true"
  tags                 = { Name = local.bucket_name }
}
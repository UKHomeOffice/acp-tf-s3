provider "aws" {
  version = "= 0.1.4"
}

module "s3-default-kms" {
  source = "/workdir/src/github.com/UKHomeOffice/acp-tf-s3"

  name                 = "testing-kms-${var.drone_build_number}"
  acl                  = "private"
  environment          = "testing"
  kms_alias            = "testingkms-kms-${var.drone_build_number}"
  bucket_iam_user      = "testing-s3-bucket-user-kms-${var.drone_build_number}"
  iam_user_policy_name = "testing-s3-bucket-policy-kms-${var.drone_build_number}"
}

module "s3-default-no-kms" {
  source = "/workdir/src/github.com/UKHomeOffice/acp-tf-s3"

  name                 = "testing-no-kms-${var.drone_build_number}"
  acl                  = "private"
  environment          = "testing"
  bucket_iam_user      = "testing-s3-bucket-user-no-kms-${var.drone_build_number}"
  iam_user_policy_name = "testing-s3-bucket-policy-no-kms-${var.drone_build_number}"
}

module "s3-default-no-kms-whitelisting" {
  source = "/workdir/src/github.com/UKHomeOffice/acp-tf-s3"

  name                 = "testing-no-kms-whitelisting-${var.drone_build_number}"
  acl                  = "private"
  environment          = "testing"
  bucket_iam_user      = "testing-s3-bucket-user-no-kms-${var.drone_build_number}"
  iam_user_policy_name = "testing-s3-bucket-policy-no-kms-${var.drone_build_number}"
  whitelist_ip         = ["10.10.0.0/16"]
}

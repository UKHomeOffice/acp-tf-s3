resource "random_id" "s3-kms-bucket-name" {
  byte_length = 10
}

module "s3-default-kms" {
  source = "../"

  name                 = "testing-${random_id.s3-kms-bucket-name.hex}"
  acl                  = "private"
  environment          = "testing"
  kms_alias            = "testingkms-${random_id.s3-kms-bucket-name.hex}"
  bucket_iam_user      = "testing-s3-bucket-user-${random_id.s3-kms-bucket-name.hex}"
  iam_user_policy_name = "testing-s3-bucket-policy-${random_id.s3-kms-bucket-name.hex}"
}

resource "random_id" "s3-no-kms-bucket-name" {
  byte_length = 10
}

module "s3-default-no-kms" {
  source = "../"

  name                 = "testing-${random_id.s3-no-kms-bucket-name.hex}"
  acl                  = "private"
  environment          = "testing"
  bucket_iam_user      = "testing-s3-bucket-user-${random_id.s3-no-kms-bucket-name.hex}"
  iam_user_policy_name = "testing-s3-bucket-policy-${random_id.s3-no-kms-bucket-name.hex}"
}

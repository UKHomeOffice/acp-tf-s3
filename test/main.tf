resource "random_id" "s3-bucket-name" {
  byte_length = 10
}

module "s3-default" {
  source = "../"

  name                 = "testing-${random_id.s3-bucket-name.hex}"
  acl                  = "private"
  environment          = "testing"
  kms_alias            = "testingkey"
  bucket_iam_user      = "testing-s3-bucket-user"
  iam_user_policy_name = "testing-s3-bucket-policy"
}

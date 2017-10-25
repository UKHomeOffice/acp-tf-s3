data "aws_caller_identity" "current" {}

data "aws_region" "current" {
  current = true
}

resource "aws_kms_key" "s3_bucket_kms_key" {
  count = "${var.kms_alias == "" ? 0 : 1}"

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = "${data.aws_iam_policy_document.kms_key_policy_document.json}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster",var.environment))}"
}

resource "aws_kms_alias" "s3_bucket_kms_alias" {
  count = "${var.kms_alias == "" ? 0 : 1}"

  name          = "alias/${var.kms_alias}"
  target_key_id = "${aws_kms_key.s3_bucket_kms_key.key_id}"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.name}"
  acl    = "${var.acl}"

  versioning {
    enabled    = "${var.versioning_enabled}"
    mfa_delete = "${var.mfa_delete_enabled}"
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = "${var.lifecycle_infrequent_storage_transition_enabled}"

    prefix = "${var.lifecycle_infrequent_storage_object_prefix}"

    transition {
      days          = "${var.lifecycle_days_to_infrequent_storage_transition}"
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = "${var.lifecycle_glacier_transition_enabled}"

    prefix = "${var.lifecycle_glacier_object_prefix}"

    transition {
      days          = "${var.lifecycle_days_to_glacier_transition}"
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = "${var.lifecycle_expiration_enabled}"

    prefix = "${var.lifecycle_expiration_object_prefix}"

    expiration {
      days = "${var.lifecycle_days_to_expiration}"
    }
  }

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster", var.environment))}"
}

resource "aws_iam_user" "s3_bucket_iam_user" {
  name = "${var.bucket_iam_user}"
  path = "/"
}

resource "aws_iam_user_policy" "s3_bucket_with_kms_user_policy" {
  count = "${var.kms_alias == "" ? 0 : 1}"

  name   = "${var.iam_user_policy_name}"
  user   = "${aws_iam_user.s3_bucket_iam_user.name}"
  policy = "${data.aws_iam_policy_document.s3_bucket_with_kms_policy_document.json}"
}

resource "aws_iam_user_policy" "s3_bucket_user_policy" {
  count = "${var.kms_alias == "" ? 1 : 0}"

  name   = "${var.iam_user_policy_name}"
  user   = "${aws_iam_user.s3_bucket_iam_user.name}"
  policy = "${data.aws_iam_policy_document.s3_bucket_policy_document.json}"
}

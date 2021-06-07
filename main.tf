/**
* Module usage:
*
*     module "s3" {
*
*        source = "git::https://github.com/UKHomeOffice/acp-tf-s3?ref=master"
*
*        name                 = "fake"
*        acl                  = "private"
*        environment          = "${var.environment}"
*        kms_alias            = "mykey"
*        bucket_iam_user      = "fake-s3-bucket-user"
*        iam_user_policy_name = "fake-s3-bucket-policy"
*
*     }
*/
terraform {
  required_version = ">= 0.12"
}

locals {
  email_tags = { for i, email in var.email_addresses : "email${i}" => email }
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

resource "aws_kms_key" "s3_bucket_kms_key" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 ? 1 : 0

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = data.aws_iam_policy_document.kms_key_policy_document.json

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

resource "aws_kms_alias" "s3_bucket_kms_alias" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 ? 1 : 0

  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.s3_bucket_kms_key[0].key_id
}

resource "aws_kms_key" "s3_bucket_kms_key_whitelist" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 ? 1 : 0

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = data.aws_iam_policy_document.kms_key_policy_document_whitelist.json

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

resource "aws_kms_alias" "s3_bucket_kms_alias_whitelist" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 ? 1 : 0

  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.s3_bucket_kms_key_whitelist[0].key_id
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.name
  acl    = var.acl

  acceleration_status = var.acceleration_status

  versioning {
    enabled = var.versioning_enabled
  }

  lifecycle_rule {
    id      = "transition-to-infrequent-access-storage"
    enabled = var.lifecycle_infrequent_storage_transition_enabled

    prefix = var.lifecycle_infrequent_storage_object_prefix

    tags = var.lifecycle_infrequent_storage_object_tags

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }
  }

  lifecycle_rule {
    id      = "transition-to-glacier"
    enabled = var.lifecycle_glacier_transition_enabled

    prefix = var.lifecycle_glacier_object_prefix

    tags = var.lifecycle_glacier_object_tags

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_expiration_enabled

    prefix = var.lifecycle_expiration_object_prefix

    tags = var.lifecycle_expiration_object_tags

    expiration {
      days = var.lifecycle_days_to_expiration
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s-%s", var.environment, var.name)
    },
    {
      "Env" = var.environment
    },
  )
}

resource "aws_iam_user" "s3_bucket_iam_user" {
  count = var.number_of_users

  name = "${var.bucket_iam_user}${var.number_of_users != 1 ? "-${count.index}" : ""}"
  path = "/"

  tags = merge(
    var.tags,
    local.email_tags,
    {
      "key_rotation" = var.key_rotation
    },
  )
}

resource "aws_iam_policy" "s3_bucket_with_kms_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_1.json
  description = "Policy for bucket and object permissions when a KMS alias is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 ? var.number_of_users : 0

  user       = element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)
  policy_arn = aws_iam_policy.s3_bucket_with_kms_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketKMSPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_2[0].json
  description = "Policy for KMS permissions when a KMS alias is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 ? var.number_of_users : 0

  user       = element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)
  policy_arn = aws_iam_policy.s3_bucket_with_kms_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_1.json
  description = "Policy for bucket and object permissions when a KMS alias and whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 ? var.number_of_users : 0

  user       = element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketKMSPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_2[0].json
  description = "Policy for KMS permissions when a KMS alias and whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 ? var.number_of_users : 0

  user       = element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_policy_document.json
  description = "Policy for bucket and object permissions"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 ? var.number_of_users : 0

  user       = element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)
  policy_arn = aws_iam_policy.s3_bucket_iam_policy[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_whitelist_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_policy_document_whitelist.json
  description = "Policy for bucket and object permissions when a whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_whitelist_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 ? var.number_of_users : 0

  user       = element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)
  policy_arn = aws_iam_policy.s3_bucket_iam_whitelist_policy[0].arn
}

resource "aws_s3_bucket_policy" "enforce_tls_bucket_policy" {
  count  = var.enforce_tls == "true" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSSLRequestsOnly",
      "Action": "s3:*",
      "Effect": "Deny",
      "Resource": [
        "arn:aws:s3:::${var.name}",
        "arn:aws:s3:::${var.name}/*"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Principal": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_policy" "s3_tls_bucket_policy" {
  count = var.enforce_tls == "true" ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3EnforceTLSPolicy"
  policy      = data.aws_iam_policy_document.s3_tls_bucket_policy_document[0].json
  description = "Policy to enforce TLS on S3 bucket"
}

resource "aws_iam_user_policy_attachment" "attach_s3_tls_bucket_policy" {
  count = var.enforce_tls == "true" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_tls_bucket_policy[0].arn
}

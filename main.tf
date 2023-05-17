/*
Module usage:

     module "s3" {

        source = "git::https://github.com/UKHomeOffice/acp-tf-s3?ref=master"

        name                 = "fake"
        acl                  = "private"
        environment          = "${var.environment}"
        kms_alias            = "mykey"
        bucket_iam_user      = "fake-s3-bucket-user"
        iam_user_policy_name = "fake-s3-bucket-policy"

     }
*/

locals {
  email_tags         = { for i, email in var.email_addresses : "email${i}" => email }
  use_kms_encryption = var.kms_alias != "" && !var.website_hosting
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

resource "aws_kms_key" "this" {
  count = local.use_kms_encryption ? 1 : 0

  description         = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  enable_key_rotation = var.cmk_enable_key_rotation
  policy              = var.kms_key_policy != "" ? var.kms_key_policy : data.aws_iam_policy_document.kms_key_policy_document.json

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

resource "aws_kms_alias" "this" {
  count = local.use_kms_encryption ? 1 : 0

  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.this[0].key_id
}

resource "aws_s3_bucket" "this" {
  bucket = var.name

  lifecycle {
    ignore_changes = [
      acl,
      cors_rule,
      grant,
      lifecycle_rule,
      logging,
      server_side_encryption_configuration,
      website,
    ]
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

resource "aws_s3_bucket_accelerate_configuration" "this" {
  count = var.website_hosting ? 0 : 1

  bucket = aws_s3_bucket.this.bucket
  status = var.acceleration_status
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = var.acl
}

resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id = "transition-to-infrequent-access-storage"

    dynamic "filter" {
      for_each = length(var.lifecycle_infrequent_storage_object_tags) > 0 && var.lifecycle_infrequent_storage_object_prefix == "" ? [1] : []
      content {
        and {
          tags = var.lifecycle_infrequent_storage_object_tags
        }
      }
    }

    dynamic "filter" {
      for_each = length(var.lifecycle_infrequent_storage_object_tags) == 0 && var.lifecycle_infrequent_storage_object_prefix != "" ? [1] : []
      content {
        prefix = var.lifecycle_infrequent_storage_object_prefix
      }
    }

    dynamic "filter" {
      for_each = length(var.lifecycle_infrequent_storage_object_tags) > 0 && var.lifecycle_infrequent_storage_object_prefix != "" ? [1] : []
      content {
        and {
          prefix = var.lifecycle_infrequent_storage_object_prefix
          tags   = var.lifecycle_infrequent_storage_object_tags
        }
      }
    }

    transition {
      days          = var.lifecycle_days_to_infrequent_storage_transition
      storage_class = "STANDARD_IA"
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions ? [1] : []
      content {
        noncurrent_days = var.lifecycle_days_to_infrequent_storage_transition
        storage_class   = "STANDARD_IA"
      }
    }
    status = var.lifecycle_infrequent_storage_transition_enabled ? "Enabled" : "Disabled"
  }

  rule {
    id = "transition-to-glacier"

    dynamic "filter" {
      for_each = length(var.lifecycle_glacier_object_tags) > 0 && var.lifecycle_glacier_object_prefix == "" ? [1] : []
      content {
        and {
          tags = var.lifecycle_glacier_object_tags
        }
      }
    }

    dynamic "filter" {
      for_each = length(var.lifecycle_glacier_object_tags) == 0 && var.lifecycle_glacier_object_prefix != "" ? [1] : []
      content {
        prefix = var.lifecycle_glacier_object_prefix
      }
    }

    dynamic "filter" {
      for_each = length(var.lifecycle_glacier_object_tags) > 0 && var.lifecycle_glacier_object_prefix != "" ? [1] : []
      content {
        and {
          prefix = var.lifecycle_glacier_object_prefix
          tags   = var.lifecycle_glacier_object_tags
        }
      }
    }

    transition {
      days          = var.lifecycle_days_to_glacier_transition
      storage_class = "GLACIER"
    }

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions ? [1] : []
      content {
        noncurrent_days = var.lifecycle_days_to_glacier_transition
        storage_class   = "GLACIER"
      }
    }
    status = var.lifecycle_glacier_transition_enabled ? "Enabled" : "Disabled"
  }

  rule {
    id = "expire-objects"

    dynamic "filter" {
      for_each = length(var.lifecycle_expiration_object_tags) > 0 && var.lifecycle_expiration_object_prefix == "" ? [1] : []
      content {
        and {
          tags = var.lifecycle_expiration_object_tags
        }
      }
    }

    dynamic "filter" {
      for_each = length(var.lifecycle_expiration_object_tags) == 0 && var.lifecycle_expiration_object_prefix != "" ? [1] : []
      content {
        prefix = var.lifecycle_expiration_object_prefix
      }
    }

    dynamic "filter" {
      for_each = length(var.lifecycle_expiration_object_tags) > 0 && var.lifecycle_expiration_object_prefix != "" ? [1] : []
      content {
        and {
          prefix = var.lifecycle_expiration_object_prefix
          tags   = var.lifecycle_expiration_object_tags
        }
      }
    }

    expiration {
      days = var.lifecycle_days_to_expiration
    }

    dynamic "noncurrent_version_expiration" {
      for_each = var.expire_noncurrent_versions ? [1] : []
      content {
        noncurrent_days = var.lifecycle_days_to_expiration
      }
    }
    status = var.lifecycle_expiration_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = var.logging_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  target_bucket = var.log_target_bucket
  target_prefix = var.log_target_prefix
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.ownership_controls
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms" {
  count = local.use_kms_encryption && var.acl != "log-delivery-write" ? 1 : 0

  bucket = aws_s3_bucket.this.bucket

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.this[0].arn
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aes" {
  count = !(local.use_kms_encryption && var.acl != "log-delivery-write") ? 1 : 0

  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_status != "" ? var.versioning_status : var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  count = var.website_hosting ? 1 : 0

  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = var.website_index_document
  }

  error_document {
    key = var.website_error_document
  }
}


resource "aws_s3_bucket_policy" "s3_website_bucket" {
  count  = var.website_hosting && !var.enforce_tls ? 1 : 0
  bucket = aws_s3_bucket.this.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.name}/*"
    }
  ]
}
POLICY

}

resource "aws_s3_bucket_policy" "enforce_tls_bucket_policy" {
  count  = !var.website_hosting && var.enforce_tls ? 1 : 0
  bucket = aws_s3_bucket.this.id

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
  count = local.use_kms_encryption && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_1[0].json
  description = "Policy for bucket and object permissions when a KMS alias is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_iam_policy_1" {
  count = local.use_kms_encryption && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_iam_policy_2" {
  count = local.use_kms_encryption && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketKMSPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_2[0].json
  description = "Policy for KMS permissions when a KMS alias is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_iam_policy_2" {
  count = local.use_kms_encryption && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_iam_policy_1" {
  count = local.use_kms_encryption && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_1[0].json
  description = "Policy for bucket and object permissions when a KMS alias and whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_iam_policy_1" {
  count = local.use_kms_encryption && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_iam_policy_2" {
  count = local.use_kms_encryption && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketKMSPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_2[0].json
  description = "Policy for KMS permissions when a KMS alias and whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_iam_policy_2" {
  count = local.use_kms_encryption && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && !var.website_hosting ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_policy_document[0].json
  description = "Policy for bucket and object permissions"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && !var.website_hosting ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_iam_policy[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_whitelist_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && !var.website_hosting ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_policy_document_whitelist[0].json
  description = "Policy for bucket and object permissions when a whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_whitelist_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && !var.website_hosting ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_iam_whitelist_policy[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1" {
  count = local.use_kms_encryption && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicyVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_vpc_policy_document_1[0].json
  description = "Policy for bucket and object permissions when a KMS alias and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1" {
  count = local.use_kms_encryption && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2" {
  count = local.use_kms_encryption && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketKMSPolicyVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_vpc_policy_document_2[0].json
  description = "Policy for KMS permissions when a KMS alias and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2" {
  count = local.use_kms_encryption && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1" {
  count = local.use_kms_encryption && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketObjectPolicyIPandVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_1[0].json
  description = "Policy for bucket and object permissions when a KMS alias and whitelist IP range and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1" {
  count = local.use_kms_encryption && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2" {
  count = local.use_kms_encryption && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketKMSPolicyIPandVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_2[0].json
  description = "Policy for KMS permissions when a KMS alias and whitelist IP range and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2" {
  count = local.use_kms_encryption && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_whitelist_vpc_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && !var.website_hosting ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicyVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_whitelist_vpc_policy_document[0].json
  description = "Policy for bucket and object permissions when a VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_whitelist_vpc_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && !var.website_hosting ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_whitelist_vpc_iam_policy[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_whitelist_ip_and_vpc_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && !var.website_hosting ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicyIPandVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_whitelist_ip_and_vpc_policy_document[0].json
  description = "Policy for bucket and object permissions when a whitelist IP range and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_whitelist_ip_and_vpc_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_iam_whitelist_ip_and_vpc_policy[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_website_policy_1" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting ? 1 : 0

  name        = "${var.iam_user_policy_name}-WebsiteS3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_website_policy_document_1[0].json
  description = "Policy for bucket and object permissions when webstite hosting is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_website_bucket_iam_policy_1" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_iam_website_policy_1[0].arn
}

resource "aws_iam_policy" "s3_tls_bucket_policy" {
  count = var.enforce_tls ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3EnforceTLSPolicy"
  policy      = data.aws_iam_policy_document.s3_tls_bucket_policy_document[0].json
  description = "Policy to enforce TLS on S3 bucket"
}

resource "aws_iam_user_policy_attachment" "attach_s3_tls_bucket_policy" {
  count = var.enforce_tls ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_tls_bucket_policy[0].arn
}

module "self_serve_access_keys" {
  source = "git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys?ref=v0.1.0"

  user_names = aws_iam_user.s3_bucket_iam_user.*.name
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  count                   = var.block_public_access ? 1 : 0
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_policy.s3_website_bucket,
    aws_s3_bucket_policy.s3_website_bucket,
    aws_s3_bucket_policy.enforce_tls_bucket_policy,
    aws_iam_policy.s3_bucket_with_kms_iam_policy_1,
    aws_iam_policy.s3_bucket_with_kms_iam_policy_2,
    aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_1,
    aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_2,
    aws_iam_policy.s3_bucket_iam_policy,
    aws_iam_policy.s3_bucket_iam_whitelist_policy,
    aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1,
    aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2,
    aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1,
    aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2,
    aws_iam_policy.s3_bucket_with_whitelist_vpc_iam_policy,
    aws_iam_policy.s3_bucket_iam_whitelist_ip_and_vpc_policy,
    aws_iam_policy.s3_bucket_iam_website_policy_1,
    aws_iam_policy.s3_tls_bucket_policy,
  ]
}

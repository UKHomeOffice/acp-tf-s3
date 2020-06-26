/**
* Module usage:
*
*      module "s3" {
*
*         source = "git::https://github.com/UKHomeOffice/acp-tf-s3?ref=master"
*
*         name                 = "fake"
*         acl                  = "private"
*         environment          = "${var.environment}"
*         kms_alias            = "mykey"
*         bucket_iam_user      = "fake-s3-bucket-user"
*         iam_user_policy_name = "fake-s3-bucket-policy"
*
*      }
*/
terraform {
  required_version = ">= 0.12"
}

locals {
  s3_bucket_arn = coalesce(
    join("", aws_s3_bucket.s3_bucket.*.arn),
    join("", aws_s3_bucket.s3_bucket_with_logging.*.arn),
    join("", aws_s3_bucket.s3_website_bucket.*.arn),
    join("", aws_s3_bucket.s3_website_bucket_with_logging.*.arn),
    join("", aws_s3_bucket.s3_tls_bucket.*.arn),
    join("", aws_s3_bucket.s3_tls_bucket_with_logging.*.arn),
  )
  s3_bucket_id = coalesce(
    join("", aws_s3_bucket.s3_bucket.*.id),
    join("", aws_s3_bucket.s3_bucket_with_logging.*.id),
    join("", aws_s3_bucket.s3_website_bucket.*.id),
    join("", aws_s3_bucket.s3_website_bucket_with_logging.*.id),
    join("", aws_s3_bucket.s3_tls_bucket.*.id),
    join("", aws_s3_bucket.s3_tls_bucket_with_logging.*.id),
  )
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

resource "aws_kms_key" "s3_bucket_kms_key" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = var.kms_key_policy != "" ? var.kms_key_policy : data.aws_iam_policy_document.kms_key_policy_document.json

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
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.s3_bucket_kms_key[0].key_id
}

resource "aws_kms_key" "s3_bucket_kms_key_whitelist" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = var.kms_key_policy != "" ? var.kms_key_policy : data.aws_iam_policy_document.kms_key_policy_document_whitelist.json

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
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.s3_bucket_kms_key_whitelist[0].key_id
}

resource "aws_kms_key" "s3_bucket_kms_key_whitelist_vpc" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = var.kms_key_policy != "" ? var.kms_key_policy : data.aws_iam_policy_document.kms_key_with_whitelist_vpc_policy_document.json

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

resource "aws_kms_alias" "s3_bucket_kms_alias_whitelist_vpc" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.s3_bucket_kms_key_whitelist_vpc[0].key_id
}

resource "aws_kms_key" "s3_bucket_kms_key_whitelist_ip_and_vpc" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = var.kms_key_policy != "" ? var.kms_key_policy : data.aws_iam_policy_document.kms_key_with_whitelist_ip_and_vpc_policy_document.json

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

resource "aws_kms_alias" "s3_bucket_kms_alias_whitelist_ip_and_vpc" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc[0].key_id
}

resource "aws_s3_bucket" "s3_bucket" {
  count = var.website_hosting == "false" && var.logging_enabled == "false" ? 1 : 0

  bucket = var.name
  acl    = var.acl

  acceleration_status = var.acceleration_status

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_infrequent_storage_transition
        storage_class = "STANDARD_IA"
      }
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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_glacier_transition
        storage_class = "GLACIER"
      }
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

    dynamic "noncurrent_version_expiration" {
      for_each = var.expire_noncurrent_versions == "false" ? [] : [1]
      content {
        days = var.lifecycle_days_to_expiration
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration
    content {
      dynamic "rule" {
        for_each = lookup(server_side_encryption_configuration.value, "rule", [])
        content {
          dynamic "apply_server_side_encryption_by_default" {
            for_each = lookup(rule.value, "apply_server_side_encryption_by_default", [])
            content {
              kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
            }
          }
        }
      }
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

resource "aws_s3_bucket" "s3_bucket_with_logging" {
  count = var.website_hosting == "false" && var.logging_enabled ? 1 : 0

  bucket = var.name
  acl    = var.acl

  acceleration_status = var.acceleration_status

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_infrequent_storage_transition
        storage_class = "STANDARD_IA"
      }
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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_glacier_transition
        storage_class = "GLACIER"
      }
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

    dynamic "noncurrent_version_expiration" {
      for_each = var.expire_noncurrent_versions == "false" ? [] : [1]
      content {
        days = var.lifecycle_days_to_expiration
      }
    }
  }

  logging {
    target_bucket = var.log_target_bucket
    target_prefix = var.log_target_prefix
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration
    content {
      dynamic "rule" {
        for_each = lookup(server_side_encryption_configuration.value, "rule", [])
        content {
          dynamic "apply_server_side_encryption_by_default" {
            for_each = lookup(rule.value, "apply_server_side_encryption_by_default", [])
            content {
              kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
            }
          }
        }
      }
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

resource "aws_s3_bucket" "s3_website_bucket" {
  count = var.website_hosting == "true" && var.logging_enabled == "false" ? 1 : 0

  bucket = var.name
  acl    = var.acl

  acceleration_status = var.acceleration_status

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_infrequent_storage_transition
        storage_class = "STANDARD_IA"
      }
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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_glacier_transition
        storage_class = "GLACIER"
      }
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

    dynamic "noncurrent_version_expiration" {
      for_each = var.expire_noncurrent_versions == "false" ? [] : [1]
      content {
        days = var.lifecycle_days_to_expiration
      }
    }
  }

  website {
    index_document = var.website_index_document
    error_document = var.website_error_document
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration
    content {
      dynamic "rule" {
        for_each = lookup(server_side_encryption_configuration.value, "rule", [])
        content {
          dynamic "apply_server_side_encryption_by_default" {
            for_each = lookup(rule.value, "apply_server_side_encryption_by_default", [])
            content {
              kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
            }
          }
        }
      }
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

resource "aws_s3_bucket" "s3_website_bucket_with_logging" {
  count = var.website_hosting == "true" && var.logging_enabled ? 1 : 0

  bucket = var.name
  acl    = var.acl

  acceleration_status = var.acceleration_status

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_infrequent_storage_transition
        storage_class = "STANDARD_IA"
      }
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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_glacier_transition
        storage_class = "GLACIER"
      }
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

    dynamic "noncurrent_version_expiration" {
      for_each = var.expire_noncurrent_versions == "false" ? [] : [1]
      content {
        days = var.lifecycle_days_to_expiration
      }
    }
  }

  logging {
    target_bucket = var.log_target_bucket
    target_prefix = var.log_target_prefix
  }

  website {
    index_document = var.website_index_document
    error_document = var.website_error_document
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration
    content {
      dynamic "rule" {
        for_each = lookup(server_side_encryption_configuration.value, "rule", [])
        content {
          dynamic "apply_server_side_encryption_by_default" {
            for_each = lookup(rule.value, "apply_server_side_encryption_by_default", [])
            content {
              kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
            }
          }
        }
      }
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

resource "aws_s3_bucket" "s3_tls_bucket" {
  count = var.website_hosting == "false" && var.enforce_tls == "true" && var.logging_enabled == "false" ? 1 : 0

  bucket = var.name
  acl    = var.acl

  acceleration_status = var.acceleration_status

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_infrequent_storage_transition
        storage_class = "STANDARD_IA"
      }
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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_glacier_transition
        storage_class = "GLACIER"
      }
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

    dynamic "noncurrent_version_expiration" {
      for_each = var.expire_noncurrent_versions == "false" ? [] : [1]
      content {
        days = var.lifecycle_days_to_expiration
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration
    content {
      dynamic "rule" {
        for_each = lookup(server_side_encryption_configuration.value, "rule", [])
        content {
          dynamic "apply_server_side_encryption_by_default" {
            for_each = lookup(rule.value, "apply_server_side_encryption_by_default", [])
            content {
              kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
            }
          }
        }
      }
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

resource "aws_s3_bucket" "s3_tls_bucket_with_logging" {
  count = var.website_hosting == "false" && var.enforce_tls == "true" && var.logging_enabled ? 1 : 0

  bucket = var.name
  acl    = var.acl

  acceleration_status = var.acceleration_status

  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_infrequent_storage_transition
        storage_class = "STANDARD_IA"
      }
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

    dynamic "noncurrent_version_transition" {
      for_each = var.transition_noncurrent_versions == "false" ? [] : [1]
      content {
        days          = var.lifecycle_days_to_glacier_transition
        storage_class = "GLACIER"
      }
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

    dynamic "noncurrent_version_expiration" {
      for_each = var.expire_noncurrent_versions == "false" ? [] : [1]
      content {
        days = var.lifecycle_days_to_expiration
      }
    }
  }

  logging {
    target_bucket = var.log_target_bucket
    target_prefix = var.log_target_prefix
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration
    content {
      dynamic "rule" {
        for_each = lookup(server_side_encryption_configuration.value, "rule", [])
        content {
          dynamic "apply_server_side_encryption_by_default" {
            for_each = lookup(rule.value, "apply_server_side_encryption_by_default", [])
            content {
              kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
            }
          }
        }
      }
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

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  count  = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "true" && var.enforce_tls == "false" ? 1 : 0
  bucket = local.s3_bucket_id

  policy = var.website_hosting != "true" ? var.bucket_policy : data.aws_iam_policy_document.website_hosting_policy_document[0].json
}

resource "aws_s3_bucket_policy" "enforce_tls_bucet_policy" {
  count  = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" && var.enforce_tls == "true" ? 1 : 0
  bucket = local.s3_bucket_id

  policy = var.enforce_tls != "true" ? var.bucket_policy : data.aws_iam_policy_document.enforce_tls_policy_document[0].json
}

resource "aws_iam_user" "s3_bucket_iam_user" {
  count = var.number_of_users

  name = "${var.bucket_iam_user}${var.number_of_users != 1 ? "-${count.index}" : ""}"
  path = "/"
}

resource "aws_iam_policy" "s3_bucket_with_kms_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_1[0].json
  description = "Policy for bucket and object permissions when a KMS alias is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketKMSPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_2[0].json
  description = "Policy for KMS permissions when a KMS alias is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_1[0].json
  description = "Policy for bucket and object permissions when a KMS alias and whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketKMSPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_2[0].json
  description = "Policy for KMS permissions when a KMS alias and whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_policy_document[0].json
  description = "Policy for bucket and object permissions"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_iam_policy[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_whitelist_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_policy_document_whitelist[0].json
  description = "Policy for bucket and object permissions when a whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_whitelist_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_iam_whitelist_policy[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicyVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_vpc_policy_document_1[0].json
  description = "Policy for bucket and object permissions when a KMS alias and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketKMSPolicyVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_vpc_policy_document_2[0].json
  description = "Policy for KMS permissions when a KMS alias and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketObjectPolicyIPandVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_1[0].json
  description = "Policy for bucket and object permissions when a KMS alias and whitelist IP range and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketKMSPolicyIPandVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_2[0].json
  description = "Policy for KMS permissions when a KMS alias and whitelist IP range and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2" {
  count = var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2[0].arn
}

resource "aws_iam_policy" "s3_bucket_with_whitelist_vpc_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicyVPC"
  policy      = data.aws_iam_policy_document.s3_bucket_with_whitelist_vpc_policy_document[0].json
  description = "Policy for bucket and object permissions when a VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_whitelist_vpc_iam_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_with_whitelist_vpc_iam_policy[0].arn
}

resource "aws_iam_policy" "s3_bucket_iam_whitelist_ip_and_vpc_policy" {
  count = var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0

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
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "true" ? 1 : 0

  name        = "${var.iam_user_policy_name}-WebsiteS3BucketObjectPolicy"
  policy      = data.aws_iam_policy_document.s3_bucket_with_kms_website_policy_document_1[0].json
  description = "Policy for bucket and object permissions when webstite hosting is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_website_bucket_iam_policy_1" {
  count = var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "true" ? var.number_of_users : 0

  user       = aws_iam_user.s3_bucket_iam_user[count.index].name
  policy_arn = aws_iam_policy.s3_bucket_iam_website_policy_1[0].arn
}

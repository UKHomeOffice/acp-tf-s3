data "aws_iam_policy_document" "s3_bucket_with_kms_policy_document" {
  count = "${var.kms_alias == "" ? 0 : 1 + 2 * length(var.white_list_ip) == 0 ? 0 : 1 == 1 ? 1 : 0}"

  policy_id = "${var.bucket_iam_user}Policy"

  statement {
    sid    = "IAMS3BucketPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:ListBucket",
    ]
  }

  statement {
    sid    = "IAMS3ObjectPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
  }

  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    resources = [
      "${aws_kms_key.s3_bucket_kms_key.arn}",
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/${var.kms_alias}",
    ]

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:GenerateRandom",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ReEncrypt",
    ]
  }

  statement {
    sid    = "DenyCondition"
    effect = "Deny"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:PutObject",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "aws:kms",
      ]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_policy_document" {
  count = "${var.kms_alias == "" ? 0 : 1 + 2 * length(var.white_list_ip) == 0 ? 0 : 1 == 0 ? 1 : 0}"

  policy_id = "${var.bucket_iam_user}Policy"

  statement {
    sid    = "IAMS3BucketPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:ListBucket",
    ]
  }

  statement {
    sid    = "IAMS3ObjectPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
  }
}

data "aws_iam_policy_document" "kms_key_policy_document" {
  count = "${var.kms_alias == "" ? 0 : 1  + 2 * length(var.white_list_ip) == 0 ? 0 : 1 == 1 ? 1 : 0}"

  policy_id = "${var.kms_alias}Policy"

  statement {
    sid    = "IAMPermissions"
    effect = "Allow"

    resources = ["*"]

    actions = [
      "kms:*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }

  statement {
    sid    = "KeyAdministratorsPermissions"
    effect = "Allow"

    resources = ["*"]

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]
  }
}

data "aws_iam_policy_document" "s3_bucket_with_kms_policy_document_whitelist" {
  count = "${var.kms_alias == "" ? 0 : 1 + 2 * length(var.white_list_ip) == 0 ? 0 : 1 == 3 ? 1 : 0}"

  policy_id = "${var.bucket_iam_user}Policy"

  statement {
    sid    = "IAMS3BucketPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:ListBucket",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = "${var.white_list_ip}"
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = "true"
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = "${var.white_list_ip}"
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = "true"
    }
  }

  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    resources = [
      "${aws_kms_key.s3_bucket_kms_key.arn}",
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/${var.kms_alias}",
    ]

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:GenerateRandom",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ReEncrypt",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = "${var.white_list_ip}"
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = "true"
    }
  }

  statement {
    sid    = "DenyCondition"
    effect = "Deny"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:PutObject",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "aws:kms",
      ]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = "${var.white_list_ip}"
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = "true"
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_policy_document_whitelist" {
  count = "${var.kms_alias == "" ? 0 : 1 + 2 * length(var.white_list_ip) == 0 ? 0 : 1 == 2 ? 1 : 0}"

  policy_id = "${var.bucket_iam_user}Policy"

  statement {
    sid    = "IAMS3BucketPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:ListBucket",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = "${var.white_list_ip}"
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = "true"
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = "${var.white_list_ip}"
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = "true"
    }
  }
}

data "aws_iam_policy_document" "kms_key_policy_document_whitelist" {
  count = "${var.kms_alias == "" ? 0 : 1 + 2 * length(var.white_list_ip) == 0 ? 0 : 1 == 3 ? 1 : 0}"

  policy_id = "${var.kms_alias}Policy"

  statement {
    sid    = "IAMPermissions"
    effect = "Allow"

    resources = ["*"]

    actions = [
      "kms:*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = "${var.white_list_ip}"
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = "true"
    }
  }

  statement {
    sid    = "KeyAdministratorsPermissions"
    effect = "Allow"

    resources = ["*"]

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = "${var.white_list_ip}"
    }

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = "true"
    }
  }
}

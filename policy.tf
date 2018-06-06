data "aws_iam_policy_document" "s3_bucket_with_kms_policy_document_1" {
  policy_id = "${var.bucket_iam_user}S3BucketPolicy"

  statement {
    sid    = "IAMS3BucketPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]
  }

  statement {
    sid    = "IAMS3ObjectPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
    ]
  }
}

data "aws_iam_policy_document" "s3_bucket_with_kms_policy_document_2" {
  count     = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 ? 1 : 0}"
  policy_id = "${var.bucket_iam_user}KMSPolicy"

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
}

data "aws_iam_policy_document" "s3_bucket_policy_document" {
  policy_id = "${var.bucket_iam_user}S3BucketPolicy"

  statement {
    sid    = "IAMS3BucketPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]
  }

  statement {
    sid    = "IAMS3ObjectPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
    ]
  }
}

data "aws_iam_policy_document" "kms_key_policy_document" {
  policy_id = "${var.kms_alias}KMSPolicy"

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

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_with_kms_policy_document_whitelist_1" {
  policy_id = "${var.bucket_iam_user}S3BucketPolicy"

  statement {
    sid    = "IAMS3BucketPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPutGetPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["${aws_kms_key.s3_bucket_kms_key.arn}"]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_with_kms_policy_document_whitelist_2" {
  count     = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0? 1 : 0}"
  policy_id = "${var.bucket_iam_user}KMSPolicy"

  statement {
    sid    = "KMSPermissions"
    effect = "Allow"

    resources = [
      "${aws_kms_key.s3_bucket_kms_key_whitelist.arn}",
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
      values   = ["${var.whitelist_ip}"]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_policy_document_whitelist" {
  policy_id = "${var.bucket_iam_user}S3BucketPolicy"

  statement {
    sid    = "IAMS3BucketPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPutGetPermissions"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["${aws_kms_key.s3_bucket_kms_key_whitelist_ip.arn}"]
    }
  }
}

data "aws_iam_policy_document" "kms_key_policy_document_whitelist" {
  policy_id = "${var.kms_alias}KMSPolicy"

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

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_with_kms_and_whitelist_vpc_policy_document_1" {
  policy_id = "${var.bucket_iam_user}S3BucketPolicyVPC"

  statement {
    sid    = "IAMS3BucketPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPutGetPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["${aws_kms_key.s3_bucket_kms_key_whitelist_vpc.arn}"]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_with_kms_and_whitelist_vpc_policy_document_2" {
  count     = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 ? 1 : 0}"
  policy_id = "${var.bucket_iam_user}KMSPolicyVPC"

  statement {
    sid    = "KMSPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_kms_key.s3_bucket_kms_key_whitelist_vpc.arn}",
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
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_with_whitelist_vpc_policy_document" {
  policy_id = "${var.bucket_iam_user}S3BucketPolicyVPC"

  statement {
    sid    = "IAMS3BucketPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPutGetPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["${aws_kms_key.s3_bucket_whitelist_vpc.arn}"]
    }
  }
}

data "aws_iam_policy_document" "kms_key_with_whitelist_vpc_policy_document" {
  policy_id = "${var.kms_alias}KMSPolicy"

  statement {
    sid    = "IAMPermissionsVPC"
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
    sid    = "KeyAdministratorsPermissionsVPC"
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
      test     = "StringNotEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_1" {
  policy_id = "${var.bucket_iam_user}S3BucketPolicyIPandVPC"

  statement {
    sid    = "IAMS3BucketPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPutGetPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["${aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.arn}"]
    }
  }

  statement {
    sid    = "IAMS3BucketPermissionsIP"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissionsIP"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPutGetPermissionsIP"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["${aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.arn}"]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_2" {
  count     = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 ? 1 : 0}"
  policy_id = "${var.bucket_iam_user}KMSPolicyIPandVPC"

  statement {
    sid    = "KMSPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.arn}",
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
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "KMSPermissionsIP"
    effect = "Allow"

    resources = [
      "${aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.arn}",
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
      values   = ["${var.whitelist_ip}"]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket_with_whitelist_ip_and_vpc_policy_document" {
  policy_id = "${var.bucket_iam_user}S3BucketPolicyIPandVPC"

  statement {
    sid    = "IAMS3BucketPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPutGetPermissionsVPC"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["${aws_kms_key.s3_bucket_whitelist_ip_and_vpc.arn}"]
    }
  }

  statement {
    sid    = "IAMS3BucketPermissionsIP"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}",
    ]

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPermissionsIP"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }
  }

  statement {
    sid    = "IAMS3ObjectPutGetPermissionsIP"
    effect = "Allow"

    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*",
    ]

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["${var.whitelist_ip}"]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["${aws_kms_key.s3_bucket_whitelist_ip_and_vpc.arn}"]
    }
  }
}

data "aws_iam_policy_document" "kms_key_with_whitelist_ip_and_vpc_policy_document" {
  policy_id = "${var.kms_alias}KMSPolicyIPandVPC"

  statement {
    sid    = "IAMPermissionsIPandVPC"
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
    sid    = "KeyAdministratorsPermissionsVPC"
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
      test     = "StringNotEquals"
      variable = "aws:SourceVpce"
      values   = ["${var.whitelist_vpc}"]
    }

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }

  statement {
    sid    = "KeyAdministratorsPermissionsIP"
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
      values   = ["${var.whitelist_ip}"]
    }

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

/**
* Module usage:
*
*      module "s3" {
*
*      source = "git::https://github.com/UKHomeOffice/acp-tf-s3?ref=master"
*
*      name                 = "fake"
*      acl                  = "private"
*      environment          = "${var.environment}"
*      kms_alias            = "mykey"
*      bucket_iam_user      = "fake-s3-bucket-user"
*      iam_user_policy_name = "fake-s3-bucket-policy"
*
*       }
*/

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_kms_key" "s3_bucket_kms_key" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = "${data.aws_iam_policy_document.kms_key_policy_document.json}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

resource "aws_kms_alias" "s3_bucket_kms_alias" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  name          = "alias/${var.kms_alias}"
  target_key_id = "${aws_kms_key.s3_bucket_kms_key.key_id}"
}

resource "aws_kms_key" "s3_bucket_kms_key_whitelist" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = "${data.aws_iam_policy_document.kms_key_policy_document_whitelist.json}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

resource "aws_kms_alias" "s3_bucket_kms_alias_whitelist" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ?  1 : 0}"

  name          = "alias/${var.kms_alias}"
  target_key_id = "${aws_kms_key.s3_bucket_kms_key_whitelist.key_id}"
}

resource "aws_kms_key" "s3_bucket_kms_key_whitelist_vpc" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0}"

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = "${data.aws_iam_policy_document.kms_key_with_whitelist_vpc_policy_document.json}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

resource "aws_kms_alias" "s3_bucket_kms_alias_whitelist_vpc" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0}"

  name          = "alias/${var.kms_alias}"
  target_key_id = "${aws_kms_key.s3_bucket_kms_key_whitelist_vpc.key_id}"
}

resource "aws_kms_key" "s3_bucket_kms_key_whitelist_ip_and_vpc" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false"? 1 : 0}"

  description = "A kms key for encrypting/decrypting S3 bucket ${var.name}"
  policy      = "${data.aws_iam_policy_document.kms_key_with_whitelist_ip_and_vpc_policy_document.json}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

resource "aws_kms_alias" "s3_bucket_kms_alias_whitelist_ip_and_vpc" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0}"

  name          = "alias/${var.kms_alias}"
  target_key_id = "${aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc.key_id}"
}

resource "aws_s3_bucket" "s3_bucket" {
  count = "${var.website_hosting == "false" ? 1 : 0}"

  bucket = "${var.name}"
  acl    = "${var.acl}"

  cors_rule {
    allowed_headers = "${var.cors_allowed_headers}"
    allowed_methods = "${var.cors_allowed_methods}"
    allowed_origins = "${var.cors_allowed_origins}"
    expose_headers  = "${var.cors_expose_headers}"
    max_age_seconds = "${var.cors_max_age_seconds}"
  }

  versioning {
    enabled = "${var.versioning_enabled}"
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

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

resource "aws_s3_bucket" "s3_website_bucket" {
  count = "${var.website_hosting == "true" ? 1 : 0}"

  bucket = "${var.name}"
  acl    = "${var.acl}"

  cors_rule {
    allowed_headers = "${var.cors_allowed_headers}"
    allowed_methods = "${var.cors_allowed_methods}"
    allowed_origins = "${var.cors_allowed_origins}"
    expose_headers  = "${var.cors_expose_headers}"
    max_age_seconds = "${var.cors_max_age_seconds}"
  }

  versioning {
    enabled = "${var.versioning_enabled}"
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

  website {
    index_document = "${var.website_index_document}"
    error_document = "${var.website_error_document}"
  }

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment))}"
}

resource "aws_s3_bucket_policy" "s3_website_bucket" {
  count  = "${var.website_hosting == "true" ? 1 : 0}"
  bucket = "${aws_s3_bucket.s3_website_bucket.id}"

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

resource "aws_iam_user" "s3_bucket_iam_user" {
  count = "${var.number_of_users}"

  name = "${var.bucket_iam_user}${var.number_of_users != 1 ? "-${count.index}" : "" }"
  path = "/"
}

resource "aws_iam_policy" "s3_bucket_with_kms_iam_policy_1" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_1.json}"
  description = "Policy for bucket and object permissions when a KMS alias is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_iam_policy_1" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_kms_iam_policy_1.arn}"
}

resource "aws_iam_policy" "s3_bucket_with_kms_iam_policy_2" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-S3BucketKMSPolicy"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_2.json}"
  description = "Policy for KMS permissions when a KMS alias is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_iam_policy_2" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_kms_iam_policy_2.arn}"
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_iam_policy_1" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketObjectPolicy"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_1.json}"
  description = "Policy for bucket and object permissions when a KMS alias and whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_iam_policy_1" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_1.arn}"
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_iam_policy_2" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketKMSPolicy"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_2.json}"
  description = "Policy for KMS permissions when a KMS alias and whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_iam_policy_2" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_2.arn}"
}

resource "aws_iam_policy" "s3_bucket_iam_policy" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = "${data.aws_iam_policy_document.s3_bucket_policy_document.json}"
  description = "Policy for bucket and object permissions"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_iam_policy" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_iam_policy.arn}"
}

resource "aws_iam_policy" "s3_bucket_iam_whitelist_policy" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicy"
  policy      = "${data.aws_iam_policy_document.s3_bucket_policy_document_whitelist.json}"
  description = "Policy for bucket and object permissions when a whitelist IP range is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_whitelist_iam_policy" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_iam_whitelist_policy.arn}"
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicyVPC"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_vpc_policy_document_1.json}"
  description = "Policy for bucket and object permissions when a KMS alias and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1.arn}"
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-S3BucketKMSPolicyVPC"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_vpc_policy_document_2.json}"
  description = "Policy for KMS permissions when a KMS alias and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2.arn}"
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketObjectPolicyIPandVPC"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_1.json}"
  description = "Policy for bucket and object permissions when a KMS alias and whitelist IP range and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1.arn}"
}

resource "aws_iam_policy" "s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-WhitelistedS3BucketKMSPolicyIPandVPC"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_2.json}"
  description = "Policy for KMS permissions when a KMS alias and whitelist IP range and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2" {
  count = "${var.kms_alias != "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2.arn}"
}

resource "aws_iam_policy" "s3_bucket_with_whitelist_vpc_iam_policy" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0  && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicyVPC"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_whitelist_vpc_policy_document.json}"
  description = "Policy for bucket and object permissions when a VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_with_whitelist_vpc_iam_policy" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_with_whitelist_vpc_iam_policy.arn}"
}

resource "aws_iam_policy" "s3_bucket_iam_whitelist_ip_and_vpc_policy" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 && var.website_hosting == "false" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-S3BucketObjectPolicyIPandVPC"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_whitelist_ip_and_vpc_policy_document.json}"
  description = "Policy for bucket and object permissions when a whitelist IP range and VPC is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_bucket_whitelist_ip_and_vpc_iam_policy" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) != 0 && length(var.whitelist_vpc) != 0 ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_iam_whitelist_ip_and_vpc_policy.arn}"
}

resource "aws_iam_policy" "s3_bucket_iam_website_policy_1" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "true" ? 1 : 0}"

  name        = "${var.iam_user_policy_name}-WebsiteS3BucketObjectPolicy"
  policy      = "${data.aws_iam_policy_document.s3_bucket_with_kms_website_policy_document_1.json}"
  description = "Policy for bucket and object permissions when webstite hosting is specified"
}

resource "aws_iam_user_policy_attachment" "attach_s3_website_bucket_iam_policy_1" {
  count = "${var.kms_alias == "" && length(var.whitelist_ip) == 0 && length(var.whitelist_vpc) == 0 && var.website_hosting == "true" ? var.number_of_users : 0}"

  user       = "${element(aws_iam_user.s3_bucket_iam_user.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.s3_bucket_iam_website_policy_1.arn}"
}

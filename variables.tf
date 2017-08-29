variable "name" {
  description = "A descriptive name for the S3 instance"
}

variable "environment" {
  description = "The environment the S3 is running in i.e. dev, prod etc"
}

variable "bucket_iam_user" {
  description = "The name of the iam user assigned to the created s3 bucket"
}

variable "iam_user_policy_name" {
  description = "The policy name of attached to the user"
}

variable "kms_alias" {
  description = "The alias name for the kms key used to encrypt and decrypt the created S3 bucket objects"
  default     = ""
}

variable "versioning_enabled" {
  description = "If versioning is set for buckets in case of accidental deletion"
  default     = "true"
}

variable "mfa_delete_enabled" {
  description = "If mfa is enabled for bucket deletion"
  default     = "false"
}

variable "acl" {
  description = "The access control list assigned to this bucket"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

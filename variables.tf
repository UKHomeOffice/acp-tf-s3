variable "name" {
  description = "A descriptive name for the S3 instance"
}

variable "environment" {
  description = "The environment the S3 is running in i.e. dev, prod etc"
}

variable "bucket_iam_user" {
  description = "The name of the iam user assigned to the created s3 bucket"
}

variable "number_of_users" {
  description = "The number of user to generate credentials for"
  default     = 1
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

variable "acl" {
  description = "The access control list assigned to this bucket"
  default     = "public"
}

variable "whitelist_ip" {
  description = "Whitelisted ip allowed to access the created s3 bucket (note: this allows all by default)"
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "lifecycle_infrequent_storage_transition_enabled" {
  description = "Specifies infrequent storage transition lifecycle rule status."
  default     = "false"
}

variable "lifecycle_infrequent_storage_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = ""
}

variable "lifecycle_days_to_infrequent_storage_transition" {
  description = "Specifies the number of days after object creation when it will be moved to standard infrequent access storage."
  default     = "60"
}

variable "lifecycle_glacier_transition_enabled" {
  description = "Specifies Glacier transition lifecycle rule status."
  default     = "false"
}

variable "lifecycle_glacier_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = ""
}

variable "lifecycle_days_to_glacier_transition" {
  description = "Specifies the number of days after object creation when it will be moved to Glacier storage."
  default     = "180"
}

variable "lifecycle_expiration_enabled" {
  description = "Specifies expiration lifecycle rule status."
  default     = "false"
}

variable "lifecycle_expiration_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = ""
}

variable "lifecycle_days_to_expiration" {
  description = "Specifies the number of days after object creation when the object expires."
  default     = "365"
}

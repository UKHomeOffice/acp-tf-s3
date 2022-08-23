variable "acl" {
  description = "The access control list assigned to this bucket"
  default     = "private"
}

variable "acceleration_status" {
  description = "Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  default     = "Suspended"
}

variable "block_public_access" {
  description = "Blocks all public access to the bucket"
  type        = bool
  default     = false
}

variable "bucket_iam_user" {
  description = "The name of the iam user assigned to the created s3 bucket"
}

variable "environment" {
  description = "The environment the S3 is running in i.e. dev, prod etc"
}

variable "enforce_tls" {
  description = "Specifies if the bucket will be enforce a TLS bucket policy"
  type        = bool
  default     = true
}

variable "bucket_policy" {
  description = "Custom Bucket Policy"
  type        = string
  default     = ""
}

variable "cmk_enable_key_rotation" {
  description = "Enables CMK key rotation"
  type        = bool
  default     = true
}

variable "cors_allowed_headers" {
  description = "Specifies which headers are allowed."
  default     = ["Authorization"]
}

variable "cors_allowed_methods" {
  description = "Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD."
  default     = ["GET"]
}

variable "cors_allowed_origins" {
  description = "Specifies which origins are allowed."
  default     = ["*"]
}

variable "cors_expose_headers" {
  description = "Specifies expose header in the response."
  default     = []
}

variable "cors_max_age_seconds" {
  description = "Specifies time in seconds that browser can cache the response for a preflight request."
  default     = "3000"
}

variable "email_addresses" {
  description = "A list of email addresses for key rotation notifications."
  default     = []
}

variable "expire_noncurrent_versions" {
  description = "Allow expiration/retention rules to apply for all non-current version objects"
  type        = bool
  default     = true
}

variable "iam_user_policy_name" {
  description = "The policy name of attached to the user"
}

variable "key_rotation" {
  description = "Enable email notifications for old IAM keys."
  type        = bool
  default     = true
}

variable "kms_alias" {
  description = "The alias name for the kms key used to encrypt and decrypt the created S3 bucket objects"
  default     = ""
}

variable "kms_key_policy" {
  description = "KMS key policy (uses a default policy if omitted)"
  default     = ""
}

variable "lifecycle_infrequent_storage_transition_enabled" {
  description = "Specifies infrequent storage transition lifecycle rule status."
  type        = bool
  default     = false
}

variable "lifecycle_infrequent_storage_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = ""
}

variable "lifecycle_infrequent_storage_object_tags" {
  description = "Object tags to filter on for the transition to infrequent storage lifecycle rule."
  default     = {}
}

variable "lifecycle_days_to_infrequent_storage_transition" {
  description = "Specifies the number of days after object creation when it will be moved to standard infrequent access storage."
  default     = "60"
}

variable "lifecycle_glacier_transition_enabled" {
  description = "Specifies Glacier transition lifecycle rule status."
  type        = bool
  default     = false
}

variable "lifecycle_glacier_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = ""
}

variable "lifecycle_glacier_object_tags" {
  description = "Object tags to filter on for the transition to glacier lifecycle rule."
  default     = {}
}

variable "lifecycle_days_to_glacier_transition" {
  description = "Specifies the number of days after object creation when it will be moved to Glacier storage."
  default     = "180"
}

variable "lifecycle_expiration_enabled" {
  description = "Specifies expiration lifecycle rule status."
  type        = bool
  default     = false
}

variable "lifecycle_expiration_object_prefix" {
  description = "Object key prefix identifying one or more objects to which the lifecycle rule applies."
  default     = ""
}

variable "lifecycle_expiration_object_tags" {
  description = "Object tags to filter on for the expire object lifecycle rule."
  default     = {}
}

variable "lifecycle_days_to_expiration" {
  description = "Specifies the number of days after object creation when the object expires."
  default     = "365"
}

variable "logging_enabled" {
  description = "Specifies whether server access logging is enabled or not."
  type        = bool
  default     = false
}

variable "log_target_bucket" {
  description = "The S3 bucket that access logs should be sent to."
  default     = ""
}

variable "log_target_prefix" {
  description = "The object prefix for access logs"
  default     = ""
}

variable "name" {
  description = "A descriptive name for the S3 instance"
}

variable "number_of_users" {
  description = "The number of user to generate credentials for"
  default     = 1
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "transition_noncurrent_versions" {
  description = "Allow lifecycle rules to apply for all non-current version objects"
  type        = bool
  default     = true
}

variable "versioning_enabled" {
  description = "If versioning is set for buckets in case of accidental deletion; deprecated - use versioning_status instead"
  type        = bool
  default     = false
}

variable "versioning_status" {
  description = "The versioning status for the bucket - valid values are: Enabled, Disabled and Suspended"
  type        = string
  default     = ""
}

variable "website_hosting" {
  description = "Specifies if the bucket will be used for static website hosting"
  type        = bool
  default     = false
}

variable "website_index_document" {
  description = "The path of index document when requests are made for static website hosting"
  default     = "index.html"
}

variable "website_error_document" {
  description = "The path to the document to return in case of a 4XX error for static website hosting"
  default     = "error.html"
}

variable "whitelist_ip" {
  description = "Whitelisted ip allowed to access the created s3 bucket (note: this allows all by default)"
  default     = []
}

variable "whitelist_vpc" {
  description = "Whitelisted vpc allowed to access the created s3 bucket"
  default     = []
}

variable "enforce_kms_key_use" {
  description = "Whether or not to require a PutObject request to specify the KMS key id that was created. Defaults to true. Should only be set to false to emulate the behaviour of v0.x of the module and only until the tenants have changed their code to specify the KMS key id in their requests"
  type        = bool
  default     = true
}

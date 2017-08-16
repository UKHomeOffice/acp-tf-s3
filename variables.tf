
variable "name" {
  description = "A descriptive name for the RDS instance"
}

variable "environment" {
  description = "The environment the RDS is running in i.e. dev, prod etc"
}

variable "bucket_name" {
  description = "The name of the s3 bucket to be created"
}

variable "acl" {
  description = "The access control list assigned to this bucket"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

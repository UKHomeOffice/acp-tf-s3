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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.s3_bucket_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_iam_website_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_iam_whitelist_ip_and_vpc_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_iam_whitelist_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_kms_and_whitelist_iam_policy_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_kms_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_kms_iam_policy_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket_with_whitelist_vpc_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_tls_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.s3_bucket_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_whitelist_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_whitelist_ip_and_vpc_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_kms_and_whitelist_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_kms_and_whitelist_iam_policy_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_kms_and_whitelist_ip_and_vpc_iam_policy_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_kms_and_whitelist_vpc_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_kms_and_whitelist_vpc_iam_policy_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_kms_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_kms_iam_policy_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_bucket_with_whitelist_vpc_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_tls_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.attach_s3_website_bucket_iam_policy_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_kms_alias.s3_bucket_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.s3_bucket_kms_alias_whitelist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.s3_bucket_kms_alias_whitelist_ip_and_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.s3_bucket_kms_alias_whitelist_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.s3_bucket_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.s3_bucket_kms_key_whitelist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.s3_bucket_kms_key_whitelist_ip_and_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.s3_bucket_kms_key_whitelist_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_bucket_with_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_website_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.s3_website_bucket_with_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.enforce_tls_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.s3_website_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_key_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key_policy_document_whitelist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key_with_whitelist_ip_and_vpc_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key_with_whitelist_vpc_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_policy_document_whitelist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_ip_and_vpc_policy_document_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_vpc_policy_document_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_and_whitelist_vpc_policy_document_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_policy_document_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_policy_document_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_policy_document_whitelist_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_kms_website_policy_document_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_whitelist_ip_and_vpc_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_bucket_with_whitelist_vpc_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_tls_bucket_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acceleration_status"></a> [acceleration\_status](#input\_acceleration\_status) | Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended. | `string` | `"Suspended"` | no |
| <a name="input_acl"></a> [acl](#input\_acl) | The access control list assigned to this bucket | `string` | `"private"` | no |
| <a name="input_bucket_iam_user"></a> [bucket\_iam\_user](#input\_bucket\_iam\_user) | The name of the iam user assigned to the created s3 bucket | `any` | n/a | yes |
| <a name="input_cors_allowed_headers"></a> [cors\_allowed\_headers](#input\_cors\_allowed\_headers) | Specifies which headers are allowed. | `list` | <pre>[<br>  "Authorization"<br>]</pre> | no |
| <a name="input_cors_allowed_methods"></a> [cors\_allowed\_methods](#input\_cors\_allowed\_methods) | Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. | `list` | <pre>[<br>  "GET"<br>]</pre> | no |
| <a name="input_cors_allowed_origins"></a> [cors\_allowed\_origins](#input\_cors\_allowed\_origins) | Specifies which origins are allowed. | `list` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_cors_expose_headers"></a> [cors\_expose\_headers](#input\_cors\_expose\_headers) | Specifies expose header in the response. | `list` | `[]` | no |
| <a name="input_cors_max_age_seconds"></a> [cors\_max\_age\_seconds](#input\_cors\_max\_age\_seconds) | Specifies time in seconds that browser can cache the response for a preflight request. | `string` | `"3000"` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | A list of email addresses for key rotation notifications. | `list` | `[]` | no |
| <a name="input_enforce_tls"></a> [enforce\_tls](#input\_enforce\_tls) | Specifies if the bucket will be enforce a TLS bucket policy | `string` | `"true"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment the S3 is running in i.e. dev, prod etc | `any` | n/a | yes |
| <a name="input_expire_noncurrent_versions"></a> [expire\_noncurrent\_versions](#input\_expire\_noncurrent\_versions) | Allow expiration/retention rules to apply for all non-current version objects | `string` | `"true"` | no |
| <a name="input_iam_user_policy_name"></a> [iam\_user\_policy\_name](#input\_iam\_user\_policy\_name) | The policy name of attached to the user | `any` | n/a | yes |
| <a name="input_key_rotation"></a> [key\_rotation](#input\_key\_rotation) | Enable email notifications for old IAM keys. | `string` | `"true"` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | The alias name for the kms key used to encrypt and decrypt the created S3 bucket objects | `string` | `""` | no |
| <a name="input_kms_key_policy"></a> [kms\_key\_policy](#input\_kms\_key\_policy) | KMS key policy (uses a default policy if omitted) | `string` | `""` | no |
| <a name="input_lifecycle_days_to_expiration"></a> [lifecycle\_days\_to\_expiration](#input\_lifecycle\_days\_to\_expiration) | Specifies the number of days after object creation when the object expires. | `string` | `"365"` | no |
| <a name="input_lifecycle_days_to_glacier_transition"></a> [lifecycle\_days\_to\_glacier\_transition](#input\_lifecycle\_days\_to\_glacier\_transition) | Specifies the number of days after object creation when it will be moved to Glacier storage. | `string` | `"180"` | no |
| <a name="input_lifecycle_days_to_infrequent_storage_transition"></a> [lifecycle\_days\_to\_infrequent\_storage\_transition](#input\_lifecycle\_days\_to\_infrequent\_storage\_transition) | Specifies the number of days after object creation when it will be moved to standard infrequent access storage. | `string` | `"60"` | no |
| <a name="input_lifecycle_expiration_enabled"></a> [lifecycle\_expiration\_enabled](#input\_lifecycle\_expiration\_enabled) | Specifies expiration lifecycle rule status. | `string` | `"false"` | no |
| <a name="input_lifecycle_expiration_object_prefix"></a> [lifecycle\_expiration\_object\_prefix](#input\_lifecycle\_expiration\_object\_prefix) | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| <a name="input_lifecycle_expiration_object_tags"></a> [lifecycle\_expiration\_object\_tags](#input\_lifecycle\_expiration\_object\_tags) | Object tags to filter on for the expire object lifecycle rule. | `map` | `{}` | no |
| <a name="input_lifecycle_glacier_object_prefix"></a> [lifecycle\_glacier\_object\_prefix](#input\_lifecycle\_glacier\_object\_prefix) | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| <a name="input_lifecycle_glacier_object_tags"></a> [lifecycle\_glacier\_object\_tags](#input\_lifecycle\_glacier\_object\_tags) | Object tags to filter on for the transition to glacier lifecycle rule. | `map` | `{}` | no |
| <a name="input_lifecycle_glacier_transition_enabled"></a> [lifecycle\_glacier\_transition\_enabled](#input\_lifecycle\_glacier\_transition\_enabled) | Specifies Glacier transition lifecycle rule status. | `string` | `"false"` | no |
| <a name="input_lifecycle_infrequent_storage_object_prefix"></a> [lifecycle\_infrequent\_storage\_object\_prefix](#input\_lifecycle\_infrequent\_storage\_object\_prefix) | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| <a name="input_lifecycle_infrequent_storage_object_tags"></a> [lifecycle\_infrequent\_storage\_object\_tags](#input\_lifecycle\_infrequent\_storage\_object\_tags) | Object tags to filter on for the transition to infrequent storage lifecycle rule. | `map` | `{}` | no |
| <a name="input_lifecycle_infrequent_storage_transition_enabled"></a> [lifecycle\_infrequent\_storage\_transition\_enabled](#input\_lifecycle\_infrequent\_storage\_transition\_enabled) | Specifies infrequent storage transition lifecycle rule status. | `string` | `"false"` | no |
| <a name="input_log_target_bucket"></a> [log\_target\_bucket](#input\_log\_target\_bucket) | The S3 bucket that access logs should be sent to. | `string` | `""` | no |
| <a name="input_log_target_prefix"></a> [log\_target\_prefix](#input\_log\_target\_prefix) | The object prefix for access logs | `string` | `""` | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Specifies whether server access logging is enabled or not. | `string` | `"false"` | no |
| <a name="input_name"></a> [name](#input\_name) | A descriptive name for the S3 instance | `any` | n/a | yes |
| <a name="input_number_of_users"></a> [number\_of\_users](#input\_number\_of\_users) | The number of user to generate credentials for | `number` | `1` | no |
| <a name="input_server_side_encryption_configuration"></a> [server\_side\_encryption\_configuration](#input\_server\_side\_encryption\_configuration) | Provides access to override the server side encryption configuration | `list` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map` | `{}` | no |
| <a name="input_transition_noncurrent_versions"></a> [transition\_noncurrent\_versions](#input\_transition\_noncurrent\_versions) | Allow lifecycle rules to apply for all non-current version objects | `string` | `"true"` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | If versioning is set for buckets in case of accidental deletion | `string` | `"false"` | no |
| <a name="input_website_error_document"></a> [website\_error\_document](#input\_website\_error\_document) | The path to the document to return in case of a 4XX error for static website hosting | `string` | `"error.html"` | no |
| <a name="input_website_hosting"></a> [website\_hosting](#input\_website\_hosting) | Specifies if the bucket will be used for static website hosting | `string` | `"false"` | no |
| <a name="input_website_index_document"></a> [website\_index\_document](#input\_website\_index\_document) | The path of index document when requests are made for static website hosting | `string` | `"index.html"` | no |
| <a name="input_whitelist_ip"></a> [whitelist\_ip](#input\_whitelist\_ip) | Whitelisted ip allowed to access the created s3 bucket (note: this allows all by default) | `list` | `[]` | no |
| <a name="input_whitelist_vpc"></a> [whitelist\_vpc](#input\_whitelist\_vpc) | Whitelisted vpc allowed to access the created s3 bucket | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of generated S3 bucket |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | ID of generated S3 bucket |
| <a name="output_s3_bucket_kms_key"></a> [s3\_bucket\_kms\_key](#output\_s3\_bucket\_kms\_key) | KMS Key ID of the generated bucket |
| <a name="output_s3_bucket_kms_key_arn"></a> [s3\_bucket\_kms\_key\_arn](#output\_s3\_bucket\_kms\_key\_arn) | KMS Key ARN of the generated bucket |
| <a name="output_s3_bucket_whitelist_arn_kms_key_arn"></a> [s3\_bucket\_whitelist\_arn\_kms\_key\_arn](#output\_s3\_bucket\_whitelist\_arn\_kms\_key\_arn) | KMS Key ARN of the whitelist ip generated bucket |
| <a name="output_s3_bucket_whitelist_ip_and_vpc_kms_key"></a> [s3\_bucket\_whitelist\_ip\_and\_vpc\_kms\_key](#output\_s3\_bucket\_whitelist\_ip\_and\_vpc\_kms\_key) | KMS Key ID of the whitelist ip and vpc generated bucket |
| <a name="output_s3_bucket_whitelist_ip_and_vpc_kms_key_arn"></a> [s3\_bucket\_whitelist\_ip\_and\_vpc\_kms\_key\_arn](#output\_s3\_bucket\_whitelist\_ip\_and\_vpc\_kms\_key\_arn) | KMS Key ARN of the whitelist ip and vpc generated bucket |
| <a name="output_s3_bucket_whitelist_kms_key"></a> [s3\_bucket\_whitelist\_kms\_key](#output\_s3\_bucket\_whitelist\_kms\_key) | KMS Key ID of the whitelist ip generated bucket |
| <a name="output_s3_bucket_whitelist_vpc_arn_kms_key_arn"></a> [s3\_bucket\_whitelist\_vpc\_arn\_kms\_key\_arn](#output\_s3\_bucket\_whitelist\_vpc\_arn\_kms\_key\_arn) | KMS Key ARN of the whitelist vpc generated bucket |
| <a name="output_s3_bucket_whitelist_vpc_kms_key"></a> [s3\_bucket\_whitelist\_vpc\_kms\_key](#output\_s3\_bucket\_whitelist\_vpc\_kms\_key) | KMS Key ID of the whitelist vpc generated bucket |
| <a name="output_s3_bucket_with_logging_arn"></a> [s3\_bucket\_with\_logging\_arn](#output\_s3\_bucket\_with\_logging\_arn) | ARN of generated S3 bucket with server access logging enabled |
| <a name="output_s3_bucket_with_logging_id"></a> [s3\_bucket\_with\_logging\_id](#output\_s3\_bucket\_with\_logging\_id) | ID of generated S3 bucket with server access logging enabled |
| <a name="output_s3_website_bucket_arn"></a> [s3\_website\_bucket\_arn](#output\_s3\_website\_bucket\_arn) | ARN of generated S3 bucket with website hosting enabled |
| <a name="output_s3_website_bucket_id"></a> [s3\_website\_bucket\_id](#output\_s3\_website\_bucket\_id) | ID of generated S3 bucket with website hosting enabled |
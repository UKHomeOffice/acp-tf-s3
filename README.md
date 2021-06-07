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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| acceleration\_status | Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended. | `string` | `"Suspended"` | no |
| acl | The access control list assigned to this bucket | `string` | `"public"` | no |
| bucket\_iam\_user | The name of the iam user assigned to the created s3 bucket | `any` | n/a | yes |
| email\_addresses | A list of email addresses for key rotation notifications. | `list` | `[]` | no |
| enforce\_tls | Specifies if the bucket will be enforce a TLS bucket policy | `string` | `"true"` | no |
| environment | The environment the S3 is running in i.e. dev, prod etc | `any` | n/a | yes |
| iam\_user\_policy\_name | The policy name of attached to the user | `any` | n/a | yes |
| key\_rotation | Enable email notifications for old IAM keys. | `string` | `"true"` | no |
| kms\_alias | The alias name for the kms key used to encrypt and decrypt the created S3 bucket objects | `string` | `""` | no |
| lifecycle\_days\_to\_expiration | Specifies the number of days after object creation when the object expires. | `string` | `"365"` | no |
| lifecycle\_days\_to\_glacier\_transition | Specifies the number of days after object creation when it will be moved to Glacier storage. | `string` | `"180"` | no |
| lifecycle\_days\_to\_infrequent\_storage\_transition | Specifies the number of days after object creation when it will be moved to standard infrequent access storage. | `string` | `"60"` | no |
| lifecycle\_expiration\_enabled | Specifies expiration lifecycle rule status. | `string` | `"false"` | no |
| lifecycle\_expiration\_object\_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| lifecycle\_expiration\_object\_tags | Object tags to filter on for the expire object lifecycle rule. | `map` | `{}` | no |
| lifecycle\_glacier\_object\_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| lifecycle\_glacier\_object\_tags | Object tags to filter on for the transition to glacier lifecycle rule. | `map` | `{}` | no |
| lifecycle\_glacier\_transition\_enabled | Specifies Glacier transition lifecycle rule status. | `string` | `"false"` | no |
| lifecycle\_infrequent\_storage\_object\_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| lifecycle\_infrequent\_storage\_object\_tags | Object tags to filter on for the transition to infrequent storage lifecycle rule. | `map` | `{}` | no |
| lifecycle\_infrequent\_storage\_transition\_enabled | Specifies infrequent storage transition lifecycle rule status. | `string` | `"false"` | no |
| name | A descriptive name for the S3 instance | `any` | n/a | yes |
| number\_of\_users | The number of user to generate credentials for | `number` | `1` | no |
| tags | A map of tags to add to all resources | `map` | `{}` | no |
| versioning\_enabled | If versioning is set for buckets in case of accidental deletion | `string` | `"false"` | no |
| whitelist\_ip | Whitelisted ip allowed to access the created s3 bucket (note: this allows all by default) | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3\_bucket\_arn | The S3 bucket ARN we just created |
| s3\_bucket\_id | The S3 bucket ID we just created |
| s3\_bucket\_kms\_key | The KMS key ID used for the bucket |
| s3\_bucket\_kms\_key\_arn | The KMS key ARN used for the bucket |
| s3\_bucket\_whitelist\_arn\_kms\_key\_arn | KMS Key ARN of the whitelist ip generated bucket |
| s3\_bucket\_whitelist\_kms\_key | KMS Key ID of the whitelist ip generated bucket |
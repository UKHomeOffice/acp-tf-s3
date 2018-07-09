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

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| acl | The access control list assigned to this bucket | `public` | no |
| bucket_iam_user | The name of the iam user assigned to the created s3 bucket | - | yes |
| environment | The environment the S3 is running in i.e. dev, prod etc | - | yes |
| iam_user_policy_name | The policy name of attached to the user | - | yes |
| kms_alias | The alias name for the kms key used to encrypt and decrypt the created S3 bucket objects | `` | no |
| lifecycle_days_to_expiration | Specifies the number of days after object creation when the object expires. | `365` | no |
| lifecycle_days_to_glacier_transition | Specifies the number of days after object creation when it will be moved to Glacier storage. | `180` | no |
| lifecycle_days_to_infrequent_storage_transition | Specifies the number of days after object creation when it will be moved to standard infrequent access storage. | `60` | no |
| lifecycle_expiration_enabled | Specifies expiration lifecycle rule status. | `false` | no |
| lifecycle_expiration_object_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `` | no |
| lifecycle_glacier_object_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `` | no |
| lifecycle_glacier_transition_enabled | Specifies Glacier transition lifecycle rule status. | `false` | no |
| lifecycle_infrequent_storage_object_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `` | no |
| lifecycle_infrequent_storage_transition_enabled | Specifies infrequent storage transition lifecycle rule status. | `false` | no |
| name | A descriptive name for the S3 instance | - | yes |
| number_of_users | The number of user to generate credentials for | `1` | no |
| tags | A map of tags to add to all resources | `<map>` | no |
| versioning_enabled | If versioning is set for buckets in case of accidental deletion | `false` | no |
| whitelist_ip | Whitelisted ip allowed to access the created s3 bucket (note: this allows all by default) | `<list>` | no |
| whitelist_vpc | Whitelisted vpc allowed to access the created s3 bucket | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3_bucket_arn |  |
| s3_bucket_id |  |
| s3_bucket_kms_key |  |
| s3_bucket_kms_key_arn |  |


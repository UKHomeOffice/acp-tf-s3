Module usage:

     module "s3" {

        source = "git::https://github.com/UKHomeOffice/acp-tf-s3?ref=master"

        name                 = "fake"
        acl                  = "private"
        account_type         = "${var.environment}"
        kms_alias            = "mykey"
        bucket_iam_user      = "fake-s3-bucket-user"
        iam_user_policy_name = "fake-s3-bucket-policy"
        project_portfolio    = "fake-project-portfolio"
        project_service      = "fake-project-service"
        environment          = "fake-project-environment"
        cost_code            = "fake-cost-code"

     }


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| account_type | The account the S3 bucket is running in i.e. notprod, ci, test etc | - | yes |
| acl | The access control list assigned to this bucket | `public` | no |
| bucket_iam_user | The name of the iam user assigned to the created s3 bucket | - | yes |
| cost_code | The cost code of the project. | `` | no |
| environment | The project's environment name e.g. dev, preprod, qa. | `` | no |
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
| project_portfolio | The name of the portfolio that the project belongs to. | `` | no |
| project_service | The name of the service. | `` | no |
| tags | A map of tags to add to all resources | `<map>` | no |
| versioning_enabled | If versioning is set for buckets in case of accidental deletion | `true` | no |
| whitelist_ip | Whitelisted ip allowed to access the created s3 bucket (note: this allows all by default) | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3_bucket_id |  |
| s3_bucket_kms_key |  |


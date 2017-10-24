
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
| name | The allocated to the s3 bucket in aws | - | yes |
| bucket_iam_user | The iam user name assigned to the created bucket | - | yes |
| iam_user_policy_name | The name of the policy attached to the iam user | - | yes |
| acl | Amazon control list of access rights to the created bucket | - | yes |
| environment | The environment the S3 is running in i.e. dev, prod etc | - | yes |
| kms_alias | The name of the key for encrypting and decrypting | - | no |
| versioning_enabled | If the versioning is enabled for the created s3 bucket | true | no |
| mfa_delete_enabled | If mfa is need for delete for s3 bucket | false | no |
| white_list_ip | The ip's to whitelist from users | [] | no |
| tags | A map of tags to add to all resources | `<map>` | no |
| lifecycle_infrequent_storage_transition_enabled | Whether bucket infrequent storage transition lifecycle is enabled | false | no |
| lifecycle_infrequent_storage_object_prefix | Object key prefix identifying one or more objects to which the infrequent access storage transition rule applies | `""` | no |
| lifecycle_days_to_infrequent_storage_transition | Specifies the number of days after object creation when it will be moved to standard infrequent access storage | 60 | no |
| lifecycle_glacier_transition_enabled | Whether bucket Glacier transition lifecycle is enabled | false | no |
| lifecycle_glacier_object_prefix | Object key prefix identifying one or more objects to which the Glacier transition rule applies | `""` | no |
| lifecycle_days_to_glacier_transition | Specifies the number of days after object creation when it will be moved to Glacier storage | 180 | no |
| lifecycle_expiration_enabled | Whether bucket expiration lifecycle is enabled | false | no |
| lifecycle_expiration_object_prefix | Object key prefix identifying one or more objects to which the expiration rule applies | `""` | no |
| lifecycle_days_to_expiration | Specifies the number of days after object creation when the object expires | 365 | no |

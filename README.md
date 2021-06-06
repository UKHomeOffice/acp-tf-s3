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
| acl | The access control list assigned to this bucket | `string` | `"private"` | no |
| bucket\_iam\_user | The name of the iam user assigned to the created s3 bucket | `any` | n/a | yes |
| cors\_allowed\_headers | Specifies which headers are allowed. | `list` | <code><pre>[<br>  "Authorization"<br>]<br></pre></code> | no |
| cors\_allowed\_methods | Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. | `list` | <code><pre>[<br>  "GET"<br>]<br></pre></code> | no |
| cors\_allowed\_origins | Specifies which origins are allowed. | `list` | <code><pre>[<br>  "*"<br>]<br></pre></code> | no |
| cors\_expose\_headers | Specifies expose header in the response. | `list` | `[]` | no |
| cors\_max\_age\_seconds | Specifies time in seconds that browser can cache the response for a preflight request. | `string` | `"3000"` | no |
| email\_addresses | A list of email addresses for key rotation notifications. | `list` | `[]` | no |
| enforce\_tls | Specifies if the bucket will be enforce a TLS bucket policy | `string` | `"true"` | no |
| environment | The environment the S3 is running in i.e. dev, prod etc | `any` | n/a | yes |
| expire\_noncurrent\_versions | Allow expiration/retention rules to apply for all non-current version objects | `string` | `"true"` | no |
| iam\_user\_policy\_name | The policy name of attached to the user | `any` | n/a | yes |
| key\_rotation | Enable email notifications for old IAM keys. | `string` | `"true"` | no |
| kms\_alias | The alias name for the kms key used to encrypt and decrypt the created S3 bucket objects | `string` | `""` | no |
| kms\_key\_policy | KMS key policy (uses a default policy if omitted) | `string` | `""` | no |
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
| log\_target\_bucket | The S3 bucket that access logs should be sent to. | `string` | `""` | no |
| log\_target\_prefix | The object prefix for access logs | `string` | `""` | no |
| logging\_enabled | Specifies whether server access logging is enabled or not. | `string` | `"false"` | no |
| name | A descriptive name for the S3 instance | `any` | n/a | yes |
| number\_of\_users | The number of user to generate credentials for | `number` | `1` | no |
| server\_side\_encryption\_configuration | Provides access to override the server side encryption configuration | `list` | `[]` | no |
| tags | A map of tags to add to all resources | `map` | `{}` | no |
| transition\_noncurrent\_versions | Allow lifecycle rules to apply for all non-current version objects | `string` | `"true"` | no |
| versioning\_enabled | If versioning is set for buckets in case of accidental deletion | `string` | `"false"` | no |
| website\_error\_document | The path to the document to return in case of a 4XX error for static website hosting | `string` | `"error.html"` | no |
| website\_hosting | Specifies if the bucket will be used for static website hosting | `string` | `"false"` | no |
| website\_index\_document | The path of index document when requests are made for static website hosting | `string` | `"index.html"` | no |
| whitelist\_ip | Whitelisted ip allowed to access the created s3 bucket (note: this allows all by default) | `list` | `[]` | no |
| whitelist\_vpc | Whitelisted vpc allowed to access the created s3 bucket | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3\_bucket\_arn | ARN of generated S3 bucket |
| s3\_bucket\_id | ID of generated S3 bucket |
| s3\_bucket\_kms\_key | KMS Key ID of the generated bucket |
| s3\_bucket\_kms\_key\_arn | KMS Key ARN of the generated bucket |
| s3\_bucket\_whitelist\_arn\_kms\_key\_arn | KMS Key ARN of the whitelist ip generated bucket |
| s3\_bucket\_whitelist\_ip\_and\_vpc\_kms\_key | KMS Key ID of the whitelist ip and vpc generated bucket |
| s3\_bucket\_whitelist\_ip\_and\_vpc\_kms\_key\_arn | KMS Key ARN of the whitelist ip and vpc generated bucket |
| s3\_bucket\_whitelist\_kms\_key | KMS Key ID of the whitelist ip generated bucket |
| s3\_bucket\_whitelist\_vpc\_arn\_kms\_key\_arn | KMS Key ARN of the whitelist vpc generated bucket |
| s3\_bucket\_whitelist\_vpc\_kms\_key | KMS Key ID of the whitelist vpc generated bucket |
| s3\_bucket\_with\_logging\_arn | ARN of generated S3 bucket with server access logging enabled |
| s3\_bucket\_with\_logging\_id | ID of generated S3 bucket with server access logging enabled |
| s3\_website\_bucket\_arn | ARN of generated S3 bucket with website hosting enabled |
| s3\_website\_bucket\_id | ID of generated S3 bucket with website hosting enabled |

Module usage:

     module "s3" {
        source = "git::https://github.com/UKHomeOffice/acp-tf-s3?ref=master"

        name        = "fake"
        acl         = "private"
        environment = "${var.environment}"
     }



## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| name | The allocated to the s3 bucket in aws | - | yes |
| acl | Amazon control list of access rights to the created bucket | - | yes |
| environment | The environment the RDS is running in i.e. dev, prod etc | - | yes |
| tags | A map of tags to add to all resources | `<map>` | no |

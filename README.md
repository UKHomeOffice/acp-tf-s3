# terraform-docs

[![Build Status](https://github.com/terraform-docs/terraform-docs/workflows/ci/badge.svg)](https://github.com/terraform-docs/terraform-docs/actions) [![GoDoc](https://pkg.go.dev/badge/github.com/terraform-docs/terraform-docs)](https://pkg.go.dev/github.com/terraform-docs/terraform-docs) [![Go Report Card](https://goreportcard.com/badge/github.com/terraform-docs/terraform-docs)](https://goreportcard.com/report/github.com/terraform-docs/terraform-docs) [![Codecov Report](https://codecov.io/gh/terraform-docs/terraform-docs/branch/master/graph/badge.svg)](https://codecov.io/gh/terraform-docs/terraform-docs) [![License](https://img.shields.io/github/license/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/blob/master/LICENSE) [![Latest release](https://img.shields.io/github/v/release/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/releases)

![terraform-docs-teaser](./images/terraform-docs-teaser.png)

Sponsored by [Scalr - Terraform Automation & Collaboration Software](https://scalr.com/?utm_source=terraform-docs)

<a href="https://www.scalr.com/?utm_source=terraform-docs" target="_blank"><img src="https://bit.ly/2T7Qm3U" alt="Scalr - Terraform Automation & Collaboration Software" width="175" height="40" /></a>

## What is terraform-docs

A utility to generate documentation from Terraform modules in various output formats.

## Installation

macOS users can install using [Homebrew]:

```bash
brew install terraform-docs
```

or

```bash
brew install terraform-docs/tap/terraform-docs
```

Windows users can install using [Scoop]:

```bash
scoop bucket add terraform-docs https://github.com/terraform-docs/scoop-bucket
scoop install terraform-docs
```

or [Chocolatey]:

```bash
choco install terraform-docs
```

Stable binaries are also available on the [releases] page. To install, download the
binary for your platform from "Assets" and place this into your `$PATH`:

```bash
curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
mv terraform-docs /usr/local/terraform-docs
```

**NOTE:** Windows releases are in `ZIP` format.

The latest version can be installed using `go install` or `go get`:

```bash
# go1.17+
go install github.com/terraform-docs/terraform-docs@v0.16.0
```

```bash
# go1.16
GO111MODULE="on" go get github.com/terraform-docs/terraform-docs@v0.16.0
```

**NOTE:** please use the latest Go to do this, minimum `go1.16` is required.

This will put `terraform-docs` in `$(go env GOPATH)/bin`. If you encounter the error
`terraform-docs: command not found` after installation then you may need to either add
that directory to your `$PATH` as shown [here] or do a manual installation by cloning
the repo and run `make build` from the repository which will put `terraform-docs` in:

```bash
$(go env GOPATH)/src/github.com/terraform-docs/terraform-docs/bin/$(uname | tr '[:upper:]' '[:lower:]')-amd64/terraform-docs
```

## Usage

### Running the binary directly

To run and generate documentation into README within a directory:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject /path/to/module
```

Check [`output`] configuration for more details and examples.

### Using docker

terraform-docs can be run as a container by mounting a directory with `.tf`
files in it and run the following command:

```bash
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 markdown /terraform-docs
```

If `output.file` is not enabled for this module, generated output can be redirected
back to a file:

```bash
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 markdown /terraform-docs > doc.md
```

**NOTE:** Docker tag `latest` refers to _latest_ stable released version and `edge`
refers to HEAD of `master` at any given point in time.

### Using GitHub Actions

To use terraform-docs GitHub Action, configure a YAML workflow file (e.g.
`.github/workflows/documentation.yml`) with the following:

```yaml
name: Generate terraform docs
on:
  - pull_request

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        ref: ${{ github.event.pull_request.head.ref }}

    - name: Render terraform docs and push changes back to PR
      uses: terraform-docs/gh-actions@main
      with:
        working-dir: .
        output-file: README.md
        output-method: inject
        git-push: "true"
```

Read more about [terraform-docs GitHub Action] and its configuration and
examples.

### pre-commit hook

With pre-commit, you can ensure your Terraform module documentation is kept
up-to-date each time you make a commit.

First [install pre-commit] and then create or update a `.pre-commit-config.yaml`
in the root of your Git repo with at least the following content:

```yaml
repos:
  - repo: https://github.com/terraform-docs/terraform-docs
    rev: "v0.16.0"
    hooks:
      - id: terraform-docs-go
        args: ["markdown", "table", "--output-file", "README.md", "./mymodule/path"]
```

Then run:

```bash
pre-commit install
pre-commit install-hooks
```

Further changes to your module's `.tf` files will cause an update to documentation
when you make a commit.

## Configuration

terraform-docs can be configured with a yaml file. The default name of this file is
`.terraform-docs.yml` and the path order for locating it is:

1. root of module directory
1. `.config/` folder at root of module directory
1. current directory
1. `.config/` folder at current directory
1. `$HOME/.tfdocs.d/`

```yaml
formatter: "" # this is required

version: ""

header-from: main.tf
footer-from: ""

recursive:
  enabled: false
  path: modules

sections:
  hide: []
  show: []

content: ""

output:
  file: ""
  mode: inject
  template: |-
    <!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_self_serve_access_keys"></a> [self\_serve\_access\_keys](#module\_self\_serve\_access\_keys) | git::https://github.com/UKHomeOffice/acp-tf-self-serve-access-keys | v0.2.0 |

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
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_accelerate_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.enforce_tls_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.s3_website_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.aes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
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
| <a name="input_block_public_access"></a> [block\_public\_access](#input\_block\_public\_access) | Blocks all public access to the bucket | `bool` | `false` | no |
| <a name="input_bucket_iam_user"></a> [bucket\_iam\_user](#input\_bucket\_iam\_user) | The name of the iam user assigned to the created s3 bucket | `any` | n/a | yes |
| <a name="input_cmk_enable_key_rotation"></a> [cmk\_enable\_key\_rotation](#input\_cmk\_enable\_key\_rotation) | Enables CMK key rotation | `bool` | `true` | no |
| <a name="input_cors_allowed_headers"></a> [cors\_allowed\_headers](#input\_cors\_allowed\_headers) | Specifies which headers are allowed. | `list` | <pre>[<br>  "Authorization"<br>]</pre> | no |
| <a name="input_cors_allowed_methods"></a> [cors\_allowed\_methods](#input\_cors\_allowed\_methods) | Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. | `list` | <pre>[<br>  "GET"<br>]</pre> | no |
| <a name="input_cors_allowed_origins"></a> [cors\_allowed\_origins](#input\_cors\_allowed\_origins) | Specifies which origins are allowed. | `list` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_cors_expose_headers"></a> [cors\_expose\_headers](#input\_cors\_expose\_headers) | Specifies expose header in the response. | `list` | `[]` | no |
| <a name="input_cors_max_age_seconds"></a> [cors\_max\_age\_seconds](#input\_cors\_max\_age\_seconds) | Specifies time in seconds that browser can cache the response for a preflight request. | `string` | `"3000"` | no |
| <a name="input_create_lifecycle_policy"></a> [create\_lifecycle\_policy](#input\_create\_lifecycle\_policy) | States whether the module autocreates the lifecycle policy | `bool` | `true` | no |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | A list of email addresses for key rotation notifications. | `list` | `[]` | no |
| <a name="input_enforce_kms_key_use"></a> [enforce\_kms\_key\_use](#input\_enforce\_kms\_key\_use) | Whether or not to require a PutObject request to specify the KMS key id that was created. Defaults to true. Should only be set to false to emulate the behaviour of v0.x of the module and only until the tenants have changed their code to specify the KMS key id in their requests | `bool` | `true` | no |
| <a name="input_enforce_tls"></a> [enforce\_tls](#input\_enforce\_tls) | Specifies if the bucket will be enforce a TLS bucket policy | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment the S3 is running in i.e. dev, prod etc | `any` | n/a | yes |
| <a name="input_expire_noncurrent_versions"></a> [expire\_noncurrent\_versions](#input\_expire\_noncurrent\_versions) | Allow expiration/retention rules to apply for all non-current version objects | `bool` | `true` | no |
| <a name="input_iam_user_policy_name"></a> [iam\_user\_policy\_name](#input\_iam\_user\_policy\_name) | The policy name of attached to the user | `any` | n/a | yes |
| <a name="input_key_rotation"></a> [key\_rotation](#input\_key\_rotation) | Enable email notifications for old IAM keys. | `bool` | `true` | no |
| <a name="input_kms_alias"></a> [kms\_alias](#input\_kms\_alias) | The alias name for the kms key used to encrypt and decrypt the created S3 bucket objects | `string` | `""` | no |
| <a name="input_kms_key_policy"></a> [kms\_key\_policy](#input\_kms\_key\_policy) | KMS key policy (uses a default policy if omitted) | `string` | `""` | no |
| <a name="input_lifecycle_abort_multipart_upload_enabled"></a> [lifecycle\_abort\_multipart\_upload\_enabled](#input\_lifecycle\_abort\_multipart\_upload\_enabled) | Specifies Abort Multipart Uploads lifecycle rule status. | `bool` | `false` | no |
| <a name="input_lifecycle_abort_multipart_upload_object_prefix"></a> [lifecycle\_abort\_multipart\_upload\_object\_prefix](#input\_lifecycle\_abort\_multipart\_upload\_object\_prefix) | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| <a name="input_lifecycle_abort_multipart_upload_object_tags"></a> [lifecycle\_abort\_multipart\_upload\_object\_tags](#input\_lifecycle\_abort\_multipart\_upload\_object\_tags) | Object tags to filter on for the abort multipart upload lifecycle rule. | `map` | `{}` | no |
| <a name="input_lifecycle_days_to_abort_multipart_upload"></a> [lifecycle\_days\_to\_abort\_multipart\_upload](#input\_lifecycle\_days\_to\_abort\_multipart\_upload) | Specifies the number of days after which Amazon S3 aborts an incomplete multipart upload. | `string` | `"7"` | no |
| <a name="input_lifecycle_days_to_expiration"></a> [lifecycle\_days\_to\_expiration](#input\_lifecycle\_days\_to\_expiration) | Specifies the number of days after object creation when the object expires. | `string` | `"365"` | no |
| <a name="input_lifecycle_days_to_glacier_deep_archive_transition"></a> [lifecycle\_days\_to\_glacier\_deep\_archive\_transition](#input\_lifecycle\_days\_to\_glacier\_deep\_archive\_transition) | Specifies the number of days after object creation when it will be moved to Glacier storage. | `string` | `"180"` | no |
| <a name="input_lifecycle_days_to_glacier_transition"></a> [lifecycle\_days\_to\_glacier\_transition](#input\_lifecycle\_days\_to\_glacier\_transition) | Specifies the number of days after object creation when it will be moved to Glacier storage. | `string` | `"180"` | no |
| <a name="input_lifecycle_days_to_infrequent_storage_transition"></a> [lifecycle\_days\_to\_infrequent\_storage\_transition](#input\_lifecycle\_days\_to\_infrequent\_storage\_transition) | Specifies the number of days after object creation when it will be moved to standard infrequent access storage. | `string` | `"60"` | no |
| <a name="input_lifecycle_expiration_enabled"></a> [lifecycle\_expiration\_enabled](#input\_lifecycle\_expiration\_enabled) | Specifies expiration lifecycle rule status. | `bool` | `false` | no |
| <a name="input_lifecycle_expiration_object_prefix"></a> [lifecycle\_expiration\_object\_prefix](#input\_lifecycle\_expiration\_object\_prefix) | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| <a name="input_lifecycle_expiration_object_tags"></a> [lifecycle\_expiration\_object\_tags](#input\_lifecycle\_expiration\_object\_tags) | Object tags to filter on for the expire object lifecycle rule. | `map` | `{}` | no |
| <a name="input_lifecycle_glacier_deep_archive_object_prefix"></a> [lifecycle\_glacier\_deep\_archive\_object\_prefix](#input\_lifecycle\_glacier\_deep\_archive\_object\_prefix) | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| <a name="input_lifecycle_glacier_deep_archive_object_tags"></a> [lifecycle\_glacier\_deep\_archive\_object\_tags](#input\_lifecycle\_glacier\_deep\_archive\_object\_tags) | Object tags to filter on for the transition to glacier lifecycle rule. | `map` | `{}` | no |
| <a name="input_lifecycle_glacier_deep_archive_transition_enabled"></a> [lifecycle\_glacier\_deep\_archive\_transition\_enabled](#input\_lifecycle\_glacier\_deep\_archive\_transition\_enabled) | Specifies Glacier Deep Archive transition lifecycle rule status. | `bool` | `false` | no |
| <a name="input_lifecycle_glacier_object_prefix"></a> [lifecycle\_glacier\_object\_prefix](#input\_lifecycle\_glacier\_object\_prefix) | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| <a name="input_lifecycle_glacier_object_tags"></a> [lifecycle\_glacier\_object\_tags](#input\_lifecycle\_glacier\_object\_tags) | Object tags to filter on for the transition to glacier lifecycle rule. | `map` | `{}` | no |
| <a name="input_lifecycle_glacier_transition_enabled"></a> [lifecycle\_glacier\_transition\_enabled](#input\_lifecycle\_glacier\_transition\_enabled) | Specifies Glacier transition lifecycle rule status. | `bool` | `false` | no |
| <a name="input_lifecycle_infrequent_storage_object_prefix"></a> [lifecycle\_infrequent\_storage\_object\_prefix](#input\_lifecycle\_infrequent\_storage\_object\_prefix) | Object key prefix identifying one or more objects to which the lifecycle rule applies. | `string` | `""` | no |
| <a name="input_lifecycle_infrequent_storage_object_tags"></a> [lifecycle\_infrequent\_storage\_object\_tags](#input\_lifecycle\_infrequent\_storage\_object\_tags) | Object tags to filter on for the transition to infrequent storage lifecycle rule. | `map` | `{}` | no |
| <a name="input_lifecycle_infrequent_storage_transition_enabled"></a> [lifecycle\_infrequent\_storage\_transition\_enabled](#input\_lifecycle\_infrequent\_storage\_transition\_enabled) | Specifies infrequent storage transition lifecycle rule status. | `bool` | `false` | no |
| <a name="input_log_target_bucket"></a> [log\_target\_bucket](#input\_log\_target\_bucket) | The S3 bucket that access logs should be sent to. | `string` | `""` | no |
| <a name="input_log_target_prefix"></a> [log\_target\_prefix](#input\_log\_target\_prefix) | The object prefix for access logs | `string` | `""` | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Specifies whether server access logging is enabled or not. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | A descriptive name for the S3 instance | `any` | n/a | yes |
| <a name="input_number_of_users"></a> [number\_of\_users](#input\_number\_of\_users) | The number of user to generate credentials for | `number` | `1` | no |
| <a name="input_ownership_controls"></a> [ownership\_controls](#input\_ownership\_controls) | Ownership controls for the writer must be defined by default | `string` | `"ObjectWriter"` | no |
| <a name="input_ownership_controls_object"></a> [ownership\_controls\_object](#input\_ownership\_controls\_object) | control\_object\_ownership needs to be set to true | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map` | `{}` | no |
| <a name="input_transition_noncurrent_versions"></a> [transition\_noncurrent\_versions](#input\_transition\_noncurrent\_versions) | Allow lifecycle rules to apply for all non-current version objects | `bool` | `true` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | If versioning is set for buckets in case of accidental deletion; deprecated - use versioning\_status instead | `bool` | `false` | no |
| <a name="input_versioning_status"></a> [versioning\_status](#input\_versioning\_status) | The versioning status for the bucket - valid values are: Enabled, Disabled and Suspended | `string` | `""` | no |
| <a name="input_website_error_document"></a> [website\_error\_document](#input\_website\_error\_document) | The path to the document to return in case of a 4XX error for static website hosting | `string` | `"error.html"` | no |
| <a name="input_website_hosting"></a> [website\_hosting](#input\_website\_hosting) | Specifies if the bucket will be used for static website hosting | `bool` | `false` | no |
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
<!-- END_TF_DOCS -->

output-values:
  enabled: false
  from: ""

sort:
  enabled: true
  by: name

settings:
  anchor: true
  color: true
  default: true
  description: false
  escape: true
  hide-empty: false
  html: true
  indent: 2
  lockfile: true
  read-comments: true
  required: true
  sensitive: true
  type: true
```

## Content Template

Generated content can be customized further away with `content` in configuration.
If the `content` is empty the default order of sections is used.

Compatible formatters for customized content are `asciidoc` and `markdown`. `content`
will be ignored for other formatters.

`content` is a Go template with following additional variables:

- `{{ .Header }}`
- `{{ .Footer }}`
- `{{ .Inputs }}`
- `{{ .Modules }}`
- `{{ .Outputs }}`
- `{{ .Providers }}`
- `{{ .Requirements }}`
- `{{ .Resources }}`

and following functions:

- `{{ include "relative/path/to/file" }}`

These variables are the generated output of individual sections in the selected
formatter. For example `{{ .Inputs }}` is Markdown Table representation of _inputs_
when formatter is set to `markdown table`.

Note that sections visibility (i.e. `sections.show` and `sections.hide`) takes
precedence over the `content`.

Additionally there's also one extra special variable avaialble to the `content`:

- `{{ .Module }}`

As opposed to the other variables mentioned above, which are generated sections
based on a selected formatter, the `{{ .Module }}` variable is just a `struct`
representing a [Terraform module].

````yaml
content: |-
  Any arbitrary text can be placed anywhere in the content

  {{ .Header }}

  and even in between sections

  {{ .Providers }}

  and they don't even need to be in the default order

  {{ .Outputs }}

  include any relative files

  {{ include "relative/path/to/file" }}

  {{ .Inputs }}

  # Examples

  ```hcl
  {{ include "examples/foo/main.tf" }}
  ```

  ## Resources

  {{ range .Module.Resources }}
  - {{ .GetMode }}.{{ .Spec }} ({{ .Position.Filename }}#{{ .Position.Line }})
  {{- end }}
````

## Build on top of terraform-docs

terraform-docs primary use-case is to be utilized as a standalone binary, but
some parts of it is also available publicly and can be imported in your project
as a library.

```go
import (
    "github.com/terraform-docs/terraform-docs/format"
    "github.com/terraform-docs/terraform-docs/print"
    "github.com/terraform-docs/terraform-docs/terraform"
)

// buildTerraformDocs for module root `path` and provided content `tmpl`.
func buildTerraformDocs(path string, tmpl string) (string, error) {
    config := print.DefaultConfig()
    config.ModuleRoot = path // module root path (can be relative or absolute)

    module, err := terraform.LoadWithOptions(config)
    if err != nil {
        return "", err
    }

    // Generate in Markdown Table format
    formatter := format.NewMarkdownTable(config)

    if err := formatter.Generate(module); err != nil {
        return "", err
    }

    // // Note: if you don't intend to provide additional template for the generated
    // // content, or the target format doesn't provide templating (e.g. json, yaml,
    // // xml, or toml) you can use `Content()` function instead of `Render()`.
    // // `Content()` returns all the sections combined with predefined order.
    // return formatter.Content(), nil

    return formatter.Render(tmpl)
}
```

## Plugin

Generated output can be heavily customized with [`content`], but if using that
is not enough for your use-case, you can write your own plugin.

In order to install a plugin the following steps are needed:

- download the plugin and place it in `~/.tfdocs.d/plugins` (or `./.tfdocs.d/plugins`)
- make sure the plugin file name is `tfdocs-format-<NAME>`
- modify [`formatter`] of `.terraform-docs.yml` file to be `<NAME>`

**Important notes:**

- if the plugin file name is different than the example above, terraform-docs won't
be able to to pick it up nor register it properly
- you can only use plugin thorough `.terraform-docs.yml` file and it cannot be used
with CLI arguments

To create a new plugin create a new repository called `tfdocs-format-<NAME>` with
following `main.go`:

```go
package main

import (
    _ "embed" //nolint

    "github.com/terraform-docs/terraform-docs/plugin"
    "github.com/terraform-docs/terraform-docs/print"
    "github.com/terraform-docs/terraform-docs/template"
    "github.com/terraform-docs/terraform-docs/terraform"
)

func main() {
    plugin.Serve(&plugin.ServeOpts{
        Name:    "<NAME>",
        Version: "0.1.0",
        Printer: printerFunc,
    })
}

//go:embed sections.tmpl
var tplCustom []byte

// printerFunc the function being executed by the plugin client.
func printerFunc(config *print.Config, module *terraform.Module) (string, error) {
    tpl := template.New(config,
        &template.Item{Name: "custom", Text: string(tplCustom)},
    )

    rendered, err := tpl.Render("custom", module)
    if err != nil {
        return "", err
    }

    return rendered, nil
}
```

Please refer to [tfdocs-format-template] for more details. You can create a new
repository from it by clicking on `Use this template` button.

## Documentation

- **Users**
  - Read the [User Guide] to learn how to use terraform-docs
  - Read the [Formats Guide] to learn about different output formats of terraform-docs
  - Refer to [Config File Reference] for all the available configuration options
- **Developers**
  - Read [Contributing Guide] before submitting a pull request

Visit [our website] for all documentation.

## Community

- Discuss terraform-docs on [Slack]

## License

MIT License - Copyright (c) 2021 The terraform-docs Authors.

[Chocolatey]: https://www.chocolatey.org
[Config File Reference]: https://terraform-docs.io/user-guide/configuration/
[`content`]: https://terraform-docs.io/user-guide/configuration/content/
[Contributing Guide]: CONTRIBUTING.md
[Formats Guide]: https://terraform-docs.io/reference/terraform-docs/
[`formatter`]: https://terraform-docs.io/user-guide/configuration/formatter/
[here]: https://golang.org/doc/code.html#GOPATH
[Homebrew]: https://brew.sh
[install pre-commit]: https://pre-commit.com/#install
[`output`]: https://terraform-docs.io/user-guide/configuration/output/
[releases]: https://github.com/terraform-docs/terraform-docs/releases
[Scoop]: https://scoop.sh/
[Slack]: https://slack.terraform-docs.io/
[terraform-docs GitHub Action]: https://github.com/terraform-docs/gh-actions
[Terraform module]: https://pkg.go.dev/github.com/terraform-docs/terraform-docs/terraform#Module
[tfdocs-format-template]: https://github.com/terraform-docs/tfdocs-format-template
[our website]: https://terraform-docs.io/
[User Guide]: https://terraform-docs.io/user-guide/introduction/

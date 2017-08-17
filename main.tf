
data "aws_caller_identity" "current" { }

resource "aws_s3_bucket" "s3_bucket" {
  
  bucket = "${var.name}"
  acl    = "${var.acl}"
  policy = "${data.aws_iam_policy_document.s3_bucket_policy_document.json}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.environment, var.name)), map("Env", var.environment), map("KubernetesCluster", var.environment))}"  

}

data "aws_iam_policy_document" "s3_bucket_policy_document" {
  policy_id = "TerraformPolicy"

  statement {
    sid    = "BucketAccess"
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [
      "arn:aws:s3:::${var.name}/*",
    ]

    principals {
      type = "AWS"

      identifiers = ["*"]
    }
  }
}


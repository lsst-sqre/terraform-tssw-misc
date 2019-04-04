locals {
  sal_obj_bucket      = "sal-objects"
  sal_obj_logs_bucket = "${local.sal_obj_bucket}-logs"

  sal_topic_bucket      = "sal-topic-registry"
  sal_topic_logs_bucket = "${local.sal_topic_bucket}-logs"
}

resource "aws_s3_bucket" "sal_obj" {
  bucket        = "${local.sal_obj_bucket}"
  acl           = "public-read"
  force_destroy = false

  versioning {
    enabled = false
  }

  logging {
    target_bucket = "${aws_s3_bucket.sal_obj_logs.id}"
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket_metric" "sal_obj" {
  bucket = "${aws_s3_bucket.sal_obj.id}"
  name   = "EntireBucket"
}

resource "aws_s3_bucket" "sal_obj_logs" {
  bucket        = "${local.sal_obj_logs_bucket}"
  acl           = "log-delivery-write"
  force_destroy = false
}

resource "aws_s3_bucket" "sal_topic" {
  bucket        = "${local.sal_topic_bucket}"
  acl           = "public-read"
  force_destroy = false

  versioning {
    enabled = false
  }

  logging {
    target_bucket = "${aws_s3_bucket.sal_topic_logs.id}"
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket_metric" "sal_topic" {
  bucket = "${aws_s3_bucket.sal_topic.id}"
  name   = "EntireBucket"
}

resource "aws_s3_bucket" "sal_topic_logs" {
  bucket        = "${local.sal_topic_logs_bucket}"
  acl           = "log-delivery-write"
  force_destroy = false
}

data "template_file" "tssw_iam_policy" {
  template = "${file("${path.module}/tssw-iam-policy.json")}"

  vars {
    sal_obj_arn   = "${aws_s3_bucket.sal_obj.arn}"
    sal_topic_arn = "${aws_s3_bucket.sal_topic.arn}"
  }
}

module "tssw_user" {
  source = "git::https://github.com/lsst-sqre/terraform-aws-iam-user"

  name = "tssw"

  policy = "${data.template_file.tssw_iam_policy.rendered}"
}

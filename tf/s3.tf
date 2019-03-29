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

module "tssw_user" {
  source = "git::https://github.com/lsst-sqre/terraform-aws-iam-user"

  name = "tssw"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.sal_obj.arn}/*",
        "${aws_s3_bucket.sal_topic.arn}/*"
      ]
    },
    {
      "Sid": "2",
      "Effect": "Allow",
      "Action": [
        "s3:ListObjects",
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.sal_obj.arn}/*",
        "${aws_s3_bucket.sal_topic.arn}/*"
      ]
    }
  ]
}
EOF
}

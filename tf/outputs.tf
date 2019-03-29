output "TSSW_USER" {
  value = "${module.tssw_user.name}"
}

output "TSSW_USER_AWS_ACCESS_KEY_ID" {
  sensitive = true
  value     = "${module.tssw_user.id}"
}

output "TSSW_USER_AWS_SECRET_ACCESS_KEY" {
  sensitive = true
  value     = "${module.tssw_user.secret}"
}

output "SAL_OBJECTS_S3_BUCKET" {
  value = "${aws_s3_bucket.sal_obj.id}"
}

output "SAL_TOPIC_REGISTRY_BUCKET" {
  value = "${aws_s3_bucket.sal_topic.id}"
}

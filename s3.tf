resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.project_name}-${data.aws_caller_identity.current.account_id}-test-bucket"
}

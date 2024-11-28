data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    Environment = "${var.env}"
    BuildingBlock = "${var.building_block}"
  }
  storage_bucket = "${var.building_block}-${var.env}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = local.storage_bucket
  tags = merge(
    {
      Name = local.storage_bucket
    },
    local.common_tags,
    var.additional_tags)
}

resource "aws_s3_bucket_cors_configuration" "storage_bucket_cors" {
  bucket = aws_s3_bucket.storage_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket" "s3_backups_bucket" {
  bucket = "backups-${local.storage_bucket}"
  tags = merge(
    {
      Name = "backups-${local.storage_bucket}"
    },
    local.common_tags,
    var.additional_tags)
}
output "s3_bucket" {
  value = aws_s3_bucket.storage_bucket.bucket
}

output "s3_backups_bucket" {
  value = aws_s3_bucket.s3_backups_bucket.bucket
}
output "s3_name" {
    value   = aws_s3_bucket.main.*.bucket
}
output "s3_arn" {
    value   = aws_s3_bucket.main.*.arn
}
output "s3_acl" {
    value   = aws_s3_bucket.main.*.acl
}
output "s3_region" {
    value   = aws_s3_bucket.main.*.region
}

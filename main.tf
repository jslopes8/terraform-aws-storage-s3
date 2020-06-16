# S3 Storage to terraform remote state
resource "aws_s3_bucket" "main" {
    count   = var.create_bucket ? 1 : 0

    bucket              = var.bucket
    bucket_prefix       = var.bucket_prefix
    acl                 = var.acl
    force_destroy       = var.force_destroy
    acceleration_status = var.acceleration_status
    region              = var.region
    request_payer       = var.request_payer

    tags = var.default_tags

    dynamic "lifecycle_rule" {
        for_each = var.lifecycle_rule
        content {
            id                                     = lookup(lifecycle_rule.value, "id", null)
            prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
            tags                                   = lookup(lifecycle_rule.value, "tags", null)
            abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
            enabled                                = lifecycle_rule.value.enabled

            dynamic "expiration" {
                for_each = length(keys(lookup(lifecycle_rule.value, "expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "expiration", {})]
                content {
                    date                         = lookup(expiration.value, "date", null)
                    days                         = lookup(expiration.value, "days", null)
                    expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", null)
                }
            }
            dynamic "transition" {
                for_each = lookup(lifecycle_rule.value, "transition", [])
                content {
                    date          = lookup(transition.value, "date", null)
                    days          = lookup(transition.value, "days", null)
                    storage_class = transition.value.storage_class
                }   
            }
            dynamic "noncurrent_version_expiration" {
                for_each = length(keys(lookup(lifecycle_rule.value, "noncurrent_version_expiration", {}))) == 0 ? [] : [lookup(lifecycle_rule.value, "noncurrent_version_expiration", {})]
                content {
                    days = lookup(noncurrent_version_expiration.value, "days", null)
                }
            }
            dynamic "noncurrent_version_transition" {
                for_each = lookup(lifecycle_rule.value, "noncurrent_version_transition", [])
                content {
                    days          = lookup(noncurrent_version_transition.value, "days", null)
                    storage_class = noncurrent_version_transition.value.storage_class
                }
            }
        }
    }

    dynamic "server_side_encryption_configuration" {
        for_each = length(keys(var.server_side_encryption_configuration)) == 0 ? [] : [var.server_side_encryption_configuration]
        content {
            dynamic "rule" {
                for_each = length(keys(lookup(server_side_encryption_configuration.value, "rule", {}))) == 0 ? [] : [lookup(server_side_encryption_configuration.value, "rule", {})]
                content {
                    dynamic "apply_server_side_encryption_by_default" {
                        for_each = length(keys(lookup(rule.value, "apply_server_side_encryption_by_default", {}))) == 0 ? [] : [ lookup(rule.value, "apply_server_side_encryption_by_default", {})]
                        content {
                            sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm 
                            kms_master_key_id = lookup(apply_server_side_encryption_by_default.value, "kms_master_key_id", null)
                        }
                    }
                }
            }
        }
    }

    dynamic "versioning" {
        for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]
        content {
            enabled     = lookup(versioning.value, "enabled", null)
            mfa_delete  = lookup(versioning.value, "mfa_delete", null)
        }
    }
}

resource "aws_s3_bucket_public_access_block" "example" {
    count   = var.create_bucket ? length(var.block_public_access) : 0 

    bucket = aws_s3_bucket.main.0.id

    block_public_acls       = var.block_public_access[count.index]["block_public_acls"]
    block_public_policy     = var.block_public_access[count.index]["block_public_policy"]
    ignore_public_acls      = var.block_public_access[count.index]["ignore_public_acls"]
    restrict_public_buckets = var.block_public_access[count.index]["restrict_public_buckets"]
}
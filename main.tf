resource "aws_s3_bucket_policy" "main" {
  count = var.create_bucket ? length(var.bucket_policy) : 0

  depends_on = [aws_s3_bucket.main]

  bucket = aws_s3_bucket.main.0.id
  policy = data.aws_iam_policy_document.role_policy.json
}
data "aws_iam_policy_document" "role_policy" {
  dynamic "statement" {
    for_each = var.bucket_policy

    content {
      sid         = lookup(statement.value, "sid", null)
      effect      = lookup(statement.value, "effect", null)
      actions     = lookup(statement.value, "actions", null)
      not_actions = lookup(statement.value, "not_actions", null)
      resources   = lookup(statement.value, "resources", null)

      dynamic "condition" {
        for_each = length(keys(lookup(statement.value, "condition", {}))) == 0 ? [] : [lookup(statement.value, "condition", {})]
        content {
          test     = lookup(condition.value, "test", null)
          variable = lookup(condition.value, "variable", null)
          values   = lookup(condition.value, "values", null)

        }
      }

      dynamic "principals" {
        for_each = length(keys(lookup(statement.value, "principals", {}))) == 0 ? [] : [lookup(statement.value, "principals", {})]
        content {
          type        = lookup(principals.value, "type", null)
          identifiers = lookup(principals.value, "identifiers", null)
        }
      }
    }
  }
}

resource "aws_s3_bucket" "main" {
  count = var.create_bucket ? 1 : 0

  bucket              = var.bucket_name
  bucket_prefix       = var.bucket_prefix
  acl                 = var.bucket_acl
  force_destroy       = var.force_destroy
  acceleration_status = var.acceleration_status
  request_payer       = var.request_payer

  tags = var.default_tags

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    content {
      id                                     = lookup(lifecycle_rule.value, "id", null)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      tags                                   = lookup(lifecycle_rule.value, "default_tags", null)
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
    for_each = var.server_side_encryption == true ? [1] : []
    content {
      dynamic "rule" {
        for_each = var.encryption_type_sse_s3 == true ? [1] : []
        content {
          apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
          }
        }
      }
      dynamic "rule" {
        for_each = var.encryption_type_sse_kms == true ? [1] : []
        content {
          apply_server_side_encryption_by_default {
            sse_algorithm     = "aws:kms"
            kms_master_key_id = var.kms_master_key_arn
          }
        }
      }
    }
  }

  dynamic "versioning" {
    for_each = var.enable_bucket_versioning == true ? [1] : []
    content {
      enabled = "true"
    }
  }

  dynamic "object_lock_configuration" {
    for_each = length(keys(var.bucket_object_lock)) == 0 ? [] : [var.bucket_object_lock]
    content {
      object_lock_enabled = lookup(object_lock_configuration.value, "object_lock_enabled", null)

      dynamic "rule" {
        for_each = length(keys(lookup(object_lock_configuration.value, "rule", {}))) == 0 ? [] : [lookup(object_lock_configuration.value, "rule", {})]
        content {
          dynamic "default_retention" {
            for_each = length(keys(lookup(rule.value, "default_retention", {}))) == 0 ? [] : [lookup(rule.value, "default_retention", {})]
            content {
              mode  = default_retention.value.mode
              days  = lookup(default_retention.value, "days", null)
              years = lookup(default_retention.value, "years", null)
            }
          }
        }
      }
    }
  }

  dynamic "cors_rule" {
    for_each = var.bucket_cors_rule
    content {
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      allowed_methods = lookup(cors_rule.value, "allowed_methods", null)
      allowed_origins = lookup(cors_rule.value, "allowed_origins", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  count = var.create_bucket ? length(var.block_public_access) : 0

  depends_on = [aws_s3_bucket.main, aws_s3_bucket_policy.main]

  bucket                  = aws_s3_bucket.main.0.id
  block_public_acls       = var.block_public_access[count.index]["block_public_acls"]
  block_public_policy     = var.block_public_access[count.index]["block_public_policy"]
  ignore_public_acls      = var.block_public_access[count.index]["ignore_public_acls"]
  restrict_public_buckets = var.block_public_access[count.index]["restrict_public_buckets"]
}

resource "aws_s3_bucket_public_access_block" "all_public_access" {
  count = var.create_bucket && var.block_all_public_access ? 1 : 0

  depends_on = [aws_s3_bucket.main, aws_s3_bucket_policy.main]

  bucket                  = aws_s3_bucket.main.0.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "main" {
  depends_on = [aws_s3_bucket.main]

  count = var.create_bucket ? length(var.bucket_object) : 0

  bucket        = aws_s3_bucket.main.0.id
  key           = var.bucket_object[count.index]["key"]
  source        = lookup(var.bucket_object[count.index], "source", null)
  force_destroy = lookup(var.bucket_object[count.index], "force_destroy", null)

  server_side_encryption = lookup(var.bucket_object[count.index], "server_side_encryption", null)
  storage_class          = lookup(var.bucket_object[count.index], "storage_class", null)

  object_lock_legal_hold_status = lookup(var.bucket_object[count.index], "legal_hold", null)
  object_lock_mode              = lookup(var.bucket_object[count.index], "retention_mode", null)
  object_lock_retain_until_date = lookup(var.bucket_object[count.index], "retain_until", null)

}

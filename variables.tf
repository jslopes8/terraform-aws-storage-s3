variable "create_bucket" {
  type    = bool
  default = true
}
variable "bucket_policy" {
  type    = any
  default = []
}
variable "bucket_name" {
  type = string
}
variable "bucket_prefix" {
  type    = string
  default = null
}
variable "bucket_acl" {
  type    = string
  default = "private"
}
variable "force_destroy" {
  type    = bool
  default = false
}
variable "request_payer" {
  type    = string
  default = null
}
variable "acceleration_status" {
  type    = string
  default = null
}
variable "enable_bucket_versioning" {
  type    = bool
  default = false
}
variable "lifecycle_rule" {
  type    = any
  default = []
}
variable "block_public_access" {
  type    = list(map(string))
  default = []
}
variable "block_all_public_access" {
  type = bool
  default = true
}
variable "kms_master_key_arn" {
  type    = string
  default = null
}
variable "server_side_encryption" {
  type    = bool
  default = false
}
variable "encryption_type_sse_kms" {
  type    = bool
  default = false
}
variable "encryption_type_sse_s3" {
  type    = bool
  default = false
}
variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "bucket_object_lock" {
  type    = any
  default = {}
}
variable "bucket_object" {
  type    = any
  default = []
}
variable "bucket_cors_rule" {
  type    = any
  default = []
}

variable "create_bucket" {
    type    = bool
    default = true
}
variable "bucket_policy" {
    type    = any
    default = []
}
variable "bucket" {
    type    = string
    default = null
}
variable "bucket_prefix" {
    type    =  string
    default = null
}
variable "acl" {
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
variable "versioning" {
    type    = map(string)
    default = {}
}
variable "lifecycle_rule" {
    type    = any
    default = []
}
variable "block_public_access" {
    type    = list(map(string))
    default = []
}
variable "server_side_encryption_configuration" {
    type    = any
    default = {}
}
variable "default_tags" {
    type    = map(string)
    default = {}
}

variable "object_lock_configuration" {
    type    = any
    default = {}
}
variable "bucket_object" {
    type    = any
    default = []
}

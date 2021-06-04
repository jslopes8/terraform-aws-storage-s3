# Terraform AWS S3 Bucket
Provides a S3 bucket resource.

The code will provide the following resources
* [S3 Bucket](https://www.terraform.io/docs/providers/aws/r/s3_bucket.html)
* [S3 Account Public Access Block](https://www.terraform.io/docs/providers/aws/r/s3_account_public_access_block.html)
* [S3 Bucket Policy](https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html)
* [S3 Bucket Object](https://www.terraform.io/docs/providers/aws/r/s3_bucket_object.html)

This module for creating of the s3 bucket have support for following configuration

- `versioning`
- `server_side_encryption_configuration`
- `lifecycle_rule`
- `block_public_access`
- `object_lock_configuration`
- `bucket_object`


## Usage

Example of the use: Criating an S3 Bucket
```hcl
module "s3_bucket" {
    source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v1.0"

    bucket          = "s3-bucket-name"
    acl             = "private"
    region          = "us-east-1"

}
```
Example of the use: Criating an S3 Bucket with encryption configuration
```hcl
module "s3_bucket" {
    source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v1.0"

...

    server_side_encryption_configuration    = {
        rule  = {
            apply_server_side_encryption_by_default = {
                sse_algorithm = "AES256"
            }
        }
    }
}
```
Example of the use: Criating an S3 Bucket with block public access configuration
```hcl
module "s3_bucket" {
    source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v1.0"

...

    block_public_access = [
        {
            block_public_acls       = "true"
            block_public_policy     = "true"
        }
    ]
}
```
Example of the use: Criating an S3 Bucket with bucket policy configuration
```hcl
module "s3_bucket" {
    source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v1.0"

...

    bucket_policy   = [
        {
            sid     = "AWSCloudTrailAclCheck"
            effect  = "Allow"
            actions = [ 
                "s3:GetBucketAcl",
            ]
            principals  = {
                type = "Service"
                identifiers = [ "cloudtrail.amazonaws.com" ]
            }
            resources   = [
                "arn:aws:s3:::*"
            ]
        }
    ]
}
```

## Requirements

| Name | Version |
| ---- | ------- |
| aws | ~> 2.67 |
| terraform | 0.12 |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Variables Inputs
| Name | Description | Required | Type | Default |
| ---- | ----------- | -------- | ---- | ------- |
| bucket | The name bucket to created. | `yes` | `string` | ` ` |
| bucket_prefix | Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket. | `no` | `string` | ` ` |
| acl | The canned ACL to apply. Defaults to "private". | `no` | `string` | `private` |
| force_destroy | A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `no` | `bool` | `false` |
| acceleration_status | Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended. | `no` | `string` | ` ` |
| region | If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee. | `yes` | `string` | ` ` |
| default_tags | A map of tags to assign to the bucket. | `no` | `map(string)` | `{}` |
| lifecycle_rule | A configuration of object lifecycle management. | `no` | `any` | `[ ]` |
| server_side_encryption_configuration | Amazon S3 default encryption provides a way to set the default encryption behavior for an S3 bucket. | `no` | `any` | `{ }` |
| versioning | A state of versioning | `no` | `any` | `{ }` |
| block_public_access | S3 Block Public Access provides four settings for access points, buckets, and accounts to help you manage public access to Amazon S3 resources. | `no` | `map` | `[ ]` | 
| bucket_policy | S3 Bucket Policy block Attaches a policy to an S3 bucket resource | `no` | `map` | `[ ]` | 
| object_lock_configuration | Indicates whether this bucket has an Object Lock configuration enabled. | `no` | `map` | `{ }` |
| bucket_object | S3 Object Lock | `no` | `any` | `[ ]` |

## Reference for of the attributes
The `versioning` block have the following attributes;

- `enabled`: (Optional) Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket.
- `mfa_delete`: Optional) Enable MFA delete for either Change the versioning state of your bucket or Permanently delete an object version. Default is false.

The `server_side_encryption_configuration` block have the following attributes;

- `rule`: (required) A single object for server-side encryption by default configuration.
    - `apply_server_side_encryption_by_default`: (required) A single object for setting server-side encryption by default.
        - `sse_algorithm`: (required) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms.
        - `kms_master_key_id`: (optional) The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3.

The `lifecycle_rule` block have the following attributes;

- `id`: Unique identifier for the rule.
- `default_tags`: Specifies object tags key and value.
- `enabled`: Specifies lifecycle rule status.
- `abort_incomplete_multipart_upload_days`: Specifies the number of days after initiating a multipart upload when the multipart upload must be completed.

    -  `expiration`: Specifies a period in the object's expire
        - `date`: Specifies the date after which you want the corresponding action to take effect.
        - `days`: Specifies the number of days after object creation when the specific rule action takes effect.
        - `expired_object_delete_marker`: On a versioned bucket (versioning-enabled or versioning-suspended bucket), you can add this element in the lifecycle configuration to direct Amazon S3 to delete expired object delete markers.

    - `transition`: Specifies a period in the object's transitions
        - `date`: Specifies the date after which you want the corresponding action to take effect.
        - `days`: Specifies the number of days after object creation when the specific rule action takes effect.
        - `storage_class`: (Required) Specifies the Amazon S3 storage class to which you want the object to transition. Can be ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, GLACIER, or DEEP_ARCHIVE.

    - `noncurrent_version_expiration`: Specifies when noncurrent object versions expire
        - `days`: (Required) Specifies the number of days noncurrent object versions expire.
    - `noncurrent_version_transition`: Specifies when noncurrent object versions transitions
        - `days`: (Required) Specifies the number of days noncurrent object versions transition.
        - `storage_class`:  (Required) Specifies the Amazon S3 storage class to which you want the noncurrent object versions to transition. Can be ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, GLACIER, or DEEP_ARCHIVE.

The `block_public_access` block have the following attributes;

- `block_public_acls`: prevent any new operation from making buckets or objects public through Bucket or object ACLs.
- `ignore_public_acls`: ignore all public ACLs in a bucket and all objects it contains
- `block_public_policy`: reject calls to the PUT Bucket policy if the specified bucket policy allows public access.
- `restrict_public_buckets`: restrict access to a bucket with a public policy only for AWS services and authorized users in the bucket owner's account. 

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| s3_name | The named of the bucket. |
| s3_arn | The ARN of the bucket. |
| s3_region | The AWS region this bucket resides in. | 

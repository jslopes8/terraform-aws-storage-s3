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
  source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v3.5"
	
  bucket_name = "s3-bucket-name"
  bucket_acl  = "private"
}
```
Example of the use: Criating an S3 Bucket with encryption configuration
```bash
module "s3_bucket" {
  source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v3.5"

  # configuraçao geral
  bucket_name = "tf-jslopes-s3-test"
  bucket_acl  = "private"

  # default encryption
  server_side_encryption = true
  encryption_type_sse_s3 = true
}
```
Example of the use: Criating an S3 Bucket with block public access configuration
```bash
module "s3_bucket" {
  source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v3.5"
	
  # configuraçao geral
  bucket_name = "tf-jslopes-s3-test"
  bucket_acl  = "private"

  # block public access
  block_all_public_access  = true
}
```
Example of the use: Criating an S3 Bucket with bucket policy configuration
```bash
module "s3_bucket" {
  source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v3.5"

  # configuraçao geral
  bucket_name = "tf-jslopes-s3-test"
  bucket_acl  = "private"

  bucket_policy   = [
    {
      sid     	= "AWSCloudTrailAclCheck"
      effect  	= "Allow"
      actions 	= [  "s3:GetBucketAcl" ]
      resources   = [ "arn:aws:s3:::*" ]
      principals  = {
        type	= "Service"
        identifiers = [ "cloudtrail.amazonaws.com" ]
      }
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
| bucket_name | The name bucket to created. | `yes` | `string` | ` ` |
| bucket_prefix | Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket. | `no` | `string` | ` ` |
| bucket_acl | The canned ACL to apply. Defaults to "private". | `no` | `string` | `private` |
| force_destroy | A boolean that indicates all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `no` | `bool` | `false` |
| acceleration_status | Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended. | `no` | `string` | ` ` |
| default_tags | A map of tags to assign to the bucket. | `no` | `map(string)` | `{}` |
| lifecycle_rule | A configuration of object lifecycle management. | `no` | `any` | `[ ]` |
| server_side_encryption | Amazon S3 default encryption provides a way to set the default encryption behavior for an S3 bucket. | `no` | `bool` | `false` |
| encryption_type_sse_s3 | Amazon S3 encryption type for SS3-S3. | `no` | `bool` | `false` |
| encryption_type_sse_kms | Amazon S3 encryption type for SS3-KMS. | `no` | `bool` | `false` |
| kms_master_key_arn | Amazon S3 encryption type for SS3-KMS setting of the ARN KMS. | `no` | `string` | `` |
| enable_bucket_versioning | A state of versioning | `no` | `bool` | `false` |
| block_public_access | S3 Block Public Access provides four settings for access points, buckets, and accounts to help you manage public access to Amazon S3 resources. | `no` | `list` | `[ ]` | 
| block_all_public_access | S3 Block Public Access for all access points. | `no` | `bool` | `true` | 
| bucket_policy | S3 Bucket Policy block Attaches a policy to an S3 bucket resource | `no` | `map` | `[ ]` | 
| bucket_object_lock | Indicates whether this bucket has an Object Lock configuration enabled. | `no` | `map` | `{ }` |
| bucket_object | S3 Object Lock | `no` | `any` | `[ ]` |

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

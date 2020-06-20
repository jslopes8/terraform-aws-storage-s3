# AWS S3 Bucket Terraform module

Este module para S3 segue estratégias de segurança com suporte para os seguintes itens;

- `Encryption`: garante que todos os objetos novos sejam criptografados.
ACLs: permitem o gerenciamento do acesso aos buckets e objetos (este item é padrão private usando o terraform). 
- `Versioning`: permitem que você recupere objetos de uma exclusão ou substituição acidental.
- `Block Public ACLs`: impeça qualquer nova operação de tornar públicos buckets ou objetos por meio de Bucket ou ACLs de objeto. (as políticas e ACLs existentes para buckets e objetos não são modificadas.)
- `Ignore Public ACLs`: ignora todas as ACLs públicas em um bucket e todos os objetos que ele contém
- `Block Public Policy`: rejeite chamadas para a política de PUT Bucket se a política de bucket especificada permitir acesso público. (A ativação dessa configuração não afeta as políticas de bucket existentes)
- `Restrict Public Buckets`: restrinja o acesso a um bucket com uma política pública apenas para serviços da AWS e usuários autorizados na conta do proprietário do bucket. 

## Usage
```hcl
module "s3_bucket_security" {
    source  = "git@github.com:Terraform-AWS/terraform-aws-services-s3.git?ref=v1.0"

    bucket          = "s3-bucket-name"
    acl             = "private"
    region          = "us-east-1"

    server_side_encryption_configuration    = {
        rule  = {
            apply_server_side_encryption_by_default = {
                sse_algorithm = "AES256"
            }
        }
    }
    versioning = {
        enabled = "true"
    }
    block_public_access = [
        {
            block_public_acls       = "true"
            block_public_policy     = "true"
            ignore_public_acls      = "true"
            restrict_public_buckets = "true"
        }
    ]

    default_tags = {
        Enviroment  = "Homolog"
    }
}
```

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

## Variable Outputs
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
| Name | Description |
| ---- | ----------- |
| s3_name | The named of the bucket. |
| s3_arn | The ARN of the bucket. |
| s3_region | The AWS region this bucket resides in. | 
# terraform-aws-template

[![Lint Status](https://github.com/DNXLabs/terraform-aws-template/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-template/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-template)](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE)

<!--- BEGIN_TF_DOCS --->

# AWS OpenSearch Terraform Module

Terraform module to provision an OpenSearch cluster with SAML authentication.

## Prerequisites

- A [hosted zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) to route traffic to your OpenSearch domain
- An [entityID and metadata XML](https://aws.amazon.com/de/blogs/security/configure-saml-single-sign-on-for-kibana-with-ad-fs-on-amazon-elasticsearch-service/) from your SAML identity provider

## Features

- Create an AWS OpenSearch cluster with SAML authentication
- All node types with local NVMe for high IO performance are supported
- Create or manage various OpenSearch resources:
  - [Index templates](https://opensearch.org/docs/latest/opensearch/index-templates/)
  - [Indices](https://opensearch.org/docs/latest/opensearch/rest-api/index-apis/create-index/)
  - [ISM policies](https://opensearch.org/docs/latest/im-plugin/ism/policies/)
  - [Roles](https://opensearch.org/docs/latest/security-plugin/access-control/users-roles/#create-roles)
  - [Role mappings](https://opensearch.org/docs/latest/security-plugin/access-control/users-roles/#map-users-to-roles)

## Usage

This example is using Azure AD as SAML identity provider.

```terraform
locals {
  cluster_name      = "opensearch"
  cluster_domain    = "example.com"
  saml_entity_id    = "https://sts.windows.net/XXX-XXX-XXX-XXX-XXX/"
  saml_metadata_url = "https://login.microsoftonline.com/XXX-XXX-XXX-XXX-XXX/federationmetadata/2007-06/federationmetadata.xml?appid=YYY-YYY-YYY-YYY-YYY"
}

data "aws_region" "current" {}

data "http" "saml_metadata" {
  url = local.saml_metadata_url
}

provider "elasticsearch" {
  url                   = "https://${local.cluster_name}.${local.cluster_domain}"
  aws_region            = data.aws_region.current.name
  elasticsearch_version = "7.10.2"
  healthcheck           = false
}

module "opensearch" {
  source = "idealo/opensearch/aws"

  cluster_name    = local.cluster_name
  cluster_domain  = local.cluster_domain
  cluster_version = "1.0"

  saml_entity_id        = local.saml_entity_id
  saml_metadata_content = data.http.saml_metadata.body

  indices = {
    example-index = {
      number_of_shards   = 2
      number_of_replicas = 1
    }
  }
}
```

## Examples

Here is a working example of using this Terraform module:

- [Complete](https://github.com/idealo/terraform-aws-opensearch/tree/main/examples/complete) - Create an AWS OpenSearch cluster with all necessary resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.65 |
| <a name="requirement_elasticsearch"></a> [elasticsearch](#requirement\_elasticsearch) | >= 1.6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_elasticsearch_domain.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_elasticsearch_domain_saml_options.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain_saml_options) | resource |
| [aws_iam_service_linked_role.es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_route53_record.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [elasticsearch_index.index](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/index) | resource |
| [elasticsearch_index_template.index_template](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/index_template) | resource |
| [elasticsearch_opendistro_ism_policy.ism_policy](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opendistro_ism_policy) | resource |
| [elasticsearch_opendistro_role.role](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opendistro_role) | resource |
| [elasticsearch_opendistro_roles_mapping.master_user_arn](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opendistro_roles_mapping) | resource |
| [elasticsearch_opendistro_roles_mapping.role_mapping](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opendistro_roles_mapping) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3. | `number` | `3` | no |
| cluster\_domain | The hosted zone name of the OpenSearch cluster. | `string` | n/a | yes |
| cluster\_name | The name of the OpenSearch cluster. | `string` | `"opensearch"` | no |
| cluster\_version | The version of OpenSearch to deploy. | `string` | `"1.0"` | no |
| create\_service\_role | Indicates whether to create the service-linked role. See https://docs.aws.amazon.com/opensearch-service/latest/developerguide/slr.html | `bool` | `true` | no |
| encrypt\_kms\_key\_id | The KMS key ID to encrypt the OpenSearch cluster with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key. | `string` | `""` | no |
| hot\_instance\_count | The number of dedicated hot nodes in the cluster. | `number` | `3` | no |
| hot\_instance\_type | The type of EC2 instances to run for each hot node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.4xlarge.elasticsearch"` | no |
| index\_files | A set of all index files to create. | `set(string)` | `[]` | no |
| index\_template\_files | A set of all index template files to create. | `set(string)` | `[]` | no |
| index\_templates | A map of all index templates to create. | `map(any)` | `{}` | no |
| indices | A map of all indices to create. | `map(any)` | `{}` | no |
| ism\_policies | A map of all ISM policies to create. | `map(any)` | `{}` | no |
| ism\_policy\_files | A set of all ISM policy files to create. | `set(string)` | `[]` | no |
| master\_instance\_count | The number of dedicated master nodes in the cluster. | `number` | `3` | no |
| master\_instance\_enabled | Indicates whether dedicated master nodes are enabled for the cluster. | `bool` | `true` | no |
| master\_instance\_type | The type of EC2 instances to run for each master node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.large.elasticsearch"` | no |
| master\_user\_arn | The ARN for the master user of the cluster. If not specified, then it defaults to using the IAM user that is making the request. | `string` | `""` | no |
| role\_files | A set of all role files to create. | `set(string)` | `[]` | no |
| role\_mapping\_files | A set of all role mapping files to create. | `set(string)` | `[]` | no |
| role\_mappings | A map of all role mappings to create. | `map(any)` | `{}` | no |
| roles | A map of all roles to create. | `map(any)` | `{}` | no |
| saml\_entity\_id | The unique Entity ID of the application in SAML Identity Provider. | `string` | n/a | yes |
| saml\_metadata\_content | The metadata of the SAML application in xml format. | `string` | n/a | yes |
| saml\_roles\_key | Element of the SAML assertion to use for backend roles. | `string` | `"http://schemas.microsoft.com/ws/2008/06/identity/claims/role"` | no |
| saml\_session\_timeout | Duration of a session in minutes after a user logs in. Default is 60. Maximum value is 1,440. | `number` | `60` | no |
| saml\_subject\_key | Element of the SAML assertion to use for username. | `string` | `"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| vpc\_id | VPC | `string` | n/a | yes |
| warm\_instance\_count | The number of dedicated warm nodes in the cluster. | `number` | `3` | no |
| warm\_instance\_enabled | Indicates whether ultrawarm nodes are enabled for the cluster. | `bool` | `true` | no |
| warm\_instance\_type | The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing | `string` | `"ultrawarm1.large.elasticsearch"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint URL of the OpenSearch cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the OpenSearch cluster. |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The version of the OpenSearch cluster. |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | The endpoint URL of Kibana. |

<!--- END_TF_DOCS --->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/idealo/terraform-aws-opensearch/blob/main/LICENSE) for full details.
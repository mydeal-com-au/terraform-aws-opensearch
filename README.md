# terraform-aws-opensearch

[![Lint Status](https://github.com/DNXLabs/terraform-aws-template/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-template/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-template)](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE)

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

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | > 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | > 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| advanced\_options | Key-value string pairs to specify advanced configuration options. | `map(string)` | `null` | no |
| advanced\_security\_options\_enabled | n/a | `bool` | `true` | no |
| advanced\_security\_options\_internal\_user\_db | n/a | `bool` | `false` | no |
| allow\_cidrs | List of CIDR to allow connection to this Cluster | <pre>list(object({<br>    name        = string<br>    description = string<br>    cidr        = list(string)<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>  }))</pre> | `[]` | no |
| allow\_security\_group\_ids | List of Security Group IDs to allow connection to this Cluster | <pre>list(object({<br>    name              = string<br>    description       = string<br>    security_group_id = string<br>    from_port         = number<br>    to_port           = number<br>    protocol          = string<br>  }))</pre> | `[]` | no |
| availability\_zones | The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3. | `number` | `1` | no |
| cluster\_domain | The hosted zone name of the OpenSearch cluster. | `string` | n/a | yes |
| cluster\_hostname | The hostname name of the OpenSearch cluster. | `string` | n/a | yes |
| cluster\_name | The name of the OpenSearch cluster. | `string` | `"opensearch"` | no |
| cluster\_version | The version of OpenSearch to deploy. | `string` | `"1.1"` | no |
| create\_service\_role | Indicates whether to create the service-linked role. See https://docs.aws.amazon.com/opensearch-service/latest/developerguide/slr.html | `bool` | `true` | no |
| ebs\_enabled | n/a | `bool` | `true` | no |
| ebs\_iops | n/a | `number` | `null` | no |
| ebs\_volume\_size | n/a | `number` | `10` | no |
| ebs\_volume\_type | n/a | `string` | `null` | no |
| enable\_saml\_options | Enable or not saml options | `string` | `true` | no |
| encrypt\_kms\_key\_id | The KMS key ID to encrypt the OpenSearch cluster with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key. | `string` | `""` | no |
| hot\_instance\_count | The number of dedicated hot nodes in the cluster. | `number` | `1` | no |
| hot\_instance\_type | The type of EC2 instances to run for each hot node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.large.elasticsearch"` | no |
| log\_publishing\_options | A list of maps containing log publishing options. | <pre>list(object({<br>    enable                   = bool<br>    cloudwatch_log_group_arn = string<br>    log_type                 = string<br>  }))</pre> | `[]` | no |
| log\_publishing\_options\_cloudwatch\_log\_group\_arn | n/a | `string` | `null` | no |
| log\_publishing\_options\_enable | n/a | `bool` | `null` | no |
| log\_publishing\_options\_log\_type | n/a | `string` | `null` | no |
| master\_instance\_count | The number of dedicated master nodes in the cluster. | `number` | `1` | no |
| master\_instance\_enabled | Indicates whether dedicated master nodes are enabled for the cluster. | `bool` | `true` | no |
| master\_instance\_type | The type of EC2 instances to run for each master node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.large.elasticsearch"` | no |
| master\_user\_arn | The ARN for the master user of the cluster. If not specified, then it defaults to using the IAM user that is making the request. | `string` | `""` | no |
| saml\_entity\_id | The unique Entity ID of the application in SAML Identity Provider. | `string` | n/a | yes |
| saml\_master\_backend\_role | SAML Master backend role. | `string` | `""` | no |
| saml\_master\_user\_name | SAML master user name | `string` | `""` | no |
| saml\_metadata\_content | The metadata of the SAML application in xml format. | `string` | n/a | yes |
| saml\_roles\_key | Element of the SAML assertion to use for backend roles. | `string` | `""` | no |
| saml\_session\_timeout | Duration of a session in minutes after a user logs in. Default is 60. Maximum value is 1,440. | `number` | `60` | no |
| saml\_subject\_key | Element of the SAML assertion to use for username. | `string` | `""` | no |
| subnets\_id | Subnets | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| vpc\_id | VPC | `string` | n/a | yes |
| warm\_instance\_count | The number of dedicated warm nodes in the cluster. | `number` | `1` | no |
| warm\_instance\_enabled | Indicates whether ultrawarm nodes are enabled for the cluster. | `bool` | `false` | no |
| warm\_instance\_type | The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing | `string` | `"ultrawarm1.large.elasticsearch"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_endpoint | The endpoint URL of the OpenSearch cluster. |
| cluster\_name | The name of the OpenSearch cluster. |
| cluster\_version | The version of the OpenSearch cluster. |
| kibana\_endpoint | The endpoint URL of Kibana. |

<!--- END_TF_DOCS --->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/idealo/terraform-aws-opensearch/blob/main/LICENSE) for full details.
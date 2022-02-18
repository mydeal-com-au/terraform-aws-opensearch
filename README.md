# terraform-aws-template

[![Lint Status](https://github.com/DNXLabs/terraform-aws-template/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-template/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-template)](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE)

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | = 3.74.1 |
| elasticsearch | >= 1.6.0 |

## Providers

| Name | Version |
|------|---------|
| aws | = 3.74.1 |

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
| vpc | VPC | `string` | n/a | yes |
| warm\_instance\_count | The number of dedicated warm nodes in the cluster. | `number` | `3` | no |
| warm\_instance\_enabled | Indicates whether ultrawarm nodes are enabled for the cluster. | `bool` | `true` | no |
| warm\_instance\_type | The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing | `string` | `"ultrawarm1.large.elasticsearch"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_endpoint | The endpoint URL of the OpenSearch cluster. |
| cluster\_name | The name of the OpenSearch cluster. |
| cluster\_version | The version of the OpenSearch cluster. |
| kibana\_endpoint | The endpoint URL of Kibana. |

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-template/blob/master/LICENSE) for full details.
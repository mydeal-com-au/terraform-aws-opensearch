variable "cluster_name" {
  description = "The name of the OpenSearch cluster."
  type        = string
  default     = "opensearch"
}

variable "cluster_version" {
  description = "The version of OpenSearch to deploy."
  type        = string
  default     = "1.1"
}

variable "cluster_domain" {
  description = "The hosted zone name of the OpenSearch cluster."
  type        = string
}

variable "cluster_hostname" {
  description = "The hostname name of the OpenSearch cluster."
  type        = string
}

variable "advanced_options" {
  description = "Key-value string pairs to specify advanced configuration options."
  type        = map(string)
  default     = null
}

variable "vpc_id" {
  description = "VPC"
  type        = string

}

variable "subnets_id" {
  description = "Subnets"
  type        = list(string)

}

variable "create_service_role" {
  description = "Indicates whether to create the service-linked role. See https://docs.aws.amazon.com/opensearch-service/latest/developerguide/slr.html"
  type        = bool
  default     = true
}

variable "master_user_arn" {
  description = "The ARN for the master user of the cluster. If not specified, then it defaults to using the IAM user that is making the request."
  type        = string
  default     = ""
}

variable "master_instance_enabled" {
  description = "Indicates whether dedicated master nodes are enabled for the cluster."
  type        = bool
  default     = true
}

variable "master_instance_type" {
  description = "The type of EC2 instances to run for each master node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing"
  type        = string
  default     = "r6gd.large.elasticsearch"
}

variable "master_instance_count" {
  description = "The number of dedicated master nodes in the cluster."
  type        = number
  default     = 1
}

variable "hot_instance_type" {
  description = "The type of EC2 instances to run for each hot node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing"
  type        = string
  default     = "r6gd.large.elasticsearch"
}

variable "hot_instance_count" {
  description = "The number of dedicated hot nodes in the cluster."
  type        = number
  default     = 1
}

variable "warm_instance_enabled" {
  description = "Indicates whether ultrawarm nodes are enabled for the cluster."
  type        = bool
  default     = false
}

variable "warm_instance_type" {
  description = "The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing"
  type        = string
  default     = "ultrawarm1.large.elasticsearch"
}

variable "warm_instance_count" {
  description = "The number of dedicated warm nodes in the cluster."
  type        = number
  default     = 1
}

variable "availability_zones" {
  description = "The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3."
  type        = number
  default     = 1
}

variable "encrypt_kms_key_id" {
  description = "The KMS key ID to encrypt the OpenSearch cluster with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key."
  type        = string
  default     = ""
}

variable "saml_subject_key" {
  description = "Element of the SAML assertion to use for username."
  type        = string
  default     = ""
}

variable "saml_roles_key" {
  description = "Element of the SAML assertion to use for backend roles."
  type        = string
  default     = ""
}

variable "enable_saml_options" {
  description = "Enable or not saml options"
  type        = string
  default     = true
}

variable "saml_entity_id" {
  description = "The unique Entity ID of the application in SAML Identity Provider."
  type        = string
}

variable "saml_metadata_content" {
  description = "The metadata of the SAML application in xml format."
  type        = string
}

variable "saml_session_timeout" {
  description = "Duration of a session in minutes after a user logs in. Default is 60. Maximum value is 1,440."
  type        = number
  default     = 60
}

variable "saml_master_backend_role" {
  description = "SAML Master backend role."
  type        = string
  default     = ""
}

variable "saml_master_user_name" {
  description = "SAML master user name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "ebs_enabled" {
  type    = bool
  default = true
}

variable "ebs_volume_size" {
  type    = number
  default = 10
}

variable "ebs_volume_type" {
  type    = string
  default = null
}

variable "ebs_iops" {
  type    = number
  default = null
}

variable "log_publishing_options_enable" {
  type    = bool
  default = null
}

variable "log_publishing_options_cloudwatch_log_group_arn" {
  type    = string
  default = null
}

variable "log_publishing_options_log_type" {
  type    = string
  default = null
}

variable "allow_security_group_ids" {
  type = list(object({
    name              = string
    description       = string
    security_group_id = string
    from_port         = number
    to_port           = number
    protocol          = string
  }))
  description = "List of Security Group IDs to allow connection to this Cluster"
  default     = []
}

variable "allow_cidrs" {
  type = list(object({
    name        = string
    description = string
    cidr        = list(string)
    from_port   = number
    to_port     = number
    protocol    = string
  }))
  description = "List of CIDR to allow connection to this Cluster"
  default     = []
}

variable "log_publishing_options" {
  description = "A list of maps containing log publishing options."
  type = list(object({
    enable                   = bool
    cloudwatch_log_group_arn = string
    log_type                 = string
  }))
  default = []
}

variable "advanced_security_options_enabled" {
  type    = bool
  default = true
}

variable "advanced_security_options_internal_user_db" {
  type    = bool
  default = false
}
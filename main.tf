

resource "aws_iam_service_linked_role" "es" {
  count            = var.create_service_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}



resource "aws_opensearch_domain" "opensearch" {
  domain_name           = var.cluster_name
  engine_version        = "OpenSearch_${var.cluster_version}"
  access_policies       = data.aws_iam_policy_document.access_policy.json
  advanced_options      = var.advanced_options

  cluster_config {
    dedicated_master_enabled = var.master_instance_enabled
    dedicated_master_count   = var.master_instance_enabled ? var.master_instance_count : null
    dedicated_master_type    = var.master_instance_enabled ? var.master_instance_type : null

    instance_count = var.hot_instance_count
    instance_type  = var.hot_instance_type

    warm_enabled = var.warm_instance_enabled
    warm_count   = var.warm_instance_enabled ? var.warm_instance_count : null
    warm_type    = var.warm_instance_enabled ? var.warm_instance_type : null

    zone_awareness_enabled = (var.availability_zones > 1) ? true : false

    dynamic "zone_awareness_config" {
      for_each = (var.availability_zones > 1) ? [var.availability_zones] : []
      content {
        availability_zone_count = zone_awareness_config.value
      }
    }
  }

  dynamic "vpc_options" {
    for_each = (length(var.subnets_id) >= 1) ? [1] : []

    content {
      subnet_ids         = var.subnets_id
      security_group_ids = [aws_security_group.es.id]
    }
  }

  advanced_security_options {
    enabled                        = var.advanced_security_options_enabled
    internal_user_database_enabled = var.advanced_security_options_internal_user_db

    master_user_options {
      master_user_arn = (var.master_user_arn != "") ? var.master_user_arn : data.aws_caller_identity.current.arn
    }
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    custom_endpoint_enabled         = true
    custom_endpoint                 = "${var.cluster_hostname}.${data.aws_route53_zone.opensearch.name}"
    custom_endpoint_certificate_arn = data.aws_acm_certificate.domain_host.arn
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.encrypt_kms_key_id
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
    iops        = var.ebs_iops
    throughput  = var.ebs_throughput
  }

  dynamic "log_publishing_options" {
    for_each = var.log_publishing_options

    content {
      enabled                  = log_publishing_options.value.enable
      cloudwatch_log_group_arn = log_publishing_options.value.cloudwatch_log_group_arn
      log_type                 = log_publishing_options.value.log_type
    }
  }

  tags = var.tags

  depends_on = [aws_iam_service_linked_role.es]
}

resource "aws_opensearch_domain_saml_options" "opensearch" {
  count       = var.enable_saml_options ? 1 : 0
  domain_name = aws_opensearch_domain.opensearch.domain_name

  saml_options {
    enabled                 = true
    subject_key             = var.saml_subject_key
    roles_key               = var.saml_roles_key
    session_timeout_minutes = var.saml_session_timeout
    master_backend_role     = var.saml_master_backend_role
    master_user_name        = var.saml_master_user_name

    idp {
      entity_id        = var.saml_entity_id
      metadata_content = sensitive(replace(var.saml_metadata_content, "\ufeff", ""))
    }
  }
}

resource "aws_route53_record" "opensearch" {
  zone_id = data.aws_route53_zone.opensearch.id
  name    = var.cluster_hostname
  type    = "CNAME"
  ttl     = "60"

  records = [aws_opensearch_domain.opensearch.endpoint]
}

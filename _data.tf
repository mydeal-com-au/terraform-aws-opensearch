data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "opensearch" {
  name = var.cluster_domain
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Scheme = "private"
  }
}

data "aws_iam_policy_document" "access_policy" {
  statement {
    actions   = ["es:*"]
    resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.cluster_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

data "aws_acm_certificate" "domain_host" {
  domain   = var.cluster_domain
  statuses = ["ISSUED"]
}

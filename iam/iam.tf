module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.24.1"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
  enabled    = var.enabled
}

data "aws_caller_identity" "current" {
  count = var.enabled && var.create_aws_role ? 1 : 0
}

locals {
  aws_account_id       = var.eks_account_id != "" ? var.eks_account_id : join("", data.aws_caller_identity.current.*.account_id)
  oidc_issuer_hostpath = replace(var.eks_oidc_issuer_url, "https://", "")
  oidc_provider_arn    = "arn:aws:iam::${local.aws_account_id}:oidc-provider/${local.oidc_issuer_hostpath}"
  service_account_name = var.service_account_name != "" ? var.service_account_name : module.label.id
}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled && var.create_aws_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_hostpath}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_hostpath}:sub"
      values   = ["system:serviceaccount:${var.kubernetes_namespace}:${local.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "default" {
  count = var.enabled && var.create_aws_role ? 1 : 0

  name               = module.label.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
}

resource "aws_iam_role_policy" "default" {
  for_each = var.enabled && var.create_aws_role ? var.inline_role_policies : {}

  name   = each.key
  role   = join("", aws_iam_role.default.*.name)
  policy = each.value
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each = var.enabled && var.create_aws_role ? toset(var.attached_role_policy_arns) : []

  role       = join("", aws_iam_role.default.*.name)
  policy_arn = each.value
}

resource "kubernetes_service_account" "default" {
  count = var.enabled && var.create_service_account ? 1 : 0

  metadata {
    namespace = var.kubernetes_namespace

    name = local.service_account_name

    labels = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = var.create_aws_role == true ? join("", aws_iam_role.default.*.arn) : var.aws_role
    }
  }

  automount_service_account_token = true

}

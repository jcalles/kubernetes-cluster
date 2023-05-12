provider "aws" {

  default_tags {
    tags = {
      Technology = "Terraform"
    }
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks_cluster.eks_cluster_id
}

data "aws_availability_zones" "main" {
}

## vpc-cni coredns and kube-proxy
data "aws_eks_addon_version" "latest" {
  for_each           = { for key, value in local.eks_components : key => value if value == true }
  addon_name         = each.key
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}


data "aws_iam_policy" "vpc_cni_policy" {
  name = "AmazonEKS_CNI_Policy"
}


module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.24.1"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = compact(concat(var.attributes, ["cluster"]))
  tags       = var.tags
}


module "eks_node_group" {
  source                     = "git::https://github.com/cloudposse/terraform-aws-eks-node-group.git?ref=tags/2.6.1"
  enabled                    = var.node_group_enabled
  namespace                  = var.namespace
  stage                      = var.stage
  name                       = var.name
  attributes                 = var.attributes
  tags                       = local.tags
  subnet_ids                 = length(var.node_group_availability_zones) > 0 ? matchkeys(local.private_subnet_ids, local.azs, var.node_group_availability_zones) : local.private_subnet_ids
  cluster_name               = module.eks_cluster.eks_cluster_id
  instance_types             = var.instance_types
  desired_size               = var.desired_size
  min_size                   = var.min_size
  max_size                   = var.max_size
  kubernetes_labels          = var.kubernetes_labels
  block_device_mappings      = var.block_device_mappings
  node_role_policy_arns      = var.node_role_policy_arns
  cluster_autoscaler_enabled = var.cluster_autoscaler_enabled
  resources_to_tag           = var.node_group_resources_to_tag
  create_before_destroy      = var.create_before_destroy
  kubernetes_version         = [var.kubernetes_version]
  module_depends_on = [
    module.eks_cluster.kubernetes_config_map_id,
    module.eks_cluster
  ]
}


module "eks_cluster" {
  source                                    = "git::https://github.com/cloudposse/terraform-aws-eks-cluster.git?ref=tags/1.0.0"
  namespace                                 = var.namespace
  stage                                     = var.stage
  name                                      = var.name
  attributes                                = var.attributes
  tags                                      = local.tags
  region                                    = var.aws_region
  vpc_id                                    = var.vpc_id
  subnet_ids                                = local.private_subnet_ids
  kubernetes_version                        = var.kubernetes_version
  local_exec_interpreter                    = var.local_exec_interpreter
  kubernetes_config_map_ignore_role_changes = var.kubernetes_config_map_ignore_role_changes
  oidc_provider_enabled                     = true
  cluster_encryption_config_enabled         = var.cluster_encryption_config_enabled
  enabled_cluster_log_types                 = var.enabled_cluster_log_types
  cluster_log_retention_period              = var.cluster_log_retention_period
  endpoint_private_access                   = var.endpoint_private_access
  endpoint_public_access                    = var.endpoint_public_access
  public_access_cidrs                       = var.public_access_cidrs
  kubeconfig_path_enabled                   = var.kubeconfig_path_enabled
  kubeconfig_path                           = var.kubeconfig_path
  kubeconfig_context                        = var.kubeconfig_context
  kube_data_auth_enabled                    = var.kube_data_auth_enabled
  kube_exec_auth_enabled                    = var.kube_exec_auth_enabled
  kube_exec_auth_role_arn                   = var.kube_exec_auth_role_arn
  kube_exec_auth_role_arn_enabled           = var.kube_exec_auth_role_arn_enabled
  kube_exec_auth_aws_profile                = var.kube_exec_auth_aws_profile
  kube_exec_auth_aws_profile_enabled        = var.kube_exec_auth_aws_profile_enabled
  aws_auth_yaml_strip_quotes                = var.aws_auth_yaml_strip_quotes
  dummy_kubeapi_server                      = var.dummy_kubeapi_server
  map_additional_iam_roles                  = []
}


####  Fargate

module "eks_fargate_profile" {
  for_each                                = toset(["default", "kube-system"])
  source                                  = "git::https://github.com/cloudposse/terraform-aws-eks-fargate-profile.git?ref=tags/1.1.0"
  enabled                                 = var.default_fargate_profile_enabled
  namespace                               = var.namespace
  stage                                   = var.stage
  name                                    = var.name
  attributes                              = [each.value]
  tags                                    = merge(local.tags, { KubernetesNamespace = each.value })
  subnet_ids                              = local.private_subnet_ids
  cluster_name                            = module.eks_cluster.eks_cluster_id
  kubernetes_labels                       = var.kubernetes_labels
  kubernetes_namespace                    = each.value
  iam_role_kubernetes_namespace_delimiter = "@"
  depends_on                              = [module.eks_node_group]
}


#### Components 

resource "aws_eks_addon" "components" {
  for_each          = { for key, value in local.eks_components : key => value if value == true }
  cluster_name      = module.eks_cluster.eks_cluster_id
  addon_name        = each.key
  addon_version     = data.aws_eks_addon_version.latest[each.key].version
  resolve_conflicts = var.resolve_conflicts
  tags              = merge(local.tags, { "eks_addon" = each.key })
  depends_on = [
    module.eks_cluster.eks_cluster_id,
    module.eks_cluster.wait_for_cluster_command,
    helm_release.vpc_cni
  ]
}




resource "null_resource" "patch_aws_node" {
  triggers = {
    cluster_ready = module.eks_cluster.eks_cluster_id
  }
  provisioner "local-exec" {
    command = "${path.module}/script.sh ${var.aws_region} aws-vpc-cni"
    environment = {
      namespace = var.namespace
      stage     = var.stage
    }
  }
  provisioner "local-exec" {
    when    = destroy
    command = "echo destroying"
  }


  depends_on = [
    module.eks_cluster
  ]
}
## VPC-CNI
module "vpc_cni_iam_role" {
  count                     = var.components_enabled ? 1 : 0
  source                    = "./iam"
  enabled                   = true
  namespace                 = var.namespace
  stage                     = var.stage
  name                      = "vpc-cni"
  kubernetes_namespace      = "kube-system"
  service_account_name      = "vpc-cni-sa"
  eks_oidc_issuer_url       = module.eks_cluster.eks_cluster_identity_oidc_issuer
  attached_role_policy_arns = [data.aws_iam_policy.vpc_cni_policy.arn]
  tags                      = local.tags
}


resource "helm_release" "vpc_cni" {
  count      = var.components_enabled ? 1 : 0
  name       = var.vpc_cni_helm_chart_name
  chart      = var.vpc_cni_helm_chart_release_name
  repository = var.vpc_cni_helm_chart_repo
  version    = var.vpc_cni_helm_chart_version
  namespace  = "kube-system"

  values = [
    yamlencode(var.vpc-cni_settings)
  ]

  set {
    name  = "originalMatchLabels"
    value = true
  }

  dynamic "set" {
    for_each = toset(["image.region", "init.image.region", "eniConfig.region"])
    content {
      name  = set.value
      value = var.aws_region
    }
  }


  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = join("", module.vpc_cni_iam_role.*.iam_role_arn)
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  depends_on = [
    module.eks_cluster.eks_cluster_id,
    module.eks_cluster.wait_for_cluster_command,
    module.vpc_cni_iam_role,
    null_resource.patch_aws_node
  ]

}

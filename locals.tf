locals {
  private_subnet_ids = var.vpc_private_subnet_ids
  azs                = data.aws_availability_zones.main.zone_ids
  ecr_eks_url        = "602401143452.dkr.ecr.us-west-2.amazonaws.com/eks"

  eks_worker_ami_name_filter = "amazon-eks-node-${var.kubernetes_version}*"
  tags                       = merge(var.tags, { "kubernetes.io/cluster/${module.label.id}" = "shared", ManagedBy = "Terraform" })

  eks_components = {
    "kube-proxy" = lookup(var.eks_components, "kube-proxy", true)
    "coredns"    = lookup(var.eks_components, "coredns", false)
  }
}




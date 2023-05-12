variable "aws_region" {}

variable "aws_account_id" {}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev' or 'testing'"
}

variable "name" {
  type        = string
  default     = "eks"
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "kubernetes_version" {
  type        = string
  default     = "1.23"
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}


variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}

variable "cluster_log_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html."
}

variable "map_additional_aws_accounts" {
  description = "Additional AWS account numbers to add to `config-map-aws-auth` ConfigMap"
  type        = list(string)
  default     = []
}

variable "map_additional_iam_roles" {
  description = "Additional IAM roles to add to `config-map-aws-auth` ConfigMap"

  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "map_additional_iam_users" {
  description = "Additional IAM users to add to `config-map-aws-auth` ConfigMap"

  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "oidc_provider_enabled" {
  type        = bool
  default     = true
  description = "Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using `kiam` or `kube2iam`. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html"
}

variable "endpoint_private_access" {
  type        = bool
  default     = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false"
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true"
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0."
}

variable "local_exec_interpreter" {
  type        = list(string)
  default     = ["/bin/sh", "-c"]
  description = "shell to use for local_exec"
}

variable "kube_system_fargate_profile_enabled" {
  type        = bool
  default     = false
  description = "Toggle to enable the kube-system namespace fargate profile"
}

variable "default_fargate_profile_enabled" {
  type        = bool
  default     = false
  description = "Toggle to enable the default namespace fargate profile"
}

variable "node_group_enabled" {
  type        = bool
  default     = true
  description = "Toggle to deploy a managed node group"
}

variable "node_group_resources_to_tag" {
  type        = list(string)
  default     = ["instance", "volume", "elastic-gpu", "spot-instances-request"]
  description = "Set node group resources you want to maintain upstream tags."
}

variable "launch_template_disk_encryption_enabled" {
  type        = bool
  description = "Enable disk encryption for the created launch template (if we aren't provided with an existing launch template)"
  default     = true
}

variable "launch_template_disk_encryption_kms_key_id" {
  type        = string
  default     = ""
  description = "Custom KMS Key ID to encrypt EBS volumes on EC2 instances, applicable only if `launch_template_disk_encryption_enabled` is set to true"
}


variable "instance_types" {
  type        = list(string)
  default     = ["m5.xlarge"]
  description = "Set of instance types associated with the EKS Node Group. Defaults to [\"t3.medium\"]. Terraform will only perform drift detection if a configuration value is provided"
}

variable "kubernetes_labels" {
  type        = map(string)
  default     = {}
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
}

variable "desired_size" {
  type        = number
  default     = 2
  description = "Desired number of worker nodes"
}

variable "max_size" {
  type        = number
  default     = 6
  description = "The maximum size of the AutoScaling Group"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "The minimum size of the AutoScaling Group"
}

variable "cluster_autoscaler_enabled" {
  type        = bool
  description = "Whether to enable node group to scale the Auto Scaling Group"
  default     = true
}

variable "node_group_availability_zones" {
  type        = list(string)
  default     = []
  description = "List of availability zones to deploy managed nodes to"
}

variable "worker_role_autoscale_iam_enabled" {
  type        = bool
  default     = false
  description = "If true, the worker IAM role will be authorized to perform autoscaling operations. Not recommended."
}

variable "node_group_create_before_destroy" {
  type        = bool
  default     = false
  description = "Set true in order to create the new node group before destroying the old one. If false, the old node group will be destroyed first, causing downtime. Changing this setting will always cause node group to be replaced."
}


variable "cluster_encryption_config_kms_key_id" {
  type        = string
  default     = ""
  description = "KMS Key ID to use for cluster encryption config"
}


variable "cluster_encryption_config_enabled" {
  type        = bool
  default     = false
  description = "Set to `true` to enable Cluster Encryption Configuration"
}

variable "create_before_destroy" {
  type        = bool
  default     = true
  description = <<-EOT
    Set true in order to create the new node group before destroying the old one.
    If false, the old node group will be destroyed first, causing downtime.
    Changing this setting will always cause node group to be replaced.
    EOT
}

variable "eks_components" {
  type        = any
  description = "Map of  add-on components versions described below "
  default = {
    "kube-proxy" = true
    "coredns"    = false
  }
}

variable "resolve_conflicts" {
  description = "Define how to resolve parameter value conflicts. Valid values are NONE and OVERWRITE."
  type        = string
  default     = "OVERWRITE"

}


variable "vpc_cni_helm_chart_name" {
  type        = string
  default     = "aws-vpc-cni"
  description = "AWS Load Balancer Controller Helm chart name."
}

variable "vpc_cni_helm_chart_release_name" {
  type        = string
  default     = "aws-vpc-cni"
  description = "AWS Load Balancer Controller Helm chart release name."
}

variable "vpc_cni_helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "AWS Load Balancer Controller Helm repository name."
}

variable "vpc_cni_helm_chart_version" {
  type        = string
  default     = "1.2.2"
  description = "AWS Load Balancer Controller Helm chart version. "
}



variable "block_device_mappings" {
  type        = list(any)
  description = <<-EOT
    List of block device mappings for the launch template.
    Each list element is an object with a `device_name` key and
    any keys supported by the `ebs` block of `launch_template`.
    EOT
  # See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#ebs
  default = [{
    device_name           = "/dev/xvda"
    volume_size           = 100
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }]
}

variable "kubernetes_config_map_ignore_role_changes" {
  type        = bool
  description = "Set to `true` to ignore IAM role changes in the Kubernetes Auth ConfigMap"
  default     = true
}

variable "node_role_policy_arns" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  ]
  description = "List of policy ARNs to attach to the worker role this module creates in addition to the default ones"
}

variable "apply_config_map_aws_auth" {
  type        = bool
  description = "Whether to apply the ConfigMap to allow worker nodes to join the EKS cluster and allow additional users, accounts and roles to acces the cluster"
  default     = true
}



variable "vpc-cni_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}


##################
# All the following variables are just about configuring the Kubernetes provider
# to be able to modify the aws-auth ConfigMap. Once EKS provides a normal
# AWS API for modifying it, we can do away with all of this.
#
# The reason there are so many options is because at various times, each
# one of them has had problems, so we give you a choice.
#
# The reason there are so many "enabled" inputs rather than automatically
# detecting whether or not they are enabled based on the value of the input
# is that any logic based on input values requires the values to be known during
# the "plan" phase of Terraform, and often they are not, which causes problems.
#

variable "kubeconfig_path_enabled" {
  type        = bool
  description = "If `true`, configure the Kubernetes provider with `kubeconfig_path` and use it for authenticating to the EKS cluster"
  default     = false
}

variable "kubeconfig_path" {
  type        = string
  description = "The Kubernetes provider `config_path` setting to use when `kubeconfig_path_enabled` is `true`"
  default     = ""
}

variable "kubeconfig_context" {
  type        = string
  description = "Context to choose from the Kubernetes kube config file"
  default     = ""
}

variable "kube_data_auth_enabled" {
  type        = bool
  description = <<-EOT
    If `true`, use an `aws_eks_cluster_auth` data source to authenticate to the EKS cluster.
    Disabled by `kubeconfig_path_enabled` or `kube_exec_auth_enabled`.
    EOT
  default     = true
}

variable "kube_exec_auth_enabled" {
  type        = bool
  description = <<-EOT
    If `true`, use the Kubernetes provider `exec` feature to execute `aws eks get-token` to authenticate to the EKS cluster.
    Disabled by `kubeconfig_path_enabled`, overrides `kube_data_auth_enabled`.
    EOT
  default     = false
}


variable "kube_exec_auth_role_arn" {
  type        = string
  description = "The role ARN for `aws eks get-token` to use"
  default     = ""
}

variable "kube_exec_auth_role_arn_enabled" {
  type        = bool
  description = "If `true`, pass `kube_exec_auth_role_arn` as the role ARN to `aws eks get-token`"
  default     = false
}

variable "kube_exec_auth_aws_profile" {
  type        = string
  description = "The AWS config profile for `aws eks get-token` to use"
  default     = ""
}

variable "kube_exec_auth_aws_profile_enabled" {
  type        = bool
  description = "If `true`, pass `kube_exec_auth_aws_profile` as the `profile` to `aws eks get-token`"
  default     = false
}

variable "aws_auth_yaml_strip_quotes" {
  type        = bool
  description = "If true, remove double quotes from the generated aws-auth ConfigMap YAML to reduce spurious diffs in plans"
  default     = true
}

variable "dummy_kubeapi_server" {
  type        = string
  default     = "https://jsonplaceholder.typicode.com"
  description = <<-EOT
    URL of a dummy API server for the Kubernetes server to use when the real one is unknown.
    This is a workaround to ignore connection failures that break Terraform even though the results do not matter.
    You can disable it by setting it to `null`; however, as of Kubernetes provider v2.3.2, doing so _will_
    cause Terraform to fail in several situations unless you provide a valid `kubeconfig` file
    via `kubeconfig_path` and set `kubeconfig_path_enabled` to `true`.
    EOT
}

variable "cluster_attributes" {
  type        = list(string)
  description = "Override label module default cluster attributes"
  default     = ["cluster"]
}

#######

variable "create_security_group" {
  type        = bool
  default     = true
  description = <<-EOT
    Set to `true` to create and configure an additional Security Group for the cluster.
    Only for backwards compatibility, if you are updating this module to the latest version on existing clusters, not recommended for new clusters.
    EKS creates a managed Security Group for the cluster automatically, places the control plane and managed nodes into the Security Group,
    and you can also allow unmanaged nodes to communicate with the cluster by using the `allowed_security_group_ids` variable.
    The additional Security Group is kept in the module for backwards compatibility and will be removed in future releases along with this variable.
    See https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html for more details.
    EOT
}


variable "create_eks_service_role" {
  type        = bool
  description = "Set `false` to use existing `eks_cluster_service_role_arn` instead of creating one"
  default     = true
}

variable "vpc_id" {
  type = string
}

variable "vpc_private_subnet_ids" {
  type = list(string)
}
#########

variable "components_enabled" {
  type    = bool
  default = false
}

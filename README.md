## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | git::https://github.com/cloudposse/terraform-aws-eks-cluster.git | tags/1.0.0 |
| <a name="module_eks_fargate_profile"></a> [eks\_fargate\_profile](#module\_eks\_fargate\_profile) | git::https://github.com/cloudposse/terraform-aws-eks-fargate-profile.git | tags/1.1.0 |
| <a name="module_eks_node_group"></a> [eks\_node\_group](#module\_eks\_node\_group) | git::https://github.com/cloudposse/terraform-aws-eks-node-group.git | tags/2.6.1 |
| <a name="module_label"></a> [label](#module\_label) | git::https://github.com/cloudposse/terraform-null-label.git | tags/0.24.1 |
| <a name="module_vpc_cni_iam_role"></a> [vpc\_cni\_iam\_role](#module\_vpc\_cni\_iam\_role) | ./iam | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.components](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [helm_release.vpc_cni](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.patch_aws_node](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_availability_zones.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_eks_addon_version.latest](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_cluster_auth.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy.vpc_cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_config_map_aws_auth"></a> [apply\_config\_map\_aws\_auth](#input\_apply\_config\_map\_aws\_auth) | Whether to apply the ConfigMap to allow worker nodes to join the EKS cluster and allow additional users, accounts and roles to acces the cluster | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | n/a | `any` | n/a | yes |
| <a name="input_aws_auth_yaml_strip_quotes"></a> [aws\_auth\_yaml\_strip\_quotes](#input\_aws\_auth\_yaml\_strip\_quotes) | If true, remove double quotes from the generated aws-auth ConfigMap YAML to reduce spurious diffs in plans | `bool` | `true` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `any` | n/a | yes |
| <a name="input_block_device_mappings"></a> [block\_device\_mappings](#input\_block\_device\_mappings) | List of block device mappings for the launch template.<br>Each list element is an object with a `device_name` key and<br>any keys supported by the `ebs` block of `launch_template`. | `list(any)` | <pre>[<br>  {<br>    "delete_on_termination": true,<br>    "device_name": "/dev/xvda",<br>    "encrypted": true,<br>    "volume_size": 100,<br>    "volume_type": "gp3"<br>  }<br>]</pre> | no |
| <a name="input_cluster_attributes"></a> [cluster\_attributes](#input\_cluster\_attributes) | Override label module default cluster attributes | `list(string)` | <pre>[<br>  "cluster"<br>]</pre> | no |
| <a name="input_cluster_autoscaler_enabled"></a> [cluster\_autoscaler\_enabled](#input\_cluster\_autoscaler\_enabled) | Whether to enable node group to scale the Auto Scaling Group | `bool` | `true` | no |
| <a name="input_cluster_encryption_config_enabled"></a> [cluster\_encryption\_config\_enabled](#input\_cluster\_encryption\_config\_enabled) | Set to `true` to enable Cluster Encryption Configuration | `bool` | `false` | no |
| <a name="input_cluster_encryption_config_kms_key_id"></a> [cluster\_encryption\_config\_kms\_key\_id](#input\_cluster\_encryption\_config\_kms\_key\_id) | KMS Key ID to use for cluster encryption config | `string` | `""` | no |
| <a name="input_cluster_log_retention_period"></a> [cluster\_log\_retention\_period](#input\_cluster\_log\_retention\_period) | Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. | `number` | `7` | no |
| <a name="input_components_enabled"></a> [components\_enabled](#input\_components\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_create_before_destroy"></a> [create\_before\_destroy](#input\_create\_before\_destroy) | Set true in order to create the new node group before destroying the old one.<br>If false, the old node group will be destroyed first, causing downtime.<br>Changing this setting will always cause node group to be replaced. | `bool` | `true` | no |
| <a name="input_create_eks_service_role"></a> [create\_eks\_service\_role](#input\_create\_eks\_service\_role) | Set `false` to use existing `eks_cluster_service_role_arn` instead of creating one | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Set to `true` to create and configure an additional Security Group for the cluster.<br>Only for backwards compatibility, if you are updating this module to the latest version on existing clusters, not recommended for new clusters.<br>EKS creates a managed Security Group for the cluster automatically, places the control plane and managed nodes into the Security Group,<br>and you can also allow unmanaged nodes to communicate with the cluster by using the `allowed_security_group_ids` variable.<br>The additional Security Group is kept in the module for backwards compatibility and will be removed in future releases along with this variable.<br>See https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html for more details. | `bool` | `true` | no |
| <a name="input_default_fargate_profile_enabled"></a> [default\_fargate\_profile\_enabled](#input\_default\_fargate\_profile\_enabled) | Toggle to enable the default namespace fargate profile | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `name`, `namespace`, `stage`, etc. | `string` | `"-"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desired number of worker nodes | `number` | `2` | no |
| <a name="input_dummy_kubeapi_server"></a> [dummy\_kubeapi\_server](#input\_dummy\_kubeapi\_server) | URL of a dummy API server for the Kubernetes server to use when the real one is unknown.<br>This is a workaround to ignore connection failures that break Terraform even though the results do not matter.<br>You can disable it by setting it to `null`; however, as of Kubernetes provider v2.3.2, doing so \_will\_<br>cause Terraform to fail in several situations unless you provide a valid `kubeconfig` file<br>via `kubeconfig_path` and set `kubeconfig_path_enabled` to `true`. | `string` | `"https://jsonplaceholder.typicode.com"` | no |
| <a name="input_eks_components"></a> [eks\_components](#input\_eks\_components) | Map of  add-on components versions described below | `any` | <pre>{<br>  "coredns": false,<br>  "kube-proxy": true<br>}</pre> | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`] | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true | `bool` | `true` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Set of instance types associated with the EKS Node Group. Defaults to ["t3.medium"]. Terraform will only perform drift detection if a configuration value is provided | `list(string)` | <pre>[<br>  "m5.xlarge"<br>]</pre> | no |
| <a name="input_kube_data_auth_enabled"></a> [kube\_data\_auth\_enabled](#input\_kube\_data\_auth\_enabled) | If `true`, use an `aws_eks_cluster_auth` data source to authenticate to the EKS cluster.<br>Disabled by `kubeconfig_path_enabled` or `kube_exec_auth_enabled`. | `bool` | `true` | no |
| <a name="input_kube_exec_auth_aws_profile"></a> [kube\_exec\_auth\_aws\_profile](#input\_kube\_exec\_auth\_aws\_profile) | The AWS config profile for `aws eks get-token` to use | `string` | `""` | no |
| <a name="input_kube_exec_auth_aws_profile_enabled"></a> [kube\_exec\_auth\_aws\_profile\_enabled](#input\_kube\_exec\_auth\_aws\_profile\_enabled) | If `true`, pass `kube_exec_auth_aws_profile` as the `profile` to `aws eks get-token` | `bool` | `false` | no |
| <a name="input_kube_exec_auth_enabled"></a> [kube\_exec\_auth\_enabled](#input\_kube\_exec\_auth\_enabled) | If `true`, use the Kubernetes provider `exec` feature to execute `aws eks get-token` to authenticate to the EKS cluster.<br>Disabled by `kubeconfig_path_enabled`, overrides `kube_data_auth_enabled`. | `bool` | `false` | no |
| <a name="input_kube_exec_auth_role_arn"></a> [kube\_exec\_auth\_role\_arn](#input\_kube\_exec\_auth\_role\_arn) | The role ARN for `aws eks get-token` to use | `string` | `""` | no |
| <a name="input_kube_exec_auth_role_arn_enabled"></a> [kube\_exec\_auth\_role\_arn\_enabled](#input\_kube\_exec\_auth\_role\_arn\_enabled) | If `true`, pass `kube_exec_auth_role_arn` as the role ARN to `aws eks get-token` | `bool` | `false` | no |
| <a name="input_kube_system_fargate_profile_enabled"></a> [kube\_system\_fargate\_profile\_enabled](#input\_kube\_system\_fargate\_profile\_enabled) | Toggle to enable the kube-system namespace fargate profile | `bool` | `false` | no |
| <a name="input_kubeconfig_context"></a> [kubeconfig\_context](#input\_kubeconfig\_context) | Context to choose from the Kubernetes kube config file | `string` | `""` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | The Kubernetes provider `config_path` setting to use when `kubeconfig_path_enabled` is `true` | `string` | `""` | no |
| <a name="input_kubeconfig_path_enabled"></a> [kubeconfig\_path\_enabled](#input\_kubeconfig\_path\_enabled) | If `true`, configure the Kubernetes provider with `kubeconfig_path` and use it for authenticating to the EKS cluster | `bool` | `false` | no |
| <a name="input_kubernetes_config_map_ignore_role_changes"></a> [kubernetes\_config\_map\_ignore\_role\_changes](#input\_kubernetes\_config\_map\_ignore\_role\_changes) | Set to `true` to ignore IAM role changes in the Kubernetes Auth ConfigMap | `bool` | `true` | no |
| <a name="input_kubernetes_labels"></a> [kubernetes\_labels](#input\_kubernetes\_labels) | Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed | `map(string)` | `{}` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Desired Kubernetes master version. If you do not specify a value, the latest available version is used | `string` | `"1.23"` | no |
| <a name="input_launch_template_disk_encryption_enabled"></a> [launch\_template\_disk\_encryption\_enabled](#input\_launch\_template\_disk\_encryption\_enabled) | Enable disk encryption for the created launch template (if we aren't provided with an existing launch template) | `bool` | `true` | no |
| <a name="input_launch_template_disk_encryption_kms_key_id"></a> [launch\_template\_disk\_encryption\_kms\_key\_id](#input\_launch\_template\_disk\_encryption\_kms\_key\_id) | Custom KMS Key ID to encrypt EBS volumes on EC2 instances, applicable only if `launch_template_disk_encryption_enabled` is set to true | `string` | `""` | no |
| <a name="input_local_exec_interpreter"></a> [local\_exec\_interpreter](#input\_local\_exec\_interpreter) | shell to use for local\_exec | `list(string)` | <pre>[<br>  "/bin/sh",<br>  "-c"<br>]</pre> | no |
| <a name="input_map_additional_aws_accounts"></a> [map\_additional\_aws\_accounts](#input\_map\_additional\_aws\_accounts) | Additional AWS account numbers to add to `config-map-aws-auth` ConfigMap | `list(string)` | `[]` | no |
| <a name="input_map_additional_iam_roles"></a> [map\_additional\_iam\_roles](#input\_map\_additional\_iam\_roles) | Additional IAM roles to add to `config-map-aws-auth` ConfigMap | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_additional_iam_users"></a> [map\_additional\_iam\_users](#input\_map\_additional\_iam\_users) | Additional IAM users to add to `config-map-aws-auth` ConfigMap | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | The maximum size of the AutoScaling Group | `number` | `6` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | The minimum size of the AutoScaling Group | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'cluster' | `string` | `"eks"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | `string` | n/a | yes |
| <a name="input_node_group_availability_zones"></a> [node\_group\_availability\_zones](#input\_node\_group\_availability\_zones) | List of availability zones to deploy managed nodes to | `list(string)` | `[]` | no |
| <a name="input_node_group_create_before_destroy"></a> [node\_group\_create\_before\_destroy](#input\_node\_group\_create\_before\_destroy) | Set true in order to create the new node group before destroying the old one. If false, the old node group will be destroyed first, causing downtime. Changing this setting will always cause node group to be replaced. | `bool` | `false` | no |
| <a name="input_node_group_enabled"></a> [node\_group\_enabled](#input\_node\_group\_enabled) | Toggle to deploy a managed node group | `bool` | `true` | no |
| <a name="input_node_group_resources_to_tag"></a> [node\_group\_resources\_to\_tag](#input\_node\_group\_resources\_to\_tag) | Set node group resources you want to maintain upstream tags. | `list(string)` | <pre>[<br>  "instance",<br>  "volume",<br>  "elastic-gpu",<br>  "spot-instances-request"<br>]</pre> | no |
| <a name="input_node_role_policy_arns"></a> [node\_role\_policy\_arns](#input\_node\_role\_policy\_arns) | List of policy ARNs to attach to the worker role this module creates in addition to the default ones | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",<br>  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",<br>  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"<br>]</pre> | no |
| <a name="input_oidc_provider_enabled"></a> [oidc\_provider\_enabled](#input\_oidc\_provider\_enabled) | Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using `kiam` or `kube2iam`. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html | `bool` | `true` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_resolve_conflicts"></a> [resolve\_conflicts](#input\_resolve\_conflicts) | Define how to resolve parameter value conflicts. Valid values are NONE and OVERWRITE. | `string` | `"OVERWRITE"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev' or 'testing' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |
| <a name="input_vpc-cni_settings"></a> [vpc-cni\_settings](#input\_vpc-cni\_settings) | Additional settings which will be passed to the Helm chart values. | `map` | `{}` | no |
| <a name="input_vpc_cni_helm_chart_name"></a> [vpc\_cni\_helm\_chart\_name](#input\_vpc\_cni\_helm\_chart\_name) | AWS Load Balancer Controller Helm chart name. | `string` | `"aws-vpc-cni"` | no |
| <a name="input_vpc_cni_helm_chart_release_name"></a> [vpc\_cni\_helm\_chart\_release\_name](#input\_vpc\_cni\_helm\_chart\_release\_name) | AWS Load Balancer Controller Helm chart release name. | `string` | `"aws-vpc-cni"` | no |
| <a name="input_vpc_cni_helm_chart_repo"></a> [vpc\_cni\_helm\_chart\_repo](#input\_vpc\_cni\_helm\_chart\_repo) | AWS Load Balancer Controller Helm repository name. | `string` | `"https://aws.github.io/eks-charts"` | no |
| <a name="input_vpc_cni_helm_chart_version"></a> [vpc\_cni\_helm\_chart\_version](#input\_vpc\_cni\_helm\_chart\_version) | AWS Load Balancer Controller Helm chart version. | `string` | `"1.2.2"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |
| <a name="input_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#input\_vpc\_private\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_worker_role_autoscale_iam_enabled"></a> [worker\_role\_autoscale\_iam\_enabled](#input\_worker\_role\_autoscale\_iam\_enabled) | If true, the worker IAM role will be authorized to perform autoscaling operations. Not recommended. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | The endpoint for the Kubernetes API server |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The name of the cluster |
| <a name="output_eks_cluster_identity_oidc_issuer"></a> [eks\_cluster\_identity\_oidc\_issuer](#output\_eks\_cluster\_identity\_oidc\_issuer) | The OIDC Identity issuer for the cluster |
| <a name="output_eks_cluster_managed_security_group_id"></a> [eks\_cluster\_managed\_security\_group\_id](#output\_eks\_cluster\_managed\_security\_group\_id) | Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads |
| <a name="output_eks_cluster_security_group_arn"></a> [eks\_cluster\_security\_group\_arn](#output\_eks\_cluster\_security\_group\_arn) | ARN of the EKS cluster Security Group |
| <a name="output_eks_cluster_security_group_id"></a> [eks\_cluster\_security\_group\_id](#output\_eks\_cluster\_security\_group\_id) | ID of the EKS cluster Security Group |
| <a name="output_eks_cluster_security_group_name"></a> [eks\_cluster\_security\_group\_name](#output\_eks\_cluster\_security\_group\_name) | Name of the EKS cluster Security Group |
| <a name="output_eks_cluster_version"></a> [eks\_cluster\_version](#output\_eks\_cluster\_version) | The Kubernetes server version of the cluster |
| <a name="output_eks_node_group_arn"></a> [eks\_node\_group\_arn](#output\_eks\_node\_group\_arn) | Amazon Resource Name (ARN) of the EKS Node Group |
| <a name="output_eks_node_group_id"></a> [eks\_node\_group\_id](#output\_eks\_node\_group\_id) | EKS Cluster name and EKS Node Group name separated by a colon |
| <a name="output_eks_node_group_resources"></a> [eks\_node\_group\_resources](#output\_eks\_node\_group\_resources) | List of objects containing information about underlying resources of the EKS Node Group |
| <a name="output_eks_node_group_role_arn"></a> [eks\_node\_group\_role\_arn](#output\_eks\_node\_group\_role\_arn) | ARN of the worker nodes IAM role |
| <a name="output_eks_node_group_role_name"></a> [eks\_node\_group\_role\_name](#output\_eks\_node\_group\_role\_name) | Name of the worker nodes IAM role |
| <a name="output_eks_node_group_status"></a> [eks\_node\_group\_status](#output\_eks\_node\_group\_status) | Status of the EKS Node Group |

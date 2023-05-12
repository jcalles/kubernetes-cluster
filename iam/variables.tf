variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
}

variable "stage" {
  type        = string
  default     = ""
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

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "kubernetes_namespace" {
  type        = string
  default     = "default"
  description = "Kubernetes namespace containing thed service account, defaults to `default`"
}

variable "service_account_name" {
  type        = string
  default     = ""
  description = "Kubernetes service account name, defaults to the IAM role name"
}

variable "create_service_account" {
  type        = bool
  default     = false
  description = "Set to true to create a Kubernetes service account linked to the IAM role"
}

variable "eks_oidc_issuer_url" {
  type        = string
  description = "OpenID Connect issuer URL"
}

variable "eks_account_id" {
  type        = string
  default     = ""
  description = "EKS cluster account ID"
}

variable "inline_role_policies" {
  type    = map(string)
  default = {}
}

variable "attached_role_policy_arns" {
  type    = list(string)
  default = []
}

variable "create_aws_role" {
  type        = bool
  default     = true
  description = "Set to true to create a AWS role linked to the EKS service account"
}


variable "aws_role" {
  type        = string
  default     = null
  description = "Role previously created"
}

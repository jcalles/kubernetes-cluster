output "iam_role_name" {
  value = join("", aws_iam_role.default.*.name)
}

output "iam_role_arn" {
  value = join("", aws_iam_role.default.*.arn)
}

output "kubernetes_namespace" {
  value = var.kubernetes_namespace
}

output "service_account_name" {
  value = local.service_account_name
}

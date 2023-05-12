#!/usr/bin/env bash
export aws_region="${1:-us-west-2}"
export vpc_cni_release_name="${2:-aws-vpc-cni}"

# get config k8s
aws eks --region "${aws_region}" update-kubeconfig --name "$namespace"-"$stage"-eks-cluster
set -euo pipefail

# don't import the crd. Helm cant manage the lifecycle of it anyway.
for kind in daemonSet clusterRole clusterRoleBinding serviceAccount
do
  echo "setting annotations and labels on $kind/aws-node"
  kubectl -n kube-system annotate --overwrite $kind aws-node meta.helm.sh/release-name="${vpc_cni_release_name}"
  kubectl -n kube-system annotate --overwrite $kind aws-node meta.helm.sh/release-namespace=kube-system
  kubectl -n kube-system label --overwrite $kind aws-node app.kubernetes.io/managed-by=Helm
done

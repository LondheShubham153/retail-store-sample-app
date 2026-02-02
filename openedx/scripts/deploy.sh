#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

kubectl apply -f "$ROOT_DIR/openedx/k8s/namespaces/namespaces.yaml"

kubectl apply -f "$ROOT_DIR/openedx/k8s/externals/external-databases-secret.yaml"
kubectl apply -f "$ROOT_DIR/openedx/k8s/storage/media-pvc.yaml"

kubectl apply -f "$ROOT_DIR/openedx/k8s/openedx/deployments.yaml"
kubectl apply -f "$ROOT_DIR/openedx/k8s/openedx/services.yaml"
kubectl apply -f "$ROOT_DIR/openedx/k8s/openedx/hpa.yaml"

kubectl apply -f "$ROOT_DIR/openedx/k8s/ingress/ingress.yaml"

kubectl apply -f "$ROOT_DIR/openedx/k8s/observability/monitoring.yaml"

echo "Deployment manifests applied. Validate pod status and ingress endpoints."

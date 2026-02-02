# Deployment Guide: OpenEdX on EKS with Tutor + Nginx

This guide follows the architecture and manifests provided in `/openedx` and assumes the EKS + GitOps foundation from this repository.

## 1) Prerequisites

* AWS account with EKS permissions
* kubectl, helm, terraform, tutor
* Existing VPC/EKS (provisioned via this repo's Terraform)

## 2) Install Tutor + tutor-k8s

```bash
pip install "tutor[full]" 
tutor plugins enable k8s
```

> Use the latest stable Tutor version. The `tutor-k8s` plugin is required for Kubernetes deployments.

## 3) Configure External Databases

Create the external services (managed recommended) and note endpoints/credentials:

* MySQL (RDS)
* MongoDB (DocumentDB or Atlas)
* Elasticsearch (OpenSearch)
* Redis (ElastiCache)

Populate the Kubernetes secret in `/openedx/k8s/externals/external-databases-secret.yaml` with connection strings and credentials.

## 4) Configure Tutor

Edit `/openedx/tutor/config.yml` and set:

* External DB endpoints
* S3 bucket for user uploads/media
* CDN domain for static assets
* TLS settings

Generate Tutor configuration and render Kubernetes manifests:

```bash
tutor config save

tutor k8s render > /tmp/openedx-rendered.yaml
```

## 5) Deploy Kubernetes Manifests

```bash
kubectl apply -f openedx/k8s/namespaces
kubectl apply -f openedx/k8s/externals
kubectl apply -f openedx/k8s/storage
kubectl apply -f openedx/k8s/openedx
kubectl apply -f openedx/k8s/observability
kubectl apply -f openedx/k8s/ingress
```

## 6) Replace Caddy with Nginx

1. Deploy Nginx Ingress Controller with the provided Helm values.
2. Apply the custom Nginx config with HTTP/2 + TLS termination.
3. Ensure ingress resources point to the Nginx ingress class.

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f openedx/helm/ingress-nginx/values.yaml

kubectl apply -f openedx/nginx/nginx-configmap.yaml
```

## 7) CDN + WAF

* Configure CloudFront to cache `/static/` and `/media/`.
* Associate AWS WAF rules with CloudFront or the ALB.

Sample WAF rule sets are listed in `/openedx/k8s/ingress/waf-policy.md`.

## 8) Autoscaling

HPA manifests for LMS/CMS are provided in `/openedx/k8s/openedx/hpa.yaml`.

## 9) Monitoring + Logging

Deploy Prometheus + Grafana using the manifests in `/openedx/k8s/observability/`.

## 10) Validation

* Verify `/health` endpoints
* Confirm Nginx TLS termination
* Check LMS/CMS pods scale under load
* Validate external DB connectivity in logs

## 11) Backup Strategy

Review `/openedx/scripts/backup.sh` and schedule via CronJob.

## 12) Troubleshooting

See [Troubleshooting](./troubleshooting.md).

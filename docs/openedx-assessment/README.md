# OpenEdX on Kubernetes Technical Assessment (Full Guided README)

This README is the **full, guided walkthrough** for the OpenEdX technical assessment using this repository’s EKS + GitOps foundations. It is intentionally comprehensive so reviewers can trace every requirement to concrete documentation, configuration, and manifests in the repo.

## 1) What You’re Getting

This package delivers a production-style OpenEdX deployment plan on **AWS EKS**, using **Tutor (latest stable)** and the **tutor-k8s** plugin, with:

* External databases (MySQL, MongoDB, Elasticsearch, Redis)
* **Nginx** as the web server / ingress (replacing Caddy)
* CDN + WAF integration and rate limiting
* Namespace isolation, PV/PVC, HPA, and health checks
* Observability via Prometheus/Grafana ServiceMonitors

## 2) Where Everything Lives (Checklist)

| Requirement | Location |
| --- | --- |
| Deployment guide | [docs/openedx-assessment/deployment-guide.md](./deployment-guide.md) |
| Architecture diagram | [docs/openedx-assessment/architecture.md](./architecture.md) |
| Network flow diagram | [docs/openedx-assessment/network-flow.md](./network-flow.md) |
| Decisions & rationale | [docs/openedx-assessment/decisions.md](./decisions.md) |
| Troubleshooting | [docs/openedx-assessment/troubleshooting.md](./troubleshooting.md) |
| Kubernetes manifests | [openedx/k8s](../../openedx/k8s) |
| Tutor config | [openedx/tutor/config.yml](../../openedx/tutor/config.yml) |
| Nginx config | [openedx/nginx/nginx.conf](../../openedx/nginx/nginx.conf) |
| Nginx ConfigMap | [openedx/nginx/nginx-configmap.yaml](../../openedx/nginx/nginx-configmap.yaml) |
| Helm values (ingress-nginx) | [openedx/helm/ingress-nginx/values.yaml](../../openedx/helm/ingress-nginx/values.yaml) |
| DB init + connection reference | [openedx/db](../../openedx/db) |
| Scripts (deploy/backup/monitoring) | [openedx/scripts](../../openedx/scripts) |

## 3) Prerequisites (Reviewer Ready)

* AWS account with EKS permissions
* kubectl, helm, terraform, tutor
* EKS cluster provisioned (this repo’s Terraform or an equivalent setup)

> You can use a different cloud provider, but **AWS EKS** is assumed in this guide.

## 4) Guided Step‑by‑Step Deployment

### Step 1: Install Tutor + Enable Kubernetes Plugin

```bash
pip install "tutor[full]"
tutor plugins enable k8s
```

### Step 2: Provision External Databases

Create or use managed services for:

* **MySQL** (RDS)
* **MongoDB** (DocumentDB or Atlas)
* **Elasticsearch / OpenSearch**
* **Redis** (ElastiCache)

Populate the secret:

```
openedx/k8s/externals/external-databases-secret.yaml
```

### Step 3: Configure Tutor

Edit:

```
openedx/tutor/config.yml
```

Set database endpoints, CDN domain, S3 bucket, and TLS settings.

### Step 4: Render Tutor Manifests (Optional)

```bash
tutor config save
tutor k8s render > /tmp/openedx-rendered.yaml
```

> This generates the full OpenEdX manifest set; in this repo we also provide curated Kubernetes manifests under `openedx/k8s`.

### Step 5: Apply Kubernetes Manifests

```bash
kubectl apply -f openedx/k8s/namespaces
kubectl apply -f openedx/k8s/externals
kubectl apply -f openedx/k8s/storage
kubectl apply -f openedx/k8s/openedx
kubectl apply -f openedx/k8s/observability
kubectl apply -f openedx/k8s/ingress
```

### Step 6: Replace Caddy with Nginx

Install Nginx Ingress Controller with HTTP/2 + TLS settings:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f openedx/helm/ingress-nginx/values.yaml

kubectl apply -f openedx/nginx/nginx-configmap.yaml
```

### Step 7: CDN + WAF

* Configure CloudFront (or another CDN) with origin = Nginx/ALB
* Attach AWS WAF rules (see `openedx/k8s/ingress/waf-policy.md`)
* Confirm `/static/` and `/media/` caching

### Step 8: HPA + Readiness/Liveness

HPA manifests are provided in:

```
openedx/k8s/openedx/hpa.yaml
```

Readiness and liveness checks are embedded in the deployments.

### Step 9: Monitoring & Logging

Install Prometheus + Grafana:

```bash
openedx/scripts/monitoring-setup.sh
```

Then apply ServiceMonitors:

```bash
kubectl apply -f openedx/k8s/observability/monitoring.yaml
```

### Step 10: Backups

Run (or schedule) the backup script:

```bash
openedx/scripts/backup.sh
```

### Step 11: Validation Checklist

* LMS and CMS health endpoints return `200`
* Ingress TLS termination works with HTTP/2
* HPA scales pods under load
* Logs show successful DB connections

## 5) Deliverables Mapping (Assessment Checklist)

### Documentation
1. Deployment guide ✅
2. Architecture diagram ✅
3. Network flow ✅
4. Decisions/rationale ✅
5. Troubleshooting ✅

### Configuration Files
6. Kubernetes manifests ✅
7. Tutor config ✅
8. Nginx config ✅
9. Helm values ✅
10. DB init scripts ✅
11. Ingress + ingress controller ✅

### Scripts & Automation
12. Deploy scripts ✅
13. Backup/restore scripts ✅
14. Monitoring setup scripts ✅

### Testing Evidence (placeholders)
15. Deployment screenshots (to be added by operator)
16. WAF/CDN proof (to be added by operator)
17. Load testing results (to be added by operator)
18. Logs for DB connections & health checks (to be added by operator)

## 6) Next Steps (If You Want Bonus Points)

* Add ArgoCD Application definitions for OpenEdX
* Add CI/CD pipeline to build custom OpenEdX images
* Add GitOps sync policies (auto-sync, drift detection)
* Add service mesh (Istio/Linkerd)
* Add disaster recovery and failover plan

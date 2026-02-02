# OpenEdX Deployment Assets

This directory contains the configuration, Kubernetes manifests, and scripts required to deploy OpenEdX on EKS using Tutor with Nginx, external databases, and enterprise-grade security components.

## Structure

* `k8s/` - Kubernetes manifests for namespaces, externals, storage, OpenEdX workloads, ingress, observability
* `tutor/` - Tutor configuration (config.yml)
* `nginx/` - Nginx configuration and ConfigMap
* `helm/` - Helm values for ingress-nginx
* `db/` - Database init and connection reference
* `scripts/` - Deployment, backup, and monitoring automation scripts

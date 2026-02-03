# Configuration Decisions & Rationale

## Platform & Deployment
* **EKS + Terraform + Argo CD**: Reuses this repository's GitOps approach and infrastructure as code.
* **Tutor with tutor-k8s**: Official deployment workflow for OpenEdX with Kubernetes support.

## External Datastores
* **MySQL**: Primary relational data store; managed RDS reduces operational burden.
* **MongoDB**: Course structure and modulestore; managed DocumentDB or Atlas.
* **Elasticsearch**: Search and analytics; OpenSearch compatible.
* **Redis**: Caching, Celery broker; managed ElastiCache for reliability.

## Nginx in place of Caddy
* Consistent with enterprise ingress expectations and supports advanced rate limiting, TLS policies, and HTTP/2.

## Security
* **CloudFront CDN** for global caching of static assets.
* **AWS WAF** attached to CloudFront/ALB with managed rule sets.
* TLS termination at Nginx with strict cipher suites.

## Reliability & Performance
* **HPA** on LMS/CMS; scale based on CPU and memory.
* **Persistent storage** with PVC for user uploads; offload to S3-compatible object storage for durability.

## Observability
* **Prometheus + Grafana** for metrics and dashboards.
* **Kubernetes readiness/liveness probes** for all OpenEdX pods.

## Backup Strategy
* Databases: managed backups + scripted exports.
* PVC: snapshots or scheduled S3 syncs.

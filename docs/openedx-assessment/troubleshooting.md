# Troubleshooting Guide

## LMS/CMS Pods Not Ready
* Check pod logs: `kubectl logs -n openedx deploy/openedx-lms`
* Confirm external DB endpoints are reachable.
* Validate secrets in `external-databases-secret.yaml`.

## Ingress 404 or SSL Errors
* Verify the ingress controller is running in `ingress-nginx`.
* Ensure the TLS secret exists and is referenced in the ingress.
* Confirm `nginx.ingress.kubernetes.io/backend-protocol: "HTTP"` when TLS terminates at Nginx.

## Static Assets Not Loading
* Check CDN cache behavior and origin path.
* Validate `STATIC_URL` and CDN domain in Tutor config.

## HPA Not Scaling
* Ensure metrics server is installed.
* Confirm CPU/memory requests/limits are set on LMS/CMS.

## Search Errors
* Verify OpenSearch/Elasticsearch endpoint and credentials.
* Confirm firewall rules allow EKS nodes to access the external service.

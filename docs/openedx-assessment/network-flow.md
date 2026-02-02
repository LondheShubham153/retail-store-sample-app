# Network Flow Diagram

```mermaid
sequenceDiagram
  participant User
  participant WAF
  participant CDN
  participant ALB
  participant NGINX
  participant LMS
  participant CMS
  participant DBs

  User->>WAF: HTTPS request
  WAF->>CDN: Allowed traffic
  CDN->>ALB: Cache miss / dynamic request
  ALB->>NGINX: Forwarded HTTPS
  NGINX->>LMS: /courses /dashboard
  NGINX->>CMS: /studio
  LMS->>DBs: MySQL/Mongo/ES/Redis
  CMS->>DBs: MySQL/Mongo/ES/Redis
  LMS-->>User: Response via NGINX/CDN
  CMS-->>User: Response via NGINX/CDN

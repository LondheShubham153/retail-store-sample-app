# Architecture Diagram

```mermaid
flowchart TB
  subgraph Security[Security Layer]
    WAF[WAF]
    CDN[CDN]
    LB[Load Balancer]
    WAF --> CDN --> LB
  end

  subgraph Web[Web Server Layer]
    NGINX[Nginx Ingress Controller]
  end

  subgraph App[Application Layer (K8s)]
    LMS[LMS Pod]
    CMS[CMS Pod]
    WORKERS[Workers]
  end

  subgraph Data[External Data Layer]
    MYSQL[(MySQL)]
    MONGO[(MongoDB)]
    ES[(Elasticsearch)]
    REDIS[(Redis)]
  end

  subgraph Storage[Storage]
    PV[(PV/PVC for media/uploads)]
    S3[(Object Storage for media)]
  end

  LB --> NGINX
  NGINX --> LMS
  NGINX --> CMS
  LMS --> WORKERS
  CMS --> WORKERS

  LMS --> MYSQL
  LMS --> MONGO
  LMS --> ES
  LMS --> REDIS

  CMS --> MYSQL
  CMS --> MONGO
  CMS --> ES
  CMS --> REDIS

  LMS --> PV
  CMS --> PV
  PV --> S3

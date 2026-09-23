# CloudGuard — Secure AWS Production Platform

[![Infrastructure CI](https://github.com/Seugne/cyber-platform-lab/actions/workflows/terraform-ci.yml/badge.svg?branch=main)](https://github.com/Seugne/cyber-platform-lab/actions/workflows/terraform-ci.yml)
[![Application Security CI](https://github.com/Seugne/cyber-platform-lab/actions/workflows/application-security-ci.yml/badge.svg?branch=main)](https://github.com/Seugne/cyber-platform-lab/actions/workflows/application-security-ci.yml)
[![Deployment & DAST](https://github.com/Seugne/cyber-platform-lab/actions/workflows/deployment-dast.yml/badge.svg?branch=main)](https://github.com/Seugne/cyber-platform-lab/actions/workflows/deployment-dast.yml)


CloudGuard is a production-oriented AWS security case study built with **Terraform**, **GitHub Actions** and layered DevSecOps controls.

It demonstrates the complete path from infrastructure design to production validation:

```text
Terraform
   ↓
Infrastructure CI
   ↓
Application Security CI
   ↓
GitHub production deployment
   ↓
AWS production environment
   ↓
HTTPS runtime validation
   ↓
OWASP ZAP DAST
```

## Recruiter / engineering quick scan

| Question | Answer |
|---|---|
| What is it? | Secure AWS production platform built and validated end-to-end |
| How is it provisioned? | Terraform |
| How does CI authenticate to AWS? | GitHub OIDC — no long-lived AWS keys |
| Where are workloads? | Private EC2 subnets; public ingress only through ALB |
| How is the database exposed? | It is not public; PostgreSQL RDS stays private |
| How is delivery controlled? | Separate PLAN/DEPLOY roles + manual production input |
| What security gates run? | Gitleaks, Trivy IaC/FS/Image, Semgrep, non-root check, health check |
| What happens after deploy? | HTTPS verification, target health validation, OWASP ZAP DAST |
| DAST result | **136 PASS / 5 WARN / 0 FAIL** |

## Executive summary

CloudGuard deploys an AWS environment in `eu-west-3` with:

- 1 VPC (`10.0.0.0/16`);
- 2 Availability Zones;
- 2 public + 2 private subnets;
- Internet Gateway + NAT Gateway;
- S3 gateway endpoint and private SSM-related endpoints;
- 2 private EC2 instances;
- Application Load Balancer exposed through HTTPS;
- Route 53 DNS + ACM certificate for `app.cloudguardlab.fr`;
- private PostgreSQL RDS;
- KMS encryption;
- CloudTrail, CloudWatch and AWS Config;
- remote Terraform backend in S3 with KMS encryption and locking;
- GitHub OIDC with separate PLAN and DEPLOY IAM roles;
- SAST, secret detection, dependency scanning, image scanning and DAST.

---

## Architecture

![CloudGuard architecture](architecture/images/architecture-overview.png)

- [Open full-resolution architecture](architecture/images/architecture-full.png)
- [Architecture PDF](architecture/cloudguard-architecture-v3.pdf)
- [Draw.io source](architecture/cloudguard-architecture-v3.drawio)

### Deployed VPC

![AWS VPC resource map](../docs/evidence/cloudguard/05-vpc-resource-map.png)

The deployed VPC separates Internet-facing ingress from private compute and data layers.

```text
Internet
   │
Route 53 / ACM
   │
ALB — HTTPS :443
   │
Target Group
   │
Private App EC2 :8080
   │
Private PostgreSQL RDS :5432

Private Admin EC2
   │
AWS Systems Manager
   │
VPC Endpoints
```

---

## Security architecture

### Identity & CI/CD

- GitHub Actions authenticates to AWS through **OIDC**.
- No long-lived AWS access keys are stored in GitHub.
- A dedicated **PLAN** role performs infrastructure planning.
- A separate **DEPLOY** role is trusted from the GitHub `production` environment.
- Production deployment is manually triggered with an explicit boolean deploy input and runs in the GitHub `production` environment.

### Network security

- Application and administration EC2 instances are private.
- No inbound SSH administration path is required.
- SSM connectivity is provided through private VPC endpoints.
- Security groups implement explicit ALB → app and app → RDS paths.
- RDS is **not publicly accessible**.
- Public ingress terminates on the ALB over HTTPS.

### Encryption & governance

- Terraform remote state uses S3 + KMS + locking.
- Audit data uses KMS-backed encryption.
- RDS storage is encrypted.
- CloudTrail, CloudWatch and AWS Config provide governance and audit visibility.

---

## DevSecOps pipelines

CloudGuard uses three complementary GitHub Actions workflows.

### 1. Infrastructure CI

Workflow: [`.github/workflows/terraform-ci.yml`](../.github/workflows/terraform-ci.yml)

Purpose:

- Terraform format / validation;
- secret scanning;
- Infrastructure as Code security scanning;
- AWS OIDC authentication;
- LAB and PRODUCTION plans;
- no automatic infrastructure apply.

Validated pre-deployment plans:

```text
LAB        31 to add, 0 to change, 0 to destroy
PRODUCTION 78 to add, 0 to change, 0 to destroy
```

The LAB profile intentionally disables the public HTTPS listener while PRODUCTION enables the full ingress path.

### 2. Application Security CI

Workflow: [`.github/workflows/application-security-ci.yml`](../.github/workflows/application-security-ci.yml)

| Control | Purpose |
|---|---|
| Python validation | Syntax validation |
| Gitleaks | Secret detection |
| Semgrep | Static Application Security Testing |
| Trivy filesystem | Dependency vulnerability analysis |
| Docker build | Reproducible application artifact |
| Non-root validation | Container privilege reduction |
| Health check | Runtime validation |
| Trivy image | Container vulnerability analysis |

### 3. Production Deployment & DAST

Workflow: [`.github/workflows/deployment-dast.yml`](../.github/workflows/deployment-dast.yml)

The production workflow performs:

1. GitHub OIDC authentication;
2. Terraform initialization against the remote backend;
3. production plan;
4. controlled `terraform apply`;
5. ALB target-health wait;
6. HTTPS health verification;
7. OWASP ZAP Full Scan;
8. ZAP report upload as a workflow artifact.

---

## Runtime validation

The deployed path is:

```text
Internet
  ↓
Route 53 / ACM
  ↓
ALB — HTTPS :443
  ↓
cloudguard-app-tg
  ↓
private application EC2 :8080
  ↓
private PostgreSQL RDS :5432
```

### ALB target health

![CloudGuard target group health](../docs/evidence/cloudguard/06-target-group-healthy.png)

AWS reports **1 healthy / 0 unhealthy** registered application targets before the pipeline continues to HTTPS validation and DAST.

### Private database

PostgreSQL RDS is deployed with:

- engine: PostgreSQL;
- instance class: `db.t3.micro`;
- port: `5432`;
- publicly accessible: **No**;
- encrypted storage;
- Secrets Manager-managed master credentials;
- enhanced monitoring.

### Application health

![Application health endpoint](../docs/evidence/cloudguard/09-health-endpoint.png)

The public HTTPS endpoint reaches the private application instance successfully. The returned internal EC2 hostname is also useful evidence that the public request terminates at the ALB and is forwarded to a private workload.

---

## Evidence strategy

The repository keeps the README focused on high-signal evidence rather than duplicating every console screen. CI/CD proof is linked through the live GitHub Actions workflows and badges; AWS screenshots are used where they prove runtime state that the source code alone cannot show.

| Evidence | What it proves |
|---|---|
| VPC resource map | public/private segmentation, routing, IGW, NAT and S3 endpoint |
| Target Group health | ALB can reach the private application on port 8080 |
| HTTPS health endpoint | end-to-end public HTTPS → ALB → private EC2 path |
| GitHub Actions workflows | repeatable IaC, AppSec and production/DAST automation |
| ZAP workflow artifact | retained dynamic-security output |

## DAST evidence

The live production endpoint was scanned with OWASP ZAP after deployment.

```text
FAIL-NEW: 0
FAIL-INPROG: 0
WARN-NEW: 5
WARN-INPROG: 0
INFO: 0
IGNORE: 0
PASS: 136
```

Representative warnings:

- `X-Content-Type-Options` header missing;
- HSTS header not set;
- server version information exposure;
- Spring Actuator information exposure;
- Cross-Origin-Resource-Policy header missing or invalid.

These findings are documented as remediation work rather than removed from the evidence.

---

## Repository layout

```text
01-terraform-aws/
├── bootstrap/
│   ├── backend/
│   ├── dns/
│   └── github-oidc/
├── architecture/
└── terraform/
    ├── environments/
    │   ├── lab.tfvars
    │   └── production.tfvars
    └── *.tf

02-ci-security/
├── app/
├── Dockerfile
└── requirements.txt

.github/workflows/
├── terraform-ci.yml
├── application-security-ci.yml
└── deployment-dast.yml
```

---

## Reproducibility and cost control

The persistent foundation is deliberately separated from the disposable production stack.

**Persistent**

- Terraform state backend;
- Route 53 hosted zone;
- GitHub OIDC bootstrap.

**Recreatable**

- application VPC;
- ALB;
- EC2;
- RDS;
- NAT Gateway;
- VPC endpoints;
- audit / governance resources.

This allows the production lab to be deployed for validation and then removed to control AWS costs.

---

## What this project demonstrates

- AWS network architecture and segmentation;
- Terraform state and lifecycle management;
- IAM and workload identity federation;
- secure CI/CD design;
- container hardening;
- SAST / secrets / dependency / image scanning;
- TLS and load balancing;
- private database design;
- AWS governance services;
- post-deployment DAST;
- security finding documentation and remediation workflow.

---

## Author

**Alain SEUGNE**

Cloud Security • DevSecOps • Infrastructure Security

# Cyber Platform Lab

> **Security engineering portfolio focused on Cloud Security, DevSecOps, Kubernetes Security, Detection Engineering and Secrets Management.**

This repository is structured as a set of hands-on engineering case studies. The objective is not to collect isolated demos, but to show how I design, secure, automate, validate and document infrastructure in a way that can be reviewed by another engineer.

## Featured case study — CloudGuard

**CloudGuard** is a production-oriented AWS security lab built with Terraform and GitHub Actions.

It combines:

- segmented AWS networking across two Availability Zones;
- private application and administration EC2 instances;
- an internet-facing Application Load Balancer with **HTTPS :443**;
- a private PostgreSQL RDS database;
- AWS Systems Manager connectivity through VPC endpoints;
- encryption with KMS;
- CloudTrail, CloudWatch and AWS Config;
- remote Terraform state in S3 with KMS encryption and state locking;
- GitHub OIDC federation instead of long-lived AWS credentials;
- Infrastructure as Code security checks;
- application, dependency and container security scans;
- controlled production deployment;
- post-deployment OWASP ZAP DAST.

### What was validated

| Control | Evidence |
|---|---|
| Infrastructure CI | Terraform validation + security checks + LAB/PRODUCTION plans |
| Secret detection | Gitleaks — no leaks detected |
| SAST | Semgrep |
| Dependency / filesystem scan | Trivy |
| Container hardening | non-root runtime + image scan |
| AWS authentication | GitHub OIDC with separate PLAN and DEPLOY roles |
| Production delivery | protected GitHub `production` environment |
| Runtime health | ALB target healthy + HTTPS health endpoint |
| DAST | OWASP ZAP Full Scan |
| ZAP result | **136 PASS / 5 WARN / 0 FAIL** |

### Architecture evidence

![CloudGuard VPC resource map](docs/evidence/cloudguard/05-vpc-resource-map.png)

The deployed VPC contains two public and two private subnets across `eu-west-3a` and `eu-west-3b`, dedicated route tables, an Internet Gateway, a NAT Gateway and private AWS service connectivity.

### CI/CD evidence

| Infrastructure CI | Application Security CI |
|---|---|
| ![Infrastructure CI](docs/evidence/cloudguard/01-infrastructure-ci.png) | ![Application Security CI](docs/evidence/cloudguard/02-application-security-ci.png) |

| Production deployment | DAST result |
|---|---|
| ![Deployment and DAST](docs/evidence/cloudguard/03-deployment-dast.png) | ![OWASP ZAP results](docs/evidence/cloudguard/04-zap-results.png) |

### Runtime evidence

| ALB target health | HTTPS listener |
|---|---|
| ![Target group healthy](docs/evidence/cloudguard/06-target-group-healthy.png) | ![ALB HTTPS](docs/evidence/cloudguard/07-alb-https.png) |

| Private RDS | Application health |
|---|---|
| ![Private RDS](docs/evidence/cloudguard/08-rds-private.png) | ![Application health](docs/evidence/cloudguard/09-health-endpoint.png) |

**Detailed case study:** [01-terraform-aws/README.md](01-terraform-aws/README.md)

---

## Engineering workflow

The project follows the same operating model used throughout the portfolio:

```text
Design
  ↓
Infrastructure as Code
  ↓
Static security validation
  ↓
Application & container security
  ↓
Controlled deployment
  ↓
Runtime health verification
  ↓
Dynamic security testing
  ↓
Evidence & remediation
```

Security checks are treated as deployment controls rather than documentation-only exercises.

---

## Repository roadmap

| Module | Focus | Status |
|---|---|---|
| [01-terraform-aws](01-terraform-aws/) | AWS Cloud Security / Terraform | **Implemented & validated** |
| [02-ci-security](02-ci-security/) | DevSecOps / AppSec / Container Security | **Implemented & integrated** |
| [03-k8s-hardening](03-k8s-hardening/) | Kubernetes hardening | Portfolio module |
| [04-detection-lab](04-detection-lab/) | Detection engineering / SOC | Portfolio module |
| [05-vault-secrets](05-vault-secrets/) | Secrets management / Vault | Portfolio module |

The repository is intentionally organized so each module can become an independent technical case study while contributing to the same security engineering portfolio.

---

## Technology stack

**Cloud & IaC:** AWS, Terraform  
**CI/CD:** GitHub Actions  
**Application:** Python, Flask, Gunicorn  
**Containers:** Docker  
**Security:** Gitleaks, Semgrep, Trivy, OWASP ZAP  
**AWS Security & Governance:** IAM, KMS, CloudTrail, CloudWatch, AWS Config, SSM  
**Data:** Amazon RDS PostgreSQL  
**Networking:** VPC, ALB, NAT Gateway, Route 53, ACM, VPC Endpoints

---

## Key engineering decisions

- **No static AWS keys in GitHub Actions:** workloads assume IAM roles through GitHub OIDC.
- **PLAN and DEPLOY are separated:** read-only planning is distinct from production deployment permissions.
- **Private workloads:** application, administration and database layers are not directly exposed to the Internet.
- **TLS termination at the ALB:** public traffic reaches `app.cloudguardlab.fr` over HTTPS.
- **Private database:** PostgreSQL RDS is not publicly accessible.
- **Remote Terraform state:** S3 + KMS + locking are kept outside the disposable application stack.
- **Security gates before and after deployment:** static controls run before delivery; ZAP validates the live HTTPS endpoint afterward.
- **Evidence-driven validation:** CI summaries, AWS console state and security scan artifacts are retained as proof of implementation.

---

## Security findings

The DAST run completed with:

```text
FAIL-NEW: 0
WARN-NEW: 5
PASS: 136
```

The remaining warnings are treated as remediation items, not hidden results. They include missing security headers and server-information exposure. This demonstrates the full engineering loop: **deploy → test → identify findings → remediate**.

---

## Author

**Alain SEUGNE**

Cloud Security • DevSecOps • Infrastructure Security • Detection Engineering • Security Operations

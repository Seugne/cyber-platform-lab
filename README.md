# Cyber Platform Lab

[![Infrastructure CI](https://github.com/Seugne/cyber-platform-lab/actions/workflows/terraform-ci.yml/badge.svg?branch=main)](https://github.com/Seugne/cyber-platform-lab/actions/workflows/terraform-ci.yml)
[![Application Security CI](https://github.com/Seugne/cyber-platform-lab/actions/workflows/application-security-ci.yml/badge.svg?branch=main)](https://github.com/Seugne/cyber-platform-lab/actions/workflows/application-security-ci.yml)
[![Deployment & DAST](https://github.com/Seugne/cyber-platform-lab/actions/workflows/deployment-dast.yml/badge.svg?branch=main)](https://github.com/Seugne/cyber-platform-lab/actions/workflows/deployment-dast.yml)


> **Security engineering portfolio focused on Cloud Security, DevSecOps, Kubernetes Security, Detection Engineering and Secrets Management.**

This repository is structured as a set of hands-on engineering case studies. The goal is not to collect isolated demos, but to show how I design, secure, automate, validate and document infrastructure so another engineer can review the decisions and evidence.

## Featured case study — CloudGuard

> **Project 1 status: deployed, runtime-validated and security-tested on AWS.**


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

### Recruiter quick scan

| Area | Implementation |
|---|---|
| Cloud | AWS `eu-west-3`, 2 AZ, public/private subnet segmentation |
| IaC | Terraform with remote S3 state, KMS encryption and locking |
| Identity | GitHub OIDC; separate PLAN and DEPLOY IAM roles |
| Runtime | Private EC2 application, ALB HTTPS :443, private PostgreSQL RDS |
| AppSec | Gitleaks, Semgrep, Trivy filesystem + image |
| Production test | HTTPS health validation + OWASP ZAP full DAST |
| DAST outcome | **136 PASS / 5 WARN / 0 FAIL** |

### What was validated

| Control | Result |
|---|---|
| Infrastructure CI | Terraform validation + security checks + LAB/PRODUCTION plans |
| Secret detection | Gitleaks — no leaks detected |
| SAST | Semgrep |
| Dependency / filesystem scan | Trivy |
| Container hardening | non-root runtime + image scan |
| AWS authentication | GitHub OIDC with separate PLAN and DEPLOY roles |
| Production delivery | GitHub `production` environment + explicit manual deploy input |
| Runtime health | ALB target healthy + HTTPS health endpoint |
| DAST | OWASP ZAP Full Scan |
| ZAP result | **136 PASS / 5 WARN / 0 FAIL** |

### Deployed network

![CloudGuard VPC resource map](docs/evidence/cloudguard/05-vpc-resource-map.png)

### Runtime proof

The public endpoint is served through an AWS Application Load Balancer and reaches a healthy private EC2 target.

![CloudGuard target group health](docs/evidence/cloudguard/06-target-group-healthy.png)

**Detailed technical case study:** [01-terraform-aws/README.md](01-terraform-aws/README.md)

---

## Engineering workflow

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
- **PLAN and DEPLOY are separated:** planning permissions are distinct from production deployment permissions.
- **Private workloads:** application, administration and database layers are not directly exposed to the Internet.
- **TLS termination at the ALB:** public traffic reaches `app.cloudguardlab.fr` over HTTPS.
- **Private database:** PostgreSQL RDS is not publicly accessible.
- **Remote Terraform state:** S3 + KMS + locking are kept outside the disposable application stack.
- **Security gates before and after deployment:** static controls run before delivery; the deployment workflow rejects unexpected Terraform changes/destructions; ZAP validates the live HTTPS endpoint afterward.
- **Evidence-driven validation:** CI summaries, AWS state and security scan artifacts are retained as implementation evidence.

---

## Security findings

The production DAST run completed with:

```text
FAIL-NEW: 0
WARN-NEW: 5
PASS: 136
```

The remaining warnings are treated as remediation items, not hidden results. They include missing security headers and server-information exposure. This keeps the engineering loop explicit: **deploy → test → identify findings → remediate**.

---

## Author

**Alain SEUGNE**

Cloud Security • DevSecOps • Infrastructure Security • Detection Engineering • Security Operations

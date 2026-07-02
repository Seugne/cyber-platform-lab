# Cyber Platform Lab

Cyber Platform Lab is a cybersecurity engineering laboratory developed throughout my Master's curriculum to consolidate practical experience in Cloud Security, DevSecOps, Detection Engineering, Kubernetes Security and Secrets Management.

Rather than presenting isolated demonstrations, this repository documents the progressive construction of a complete security platform reproducing technologies and operational workflows commonly encountered in enterprise environments.

Each laboratory contributes to the same objective: designing, deploying, securing, monitoring and continuously improving modern infrastructures.

---

# Laboratory Overview

The platform is currently organised into five complementary laboratories covering the main domains of infrastructure security.

Throughout the project, the platform brings together:

- **5 technical laboratories**
- **3 cloud and infrastructure environments**
- **3 Kubernetes nodes**
- **8 containerized workloads**
- **25+ Terraform-managed resources**
- **25+ centralized log sources**
- **20 custom detection rules**
- **10 MITRE ATT&CK validation scenarios**
- **8 Falco runtime detection rules**
- **6 security dashboards**
- **6 Kubernetes namespaces**
- **6 RBAC roles**
- **6 RoleBindings**
- **5 Network Policies**
- **5 automated CI/CD security stages**
- **5 Vault access policies**
- **4 Gatekeeper admission policies**
- **3 authentication methods**
- **2 secret engines**
- **1 centralized SIEM platform**
- **1 HashiCorp Vault deployment**
- **1 GitHub Actions security pipeline**

Each module is documented independently while contributing to the same engineering workflow.

---

# Repository Structure

```
Cyber Platform Lab
│
├── 01-terraform-aws
├── 02-ci-security
├── 03-k8s-hardening
├── 04-detection-lab
├── 05-vault-secrets
│
├── docs
├── screenshots
└── scripts
```

---

# CloudGuard

CloudGuard focuses on the deployment of a secure AWS infrastructure using Infrastructure as Code.

The laboratory covers network segmentation, identity management, encrypted storage, infrastructure auditing and compliance validation through Terraform.

---

# SecurePipeline

SecurePipeline demonstrates how security can be integrated throughout a modern software delivery process.

The pipeline combines automated source code analysis, secret detection, container security, dynamic application testing and infrastructure validation before deployment.

---

# K8sSec

K8sSec documents the hardening of a Kubernetes cluster composed of three nodes.

The project progressively introduces workload isolation, RBAC, admission control, runtime monitoring and compliance validation using production-oriented security controls.

---

# SOCLab

SOCLab reproduces a Security Operations environment dedicated to log collection, threat detection and incident investigation.

The platform centralises events from Windows and Linux systems, correlates security telemetry and validates custom detection rules against representative attack scenarios.

---

# VaultOps

VaultOps implements centralized secrets management using HashiCorp Vault.

The laboratory demonstrates secure authentication, policy enforcement, dynamic secrets and automated credential management for infrastructure and CI/CD environments.

---

# Technology Stack

Infrastructure

- AWS
- Terraform

Containers

- Docker
- Kubernetes
- Helm

DevSecOps

- GitHub Actions
- Jenkins
- GitLab CI

Application Security

- Semgrep
- Trivy
- OWASP ZAP
- Gitleaks

Detection Engineering

- Elastic Stack
- Wazuh
- Sigma
- MITRE ATT&CK

Secrets Management

- HashiCorp Vault

Operating Systems

- Linux
- Windows Server

Programming

- Python
- Bash

---

# Engineering Approach

Each laboratory follows the same development methodology.

1. Architecture design
2. Infrastructure deployment
3. Security implementation
4. Validation
5. Documentation
6. Continuous improvement

This approach ensures that every technical decision can be reproduced, verified and progressively improved as the platform evolves.

---

# Repository Status

This laboratory is actively maintained as part of my cybersecurity curriculum.

Each project is progressively completed with:

- architecture documentation
- implementation details
- validation procedures
- security decisions
- screenshots
- technical notes

The objective is to build a complete technical portfolio reflecting practical cybersecurity engineering skills through reproducible laboratory environments.

---

## Author

**Alain SEUGNE**

OSCP • Cloud Security • DevSecOps • Infrastructure Security • Detection Engineering • Security Operations

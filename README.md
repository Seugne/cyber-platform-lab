# Cyber Platform Lab

Cyber Platform Lab is a structured cybersecurity laboratory developed throughout my academic training to consolidate practical experience across several domains of modern cybersecurity.

Rather than presenting isolated demonstrations, this repository brings together complementary projects that collectively illustrate the lifecycle of securing an infrastructure: designing, deploying, protecting, monitoring and continuously improving production-like environments.

Each laboratory focuses on a specific technical area while remaining part of the same engineering approach.

---

## Scope

The repository currently covers five major areas frequently encountered in enterprise environments:

- Cloud Infrastructure Security
- DevSecOps
- Kubernetes Security
- Detection Engineering
- Secrets Management

Every module has its own documentation, configuration files and implementation roadmap.

---

## Repository Layout

```
Cyber Platform Lab

01-terraform-aws
 02-ci-security
 03-k8s-hardening
 04-detection-lab
 05-vault-secrets

 docs
 screenshots
 scripts
```

---

# Projects

## 01 — CloudGuard

Design and deployment of a secure AWS infrastructure using Terraform.

The objective is to build a reproducible cloud environment following Infrastructure as Code principles while integrating security controls from the first deployment.

Topics covered include:

- Virtual Private Cloud design
- IAM least privilege
- Secure storage
- CloudTrail logging
- Infrastructure validation
- Security compliance

---

## 02 — SecurePipeline

Implementation of a secure software delivery pipeline integrating automated security verification before deployment.

The laboratory combines software development with security controls in order to demonstrate how vulnerabilities and configuration issues can be detected as early as possible.

Topics include:

- GitHub Actions
- Static analysis
- Secret detection
- Container image scanning
- Dynamic application testing
- Deployment validation

---

## 03 — K8sSec

Hardening of Kubernetes environments using defensive security controls commonly deployed in production clusters.

The project focuses on reducing the attack surface while enforcing secure operational practices.

Main subjects include:

- RBAC
- Admission Control
- Network Segmentation
- Runtime Security
- Security Policies
- Cluster Hardening

---

## 04 — SOCLab

Detection Engineering laboratory dedicated to security monitoring and incident detection.

The objective is to reproduce a simplified Security Operations Center capable of collecting logs, correlating events and identifying suspicious activity.

Topics include:

- Elastic Stack
- Wazuh
- Detection Rules
- Threat Hunting
- Incident Analysis
- MITRE ATT&CK mapping

---

## 05 — VaultOps

Implementation of centralized secrets management using HashiCorp Vault.

The laboratory demonstrates how sensitive credentials can be removed from source code and securely distributed to applications.

Topics include:

- Vault Policies
- Dynamic Secrets
- Authentication Methods
- Secret Rotation
- CI/CD Integration
- Zero Trust Principles

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
- GitLab CI
- Jenkins

Application Security

- Semgrep
- Trivy
- OWASP ZAP
- Gitleaks

Detection

- Elastic Stack
- Wazuh

Operating Systems

- Linux
- Windows

Programming

- Python
- Bash

---

# Repository Status

The laboratory is under continuous development.

Each project progresses through the same engineering workflow:

- architecture design
- implementation
- validation
- documentation
- security review
- operational testing

As development progresses, each module is completed with implementation notes, validation evidence and supporting documentation.

---

# Purpose

The objective of this repository is to document the practical work carried out throughout my cybersecurity curriculum and to progressively build a coherent technical portfolio reflecting modern security engineering practices.

---

## Author

**Alain SEUGNE**

GitHub  
https://github.com/Seugne

LinkedIn  
https://linkedin.com/in/alain-seugne# Laboratoire de cyber-plateforme

Laboratoire technique académique orienté **Cloud Security**, **DevSecOps**, **Kubernetes Security**, **Detection Engineering**, **Security Operations** et **Secrets Management**.

Ce dépôt centralise plusieurs modules construits dans la continuité d'un parcours en cybersécurité. L'objectif est de documenter une plateforme cohérente couvrant le cycle opérationnel de la sécurité : **conception sécurisée → protection → supervision → détection → correction → amélioration continue**.

## Vue d'ensemble

 Module | Domaine | Objectif | Documentation |

 [01-terraform-aws](./01-terraform-aws) | Cloud Security / Infrastructure as Code | Concevoir une base AWS sécurisée avec Terraform, IAM, VPC, S3, CloudTrail et contrôles de conformité | [README](./01-terraform-aws/README.md) |
 [02-ci-security](./02-ci-security) | DevSecOps / CI/CD Security | Intégrer des contrôles de sécurité automatisés dans une chaîne CI/CD | [README](./02-ci-security/README.md) |
 [03-k8s-hardening](./03-k8s-hardening) | Kubernetes Security | Renforcer un environnement Kubernetes avec RBAC, Network Policies, Gatekeeper et Falco | [README](./03-k8s-hardening/README.md) |
 [04-detection-lab](./04-detection-lab) | SIEM / Detection Engineering | Centraliser les journaux et construire des règles de détection | [README](./04-detection-lab/README.md) |
 [05-vault-secrets](./05-vault-secrets) | Secrets Management / Zero Trust | Externaliser les secrets applicatifs et intégrer Vault dans une chaîne DevSecOps | [README](./05-vault-secrets/README.md) |

## Objectif général

Ce laboratoire n'est pas conçu comme une juxtaposition d'exercices isolés. Il vise à documenter une progression technique autour de la sécurisation d'infrastructures modernes :

- conception d'environnements Cloud sécurisés ;
- automatisation des contrôles de sécurité ;
- sécurisation des systèmes Linux et Kubernetes ;
- détection et supervision des événements de sécurité ;
- gestion sécurisée des secrets ;
- amélioration continue des politiques de sécurité.

## Logique cybersécurité

Le dépôt suit une logique proche du cycle opérationnel attendu en cybersécurité :

1. **Construire** une infrastructure sécurisée.
2. **Protéger** les applications, les secrets et les environnements.
3. **Surveiller** les journaux et événements.
4. **Détecter** les comportements anormaux.
5. **Corriger** les écarts de configuration ou de sécurité.
6. **Documenter** les choix techniques et les remédiations.

## Correspondance avec les attendus SeCReTS / cybersécurité

| Attendu technique | Modules concernés |

 Sécurité des réseaux et infrastructures | 01-terraform-aws, 03-k8s-hardening |
 Systèmes Linux / Windows et administration sécurisée | 03-k8s-hardening, 04-detection-lab |
 Cloud Security et Infrastructure as Code | 01-terraform-aws |
 DevSecOps et sécurité applicative | 02-ci-security |
 Détection, supervision et Security Operations | 04-detection-lab |
 Politiques de sécurité, conformité et gouvernance | 01-terraform-aws, 03-k8s-hardening |
 Gestion des secrets et approche Zero Trust | 05-vault-secrets |

## État du dépôt

Le dépôt est en construction progressive. Chaque module contient une structure technique, une documentation d'objectif, des fichiers de base et une feuille de route de validation.

Les prochaines évolutions prévues sont :

- ajout de schémas d'architecture ;
- ajout de captures d'écran ;
- enrichissement des fichiers Terraform, Kubernetes et CI/CD ;
- ajout de rapports de scan ;
- ajout de journaux d'exécution ;
- documentation des choix de sécurité ;
- documentation des remédiations.

## Utilisation

Chaque module possède son propre README afin de présenter :

- le contexte ;
- les objectifs ;
- l'architecture cible ;
- les technologies utilisées ;
- les compétences mobilisées ;
- les étapes de validation prévues ;
- les livrables attendus.
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

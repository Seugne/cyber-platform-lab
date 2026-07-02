# VaultOps

VaultOps documents the implementation of centralized secrets management using HashiCorp Vault within a modern infrastructure.

The objective is to eliminate static credentials from applications and deployment pipelines by introducing controlled, auditable and short-lived access to sensitive resources.

The laboratory follows Zero Trust principles where authentication, authorization and secret distribution are managed independently from application code.

---

## Project Objectives

This project focuses on building a secure secrets management platform capable of supporting cloud infrastructure and DevSecOps workflows.

The implementation progressively introduces authentication methods, access policies, dynamic credentials and automated secret rotation.

---

## Technical Scope

Current implementation includes:

- HashiCorp Vault
- Docker Compose
- Vault Policies
- AppRole Authentication
- Dynamic Secrets
- Audit Logging
- AWS Integration
- CI/CD Integration

---

## Laboratory Architecture

The target environment includes:

- **1 Vault Server**
- **3 Authentication Methods**
- **5 Access Policies**
- **2 Secret Engines**
- **1 Audit Log Backend**
- **1 CI/CD Integration**
- **Dynamic AWS Credentials**
- **Automatic Secret Rotation**

Each component is progressively documented and validated during implementation.

---

## Repository Structure

```
config/
└── vault.hcl

policies/
└── ci-policy.hcl

docker-compose.yml

docs/
```

---

## Security Strategy

The platform separates secret management from application code.

Applications authenticate to Vault using dedicated identities instead of embedded credentials.

Access to secrets is controlled through least-privilege policies and every operation is recorded through audit logging.

Where applicable, credentials are generated dynamically and revoked automatically after expiration.

---

## Validation Strategy

Each implementation stage is validated through reproducible tests.

Validation includes:

- Vault initialization
- Policy verification
- Authentication tests
- Secret creation and retrieval
- Dynamic credential generation
- Secret rotation
- Audit log verification
- CI/CD integration

Validation evidence will progressively include command outputs, configuration files and screenshots.

---

## Current Status

The initial project structure has been prepared.

Configuration files, access policies and deployment components are available.

Additional integrations and validation reports will be added as implementation progresses.

---

## Learning Outcomes

This laboratory develops practical experience in:

- Secrets Management
- Zero Trust Architecture
- Identity and Access Management
- Secure DevSecOps
- HashiCorp Vault
- Infrastructure Security
- Cloud Security
- Security Automation

---

## Planned Improvements

Future iterations will include:

- Kubernetes Authentication
- PKI Secret Engine
- Database Dynamic Credentials
- Transit Encryption
- Response Wrapping
- Multi-Environment Integration
- Automated Secret Rotation

Each improvement will be documented together with its implementation rationale and validation results.

---

## Author

Alain SEUGNE

Cloud Security • DevSecOps • Infrastructure Security# 05-vault-secrets

Module de gestion des secrets avec HashiCorp Vault.

## Technologies

HashiCorp Vault, Docker, Terraform, GitHub Actions, IAM.

## Statut

Structure initiale du module.

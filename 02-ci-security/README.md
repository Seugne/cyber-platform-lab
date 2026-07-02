# SecurePipeline

SecurePipeline documents the implementation of a DevSecOps pipeline where security controls are integrated into the software delivery process from the first commit to deployment.

The objective is to demonstrate how automated security verification can reduce deployment risks while keeping the development workflow efficient.

Rather than treating security as a final verification step, this laboratory applies continuous validation throughout the CI/CD pipeline.

---

## Project Objectives

This project explores the integration of security tools within a modern software delivery workflow.

Each stage is designed to identify vulnerabilities, insecure configurations and exposed secrets before code reaches production.

---

## Technical Scope

The laboratory progressively integrates:

- GitHub Actions
- Docker
- Python Flask
- Static Application Security Testing (SAST)
- Dynamic Application Security Testing (DAST)
- Container Security
- Secret Detection
- Infrastructure Validation

---

## Repository Structure

```
app/
├── app.py

Dockerfile

requirements.txt

.github/
└── workflows/

docs/
```

Documentation and validation evidence will be progressively added during implementation.

---

## Security Workflow

The pipeline is designed around successive validation stages.

Source code is first analysed before the application is built.

Container images are then inspected for known vulnerabilities.

Secrets accidentally committed to the repository are automatically detected.

Infrastructure configuration is validated before deployment.

Only successful validation allows the pipeline to continue.

---

## Security Controls

The project integrates several complementary verification mechanisms:

- source code analysis with Semgrep
- secret detection with Gitleaks
- container vulnerability scanning with Trivy
- dynamic application testing using OWASP ZAP
- Infrastructure as Code validation

Each control addresses a different stage of the software supply chain.

---

## Validation Strategy

Every pipeline execution is intended to produce verifiable evidence, including:

- successful workflow execution
- security scan reports
- detected vulnerabilities
- remediation actions
- deployment validation

As the project progresses, validation reports and screenshots will be incorporated into the documentation.

---

## Current Status

The project currently contains the application structure together with the files required to build and secure the pipeline.

The security workflow will be progressively expanded as additional controls are implemented and validated.

---

## Learning Outcomes

This laboratory provides practical experience in:

- CI/CD security
- DevSecOps practices
- Secure software delivery
- Application security testing
- Container security
- Software supply chain security
- Automated security validation
- Continuous integration

---

## Future Work

Planned improvements include:

- dependency vulnerability scanning
- Software Bill of Materials (SBOM)
- container image signing
- artifact integrity verification
- deployment approval gates
- policy enforcement
- automated compliance reporting

Each addition will be documented together with its implementation rationale and validation process.

---

## Author

Alain SEUGNE

Cybersecurity • Cloud Security • DevSecOps# 02-ci-security

Module de pipeline CI/CD sécurisé avec scans automatisés.

## Technologies

GitHub Actions, Docker, Python Flask, Semgrep, Trivy, Gitleaks.

## Statut

Structure initiale du module.

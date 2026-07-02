# SecurePipeline

SecurePipeline documents the implementation of a secure software delivery pipeline where security controls are integrated throughout the CI/CD lifecycle.

Rather than executing security checks after development, the laboratory applies a shift-left approach in which every code change is automatically validated before deployment.

The project reproduces the software supply chain of a modern application by combining development, containerization, automated testing and continuous security verification.

---

# Engineering Objectives

The objective of this laboratory is to demonstrate how DevSecOps practices reduce operational risk by integrating security into every stage of software delivery.

The implementation progressively introduces source code analysis, dependency verification, secret detection, container security, dynamic application testing and deployment validation before software reaches production.

---

# Laboratory Architecture

The target platform includes:

- **1 GitHub Repository**
- **1 GitHub Actions Pipeline**
- **1 Python Flask Application**
- **1 Docker Image**
- **5 Automated Security Stages**
- **4 Security Scanning Tools**
- **2 Deployment Environments**
- **1 Infrastructure Validation Stage**
- **1 Security Reporting Workflow**

The pipeline is designed so every stage produces measurable validation evidence before the deployment process continues.

---

# Repository Structure

```
app/
├── app.py

Dockerfile

requirements.txt

.github/
└── workflows/

docs/
```

---

# Security Controls

The pipeline integrates multiple layers of automated security verification.

Each execution performs:

- source code analysis with Semgrep
- secret detection with Gitleaks
- container vulnerability scanning with Trivy
- dynamic application testing using OWASP ZAP
- infrastructure validation before deployment

Every control contributes to reducing software supply chain risk while maintaining deployment reproducibility.

---

# Validation Workflow

Every pipeline execution follows the same engineering process.

1. Source code checkout
2. Dependency installation
3. Application build
4. Static security analysis
5. Secret detection
6. Container image scanning
7. Dynamic security testing
8. Infrastructure validation
9. Deployment approval
10. Security reporting

Each stage produces reproducible evidence allowing vulnerabilities to be identified and corrected before deployment.

---

# Technical Stack

CI/CD

- GitHub Actions
- Jenkins
- GitLab CI

Application

- Python
- Flask

Containerization

- Docker

Application Security

- Semgrep
- OWASP ZAP

Container Security

- Trivy

Secret Detection

- Gitleaks

Infrastructure Validation

- Checkov

---

# Skills Developed

This laboratory develops practical experience in:

- DevSecOps Engineering
- Secure CI/CD
- Software Supply Chain Security
- Static Application Security Testing
- Dynamic Application Security Testing
- Container Security
- Infrastructure Validation
- Continuous Security Integration

---

# Planned Extensions

Future iterations will progressively introduce:

- Software Bill of Materials (SBOM)
- Container Image Signing
- Dependency Vulnerability Analysis
- Artifact Integrity Verification
- Policy-as-Code Enforcement
- Automated Compliance Reporting
- Kubernetes Deployment Validation
- Continuous Security Monitoring

Each extension will be documented together with its implementation rationale, validation process and security impact.

---

# Current Status

The project structure has been established and the CI/CD foundation is in place.

Security controls are integrated progressively following the same engineering methodology adopted throughout the Cyber Platform Lab.

Implementation reports, workflow executions, validation evidence and remediation notes will be incorporated as the project evolves.

---

## Author

**Alain SEUGNE**

OSCP • Cloud Security • DevSecOps • Application Security

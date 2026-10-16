# SecurePipeline

SecurePipeline is a standalone DevSecOps / Application Security project focused on software delivery security.

## Goal

Build a security-gated CI/CD chain that decides whether an application artifact is allowed to progress toward Kubernetes deployment.

## Planned flow

```text
Developer
  ↓
GitHub
  ↓
GitHub Actions
  ↓
Gitleaks
  ↓
Semgrep
  ↓
Trivy filesystem / SCA
  ↓
Docker build
  ↓
Trivy image
  ↓
SBOM
  ↓
Cosign signature
  ↓
Container registry
  ↓
Kubernetes policy / admission checks
  ↓
Application deployment
  ↓
OWASP ZAP DAST
```

## Design principles

- Keep this project distinct from CloudGuard.
- Focus on software supply-chain and AppSec controls rather than AWS infrastructure.
- Demonstrate real security gates with FAIL → FIX → PASS scenarios.
- Prefer depth and explainability over adding unnecessary tools.
- Build and validate on a dedicated branch before merging to main.

## Planned project areas

- `app/` — Python / Flask demo application
- `architecture/` — draw.io architecture and exported diagrams
- `k8s/` — Kubernetes manifests
- `policies/` — security and admission policies
- `scripts/` — helper scripts and validation logic
- `.github/workflows/` — repository-level GitHub Actions workflows

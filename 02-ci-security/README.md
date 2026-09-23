# SecurePipeline — Application & Container Security CI

[![Application Security CI](https://github.com/Seugne/cyber-platform-lab/actions/workflows/application-security-ci.yml/badge.svg?branch=main)](https://github.com/Seugne/cyber-platform-lab/actions/workflows/application-security-ci.yml)


SecurePipeline is the application-security component of the CloudGuard case study. It validates source code, secrets, dependencies, the Docker image and application runtime before production deployment.

The active workflow is:

[`.github/workflows/application-security-ci.yml`](../.github/workflows/application-security-ci.yml)

## Pipeline controls

| Control | Purpose |
|---|---|
| Python validation | Syntax validation |
| Gitleaks | Secret detection |
| Semgrep | SAST |
| Trivy filesystem | Dependency / filesystem vulnerability analysis |
| Docker build | Reproducible artifact creation |
| Non-root validation | Runtime privilege reduction |
| Health check | Application runtime verification |
| Trivy image | Container vulnerability analysis |

## Production relationship

This pipeline is intentionally separate from infrastructure deployment.

```text
Application Security CI
        ↓
validated application/container
        ↓
Deployment & DAST
        ↓
live HTTPS endpoint
        ↓
OWASP ZAP Full Scan
```

The deployment workflow is:

[`.github/workflows/deployment-dast.yml`](../.github/workflows/deployment-dast.yml)

and runs in the GitHub `production` environment using AWS OIDC federation and an explicit manual deploy input.

## Application runtime

- Python / Flask application;
- Gunicorn production server;
- container runs as a non-root user;
- health endpoint is validated before security testing.

## Security evidence

The production DAST stage completed with:

```text
PASS: 136
WARN-NEW: 5
FAIL-NEW: 0
```

See the complete CloudGuard engineering case study:

**[CloudGuard — Secure AWS Production Platform](../01-terraform-aws/README.md)**

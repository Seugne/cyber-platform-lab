# CloudGuard Application

This directory contains the small Python/Flask application used by the CloudGuard case study for application, container and runtime security validation.

It is part of **CloudGuard** and is intentionally kept inside `01-terraform-aws/` so the AWS case study is self-contained. The standalone portfolio project `02-securepipeline/` is a separate DevSecOps / software supply-chain project.

## Active CI

The repository-level workflow is:

[`.github/workflows/application-security-ci.yml`](../../.github/workflows/application-security-ci.yml)

It validates:

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

## Runtime

- Python / Flask
- Gunicorn
- container runs as UID 10001
- HTTP service on port 8080
- `/health` endpoint for runtime validation

The production deployment and DAST workflow remains:

[`.github/workflows/deployment-dast.yml`](../../.github/workflows/deployment-dast.yml)

See the complete case study:

**[CloudGuard — Secure AWS Production Platform](../README.md)**

# K8sSec

K8sSec documents the design and hardening of a Kubernetes environment following production-oriented security practices.

The project focuses on reducing the attack surface of a cluster while implementing layered security controls across identity, networking, workload protection and runtime monitoring.

Rather than deploying applications only, the objective is to understand how Kubernetes can be secured throughout its operational lifecycle.

---

## Project Objectives

This laboratory reproduces a small production-oriented Kubernetes environment designed to validate security controls commonly implemented in enterprise infrastructures.

The platform is built around a **3-node Kubernetes cluster** and progressively integrates identity management, workload isolation, policy enforcement and runtime threat detection.

---

## Technical Scope

Current implementation includes:

- Kubernetes (k3s)
- Docker
- Helm
- RBAC
- Network Policies
- OPA Gatekeeper
- Falco
- CIS Kubernetes Benchmark

---

## Laboratory Architecture

The target environment includes:

- **1 Control Plane**
- **2 Worker Nodes**
- **6 Kubernetes Namespaces**
- **8 Containerized Workloads**
- **6 RBAC Roles**
- **6 RoleBindings**
- **5 Network Policies**
- **4 Gatekeeper Constraints**
- **8 Falco Detection Rules**

Each component is introduced progressively and documented as the project evolves.

---

## Repository Structure

```
manifests/
├── deployment.yaml
├── service.yaml
├── rbac.yaml
└── network-policy.yaml

policies/

docs/
```

---

## Security Implementation

The laboratory applies multiple layers of protection.

Identity and permissions are restricted through Role-Based Access Control.

East-west traffic is controlled using Network Policies.

Admission requests are validated before deployment through Gatekeeper.

Runtime activities are continuously monitored using Falco.

Security configuration is compared against the CIS Kubernetes Benchmark during validation.

---

## Validation Strategy

Each implementation phase is validated through reproducible tests.

Validation includes:

- successful cluster deployment
- namespace isolation
- RBAC verification
- network segmentation tests
- admission policy validation
- runtime event generation
- CIS Benchmark review

Evidence collected during validation will include configuration files, command outputs and screenshots.

---

## Current Status

The repository currently contains the initial manifests required to deploy the laboratory environment.

Additional security controls, validation reports and implementation notes will be added progressively.

---

## Learning Outcomes

This project develops practical experience in:

- Kubernetes Security
- Cluster Hardening
- Container Security
- Runtime Detection
- Admission Control
- Policy Enforcement
- Linux Container Isolation
- Secure Platform Engineering

---

## Planned Improvements

Future iterations will introduce:

- Private Container Registry
- Image Signature Verification
- Pod Security Standards
- Secrets Encryption
- External Secrets Operator
- GitOps deployment workflow
- Continuous compliance assessment

Each improvement will be documented together with its implementation, rationale and validation results.

---

## Author

Alain SEUGNE

Cloud Security • Kubernetes Security • DevSecOps# 03-k8s-hardening

Module de durcissement Kubernetes.

## Technologies

Kubernetes, k3d, kubectl, Helm, OPA Gatekeeper, Falco, Calico.

## Statut

Structure initiale du module.

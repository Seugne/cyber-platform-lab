# CloudGuard — Engineering Evidence

This directory contains selected runtime evidence for the CloudGuard case study.

The intent is **not** to archive every AWS console page. Evidence is selected when it proves a security or operational property that cannot be established from Terraform source alone.

| File | Engineering claim |
|---|---|
| `05-vpc-resource-map.png` | Two-AZ public/private subnet segmentation, route tables, Internet Gateway, NAT Gateway and S3 endpoint |
| `06-target-group-healthy.png` | The private application EC2 target is registered on HTTP :8080 and reported healthy by the ALB target group |
| `09-health-endpoint.png` | End-to-end HTTPS request reaches the CloudGuard application and returns a healthy runtime state |

CI/CD evidence remains directly verifiable through the live repository workflows:

- [Infrastructure CI](../../../actions/workflows/terraform-ci.yml)
- [Application Security CI](../../../actions/workflows/application-security-ci.yml)
- [Deployment & DAST](../../../actions/workflows/deployment-dast.yml)

Security testing is summarized in the main case study as **136 PASS / 5 WARN / 0 FAIL** for the successful OWASP ZAP production scan.

> Evidence is intentionally curated: **README explains → evidence proves → source code and workflow history confirm.**

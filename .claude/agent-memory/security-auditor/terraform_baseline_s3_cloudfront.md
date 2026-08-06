---
name: terraform-baseline-s3-cloudfront
description: Recurring structure and recurring security gaps found in terraform/ for the S3+CloudFront static site (main.tf, backend.tf, providers.tf, variables.tf, outputs.tf)
metadata:
  type: project
---

As of 2026-08-05, `terraform/` contains only 5 files: `main.tf`, `providers.tf`, `variables.tf`, `outputs.tf`, `backend.tf`. No IAM/OIDC resources are defined anywhere in this directory — the GitHub Actions deploy role/OIDC trust policy is managed outside Terraform (not reviewable from this repo alone).

**What's already done well (don't re-flag as new findings, just confirm still present):**
- `aws_s3_bucket_public_access_block` blocks all public access (all 4 flags true).
- `aws_s3_bucket_ownership_controls` uses `BucketOwnerEnforced` (ACLs disabled entirely).
- S3 bucket policy scopes access to `cloudfront.amazonaws.com` with a `AWS:SourceArn` condition tied to the specific distribution ARN — correctly scoped, not a wildcard.
- CloudFront uses OAC (`aws_cloudfront_origin_access_control`), not legacy OAI.
- `viewer_protocol_policy = "redirect-to-https"` enforces HTTPS.
- No hardcoded credentials, account IDs, or literal ARNs found in any `.tf` file.
- `.gitignore` correctly excludes `terraform/.terraform/`, `*.tfstate*`, `*.tfplan`, override files — state file hygiene is good.
- `backend.tf` currently ships with the S3 remote backend commented out (intentional bootstrap-first-then-migrate pattern, documented inline) — not itself a bug, but check on each audit whether it's since been uncommented/migrated.

**Recurring gaps to check on every audit of this repo** (as of 2026-08-05, all of these were absent):
1. No CloudFront Response Headers Policy — no CSP, X-Frame-Options, X-Content-Type-Options, Strict-Transport-Security, Referrer-Policy configured anywhere. This is the most consistently-missed checklist item for this repo.
2. No `aws_s3_bucket_server_side_encryption_configuration` on the site bucket.
3. No `aws_s3_bucket_versioning` on the site bucket.
4. No S3 access logging (`aws_s3_bucket_logging`) and no CloudFront `logging_config` block.
5. No WAF (`web_acl_id`) attached to the CloudFront distribution.
6. `viewer_certificate { cloudfront_default_certificate = true }` — this forces CloudFront's minimum TLS protocol to legacy TLSv1 and cannot be overridden while using the default cert. The `domain_name` variable in `variables.tf` is defined but unused anywhere in `main.tf` — if a custom domain + ACM cert is ever added, remember to also set `minimum_protocol_version = "TLSv1.2_2021"` and `ssl_support_method = "sni-only"`.
7. `backend.tf`'s commented-out S3 backend block uses `use_lockfile` (a Terraform >=1.10 feature) but `providers.tf` only pins `required_version = ">= 1.5"` — flag as a version-mismatch risk if/when the backend block is uncommented.

See [[project_portfolio_site]] for why this is judged as a low-overall-risk site (informs severity calibration — e.g., missing WAF is MEDIUM not CRITICAL here).

---
name: project-portfolio-site
description: What this repo's infrastructure is and its risk profile, for calibrating audit severity
metadata:
  type: project
---

This repo hosts a personal static portfolio website (subhamay-bhattacharyya) — pure HTML5/CSS3, no JS, no framework, no build step (per root `CLAUDE.md`). It's deployed to S3 + CloudFront via Terraform and GitHub Actions.

**Why this matters for audits:** the content served is entirely public marketing/portfolio content (About, Services, Courses, Books, Community, Contact) — there is no user data, no auth, no dynamic backend, no PII collected on the frontend. This means:
- Missing S3 encryption-at-rest / WAF / access logging are real gaps worth reporting (checklist items), but should be rated MEDIUM rather than CRITICAL/HIGH — the blast radius of a lapse here is defacement/availability, not data breach.
- Anything touching IAM/OIDC trust policy scoping or public bucket access should still be rated HIGH/CRITICAL if found, since a misconfiguration there could let an attacker overwrite site content or pivot to other AWS resources in the account.
- The project's own convention (`CLAUDE.md`): "All infrastructure changes go through Terraform — never modify AWS resources manually." If IAM/OIDC resources for the GitHub Actions deploy role are found to exist in AWS but are absent from `terraform/`, that's worth flagging as a process/governance gap, not just a technical one.

See [[terraform_baseline_s3_cloudfront]] for the current state of the actual Terraform resources.

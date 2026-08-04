# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions.

## Architecture

Pure HTML5 and CSS3. No JavaScript. No build step. No framework.

- **index.html** — Single-page portfolio (About, Services, Courses, Books, Community, Contact)
- **style.css** — All styling (~1145 lines), mobile-first responsive (breakpoints: 900px, 768px, 600px)
- **privacy.html / terms.html** — Standalone pages with inline styles
- **images/** — Static assets (logo, profile, course thumbnails, hero background)

## Commands

```bash
# Terraform
cd terraform && terraform init
cd terraform && terraform plan
cd terraform && terraform apply

# Local preview
open index.html

# Manual S3 sync (CI does this automatically)
aws s3 sync . s3://$BUCKET_NAME --exclude "terraform/*" --exclude ".git/*" --exclude ".github/*" --exclude "*.md" --exclude ".claude/*"
```

## Conventions

- All infrastructure changes go through Terraform — never modify AWS resources manually
- No JavaScript in this project
- CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Safety Layers

- Never put secrets in this file. No API keys, passwords, or AWS credentials.

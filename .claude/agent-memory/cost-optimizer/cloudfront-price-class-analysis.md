---
name: cloudfront-price-class-opportunity
description: CloudFront Price Class_200 may be over-provisioned for personal portfolio static site
metadata:
  type: feedback
---

**Issue**: CloudFront distribution in `terraform/main.tf:80` uses `PriceClass_200`, which provides global coverage across North America, Europe, Asia, and Middle East regions.

**Why**: Personal portfolio website serving static HTML/CSS with no indication of global audience requirement. Most portfolio traffic likely concentrated in North America or Europe.

**Recommendation**: Consider `PriceClass_100` (North America + Europe only) if audience is primarily regional, or `PriceClass_All` only if global distribution is genuinely needed.

**Estimated savings**: ~30% reduction on CloudFront data transfer costs (PriceClass_100 vs PriceClass_200).

**How to apply**: Before changing, verify actual traffic patterns via CloudFront metrics to confirm most requests come from supported regions.

---
name: skidora-security
description: >-
  No secrets in memory, no fake APIs, explicit destructive ops. Use when security, secrets, or deletions are in play.
---

# Security

All Skidora work stays safe by default.

## Secrets

- Never write secrets, tokens, `.env` values, or credentials into Helix files, graphs, plans, or chat.
- If a secret is needed to verify, use the project's existing env pattern; do not print values.

## Endpoints and files

- Do not hallucinate APIs, keys, or cloud resources.
- Confirm a path exists before editing or deleting.
- Destructive actions (delete component, drop route, reset data) require explicit user language or an answered P0.

## Agent conduct

- Least change that satisfies the request.
- No drive-by refactors, no unrelated dependency adds.
- Generated tools must not exfiltrate data or disable logging.
- Treat user-provided URLs and files as untrusted input when fetching.

## Failures

If a check needs credentials you do not have, that is Blocked (P0), not a skipped verify.

---
name: skidora-verify
description: >-
  Dual-pass verification: Pass A AST file:line, Pass B command+exit runtime proof, multi-format network input parsing (Jam, HAR, Spot, curl), and bounded retry loop.
---

# Verify & Proof-of-Work

No completion without evidence. Recheck twice. Blueprint mode requires the standardized 3-line Proof-of-Work badge.

## Dual-Pass Verification

For every endpoint, schema migration, or public contract change:
1. **Pass A (Static AST Proof):** Identify exact `<file>:<line>` where route/schema is declared and validated.
2. **Pass B (Runtime Execution Proof):** Run tests or execute curl/CLI command with exit code 0.

If Pass A and Pass B disagree, the work is NOT done.

## Standardized Proof-of-Work Badge

See [templates/proof-of-work.md](../templates/proof-of-work.md):

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <command> -> exit 0 (e.g. curl -s -o /dev/null -w "%{http_code}" <URL> -> 200 OK)
- Regression: <X/X tests passing> (0 failures)
```

## Multi-Format Network Debugging

Accept network traces in any standard format:
- **Jam.dev Recording:** Extract failing URL, HTTP method, status code, and payload from Jam URL/metadata.
- **HAR Dump / DevTools:** Filter entries with `response.status >= 400`. Inspect headers and response body.
- **OpenReplay Spot:** Correlate user DOM click with network waterfall error.
- **cURL Command:** Reproduce locally via `curl -v -X <METHOD> <URL>`.

Sanitize bearer tokens and passwords before logging. Never store secrets in `.skidora/recover.md`.

## Bounded CD Retry Loop

If verification fails:
1. Analyze compiler error, status code, or test failure diff.
2. Apply minimal targeted fix using 7-Rung Ladder.
3. Max **3 retries**. If still failing after 3 attempts, halt and mark status as `Blocked` in `.skidora/recover.md`.

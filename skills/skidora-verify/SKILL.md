---
name: skidora-verify
description: >-
  Dual-pass verification: Pass A AST file:line, Pass B command+exit runtime proof, multi-format network input parsing (Jam, HAR, Spot, curl), and bounded retry loop.
---

# Dual-Pass Verification & Proof-of-Work

Ensure work is genuinely complete before reporting success. Never accept `// TODO` placeholders or unverified diffs.

## The Dual-Pass Protocol

1. **Pass A — Static Proof (AST & Routing):**
   - Verify symbol, route, or schema definition exists in code: `path/to/file.ts:<line>`.
   - Confirm route is registered in the router with schema validation (Zod, Pydantic, Ecto).
2. **Pass B — Runtime Proof (Command & Exit Code):**
   - Run the project's real test suite or execution command (e.g. `npm test`, `cargo test`, `mix test`).
   - For public endpoints: execute a real curl command verifying exit code 0 and expected HTTP status.
   - For secure endpoints: execute negative test (e.g. missing/invalid auth -> `401 Unauthorized`) and positive test -> `200 OK`.

## The Standardized Proof-of-Work Badge

See [templates/proof-of-work.md](templates/proof-of-work.md):

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <command> -> exit 0 (e.g. curl ... bad auth -> 401, good auth -> 200 OK)
- Regression: <X/X tests passing> (0 failures)
```

## Multi-Format Network Trace Ingestion

When diagnosing or verifying network issues, ingest traces across any standard format:
- **Jam.dev URLs:** Parse reproduction link to extract failing route, status code, and request body.
- **HAR Dumps / DevTools:** Filter entries with `response.status >= 400`.
- **OpenReplay Spot:** Correlate user DOM clicks with network waterfall failures.
- **cURL Commands:** Reproduce failure locally in terminal.

## Bounded CD Retry Loop

If Pass B fails:
1. Max **3 retry attempts**.
2. Each attempt must fix the root cause and rerun the exact same test gate.
3. If still failing after 3 attempts: **STOP**, mark `Blocked: <evidence>` in `.skidora/recover.md`, and report findings.

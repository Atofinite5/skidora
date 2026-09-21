---
name: skidora-verify
description: >-
  Dual-pass verification: Pass A static router/handler path:line, Pass B command+exit runtime proof with UNVERIFIED fallback, Jam-if-MCP or user traces, and bounded retry loop.
---

# Dual-Pass Verification & Proof-of-Work

Ensure work is genuinely complete before reporting success. Never accept `// TODO` placeholders, simulated exit codes, or unverified diffs.

## The Dual-Pass Protocol

1. **Pass A — Static Proof (Router & Handler `path:line`):**
   - Static: open the router/handler and cite `path:line`.
   - Confirm route is registered in the router with schema validation (Zod, Pydantic, Ecto).
2. **Pass B — Runtime Proof (Literal Command & Actual Output):**
   - Run the project's real test suite or execution command (e.g. `npm test`, `cargo test`, `mix test`).
   - For public endpoints: execute a real curl command verifying exit code and expected HTTP status.
   - For secure endpoints: execute negative test (missing/invalid auth -> `401 Unauthorized`) and positive test -> `200 OK`.
   - **The UNVERIFIED Rule:** Pass B must quote the literal command run this turn. If no command was executed (e.g. offline, local server not running), write `UNVERIFIED — <reason>`. Never fake a 200 OK or exit 0.

## The Standardized Proof-of-Work Badge

See [templates/proof-of-work.md](templates/proof-of-work.md):

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <literal command run this turn> -> <actual exit/http code> (or UNVERIFIED — <reason>)
- Regression: <X/X tests passing> (0 failures)
```

## Network Trace & Session Debugging (Jam-if-MCP)

When diagnosing or verifying network and UI issues:
1. **Jam MCP (When Available):** If a Jam MCP tool (`jam_*` or similar) is present in the agent session, call Jam MCP directly to inspect recordings, console errors, user actions, and network traces.
2. **User-Pasted cURL Commands (CLI/Local):** Reproduce failure locally in terminal with `curl -v -X <METHOD> <URL>` to inspect headers and response codes.
3. **User-Pasted HAR Dumps / DevTools Logs:** Filter entries with `response.status >= 400` to inspect failing request headers and response payloads.
*Note:* If Jam MCP is not present, never claim an external automated URL fetch — rely strictly on user-pasted cURL and HAR text.

## Bounded Retry Loop

If Pass B fails:
1. Max **3 retry attempts**.
2. Each attempt must fix the root cause and rerun the exact same test gate.
3. If still failing after 3 attempts: **STOP**, mark `Blocked: <evidence>` in `.skidora/recover.md`, and report findings.

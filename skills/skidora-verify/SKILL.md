---
name: skidora-verify
description: >-
  Dual-pass verification: Pass A static router/handler path:line, Pass B command+exit runtime proof with UNVERIFIED fallback, Habitat open trace debugging, and bounded retry loop.
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

## Open Trace & Network Debugging (Habitat Standard)

When diagnosing or verifying network failures (HTTP 4xx/5xx, CORS, timeouts), Skidora integrates with the **open-source Habitat Browser Recorder** standard:

1. **Habitat Browser Recorder (Extension):**
   - Use the open-source [Habitat Browser Recorder](https://github.com/HabitatHQ/browser-recorder) to capture network and console activity.
   - Click **"Copy as cURL"** on any failed request and paste it directly into the agent prompt.
2. **Skidora Trace Interceptor (`scripts/trace-interceptor.js`):**
   - Lightweight zero-dependency script pasteable into any browser DevTools console or test setup.
   - Automatically intercepts `fetch` and `XMLHttpRequest`, maintaining a ring buffer and printing reproduction cURL commands for any request returning status $\ge 400$.
3. **Trace Extractor CLI (`scripts/trace-extract.js`):**
   - Parse any `.har` or Habitat JSON report:
     ```bash
     node scripts/trace-extract.js report.json
     # or pipe directly:
     cat network.har | node scripts/trace-extract.js -
     ```
   - Automatically extracts failing requests, pinpoints Pass A router targets, and generates Pass B cURL commands.
4. *Rule:* Always execute the literal cURL command locally to verify the fix in Pass B. Never claim external unauthenticated URL fetches.

## Bounded Retry Loop

If Pass B fails:
1. Max **3 retry attempts**.
2. Each attempt must fix the root cause and rerun the exact same test gate.
3. If still failing after 3 attempts: **STOP**, mark `Blocked: <evidence>` in `.skidora/recover.md`, and report findings.

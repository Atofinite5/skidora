# Verify & Proof-of-Work Reference

Blueprint Mode requires dual-pass verification and the 3-line Proof-of-Work Badge.

## Standardized Badge

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <literal command run this turn> -> <actual exit/http code> (or UNVERIFIED — <reason>)
- Regression: <X/X tests passing> (0 failures)
```

## The UNVERIFIED Rule
Pass B must quote literal command and actual output run during this turn. If not run, write `UNVERIFIED — <reason>`, never fake 200 OK or exit 0.

## Network Trace & Session Debugging (Jam-if-MCP)

1. **Jam MCP (When Available):** If a Jam MCP tool is present in the environment, use it to inspect session traces, DOM actions, console errors, and network payloads.
2. **User-Pasted cURL / CLI:** Reproduce locally with `curl -v -X <METHOD> <URL>`.
3. **User-Pasted HAR File / DevTools:** Filter for HTTP $\ge 400$, inspect request headers and response body.
4. *Rule:* Never claim unauthenticated URL fetching if Jam MCP is not present.

## Bounded Retry Loop

- Retry failed checks up to **3 times**.
- Each retry must follow the 7-Rung Ladder (KISS, DRY).
- If failure persists after 3 attempts, halt immediately and mark `Blocked: <reason>` in `.skidora/recover.md`.

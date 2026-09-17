# Verify & Proof-of-Work Reference

Blueprint Mode requires dual-pass verification and the 3-line Proof-of-Work Badge.

## Standardized Badge

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <command> -> exit 0 (e.g. curl -s -o /dev/null -w "%{http_code}" <URL> -> 200 OK)
- Regression: <X/X tests passing> (0 failures)
```

## Network Input Parsing

Support four standard network debugging formats:
1. **Jam URL:** Ingest bug URL, extract failing route, status code, and payload.
2. **HAR File:** Filter for HTTP $\ge 400$, inspect request headers and response body.
3. **OpenReplay Spot:** Correlate user DOM action with network waterfall failure.
4. **cURL / CLI:** Reproduce locally with `curl -v -X <METHOD> <URL>`.

## Bounded Retry Loop

- Retry failed checks up to **3 times**.
- Each retry must follow the 7-Rung Ladder (KISS, DRY).
- If failure persists after 3 attempts, halt immediately and mark `Blocked: <reason>` in `.skidora/recover.md`.

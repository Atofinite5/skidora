# Proof-of-Work Badge

Every Blueprint change (public API, DB schema, cross-service boundary) must conclude with this 3-line proof:

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <command> -> exit 0 (e.g. curl -s -o /dev/null -w "%{http_code}" <URL> -> 200 OK)
- Regression: <X/X tests passing> (0 failures)
```

## Network Input Verification
When debugging network issues, accept any of the following trace formats:
- **Jam URL:** Extract failing endpoint, status code, and payload from Jam recording.
- **HAR Dump / DevTools:** Filter by status $\ge 400$, inspect failing request headers and response body.
- **OpenReplay Spot:** Match failing DOM click to network waterfall.
- **cURL / CLI:** Reproduce locally with `curl -v -X <METHOD> <URL>`.

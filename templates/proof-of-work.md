# Proof-of-Work Badge

Every Blueprint change (public API, DB schema, cross-service boundary) must conclude with this 3-line proof:

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <literal command run this turn> -> <actual exit code / HTTP status>
- Regression: <X/X tests passing> (0 failures)
```

### The UNVERIFIED Rule
Pass B must quote a command executed during this turn. If a command was not executed (e.g. offline, local server unavailable, no curl tool), you **MUST** write `UNVERIFIED`:
```markdown
[Skidora Proof-of-Work]
- Pass A (Static): app/api/billing/route.ts:18 — Route registered in router with schema validation.
- Pass B (Runtime): UNVERIFIED — Local server not running; command could not be executed this turn.
- Regression: 18/18 tests passing (0 failures)
```
*Never output a simulated exit 0 or fake 200 OK without running the command.*

# Verify & Proof-of-Work Reference

Canonical badge: [`skills/skidora/templates/proof-of-work.md`](../skills/skidora/templates/proof-of-work.md)

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <literal command run this turn> -> <actual exit/http code> (or UNVERIFIED — <reason>)
- Regression: <X/X tests passing> (0 failures)
```

## The UNVERIFIED Rule
Pass B must quote literal command and actual output run during this turn. If not run, write `UNVERIFIED — <reason>`, never fake 200 OK or exit 0.

## Network Trace (Jam-if-MCP)

1. If `jam_*` / user-jam MCP tools exist in this session: use them (including Jam URL fetch). Do not refuse.
2. Else: user-pasted HAR or curl. Filter HAR `response.status >= 400`. Reproduce locally.
3. Never invent an unauthenticated fetch when Jam MCP is absent. Never ban Jam when it is present.

Optional local extras (not in the skill pack): `scripts/trace-extract.js` parses a pasted HAR.

## Bounded Retry Loop

- Retry failed checks up to **3 times**.
- Each retry must follow the 7-Rung Ladder (KISS, DRY).
- If failure persists after 3 attempts, halt immediately and mark `Blocked: <reason>` in `.skidora/recover.md`.

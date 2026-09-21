# Helix Single-File Memory Reference

Helix memory provides cross-session persistence using a **single file**: `.skidora/recover.md`.

## The Ledger Format

```markdown
# Helix Recover Ledger

## Current State
- Goal: Add webhook authentication
- Active Route: POST /api/v1/webhook
- Next: Implement rate limiting

## Verified Milestones
- [2026-09-18] Fixed bookingKpis day window in src/kpis.ts. (14/14 tests pass)
- [2026-09-18] Added HMAC SHA-256 signature verification in app/api/webhook/route.ts. (curl exit 0)
```

## Rules
1. **Single File Only:** Do not create `draft.md`, `plan.md`, or `graph.md`.
2. **Cap Size:** Keep under 40 lines. Prune older entries when approaching the limit: keep Goal, Next, Active Routes (if any), and the last 8 milestone lines.
3. **Zero Secrets:** Never record bearer tokens, API keys, or private environment variables.

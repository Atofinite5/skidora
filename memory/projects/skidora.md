# Recover prompt

Slug: skidora
Path: /Users/bhargavkalambhe/Desktop/skidora
Updated: 2026-09-21

## Goal
Adaptive OS for AI coding agents: 7-Rung Ladder, strict single-file memory (.skidora/recover.md), zero-slop dual-pass proof of work.

## Decisions
- Master orchestrator with two clean modes: Surgical (90%) and Blueprint (10%)
- Single ledger: .skidora/recover.md (<40 lines); no draft.md, plan.md, or graph.md
- Dual-pass proof of work: Pass A static router/handler path:line + Pass B runtime command (UNVERIFIED fallback)
- Default `*` is 4 core (skidora, when-not, helix, verify) + backend; erlang only if mix.exs / rebar.config
- Canonical proof-of-work.md lives in the hub skill; verify points at it
- Jam-if-MCP: use jam_* when present; else pasted HAR/curl
- SOLID stays out of when-not YAML; ISP = callers must not depend on unused methods
- Skill pack is markdown only; JS interceptors stay out of skills/

## Key files
- skills/skidora/SKILL.md — Master orchestrator
- skills/skidora-when-not/SKILL.md — 7-Rung Ladder, KISS, DRY
- skills/skidora-helix/SKILL.md — Single-file recover.md contract
- skills/skidora-verify/SKILL.md — Dual-pass verification
- skills/skidora-backend/SKILL.md — NLP to physical router mapping
- skills/skidora-erlang-elixir/SKILL.md — Optional BEAM/OTP module
- scripts/install.sh — prune leftovers, fail on plan.md skills, Cursor symlinks

## Live endpoints
- none (skill + optional CLI, not an HTTP app)

## NLP map
- "recover / state" -> skidora recover
- "surgical / fix / typo" -> skidora-when-not
- "route / api / endpoint" -> skidora-backend
- "verify / test / trace" -> skidora-verify
- "phoenix / elixir / erlang / otp" -> skidora-erlang-elixir (BEAM only)

## Next
Ship install.sh so Cursor has real symlinks and hub files exist in the installed folder.

## Open risks
- skills.sh hub may still list historical v1/v2 skill names until cache expires; installer prunes them locally.

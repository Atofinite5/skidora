# Recover prompt

Slug: skidora
Path: /Users/bhargavkalambhe/Desktop/skidora
Updated: 2026-09-21

## Goal
Adaptive OS for AI coding agents: 7-Rung Ladder, strict single-file memory (.skidora/recover.md), zero-slop dual-pass proof of work.

## Decisions
- Master orchestrator with two clean modes: Surgical (90%) and Blueprint (10%)
- Single ledger: .skidora/recover.md (<40 lines); no draft.md, plan.md, or graph.md
- Dual-pass proof of work: Pass A static router/handler path:line + Pass B runtime command exit 0 (with mandatory UNVERIFIED fallback)
- Optional Rust engine + Neovim integration with smart binary fallbacks (no CLI required)
- 6 clean skills installed across all agents with native Cursor, Claude, and Codex linking
- Single source of truth: root repository files; skills/skidora contains only portable skill artifacts

## Key files
- skills/skidora/SKILL.md — Master orchestrator
- skills/skidora-when-not/SKILL.md — 7-Rung Ladder, SOLID, KISS ("Do it simple"), DRY ("Do it once")
- skills/skidora-helix/SKILL.md — Single-file recover.md contract
- skills/skidora-verify/SKILL.md — Dual-pass verification & Proof-of-Work badge
- skills/skidora-backend/SKILL.md — NLP to physical router mapping
- skills/skidora-erlang-elixir/SKILL.md — Optional BEAM/OTP module
- crates/skidora-core — Memory engine
- crates/skidora-cli — CLI binary
- nvim/lua/skidora/init.lua — Neovim commands

## Live endpoints
- none (skill + optional CLI, not an HTTP app)

## NLP map
- "recover / state" -> skidora recover
- "surgical / fix / typo" -> skidora-when-not
- "route / api / endpoint" -> skidora-backend
- "verify / test / trace" -> skidora-verify
- "phoenix / elixir / erlang / otp" -> skidora-erlang-elixir

## Next
Maintain production-grade agent execution with verified proof-of-work.

## Open risks
- Non-compliant LLM prompt drift: Mitigated by mandatory UNVERIFIED rule, 12-line AGENTS.md contract, and evals/traces.md.

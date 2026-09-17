---
name: skidora
description: >-
  Operating system for AI coding agents (Cursor, Claude Code, Antigravity, Zed, Copilot).
  Adaptive execution (Ponytail 7-Rung Ladder, YAGNI, KISS, DRY), single-file Helix memory (.skidora/recover.md),
  zero-hallucination backend routing, and dual-pass verification. Use when starting or continuing a project,
  recovering past work, fixing bugs surgically, or building/verifying APIs.
---

# Skidora 🧬

Universal agent operating system for **any developer and any coding agent**.
Works identically in Cursor, Claude Code, Antigravity, Zed, and Copilot.

---

## The Core Operating Model

Skidora routes every task into one of two modes:

```
User Message
     │
     ▼
[Mode Gate: Is it a Public Route, DB Schema Migration, or /plan?]
     │
     ├── No (90% Daily Work) ──► SURGICAL MODE
     │                           - Run 7-Rung Ladder (YAGNI, KISS, DRY)
     │                           - Shortest working diff wins
     │                           - Response capped at ≤3 lines
     │                           - Silent 1-line append to .skidora/recover.md
     │
     └── Yes (10% Structural) ──► BLUEPRINT MODE
                                 - Load .skidora/recover.md
                                 - Ask P0 blockers if facts are missing
                                 - Map NLP to real router files (skidora-backend)
                                 - Dual-Pass Proof-of-Work (skidora-verify)
                                 - Output 3-line Proof-of-Work badge
```

---

## The 7-Rung Ladder of Laziness

Before writing any new code, step down the ladder and **stop at the first rung that holds**:

1. **Rung 1 — YAGNI:** Does this need to exist? If speculative, skip it.
2. **Rung 2 — In Codebase:** Reuse existing helpers, types, or utilities (DRY).
3. **Rung 3 — Standard Library:** Use built-in language primitives (`Math`, `Array`, `datetime`, `Enum`).
4. **Rung 4 — Native Platform:** Leverage native HTML5, CSS, or SQL database constraints.
5. **Rung 5 — Existing Dependency:** Use what is already installed in `package.json` / `Cargo.toml`.
6. **Rung 6 — One-Liner:** Keep it cleanly in one line if possible (KISS).
7. **Rung 7 — Minimum Viable Code:** Write the absolute minimum safe code that fixes the root cause.

---

## Single-File Helix Memory Contract

Memory lives in **one single compact file**: `.skidora/recover.md` (<40 lines).
Never create `draft.md`, `plan.md`, or `graph.md`.

- **On Session Start:** Read `.skidora/recover.md` to resume from **Next**.
- **On Surgical Completion:** Silently append one line:
  `- [YYYY-MM-DD] Fixed <issue> in <file>. (<tests pass>)`
- **On Blueprint Completion:** Update active routes and verified state.

---

## Core Dispatch

| Task Kind | Skill Module | Purpose |
|---|---|---|
| **Adaptive Gate** | [`skidora-when-not`](../skidora-when-not) | Enforces 7-Rung Ladder, YAGNI, KISS, DRY. |
| **Session Memory** | [`skidora-helix`](../skidora-helix) | Reads and updates single-file `.skidora/recover.md`. |
| **Backend & Routing** | [`skidora-backend`](../skidora-backend) | NLP to physical router handlers; torn router resolution. |
| **Verification & Network** | [`skidora-verify`](../skidora-verify) | Dual-pass AST + runtime proof, network trace parsing, and 3-line badge. |
| **BEAM/OTP (Optional)** | [`skidora-erlang-elixir`](../skidora-erlang-elixir) | Phoenix, LiveView, Mix/Rebar3 (load only if `mix.exs`/`rebar.config` exists). |

---

## Production Security Rules

1. **Zero Secrets in Memory:** Never write API keys, bearer tokens, or secrets to `.skidora/recover.md` or git.
2. **Zero Invented Endpoints:** Every route must exist in physical router code.
3. **Explicit Destructive Approval:** Deletions, drops, or migrations require explicit user confirmation.
4. **Mandatory Timeouts:** Every network request must enforce an explicit 5s–10s timeout.
5. **Strict CORS:** Whitelist specific origins; never pair wildcard `*` with `credentials: true`.
6. **SSRF Protection:** Whitelist and sanitize all outgoing URLs against internal RFC 1918 subnets.
7. **Sanitized Errors:** Strip stack traces and internal IPs from public error responses.
8. **Bounded Retries:** Maximum 3 retries in CD loops; then halt and mark `Blocked` in `recover.md`.

---

## Proof-of-Work Standard

All structural changes must supply the 3-line badge defined in [templates/proof-of-work.md](templates/proof-of-work.md):

```markdown
[Skidora Proof-of-Work]
- Pass A (Static): <file>:<line> — Route registered in router with schema validation.
- Pass B (Runtime): <command> -> exit 0 (e.g. curl -s -o /dev/null -w "%{http_code}" <URL> -> 200 OK)
- Regression: <X/X tests passing> (0 failures)
```

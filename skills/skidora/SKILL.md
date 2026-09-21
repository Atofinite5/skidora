---
name: skidora
description: >-
  Adaptive operating system for AI coding agents. 7-Rung Ladder (≤3 lines diff, zero ceremony), single-file memory (.skidora/recover.md), zero-hallucination routing, and dual-pass proof of work.
---

# Skidora: Master Orchestrator

The unified operating system for AI coding agents. Operates in two distinct modes:

```
                  ┌────────────────────────────────────────┐
                  │          USER TASK ARRIVES             │
                  └────────────────────┬───────────────────┘
                                       │
                    Is it a public HTTP/gRPC route,          
                    database schema migration, or            
                    explicit user `/plan` command?           
                                       │
                     ┌─────────────────┴─────────────────┐
                    NO                                  YES
                     │                                   │
                     ▼                                   ▼
        ┌─────────────────────────┐         ┌─────────────────────────┐
        │      SURGICAL MODE      │         │     BLUEPRINT MODE      │
        │       (90% tasks)       │         │       (10% tasks)       │
        │                         │         │                         │
        │ • 7-Rung Ladder         │         │ • 1. Load recover.md    │
        │ • KISS & DRY slogans    │         │ • 2. Router mapping     │
        │ • Shortest diff wins    │         │ • 3. Dual-pass proof    │
        │ • ≤3 lines explanation  │         │ • 4. Proof-of-Work badge│
        │ • 0 markdown dumped     │         │ • 5. Update recover.md  │
        │ • Silent 1-line memory  │         └─────────────────────────┘
        └─────────────────────────┘
```

---

## 1. Boot Protocol & Core Principles

**Boot Directive:** If `AGENTS.md` in the target repo lacks Skidora, follow the contract (`project-kit/AGENTS.md`) anyway this turn. Never dump unrequested markdown files.

- **KISS ("Do it simple"):** Shortest working diff wins. Stop at the lowest rung that holds.
- **DRY ("Do it once"):** Reuse existing codebase helpers and standard libraries. In memory, maintain **only one** memory ledger (`.skidora/recover.md`).
- **YAGNI:** You Aren't Gonna Need It. Never generate speculative scaffolding, unrequested interfaces, or paperwork.
- **Trace Obedience:** Follow behavioral traces in `evals/traces.md`; violating a trace constraint fails the turn.
- **Repo Exception:** Authoring or improving Skidora itself is Blueprint mode (not capped at 3 lines).

---

## 2. Dispatch Table (The Core Skills)

Skidora runs standalone. If sibling skills are installed, read them; otherwise execute inline following the core principles:

| Trigger Condition | Target Skill (if sibling exists, read it) | Inline Core Function |
|---|---|---|
| Bug fix, refactor, typo, small feature, script edit | `skidora-when-not` | Apply 7-Rung Ladder, ≤3 line diffs, zero paperwork. |
| Session resume, crash recovery, cross-turn context | `skidora-helix` | Read/update single `.skidora/recover.md` ledger (<40 lines). |
| Structural route, DB migration, network trace, CD | `skidora-verify` | Dual-pass proof (Pass A static router path:line + Pass B runtime command with UNVERIFIED rule), user trace debugging, 3-line badge. |
| NLP query to backend route, torn router graph | `skidora-backend` | Map natural language to physical router code; in-memory torn router resolution. |
| Erlang, Elixir, Phoenix, LiveView, Mix, Rebar3 | `skidora-erlang-elixir` | BEAM OTP worker/supervisor architecture & Mix test gate (BEAM repos only). |

---

## 3. Surgical Mode Execution Rules (90% of Tasks)

When the task is a bug fix, refactor, typo, single-function change, or dependency update:
1. **Apply the 7-Rung Ladder:** Step down and stop at the first rung that holds:
   - **Rung 1 (YAGNI):** Does this need to exist? Skip if speculative.
   - **Rung 2 (In Codebase):** Reuse existing helpers, types, or utilities (DRY: "Do it once").
   - **Rung 3 (Standard Library):** Use language built-ins instead of custom packages.
   - **Rung 4 (Native Platform):** Leverage HTML5, CSS, or database constraints.
   - **Rung 5 (Existing Dependency):** Use already-installed libraries.
   - **Rung 6 (One-Liner):** Keep it cleanly in one line if possible (KISS: "Do it simple").
   - **Rung 7 (Minimum Viable Code):** Write the absolute minimum safe code that fixes the root cause.
2. **Response:** Maximum **3 lines of explanation** + code diff.
3. **Paperwork:** **Zero** markdown files created. Never create `draft.md`, `plan.md`, or `graph.md`.
4. **Memory:** Silently append one line to `.skidora/recover.md`:
   `- [YYYY-MM-DD] Fixed <issue> in <file>. (<tests pass>)`

---

## 4. Blueprint Mode Execution Rules (10% of Tasks)

Triggered **only** when introducing or removing public HTTP/gRPC endpoints, database schema migrations, cross-service RPC boundaries, or when user explicitly asks for `/plan`:
1. **Load Memory:** Read `.skidora/recover.md`.
2. **Clarify Blockers:** If essential parameters are missing, prompt via `templates/question-block.md` (P0 blockers only).
3. **NLP-to-Router Mapping:** Extract real routes from physical router files (`app/api/`, `routes/`, `router.ex`). Zero invented routes. Use `templates/architecture.md` for structural alignment if needed.
4. **Dual-Pass Verification:**
   - Pass A: Static: open the router/handler and cite `path:line`.
   - Pass B: Literal runtime command executed during this turn. For authenticated routes, test negative (bad auth -> 401) and positive -> 200.
   - **The UNVERIFIED Rule:** If a command was not executed this turn, mark Pass B `UNVERIFIED — <reason>`. Never fake an exit 0 or 200 OK.
5. **Standardized Proof-of-Work Badge:**
   All structural changes must supply the 3-line badge defined in [templates/proof-of-work.md](templates/proof-of-work.md):
   ```markdown
   [Skidora Proof-of-Work]
   - Pass A (Static): <file>:<line> — Route registered in router with schema validation.
   - Pass B (Runtime): <literal command run this turn> -> <actual exit/http code> (or UNVERIFIED — <reason>)
   - Regression: <X/X tests passing> (0 failures)
   ```
6. **Update Memory:** Append the verified milestone to `.skidora/recover.md`.

---

## 5. Production Hardening Rules

1. **Secrets:** Never log or pass API keys or bearer tokens in query parameters or commit them to git.
2. **Endpoints:** Never invent fake paths. If a route isn't in a real router file, it does not exist.
3. **Mutations:** Destructive database operations require explicit confirmation or transactional rollback guards.
4. **Timeouts:** All external HTTP/gRPC calls must declare explicit timeouts (5s–10s) and retry policies.
5. **CORS:** Restrict allowed origins; never wildcard with credentials.
6. **SSRF:** Sanitize and whitelist all target URLs against internal RFC 1918 CIDRs.
7. **Errors:** Sanitize error responses returned to clients; never expose raw stack traces.
8. **CD Loops:** Bounded retry limit of 3 attempts. Stop and flag `Blocked:` in `.skidora/recover.md` on repeated failure.

---
name: skidora
description: >-
  Adaptive operating system for AI coding agents. Ponytail 7-Rung Ladder (≤3 lines diff, zero ceremony), single-file memory (.skidora/recover.md), zero-hallucination routing, and dual-pass proof of work.
---

# Skidora: Master Orchestrator

The unified operating system for AI coding agents. Operates in two distinct modes:

```
                  ┌─────────────────────────────────────────┐
                  │          USER TASK ARRIVES              │
                  └────────────────────┬────────────────────┘
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
        │ • YAGNI, KISS, DRY      │         │ • 2. Router mapping     │
        │ • Shortest diff wins    │         │ • 3. Dual-pass proof    │
        │ • ≤3 lines explanation  │         │ • 4. Proof-of-Work badge│
        │ • 0 markdown dumped     │         │ • 5. Update recover.md  │
        │ • Silent 1-line memory  │         └─────────────────────────┘
        └─────────────────────────┘
```

---

## 1. Core Principles (Zero Slop Creed)

- **YAGNI:** You Aren't Gonna Need It. Never generate speculative scaffolding, unrequested interfaces, or paperwork.
- **KISS:** Keep It Simple, Stupid. The shortest working diff that solves the root cause wins.
- **DRY:** Don't Repeat Yourself. Reuse existing helpers in the codebase. Maintain **only one** memory ledger (`.skidora/recover.md`).
- **Zero AI Slop:** No conversational preamble. No `// TODO: implement later` placeholders. No fake in-memory mock endpoints.

---

## 2. Dispatch Table (The Core Skills)

Skidora delegates specialized tasks to these focused skills:

| Trigger Condition | Target Skill | Core Function |
|---|---|---|
| Bug fix, refactor, typo, small feature, script edit | [`skidora-when-not`](../skidora-when-not) | 7-Rung Ladder of Laziness, ≤3 line diffs, zero paperwork. |
| Session resume, crash recovery, cross-turn context | [`skidora-helix`](../skidora-helix) | Reads/updates single `.skidora/recover.md` ledger (<40 lines). |
| Structural route, DB migration, network trace, CD | [`skidora-verify`](../skidora-verify) | Dual-pass proof (AST + runtime command), network trace ingestion (Jam/HAR/Spot/curl), 3-line badge. |
| NLP query to backend route, torn router graph | [`skidora-backend`](../skidora-backend) | Maps natural language to physical router code; torn router in-memory resolution. |
| Erlang, Elixir, Phoenix, LiveView, Mix, Rebar3 | [`skidora-erlang-elixir`](../skidora-erlang-elixir) | BEAM OTP worker/supervisor architecture & Mix test gate. |

---

## 3. Surgical Mode Execution Rules (90% of Tasks)

When the task is a bug fix, refactor, typo, single-function change, or dependency update:
1. **Apply the 7-Rung Ladder of Laziness:**
   - Rung 1: **YAGNI** — Delete speculative requirements.
   - Rung 2: **Codebase** — Reuse existing utilities.
   - Rung 3: **Standard Library** — Use language built-in primitives.
   - Rung 4: **Native Platform** — Use HTML5/CSS/SQL constraints.
   - Rung 5: **Existing Dependency** — Reuse installed packages.
   - Rung 6: **One-Liner** — Clean one-liner if possible.
   - Rung 7: **Minimum Viable Code** — Shortest safe code diff.
2. **Response:** Maximum **3 lines of explanation** + code diff.
3. **Paperwork:** **Zero** markdown files created. Never create `draft.md`, `plan.md`, or `graph.md`.
4. **Memory:** Silently append one line to `.skidora/recover.md`:
   `- [YYYY-MM-DD] Fixed <issue> in <file>. (<tests pass>)`

---

## 4. Blueprint Mode Execution Rules (10% of Tasks)

Triggered **only** when introducing or removing public HTTP/gRPC endpoints, database schema migrations, cross-service RPC boundaries, or when user explicitly asks for `/plan`:
1. **Load Memory:** Read `.skidora/recover.md`.
2. **Clarify Blockers:** If essential parameters are missing, ask them directly.
3. **NLP-to-Router Mapping:** Extract real routes from physical router files (`app/api/`, `routes/`, `router.ex`). Zero invented routes.
4. **Dual-Pass Verification:**
   - Pass A: Static AST verification (`file:line`).
   - Pass B: Runtime test or curl command proving exit code 0. For authenticated/signed routes, test negative (bad auth -> 401) and positive -> 200.
5. **Standardized Proof-of-Work Badge:**
   All structural changes must supply the 3-line badge defined in [templates/proof-of-work.md](templates/proof-of-work.md):
   ```markdown
   [Skidora Proof-of-Work]
   - Pass A (Static): <file>:<line> — Route registered in router with schema validation.
   - Pass B (Runtime): <command> -> exit 0 (e.g. curl ... bad auth -> 401, good auth -> 200 OK)
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

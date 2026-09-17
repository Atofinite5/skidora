# Adaptive Execution & Principles Reference

When to act surgically, when to produce a blueprint, and how to write production-grade code with zero AI slop.

## Core Engineering Principles

- **YAGNI (You Aren't Gonna Need It):** Never generate speculative abstractions, unrequested files, or defensive layers for imaginary requirements.
- **KISS ("Do It Simple"):** The simplest working code that solves the root cause is the best code. Stop at the lowest rung that holds.
- **DRY ("Do It Once"):** Reuse existing codebase helpers and standard libraries. Maintain **one single `.skidora/recover.md`** ledger instead of duplicating state.
- **SOLID Architectural Foundations:**
  - **Single Responsibility (S):** Each function or module does exactly one job with one reason to change.
  - **Open/Closed (O):** Extend behavior without mutating stable public contracts.
  - **Liskov Substitution (L):** Replacements must satisfy the exact contract of the original.
  - **Interface Segregation (I):** Fine-grained interfaces; clients are not forced to depend on methods they do not use.
  - **Dependency Inversion (D):** High-level policy depends on abstractions and router tables, not brittle concrete couplings.

---

## The 7-Rung Ladder of Laziness

Before generating any code, step down the ladder and **stop at the first rung that holds**:

1. **Rung 1 — YAGNI:** Does this need to exist? If speculative, delete the requirement.
2. **Rung 2 — Already in codebase?** Search the project for existing helpers, utility functions, or schemas.
3. **Rung 3 — Standard library does it?** Use built-in language primitives (`Math`, `Array`, `datetime`, `Enum`, `Option`).
4. **Rung 4 — Native platform covers it?** Use HTML5 validation (`type="email"`, `required`), native CSS, or SQL database constraints.
5. **Rung 5 — Existing dependency solves it?** Inspect `package.json`, `Cargo.toml`, or `mix.exs`. Reuse what is already installed.
6. **Rung 6 — Can it be a clean one-liner?** If it can be expressed clearly in one line, do so (KISS).
7. **Rung 7 — Minimum viable code:** Write the absolute minimum safe code that fixes the root cause.

---

## Operating Modes

### 1. Surgical Mode (Default — 90% of Daily Tasks)
- **Applies to:** Bug fixes, small refactors, typos, single function changes, script adjustments, dependency updates.
- **Execution Rules:**
  - **Shortest working diff wins.**
  - **Zero markdown ceremony:** Do NOT write `plan.md`, `architecture.md`, or `artifact-index.md`.
  - **Response size:** Max **3 lines of summary explanation** + code diff.
  - **Memory:** Silently append one line to `.skidora/recover.md`:
    `- [YYYY-MM-DD] Fixed <issue> in <file>. (<tests pass>)`

### 2. Blueprint Mode (10% of Tasks — Public APIs, DB Migrations, Cross-Service Boundaries)
- **Applies to:** Creating new public HTTP/gRPC endpoints, database schema migrations, cross-service RPC changes.
- **Execution Rules:**
  - Map NLP to real router files (zero hallucinated routes).
  - Produce the 3-line **Proof-of-Work Badge** ([templates/proof-of-work.md](../templates/proof-of-work.md)).
  - Run dual-pass verification (Pass A AST check + Pass B runtime execution test/curl).
  - Update `.skidora/recover.md` with active routes and verified state.

---

## Production-Grade Code Rules (Zero AI Slop)

1. **No Chat Preamble or Postamble:** Never begin responses with conversational filler ("Sure! Here is the fix...", "I understand..."). Output the explanation or diff immediately.
2. **No Incomplete Diffs or Placeholders:** Never use `// TODO: implement later`, `/* rest of your code here */`, or `...`. Every diff must be complete and syntactically valid.
3. **No Mock Hallucinations:** Never return mock in-memory arrays or hardcoded objects when a real database or service call is required.
4. **Strict Boundary Validation:** Validate all external inputs at the boundary using the project's existing schema library (Zod, Joi, Pydantic, Ecto).
5. **Defensive Error Handling:** Handle failure states explicitly. Never swallow errors silently or log raw exceptions containing secrets.

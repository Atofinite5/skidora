# Adaptive Execution: The 7-Rung Ladder & Core Principles (YAGNI, KISS, DRY, SOLID)

Skidora avoids ceremony suffocation by defaulting to **Surgical Execution** for 90% of daily engineering, reserving full architectural blueprints only for structural boundaries.

---

## The Core Engineering Creed

1. **YAGNI (You Aren't Gonna Need It):** Never build speculative code or generate bureaucratic files that weren't asked for.
2. **KISS (Keep It Simple, Stupid — "Do It Simple"):** The shortest working diff that solves the root cause wins. Stop at the lowest rung that holds.
3. **DRY (Don't Repeat Yourself — "Do It Once"):** Reuse existing project utilities and stdlib. In memory, maintain **one single `.skidora/recover.md`** rather than duplicating state across 5 markdown files.
4. **SOLID Principles:**
   - **S (Single Responsibility):** Each module and change does one thing well.
   - **O (Open/Closed):** Extend functionality without modifying stable contracts.
   - **L (Liskov Substitution):** New components must be drop-in compatible with existing interfaces.
   - **I (Interface Segregation):** Never force developers into unneeded ceremonies (no 500-word essays for a 1-line fix).
   - **D (Dependency Inversion):** Decouple business logic from external frameworks and volatile integrations.

---

## The 7-Rung Ladder of Laziness (Ponytail Policy)

Before writing any new code, step down the ladder and **stop at the first rung that holds**:

1. **Rung 1 — YAGNI:** Does this need to exist at all? If speculative, skip it and state why in one line.
2. **Rung 2 — Already in codebase?** Reuse existing helpers, utilities, schemas, and types instead of duplicating logic (DRY).
3. **Rung 3 — Standard library does it?** Use language built-ins (`Math`, `Array`, `datetime`, `Enum`) instead of custom functions or new packages.
4. **Rung 4 — Native platform covers it?** Use HTML5 validation, native CSS, or SQL database constraints over custom JS/application code.
5. **Rung 5 — Existing dependency solves it?** Check `package.json`, `Cargo.toml`, or `mix.exs`. Use what is already installed.
6. **Rung 6 — Can it be a clean one-liner?** If it can be expressed clearly in one line, do so (KISS).
7. **Rung 7 — Minimum viable code:** Only when all prior rungs fail, write the absolute minimum code that safely solves the task.

*(Exception: Safety, security, schema validation, and error boundaries are non-negotiable and must never be skipped).*

---

## The Two Operating Modes

### 1. Surgical Mode (Default — 90% of Daily Work)
* **Triggers:** Bug fixes, refactors, styling, minor endpoint updates, test fixes, lookups.
* **Rules:**
  - Run the 7-Rung Ladder.
  - Shortest working diff wins.
  - Chat response capped at **3 lines or fewer** + code diff.
  - **Zero markdown ceremony:** Do NOT write `plan.md`, `architecture.md`, or `artifact-index.md`.
  - Silently append a single line to `.skidora/recover.md`:
    `- [YYYY-MM-DD] Fixed <issue> in <file>. (<tests pass>)`

### 2. Blueprint Mode (10% of Work — Structural Changes Only)
* **Triggers:** Adding or removing a public API route, breaking DB schema migrations, cross-microservice boundaries, or explicit `/plan` from the user.
* **Rules:**
  - Map endpoints to router files (no hallucinated routes).
  - Produce the 3-line **Proof-of-Work Badge** (AST proof + Runtime execution proof).
  - Verify against real test suites (target 95+ score).

---
name: skidora-when-not
description: >-
  Adaptive execution gate: 7-Rung Ladder of Laziness, YAGNI, KISS, DRY, and SOLID principles. Default to surgical diffs (≤3 lines explanation, zero ceremony); reserve blueprint dumps strictly for public route or schema changes.
---

# Adaptive Execution & Core Principles

Prevent ceremony suffocation and bloated code by combining **Ponytail's 7-Rung Ladder** with **YAGNI, KISS, DRY, and SOLID**.

## Core Engineering Principles

- **YAGNI (You Aren't Gonna Need It):** Never generate speculative code or unrequested markdown files.
- **KISS ("Do it simple"):** Shortest working diff wins. Stop at the lowest rung that holds.
- **DRY ("Do it once"):** Reuse existing codebase helpers and stdlib. In memory, keep **only one single `.skidora/recover.md`** ledger.
- **SOLID Design:**
  - **S (Single Responsibility):** Each change does one thing well.
  - **O (Open/Closed):** Extend functionality without modifying stable contracts.
  - **L (Liskov Substitution):** New components remain drop-in compatible.
  - **I (Interface Segregation):** No developer forced through paperwork ceremonies for small fixes.
  - **D (Dependency Inversion):** Depend on clean interfaces/routers, not rigid hardcoded bindings.

## The 7-Rung Ladder (Default Daily Mode)

Before writing any new code, step down the ladder and **stop at the first rung that holds**:

1. **YAGNI:** Does this need to exist? Skip if speculative.
2. **In Codebase:** Reuse existing helpers, types, or utilities (DRY).
3. **Standard Library:** Use language built-ins instead of custom packages.
4. **Native Platform:** Leverage HTML5, CSS, or database constraints.
5. **Existing Dependency:** Use already-installed libraries.
6. **One-Liner:** Keep it cleanly in one line if possible (KISS).
7. **Minimum Viable Code:** Write the absolute minimum safe code that fixes the root cause.

## Operating Modes

- **Surgical Mode (Default — 90% of tasks):**
  - Use 7-Rung Ladder.
  - Response capped at **3 lines or fewer** + code diff.
  - Zero markdown files dumped.
  - Silently record a 1-line summary into `.skidora/recover.md`.
- **Blueprint Mode (10% of tasks — Public APIs, Migrations, Boundaries):**
  - Map endpoints to router files (no hallucinated routes).
  - Run dual-pass verification (static AST + runtime proof).
  - Produce the 3-line Proof-of-Work Badge.

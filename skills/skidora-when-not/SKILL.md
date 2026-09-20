---
name: skidora-when-not
description: >-
  Adaptive execution gate: 7-Rung Ladder of Laziness, YAGNI, KISS, and DRY. Default to surgical diffs (≤3 lines explanation, zero ceremony); reserve blueprint dumps strictly for public route or schema changes.
---

# Adaptive Execution & Core Principles

Prevent ceremony suffocation and AI slop by combining **Ponytail's 7-Rung Ladder** with **YAGNI, KISS, DRY, and SOLID**.

## Core Engineering Principles

- **YAGNI (You Aren't Gonna Need It):** Never generate speculative code, unrequested classes, or unnecessary markdown files.
- **KISS ("Do it simple"):** Shortest working diff wins. Stop at the lowest rung that holds.
- **DRY ("Do it once"):** Reuse existing codebase helpers and standard libraries. In memory, keep **only one single `.skidora/recover.md`** ledger.
- **SOLID Architectural Foundations:**
  - **S (Single Responsibility):** Each module, function, or edit does one thing well with a single reason to change.
  - **O (Open/Closed):** Open for extension, closed for modification — extend functionality without breaking stable public contracts.
  - **L (Liskov Substitution):** Subtypes and replacement handlers must remain drop-in compatible with expected interfaces.
  - **I (Interface Segregation):** Keep interfaces fine-grained; agents and modules must never depend on methods or prompts they do not use.
  - **D (Dependency Inversion):** Depend on abstractions and route declarations, never on rigid, hardcoded concrete implementations.

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

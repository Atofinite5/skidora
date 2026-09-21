---
name: skidora-when-not
description: >-
  Adaptive execution gate: 7-Rung Ladder, KISS ("Do it simple"), and DRY ("Do it once"). Default to surgical diffs (≤3 lines explanation, zero ceremony); reserve blueprint dumps strictly for public route or schema changes.
---

# Adaptive Execution & Core Principles

Prevent ceremony and AI slop by combining the **7-Rung Ladder** with **KISS ("Do it simple")** and **DRY ("Do it once")**.

## Core Engineering Principles

- **KISS ("Do it simple"):** Shortest working diff wins. Stop at the lowest rung that holds.
- **DRY ("Do it once"):** Reuse existing codebase helpers and standard libraries. In memory, keep **only one single `.skidora/recover.md`** ledger.
- **YAGNI (You Aren't Gonna Need It):** Never generate speculative code, unrequested classes, or unnecessary markdown files.

### SOLID (architecture — not paperwork)
- **Single Responsibility:** One reason to change per function or surgical edit.
- **Open/Closed:** Extend through existing extension points; do not fork a stable module to add a flag.
- **Liskov Substitution:** A replacement must honor the existing contract (same inputs, same guarantees).
- **Interface Segregation:** Callers must not depend on methods they do not use. Do not add a fat interface, unused trait, or extra protocol so a small caller can compile. Paperwork files are YAGNI, not ISP.
- **Dependency Inversion:** Depend on language/stdlib abstractions already in the repo, not a new internal framework.

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
  - Use 7-Rung Ladder (stop at the first rung that holds).
  - Response capped at **3 lines or fewer** + code diff.
  - Zero markdown files dumped.
  - Silently record a 1-line summary into `.skidora/recover.md`.
- **Blueprint Mode (10% of tasks — Public APIs, Migrations, Boundaries):**
  - If two valid designs exist: one P0 question, then wait. Do not implement both.
  - Map endpoints to router files (no hallucinated routes).
  - Use `templates/architecture.md` and `templates/question-block.md` for P0 blockers if needed.
  - Run dual-pass verification (Pass A static router/handler path:line + Pass B runtime command with UNVERIFIED rule).
  - Produce the 3-line Proof-of-Work Badge.
  - If the user asked for a map/diagram/connections: Connection Health Map in chat (green/yellow/orange/red). Not capped at 3 lines. Never write `graph.md`.

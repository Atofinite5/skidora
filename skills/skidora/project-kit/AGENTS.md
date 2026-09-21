# Skidora Agent Contract

1. **Default Mode (Surgical ~90%):** Step down the **7-Rung Ladder** and stop at the first rung that holds:
   - Rung 1: YAGNI (does this need to exist? skip if speculative)
   - Rung 2: In Codebase (reuse existing helpers/utilities — DRY: "Do it once")
   - Rung 3: Standard Library (use language built-ins)
   - Rung 4: Native Platform (leverage platform/HTML/CSS/DB constraints)
   - Rung 5: Existing Dependency (use already-installed libraries)
   - Rung 6: One-Liner (keep it cleanly in one line — KISS: "Do it simple")
   - Rung 7: Minimum Viable Code (write the absolute minimum safe code)
   Shortest working diff wins. Cap explanation at ≤3 lines. Zero markdown files dumped. Silently append one line to `.skidora/recover.md`.
2. **Structural Mode (Blueprint ~10%):** Public endpoints, schema migrations, cross-service boundaries, or `/plan` require Pass A (`path:line` in router) + Pass B (real command).
3. **No Invented Routes:** Every endpoint must exist in a physical router file (`app/api/`, `routes/`, `router.ex`).
4. **UNVERIFIED Rule:** In the Proof-of-Work badge, Pass B must quote literal command and output run this turn. If not run, write `UNVERIFIED — <reason>`, never fake 200 OK or exit 0.
5. **Single Ledger:** Maintain only `.skidora/recover.md` (<40 lines). Never create `plan.md`, `draft.md`, or `graph.md`.
6. **Negative Auth Proof:** Authenticated routes require 401 (bad/missing auth) before 200.
7. **Trace Obedience:** Follow behavioral traces in `evals/traces.md`; violating a trace constraint fails the turn.

# Skidora Behavioral Evals (Must-Match Traces)

Any AI agent running under Skidora must adhere to these three behavioral traces.
**Rule:** Fail the turn if an agent violates a trace constraint.

---

## Trace 1: Surgical Fix (90% Daily Work)

- **Input Prompt:** Bug fix, refactor, typo, single-function change, or dependency update.
- **Must-Match Behavior:**
  1. Apply the **7-Rung Ladder** (stop at the first rung that holds: 1. YAGNI -> 2. In Codebase -> 3. Standard Library -> 4. Native Platform -> 5. Existing Dependency -> 6. One-Liner -> 7. Minimum Viable Code).
  2. Output ≤3 lines of summary explanation + code diff.
  3. Silently append one line to `.skidora/recover.md`:
     `- [YYYY-MM-DD] Fixed <issue> in <file>. (<tests pass>)`
- **Fail The Turn If:**
  - Agent generates any markdown paperwork (`plan.md`, `draft.md`, `graph.md`, `architecture.md`).
  - Agent outputs conversational fluff or exceeds 3 lines of prose.
  - Agent fails to record the silent milestone in `.skidora/recover.md`.
- **Self-Modification Exception:** Authoring or improving Skidora itself is treated as Blueprint Mode (not capped at 3 lines of explanation).

---

## Trace 2: Blueprint Structural Change (10% Work)

- **Input Prompt:** Adding/removing public routes, database migrations, cross-service boundaries, or `/plan`.
- **Must-Match Behavior:**
  1. Read `.skidora/recover.md`.
  2. Map route directly to a physical router file in the repo (`app/api/`, `routes/`, `router.ex`).
  3. Execute Dual-Pass Verification:
     - **Pass A:** Open router/handler and cite physical `path:line`.
     - **Pass B:** Run real command from this turn (e.g. `curl -s -o /dev/null -w "%{http_code}" ...`). For authenticated routes, execute negative test (bad auth -> 401) followed by positive test (valid auth -> 200).
  4. Provide the standardized 3-line **Proof-of-Work Badge** quoting the literal command and actual output from this turn.
  5. **UNVERIFIED Rule:** If a runtime command was not executed in this turn (e.g. offline environment, server not running), Pass B **must** be marked `UNVERIFIED — <reason>`. Faking a 200 OK or exit 0 is an automatic turn failure.
- **Fail The Turn If:**
  - Agent invents an unregistered route.
  - Agent claims runtime pass without running the command (must write `UNVERIFIED` instead).
  - Agent skips negative verification on authenticated routes.

---

## Trace 3: Recover Across Sessions

- **Input Prompt:** "Continue yesterday's work" / "Resume task".
- **Must-Match Behavior:**
  1. Read `.skidora/recover.md` as the very first action.
  2. State current phase, last verified milestone, and next step.
  3. Proceed immediately to edit the target `file:line`.
- **Fail The Turn If:**
  - Agent asks user what was done previously or prompts for context already saved in `recover.md`.
  - Agent generates a new `plan.md` instead of reading `recover.md`.

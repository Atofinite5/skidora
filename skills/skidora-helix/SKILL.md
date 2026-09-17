---
name: skidora-helix
description: >-
  Single-file Helix memory: maintain compact .skidora/recover.md (<40 lines). Load on session start; append one line silently on surgical completion.
---

# Helix Single-File Memory

Helix memory provides persistent state across agent sessions using **one single, compact file**: `.skidora/recover.md`.

No ceremony. No multi-file dumps. No `draft.md`, no `plan.md`, no `graph.md`.

## The Single Ledger Contract

Inside the target project:
```
your-project/
└── .skidora/
    └── recover.md       # Compact ledger: project goal, verified milestones, next step
```

If `.skidora/` is missing, create it. Cap `recover.md` at **40 lines maximum**. Prune older entries when needed.

## Load (Every Session Start)

1. Check if `.skidora/recover.md` exists.
2. If found, read it to restore context (goal, active branch, last verified milestone, next step).
3. Continue directly from **Next**. Do not re-interrogate the user about decisions already recorded.

## Save / Append (Every Session End or Milestone)

- **Surgical Mode:** Append one silent line:
  ```markdown
  - [YYYY-MM-DD] Fixed <issue> in <file>. (<tests pass>)
  ```
- **Blueprint Mode:** Update the structured 4-point block:
  ```markdown
  # Project State
  - **Goal:** <primary objective>
  - **Last Verified:** <Pass A AST + Pass B runtime command>
  - **Active Routes:** <registered endpoints>
  - **Next:** <immediate next task>
  ```

Never store API keys, tokens, or credentials in `.skidora/recover.md`.

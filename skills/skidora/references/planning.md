# Planning

Always plan on **full** work. Small work is defined in [when-not.md](when-not.md) and skips this file.

The only other switch is whether the user sees the plan.

## Visible (default)

On any non-trivial request (new work, remove, workflow, automation, FE/BE, execution):

1. Write `.skidora/plan.md`.
2. Show the plan to the user.
3. Show architecture using [templates/architecture.md](../templates/architecture.md).
4. Show demanded artifacts using [templates/artifact-index.md](../templates/artifact-index.md).
5. Then implement.

Trivial requests (typo, one-line rename, single comment) still get a 3-line internal plan in `.skidora/plan.md`; showing it is optional.

## Hidden (`don't plan`, `just do it`, `no plan`)

1. Still write `.skidora/plan.md` with the full plan.
2. Do **not** paste the plan in the user-facing reply.
3. Implement directly.
4. Before any presentation, demo, or "here's the UI/API" moment, still show architecture (layout, modules, endpoints). That is not optional.
5. After implement + verify, give a short done/blocked/next bar — not a retroactive essay of the hidden plan.

## Plan body

Keep `.skidora/plan.md` precise:

```
# Plan
- Intent:
- Action class: create | modify | remove | accept | helix-recover | automation/cd | backend-nlp
- Scope (in):
- Scope (out):
- Modules to pull:
- Architecture: (link or embed)
- Artifacts:
- Verify:
- Risks:
```

Do not pad with theory. Name real files and endpoints.

## Architecture before presentation

Presentation means any of: showing a screen, showing an API, handing off, demoing, or claiming the work is ready.

Before that, the user must see:

- Layout (FE) or module map (BE)
- Request flow
- Endpoints that will exist or change
- What will be checked twice

Use the architecture template. If Graphifier ran, include its topology.

## Accept / remove / execute

When the user says accept, remove this component, run this, make this workflow, make this automation, or make FE/BE:

- Treat it as a full Skidora turn: Helix → intake gaps → plan (hidden if asked) → architecture → artifacts → implement → verify twice.
- Removal: list files, routes, and references that die; Graphifier if the graph is torn; then delete only what the list names.
- Accept: execute the last shown or hidden plan without re-asking P1/P2.

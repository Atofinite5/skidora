# GSD

Get Stuff Done. Keep the project manageable. One phase at a time. Bars stay visible.

## Phases

1. **Clarify** — Helix + intake. Intent is one sentence.
2. **Spec** — plan + architecture + artifact index.
3. **Execute** — smallest slice that can be verified.
4. **Verify** — [verify.md](verify.md), twice, 95-plus.
5. **Ship** — recover prompt written; user can present.

Never skip Clarify for recover/remove. Never skip Verify for endpoints.

## Project bars

Always maintain in `.skidora/draft.md` and in status replies:

```
Phase: <clarify|spec|execute|verify|ship>
Done: <this turn>
Blocked: <user decision or missing P0, or none>
Next: <one step>
```

If work spans many files, execute in slices. Each slice ends verify-green before the next slice starts.

## Pull skills for this project

After spec, list the skills this project actually needs (Skidora modules plus installed skills). Write them under Artifacts. Do not load unused skills.

## Tool generation

If a helper is required and does not exist:

1. Confirm it is not already in the repo, `.skidora/tools/`, or this skill's `scripts/`.
2. Create a small script with a one-line purpose at the top.
3. Project-only → `.skidora/tools/<name>`.
4. Reusable across projects → this skill's `scripts/<name>`.
5. Log the tool in the draft. Do not invent MCP or Cursor built-in tools.

## Suggestions

After agent-side analysis (files, tests, graph), suggest the next slice. Rank: correctness, then verifyability, then speed. Do not suggest work that contradicts Helix recover unless the user starts over.

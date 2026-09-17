# Helix memory

Helix memory is how Skidora rewinds and recovers work. It is **markdown files**, not a CLI and not chat recall. Any agent that can read and write `.skidora/` uses the same contract.

At session start (every agent): if `.skidora/` exists, read `recover.md` and the last draft. At session end: append draft and rewrite the tiny recover prompt.

## Locations

**Skill (global recover index)**

- `memory/index.md` — one line per known project
- `memory/projects/<slug>.md` — tiny recover prompt for that project

**Target project**

- `.skidora/recover.md` — compressed prompt; read this first on start
- `.skidora/draft.md` — running log; precise enough to re-word or restore a step
- `.skidora/plan.md` — last plan (shown or hidden)
- `.skidora/graph.md` — last Graphifier topology
- `.skidora/tools/` — generated helpers for this repo

If `.skidora/` is missing, create it. If the skill `memory/` files are missing, create them. Never put secrets in any of these files.

## Load (every session)

1. Read this skill's `memory/index.md`.
2. Match the current workspace path or project name.
3. If a row matches, also read `memory/projects/<slug>.md`.
4. If `.skidora/recover.md` exists, read it. Prefer project recover over the skill copy if they differ; then reconcile into one prompt.
5. If `.skidora/draft.md` exists, read the last 40 lines plus any heading that matches the user's request.
6. Continue from **Next**, not from scratch, unless the user explicitly starts over.

Slug: lowercase, hyphens, from the repo folder name (e.g. `skidora`, `my-app`).

## Draft log rules

Append, do not rewrite history. Each entry is one atomic step:

```
## [YYYY-MM-DD HH:MM] <phase> — <short title>
- Intent: <what the user asked>
- Did: <files/endpoints touched>
- Evidence: <test, curl, or command that proved it>
- Open: <unfinished>
```

The draft must be precise enough to **re-word** (user wants the same work said differently) or **recover** (restore the last known good step). Do not dump stack traces. Do not log secrets.

Use [templates/draft-log.md](../templates/draft-log.md) when creating a new draft.

## Recover prompt (tiny)

After meaningful work (decision, mergeable change, verified endpoint, or session end), rewrite `.skidora/recover.md` from [templates/recover-prompt.md](../templates/recover-prompt.md).

Keep it small: goal, decisions, key files, live endpoints, next step, open risks. Then copy the same body to `memory/projects/<slug>.md` and upsert one line in `memory/index.md`:

```
| <slug> | <absolute-or-relative path> | <one-line state> | <date> |
```

## Recover a past project

When the user asks to recover, rewind, or continue a project that is not the current folder:

1. Search `memory/index.md` by name, path, or keyword in the one-line state.
2. Read that `memory/projects/<slug>.md`.
3. If the path still exists, open it and load its `.skidora/recover.md` + `draft.md`.
4. If the path is gone, restore work from the tiny prompt: restate goal, decisions, and next step; ask P0 only if the prompt is incomplete.
5. Do not invent files that the prompt does not name.

## Re-word

If the user wants the same work re-worded: read the matching draft entry and recover prompt, then rewrite the user-facing explanation. Do not redo the implementation unless they also asked to change it.

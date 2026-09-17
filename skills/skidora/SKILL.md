---
name: skidora
description: >-
  Portable agent skill for any coding agent and any project (Cursor, Claude
  Code, Codex, Copilot, Neovim, others). Helix recover memory, skip-small-tasks
  gate, always-plan (hidden if asked), GSD/frontend/backend/NLP/CD, Graphifier,
  OTP/Phoenix, tool generation, double-check until endpoints pass, network &
  production security. Use when starting or continuing a project, recovering
  past work, building frontend or backend, mapping NLP to endpoints,
  automations, CD, architecture before presentation, network/API inspection,
  or when the user mentions Skidora, Helix memory, Graphifier, GSD, Neovim,
  Erlang, Elixir, OTP, Phoenix, or network security.
---

# Skidora

Portable operating skill for **any developer and any coding agent**. Install with `npx skills add`. Same files (`.skidora/`, `AGENTS.md`) work in Cursor, Claude Code, Codex, Antigravity, Zed, Copilot, and similar tools.

Do not guess from model knowledge. Read the repo, Helix memory, and real files/APIs, then act. Copy the traces in [examples.md](examples.md).

Memory is markdown in `.skidora/`. Write those files directly. A CLI is not required.

## Skip or full

Read [references/when-not.md](references/when-not.md) first.

- **Small** (typo, one-line, "where is X?"): Helix load only if `.skidora/` exists. No plan dump, no Graphifier, no 95-plus loop. One proof if you touch code.
- **Full**: new/remove feature or endpoint, recover, automation, presentation. Then the checklist below.

## Immediate start

Copy this checklist and follow it in order (full loop only):

```
Skidora:
- [ ] Load Helix memory (skill index + project recover/draft)
- [ ] Ask missing P0 questions in the standard block
- [ ] Recognize topic; if not, run Graphifier
- [ ] Pull only the modules this request needs
- [ ] Plan (show, or hide if user said don't plan)
- [ ] Show architecture before any presentation
- [ ] Implement precisely
- [ ] Double-check claims, APIs, endpoints
- [ ] Retry until endpoints work and score is 95-plus
- [ ] Write draft log + tiny recover prompt
```

0. Read [references/when-not.md](references/when-not.md) (or skill `skidora-when-not`). If small, stop the full checklist.
1. Read [references/helix-memory.md](references/helix-memory.md) (or skill `skidora-helix`). Load `.skidora/recover.md` and `draft.md` before other work. Create `.skidora/` by writing the templates if the task is full and the folder is missing.
2. If anything required is missing, read [references/intake.md](references/intake.md) and ask using [templates/question-block.md](templates/question-block.md). Do not interrogate in free form.
3. If the topic is unclear, torn, or conflicting, read [references/graphifier.md](references/graphifier.md) before more edits.
4. Read [references/planning.md](references/planning.md). Always plan. If the user said **don't plan**, write the plan to `.skidora/plan.md` and do not show it.
5. Read [references/agent-handling.md](references/agent-handling.md) for how to talk to the user.

## AG3 loop

1. **Intake** — recover context, ask P0 gaps, map user language to real artifacts.
2. **Plan** — architecture, demanded artifacts, which modules to pull. Visible unless hidden.
3. **Execute + verify** — implement, check twice, loop until green or a hard blocker that must be asked.

```
User message
  -> Helix load
  -> intake questions if needed
  -> Graphifier if unrecognized
  -> dispatch modules
  -> plan (shown or hidden)
  -> architecture before presentation
  -> implement
  -> double-check APIs/endpoints
  -> retry loop
  -> compress into recover prompt
```

## Dispatch

Read only the files this turn needs. Pull other installed skills when they apply (`21st-ui-build`, `ui-design`, `nextjs`, `react`, security).

| Request kind | Skill (`-s`) | Or bundled file |
|---|---|---|
| Recover, rewind, re-word | `skidora-helix` | [references/helix-memory.md](references/helix-memory.md) |
| Missing intent or stack | `skidora-intake` | [references/intake.md](references/intake.md) |
| Plan / don't-plan / architecture | `skidora-planning` | [references/planning.md](references/planning.md) |
| Project phases / bars | `skidora-gsd` | [references/gsd.md](references/gsd.md) |
| UI, layout, components | `skidora-frontend` | [references/frontend.md](references/frontend.md) |
| APIs, NLP to endpoints | `skidora-backend` | [references/backend.md](references/backend.md) |
| Network, CORS, timeouts, Jam alt | `skidora-network` | [references/network.md](references/network.md) |
| Erlang, Elixir, OTP, Phoenix | `skidora-erlang-elixir` | [references/erlang-elixir.md](references/erlang-elixir.md) |
| Pipelines, retry until green | `skidora-cd` | [references/cd-pipelines.md](references/cd-pipelines.md) |
| Unrecognized topic, torn code | `skidora-graphifier` | [references/graphifier.md](references/graphifier.md) |
| 95-plus, recheck | `skidora-verify` | [references/verify.md](references/verify.md) |
| Small vs full loop | `skidora-when-not` | [references/when-not.md](references/when-not.md) |
| Secrets, fake APIs | `skidora-security` | [references/security.md](references/security.md) |
| Voice and bars | `skidora-agent-handling` | [references/agent-handling.md](references/agent-handling.md) |

For remove-component, accept, workflow, automation, frontend, backend, or any execution: plan first (hidden if asked), show architecture, list demanded artifacts with [templates/artifact-index.md](templates/artifact-index.md), then implement.

## Project bars

Keep these four lines current in `.skidora/draft.md` and in user-facing status:

- **Phase:** intake | plan | execute | verify | ship
- **Done:** what landed this turn
- **Blocked:** what needs the user
- **Next:** the next precise step

## Hard rules

- No hallucination. If a file, route, or API is not in the repo or a live spec, do not claim it exists.
- Recheck every requirement and every endpoint twice against real code or runtime. See [references/verify.md](references/verify.md).
- Do not invent Cursor/MCP built-in tools. If the project needs a helper, create it under `.skidora/tools/` (project) or `scripts/` (reusable). See [references/gsd.md](references/gsd.md).
- Write Helix files with normal file tools: `.skidora/recover.md`, `draft.md`, `plan.md`, `graph.md`. A CLI is not required.
- NLP maps to real endpoints only. See [references/backend.md](references/backend.md). BEAM routers: [references/erlang-elixir.md](references/erlang-elixir.md).
- Network & Security: [references/network.md](references/network.md) and [references/security.md](references/security.md).
- Failures retry in a bounded loop. See [references/cd-pipelines.md](references/cd-pipelines.md).
- Skip the full loop on small work. See [references/when-not.md](references/when-not.md).
- Drop [project-kit/AGENTS.md](project-kit/AGENTS.md) into any repo so every agent self-starts.

## Examples and templates

- [examples.md](examples.md) — small fix, shown-plan endpoint, hidden-plan recover

## Templates

- [templates/question-block.md](templates/question-block.md)
- [templates/architecture.md](templates/architecture.md)
- [templates/artifact-index.md](templates/artifact-index.md)
- [templates/draft-log.md](templates/draft-log.md)
- [templates/recover-prompt.md](templates/recover-prompt.md)

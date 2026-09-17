---
name: skidora
description: >-
  Portable agent skill for any coding agent and any project (Cursor, Claude
  Code, Codex, Copilot, Neovim, others). Adaptive execution (Ponytail 7-Rung
  Ladder, YAGNI, KISS, DRY, SOLID), single-file Helix recover memory, GSD,
  NLP-to-endpoints, CD retry loops, OpenReplay Spot network inspection, and
  dual-pass verification. Use when starting or continuing a project, recovering
  past work, building frontend or backend, mapping NLP to endpoints,
  automations, CD, architecture before presentation, network/API inspection,
  or when the user mentions Skidora, Helix memory, Graphifier, GSD, Neovim,
  Erlang, Elixir, OTP, Phoenix, or network security.
---

# Skidora

Portable operating skill for **any developer and any coding agent**. Install with `npx skills add`. Same files (`.skidora/`, `AGENTS.md`) work in Cursor, Claude Code, Codex, Antigravity, Zed, Copilot, and similar tools.

Do not guess from model knowledge. Read the repo, Helix memory, and real files/APIs, then act. Copy the traces in [examples.md](examples.md).

Memory is compact markdown in `.skidora/recover.md`. Write this file directly. A CLI is not required.

## Adaptive Execution Gate (YAGNI, KISS, DRY, SOLID)

Read [references/when-not.md](references/when-not.md) first.

- **Surgical Mode (Default — 90% of tasks):** Run the **7-Rung Ladder of Laziness** (YAGNI → Codebase helpers → Stdlib → Native platform → Existing packages → One-liner → Minimal diff). Responses capped at **≤3 lines** + code diff. Zero markdown ceremony. Append 1-line silently to `.skidora/recover.md`.
- **Blueprint Mode (10% — Public APIs, DB Migrations, Cross-Service Boundaries):** Map routes to real router files, produce the 3-line Proof-of-Work Badge, and verify against test suites.

## Immediate start (Blueprint Mode only)

Copy this checklist only when touching public API contracts or major architecture:

```
Skidora:
- [ ] Load Helix memory (.skidora/recover.md)
- [ ] Ask missing P0 questions in the standard block
- [ ] Recognize topic; if not, run Graphifier
- [ ] Pull only the modules this request needs
- [ ] Plan (show, or hide if user said don't plan)
- [ ] Show architecture before any presentation
- [ ] Implement precisely using 7-Rung Ladder (KISS, DRY, SOLID)
- [ ] Double-check claims, APIs, endpoints
- [ ] Retry until endpoints work and score is 95-plus
- [ ] Record 1-line milestone to .skidora/recover.md
```

0. Read [references/when-not.md](references/when-not.md) (or skill `skidora-when-not`). Default to Surgical Mode.
1. Read [references/helix-memory.md](references/helix-memory.md) (or skill `skidora-helix`). Maintain single-file `.skidora/recover.md`.
2. If anything required is missing, read [references/intake.md](references/intake.md) and ask using [templates/question-block.md](templates/question-block.md).
3. If the topic is unclear, torn, or conflicting, read [references/graphifier.md](references/graphifier.md).
4. Read [references/planning.md](references/planning.md). Always plan for structural tasks.
5. Read [references/agent-handling.md](references/agent-handling.md) for how to talk to the user (≤3 lines for small tasks).

## AG3 loop

1. **Intake** — recover context, ask P0 gaps, map user language to real artifacts.
2. **Plan** — architecture, demanded artifacts, which modules to pull. Visible unless hidden.
3. **Execute + verify** — implement via 7-Rung Ladder, check twice, loop until green.

```
User message
  -> Check Surgical vs Blueprint (7-Rung Ladder)
  -> Helix load (.skidora/recover.md)
  -> If Blueprint: intake -> plan -> architecture -> dual-pass verify
  -> If Surgical: shortest working diff -> ≤3 lines output
  -> 1-line append to recover.md
```

## Dispatch

Read only the files this turn needs. Pull other installed skills when they apply (`21st-ui-build`, `ui-design`, `nextjs`, `react`, security).

| Request kind | Skill (`-s`) | Or bundled file |
|---|---|---|
| Adaptive gate: 7-Rungs, YAGNI, KISS, DRY, SOLID | `skidora-when-not` | [references/when-not.md](references/when-not.md) |
| Recover, rewind, single-file memory | `skidora-helix` | [references/helix-memory.md](references/helix-memory.md) |
| Missing intent or stack | `skidora-intake` | [references/intake.md](references/intake.md) |
| Plan / don't-plan / architecture | `skidora-planning` | [references/planning.md](references/planning.md) |
| Project phases / bars | `skidora-gsd` | [references/gsd.md](references/gsd.md) |
| UI, layout, components | `skidora-frontend` | [references/frontend.md](references/frontend.md) |
| APIs, NLP to endpoints | `skidora-backend` | [references/backend.md](references/backend.md) |
| Network, CORS, timeouts, OpenReplay Spot | `skidora-network` | [references/network.md](references/network.md) |
| Erlang, Elixir, OTP, Phoenix | `skidora-erlang-elixir` | [references/erlang-elixir.md](references/erlang-elixir.md) |
| Pipelines, retry until green | `skidora-cd` | [references/cd-pipelines.md](references/cd-pipelines.md) |
| Unrecognized topic, torn code | `skidora-graphifier` | [references/graphifier.md](references/graphifier.md) |
| 95-plus, recheck | `skidora-verify` | [references/verify.md](references/verify.md) |
| Secrets, fake APIs | `skidora-security` | [references/security.md](references/security.md) |
| Voice and bars | `skidora-agent-handling` | [references/agent-handling.md](references/agent-handling.md) |

## Hard rules

- No hallucination. If a file, route, or API is not in the repo or a live spec, do not claim it exists.
- Recheck every requirement and every endpoint twice against real code or runtime. See [references/verify.md](references/verify.md).
- Follow YAGNI, KISS ("Do it simple"), and DRY ("Do it once").
- Write Helix memory to `.skidora/recover.md`. A CLI is not required.
- NLP maps to real endpoints only. See [references/backend.md](references/backend.md). BEAM routers: [references/erlang-elixir.md](references/erlang-elixir.md).
- Network & Security: [references/network.md](references/network.md) and [references/security.md](references/security.md).
- Failures retry in a bounded loop. See [references/cd-pipelines.md](references/cd-pipelines.md).
- Drop [project-kit/AGENTS.md](project-kit/AGENTS.md) into any repo so every agent self-starts.

## Examples and templates

- [examples.md](examples.md) — small fix, shown-plan endpoint, hidden-plan recover

# Intake

The agent asks. The user answers. Use one standard block, then work.

Read [templates/question-block.md](../templates/question-block.md) and fill only the gaps. Do not ask what Helix memory already answers. Do not ask more than one block per turn unless a P0 appears mid-work.

## When to ask

Ask when any P0 is unknown after Helix load:

- What to build, change, remove, or recover
- Frontend vs backend vs both vs automation vs CD
- Stack only if the repo does not already show it
- Accept vs reject a proposed change
- Destructive scope (delete component, drop endpoint, rewrite)

If P0 is complete, do not block on P1/P2. Apply defaults and proceed.

## Priority

**P0 — blockers.** Must answer to proceed. Examples: recover which project; remove which component; which endpoint; production vs local.

**P1 — quality.** Defaults if skipped. Examples: test runner, styling system, deploy target.

**P2 — optional.** Nice to know. Examples: copy tone, extra analytics.

## Defaults (P1/P2 if skipped)

- Follow the existing repo. Do not introduce a new framework.
- `mix.exs` → Elixir/Phoenix path ([erlang-elixir.md](erlang-elixir.md)). `rebar.config` / `src/*.erl` → Erlang/OTP. Do not ask stack if those files exist.
- Architecture is shown before presentation even if planning is hidden.
- Verify with the project's own test/lint/dev commands when they exist.
- NLP maps to existing routes before creating new ones.

## Question style

- One block, numbered, P0 first.
- Each item is a single closed question or a short choice list.
- State the default in the same line when one exists.
- After answers (or timeout/defaults), restate the interpreted intent in one sentence, then plan or implement.

## NLP to intent

Map informal text to one action class before dispatching:

| User language | Action class |
|---|---|
| make, add, build, implement | create |
| change, update, fix, re-word | modify |
| remove, delete, drop | remove |
| accept, lgtm, do it, ship | accept |
| don't plan, just do it | hidden-plan execute |
| recover, continue, rewind | helix-recover |
| automate, workflow, pipeline | automation/cd |
| endpoint, api, nlp, intent | backend-nlp |
| elixir, erlang, otp, phoenix, liveview, genserver | erlang-elixir |

If mapping is ambiguous, that is a P0 question, not a guess.

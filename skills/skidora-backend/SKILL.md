---
name: skidora-backend
description: >-
  Backend APIs, NLP-to-endpoint mapping, torn router resolution, and Connection Health Map.
  Use when the user asks for routes, APIs, architecture, mermaid, diagrams, connections, or whether a linkage is healthy.
  Zero invented routes. Colored mermaid in chat: green verified, yellow unverified, orange torn, red broken.
---

# Backend, NLP-to-Endpoints, and Connection Health Map

An endpoint is real ONLY if it exists in router code, an OpenAPI/schema spec, or a verified live route table. Senior review is the map: **is the hop linked, and what color is the hop?**

## NLP -> Real Route Mapping

1. Extract intent, entity, and constraints from the prompt.
2. Match to an existing handler and router file by name, path, or schema.
3. If no match exists, flag as Blueprint (new endpoint). Never silently invent a path.
4. Record verified route in `.skidora/recover.md`:
   `Route: <METHOD> <path> -> <handler file:line>`

## Torn Router Resolution (In-Memory Graph)

When a codebase has torn routes, dual backends, or conflicting middleware:
1. Scan router files (`src/routes/*`, `app/api/*`, `router.ex`, `*_web/router.ex`).
2. Build an in-memory map: `Route -> Middleware/Auth -> Controller/Handler -> Database/Store`.
3. Resolve conflicts at the router. Do **not** write `graph.md` unless the user asked for a file.

## Connection Health Map (Claude cowork reply)

Trigger when the user asks to map the system, see connections, architecture, mermaid, endpoint health, or “is it wired?” Also after a Blueprint change, show the **touched** hops — not a dump of the universe.

This is **not** Surgical Mode. Reply in chat like Claude Cowork: short prose + mermaid. Canonical stencil: hub `templates/connection-health.md`.

### 1. Evidence first (no invented boxes)

Scan only what exists:

| Hop | Evidence |
|---|---|
| Route | Physical router `file:line` (`app/api/**/route.ts`, `routes/*`, `router.ex`) |
| Handler | Exported handler / controller that the route actually calls |
| Schema | Zod / Pydantic / Ecto already on that hop |
| Store | DB/client import the handler uses |
| Runtime | Pass B command this turn, or `UNVERIFIED — <reason>` |

If a hop has no file, **omit the node**. Never draw `/api/v1/...` because it would look complete.

Cap the diagram at **12 nodes**. Prefer the requested slice or the routes changed this turn.

### 2. Color = danger (brighter / thicker = worse)

| Class | Color | Stroke | When |
|---|---|---|---|
| `ok` | **green** `#4ade80` | 2px | Linked + verified this turn (Pass A `file:line` **and** Pass B real command / test of that hop). |
| `stale` | **yellow** `#facc15` | 3px | Linked, but Pass B is `UNVERIFIED`. Connection is there; proof was not run. |
| `torn` | **orange** `#fb923c` | 4px | Linked with a defect: missing schema, rustc warning, type error, handler not registered, test skipped. |
| `down` | **red** `#f87171` | 5px | Broken: compile error, panic, HTTP 5xx, dangling import, missing target. |

A hop that is wired **and** still wrong is **orange or red**, never green. Green is only dual-pass evidence from **this turn**.

Rust / compiler / type diagnostics on a hop: warning → orange, error → red.

### 3. Draw this mermaid (in the reply)

```mermaid
%%{init: {"theme":"dark"}}%%
flowchart LR
  classDef ok fill:#052e16,stroke:#4ade80,color:#bbf7d0,stroke-width:2px
  classDef stale fill:#422006,stroke:#facc15,color:#fde68a,stroke-width:3px
  classDef torn fill:#431407,stroke:#fb923c,color:#fed7aa,stroke-width:4px
  classDef down fill:#450a0a,stroke:#f87171,color:#fecaca,stroke-width:5px

  C[Client]
  R["POST /api/v1/billing/webhook<br/>app/api/billing/webhook/route.ts:18"]
  H["HMAC handler"]
  S["store"]
  C -->|ok| R
  R -->|stale| H
  H -->|torn| S
  class R ok
  class H stale
  class S torn
  linkStyle 0 stroke:#4ade80,stroke-width:2px
  linkStyle 1 stroke:#facc15,stroke-width:3px
  linkStyle 2 stroke:#fb923c,stroke-width:4px
```

Replace labels with **this repo’s** `file:line`. Keep `classDef` lines unchanged so colors stay comparable across projects. Paint **both** the node (`class`) **and** the matching `linkStyle` so the connection line is the same color as the destination hop.

### 4. Cowork reply shape (always)

1. **Status (one sentence):** `Connection health — 4 hops. 2 green, 1 yellow, 1 orange, 0 red.`
2. **Mermaid** (above).
3. **Brightest hop:** worst color, `file:line`, what is wrong.
4. **Next:** the next physical edit. Then stop.

Do not follow with a 400-word essay. Do not write `architecture.md` / `graph.md`.

### 5. Fail the turn if

- A node or edge is not backed by a real file (hallucinated connection).
- A green hop did not have Pass A + Pass B (or equivalent compile/test) **this turn**.
- Pass B was skipped and the hop was painted green instead of yellow.
- The map was written to a markdown file the user did not ask for.

## Backend Hardening Rules

- **Schema Validation:** Validate incoming payloads with the project's existing schema library (Zod, Joi, Pydantic, Ecto).
- **Network Resilience:** Explicit 5s–10s timeouts and sanitized error responses.
- **Zero Secrets in Logs:** Never log authorization headers, passwords, or tokens.
- **Side Effects Guard:** Mutations, webhooks, or deletions require explicit verification.

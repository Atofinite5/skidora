# Connection Health Map (in-chat only)

Draw **only when the user asked** for a map / architecture / mermaid / connections / “is it wired?”. Never write `graph.md` unless they asked for a file.

Scan first. Every hop starts **yellow**. One unlabeled actor (`Client`) is allowed. Every other box needs a real `file:line` from this turn’s scan.

Status text is required (mermaid stroke-width may not render):

`Connection health — N hops. G green / Y yellow / O orange / R red.`

```mermaid
%%{init: {"theme":"dark"}}%%
flowchart LR
  classDef ok fill:#052e16,stroke:#4ade80,color:#bbf7d0,stroke-width:2px
  classDef stale fill:#422006,stroke:#facc15,color:#fde68a,stroke-width:3px
  classDef torn fill:#431407,stroke:#fb923c,color:#fed7aa,stroke-width:4px
  classDef down fill:#450a0a,stroke:#f87171,color:#fecaca,stroke-width:5px

  C[Client]
  R["METHOD /path<br/>router file:line"]
  H["handler file:line"]
  S["store file:line"]
  C -->|stale| R
  R -->|stale| H
  H -->|stale| S
  class R stale
  class H stale
  class S stale
  linkStyle 0 stroke:#facc15,stroke-width:3px
  linkStyle 1 stroke:#facc15,stroke-width:3px
  linkStyle 2 stroke:#facc15,stroke-width:3px
```

Replace placeholders with this repo’s scan hits. Do not copy sample API paths. Upgrade yellow → green/orange/red only from this turn’s Pass B or compiler/test log.

| Class | Color | Meaning |
|---|---|---|
| `stale` | yellow | Default. Linked; Pass B `UNVERIFIED` this turn. |
| `ok` | green | Pass A + Pass B of that hop **this turn**. |
| `torn` | orange | This turn’s log: warning / missing schema / unwired handler on that file. |
| `down` | red | This turn’s log: compile error / panic / 5xx / dangling import on that file. |

Reply: status counts → mermaid → brightest hop `file:line` → next edit. Stop.

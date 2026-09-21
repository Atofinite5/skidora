# Connection Health Map (in-chat only)

Draw this in the reply. Never write `graph.md` unless the user asked for a file.

Brighter / thicker stroke = more danger. No invented nodes. Every box cites a real `file:line` or is omitted.

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
  S["store / downstream file:line"]
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

| Class | Color | Stroke | Meaning |
|---|---|---|---|
| `ok` | green | 2px | Linked **and** verified this turn (Pass A `file:line` + Pass B real command, or compile/test of that hop). |
| `stale` | yellow | 3px | Linked, Pass B `UNVERIFIED`. Connection exists; proof was not run. |
| `torn` | orange | 4px | Linked with a defect on the hop (missing schema, rustc warning, type error, handler not wired). |
| `down` | red | 5px | Broken / danger (compile error, panic, 5xx, dangling edge, missing target). |

Reply shape (Claude cowork):
1. One status sentence: counts per color.
2. The mermaid.
3. The brightest (worst) hop: `file:line` + what is wrong.
4. Next physical edit. Stop.

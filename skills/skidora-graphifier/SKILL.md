---
name: skidora-graphifier
description: >-
  Topic graph: nodes, edges, torn code. Use when the topic is unrecognized or the codebase is torn.
---

# Graphifier

Use when the agent cannot recognize the topic, the request spans unclear files, or code is torn (broken imports, half-refactors, missing handlers).

Graphifier is agent-side: it reads cache and the repo. It does not guess a graph from the model.

## Cache sources (read in this order)

1. `.skidora/recover.md`
2. `.skidora/draft.md`
3. `.skidora/graph.md` (previous topology)
4. Repo tree for the suspected area (Glob/Grep)
5. Skill `memory/projects/<slug>.md` if recovering another project

## Build topology

Write `.skidora/graph.md`:

```
# Graph
Updated: <ISO datetime>
Question: <what was unrecognized>

## Nodes
- id | kind | path-or-name | one-line

## Edges
- from -> to | kind | why

## Torn
- <broken ref, missing file, dangling route> | evidence

## Next
- <which node to act on and why>
```

Kinds: `topic`, `file`, `route`, `component`, `job`, `decision`, `tool`, `otp_app`, `supervisor`, `worker`, `liveview`, `context`.

Edge kinds: `imports`, `calls`, `renders`, `maps-nlp`, `depends`, `broke`, `supervises`, `routes`.

Keep it small. Cap ~30 nodes unless the user asked for a full map. Prefer the subgraph that answers the unrecognized topic.

## After the graph

1. Dispatch the module for the **Next** node.
2. If Torn is non-empty, repair torn edges before new features.
3. Re-run Graphifier after a large repair so the cache matches the code.

## User-facing

Show a short topology (nodes + edges + next). Do not dump the whole repo tree.

pub const DRAFT: &str = r#"# Draft log

Phase: clarify
Done: —
Blocked: —
Next: load Helix and intake

---

## [session start]
- Intent:
- Did: created `.skidora/`
- Evidence: —
- Open:
"#;

pub const PLAN: &str = r#"# Plan
- Intent:
- Action class:
- Scope (in):
- Scope (out):
- Modules to pull:
- Architecture:
- Artifacts:
- Verify:
- Risks:
"#;

pub const RECOVER: &str = r#"# Recover prompt

Slug: {slug}
Path: {path}
Updated: {updated}

## Goal
—

## Decisions
- none yet

## Key files
- .skidora/draft.md — running Helix log

## Live endpoints
- none

## NLP map
- none

## Next
load Helix and intake

## Open risks
- none
"#;

pub const GRAPH: &str = r#"# Graph
Updated: {updated}
Question: {question}

## Nodes
-

## Edges
-

## Torn
-

## Next
-
"#;

pub const INDEX: &str = r#"# Recover index

Tiny prompts live in `memory/projects/<slug>.md`. Do not store secrets.

| Slug | Path | State | Updated |
|---|---|---|---|
"#;

pub const RECOVER: &str = r#"# Recover prompt

Slug: {slug}
Path: {path}
Updated: {updated}

## Goal
—

## Decisions
- none yet

## Key files
- none

## Live endpoints
- none

## NLP map
- none

## Next
load Helix and intake

## Open risks
- none

## Verified Milestones
- [{updated}] Initialized Skidora single-file recover memory.
"#;

pub const INDEX: &str = r#"# Recover index

Tiny prompts live in `memory/projects/<slug>.md`. Do not store secrets.

| Slug | Path | State | Updated |
|---|---|---|---|
"#;

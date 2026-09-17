# When not to run the full loop

Skidora stays efficient by **not** running AG3 on small work. This applies to every agent and every project.

## Small (skip plan, architecture, Graphifier, 95-plus loop)

Do these in one pass. Still no hallucination. Still do not invent files.

- Typo, comment, rename of one symbol, one-line fix
- "What does this file do?" / "Where is X?" (answer from the repo)
- Format, lint-ignore, import sort
- Re-word a reply with no code change

For small work: Helix load if `.skidora/` exists (do not init), change the file, one proof if tests are already in reach. No question block. No architecture dump.

## Full loop (required)

- New feature, new/removed endpoint or component
- Workflow, automation, CD, scaffold
- Recover/rewind a past project
- Torn code, unclear topic
- User said accept / remove this / make this backend or frontend
- Any presentation, demo, or "it works" claim on an API or UI

## Hidden plan is not "small"

`don't plan` still writes `.skidora/plan.md` and still verifies. It only hides the plan from the user. See [planning.md](planning.md).

## One module per turn

After the skip/full decision, read **at most** the dispatch rows you need. Do not open every reference file.

# Adaptive Execution & Principles Reference

The canonical **7-Rung Ladder**, KISS, DRY, and (accurate) SOLID are in [`skills/skidora-when-not/SKILL.md`](../skills/skidora-when-not/SKILL.md). YAML description does not list SOLID. Interface Segregation means callers must not depend on methods they do not use — not "skip paperwork".

## The 7-Rung Ladder Summary
1. **YAGNI:** Does this need to exist? Skip if speculative.
2. **In Codebase:** Reuse existing helpers, types, or utilities (DRY: "Do it once").
3. **Standard Library:** Use language built-ins instead of custom packages.
4. **Native Platform:** Leverage HTML5, CSS, or database constraints.
5. **Existing Dependency:** Use already-installed libraries.
6. **One-Liner:** Keep it cleanly in one line if possible (KISS: "Do it simple").
7. **Minimum Viable Code:** Write the absolute minimum safe code that fixes the root cause.

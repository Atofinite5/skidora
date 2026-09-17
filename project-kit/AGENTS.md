# Skidora Agent Protocol (Append to your AGENTS.md)

This project operates under the **Skidora Operating System**:
- **Surgical Mode (Default):** Run the 7-Rung Ladder (YAGNI, KISS, DRY). Shortest working diff wins. Max 3 lines of chat output. Silent 1-line append to `.skidora/recover.md`.
- **Blueprint Mode (Structural):** Public APIs, DB schemas, or boundary changes require dual-pass verification (Pass A AST file:line + Pass B runtime command) and the 3-line Proof-of-Work Badge.
- **Single-File Memory:** All cross-session state lives in `.skidora/recover.md` (<40 lines). Never create `draft.md` or `plan.md`.
- **Zero Hallucination:** Every endpoint must exist in physical router code.

# Example Traces

Three concrete traces demonstrate Skidora execution in practice.

---

## Trace 1: Surgical Bug Fix (90% Default Mode)

**User Prompt:** `fix the date parsing error in auth/token.ts`

**Agent Execution:**
1. **Ladder Check:** Steps down 7-Rung Ladder -> Rung 3 (Standard Library: `Date.parse` or native `Intl`).
2. **Execution:** Surgical 4-line diff in `auth/token.ts`.
3. **Paperwork:** Zero markdown files created. No `draft.md`, no `plan.md`.
4. **Memory:** Appends one line to `.skidora/recover.md`:
   `- [2026-09-18] Fixed ISO date parsing in auth/token.ts. (12/12 tests pass)`
5. **Response to User:** (≤3 lines total explanation + code diff)
   ```markdown
   Fixed timestamp normalization in `auth/token.ts` to support ISO 8601 strings without seconds.
   Ran `npm test auth/token.test.ts` — 12/12 tests green.
   ```

---

## Trace 2: Blueprint New Route + Proof-of-Work (10% Structural)

**User Prompt:** `add POST /api/v1/billing/webhook with HMAC signature check`

**Agent Execution:**
1. **Gate Check:** New public endpoint with auth validation -> **Blueprint Mode**.
2. **Intake:** Read `.skidora/recover.md` and repo router (`app/api/billing/webhook/route.ts`).
3. **Implementation:**
   - Implement router handler with HMAC SHA-256 header validation and Zod schema.
   - Unauthorized requests without valid signature return `401 Unauthorized`.
   - Authorized requests with valid signature return `200 OK`.
4. **Dual-Pass Verification:**
   - **Pass A (Static):** AST check (`app/api/billing/webhook/route.ts:18` registered in Next.js/Express router).
   - **Pass B (Runtime - Negative & Positive Proof):**
     - Negative test (bad signature): `curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:3000/api/v1/billing/webhook -H "x-signature: invalid" -d "{}"` -> `401 Unauthorized` (Proof of signature enforcement).
     - Positive test (valid test HMAC): `curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:3000/api/v1/billing/webhook -H "x-signature: <computed_hmac>" -d '{"event":"charge.succeeded"}'` -> `200 OK`.
5. **Memory:** Append milestone to `.skidora/recover.md`:
   `- [2026-09-18] Added POST /api/v1/billing/webhook with HMAC SHA-256 validation (Pass A & B verified).`
6. **Response to User:** Includes code diff and standardized 3-line badge:
   ```markdown
   [Skidora Proof-of-Work]
   - Pass A (Static): app/api/billing/webhook/route.ts:18 — Route registered with HMAC SHA-256 validation.
   - Pass B (Runtime): curl -X POST ... with bad sig -> 401 Unauthorized; with valid HMAC -> 200 OK (exit 0)
   - Regression: 18/18 test suites passing (0 failures)
   ```

---

## Trace 3: Recover Context Across Sessions

**User Prompt:** `continue yesterday's authentication work`

**Agent Execution:**
1. **Read Memory:** Read `.skidora/recover.md`.
2. **Zero Paperwork:** Do NOT write `.skidora/plan.md`. Do NOT re-ask solved questions.
3. **Status Output:** Extract current state and immediately state the next physical file:line to modify:
   ```markdown
   Resuming from `.skidora/recover.md`:
   - Phase: execute
   - Done: Fixed ISO date parsing in auth/token.ts
   - Next: Implement refresh token rotation in `auth/refresh.ts`
   ```
4. **Action:** Begin immediate execution on `auth/refresh.ts`.

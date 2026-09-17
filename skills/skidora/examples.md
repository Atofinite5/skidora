# Concrete Execution Examples

Copy these three traces. Never invent a fourth ritual.

---

## Trace 1: Surgical Fix (Default — 90% of Tasks)

**User Prompt:** `fix bookingKpis day window calculation in src/kpis.ts`

**Agent Execution:**
1. **Gate Check:** Small bug fix -> **Surgical Mode**.
2. **7-Rung Ladder:**
   - Step down ladder: Rung 6 (clean one-liner date calculation using existing `date-fns` helper).
3. **Action:** Apply shortest working diff to `src/kpis.ts`.
4. **Run Tests:** `npm test -- -t "bookingKpis"` -> 14/14 passed.
5. **Memory:** Silently append one line to `.skidora/recover.md`:
   `- [2026-09-18] Fixed bookingKpis 7-day window calculation in src/kpis.ts. (14/14 tests pass)`
6. **Response to User (<=3 lines):**
   ```markdown
   Updated `src/kpis.ts` to adjust the 7-day inclusive window.
   Ran test suite: 14/14 unit tests green.
   ```

---

## Trace 2: Blueprint New Route + Proof-of-Work (10% Structural)

**User Prompt:** `add POST /api/v1/billing/webhook with signature check`

**Agent Execution:**
1. **Gate Check:** New public endpoint -> **Blueprint Mode**.
2. **Intake:** Read `recover.md` and repo router (`app/api/billing/webhook/route.ts`).
3. **Implementation:**
   - Implement router handler with HMAC SHA-256 header validation and Zod schema.
4. **Dual-Pass Verification:**
   - Pass A: Static AST check (`app/api/billing/webhook/route.ts:18`).
   - Pass B: `curl -s -X POST http://localhost:3000/api/v1/billing/webhook -H "x-signature: test" -d "{}" -w "%{http_code}"` -> 200 OK.
5. **Memory:** Update `.skidora/recover.md` active routes.
6. **Response to User:** Includes code diff and the standardized 3-line badge:
   ```markdown
   [Skidora Proof-of-Work]
   - Pass A (Static): app/api/billing/webhook/route.ts:18 — Route registered with HMAC signature check.
   - Pass B (Runtime): curl -X POST http://localhost:3000/api/v1/billing/webhook -> 200 OK
   - Regression: 18/18 test suites passing (0 failures)
   ```

---

## Trace 3: Recover Context Across Sessions

**User Prompt:** `continue yesterday's authentication work`

**Agent Execution:**
1. **Read Memory:** Read `.skidora/recover.md`.
   - Found: `Next: Implement JWT refresh token rotation in src/auth/token.ts`.
2. **Zero Paperwork:** Do NOT write `.skidora/plan.md`. Do NOT re-ask solved questions.
3. **Implement:** Write token rotation logic using existing crypto primitives.
4. **Verify:** Run auth test suite.
5. **Update Memory:** Mark milestone verified in `.skidora/recover.md`.
6. **Response to User (<=3 lines):**
   ```markdown
   Resumed from `.skidora/recover.md`: Implemented JWT refresh token rotation in `src/auth/token.ts`.
   Auth test suite verified (6/6 tests passing).
   ```

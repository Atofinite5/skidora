# Architecture (Blueprint Mode Only)

Intent: <one sentence>

## Modules
- <module> — <role>

## Request Flow
1. <client / caller>
2. <route entry>
3. <handler / controller>
4. <store / downstream service>

## Endpoints in Scope
| Method | Path | Auth | Change |
|---|---|---|---|
| GET | /... | | add / edit / remove |

## Verification Plan
- Pass A (Static): open router/handler and cite <file>:<line>
- Pass B (Runtime): <literal command run this turn> -> <actual exit/http code> (or UNVERIFIED)

## Torn State / Risks
- <none or identified risk>

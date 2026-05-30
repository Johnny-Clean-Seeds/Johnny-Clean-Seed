# Triple-Check Before Resend Hardening Checklist V1

Date: 2026-05-30
WorkKey: TRIPLECHECK-RESEND-HARDENING-20260530
Status: CHECKLIST / NOT DOCTRINE

## Checklist

- Object relocked.
- Failure trail named.
- Current guard named.
- Required proof conditions listed.
- Current file checked for soft-report risk.
- Known dangerous patterns self-scanned.
- Required failures produce blocked/nonzero exit.
- Code Gate required before direct run.
- Direct run allowed only after Code Gate target pass.
- Result classified as proof, watch, blocked, or failed.
- Process saved if it produces reusable system learning.

## Dangerous old patterns to scan for

- markdown backtick traps in PowerShell strings;
- `$Matches` / `$matches` variable collision;
- mandatory collection binding with possibly empty collections;
- scalar `.Count` assumptions;
- command output followed directly by operators;
- manifest or receipt checked before creation;
- Code Gate PASS treated as job PASS;
- report creation treated as proof.
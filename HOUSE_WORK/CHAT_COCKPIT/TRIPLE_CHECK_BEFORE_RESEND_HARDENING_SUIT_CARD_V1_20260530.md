# Chat Suit Card — Triple-Check Before Resend Hardening V1

Date: 2026-05-30
SuitKey: TRIPLE-CHECK-BEFORE-RESEND-HARDENING-SUIT-V1
RuleKey: TRIPLE-CHECK-BEFORE-RESEND-HARDENING-ORDER-V1
Status: CHAT COCKPIT SUPPORT CARD / PROCESS RULE / NOT DOCTRINE

## Wear line

Do not merely resend after repeated lower-layer failures. Re-lock, re-check, harden, then send.

## Use when

Use this when a helper, script, file, handoff, or save route is requested again after:

- parser failure;
- run-layer failure;
- collection-shape failure;
- report primitive failure;
- manifest/save-order failure;
- broken download/link;
- command mash;
- Code Gate pass followed by direct-run failure;
- user says go back over it or triple check.

## Required checks

1. What is the active object?
2. What failure trail is active?
3. What current guard applies?
4. What must this file prove?
5. Does the current file enforce those proof conditions?
6. Does it self-scan for old dangerous patterns?
7. Does it exit nonzero or blocked if required proof fails?
8. Is it safe to resend?

## Blocked moves

- no mechanical resend after repeated lower-layer failures;
- no "same file" unless already proven fit;
- no report that looks like proof but lacks required checks;
- no Code Gate PASS treated as job PASS;
- no direct run after Code Gate target nonzero.

## Final Judge

PASS only if the file is hardened enough to prove or block its own required conditions.
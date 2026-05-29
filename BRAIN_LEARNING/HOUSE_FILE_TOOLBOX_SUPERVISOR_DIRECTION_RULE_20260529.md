# House File Toolbox Supervisor Direction Rule — 2026-05-29

## Status

Type: durable build-direction rule / behavior target.

Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX; not automation.

Verdict: ACCEPT WITH GUARDRAILS / LOCK AS FORWARD TOOLBOX DIRECTION.

## Core lock

The forward architecture for the house file toolbox is supervisor-first.

The menu is a child surface.

The supervisor is the parent system.

The locked direction is:

`
launcher -> bootstrap -> preflight -> action manifest -> runner -> watcher -> recovery ladder -> report -> cleanup -> learning ledger -> next suggested action
`

This direction stays valid even if every feature is not built now, not built in one pass, or never built fully.

Work may proceed incrementally, but the shape should not drift back into a flat menu that collects features without supervision, proof, recovery, and cleanup.

## Required principles

1. The .cmd launcher owns missing-engine bootstrap and ToolHome repair.
2. The .ps1 engine owns menu, manifests, runners, watcher, recovery, reports, and settings only after it is loaded.
3. ToolHome is the stable local tool home:

   C:\Users\13527\Desktop\file tools

4. Every nontrivial action writes an action manifest before execution.
5. Action manifests are steering authority.
6. Watcher/receipts are proof authority.
7. Recovery ladder is next-move authority.
8. Learning ledger is local pattern memory, not doctrine.
9. Git save remains exact-file manifest workflow only.
10. Git status/ignore output is proof after selection, not steering authority.
11. Window cleanup may close only toolbox-opened windows, gently and with user confirmation when unsaved work is possible.
12. Code Gate PASS is parser/risk proof only; it is not job PASS.
13. Report-open actions are not house truth claims.
14. Unknown/missing fields in a review are defects unless every source lacks the value and the review says which sources were checked.
15. The toolbox must create recovery cards for repeated failure shapes and route through known clean next steps instead of producing raw console mess.

## Blocked drift

Blocked:

- no flat-menu feature pile as final architecture;
- no casual Git toggle that commits whatever is dirty;
- no wildcard/folder force-add;
- no force-close of unsaved Notepad windows by default;
- no treating Git status as the decision-maker;
- no report-open equals PASS;
- no learning-ledger promotion to doctrine;
- no deleting unknown files to repair;
- no pretending a missing .ps1 can repair itself after PowerShell failed to load it.

## Clean slogan

Supervisor first. Manifest steers. Watcher proves. Recovery routes. Git saves only exact files.
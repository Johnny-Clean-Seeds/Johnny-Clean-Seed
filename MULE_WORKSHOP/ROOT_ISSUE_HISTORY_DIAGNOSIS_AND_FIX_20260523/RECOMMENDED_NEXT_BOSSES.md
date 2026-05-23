# Recommended Next Bosses

Date: 2026-05-23

Status: next clean work order, pending user choice.

## Next Boss 1: Save / Lock This Packet If Approved

Why:
The diagnosis and safe local fixes are complete as files, but not committed or pushed.

Exact action:
If user chooses save/lock, stage only this output folder, commit it, push it, verify origin/main equals HEAD, and update receipt with commit proof if approved.

Blocked until:
User explicitly chooses save/lock.

## Next Boss 2: Home Path Sync Candidate

Why:
Prior audit evidence found active control files still pointing at `C:\Users\13527\Desktop\Jxhnny_Kleen_C3dz` while active home is `C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz`.

Exact action:
Create a scoped Home Path Sync candidate that lists intended replacements, protected files, proof needed, and rollback plan before editing.

Blocked:
Do not rewrite `CURRENT_TRUTH_INDEX`, `AGENTS.md`, Command Center pointers, or scripts without explicit approval.

## Next Boss 3: Runner / Porch Lifecycle Closeout Card

Why:
The issue list proves runner scripts can succeed but still leave porch lifecycle unfinished.

Exact action:
Write a compact candidate:
`runner created/sent -> dropped -> preflighted -> run -> report -> verify -> archive used runner -> receipt -> porch clean`.

Proof:
Next runner task uses it and records root `.ps1` count before/after.

## Next Boss 4: Recursive Mirror Live-Use Card

Why:
The mirror rule exists but still needs a small work-entry card that actually fires.

Exact action:
Shrink the mirror chain into a reusable live card:
`active boss / parent rule / sibling rule / child behavior / TODO / parking / delivery / path / source / mule / proof / Final Judge`.

Proof:
Use it on one nontrivial action before installing broadly.

## Next Boss 5: Target Proof Comparator Footer

Why:
Neighbor proof masked target failure in the recent chain.

Exact action:
Add a save-ready candidate footer:
`intended files / actual files / hashes / Git state if authorized / blockers / verdict`.

Proof:
Use it on the next save or local-fix packet.

## Next Boss 6: Local-Only Tracking Audit

Why:
Prior audit found tracked paths whose names imply local-only or not-Git.

Exact action:
Create a table:
`path / why local-only named / tracked state / keep tracked / untrack / relabel / split pointer / blocked`.

Blocked:
No untracking or relabeling without review.

## Next Boss 7: Work Shed Reference Reconciliation

Why:
`.gitignore` excludes shed folders, but history/status/TODO files still contain thousands of Work Shed references.

Exact action:
Decide whether references are:

- historical only;
- need archive pointer;
- need clean non-shed stub;
- should remain unchanged;
- need separate restoration approval.

Blocked:
Do not restore shed or bridge folders automatically.

## Next Boss 8: TODO / Parking Return Trigger Scan

Why:
TODO and parking rules exist, but repeated failures show return triggers do not always control re-entry.

Exact action:
Run a proof-ranked scan of open TODO/parking items only after Home Path Sync and Work Shed reference status are clear.

## Clean Order

1. Ask user save/lock, continue, or chat review.
2. If save/lock: commit/push this packet only.
3. If continue: start Home Path Sync candidate, not broad rewrite.
4. If chat review: hand back the report paths and wait.

## Do Not Start Yet

- Broad active guide rewrite.
- CURRENT_TRUTH_INDEX rewrite.
- Doctrine promotion.
- Work Shed restoration.
- Local-only untracking.
- Mule return adoption.
- Dashboard or automation.

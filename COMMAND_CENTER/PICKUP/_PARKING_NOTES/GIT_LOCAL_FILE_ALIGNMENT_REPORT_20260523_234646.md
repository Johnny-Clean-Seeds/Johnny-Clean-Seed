# Git / Local File Alignment Report - 20260523_234646

Status: LOCAL ALIGNMENT CHECK / NO COMMIT / NO RESTORE / NO DELETE

## Summary

- Repo: C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz
- Tracked files total: 3003
- Tracked files present in repo worktree: 2908
- Tracked paths absent from repo worktree: 95
- Git deleted paths: 95
- Deleted tracked paths covered by messy ledger: 95
- Deleted tracked paths with bad/missing messy proof: 0
- Deleted tracked paths with no messy ledger row: 0
- Untracked local files: 24

## Decision

The 95 deleted tracked paths are the approved Neocities move-out. They are not lost from the PC. They are preserved under:

C:\Users\13527\Desktop\messy\NEOCITIES_FROM_Jxhnny_Kl33N_Seedz_20260523_220438\PAYLOAD

Ledger:

C:\Users\13527\Desktop\messy\NEOCITIES_FROM_Jxhnny_Kl33N_Seedz_20260523_220438\NEOCITIES_MOVE_LEDGER_20260523_220438.csv

## Alignment Meaning

Local-file preservation: PASS.

Git working tree alignment: PARTIAL BY DESIGN.

Reason: the Neocities files were intentionally moved out of the repo to Desktop messy. Git now sees them as deleted until the user explicitly chooses one of these later moves:

- commit the Neocities removal and add selected support files;
- restore Neocities into the repo;
- keep the repo dirty/local-only for now.

## Blocked Action

Do not auto-restore Neocities because the user asked to move it off to messy.
Do not auto-commit or push without explicit Git instruction.

## Git Status Summary

 D 95
?? 24

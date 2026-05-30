# Save Script Git Wrapper Living Ledger

## Helper / lane
Save-script helper family / Git wrapper lane.

## Purpose
Accumulate all useful data about save-script failures and fixes so future scripts do not repeat old mistakes.

## Current remembered failures

### Event 001 - Empty content reached writer

Prior failure family: a save script reached `Set-Utf8File` with empty fit-card content.

Learning: planned artifacts must be validated as non-empty before writing, and crash-discovered content must become a power-play rule/card instead of a rerun.

Status: captured previously in helper save-content validation learning.

### Event 002 - Ignored Work Shed paths blocked Git add

Failure: `LOCK_SAVE_HELPER_LIVING_MEMORY_LEDGER_V1.ps1` wrote planned living-ledger files, then failed because `git add --` encountered ignored `HOUSE_WORK/WORK_SHED` paths.

Learning: save scripts that intentionally save ignored Work Shed support files must exact-force-add only the planned paths and verify staged set before commit.

Status: open until a repaired save script commits/pushes/verifies these paths cleanly.

### Event 003 - Git wrapper called bare git

Failure: `LOCK_SAVE_FRESHEN_UP_INTERNAL_ORIENTATION_AND_FILE_RULE_V1.ps1` failed with bare `git` usage output.

Evidence: write-mode failure printed `GIT_FAILED: git  usage: git ...`.

False blame blocked:

- not a parser failure;
- not a bad Freshen' up rule;
- not a Git remote failure;
- not a user input failure.

Root cause: helper Git wrapper argument-list/control-variable bug.

Fix in V1.1:

- rename wrapper parameter to `$GitArgs`;
- block empty argument lists before running Git;
- print `$GitArgs` in errors;
- exact-stage planned paths;
- use `git add -f` only for ignored planned files;
- verify staged set, commit, push, fetch, remote match, and clean status.

Closed when: V1.1 save completes with `HEAD == origin/main` and final status clean.

Reopen trigger: any future save script prints bare Git usage, loses arguments, or claims save without final remote/clean proof.
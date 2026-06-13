# Chat Drop Anchor Naming And Freshness Rule V0.1

Status: PUBLIC_NOTE / CHAT_DROP_FRESHNESS_HELPER / NOT_DOCTRINE
Date: 2026-06-13

Purpose:
Make Chat Drop currentness visible by filename and by a small load-first anchor, so outside agents stop treating every top-level Chat Drop card as equally current.

## Rule

Every required Chat Drop folder should contain:

`00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__V0_1_20260613.md`

That file sorts first and names:

- current helpers;
- superseded helpers;
- support-only helpers;
- not-default-load folders;
- update-needed conditions.

## Required Chat Drop Locations

Current required locations:

1. `C:\Users\13527\Desktop\123\Chat Drop`
2. `C:\Users\13527\Desktop\Chat Drop`

`ASSISTANT_LOCAL` is not a required mirror unless the user explicitly re-authorizes it.

## Filename Signals

- `00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__...` means load first before other Chat Drop helper cards.
- `00_ANCHOR__UPDATE_REQUIRED__...` means stop and tell the user a Chat Drop update is needed.
- `CHAT_DROP_COPY__...` means helper card; freshness must be checked against the load-first anchor.
- `_OLD_LOADS`, `_SYNC_REPORTS`, `_CLEANUP_REPORTS`, receipts, and workshop folders are not default-load.

## Current Helper Names Introduced By This Pass

- `00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__V0_1_20260613.md`
- `CHAT_DROP_COPY__CLEAR_LENS_ENTRY_SUIT_AND_OUTSIDE_AGENT_IDENTITY_CARD_V0_1_20260613.md`
- `CHAT_DROP_COPY__PULL_MEANS_LOCAL_FILES_RULE_V0_1_20260613.md`
- `PUBLIC_NOTES\CHAT_DROP_PULL_MEANS_LOCAL_FILES_RULE_V0_1_20260613.md`
- `TOOLS\ChatDropFreshnessScanner.ps1`

## Agent Behavior

Plain `pull` means take from, read from, inspect, or bring forward from the named local file surface.

For Chat Drop work, `pull the chat drops` means inspect or take from:

1. `C:\Users\13527\Desktop\123\Chat Drop`
2. `C:\Users\13527\Desktop\Chat Drop`

Plain `pull` does not mean GitHub, Git remote, clone, fetch, sparse checkout, or `git pull` unless the user explicitly says `git`, `GitHub`, `remote`, `repo`, `branch`, `commit`, `clone`, `fetch`, `git pull`, or gives a repo URL.

If the target is unclear, ask a short clarification or run only the local read-only scanner.

If the anchor says a file is missing from one required Chat Drop folder, say:

`CHAT_DROP_UPDATE_NEEDED: [folder] is missing [file].`

If the agent is local and has the Git repo, it may run the read-only scanner:

`powershell -NoProfile -ExecutionPolicy Bypass -File .\TOOLS\ChatDropFreshnessScanner.ps1`

The scanner must not mutate, rename, delete, move, commit, or push.

The scanner must not clone, fetch, pull from GitHub, or print a pass verdict after missing proof.

If the user approves a Git publish lane after Chat Drop updates, use helper files, stage only exact public-safe files, run `git diff --cached --check`, commit, push, and report the commit.

## Does Not Prove

This note does not prove local Chat Drop state by itself, does not authorize cleanup, does not make Chat Drop source authority, and does not replace the current user command.

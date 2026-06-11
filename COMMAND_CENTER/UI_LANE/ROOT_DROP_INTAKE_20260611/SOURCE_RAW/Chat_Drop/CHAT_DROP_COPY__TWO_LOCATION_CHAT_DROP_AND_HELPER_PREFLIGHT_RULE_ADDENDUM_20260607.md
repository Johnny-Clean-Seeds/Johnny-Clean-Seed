# TWO LOCATION CHAT DROP AND HELPER PREFLIGHT RULE ADDENDUM

Status: CHAT_DROP_RULE_ADDENDUM / LOAD_LAST_AND_OVERRIDE_OLD_THREE_COPY_LANGUAGE / NOT_DOCTRINE
Date: 2026-06-07

## RULE 1 - TWO REQUIRED CHAT DROP LOCATIONS

There are two required Chat Drop locations by default:

1. `C:\Users\13527\Desktop\123\Chat Drop`
2. `C:\Users\13527\Desktop\Chat Drop`

The 123 Chat Drop is the mule working copy.

The Desktop Chat Drop is the user handoff copy and assistant-load copy.

## RULE 2 - NOT A REQUIRED THIRD MIRROR

`C:\Users\13527\Desktop\ASSISTANT_LOCAL\CHAT_RULES_LOCAL_ONLY` is not a required Chat Drop mirror by default.

If present, it is legacy/local auxiliary only unless the user explicitly re-authorizes it.

## RULE 3 - SUPERSEDES OLD THREE-COPY LANGUAGE

Any older Chat Drop instruction, receipt, report, addendum, or assistant note that says there are three required Chat Drop mirrors is superseded.

ASSISTANT_LOCAL is not a required mirror.

This addendum loads last and overrides older three-location language.

## RULE 4 - NOTICE TRIGGER

When the user says "NOTICE: I updated Chat Drops," the Desktop Chat Drop is the fresh source.

The mule must compare Desktop Chat Drop into 123 Chat Drop.

The mule must not invent or require a third mirror.

## RULE 5 - MULE PUBLISH RULE

When the mule creates or updates Chat Drop files inside 123 Chat Drop, the mule must also publish the user handoff copy into Desktop Chat Drop so the user can drop it into ChatGPT.

## RULE 6 - HELPER FILE PREFLIGHT

Before any mule job, the mule must identify and use the relevant helper files.

Do not rely on Git alone.

Do not rely on chat memory alone.

Do not rely on receipts alone.

Load the active/current Chat Drop helper files first.

Do not blindly load `_OLD_LOADS`.

If helper files are missing, stale, contradictory, or unreadable, report `HELPER_FILE_BLOCKER`.

## RULE 7 - LOAD ORDER

Load current top-level `CHAT_DROP_COPY__*.md` helper files.

Load this two-location/helper-preflight rule addendum last.

Do not load `_OLD_LOADS`, `_SYNC_REPORTS`, `_CLEANUP_REPORTS`, `RECEIPTS`, workshop folders, or `ASSISTANT_LOCAL` by default.

## RULE 8 - _OLD_LOADS

`_OLD_LOADS` is historical reference only.

`_OLD_LOADS` is not trash.

`_OLD_LOADS` is not current load.

`_OLD_LOADS` must not be deleted unless the user explicitly approves.

## RULE 9 - FINAL RETURNS MUST BE VISIBLE

After Chat Drop work, the mule must tell the user exactly:

- which folder to open
- which files changed
- which file or folder to drop into the assistant
- whether helper files were used
- whether blockers remain

## DOESNOTPROVE

This addendum proves only the current two-location Chat Drop rule and helper-file preflight boundary. It does not prove Git export is approved, rough_state retirement is approved, M1 fixture review is approved, cleanup is approved, or the project is complete.

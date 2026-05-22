# Desktop Drop Version Naming Rule — 20260522

## Status

Type: brain-learning / desktop-drop naming and user-facing artifact rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not rename internal house/repo files.
- This applies only to Desktop/drop/download/export items meant for the user to handle directly.

## Core Rule

When the assistant creates or drops a file for the user's Desktop or as a Desktop-facing/downloadable transfer item, the file name must include a clear version suffix.

Use this version sequence:

- V1
- V1.1
- V1.2
- V1.3
- V1.4
- V1.5
- V1.6
- V1.7
- V1.8
- V1.9
- V2.0
- V2.1
- V2.2
- continue as needed

## Purpose

The user needs to know which Desktop drop is current, which one is older, and which artifacts belong to the same family.

Versioned Desktop drops reduce confusion, duplicate clutter, stale downloads, and accidental use of the wrong file.

## Naming Shape

Use:

RESPECTIVE_DESCRIPTIVE_NAME_V1.ext

Examples:

SAVE_DESKTOP_DROP_VERSION_NAMING_RULE_V1.ps1

ROBOCOP_CONTEXT_README_SETUP_PACK_V1.zip

BOSS_WHIRLPOOL_3_LAP_MULE_HANDOFF_V1.md

If a revised Desktop drop is made in the same artifact family, use:

RESPECTIVE_DESCRIPTIVE_NAME_V1.1.ext

Then:

RESPECTIVE_DESCRIPTIVE_NAME_V1.2.ext

After V1.9, use V2.0.

## Applies To

This applies to user-facing external/drop artifacts such as:

- downloadable scripts;
- Desktop helper scripts;
- Desktop transfer packs;
- ZIP packs;
- handoff files dropped for the user;
- chat-produced files meant for user download;
- Desktop drop-copy support files when they are new exported versions;
- one-shot launchers the user handles directly.

## Does Not Apply To Internal House Files

Do not use this style for internal house/repo files.

Internal house files keep existing conventions:

- lane path;
- role name;
- date stamp;
- receipt naming;
- proof-history naming;
- current project naming rules.

Examples of internal house files that should not be forced into V1/V1.1 style:

- BRAIN_LEARNING/*.md
- HOUSE_WORK/WORK_SHED/*.md
- PROOF_HISTORY/*.txt
- HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
- ACTIVE_ANCHOR.txt
- CURRENT_TRUTH_INDEX files
- ACTIVE_GUIDES files

## Version Family Rule

A version series belongs to an artifact family.

If the same desktop/drop artifact is revised, increment the version.

If it is a new artifact family, start at V1.

## Reporting Rule

When a Desktop/drop artifact is created, report:

- file name;
- version;
- whether it is a new family or revision;
- SHA256 when practical;
- whether it is local-only or local+URL;
- whether an internal house save also happened separately.

## Failure Pattern

Dirty pattern:
Creating several Desktop/download files with similar names and no visible version.

Worse dirty pattern:
Using V1/V1.1 naming inside the house and polluting internal project naming.

Worst dirty pattern:
Replacing an older Desktop drop without making the version visible.

## Clean Pattern

Clean pattern:

1. Name the Desktop drop clearly.
2. Add version suffix.
3. Preserve internal house naming separately.
4. Report local-only versus local+URL.
5. If revised, increment version.

## Short Form

Desktop drops get V names.

House files do not.

V1, V1.1 to V1.9, then V2.0, V2.1, and onward.

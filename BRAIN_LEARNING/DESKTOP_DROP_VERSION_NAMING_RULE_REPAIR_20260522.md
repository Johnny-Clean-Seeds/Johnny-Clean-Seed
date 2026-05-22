# Desktop Drop Version Naming Repair — 20260522

## Status

Type: brain-learning / repair to Desktop-facing artifact naming.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not rename internal house/repo files.
- This applies only to Desktop/drop/download/export items meant for the user to handle directly.

## Repair

The earlier Desktop Drop Version Naming rule was correct in principle, but the assistant still made Desktop-facing names too long and treated the CHAT cockpit current-pointer as a broad exception without explicit user approval.

Correction:

Desktop-facing files must use names that are:

1. short enough to read;
2. direct enough to identify the job;
3. versioned with V sequence.

## Core Rule

Keep the name to the point.

Add the V suffix.

Use:

NAME_V1.ext
NAME_V1.1.ext
NAME_V1.2.ext
...
NAME_V1.9.ext
NAME_V2.0.ext
NAME_V2.1.ext

## Examples

Good Desktop/drop names:

- SAVE_DESKTOP_NAMING_REPAIR_V1.1.ps1
- MULE_HANDOFF_V1.md
- ROBOCOP_SETUP_V1.zip
- CHAT_COCKPIT_V1.md
- PORCH_DROPPER_V1.ps1
- SOURCE_PACKET_V1.md

Bad Desktop/drop names:

- overlong file names that read like a paragraph
- names with too many stacked concepts
- names without visible V suffix
- names that force the user to guess which one is current

## Internal House Exception

Internal house/repo files still do not use the Desktop V style.

House files keep lane/date/receipt naming.

Examples:

- BRAIN_LEARNING/*.md
- HOUSE_WORK/*.md
- PROOF_HISTORY/*.txt
- ACTIVE_ANCHOR.txt
- CURRENT_TRUTH_INDEX files
- ACTIVE_GUIDES files

## Current-Pointer Rule

A stable current-pointer Desktop file is allowed only if the user explicitly approves it.

Do not assume the exception.

Until approved, Desktop-facing cockpit drops should also provide a concise V-named copy such as:

CHAT_COCKPIT_V1.md

The internal canonical cockpit file remains:

HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

## Apply Gate

Because this repair touches existing rules, it must run through the Multi-Rule Batch Compatibility Apply Gate.

Compatibility checks required:
- Desktop naming obeys No Parking.
- Desktop naming obeys Save Location split.
- Desktop naming does not rename internal house files.
- Cockpit/drop-copy update remains visible.
- The prior bounded exception is either user-approved or corrected.
- Receipt states local+URL and local-only split.

## Short Form

Desktop drops:
short name + V number.

House files:
normal house naming.

No assumed exceptions.

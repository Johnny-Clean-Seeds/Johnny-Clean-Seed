# Porch Watcher / Move-Not-Copy Housekeeping Rule — 20260522

## Status

Type: project-wide housekeeping and dropper/routing rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not background automation by itself.
- This does not delete files.
- This does not make Desktop the source of truth.
- This does not replace source custody or proof gates.

## Core Rule

Default intake/routing is MOVE, not COPY.

Dropped, downloaded, generated, or porch-sitting project files must not be copied into place while the original is left hanging.

A porch/dropper tool should:

1. read the file name;
2. classify the object;
3. identify the correct lane;
4. MOVE the file to that lane;
5. write a receipt;
6. report blocked/unknown files instead of leaving silent clutter.

## Copy Exception

Copy is allowed only for intentional export/mirror/drop-copy cases.

Those copies must be clearly labeled as copies.

Examples:
- CHAT_DROP_COPY files for dragging into chat;
- exported receipts;
- intentional backup versions;
- intentional mirror/output artifacts.

If it is not an explicit copy/export/mirror/drop-copy case, do not copy by default.

## Porch Definition

Porch means loose intake area where files can pile up before placement, especially:

- Desktop
- Downloads
- root of Desktop\123
- tool download areas
- chat-generated artifact landing areas

Porch is not a permanent lane.

## Move Rule

A generated/downloaded project file must either:

- be moved to the correct lane;
- be explicitly exported as a labeled copy;
- be parked in a sorting lane with a reason;
- or produce a blocked receipt.

Do not leave it floating.

## Watcher/Dropper Requirement

The porch watcher/dropper must classify by name first.

High-confidence examples:

- BOSS_WHIRLPOOL_3_LAP_MULE_HANDOFF -> MULE_WORKSHOP/ASSISTANT_TO_MULE
- MULE_HANDOFF -> MULE_WORKSHOP/ASSISTANT_TO_MULE
- SAVE_*.ps1 -> COMMAND_CENTER/SCRIPTS/SAVE_SCRIPTS
- ROBOCOP*.zip -> TOOL_PACKS/ROBOCOP
- CHAT_DROP_COPY__* -> chat cockpit drop-copy lane or Desktop export
- *.url -> SOURCE_TRANSFER/URL_SHORTCUTS
- unknown project-like files -> PORCH_SORTING_TABLE/NEEDS_REVIEW

## Dirty Pattern

Dirty pattern:
copying a file into the right place while leaving the original at the porch.

Worse dirty pattern:
making a handoff/download/script and never proving it was placed.

Worst dirty pattern:
a porch full of loose project artifacts with no watcher, no receipt, no move, and no route.

## Clean Pattern

Clean pattern:

1. Create/download artifact.
2. Classify by name and job.
3. Move to correct lane.
4. Write receipt.
5. If chat-facing, export labeled CHAT drop-copy.
6. If unknown, move to sorting table with receipt.
7. Do not leave porch clutter.

## Relation to Final Judge Gate

Final Judge Gate starts the gate run and ends it.

For porch/dropper work it asks:

- Did the object have a job?
- Did the dropper identify the job?
- Did it route to the right lane?
- Did it move instead of copy when move was required?
- Did it write a receipt?
- Did it leave porch clutter?

## Short Form

Porch is not storage.

Default route is move, not copy.

Copy only when explicitly labeled as copy/export/mirror/drop-copy.

No loose packages.

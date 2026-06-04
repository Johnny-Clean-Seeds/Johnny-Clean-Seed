# UI Action Card Template V0

Date: 2026-06-04
Status: TEMPLATE / DESIGN ONLY / NOT EXECUTION
WorkKey: UI-ACTION-CARD-TEMPLATE-V0-20260604

## Action Card

Command:

ResolvedIntent:

ActiveObject:

TargetPath:

SourcePath:

RequiredInputs:

AllowedActions:

ForbiddenActions:

ProofRequired:

StopAskConditions:

UserConfirmationRequired:

ReceiptPath:

ManifestPath:

RootCleanCheck:

CloseoutVerdict:

DoesNotProve:

## Required Boundary Fields

Every action card must name:

- what can be read;
- what can be written;
- what cannot be touched;
- whether Git is allowed;
- whether helper/target execution is allowed;
- whether watcher/automation is allowed;
- whether ACTIVE_GUIDES or CURRENT_TRUTH_INDEX are protected.

## Default Forbidden Actions

- target/helper execution without explicit authorization;
- watcher or automation;
- package install;
- broad root cleanup;
- delete user originals;
- doctrine promotion;
- ACTIVE_GUIDES edit;
- CURRENT_TRUTH_INDEX edit;
- commit/push without exact staged-set proof.

## Closeout Lines

Use exact closeout lines, for example:

- `ROOT_NO_LOOSE_FILES_CHECK_PASS`
- `TARGET_HELPER_NOT_RUN`
- `NO_COMMIT_NO_PUSH_WITH_REASON`
- `COMMIT_AND_PUSH_PROVED`
- `GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE`

# Porch Drop Event Trigger + Package Intake Rule — 20260522

## Status

Type: project-wide housekeeping / assistant-awareness trigger rule.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not background automation.
- This does not delete files.
- This does not promote dropped files or packages.
- This does not override source custody.

## Core Rule

When a file, folder, or package is dropped, record the event.

The event trigger must land where the assistant walks in so it fires before work begins.

Short phrase:
BAM — YOU GOT MAIL.

## Event Trigger Must Include

Every porch/drop event record must identify:

- timestamp
- object name
- object type: file, folder package, zip package, handoff, script, receipt, etc.
- source path
- classification
- route
- action taken: moved, parked, kept as intentional copy, blocked
- destination path
- receipt path
- next required assistant action

## Where The Trigger Lands

The event must land in the Command Center entry/current-context lane or equivalent assistant entry lane.

Default:

Desktop\123\COMMAND_CENTER\CURRENT_CONTEXT_CART\YOU_GOT_MAIL__PORCH_EVENT_TRIGGER_<timestamp>.md

Reason:
The assistant sees this where it walks in.

## Package / Folder Rule

If a folder is dropped, treat it as a package object first.

Do not scatter its internal files from the outside.

Process:

1. record folder name as package identity;
2. move the whole folder to PACKAGE_INTAKE/PACKAGES or a package review lane;
3. write a package event/receipt;
4. the assistant opens the package in the next intake step;
5. only after opening/reviewing the package may internal items be sorted.

Short form:
Folder name first. Whole package first. Open package later.

## File Rule

If a file is dropped, classify by filename first.

Move it to the correct lane or a review/sorting lane.

Do not copy and leave the original hanging.

## Desktop 123 Root Rule

The root of `C:\Users\13527\Desktop\123` is a drop-off zone, not a storage shelf.

Plain files found directly in that root must be moved into the house or a local-only hold before
final status. If a root file was copied for custody, the original still must be moved or explicitly
held with a receipt.

Use Root Drop Zone Immediate Intake Rule for the detailed intake, hash, move, receipt, mail trigger,
and root-clean verification.

## Package Rule

Packages include:

- dropped folders
- zip files
- grouped packets
- bundled artifacts
- tool packs
- mule returns
- handoff folders

A package must stay together until reviewed as a package.

## Relation to Move-Not-Copy Rule

Default route is MOVE, not COPY.

Copy is allowed only for explicit labeled exports, mirrors, backups, or chat drop-copies.

A drop event must say when an object is kept as an allowed copy.

## Dirty Pattern

Dirty pattern:
A file/folder is dropped, moved, or copied without any event visible at the assistant entry point.

Worse dirty pattern:
A folder package is broken apart before package review.

Worst dirty pattern:
The assistant asks "where is the file?" after a drop because no mail trigger was written.

## Clean Pattern

Clean pattern:

1. Drop happens.
2. Event is recorded.
3. Object is classified by name.
4. File moves to lane, or folder moves as whole package.
5. Receipt is written.
6. Mail trigger appears where assistant enters.
7. Assistant opens the mail trigger before acting.

## Short Form

Drop means event.

Folder means package.

Move, receipt, and YOU GOT MAIL trigger.

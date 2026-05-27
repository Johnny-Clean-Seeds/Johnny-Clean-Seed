# Misc Drawer Canonical Naming Rule
Date: 20260527

## Status

Type: naming / routing / read-before-action behavior rule.

This is not doctrine.
This is not delete authority.
This is not a new storage system by itself.
This is not proof replacement.
This is not a porch cleanup trigger.
This is not a mule rule unless mule lane is explicitly selected.

## Canonical name

Use one canonical house name:

`Misc Drawer`

The user may casually say:

- junk drawer
- misc pile
- misc drawer
- misc section
- intake drawer

Treat those as aliases for the same lane unless the user explicitly creates a narrower subtype.

## Meaning

The Misc Drawer is a temporary miscellaneous holding drawer for mixed material that must be read, classified, and routed before action.

It is for material that does not yet have a clean lane, or whose lane cannot be chosen until it is read.

It is not trash.
It is not mail.
It is not permanent storage.
It is not deletion authority.
It is not proof authority.
It is not source authority.
It is not a place to hide unresolved work.

## Subtype rule

Do not create many names.

If a more specific drawer is needed, name it as a subtype of the same pattern only when specificity helps routing.

Examples:

- Transcript Misc Drawer
- Script Misc Drawer
- Source Misc Drawer

The parent stays:

`Misc Drawer`

## Operating rule

When the user refers to the Misc Drawer or any alias, the assistant should treat it as a read-before-action lane.

Default sequence:

1. place or identify the mixed material;
2. read enough to classify;
3. decide whether it belongs in code, proof, source, cockpit, repo, mule, local-only, park, or block;
4. produce a move/code/save plan;
5. move or write only after the plan is safe;
6. do not delete;
7. do not call the drawer trash;
8. do not leave loose files in the root after the lane exists.

## Physical local lane

If a local drawer is created, use this root:

`C:\Users\<user>\Desktop\123\_MISC_DRAWER`

Suggested child folders:

- INBOX
- READ_REPORTS
- READY_FOR_CODE
- PROCESSED
- UNKNOWN_DO_NOT_TOUCH
- RECEIPTS

The folder root itself is one clean local object, not root slop.

## Git lane

Git should not receive raw mixed material by default.

Git may receive:

- cleaned read reports;
- routing decisions;
- receipts;
- stable rules;
- maps or indexes after source custody is clear.

Raw source-heavy, transcript-heavy, private, local-only, or unclassified material stays local unless a safe route says otherwise.

## Relationship to All-Gates Data Waste Team Entry

The Misc Drawer supports data-waste control by preventing loose root material and preventing premature writes.

The drawer is for temporary mixed material.
The All-Gates Data Waste Team decides what can be carried, pointer-only, dissolved from live load, parked, or saved.

Short form:
Use the drawer for mixed stuff. Read first. Classify. Then code, move, save, park, or block.

## Blocked moves

Blocked:

- no root slop;
- no blind moving;
- no deletion from drawer logic alone;
- no treating "junk drawer" as trash;
- no creating 100 drawer names;
- no putting raw unclassified source into Git by default;
- no coding from material before reading it;
- no permanent storage pile;
- no proof/source/receipt burning.

## Final short form

Misc Drawer means mixed material waiting to be read and classified.

Read first.
Classify.
Then act.

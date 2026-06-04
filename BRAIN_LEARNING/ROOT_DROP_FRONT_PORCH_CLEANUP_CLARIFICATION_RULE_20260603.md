# Root Drop Front-Porch Cleanup Clarification Rule

Date: 2026-06-03
Status: USER CORRECTION ACCEPTED / SUPPORT RULE CANDIDATE / NOT DOCTRINE

## Source Custody

Source file after root cleanup:

`C:\Users\13527\Desktop\123\_SOURCE_RESEARCH_NOTES\ROOT_TEXT_DROPS_20260603\CONSUMED_BY_REPO_SAVE\READ_THIS_MULE.txt`

SourceSHA256: `590491204313166D90D91089785721B9ACD1B81A87553A37E5225EDFF6C79820`

Line anchors:
- L1: front-porch cleanup clarification.
- L4-L6: root is temporary drop/front-porch surface, not long-term storage.
- L8-L17: required behavior is identify, hash, classify, read/apply, store, and receipt.
- L19-L26: forbidden actions include blind delete, broad cleanup, unclassified moves, and hiding source trail.
- L28-L32: safe interpretation is read, hash, classify, apply/park, store, receipt, root clean.

## Rule

When the user says "clean out the root folder" or "stop leaving files in there," treat root as a temporary intake/front-porch surface.

Do this:

```text
READ -> HASH -> CLASSIFY -> APPLY/PARK -> STORE IN RIGHT PLACE -> RECEIPT -> ROOT CLEAN
```

Do not treat the request as permission for broad delete, blind cleanup, protected-path movement, or source loss.

## Required Behavior

For each loose root drop:
- identify the file.
- hash before movement.
- classify as raw source, handoff, receipt/copy-back, temporary helper, or unknown.
- read and apply only authorized useful parts.
- store the original or custody copy in the right source/intake/archive/tool lane.
- leave a receipt or note showing where it went.
- keep root clean after custody is established.

## Forbidden

- blind delete.
- broad cleanup.
- moving without hash/classification.
- treating raw source as active doctrine.
- using root as durable storage.
- hiding the source trail.
- moving protected/project files unless explicitly authorized.
- deleting a raw file just because it was processed.

## Does Not Prove

This rule does not authorize broad folder cleanup, protected-file movement, tool activation, automation, repo rewrite, or deleting source material.

## Return Trigger

Return here whenever loose root files exist after intake, or when a cleanup request could be mistaken for delete/sweep behavior.

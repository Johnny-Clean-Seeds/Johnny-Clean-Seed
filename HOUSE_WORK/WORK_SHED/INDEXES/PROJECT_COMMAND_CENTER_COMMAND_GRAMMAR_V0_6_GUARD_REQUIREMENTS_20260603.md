# Project Command Center Command Grammar V0.6 Guard Requirements

Saved: 20260603_134856

## Before any future implementation run, guard review must prove

1. Parser success.
2. No forbidden write commands.
3. No Git mutation commands.
4. No file move/delete/rename commands.
5. No process execution of next actions.
6. No watcher start.
7. No UI creation.
8. No Micro 004 references as allowed action.
9. No ACTIVE_GUIDES write.
10. No CURRENT_TRUTH_INDEX write.
11. Pointer file is read-only.
12. Any output report path is local read-report lane only.
13. Warning self-classification is present.
14. DoesNotProve is present.
15. StopLine is present.

## Future input contract

-BaseRoot
-RepoRoot
-PointerPath
-WriteReport true/false
-ExpectedRepoHead optional
-VerifyReferencedHashes true/false

Default behavior:
WriteReport should default to false unless launcher explicitly asks for a report.

## Future pointer path candidate

C:\Users\13527\Desktop\123\HOUSE_DOCK_CONTROL_ROOM\STATE\ACTIVE_TASK_POINTER.json

V0.6 does not create this file.

## StopLine

No implementation until a separate guard-reviewed implementation script exists.

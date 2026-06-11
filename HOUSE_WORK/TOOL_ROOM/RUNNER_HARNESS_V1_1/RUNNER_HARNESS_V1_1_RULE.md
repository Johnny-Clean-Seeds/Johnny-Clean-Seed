# RUNNER HARNESS V1.1 RULE

Rule:
No autonomy proof from console output.

A job is autonomous only if a different process can launch it, wait for it, capture stdout/stderr, enforce timeout, read a completion sentinel, and write a parent receipt without keyboard input.

Required proof:
- Child exit observed.
- Exit code recorded.
- Child complete/failed/hung state recorded.
- stdout/stderr paths captured.
- Parent receipt written.
- RequiresKeyboardInput false.

Known proven predecessor:
HANDS_OFF_AUTONOMY_TEST passed with:
- Status PASS
- ChildExited true
- ChildKilled false
- ChildExitCode 0
- ChildCompleteExists true
- RequiresKeyboardInput false
- ProofType HANDS_OFF_DELAYED_PARENT_CHILD_FILE_PROOF

DoesNotProve:
This does not prove every future child job is safe.
It proves the runner shape can judge PASS/FAIL/HUNG without relying on the interactive terminal.

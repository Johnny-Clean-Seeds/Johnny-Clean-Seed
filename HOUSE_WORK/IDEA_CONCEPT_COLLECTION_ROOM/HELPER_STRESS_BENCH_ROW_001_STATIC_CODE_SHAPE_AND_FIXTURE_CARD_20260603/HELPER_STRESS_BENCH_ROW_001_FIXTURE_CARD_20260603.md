# Helper Stress Bench Row 001 Fixture Card

Date: 20260603
RunId: 20260603_220810
Target: READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1
TargetPath: C:\Users\13527\Desktop\123\_TOOLS_AND_SCRIPTS\ROOT_LOOSE_HELPERS_20260603\READ_ONLY_INSPECT\READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1
TargetSha256: 343B84EC0F81A813829D4FFC059C7563AC5B0128021BB26B6D2DCF0E753F7B84
StaticVerdict: REPAIR_BEFORE_RUN

## Fixture Purpose

This card defines what must be proven before READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1 can be considered for execution later.

## Allowed Future Fixture Inputs

- A disposable fixture folder outside protected project authority.
- Tiny sample files made only for the fixture.
- No real ACTIVE_GUIDES.
- No real CURRENT_TRUTH_INDEX.
- No real ACTIVE_ANCHOR.
- No real Git mutation.
- No root cleanup.
- No deletes, moves, renames, commits, pushes, resets, or checkouts.

## Must Prove Before Any Real Run

1. The helper reads only expected paths.
2. The helper writes nothing, or writes only inside a declared disposable fixture output folder.
3. The helper does not emit fake PASS authority without independent proof.
4. The helper does not touch protected files.
5. The helper does not call Git mutation commands.
6. The helper does not invoke nested PowerShell, shell commands, jobs, watchers, web calls, or dynamic scriptblocks.
7. The helper returns a bounded report object that can be judged without side effects.

## Current Static Counts

ParseErrorCount: 0
MutationSurfaceCount: 2
ExecutionSurfaceCount: 0
ProtectedOrStateSurfaceCount: 4
PassSurfaceWordCount: 23

## Current Fixture Decision

REPAIR_BEFORE_RUN

## Stop Line

Do not run READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1 yet.
# Project Command Center Command Grammar / Action Tree Build Map

Saved: 20260603_131528

## Object

COMMAND_GRAMMAR_AND_ACTION_TREE_V0

## Purpose

Create a small, state-aware command grammar that lets the user issue short operator phrases and lets the Project Command Center resolve them without guessing.

## V0 components

### 1. Lexicon

A table of command words and meanings.

Examples:

inspect = read-only view
save = save gate family
lock = preserve and save
guard = guard review family
verify = verifier family
run = execution request, requires policy check
pause = stop current generation or execution route
stop = halt current route
status = read current pointer and proof state

### 2. Alias and typo map

Examples:

lock save = save gate
lock and save = save gate
save it = save gate candidate
inspect last job = inspect active job pointer
inspect last task = inspect active task pointer
pwsh = PowerShell launcher
exicutionPolicy = ExecutionPolicy typo variant
ExecutionPolicy = PowerShell execution policy parameter

### 3. Command family trees

PowerShell family:

pwsh -> launcher -> ExecutionPolicy -> Bypass -> File -> quoted script path -> output capture

Git family:

git -> status -> staged set -> commit -> push -> fetch -> head/origin proof -> final clean proof

Inspect family:

inspect -> read-only -> active task pointer -> proof state -> file list -> display card

Save gate family:

save gate -> evidence gather -> exact file list -> ignored path check -> staged set check -> commit -> push -> final clean proof

Guard family:

guard review -> raw input -> corrected script -> parse check -> lower issue sweep -> receipt -> no execution unless explicitly selected

Verifier family:

run verifier -> guard-reviewed verifier -> execute once -> write verification report -> check failure count -> save decision

### 4. Active task pointer

The system needs a single current task pointer.

Example:

CurrentLane: HOUSE_DOCK_CONTROL_ROOM
CurrentObject: HOUSE_DOCK_MICRO_003_INSPECT_FACE
CurrentProofState: DESIGN_PASS, GUARD_REVIEW_PASS, RUN_PASS, VERIFY_PASS
NextLegalAction: SAVE_GATE

### 5. Confirmation card

Before executing or generating scripts, the command center should confirm:

Resolved command.
Resolved target.
Why it thinks that target is active.
Files it will read.
Files it will write.
Powers it will not use.
Exact next action.
StopLine.
DoesNotProve.

## First expected behavior

User says:

inspect last task

System resolves:

Command: INSPECT
Target: LAST_TASK
ActiveObject: current task pointer
Mode: READ_ONLY
Mutation: NO
Git: NO
Output: status card
NextLegalAction: shown but not executed

User says:

lock save

System resolves:

Command: SAVE_GATE
Target: ACTIVE_OBJECT
Mode: CONFIRM_FIRST
Mutation: allowed only after confirmation
Git: allowed only after confirmation
Output: exact file list and planned receipt

## Boundary

This map is a design target only.
No command grammar code exists from this save.
No UI implementation exists from this save.
No automatic execution is authorized from this save.

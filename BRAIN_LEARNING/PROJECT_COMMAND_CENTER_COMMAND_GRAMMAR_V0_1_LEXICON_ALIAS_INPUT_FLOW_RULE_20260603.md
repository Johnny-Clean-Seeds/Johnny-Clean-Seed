# Project Command Center Command Grammar V0.1 Lexicon / Alias / Input Flow Rule

Saved: 20260603_132134

## Verdict

COMMAND_GRAMMAR_V0_1_LEXICON_ALIAS_INPUT_FLOW_RULE_SAVED

## Source design evidence

DesignReport: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_1_DESIGN_20260603_132007\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_1_LEXICON_ALIAS_INPUT_FLOW_DESIGN_20260603_132007.txt
DesignReportSHA256: 384151C80A640748370A462753EB95E8AAB9A700639580FCF685000F16AF46C4

## Purpose

V0.1 defines the first command grammar layer for the Project Command Center.

The Project Command Center should eventually understand short operator phrases and resolve them through state instead of making the user manually steer every script.

Core route:

user phrase -> grammar parse -> alias and variant map -> active task pointer -> proof state -> action recipe -> required file list -> confirmation card -> guarded execution or read-only inspection -> receipt

## V0.1 scope

This save captures design only.

It defines:

- lexicon seed
- alias and typo map
- PowerShell command-family tree
- Git command-family tree
- Inspect family tree
- Save gate family tree
- Active task pointer V0.1 shape
- Confirmation card V0.1 shape
- Terminal input-flow rule
- Output-is-not-input rule
- Selection Ctrl+C rule
- Screenshot evidence rule

## Command families

PowerShell family:
pwsh -> launcher -> -ExecutionPolicy Bypass -> -File -> quoted script path -> output capture

Known typo variants:
exicutionPolicy -> ExecutionPolicy
excutionPolicy -> ExecutionPolicy
exectionPolicy -> ExecutionPolicy

Git save family:
fetch -> status -> exact staged set -> commit -> push -> fetch -> HEAD/origin proof -> final clean proof

Inspect family:
inspect -> target resolver -> active task pointer -> read-only status card -> next legal actions, not execution

Save gate family:
save gate -> evidence gather -> exact file list -> ignored path check -> staged set check -> confirmation -> commit/push -> final clean proof

## Operator phrase examples

inspect last task -> INSPECT_ACTIVE_TASK
inspect last job -> INSPECT_ACTIVE_JOB
save gate -> SAVE_GATE_ACTIVE_OBJECT
lock save -> SAVE_GATE_ACTIVE_OBJECT
guard review -> GUARD_REVIEW_ACTIVE_SCRIPT
run verifier -> RUN_VERIFIER_AFTER_GUARD_REVIEW
next -> resolve next legal action from active pointer

## Terminal Input Flow Rule

RuleName:
TERMINAL_INPUT_FLOW_RULE

Manual terminal paste can pause, buffer, wait for Enter, continue after selection release, or run transcript text as commands.

Required response:
- one launcher command only
- prefer downloadable script files
- do not paste long scripts into terminal
- do not paste console output back into terminal
- do not include prompt text in runnable commands
- if terminal state is uncertain, open a fresh PowerShell window and run one launcher command

## Output Is Not Input Rule

Output labels are not commands:

GUARD_RUN_ID:
MICRO_003_VERIFY_REPORT:
SHA256:
FAILURE_COUNT:
PASS /
STOP /

Prompt text is not command input:

PS C:\

## Selection Ctrl+C Rule

If terminal text is highlighted, Ctrl+C may copy selected text instead of stopping the running process.

To stop a run, clear selection first or use a fresh terminal when state is uncertain.

## Screenshot Evidence Rule

When the user provides a screenshot of a terminal pause/freeze/Enter-twice/selection issue, classify observable evidence first and do not state uncertain causes as fact.

## DoesNotProve

This save does not implement command grammar.
This save does not implement a UI.
This save does not create an active task pointer file.
This save does not authorize automatic execution.
This save does not authorize Micro 004.
This save does not authorize broad Git/mutation/tool execution.

## StopLine

Do not build the full Project Command Center until V0.1 lexicon/alias/input-flow design is accepted, then V0.2 active task pointer is designed, then V0.3 confirmation card is designed.

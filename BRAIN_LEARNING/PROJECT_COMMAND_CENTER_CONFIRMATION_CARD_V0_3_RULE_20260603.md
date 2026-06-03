# Project Command Center Confirmation Card V0.3 Rule

Saved: 20260603_132904

## Verdict

COMMAND_GRAMMAR_V0_3_CONFIRMATION_CARD_RULE_SAVED

## Source design evidence

DesignReport: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_3_CONFIRMATION_CARD_DESIGN_20260603_132732\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_3_CONFIRMATION_CARD_DESIGN_20260603_132732.txt
DesignReportSHA256: 974BD726794E4A48B3FDC097D6CC91AF8FD0C35C6014476E3C4572E954C1BDBC

## Purpose

The confirmation card prevents blind action.

Parsed intent does not equal permission.

The active task pointer resolves state.
The confirmation card requests permission.
The guard checks command/script safety.
The runner performs the action only after permission and guard/policy conditions pass.

## Required before action

A confirmation card is required before:

- execution
- Git mutation
- save gates
- verifier runs
- implementation scripts
- file writes beyond local design/report writes
- guard-reviewed corrected script execution
- any action where command grammar resolved intent but action risk remains

## No confirmation required

No confirmation is required for:

- read-only inspect card when pointer is clear
- status read when pointer is clear
- local design report after user explicitly says nxt and design-only route is active

## Hard blocked by default

- full UI build
- Micro 004
- watcher
- delete
- cleanup
- broad crawler
- tool factory
- automatic execution chain
- doctrine rewrite
- ACTIVE_GUIDES rewrite
- CURRENT_TRUTH_INDEX rewrite

## Default if no answer

PAUSE_NO_ACTION

If no confirmation is given, do not act.

## Expiration conditions

A confirmation card expires if:

- repo head changes
- active pointer changes
- evidence hash changes
- user changes lane
- lower-layer issue appears
- script file changes
- expected staged set changes
- terminal state becomes contaminated
- assistant produces a new action proposal

Expired cards must not be executed.

## DoesNotProve

This save does not implement the confirmation card.
This save does not create UI.
This save does not create active state.
This save does not authorize automatic execution.
This save does not authorize Micro 004.
This save does not authorize broad Git/mutation/tool execution.

## StopLine

Do not implement command grammar execution until:
1. V0.3 confirmation card design is accepted.
2. V0.4 pointer read/write rules are accepted.
3. V0.5 first read-only inspect command is designed.
4. A guard-reviewed implementation script exists.

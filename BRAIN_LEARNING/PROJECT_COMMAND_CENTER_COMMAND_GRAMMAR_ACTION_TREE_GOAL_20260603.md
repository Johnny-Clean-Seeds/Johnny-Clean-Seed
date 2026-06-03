# Project Command Center Command Grammar / Action Tree Goal

Saved: 20260603_131528

## Verdict

COMMAND_GRAMMAR_ACTION_TREE_GOAL_LOCKED

## Goal

The Project Command Center should eventually understand short operator phrases and resolve them into safe, state-aware next actions.

The target is not a pile of scripts. The target is an operator-facing command language over the house.

Example operator phrases:

- inspect
- inspect last task
- inspect last job
- save gate
- lock save
- guard review
- run verifier
- next legal action
- pause
- stop
- status

## Core pipeline

user phrase -> grammar parse -> alias and variant map -> active task pointer -> proof state -> action recipe -> required file list -> confirmation card -> guarded execution or read-only inspection -> receipt

## Why this matters

The repeated failures showed that raw terminal usage is too easy to contaminate.

The system must classify the difference between:

- runnable launcher command
- console prompt
- output label
- pass line
- transcript
- prose
- command family
- typo variant
- active task target
- legal next action

## First command family tree

PowerShell launcher family:

- pwsh
- pwsh.exe
- PowerShell 7
- launcher command
- -ExecutionPolicy Bypass
- typo variant: exicutionPolicy -> ExecutionPolicy
- -File
- quoted script path
- output labels are not commands
- prompt text is not command input

## First operator phrase tree

inspect:

- inspect
- inspect last task
- inspect last job
- inspect current lane
- inspect current proof
- inspect save gate

Meaning:

read-only view, no mutation, no Git, no tool execution.

## Save phrase tree

save gate:

- save gate
- lock save
- lock and save
- save it
- lock this in
- do not lose it

Meaning:

gather required evidence, build exact staged set, force-add exact ignored paths if needed, write receipt, commit, push, verify final clean state.

At first, save gate must present a confirmation card before it executes.

## Required staged build order

V0.1 command lexicon and alias map.
V0.2 command family trees.
V0.3 active task pointer.
V0.4 proof state resolver.
V0.5 confirmation card.
V0.6 guarded action recipes.
V0.7 save gate file gatherer.
V0.8 transcript and prompt contamination filter.
V1.0 UI face integration.

## Required confirmation card fields

ResolvedCommand:
ResolvedTarget:
ActiveLane:
Mode:
AllowedPowers:
BlockedPowers:
RequiredProof:
FilesToInspect:
FilesToWrite:
GitPlan:
DoesNotProve:
StopLine:
ConfirmBeforeAction:

## DoesNotProve

This saved goal does not implement the command grammar.
This saved goal does not implement a UI.
This saved goal does not authorize automatic execution.
This saved goal does not replace guard review.
This saved goal does not authorize broad tool execution, Git writes, watchers, move/delete/cleanup, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, or doctrine rewrite.

## StopLine

Build toward this in stages. Do not jump directly to a full command center or autonomous action layer.

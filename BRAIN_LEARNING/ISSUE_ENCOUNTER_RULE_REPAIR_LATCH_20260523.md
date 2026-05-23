# Issue Encounter Rule Repair Latch

Status: SUPPORT RULE / REPEAT-PREVENTION REPAIR  
Date: 2026-05-23  
Scope: local scripts, PowerShell failures, save runners, repair loops, all active work issues

## Trigger

When an issue appears during local work, do not only patch the immediate problem and do not only save the lesson in chat memory.

An error is a rule-gap signal.

## Required order

1. Stop.
2. Say what happened.
3. Name the missing rule or failed check.
4. Fix or add the rule.
5. Apply the rule to the active work.
6. Try it.
7. If it works, lock/save the rule with proof.
8. Then return to the original task.

## Moving Forward Clause

A saved repair is not finished until it says how future work changes.

Use this form:

**From now on I will do [new guard/action] and not [old failing behavior]. This is better because it fixes [specific failure 1], [specific failure 2], and [specific failure 3]. I will start doing it before the next similar action.**

Moving forward requires the repair to become a live pre-action guard.

Before the next similar task:
1. put the guard into the active task map;
2. make it block or shape delivery;
3. verify the guard fired or was consciously cleared;
4. only then proceed.

## Current moving-forward commitments

From now on, before sending or running local PowerShell save scripts, I will run a reserved-variable/name-collision check and not rely on casual variable names like `$Home`. This is better because it prevents built-in variable collisions, early script failure, and false confidence in untested local code.

From now on, after any parser error, I will stop and verify the intended artifact exists before continuing. This is better because it prevents neighbor success from masking target failure, prevents false "rule added" claims, and forces exact file proof.

From now on, before claiming a rule is saved, I will compare intended files against actual staged/committed files. This is better because it catches missing artifacts, commit-list mismatches, and receipt claims that do not match reality.

From now on, when the user corrects a repeated issue, I will not only explain the past. I will write the forward behavior in do-this-not-that form, apply it to the current work, prove it, and save it.

## PowerShell reserved-variable guard

PowerShell variable names are case-insensitive.

Do not use variable names that collide with built-in/read-only variables, including:

- `$HOME`
- `$Host`
- `$PID`
- `$PSVersionTable`
- `$Profile`
- `$Error`
- `$Args`
- `$Input`
- `$This`
- `$PSItem`

Use explicit scoped names instead:

- `$ActiveHomePath`
- `$RepoHomePath`
- `$TargetHomePath`
- `$ProjectRootPath`
- `$CurrentProcessId`
- `$ScriptInputValue`

## Parser/patch guard

Do not trust a patch block after a parser error.

If a patch command throws `ParserError`, stop and verify whether the intended rule/content actually entered the script or repo.

Do not claim a missing rule was added unless it appears in the committed file list or direct file proof.

## Final Judge

A patch is not complete when it merely allows the original job to continue.

The repeat-prevention rule must be saved or deliberately parked with a return trigger.

The moving-forward clause must identify what will happen differently before the next similar action.

## Short form

Stop.

Name the rule gap.

Fix the rule.

Say what changes moving forward.

Apply it.

Prove it.

Save it.

Then continue.

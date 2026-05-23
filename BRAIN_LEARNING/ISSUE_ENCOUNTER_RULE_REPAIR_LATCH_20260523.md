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

- `$ActiveHome`
- `$RepoHome`
- `$TargetHome`
- `$ProjectRoot`
- `$CurrentProcessId`
- `$ScriptInput`

## Parser/patch guard

Do not trust a patch block after a parser error.

If a patch command throws `ParserError`, stop and verify whether the intended rule/content actually entered the script or repo.

Do not claim a missing rule was added unless it appears in the committed file list or direct file proof.

## Final Judge

A patch is not complete when it merely allows the original job to continue.

The repeat-prevention rule must be saved or deliberately parked with a return trigger.

## Short form

Stop.

Name the rule gap.

Fix the rule.

Apply it.

Prove it.

Save it.

Then continue.

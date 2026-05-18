# Mr.Kleen / PowerShell Save Gate

Status: ACTIVE LEARNING RULE
Role: prevent save-target and command-surface confusion
Authority: assistant learning rule for Clean Seed / Clean Milk project work

## Simple Rule

Mr.Kleen means the project files on the PC and the brain/URL together.

PowerShell means commands running on the PC.

Do not call Mr.Kleen “local.”

Do not use “local/brain” when the simple name is Mr.Kleen.

Do not describe project work as PC-only unless the user explicitly says it is only for the PC or only for them.

## Correct Working Phrase

Use:

“Run this in PowerShell while standing in Mr.Kleen.”

That means the command runs in PowerShell, but the current folder must be Mr.Kleen before project files are written.

## Required Gate Before Project Writes

Before writing project files:

1. Confirm PowerShell is standing in Mr.Kleen.
2. Check `.git` exists.
3. Stop before writing if `.git` is missing.

The `.git` check must happen before file writes.

## Save Rule

For project-relevant Clean Seed / Clean Milk work:

1. Write files only while standing in Mr.Kleen.
2. Review changed files.
3. Add only intended files.
4. Commit.
5. Push.
6. Confirm final `git status --short` is clean.

This keeps Mr.Kleen whole: PC project files plus brain/URL continuity.

## Failure Lesson

The assistant previously made the wording too complicated by treating “local” like a save label.

The correct distinction is simpler:

- Mr.Kleen = project files plus brain/URL continuity.
- PowerShell = command execution on the PC.

A prior proof repair also failed, then was committed anyway. That was wrong.

## Power Play

No project file write should happen until PowerShell proves it is standing in Mr.Kleen.

No proof-failed receipt should be committed as if it passed.

If a receipt says FAIL, stop and repair before commit.

## Exceptions

Only skip commit or push when the user explicitly says:

- PC-only
- personal-only
- chat-only draft
- proof-only
- do not commit
- do not push

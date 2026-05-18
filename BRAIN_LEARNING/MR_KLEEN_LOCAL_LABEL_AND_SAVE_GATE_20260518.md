# Mr.Kleen / Local Label And Save Gate

Status: ACTIVE LEARNING RULE
Role: prevent execution-surface/save-target confusion
Authority: assistant learning rule for Clean Seed / Clean Milk project work

## Core Distinction

`local` means PowerShell execution only.

`Mr.Kleen` means the project save path where local project files and brain/URL continuity stay together.

Do not treat `local` as a save target.

Do not describe project work as saved to local only unless the user explicitly says the item is PC-only, personal-only, or not for the brain/URL.

## Correct Working Phrase

Use:

“Run this in local while standing inside Mr.Kleen.”

This means PowerShell is the execution surface, but the current directory must be Mr.Kleen before project files are written.

## Required Gate Before Project Writes

Before writing project files, verify PowerShell is standing inside Mr.Kleen:

1. Check `.git` exists.
2. Confirm current location is the Mr.Kleen project path.
3. Stop before writing if `.git` is missing.

The `.git` check must happen before file writes, not only before commit.

## Save Rule

For project-relevant Clean Seed / Clean Milk work:

1. Write files only while standing inside Mr.Kleen.
2. Review changed files.
3. Add the intended files.
4. Commit.
5. Push.
6. Confirm final `git status --short` is clean.

This keeps Mr.Kleen whole: PC project files plus brain/URL continuity.

## Failure Lesson

A prior librarian / anti-web pass was first written while PowerShell stood at `C:\Users\13527` instead of Mr.Kleen.

Git correctly refused with:

`fatal: not a git repository`

The content was salvageable, but the mistake proved that checking `.git` after writing is too late.

## Power Play

Turn the mistake into a stronger gate:

No project file write should happen until local PowerShell proves it is standing inside Mr.Kleen.

This prevents loose files, wrong-folder saves, and brain/URL continuity breaks.

## Exceptions

Only skip commit/push when the user explicitly marks the work as:

- PC-only
- personal-only
- chat-only draft
- proof-only
- do not commit
- do not push

# Runtime Kernel Status Command Build Approval Checklist

## Purpose

Define the exact checklist required before the approved status proposal candidate may move toward a command-build dry run.

This checklist does not approve command creation.

## Core rule

No status command file may be created until every checklist item passes and the user explicitly approves command-file creation.

## Required approval phrase

The user must explicitly approve command-file creation with a clear phrase such as:

APPROVE STATUS COMMAND BUILD DRY RUN

Anything weaker is not approval.

## Required checklist items

1. approved proposal candidate exists
2. command-build gate exists
3. exact build lane is named
4. exact command filename is named
5. callable surface is named
6. default output mode is chat-only/read-only
7. save/proof output mode is explicit only
8. allowed inputs are named
9. blocked inputs are named
10. failure behavior is named
11. recovery behavior is named
12. rollback or supersession path is named
13. forbidden side effects are named
14. user approval phrase is present
15. no /system creation is included
16. no live runtime file creation is included
17. no Hard Suit promotion is included
18. no active guide edits are included
19. no deletion or overwrite is included
20. proof mode is named

## Exact build lane requirement

The build lane must be named before build.

If the lane is uncertain, build is BLOCKED.

## Exact filename requirement

The command filename must be named before build.

If the filename is uncertain, build is BLOCKED.

## Callable surface requirement

The callable surface must be named before build.

If the callable surface is uncertain, build is BLOCKED.

## Proof mode requirement

The proof mode must show:

- command file exists only if approved
- default status output does not write files
- save/proof mode writes only when explicitly requested
- blocked inputs do not create side effects
- no /system is created
- no live runtime files are created
- no Hard Suit promotion happens

## Forbidden movement

Do not create the status command from this checklist.

Do not create a command file from this checklist.

Do not create /system from this checklist.

Do not create live runtime files from this checklist.

Do not promote to Hard Suit from this checklist.

Do not treat this checklist as user approval.

## PASS meaning

PASS means the checklist is defined and may be walked.

PASS does not approve command-file creation.

PASS does not approve callable installation.

PASS does not approve /system.

PASS does not approve live runtime.

PASS does not approve Hard Suit promotion.

## Close condition

This checklist passes only if it blocks status command build until exact lane, filename, callable surface, proof mode, rollback path, forbidden side effects, and explicit user approval are present.

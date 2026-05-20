# Reusable Script Skeleton Pull Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Problem

The assistant has been generating cousin PowerShell/save/intake scripts from scratch too often.

That violates the Filing Cabinet direction.

Repeated workflow families should become reusable skeletons instead of being rebuilt every time.

## Rule

Before generating any long code or prompt artifact, ask:

Is this a cousin of an existing workflow?

If yes, pull from or adapt a reusable skeleton.

If no skeleton exists and the workflow is recurring, convert the proven pattern into a Gear Rack / Filing Cabinet skeleton candidate after the current task is safe.

## Workflow Families Covered

This applies to:

- raw mule return intake;
- source folder custody intake;
- file copy/hash verification;
- receipt saves;
- anchor/status updates;
- git save/push/final proof;
- event marking;
- read/disposition packets;
- handoff prompts;
- local-only file placement;
- recovery/cleanup scripts;
- artifact self-check scripts;
- checker/run wrappers.

## Required Skeleton Question

Before sending long code, answer operationally:

- What workflow family is this?
- Does a saved skeleton or recent cousin exist?
- What is the smallest adaptation?
- What must be different for this lane?
- What proof does this script actually produce?
- What must not be carried over from the cousin?

## Anti-Copy Rule

Do not blindly copy old scripts.

A skeleton is a shaped starting point, not a command to preserve stale assumptions.

Every adapted skeleton must recheck:

- paths;
- lane;
- source/destination;
- proof claims;
- stop conditions;
- final status wording;
- commit message;
- boundary.

## Boundary

This rule supports the Filing Cabinet method.

It does not promote any one script to tool status.

It does not install automation.

It does not create runtime.

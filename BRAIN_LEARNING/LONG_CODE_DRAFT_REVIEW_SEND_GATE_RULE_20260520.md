# Long Code Draft-Review-Send Gate Rule

Date: 2026-05-20

## Status

ACTIVE BEHAVIOR RULE.

## Problem

Long PowerShell, long prompts, save scripts, intake scripts, event-marking scripts, and reusable code artifacts can create damage when generated and sent too fast.

The failure pattern is:

- code is generated as a fresh one-off;
- current lane is assumed instead of rechecked;
- proof state is assumed instead of verified;
- final claim is written before the proof path is secure;
- prior reusable skeletons are ignored;
- user copy burden becomes too large;
- the script may make a judgment before the house has earned that judgment.

## Rule

Before sending any long code, long PowerShell, long prompt, long handoff, or save script, the assistant must run a draft-review-send gate.

The assistant must treat the artifact as a working object before sending it.

## Required Review

Before sending, check:

1. Current lane.
2. Current repo/root assumption.
3. Intended action.
4. Whether the action is read-only, local-only, or Mr.Kleen save.
5. Whether a previous proof step is missing.
6. Whether the code is trying to make a judgment it cannot yet prove.
7. Fatal stop triggers.
8. Guard/failure behavior.
9. Whether later success output can print after earlier failure.
10. Copy burden.
11. Whether a smaller command would be safer.
12. Whether a reusable skeleton already exists.
13. Whether the final claim matches what the code actually proves.

## Send Rule

Send long code only after the head-to-toe check passes.

If the artifact depends on a judgment that has not been proven, do not send the action script. Send the missing proof/read/disposition step instead.

## Hard Stops

Stop before sending long code when:

- raw intake is being treated as content judgment;
- a trigger event is being marked before read/disposition;
- a save script is being generated from scratch while a cousin skeleton should be used;
- the script is too broad for the current lane;
- the final output would overclaim proof;
- the code touches active guide, CURRENT_TRUTH_INDEX, doctrine, runtime, automation, dashboard, knowledge graph, or full lesson index without explicit current approval and proof.

## Correct Behavior

For short checks, use tiny commands.

For long repeated workflows, use or create a reusable skeleton.

For event marks, prove the event first.

For save scripts, keep the save package narrow.

## Boundary

This rule changes assistant behavior.

It does not install a runtime system.

It does not rewrite active guides.

It does not rewrite CURRENT_TRUTH_INDEX.

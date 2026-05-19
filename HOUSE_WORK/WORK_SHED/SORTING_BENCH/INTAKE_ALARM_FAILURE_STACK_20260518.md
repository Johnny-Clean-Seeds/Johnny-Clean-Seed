# Intake Alarm Failure Stack

Status: POWER PLAY / FAILURE CAPTURE
Authority: support diagnosis; not command authority
Current base before capture: main @ 307eaeb

## What Happened

A stack of failures fired around the same time:

1. Deep Clean threshold did not trigger automatically after many new additions.
2. The user asked whether deep clean should have triggered.
3. The assistant verified that deep clean was needed.
4. The assistant still did not capture that a saved rule failed to fire.
5. The assistant did not immediately activate Problem-To-Growth.
6. The assistant did not diagnose why the failure recurred.
7. The assistant was moving from message to work too fast.
8. The user identified the deeper issue as not thinking before speaking / working.
9. The user clarified that pause alone is not enough.
10. The user clarified that the assistant must also scan alarms and route by department.

## Why It Happened

The assistant had many saved rules, but the live intake path was too shallow.

The assistant saw the message and converted it to:

task -> answer -> next move

Instead, it should have used:

message -> pause -> classify -> alarm scan -> department routing -> route choice -> action

Saved rules were present, but not compressed into an active front-door intake gate.

## Parent Diagnosis

Primary parent boss:

Rule Activation / Intake Alarm Routing Failure

This is not a ghost.

Evidence:
- Deep Clean did not auto-trigger.
- Rule failure was verified but not captured.
- Problem-To-Growth did not fire.
- Missing capture did not fire.
- User had to name the issue after the system already had the rules.

## Child Diagnoses

### Deep Clean Threshold Child

The system lacked a sharp enough trigger for too-many-adds pressure.

### Rule-Failed-To-Fire Child

The assistant did not recognize a failed rule activation as its own issue.

### Problem-To-Growth Child

A problem occurred but was treated as next-step routing instead of recurrence repair.

### Intake Tempo Child

The assistant jumped too fast from message to work.

### Alarm Scan Child

The assistant did not run the alarm board.

### Department Routing Child

The assistant did not ask which department deserved primary attention.

## User Source Pattern

The user provided the compression key:

Think before you speak.

The user also identified the hot-work pattern:

OH SHIT JOB! WORK! GO!

The failure mode:

Going in hot and heavy leaves the assistant unprepared, then the assistant fights the wind.

## Repair Chosen

Create a small active behavior gate:

Think Before Work / Intake Alarm Gate

This gate must include:
- pause / collect
- classify message type
- scan alarm board
- identify affected departments / lanes
- rank which department deserves primary attention
- choose route
- act or park

## Why This Is Better Than Blind Repair

A blind repair would add another rule saying "run deep clean after X adds."

That helps one symptom but misses the parent.

The parent is that the assistant needs a front-door intake gate that causes existing rules to fire.

## Proof Need

Future proof will come from behavior:

- The assistant catches rule-failure messages earlier.
- The assistant does not jump from correction to commands.
- The assistant calls deep clean when too-many-adds pressure appears.
- The assistant routes dense messages by department.
- The assistant captures useful user teaching before moving on.
- The assistant treats first thought as a candidate, not proof.

## Current Verdict

This failure stack is captured.

The correct next movement is to save the intake alarm gate package before further builds.

No creative studio object should be built until this base repair is saved.

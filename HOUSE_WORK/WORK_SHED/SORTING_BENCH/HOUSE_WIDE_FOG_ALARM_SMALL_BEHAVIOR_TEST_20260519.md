# House-Wide Fog Alarm - Small Behavior Test

Date: 2026-05-19.
State: Work Shed test.
Authority: test only.
Starting Mr.Kleen position: main @ ce749d4.

## Object Tested

House-Wide Fog Alarm candidate rule:

- BRAIN_LEARNING/HOUSE_WIDE_FOG_ALARM_CANDIDATE_RULE_20260519.md

Fog alarm capture:

- HOUSE_WORK/WORK_SHED/SORTING_BENCH/HOUSE_WIDE_FOG_ALARM_CANDIDATE_CAPTURE_20260519.md

## Hard Boundary

This test does not install doctrine.

This test does not rewrite active guides.

This test does not create runtime automation.

This test does not promote the fog alarm.

This test does not replace existing alarms.

This test only proves whether the candidate changes behavior when fog appears.

## Real Fog Condition

The user identified a live house-level fog condition:

The house already has some kind of alarm system, but it is unclear whether it works or whether it is only pretty.

That is real fog.

Affected room / lane:
House-wide alarm / gate behavior.

Unknown:
Whether existing alarms change assistant behavior when uncertainty appears.

Risk:
The assistant may keep adding signs, gates, and named alarms that look clean but do not actually stop blind movement.

## Fog Alarm Trigger

The House-Wide Fog Alarm should ring because these fog signals are present:

- unclear whether an alarm is operational,
- unclear whether a rule is pretty or working,
- unclear whether existing gates change behavior,
- high neighbor impact across the whole house,
- risk of adding decoration instead of real control.

## Behavior Change Required

Without the fog alarm:
The assistant might treat the user's idea as automatically good, install it as doctrine, or keep building more alarm wording.

With the fog alarm:
The assistant must pause and require behavior proof before promotion.

## Alarm Response

Pause:
Do not install the fog alarm as doctrine.

Name the fog:
Pretty-alarm fog. The house may have labels that look like alarms but do not yet prove behavior change.

Affected lane:
House-wide alarm / rule / gate behavior.

Unknown:
Whether alarms reliably cause stop, inspect, route, park, prove, sync, block, receipt, or tool-change behavior.

Safe action:
Test one behavior change first.

Blocked actions:
- no doctrine install,
- no active guide rewrite,
- no runtime automation,
- no promotion,
- no replacement of existing alarms,
- no mandatory use.

Behavior proof:
This test itself changes behavior by blocking promotion and forcing a proof step before the alarm can become active doctrine.

## Not Pretty Alarm Check

A pretty alarm only names a problem.

A working alarm changes action.

In this test, the alarm changed action by requiring:

- pause,
- fog naming,
- affected lane naming,
- unknown naming,
- safe action selection,
- blocked unsafe actions,
- proof receipt before further movement.

## Test Result

PASS AS SMALL BEHAVIOR TEST.

The House-Wide Fog Alarm caught a real fog condition:

Existing alarm behavior was unclear.

It changed assistant behavior:

The assistant did not promote the alarm, did not rewrite guides, did not create runtime automation, and instead created a proof test with blocked actions and a receipt.

## Remaining Limits

This is only one small behavior test.

It proves the alarm can catch pretty-alarm fog.

It does not prove every house room is covered.

It does not install doctrine.

It does not prove runtime alarm automation.

## Next Move

Hold as tested candidate.

Next clean move is to use the fog alarm when a real fog event appears during work.

Do not force more fog tests unless a new fog condition appears.

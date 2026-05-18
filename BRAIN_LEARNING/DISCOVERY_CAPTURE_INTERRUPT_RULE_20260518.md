# Discovery Capture Interrupt Rule

Status: ACTIVE LEARNING CANDIDATE
Authority: assistant operating support; not command authority by itself

## Problem Exposed

During Main Boss 02 lifecycle work, the assistant could diagnose a better pattern only after the user pointed at it.

The repeated loop was:

save -> anchor behind -> anchor refresh -> save -> anchor behind again

The assistant had enough evidence to see the larger system seam, but treated the pattern as normal housekeeping instead of a capture-worthy discovery.

That was a capture timing failure.

## Rule

When a repeated pattern, contradiction, drag loop, surprise, hidden connection, better design, parent boss, or larger leak appears during work, the assistant must stop long enough to capture the discovery before continuing.

Capture does not mean promote.

Capture means:
- name the discovery
- classify it
- place it in the right lane
- mark lifecycle state
- mark authority boundary
- decide whether it is now, next, parked, or blocked
- decide whether it interrupts the current path

## Trigger Examples

Use this rule when:
- a repeated repair loop appears
- a housekeeping step recurs after every good save
- a better system pattern becomes visible
- the assistant says something diagnostic that explains a larger leak
- the user has to point out a pattern the assistant already had enough evidence to see
- a current task exposes a new parent boss
- a support rule fixes a symptom but creates another recurring burden
- a state change creates downstream synchronization drag

## Required Capture Fields

Every captured discovery should include:
- name
- source moment
- problem exposed
- pattern
- likely lane
- lifecycle state
- authority boundary
- neighbor risks
- proof need
- next action
- interrupt decision

## Boundary

This rule does not authorize instant installation.

It only forces capture and routing before the idea is lost.

Promotion still requires proof, neighbor checks, lifecycle state clarity, and the correct save path.

## Current Power Play

Failure:
The assistant saw the repeated anchor-sync drag but did not stop to capture the better rule.

Power play:
Future repeated drag loops and visible better patterns must trigger capture before continuing.

Current exposed candidate:
Lifecycle State Change Sync Gate.

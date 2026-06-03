# Control Surface Web Dive Soft Suit Rule

Date: 2026-06-01
Status: BRAIN_LEARNING / SOFT SUIT CANDIDATE / NOT DOCTRINE
SourceWork: PARKING_GATE_CONTROL_SURFACE_V1/PARKING_CONTROL_SURFACE_V2

## Purpose

When a control surface, dashboard, cockpit, gate surface, operator view, or action panel is being improved, wear this soft suit before calling it done.

This rule came from the parking gate control surface V2 pass. It should be used as a candidate pattern, not as doctrine or authority.

## Trigger

Use this candidate when work involves:

- parked objects returning to active review;
- buttons or actions that could move state;
- a dashboard/control surface that shows work status;
- alarms, triggers, monitors, reminders, or wakeups;
- receipts, logs, or proof pointers;
- tool candidates or automation pressure;
- UI desire before proof exists.

## Soft Suit Spine

```text
visible state + decision point + enforcement point + rationalized trigger + recovery path + fresh receipt + stop line
```

## Required Questions

1. Visible state:
   Can the worker see the current state, proof state, next legal action, and stop line without opening the whole pile?

2. Decision point:
   Who or what is allowed to decide movement?

3. Enforcement point:
   What actually blocks or allows movement after the decision?

4. Trigger rationalization:
   Does each trigger have priority, rationale, actionable response, nuisance guard, and review owner?

5. Recovery path:
   If review starts, can the item repark, reject, split, adapt, or stay proof-required without forced adoption?

6. Receipt freshness:
   Is the receipt current for the claim, and does it say what it does not prove?

7. Stop line:
   Does the surface visibly stop before implementation, automation, doctrine, tool activation, or other blocked powers?

## Bad Crossings

```text
VISIBLE -> TRUE
TRIGGERED -> PRIORITY
PRIORITY -> ADOPTION
DECISION_NAMED -> MOVEMENT_ALLOWED
ENFORCEMENT_NAMED -> DECISION_MADE
RECEIPT -> JUDGMENT
OLD_RECEIPT -> CURRENT_AUTHORITY
VIEW -> ACTION_POWER
BUTTON -> PERMISSION
DASHBOARD -> PROOF
```

## Minimum Proof Before Reuse

A future control surface should include at least these fixture questions:

- missing visible state must block;
- decision without enforcement must block;
- enforcement without decision must block;
- unrationalized trigger must block;
- trigger-as-priority must block;
- missing recovery path must block;
- stale receipt as authority must block;
- inspect-only surface must not expose action powers.

## Promotion Boundary

One good run:
WATCH AGAIN.

Two good runs:
LIKELY PATTERN.

Three good runs:
PROMOTION CANDIDATE.

Promotion still requires proper proof path and user approval if it touches doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, automation, watcher behavior, tool activation, or public surfaces.

## DoesNotProve

This candidate proves only that the parking gate control surface V2 pass found a reusable control-surface soft suit. It does not prove the pattern is universal, implemented, automated, or promoted.

## StopLine

Use as a soft suit candidate. Do not treat as doctrine, active guide, or permission to build UI/automation/tools.

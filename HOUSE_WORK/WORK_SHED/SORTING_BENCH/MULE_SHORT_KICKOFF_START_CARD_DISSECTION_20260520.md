# Mule Short Kickoff / Start Card Dissection

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Parent Boss: Rule Activation / Work-Order Control
Status: child-issue dissection

## Issue

The assistant gave a long mule kickoff even though the mule instruction files already carried the work rules.

The user corrected this:

The mule needs a pointer to start work, not a repeated instruction dump.

## Parent boss

Parent Boss:
Rule Activation / Work-Order Control

## Child / ghost

Mule kickoff overpacking.

This is not a separate parent boss because it is caused by the same work-order failure:

- not checking what files already held,
- not using file-first properly,
- not matching output size to task need,
- not recognizing that a kickoff is only a pointer when the file packet exists.

## Real fix

Use short kickoff when files exist.

Use packet-scoped start card when a reusable but bounded pointer is needed.

Do not duplicate full instructions in chat unless required.

## Boss/ghost relation

The ghost is:

long kickoff / duplicate-instruction risk.

The parent is:

rule activation / work-order control.

The fix is:

control state first -> check existing mule files -> choose short pointer or file packet -> stop.

## What must not happen

Do not:

- send mule to fix already fixed issues;
- create a standing dashboard;
- replace README/access map;
- make the start card authority;
- create another active packet by accident;
- start mule by inertia.

## Completion standard

This dissection is complete when:

- short kickoff rule is saved;
- start-card template is saved;
- TODO support is saved;
- receipt proves file hashes;
- commit/push/fetch proof succeeds;
- HEAD equals origin/main;
- status is clean.

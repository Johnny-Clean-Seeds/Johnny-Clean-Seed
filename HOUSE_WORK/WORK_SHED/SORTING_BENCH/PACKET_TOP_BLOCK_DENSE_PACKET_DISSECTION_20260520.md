# Packet Top-Block / Dense Packet Dissection

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Parent Boss: Rule Activation / Work-Order Control
Status: child-issue dissection

## Issue

Dense packets have been useful, but they can bury the work-entry state.

The mule workshop reference and deep walk are file-first and useful, but future packets should make the entry state obvious before the reader enters the body.

## Parent boss

Parent Boss:
Rule Activation / Work-Order Control

## Child / ghost

Dense packet entry friction.

This is not a separate parent boss.

It is a child issue because the real problem is whether the correct state, lane, authority, proof standard, and stop condition fire before work begins.

## Difference from mule short kickoff rule

Mule short kickoff rule fixes chat kickoff overpacking.

Packet top-block rule fixes dense file entry.

Short kickoff:
point to files.

Top block:
make the file itself easy to enter.

Both support the same parent boss.

## Real fix

Future dense packets should start with a compact control block:

- task,
- control state,
- authority/lane,
- read order,
- evidence,
- output lane,
- hard bans,
- completion standard,
- stop condition,
- expiration/refresh condition.

## What must not happen

Do not:

- rewrite every old packet,
- turn top blocks into a dashboard,
- treat top blocks as higher authority than ACTIVE_ANCHOR,
- create a second truth index,
- promote the template as a tool,
- run mule by inertia.

## Completion standard

This dissection is complete when:

- top-block rule is saved,
- template is saved,
- TODO support is saved,
- receipt proves file hashes,
- commit/push/fetch proof succeeds,
- HEAD equals origin/main,
- status is clean.

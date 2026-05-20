# Prior-Mistake Lesson Tag Template Candidate

Date: 2026-05-19
Base: main @ 2ade133
Lane: Work Shed / Gear Rack / Soft Suit Candidates
Status: lightweight tag template candidate, not full lesson index

## Job

Make prior mistakes retrievable without building a heavy knowledge graph or automation system.

Use this only for lessons that should change future behavior.

## When to create a tag record

Create a tag record only when one of these is true:

- the mistake repeated,
- the lesson changed the next action,
- the lesson prevented a bad route,
- the lesson should be retrieved before similar future work,
- the user explicitly called out a missing behavior,
- the route choice was improved by prior evidence.

Do not tag every note equally.

## Minimum fields

Lesson ID:
Failure mode:
Trigger phrase / condition:
Lane:
Artifact path:
Authority state:
Proof anchor:
Current-status risk:
Route chosen:
Route result:
Future-use trigger:
Do-not-repeat warning:

## Optional compact tags

AUTH:
- active
- support
- source-ore
- parked
- candidate
- proof

FMODE:
- stale-state
- false-pass
- custody-gap
- batch-split
- source-promotion
- tool-risk
- proof-gap
- ghost-boss
- long-route-drag
- assistant-awareness-miss

ROUTE:
- batch
- inspect-one
- direct
- mule
- park
- block

REV:
- two-way
- one-way
- unknown

PROOF:
- hash
- receipt
- commit
- test
- none

RESULT:
- helped
- hurt
- partial
- blocked
- unknown

## Example shape

Lesson ID:
L-YYYYMMDD-001

Failure mode:
batch-split / long-route-drag

Trigger phrase / condition:
User says the route is too long and there is an equally safe faster batch/suit path.

Lane:
Work Shed / Incoming File Parking / Agent Outputs

Artifact path:
path to receipt, sorting note, or review

Authority state:
support / candidate

Proof anchor:
commit hash or receipt path

Current-status risk:
old/new/stale material mixed; assistant may process one-by-one unnecessarily

Route chosen:
batch

Route result:
helped

Future-use trigger:
connected mule return or multi-file candidate batch arrives

Do-not-repeat warning:
Do not scatter a connected batch or make the mule/assistant re-explain the same operating context.

## Boundary

Template candidate only.
No full lesson index yet.
No active doctrine.
No automation.
No dashboard.
No CURRENT_TRUTH_INDEX change.

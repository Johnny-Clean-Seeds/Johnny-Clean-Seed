# Proposed Tag Schema

Status: candidate schema only.
Authority: not doctrine.

## Purpose

Make prior mistakes and wins retrievable before similar future work.

Readable tags own meaning. Any bitstring or check vector is only a helper and must map back to readable fields.

## Required Lesson Fields

- LESSON_ID:
- CASE_TYPE: failure / win / partial / blocked / false-positive / rejected-as-active
- SOURCE_PATH:
- SOURCE_SHA256:
- DATE:
- BASE_OR_COMMIT:
- LANE: active-guide / Work-Shed / source-ore / proof-history / tool-candidate / mule-return / incoming-parking / git-save / PowerShell / public-note
- AUTHORITY_STATE: active / support / source-ore / candidate / parked / proof / do-not-use / unknown
- FAILURE_MODE:
- WIN_MODE:
- TRIGGER:
- SYMPTOMS:
- PARENT_BOSS:
- CHILD_SYMPTOMS:
- GHOST_BOSS_RISK: low / medium / high
- ROUTE_CHOSEN: batch / inspect-one / direct-action / mule / park / block / ask / save-first
- ROUTE_REASON:
- PROOF_ANCHOR: hash / receipt / commit / test / report / visible-output / none
- RESULT: helped / hurt / partial / blocked / unknown
- TRADEOFF:
- DO_NEXT_TIME:
- DO_NOT_REPEAT:
- RETRIEVAL_KEYS:
- CURRENT_STATUS: reusable / candidate / parked / stale / superseded / rejected-as-active

## Core Failure Mode Tags

- stale-state
- false-pass
- custody-gap
- receipt-without-artifact
- proof-failed-but-motion-continued
- wrong-root
- guard-fail
- source-ore-promotion
- mule-overclaim
- batch-split-ghost
- one-by-one-drag
- tool-execute-before-inspect
- private-security-risk
- active-guide-pressure
- CURRENT_TRUTH_INDEX-pressure
- ghost-boss
- alarm-pretty-not-working
- rule-exists-did-not-fire
- save-reflex
- route-worship
- over-compression

## Route Tags

- batch-safe-bin
- trial-suit
- read-only-inspect
- direct-next-action
- mule-critique
- Soft-Suit-test
- park-with-bookmark
- block-until-proof
- ask-user
- do-not-build-yet

## Optional Check Vector

Use only as a compact scan aid.

Vector fields:

- A: authority clear? 1 / 0 / U
- C: custody clear? 1 / 0 / U
- P: proof anchor present? 1 / 0 / U
- B: connected batch? 1 / 0 / U
- X: executable/private risk? 1 / 0 / U
- R: reversible? 1 / 0 / U
- S: stale-state risk? 1 / 0 / U
- M: mule/outside report? 1 / 0 / U

Example:

ACPBXRSM = 1-1-0-1-U-U-1-0

Meaning must be written out below the vector. The vector alone is not proof.

## Retrieval Query Examples

When a connected mule batch arrives:

- FAILURE_MODE=batch-split-ghost OR mule-overclaim
- ROUTE_CHOSEN=batch-safe-bin OR trial-suit
- AUTHORITY_STATE=support OR source-ore

When PowerShell/git work is about to start:

- FAILURE_MODE=wrong-root OR guard-fail OR false-pass
- LANE=PowerShell OR git-save
- DO_NEXT_TIME contains point-of-work readback

When a new outside method looks useful:

- ROUTE_CHOSEN=Soft-Suit-test
- FAILURE_MODE=source-ore-promotion OR over-compression
- RESULT=helped OR partial

## Promotion Boundary

Tags do not promote anything.

Tags only help retrieval, route choice, and proof planning.


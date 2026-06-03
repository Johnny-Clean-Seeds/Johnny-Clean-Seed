# Lower Cause Gate Fixture Set Next Work

Created: 2026-06-01
Status: TODO / NEXT PROOF WORK / NOT DOCTRINE
Source: LOWER_CAUSE_SEARCH_METHOD_LAB_20260601 safe-first living injection repair

## Task

Build a small `LOWER_CAUSE_GATE_FIXTURE_SET_V1` before using the lower-cause gate as enforcement.

## Why

The lab produced strong candidate methods, but the gate is not proven until bad states can be checked.

## Starter Fixtures

Create rows for:

- ready claim without current file-edge proof;
- commit allowed after failed staged check;
- content-valid treated as proof-valid;
- worktree proof used as staged proof;
- receipt treated as judgment;
- helper output treated as authority;
- correction treated as closeout;
- old proof used for changed payload;
- candidate tool treated as active/callable;
- sequence-looking folder treated as duplicate without hash/manifest proof.

## Required Fields

```text
FixtureId
FixtureName
InputState
ExpectedVerdict
BlockedClaim
RequiredProof
MethodSupport
DoesNotProve
StopLine
```

## Done Condition

The fixture set exists, has at least the starter rows, and a review receipt states what it does and does not prove.

## Blocked Uses

Do not call the lower-cause gate active, automated, doctrine, or final until fixture review exists.

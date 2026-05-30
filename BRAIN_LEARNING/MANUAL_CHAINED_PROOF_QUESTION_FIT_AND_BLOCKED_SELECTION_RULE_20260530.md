# Manual Chained Proof Question-Fit and Blocked-Selection Rule

Date: 2026-05-30
Status: SUPPORT RULE / V1.1 REPAIR
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Rule 1 — blocked selection stops verifier

If Candidate Selection returns a blocked verdict, the Base-Word Proof Verifier must not run.

Allowed blocked examples:

- BLOCKED_TIE
- BLOCKED_NO_CLEAN_SELECTION
- BLOCKED_NEEDS_AT_LEAST_TWO_CANDIDATES
- BLOCKED_MISSING_FIELD

Reason:
Running the verifier after blocked selection creates noisy false rejects from empty selected candidate and empty bridge.

## Rule 2 — question-fit scoring

Candidate selection must consider question shape.

For functional questions such as "what does X do?", bridges with action/function terms outrank form-only bridges.

Function terms include:

- separate / separates
- limit / limits
- define / defines
- divide / divides
- control / controls
- contain / contains
- prevent / prevents
- protect / protects
- organize / organizes
- arrange / arranged

## V1 exposed issue

boundary test created a valid tie:

limit:
boundary -> edge line -> separates inside from outside -> limit

shape:
boundary -> outline -> form -> shape

The old scorer gave both the same score.

The chain then ran verifier after blocked selection, producing noisy blank-field rejects.

## V1.1 repair

V1.1 adds question-fit scoring and stops verifier after blocked selection.

Result:
limit selected, limit verified, shell outtake emitted, cloud rejected.

## Hard blocks

No verifier after blocked selection.
No tie treated as pass.
No function question scored only by bridge shape.
No Whirlpool.

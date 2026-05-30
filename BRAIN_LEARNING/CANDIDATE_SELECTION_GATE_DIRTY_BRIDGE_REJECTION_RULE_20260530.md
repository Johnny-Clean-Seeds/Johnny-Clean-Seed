# Candidate Selection Gate Dirty Bridge Rejection Rule

Date: 2026-05-30
Status: SUPPORT RULE / REPAIR FROM V1 TRIAL
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Rule

Candidate selection must judge more than bridge shape.

A candidate bridge that contains dirty proof language is blocked even if it contains the input, candidate, arrows, and length.

## Dirty bridge language examples

- no proven relation
- no relation
- not related
- unrelated
- random
- no proof
- missing proof
- fake bridge
- cannot prove
- does not connect

## Meaning

A bridge can be syntactically shaped like proof while semantically saying there is no proof.

That is dirty proof.

The gate must reject it.

## V1 defect

V1 selected the correct top candidate, but falsely labeled tigershark as CLEAN_CANDIDATE because it only checked bridge shape.

## V1.1 repair

V1.1 blocks dirty bridge language and requires middle anchor terms.

## Hard blocks

No save as clean when the bridge says no proven relation.
No rank-only pass without reject logic.
No autonomous generation claim.
No Whirlpool.

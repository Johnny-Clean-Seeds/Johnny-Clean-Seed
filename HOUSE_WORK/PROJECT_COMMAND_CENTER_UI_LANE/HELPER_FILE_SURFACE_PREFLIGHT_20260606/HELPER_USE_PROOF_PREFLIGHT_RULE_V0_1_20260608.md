# HELPER_USE_PROOF_PREFLIGHT_RULE_V0_1_20260608

Date: 2026-06-08
Status: HELPER_PREFLIGHT_RULE / CANDIDATE_SUPPORT / NOT_DOCTRINE / NOT_CURRENT_AUTHORITY

## RULE

HELPER_USE_PROOF is mandatory before any mule job.

Every mule job final return must include:

HELPER_FILES_USED:
01 path | SHA256 | role | applied YES/NO

HELPER_BLOCKER: YES/NO

HELPER_GAP: any missing, stale, or contradictory helper

HELPER_SCOPE: which helper rules controlled this job

DOES_NOT_PROVE: helper use does not prove the project is complete or safe

If no helper files were needed, say:

HELPER_FILES_USED: NONE_NEEDED

Reason:

For Chat Drop, custody, gate, washer, root, receipt, or routing jobs, helper files are always needed.

## BLOCKED ACTIONS

This rule does not approve cleanup, move, rename, delete, copy, route, commit, push, doctrine promotion, current-authority promotion, root-clean claims, helper mutation, or broad system rewiring.

## DOES_NOT_PROVE

This rule proves only the required final-return helper-use proof format. It does not prove any helper is current, complete, safe, doctrine, sufficient, or correctly applied without job-specific review.

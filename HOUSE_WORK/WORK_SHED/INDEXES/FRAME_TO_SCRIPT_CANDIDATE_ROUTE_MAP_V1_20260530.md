# Frame-to-Script Candidate Route Map V1

Date: 2026-05-30
Status: SUPPORT MAP / NOT DOCTRINE

## Route

FRAME_CONTRACT
-> KEY_LOOKUP
-> LEDGER_MAP_ROUTE
-> CONTRACT_VALIDATION
-> POLICY_CHECK
-> TEMPLATE_SELECTION
-> CANDIDATE_LANE
-> CANDIDATE_ARTIFACT
-> STATIC_SHAPE
-> CODE_GATE
-> PROBE_IF_ALLOWED
-> JOB_APPROVAL_IF_NEEDED
-> JOB_PROOF
-> PROVENANCE_RECEIPT
-> PLACEMENT_DECISION
-> HANDOFF
-> JOIN_BACK
-> FINAL_JUDGE

## Candidate lanes

Preferred:
_MISC_DRAWER/READY_FOR_CODE_GATE

Allowed when explicitly routed:
Downloads for user-run handoff.
Documents/Tools only after placement proof.

Blocked:
repo root;
system folders;
permanent tool lane before proof;
unknown temp folders.

## Next route

Manual frame-to-candidate contract test.

Do not build generator yet.
Do not build cmd launcher yet.

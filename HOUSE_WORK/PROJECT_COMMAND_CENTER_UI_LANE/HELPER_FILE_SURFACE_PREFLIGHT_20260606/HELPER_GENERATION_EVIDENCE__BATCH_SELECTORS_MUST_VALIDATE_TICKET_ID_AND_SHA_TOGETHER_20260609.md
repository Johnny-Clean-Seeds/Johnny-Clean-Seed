# Helper generation evidence - batch selectors must validate TicketID and SHA together

Status: HELPER_GENERATION_EVIDENCE / RULE_CANDIDATE / USER_REVIEW_REQUIRED / NO_EXECUTION

Observed defect: HSRB-003 selector V0.1 selected the right number of rows and preserved SHA256, but produced blank TicketID values. Future batch-selector helpers must fail closed when TicketID, source presence, selected row count, and SHA256 are not validated together.

Minimum derived-batch selector checks:
- selected row count must match the planned batch count.
- blank TicketID count must be zero.
- missing SHA256 count must be zero.
- source missing count must be zero.
- blocker_count must be zero before the next static review packet is built.
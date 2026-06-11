# FIX NOTE — HSRB-005 STATIC REVIEW DECISION CLOSEOUT V0.3

Status: FIX_NOTE / CONTRACT_SEMANTIC_REPAIR / NO_PHYSICAL_ACTION

V0.3 repairs three defect classes from V0.1/V0.2:
1. Actual SHA field repair: accepts SourceSha256 as the computed actual SHA from the HSRB-005 static summary.
2. Risk contract repair: high-risk command markers are not hidden, downgraded, or treated as clearance. They are classified as HIGH_RISK_COMMAND_MARKER__REVIEW_ONLY__BLOCKED_FOR_EXECUTION.
3. Blank-line writer repair: freeze notes, fix notes, closeouts, and receipts may contain intentional blank Markdown lines without failing parameter binding.

Contract rule:
A high-risk marker becomes a blocker only when it is unclassified, paired with execution/route/cleanup/doctrine/action-now clearance, missing custody proof, or hash mismatch.
A classified high-risk marker with all clearances set to NO remains review-only evidence and may be carried into the disposition index.

Physical action remains zero.

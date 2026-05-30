# Helper Slice Contract Gate Template

CONTRACT_ID:
SLICE_ID:
HELPER_ID:

PRECONDITIONS:
- START_STATUS must be CAN_START.
- Required files/sources must exist.
- Required hashes/receipts must be present.
- Permission state must match authority ticket.

POSTCONDITIONS:
- Proof result must be written or explicitly blocked.
- STOP_REASON must be present.
- Ledger update, no-start packet, or handoff packet must exist.

INVARIANTS:
- No doctrine promotion.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No broad crawler.
- No unstated Git writes.
- No edit of real proof file when edit-copy is required.

CONTRACT_VERDICT:
CONTRACT_FAIL_REASON:
# ERROR FREEZE - HSRB-002 V0.4 MISSING SHA256 AFTER TICKET ID AND ROLE COUNT REPAIR

Status: GENERATED_HELPER_OUTPUT_DEFECT / EVIDENCE / NO_EXECUTION

V0.4 repaired TicketID and role counts together, but produced missing SHA256 values and left the index receipt SHA blank in terminal output. This is a custody-quality blocker, not a physical-action defect.

v0_4_missing_sha256_count: 6

Required repair: validate TicketID, role counts, and SHA256 in one pass before the batch can close.
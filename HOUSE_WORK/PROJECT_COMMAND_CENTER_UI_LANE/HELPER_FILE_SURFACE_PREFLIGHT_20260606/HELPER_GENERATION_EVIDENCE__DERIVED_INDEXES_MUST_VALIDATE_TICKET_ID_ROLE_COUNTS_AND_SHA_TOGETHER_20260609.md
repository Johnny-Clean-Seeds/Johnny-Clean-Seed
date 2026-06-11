# HELPER GENERATION EVIDENCE - DERIVED INDEXES MUST VALIDATE TICKET ID ROLE COUNTS AND SHA TOGETHER

Status: HELPER_OUTPUT_EVIDENCE / FUTURE_GENERATION_RULE_CANDIDATE / NOT_DOCTRINE_BY_ITSELF

Observed defect chain: V0.1 preserved SHA and role counts but not TicketID; V0.2 preserved TicketID but lost role counts; V0.3 restored role counts but kept TicketID blank; V0.4 restored TicketID and role counts but lost SHA custody. Future derived-index helpers must validate all three together before a PASS verdict.

Required derived-index gates:
- TicketID blank count must be zero.
- Role counts must match expected batch anatomy.
- SHA256 blank count must be zero.
- Blocked operation counters must remain zero.
- Final verdict cannot say repaired/pass when blocker_count is nonzero.
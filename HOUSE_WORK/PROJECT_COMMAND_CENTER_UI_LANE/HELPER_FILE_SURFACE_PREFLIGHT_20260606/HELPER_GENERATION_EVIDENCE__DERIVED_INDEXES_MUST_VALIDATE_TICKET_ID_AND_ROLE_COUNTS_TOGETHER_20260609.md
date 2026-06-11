# HELPER GENERATION EVIDENCE - Derived indexes must validate TicketID and role counts together

Observed defect chain:
- V0.1 index omitted TicketID values.
- V0.2 repaired TicketID but lost role counts.
- V0.3 repaired role counts but still emitted blank TicketID values.

New requirement:
Derived index helpers must validate source custody fields and semantic count fields together before emitting a passing verdict.

Required checks:
- TicketID blank count must be zero when source rows have tickets.
- Row count must match selected batch count.
- Role bucket counts must match expected selected-batch composition.
- A passing verdict cannot be emitted with blocker_count greater than zero.

Boundary: this evidence note is not doctrine by itself; it is repair evidence for later helper-generation rules.
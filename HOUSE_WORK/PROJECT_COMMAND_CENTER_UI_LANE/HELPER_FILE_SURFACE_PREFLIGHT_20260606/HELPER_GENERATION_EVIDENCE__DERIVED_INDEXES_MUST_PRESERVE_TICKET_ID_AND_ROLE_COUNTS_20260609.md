# HELPER GENERATION EVIDENCE - DERIVED INDEXES MUST PRESERVE TICKET ID AND ROLE COUNTS

Status: EVIDENCE / FUTURE_HELPER_REQUIREMENT / NOT_DOCTRINE_BY_ITSELF

Observed in HSRB-002:
- V0.1 index preserved role categories but blanked TicketID.
- V0.2 repaired TicketID but produced zero role-category counts.
- V0.3 repairs both custody display and role-count preservation.

Requirement candidate:
Any derived review index must preserve source custody identifiers, especially TicketID, and must also verify semantic category counts from the source review packet. Passing hashes alone is not enough when custody columns or category counts are lost.

Boundary:
This evidence note does not approve execution, routing, cleanup, commit, push, or doctrine promotion.

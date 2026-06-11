# FIX NOTE - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.3 TICKET ID AND ROLE COUNT REPAIR

Status: SAME_OBJECT_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH

Repair scope:
- Rebuild the HSRB-002 derived index from the selected batch, the 64-row queue, and the V0.1 semantic index.
- Preserve TicketID from the selected batch when present, else fall back to the 64-row queue by FileName.
- Preserve or derive IndexRole and IndexDecision for all six rows.
- Recount template-rule-card, field-apply, and freeze-repair roles after repair.

Non-scope:
- No helper execution.
- No route, move, delete, rename, cleanup, commit, or push.
- No doctrine promotion.

Helper generation rule learned:
Derived indexes must preserve custody fields and semantic count fields together. A repair must not fix one while losing the other.

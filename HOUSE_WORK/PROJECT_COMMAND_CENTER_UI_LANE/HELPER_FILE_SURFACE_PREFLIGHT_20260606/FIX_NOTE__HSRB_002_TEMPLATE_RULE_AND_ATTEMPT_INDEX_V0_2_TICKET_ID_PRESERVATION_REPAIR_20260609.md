# FIX NOTE - HSRB-002 TEMPLATE RULE AND ATTEMPT INDEX V0.2 TICKET ID PRESERVATION REPAIR

Status: FIX_NOTE / EVIDENCE / NO_EXECUTION / NO_ROUTE / NO_CLEANUP / NO_COMMIT / NO_PUSH

Repair: V0.2 rebuilds the HSRB-002 index by joining the selected batch CSV back to the static summary by FileName, preserving TicketID from the selected batch source. If the selected batch surface lacks TicketID, V0.2 falls back to the 64-row helper review queue by FileName.

Forward helper-generation rule candidate: any derived queue, index, closeout, or proof ledger must preserve custody keys from its source surface, especially TicketID, FileName, SHA256, source role, decision/disposition, and source path when available. A report writer must also preserve empty visual lines without treating the line list as null or invalid.

This is not doctrine promotion. It is evidence and a candidate rule for later house/helper rule capture.

physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0

# HELPER GENERATION EVIDENCE - DERIVED INDEXES MUST PRESERVE TICKET ID

Status: EVIDENCE / RULE_CANDIDATE / NOT_DOCTRINE / NO_EXECUTION / NO_ROUTE / NO_CLEANUP

Observed defect: HSRB-002 V0.1 index preserved filenames and hashes but lost TicketID values in the displayed index table.

Required helper behavior going forward: when a helper creates any derived review surface, it must carry source custody identifiers forward rather than only preserving human-readable names.

Minimum custody fields to preserve when present: TicketID, FileName, SHA256, SourcePath, source queue/batch ID, role/disposition/decision, and no-action boundary.

Boundary: this evidence file does not approve execution, routing, cleanup, commit, push, deletion, rename, or doctrine promotion.

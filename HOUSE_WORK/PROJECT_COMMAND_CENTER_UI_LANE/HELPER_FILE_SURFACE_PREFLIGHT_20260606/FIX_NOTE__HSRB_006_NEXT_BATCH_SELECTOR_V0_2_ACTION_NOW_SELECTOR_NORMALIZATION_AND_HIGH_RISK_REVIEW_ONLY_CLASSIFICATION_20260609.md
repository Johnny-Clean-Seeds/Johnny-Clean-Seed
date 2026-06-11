# FIX NOTE — HSRB-006 NEXT BATCH SELECTOR V0.2

Status: REPAIR_NOTE / ACTION_NOW_SEMANTIC_NORMALIZATION / NO_PHYSICAL_ACTION

Repair summary:
- V0.1 selected the correct remaining rows but counted source action-now wording as selector action authority.
- V0.2 preserves SourceActionNow while forcing SelectorActionNow/ActionNow to NO because this object is a no-execution selector only.
- High-risk command markers remain visible as review-only markers; they do not create execution, route, cleanup, or whole-house clearance.
- Recursive dry-run expansion remains required for every selected row.

Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0

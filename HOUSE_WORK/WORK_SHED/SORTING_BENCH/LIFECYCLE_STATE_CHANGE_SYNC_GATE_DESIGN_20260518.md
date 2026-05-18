# Lifecycle State Change Sync Gate Design

Status: SORTING BENCH / DESIGN PASS
Authority: support only; not command authority

## Source

This design comes from the repeated loop:

save -> anchor behind -> anchor refresh -> save -> anchor behind again

The Discovery Capture Interrupt Rule captured this as a real exposed boss.

## Design Goal

Stop blind anchor-refresh loops without weakening anchor truth.

The system needs a sync-decision gate after lifecycle-changing saves.

## Sync Decision Template

Every risky save should answer:

1. Did active ball change?
2. Did next allowed move change?
3. Did blocked moves change?
4. Did authority change?
5. Did lifecycle state change?
6. Did the user need a resume/handoff point?
7. Is status/index enough?
8. Must anchor refresh now?
9. May anchor trail safely?
10. What is the return trigger?

## Decision Types

### ANCHOR_NOW

Use when current active truth would be misleading without anchor update.

### GROUPED_ANCHOR_FOLLOWUP

Use when anchor must update, but save phase already created a new base and anchor needs a separate proof/save.

### STATUS_ENOUGH

Use when the move is support-only and status/index records it clearly.

### SAFE_TRAIL

Use when anchor can trail because final response, status/index, proof receipt, clean git status, and origin/main prove current position.

### DEFER_WITH_TRIGGER

Use when sync is intentionally deferred, with a named trigger to return.

## Proof Need

This design needs proof that:
- it names the repeated loop
- it preserves ACTIVE_ANCHOR
- it blocks blind stale-anchor behavior
- it allows status/index-only saves only when authority does not change
- it requires grouped anchor follow-up when active ball changes
- it prevents anchor refresh from becoming automatic drag

## Design Verdict

PASS FOR DESIGN ONLY.

Do not rewrite ACTIVE_ANCHOR from this design pass.

Do not install into active guides.

Do not treat this as final lifecycle doctrine.

If saved, next use should be on the next lifecycle state-machine design/proof pass.

# Assistant Context Carrier Save Or Park Decision

Date: 2026-05-31
Status: SAVE SUPPORT / LOCAL CARRIER DEFAULT / NOT DOCTRINE
WorkKey: ASSISTANT-CONTEXT-CARRIER-AND-ANCHOR-LEGEND-20260531-V1

## Decision

Save the support room and generator.

Generate current carriers local-only by default.

## Why

The support rules are stable enough to track:

- anchor legend;
- proof hierarchy;
- need-to-know load rules;
- assistant visibility card;
- gap matrix;
- generator.

The carrier itself is live state. It includes current `HEAD`, origin comparison, dirty status, root loose count, ignored count, and local evidence pointers. That should be regenerated when needed instead of treated as permanently current.

## Carrier Disposition

Default carrier output:

`C:\Users\13527\Desktop\123\_LOCAL_CUSTODY_AND_RECEIPTS\ASSISTANT_CONTEXT_CARRIER_RUNS_20260531\RUN_<timestamp>\`

Tracked only if a later job explicitly chooses a non-sensitive snapshot and records its freshness boundary.

## Next Use

When an outside assistant/helper needs orientation:

1. give the latest generated carrier;
2. give the source map if it needs proof class;
3. give exact target files only when the active task needs full structure;
4. keep long ledgers/source packets as pointers unless full text is required.

## Does Not Prove

This does not adopt a new doctrine.
This does not rewrite `ACTIVE_GUIDES`.
This does not rewrite `CURRENT_TRUTH_INDEX.txt`.
This does not authorize watcher, automation, broad refactor, helper-school install, stale-route retirement, or helper self-promotion.

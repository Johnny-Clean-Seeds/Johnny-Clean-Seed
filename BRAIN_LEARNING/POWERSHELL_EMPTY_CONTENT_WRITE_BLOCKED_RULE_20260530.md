# PowerShell Empty Content Write Blocked Rule

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
Status: SUPPORT RULE / POWERPLAY LEARNING / CHECKPOINTED

## Failure family

A save script can correctly block empty content while still revealing a route bug: the content builder or write map supplied an empty string for a planned output file.

Live failure:

`EMPTY_CONTENT_BLOCKED: BRAIN_LEARNING/HELPER_GROWTH_REPORT_REVERSE_SUMMARY_PACKET_RULE_20260530.md`

## What actually happened

V1.1 repaired the empty collection failure and passed Code Gate probe, then failed in write mode because a planned support rule file was about to be written with empty content.

That block was good. The route error was not the block; the route error was allowing a planned file to reach the writer with empty content.

## Repair pattern

Build the plan with content attached at plan creation time. Validate each template before adding it. Validate again after token expansion. Refuse to write if any planned item has empty content. Avoid loose content maps that can drift away from the plan.

## Rule

For generated save scripts, the plan should carry `Rel`, `Role`, `ForceAdd`, and `Content` together. The writer should iterate the plan, not a separate unverified map.

## False blames blocked

- not a source text failure
- not a Git failure
- not an ignored-path failure
- not a Code Gate parser failure
- not a user command failure

## Reopen trigger

Any future save helper attempts to write a planned file with empty or whitespace-only content.

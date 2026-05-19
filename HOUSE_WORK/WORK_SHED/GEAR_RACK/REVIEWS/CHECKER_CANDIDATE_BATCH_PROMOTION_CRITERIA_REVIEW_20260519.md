# Checker Candidate Batch Promotion Criteria Review

Date: 2026-05-19
Base: main @ 46fd351
Lane: Gear Rack / REVIEWS
Status: promotion review, not promotion

## Reviewed object

Current checker candidate batch:

HOUSE_WORK\WORK_SHED\INCOMING_FILE_PARKING\MOVED_IGNORED_FILES_20260519_20260519_162022\02_TOOL_CANDIDATES

Current evidence:
- Batch was closed as PASS AS CHECKER-CANDIDATE BATCH.
- No checker was promoted to active tool.
- No doctrine rewrite.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX change.

## Promotion question

Should the checker candidates move from incoming parking / tested candidate state into a stronger tool lane?

## Current verdict

DO NOT PROMOTE YET.

Keep as:
- tested checker-candidate batch,
- Gear Rack review object,
- available proof-backed candidate set.

## Why not promote yet

1. The files still live under incoming-file parking.
   That is correct for custody, but not final active-tool placement.

2. The batch has one PASS WITH GUARDRAILS checker.
   That is acceptable for candidate closure, but promotion should explicitly define how guardrail checks behave.

3. The runner has been proven useful, but not yet tested across multiple future states.
   One clean batch pass proves current fit, not durable active-tool status.

4. Promotion should not happen merely because tests passed.
   A checker becoming an active tool needs a job definition, trigger, boundary, failure handling, and maintenance rule.

5. The Gear Rack map says gear must answer:
   - What kind of gear is it?
   - What job does it do?
   - When do I wear it?
   - When do I take it off?
   - What proves it helped?
   - Where does it belong?

## Promotion criteria

A checker or runner may be considered for stronger tool lane only if it passes all of these:

1. Stable job:
   It has one clear job and does not secretly rewrite doctrine.

2. Known trigger:
   The assistant knows when to run it.

3. Clean boundary:
   It cannot promote, delete, rewrite active guides, or change CURRENT_TRUTH_INDEX by itself.

4. Failure handling:
   FAIL stops movement and creates a repair/review lane, not automatic content rewrite.

5. Guardrail semantics:
   PASS WITH GUARDRAILS is explicitly allowed only when the guardrail is named and expected.

6. Repeat use:
   It works on at least one later real use after the current batch.

7. Placement:
   It has a proper lane outside incoming parking if promoted.

8. Maintenance:
   Stale expectation repairs are tracked; checker truth follows active authority, not old wording.

## Recommended next state

Keep the batch parked as tested candidate material.

Use the saved runner pattern again when needed.

Do not move files into HOUSE_WORK\TOOLS yet.

Possible later route:
- Gear Rack / LIVE_TESTS for repeated use.
- Gear Rack / REVIEWS for second review.
- Only after repeated proof: stronger tool lane or HOUSE_WORK\TOOLS.

## Boundary

This review does not promote any checker.
This review does not install doctrine.
This review does not rewrite active guides.
This review does not change CURRENT_TRUTH_INDEX.

# TODO Pick Language Mud Correction

Date: 2026-05-20

## Status

REPAIR / SELECTION-METHOD CORRECTION.

## Trigger

After the TODO First Work Control repair, the assistant said the next move was to pick one actionable TODO.

The user corrected the weakness:

The assistant should not pick.

The TODO list should be sorted by proof, biggest issue, and weakest link.

## Issue Class

Selection-method ambiguity.

Muddy wording.

Potential preference-pick failure.

Potential easy-task drift.

## Evidence

The current TODO board has multiple open TODOs.

Current TODO evidence:

- HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md | bytes=6282 | modified=05/20/2026 03:44:30
- HOUSE_WORK\TODO\ARTIFACT_SELF_CHECK_AFTER_SEND_TODO_20260520.md | bytes=3269 | modified=05/20/2026 03:33:55
- HOUSE_WORK\TODO\COMPOSE_REVIEW_REFLECT_CAPTURE_LIVE_USE_TODO_20260520.md | bytes=4234 | modified=05/20/2026 03:33:55
- HOUSE_WORK\TODO\SOURCE_NOTE_SELF_PROOF_CAPTURE_DISPOSITION_LIVE_USE_TODO_20260520.md | bytes=1071 | modified=05/20/2026 03:33:55
- HOUSE_WORK\TODO\GROWTH_CYCLE_RETURN_DISPOSITION_BEFORE_TRIGGER_EVENT_TODO_20260520.md | bytes=1014 | modified=05/20/2026 03:00:22
- HOUSE_WORK\TODO\GROWTH_CYCLE_STAGE_READINESS_SCAFFOLD_EXIT_LIVE_USE_TODO_20260520.md | bytes=1253 | modified=05/20/2026 03:00:22
- HOUSE_WORK\TODO\FILING_CABINET_AND_RELATION_METHOD_LIVE_USE_TODO_20260520.md | bytes=1347 | modified=05/20/2026 01:08:34
- HOUSE_WORK\TODO\LIVING_ROOT_WORDS_REFINEMENT_TODO_20260520.md | bytes=1307 | modified=05/19/2026 23:37:05
- HOUSE_WORK\TODO\PACKET_TOP_BLOCK_DENSE_HANDOFF_TODO_20260520.md | bytes=1207 | modified=05/19/2026 23:30:54
- HOUSE_WORK\TODO\MULE_START_CARD_AND_SHORT_KICKOFF_TODO_20260520.md | bytes=1228 | modified=05/19/2026 23:25:23
- HOUSE_WORK\TODO\POWERSHELL_COMMAND_SAFETY_TODO_20260520.md | bytes=1695 | modified=05/19/2026 23:22:23
- HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md | bytes=2888 | modified=05/19/2026 23:17:58
- HOUSE_WORK\TODO\TODO_INDEX_20260518.md | bytes=6328 | modified=05/18/2026 05:40:03
- HOUSE_WORK\TODO\TODO_TRACE_TRIAGE_GATE_20260518.md | bytes=3422 | modified=05/18/2026 05:40:03
- HOUSE_WORK\TODO\README.md | bytes=1527 | modified=05/18/2026 05:21:51
- HOUSE_WORK\TODO\TODO_CAPTURE_INBOX_20260518.md | bytes=912 | modified=05/18/2026 05:13:11

The correct next action is not preference selection.

The correct next action is weakest-link triage.

## Corrected Standard

The list picks through proof.

The assistant groups TODOs into parent bosses, collapses child tasks, ranks by impact, and lets the biggest issue / weakest link become the top route.

## Saved Rule

BRAIN_LEARNING\TODO_PROOF_RANKED_WEAKEST_LINK_SELECTION_RULE_20260520.md

## Patched Rule

BRAIN_LEARNING\TODO_FIRST_WORK_CONTROL_RULE_20260520.md

## Board Updated

HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md

## Boundary

No doctrine.

No active guide rewrite.

No CURRENT_TRUTH_INDEX rewrite.

No dashboard.

No automation.

No runtime.

No knowledge graph.

No full lesson index.

No new TODO pile expansion.

## Next Move

Run TODO weakest-link triage.

Let the proof-ranked list identify the top route.

Then work that route or dispose it with proof.

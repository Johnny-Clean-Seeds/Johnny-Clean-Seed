# Helper Growth Report / Reverse Summary Packet Rule

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
Status: SUPPORT RULE / CHECKPOINTED
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX; no automation.

## Rule

If helpers, files, gates, packets, or ledgers gain growth logic, every growth/action event must report what it did, when it did it, why it did it, what evidence or proof it used, what changed, what it handed off, what it learned, and what can reopen it.

Reports must go to one clear parent folder for the chain, not scatter across unrelated folders.

After a helper chain finishes, the final helper or gate must reverse-walk the chain and produce one sensible full summary packet of all doings: how, when, why, inputs, outputs, proof, helper starts and stops, handoffs, ledger updates, remaining triggers, and next carry-forward packet.

## Parent folder shape

`COMMAND_CENTER/HELPER_GROWTH_REPORTS/<TRACE_ID>__<JOB_KEY>/`

Suggested children:

- `00_RUN_MANIFEST`
- `01_FRONT_GATE_PLAN`
- `02_PACKETS`
- `03_START_REPORTS`
- `04_WORK_EVENTS`
- `05_PROOF_RECEIPTS`
- `06_STOP_REPORTS`
- `07_HANDOFF_PACKETS`
- `08_LEDGER_UPDATES`
- `09_DECISION_NOTES`
- `10_REVERSE_WALK_SUMMARY`
- `11_FINAL_PACKET`

## Required close behavior

A chain is not closed until the reverse summary can identify the original task, Front Gate decision, helper sequence, start statuses, stop reasons, handoffs, proof receipts, files changed or created, ledger updates, open watch items, and next packet recommendation.

## Boundary

Reporting proves what happened. Reporting does not authorize the next action by itself.

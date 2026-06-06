# DUAL_COMMAND_CENTER_L0_STANDARD

Status: L0 STANDARD / REVIEW PACKET / NOT INSTALLED / NOT DOCTRINE
Date: 2026-06-06
SourceBasis: OUTSIDE_ASSISTANT_COOPERATION_INDEX_V0.2, especially Batches 10D, 10E, 10F, and 10G
ActiveObject: OUTSIDE_ASSISTANT_COOPERATION_INDEX_V0.2_SOURCE_TO_LIVE_L0_CUSTODY_CHAIN

## Purpose

This standard defines the first live L0 command-center spine as a dual-center system:

- USER_COMMAND_CENTER in front.
- ASSISTANT_COMMAND_CENTER backstage.
- ACTORS behind custody packets.
- FILES as carriers.
- ASSISTANTS as actors.

This file does not install the command center and does not authorize mutation.

## Plane Split

USER_COMMAND_CENTER:

- user front door
- user authority surface
- active job view
- next legal action view
- human approvals view
- user-readable blockers
- receipt summaries
- DoesNotProve boundary

ASSISTANT_COMMAND_CENTER:

- backstage routing surface
- actor board
- router ledger view
- work token view
- custody packet view
- handoff trace view
- receipt judge view
- guard status view
- byte accounting view
- root intake view
- backstage blocker view

ACTORS:

- ChatGPT
- Codex
- Mule
- Guard Agent
- Human Review
- MCP/tool actor when wrapped as an acting lane

Actors do work only under custody packets. Files carry instructions, state, and proof.

## Authority Ownership

User center owns:

- user intent
- user blocks
- human approval
- selected active job
- final accept/reject
- mutation authorization when paired with exact mutation packet

Assistant center owns:

- actor assignment details
- custody packet readiness
- work token state
- receipt completeness
- guard proof level
- byte accounting
- root intake state
- backstage blockers
- route trace

Actors own:

- only the exact work assigned in their custody packet
- only the mutation level granted in that packet
- only the return receipt they produce

No layer may quietly take another layer's authority.

## Front Door Rule

Root should expose user control, not assistant machinery.

Core rule from source:

`ROOT GETS THE USER FRONT DOOR. ASSISTANT MACHINERY STAYS BEHIND IT OR IN LOCAL CUSTODY.`

The user opens COMMAND_CENTER first. Backstage views can be linked, but they remain behind the front door and must not become the user's only control surface.

## Backstage Rule

The assistant center may request, route, project, and report. It may not approve irreversible actions by itself.

The assistant center must surface bad news:

- blockers
- rejected receipts
- missing packets
- guard gaps
- false completion risk
- DoesNotProve

It must not sanitize or hide contradictions to keep the dashboard clean.

## Actor Rule

Actors execute only packeted work.

Every actor assignment requires:

- selected actor
- active object
- working lane
- allowed mutation level
- forbidden actions
- actor-readable custody surface
- expected receipt
- stop conditions
- DoesNotProve

Actor receipt is evidence. It is not final acceptance until judged.

## Required Front-Door Files

COMMAND_CENTER/START_HERE.md:

First user-facing file and pointer to dashboard, active job, next legal action, blockers, human approvals, recent receipts, and DoesNotProve.

COMMAND_CENTER/USER_DASHBOARD.md:

Short user-readable current state. Must show active job, current actor, blocker state, mutation authorization, last receipt, receipt verdict, next legal action, and DoesNotProve.

COMMAND_CENTER/ACTIVE_JOB.md:

Active object, user request, working lane, selected actor, work token, custody packet, root intake state, active job done flag, required outputs, receipt verdict, blocker, and next legal action.

COMMAND_CENTER/NEXT_LEGAL_ACTION.md:

Current allowed next action, blocked actions, why blocked, required before next action, possible legal moves, forbidden moves, and DoesNotProve.

COMMAND_CENTER/BLOCKERS.md:

User-readable open blockers and requirements to clear them.

COMMAND_CENTER/HUMAN_APPROVALS.md:

Human review queue view. Approval must name exact item and exact action. Approval does not execute.

COMMAND_CENTER/RECENT_RECEIPTS.md:

Recent receipt summary and receipt acceptance rule.

COMMAND_CENTER/DOES_NOT_PROVE.md:

User-facing boundary file. Must not be hidden backstage.

## Required Backstage Files

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/README_ASSISTANT_BACKSTAGE.md:

Backstage role and authority boundaries.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/ACTOR_BOARD_VIEW.md:

Actor status, active object, operating mode, mutation level, work token, packet, receipt, blocker, and next legal action.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/ROUTER_LEDGER_VIEW.md:

Route decisions and rejected actor reasons.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/WORK_TOKEN_VIEW.md:

Work token ownership and close verdict.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/CUSTODY_PACKET_VIEW.md:

Packet readiness and actor-readable surface checks.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/HANDOFF_TRACE_VIEW.md:

Actor transition trace.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/RECEIPT_JUDGE_VIEW.md:

Receipt completeness and judge verdict.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/GUARD_STATUS_VIEW.md:

Protected-core proof level and gaps.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/BYTE_ACCOUNTING_VIEW.md:

Byte custody summary and cleanup-authority warnings.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/ROOT_INTAKE_VIEW.md:

Root intake state and active-job continuation.

COMMAND_CENTER/ASSISTANT_COMMAND_CENTER/BACKSTAGE_BLOCKERS_VIEW.md:

Assistant-side blocker board projection.

## Required Local State Folder

Local state belongs under:

`_LOCAL_CUSTODY_N_RECEIPTS/ASSISTANT_COMMAND_CENTER_STATE/`

It must not be loose in root.

It stores:

- ACTIVE_OBJECT.json
- ACTOR_BOARD.json
- WORK_TOKEN_LEDGER.csv
- ROUTER_LEDGER.csv
- CUSTODY_PACKET_INDEX.csv
- HANDOFF_TRACE.jsonl
- RECEIPT_INDEX.csv
- BLOCKER_BOARD.json
- HUMAN_REVIEW_QUEUE.csv
- BYTE_ACCOUNTING_LEDGER.csv
- GUARD_STATUS.json
- ROOT_INTAKE_QUEUE.csv
- UI_EVENT_LOG.jsonl
- ARTIFACT_INDEX.csv
- CATALOG.csv
- COMMAND_CENTER_LEAKAGE_GUARD_REPORT.md

## Boundary Rules

Assistant status is not user approval.

Actor receipt is not final acceptance.

Human approval is not execution.

Execution is not closure until receipt is judged.

Root intake is preflight, not active job completion.

Duplicate proof is not delete authority.

Recovery custody mass is not bloat.

Presence check is not semantic protection.

Chat memory is not actor-readable enforcement.

UI/status/button does not create mutation authority.

## Closeout Requirement

The L0 command center may later be called synced only if:

1. User files exist.
2. Assistant views exist.
3. State files exist.
4. Sync guard ran.
5. No split-brain was found.
6. DoesNotProve was preserved.
7. User dashboard points to backstage.
8. Backstage points to receipts.
9. Root contains front door only.
10. No mutation is authorized by default.

Closeout verdict if all pass:

`DUAL_COMMAND_CENTER_MVP_SYNCED`

If any fail:

`DUAL_COMMAND_CENTER_MVP_OPEN`

## Does Not Prove

This standard does not prove that files exist live, that state is synced live, that any actor has received these rules, or that mutation is authorized.

## Next Legal Action

Review the standard. If accepted, prepare a separate install approval packet before creating live command-center files.


# OUTSIDE_ASSISTANT_COOPERATION_INDEX_V0.2 - L0 Clean

Status: L0 CLEAN / REVIEW PACKET / NOT DOCTRINE / NOT INSTALLED
Date: 2026-06-06
ActiveObject: OUTSIDE_ASSISTANT_COOPERATION_INDEX_V0.2_SOURCE_TO_LIVE_L0_CUSTODY_CHAIN
OperatingMode: WRITE_REPORTS_ONLY
SourceFile: OUTSIDE_ASSISTANT_COOPERATION_INDEX_V0_2_SOURCE_TO_LIVE_L0_CUSTODY_CHAIN_RAW_20260605.md
SourceSHA256: F48BC6C737FDED649908DC6036DF82B89F5832D51B624473CA3308F99010D144

This file is the clean L0 extraction of the outside-assistant cooperation index. It is a routing constitution for outside helpers, not a generic essay and not a live install.

## Source Inventory

SourceStatus: FULL
SourceStatusNote: Read fully; not silently truncated. The source explicitly stops after 11BK and names 11BL as next.

Read result: the source file was found at the workspace root, read successfully, and ends with a stated stop point at Batch 11BK plus a named next batch, 11BL. The live build lane is unfinished after 11BK by source wording, but the source itself is not treated as silently truncated.

BatchesDetected:

- Batch 1 through Batch 9.
- Batch 10A through Batch 10Z.
- Batch 11A through Batch 11Z.
- Batch 11AA through Batch 11BK.

BatchesMissing: none detected in the source sequence.

Duplicate batch headings detected: 11C, 11L, 11AD. These were preserved as source accounting notes and not silently collapsed into invented content.

Batch 10F status: COMPLETE_ENOUGH_FOR_L0_EXTRACTION. It contains MVP root shape, user front door files, assistant backstage view files, local custody state file set, ledger headers, initial state values, leakage guard, build order, close condition, and carry line.

Batch 10G status: EXISTS_AND_COMPLETE_ENOUGH_FOR_L0_EXTRACTION. It contains the sync contract, field ownership, projection rules, sync directions, sync event schema, split-brain detection, dashboard update rules, user-authority protection, bad-news projection rule, sync guard report, no silent auto-sync rule, closeout rule, and carry line.

## Parent Correction

The parent correction survives unchanged:

`ASSISTANTS ARE ACTORS.`

`FILES ARE CARRIERS.`

Actor means something that can perform work.

Actors include:

- ChatGPT
- Codex
- Mule
- Guard Agent
- Human Review
- MCP/tool actor when wrapped as an acting lane

Carrier means something that instructs, constrains, proves, or transports state.

Carriers include:

- AGENTS.md
- SKILL.md
- mule orders
- handoff files
- rule files
- ledger files
- manifest files
- receipt files
- hash ledgers
- decision ledgers
- proof packets
- review indexes
- prompt packets
- run notes
- guard scripts

Forbidden category errors:

- Do not call a carrier an assistant.
- Do not expect a carrier to act.
- Do not expect chat memory to control an outside actor.
- Do not expect a downloaded or generated file to deploy itself.

## Core Rule

Family:

`OUTSIDE_ASSISTANT_COOPERATION_FAMILY`

Canonical rule:

`ASSISTANTS DO WORK. FILES CARRY INSTRUCTIONS, STATE, AND PROOF. ROUTE TO THE RIGHT ASSISTANT, ATTACH THE CUSTODY PACKET, REQUIRE A RECEIPT, AND NEVER CALL PREFLIGHT COMPLETION.`

Stable carry lines:

- ALL ASSISTANTS AVAILABLE. ONE ASSISTANT ACTIVE.
- ALL FILES AVAILABLE. ONE CUSTODY PACKET CARRIED.
- ALL TOOLS AVAILABLE. ONE TOOLBELT WORN.
- ALL PROOF PRESERVED. ONE PROOF POINTER RETURNED.
- CHATGPT ROUTES AND JUDGES.
- CODEX EXECUTES CODE UNDER PROJECT RULES.
- MULE AUDITS FILE CUSTODY AND RETURNS RECEIPTS.
- GUARD AGENTS CHECK RULE SURVIVAL AND SEMANTIC DRIFT.
- HUMAN REVIEW DECIDES HIGH-RISK RESTORE / DELETE / CLEANUP.
- FILES INSTRUCT, CARRY, AND PROVE. FILES DO NOT ACT.
- NO OUTSIDE ASSISTANT ACTS WITHOUT A CUSTODY PACKET.
- NO DONE CLAIM WITHOUT ACTIVE_JOB_DONE.

## Seven-Layer Cooperation Stack

1. SCENT

Detect which actor or lane fits the task.

2. FIT

Name what the actor can do and what it cannot do.

3. AUTHORITY

Define allowed mutation level. Allowed authority labels:

- READ_ONLY
- REPORT_ONLY
- WRITE_REPORTS_ONLY
- EDIT_CODE_ONLY
- RESTORE_APPROVED_ITEMS_ONLY
- MUTATION_BLOCKED
- HUMAN_APPROVAL_REQUIRED

4. CUSTODY PACKET

Attach the rules the actor must obey. Minimum packet:

- active object
- working lane
- allowed mutation level
- forbidden actions
- lossless custody rule
- root intake rule
- stop-on-error rule
- receipt requirements
- DoesNotProve

5. EXECUTION

The actor performs only its assigned work. No actor may silently expand from report-only to cleanup, from root intake to job completion, from duplicate proof to deletion, or from file routing to active job done.

6. RETURN

The actor returns receipts, not vibes. Required receipt shape:

- Status
- Actor
- ActiveObject
- InputSources
- OutputFolder
- FilesWritten
- Hashes
- MutationFlags
- RowsProcessed
- Counts
- Failures
- BlockedItems
- NextLegalAction
- DoesNotProve

7. JUDGMENT

ChatGPT or human review decides whether the work is accepted, blocked, parked, rerouted, or escalated. No actor self-certifies final truth without proof review.

## Partner-Scent Router

Routing shape:

`TASK SHAPE -> PARTNER SCENT -> ACTIVE ACTOR -> CUSTODY PACKET -> RECEIPT`

A scent is detection, not permission. Every scent must produce FIT, BOUNDARY, and CUSTODY checks. No scent can skip custody. No scent authorizes mutation by itself.

| Task shape | Primary scent | Active actor | Carrier needed | Mutation default | Receipt required |
|---|---|---|---|---|---|
| Code execution, repo edit, tests, runner repair | CODEX_SCENT | Codex | AGENTS.md or explicit task packet | code edit only when authorized | diff, test result, pass/fail, receipt |
| Missing files, root drops, recovery, byte accounting, manifests | MULE_SCENT | Mule | mule order and custody rules | report-only unless separately approved | manifest, hashes, recovery/accounting receipt |
| Protected core, rule weakening, bypass, semantic drift | GUARD_AGENT_SCENT | Guard Agent | protected core and guard order | report-only | semantic guard report |
| Architecture, routing, judgment, handoff writing | CHATGPT_SCENT | ChatGPT | source cards, packets, receipts | no local mutation | revised rule/spec/judgment |
| External API/tool operation | MCP_TOOL_SCENT | Agent using tool | tool definition plus actor packet | tool-specific and packet-bound | tool output plus receipt/source |
| Delete, empty, restore live, final disposition | HUMAN_REVIEW_SCENT | Human Review | decision ledger/accounting packet | blocked until approved | explicit approval receipt |
| Unclear authority, path, scope, or parser failures | BLOCKED_LANE_SCENT | none yet | incident/blocker report | no mutation | blocker report |

## Actor Lanes

Codex lane:

- Codex is a code actor, not the house judge.
- Codex may inspect repos, edit code, repair scripts, run tests, produce diffs, and work inside the selected directory when packeted.
- Codex must receive rules through an actor-readable surface such as AGENTS.md, .codex config, a skill, or an explicit task packet.
- Codex may not inherit cleanup authority from being able to edit code.

Mule lane:

- Mule is a custody actor, not a cleanup actor.
- Mule may read, hash, classify, ledger, compare, audit, and report.
- Mule may write reports and receipts under WRITE_REPORTS_ONLY.
- Mule may not delete, move, compress, archive, dedupe, restore in place, empty Recycle Bin, commit, push, install watchers, install automation, or rewrite parent rules without a separate exact mutation packet.

Guard lane:

- Guard Agent protects meaning, not just file existence.
- Presence is not enough. Guard proof must distinguish presence, repair, semantic integrity, non-bypass, non-intervention, and actor-surface coverage.
- A guard report must state which proof level is reached and which gaps remain.

Human Review lane:

- Irreversible or meaning-heavy decisions require human review.
- Human review owns final delete approval, final restore approval, cleanup approval, compression/replace approval, concept/rule retirement, Recycle Bin emptying approval, and unknown recovered material judgment.
- Human approval does not execute an action.

MCP/tool lane:

- Tool access is not agent authority.
- A tool may compute, read, or call something, but it does not own judgment unless wrapped in an actor lane with instructions, authority, and receipt requirements.

## Custody Packet Standard

Parent rule:

`AN OUTSIDE ASSISTANT MAY NOT ACT UNTIL IT HAS RECEIVED WHO / WHAT / AUTHORITY / CUSTODY / RETURN / STOP / DOES_NOT_PROVE.`

Minimum custody packet fields:

- PacketId
- CreatedUtc
- RequestedBy
- SelectedActor
- ActiveObject
- WorkingLane
- Task
- InputSources
- AllowedMutationLevel
- ForbiddenActions
- GoverningRules
- ActorReadableSurface
- OutputFolder
- RequiredReturnReceipt
- StopConditions
- DoesNotProve
- NextLegalAction

Failure labels include:

- PACKET_MISSING_AUTHORITY
- PACKET_MISSING_RETURN_RECEIPT
- PACKET_AUTHORITY_TOO_BROAD
- PACKET_NOT_INSTALLED_WHERE_ACTOR_READS
- PACKET_CONFUSES_ACTOR_AND_CARRIER

## Mutation Packet Standard

Human approval does not execute the action. Human approval unlocks a mutation packet. The mutation packet executes one exact action with lossless accounting.

Parent rule:

`MUTATION_EXECUTION_REQUIRES_EXACT_SCOPE_HUMAN_APPROVAL_LOSSLESS_ACCOUNTING_AND_RECEIPT.`

Mutation includes delete, move, rename, compress, archive, dedupe, restore, restore-in-place, merge, overwrite, empty Recycle Bin, remove from custody, move custody to live, change rule text, retire concept/tool/rule, commit, push, watcher install, and automation install.

Mutation does not include read, hash, classify, compare, or write reports.

Hard boundaries:

- Duplicate proof is not delete authority.
- Archive custody is not disposal authority.
- Human approval without lossless accounting does not authorize execution.
- UI/status/button language does not create mutation authority.

## Supervisor and Multi-Agent Standard

Core rule:

`ONE SUPERVISOR MAY ROUTE. ONE ACTOR MAY OWN A TASK. NO ACTOR MAY QUIETLY TAKE ANOTHER ACTOR'S AUTHORITY.`

Supervision means routing, not unchecked control. A supervisor may detect scents, select or reject actors, attach custody packets, assign active objects, track receipts, block mutation, and escalate to human review. A supervisor does not create authority by itself.

One active object should have one active actor and one custody packet unless a partitioned multi-agent packet explicitly defines separate non-overlapping lanes.

Done is a judged state, not a worker word.

## Command Center Standard

The command center is a visibility and routing surface, not a magic authority layer.

It must show:

- who is acting
- what active object is open
- what custody packet governs the actor
- what mutation level is allowed
- which receipts returned
- which blockers remain
- what does not prove completion
- next legal action

It must not say clean, fixed, deleted, restored, approved, or done merely because a button was clicked or a worker returned a happy line.

## Dual Command Center Split

The source correction creates two command centers:

1. USER_COMMAND_CENTER

The user front door and authority surface. It owns user intent, user blocks, human approvals, selected active job, final acceptance/rejection, and the user-readable DoesNotProve boundary.

2. ASSISTANT_COMMAND_CENTER

The backstage operations, routing, token, packet, trace, receipt, guard, byte-accounting, and blocker surface. It stores assistant detail and projects user-safe status upward.

Actors stay behind custody packets.

Core L0 rule:

`ROOT GETS THE USER FRONT DOOR. ASSISTANT MACHINERY STAYS BEHIND IT OR IN LOCAL CUSTODY.`

## Boundary Extraction

Hard boundaries preserved:

- user command center is the front door
- assistant command center is backstage
- root shows user control, not assistant guts
- assistant status is not user approval
- actor receipt is not final acceptance
- human approval is not execution
- execution is not closure until receipt is judged
- root intake is preflight, not active job completion
- duplicate proof is not delete authority
- recovery custody mass is not bloat
- presence check is not semantic protection
- chat memory is not actor-readable enforcement
- UI/status/button does not create mutation authority

## MVP File Set Summary

First live install shape, if separately approved later:

- COMMAND_CENTER user front door files.
- COMMAND_CENTER/ASSISTANT_COMMAND_CENTER backstage view files.
- _LOCAL_CUSTODY_N_RECEIPTS/ASSISTANT_COMMAND_CENTER_STATE local state and ledger files.

This review packet does not install that shape.

## Sync / No Split-Brain Standard

Source Batch 10G supports a sync contract. User front door and assistant backstage must sync through explicit projection, not copy-paste drift.

Core rule:

`USER FRONT DOOR AND ASSISTANT BACKSTAGE MUST SYNC THROUGH EXPLICIT PROJECTION, NOT COPY-PASTE DRIFT.`

If user-facing status and assistant state disagree, the mismatch becomes a blocker:

`DUAL_CENTER_SPLIT_BRAIN_BLOCK`

No mutation. No closeout. No done claim.

## Does Not Prove

This L0 clean file does not prove:

- the command center is installed
- this package is doctrine
- assistants can mutate files
- Codex received new rules
- Mule completed any active job besides this source-to-L0 package
- human approval exists
- deletion, cleanup, compression, restore, archive, dedupe, or Recycle Bin emptying is authorized
- user command center and assistant command center are synced live
- a UI exists
- a watcher or automation exists

## Next Legal Action

Review this L0 packet. If accepted, prepare a separate install approval packet. Do not install, mutate, promote doctrine, or authorize cleanup from this file alone.

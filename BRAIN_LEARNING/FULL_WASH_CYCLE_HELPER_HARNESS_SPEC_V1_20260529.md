# FULL WASH CYCLE HELPER HARNESS SPEC V1

Status: NARROW BUILD SPEC / NOT DOCTRINE
Object: FULL_WASH_CYCLE_HELPER_HARNESS_SPEC_V1
Date: 2026-05-29
Placement: BRAIN_LEARNING candidate with Gear Rack support card
Boundary: no code helper build; no helper execution; no bypass; no dashboard; no automation; no doctrine; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX; no broad helper manager.

## 1. Core statement

A Full Wash helper can accept almost any object for classification, routing, washing, and proof planning.

It can act only through approved narrow adapters.

It learns only through receipts, ledgers, repeated proof, and promotion gates.

It never bypasses gates by default.

It never rewrites authority.

It never self-promotes.

It never treats a run as PASS without artifact proof.

The helper is not a general-purpose executor.

The helper is a house-trained worker.

It enters through the Front Door, attaches the rope, checks the rule board, routes to the proper room, uses only earned tools, leaves proof, washes the run, updates ledgers, and shuts itself down after close.

## 2. House-fit origin

This spec comes from the Full Wash helper harness walk.

The object was not "make a helper that does anything."

The real object was a house-trained helper growth system.

Its job is to receive almost any object, classify it, attach a rope, walk gates, pick a room, use only earned tools, leave proof, wash the result, and update its ledgers.

The helper must start with Door / Alpha / Router, not action.

The helper cannot be a free executor. It must be a gate-walking worker.

## 3. Primary architecture

The working shape is:

FRONT DOOR -> ROPE -> GATE SPINE -> ROOM ROUTER -> ADAPTER -> TRACE -> ARTIFACT -> WASH -> LEDGER -> SEAT -> GROWTH PROPOSAL

Not:

helper -> action -> maybe receipt

The helper is the convergence point for existing house concepts, not a foreign automation layer.

## 4. Rope Layer

The rope is the trace object.

Every wash run gets a Rope ID:

ROPE-YYYYMMDD-HHMMSS-OBJECTSHORT

The rope records:

- object
- source
- current lane
- current gate
- action attempted
- proof found
- failure point
- next gate
- close label

Every receipt, ledger, adapter decision, and close label uses that Rope ID.

Without rope, the helper is blind movement.

With rope, the helper can walk deep rooms without losing custody.

## 5. Gate Spine

The helper starts at the gates. It does not begin at action.

Fixed gate order unless a named bounded exception is approved:

1. Front Door Gate: What is the object?
2. Authority Gate: Who or what allows action?
3. Source/Custody Gate: Where did the object come from?
4. Risk Gate: What can go wrong?
5. Direct Road Gate: What is the simplest proven path?
6. Adapter Gate: What narrow action module is allowed?
7. Execution Gate: What action, if any, can happen?
8. Trace Gate: What exactly happened?
9. Artifact Gate: What proves the work?
10. Wash Gate: What did we learn?
11. Seat Gate: Does this helper keep its seat?
12. Growth Gate: Does the helper earn a new capability?

No gate cancels another gate.

PowerShell front gate stays on by default.

Code Gate is second gate, not first gate.

Artifact proof decides job PASS.

Helper value audit decides tool seat.

## 6. Controlled force rule

Forcing can be legitimate, but it is not normal movement.

Controlled force is not gate removal.

A force, override, mute, or bypass can be valid only when scoped, named, approved, proved, and restored.

Never shut down the whole front gate unless the active object is the front gate itself.

If a gate must be muted, bypassed, or overridden, the action must record:

- reason
- scope
- target gate
- duration
- protection that remains active
- approval
- proof condition
- restore condition
- confirmation that the gate was restored or the temporary condition ended

A force action is incomplete until restoration is proved or the temporary condition has naturally closed.

The failure being repaired was not "force exists."

The failure was unscoped force becoming default behavior.

## 7. Adapter Rack

Adapters are the only parts allowed to act.

No adapter means no action.

Initial adapter ladder:

1. READ_ONLY_WITNESS_ADAPTER
   - Reads object metadata.
   - Classifies lane.
   - No write.
   - No run.

2. EVIDENCE_PARK_ADAPTER
   - Copies evidence.
   - Hashes files.
   - Writes manifest.
   - No delete.
   - No run.
   - No bypass.
   - No Git write by default.

3. STATIC_REVIEW_ADAPTER
   - Inspects text or scripts for hazards.
   - Looks for bypass words, delete/move, Git writes, network calls, interactive prompts, missing proof fields, and false PASS patterns.
   - No execution.

4. CODE_GATE_PARSE_ADAPTER
   - Uses normal front gate first.
   - Runs Code Gate parse/risk check only after normal launch conditions are clean.
   - No default ExecutionPolicy Bypass.
   - No interactive target under Code Gate by default.
   - Code Gate PASS is not job PASS.

5. DIRECT_ROAD_ADAPTER
   - Only for roads already proven manually.
   - Example: direct yt-dlp transcript road.
   - No wrapper magic.
   - Artifact proof required.

6. EXACT_SAVE_ADAPTER
   - Only after explicit lock/save approval.
   - Exact files only.
   - Staged-set proof.
   - Commit/push proof.
   - HEAD equals origin.
   - Final status clean.

7. GROWTH_PROPOSAL_ADAPTER
   - Proposes new adapters/rules/promotions from repeated proof.
   - Cannot self-promote.
   - House decides.

## 8. Capability Passport

Every adapter must carry a passport.

Minimum fields:

- Capability name
- Allowed object types
- Blocked object types
- Allowed actions
- Forbidden actions
- Required gates
- Required proof
- Known safe direct road
- Known unsafe route
- Run count
- Pass count
- Fail count
- Choke count
- Last proof
- Current trust state
- Promotion limit
- Rollback condition
- Restore condition if any gate is muted

The passport is how the helper learns without becoming loose.

It is earned capability memory, not emotional memory.

## 9. Control Ledger

Every adapter action must answer four unsafe-action questions:

1. What happens if this action is done when it should not be done?
2. What happens if this action is not done when it should be done?
3. What happens if this action is done too early, too late, or in the wrong order?
4. What happens if this action continues too long?

This absorbs the front-gate incident.

ExecutionPolicy Bypass was not evil forever.

It was unsafe as a default, unsafe in that lane, and unsafe without restoration.

## 10. Telemetry Receipt

Every meaningful helper run should split proof into:

- logs: what happened
- metrics: whether it helped
- traces: where the object traveled or died

Minimum telemetry receipt fields:

- Rope ID
- Object
- Source
- Gate path
- Adapter selected
- Run context
- Allowed actions
- Blocked actions
- Action attempted
- Artifact expected
- Artifact produced
- Artifact path
- Artifact hash or length where relevant
- ScriptStatus if script involved
- JobStatus if task involved
- FinalVerdict
- Failure class
- Proof held
- Proof missing
- Next action
- Close label

A helper that cannot produce logs, metrics, and trace is not mature.

## 11. Learning Ledger

The helper learns only through proof-bearing entries.

Learning types:

- Observed learning: saw this file/path/state.
- Failure learning: this failed here.
- Mechanism learning: this method worked.
- Boundary learning: this action was too broad.
- Suit learning: this adapter fits this object class.
- Promotion learning: repeated proof supports moving up.
- Rejection learning: this route creates burden; burn from live carry.

Only mechanism plus proof plus repeated fit should affect future behavior.

One-off vibes do not count.

## 12. Seat Ledger

Every helper or adapter must earn its seat.

Questions:

- Did it reduce burden?
- Did it preserve the object?
- Did it expose failure clearly?
- Did it produce artifact proof?
- Did it create new risk?
- Did it require recovery?
- Did it repeat cleanly?
- Did it deserve a wider scope?

Possible states:

- DOWNLOADED_UNTRUSTED
- HASHED_UNREVIEWED
- PLACED_FOR_REVIEW
- READ_ONLY_WITNESS
- CUSTODY_PROVEN
- STATIC_REVIEW_PROVEN
- CODE_GATE_PARSE_PASS_ONLY
- TARGET_RAN_NO_ARTIFACT
- TARGET_RAN_ARTIFACT_PASS
- TRUST_TAINTED
- REPAIR_CANDIDATE
- DIRECT_ROAD_ONLY
- NARROW_LIVE_USE
- REUSE_PATTERN
- PARKED_EVIDENCE
- REJECTED

## 13. Maturity Levels

No helper jumps levels.

L0 Witness:
- Observe.
- Classify.
- Report.
- No writes.
- No execution.

L1 Custody:
- Copy evidence.
- Hash.
- Manifest.
- No delete.
- No run.

L2 Static Review:
- Inspect scripts/docs.
- Flag risks.
- No execution.

L3 Gate Runner:
- Invoke approved gates under normal front-gate conditions.
- No default bypass.
- No interactive target under Code Gate.

L4 Narrow Action:
- Execute one proven direct road with receipt.
- Artifact proof required.

L5 Exact Save:
- Save one approved object.
- Exact files.
- Staged-set proof.
- Commit/push proof.
- Clean final status.

L6 Growth Proposer:
- Propose new adapters/rules/promotions from repeated proof.
- Cannot promote itself.

## 14. Adapter Selection Table

The helper should not decide to act freely.

It should select from a bounded table:

| Object type | Default adapter | Blocked adapter |
| --- | --- | --- |
| Unknown file | READ_ONLY_WITNESS_ADAPTER | run/delete/save |
| Downloaded script | STATIC_REVIEW_ADAPTER | execution/bypass |
| Failed helper evidence | EVIDENCE_PARK_ADAPTER | cleanup/delete |
| Proven direct-road task | DIRECT_ROAD_ADAPTER | wrapper rebuild |
| Save object | EXACT_SAVE_ADAPTER | broad Git staging |
| Rule pack | COMPATIBILITY_APPLY_GATE | doctrine rewrite |
| Raw transcript/source | SOURCE_CUSTODY | raw Git staging |

## 15. Growth Proposal Packet

When the helper wants to grow, it must output a proposal packet.

Minimum fields:

- Observed repeated need
- Current adapter limit
- Proof from runs
- Failure avoided
- New capability requested
- Smallest safe scope
- Required proof
- Rollback condition
- Why existing adapter is insufficient

Final Judge decides.

The helper proposes.

The house promotes.

## 16. Room Map

Front Door:
- Receives the object.
- Locks Rope ID.
- Defines mode.

Rule Board:
- Checks authority, gates, boundaries, and blocked moves.

Source/Custody Room:
- Determines where object came from and whether it is trusted, arrival-only, evidence, or active work.

Code Cabinet:
- Handles scripts only after front-gate rules.
- No default bypass.
- No interactive target under Code Gate by default.

Proof Room:
- Checks artifacts, hashes, receipts, and final states.

Misc Drawer:
- Parks evidence.
- Not trash.
- Not proof authority.
- Not deletion authority.

Gear Rack:
- Stores reusable adapters and capability passports.

Think Tank:
- Reviews growth candidates.
- Finds pattern fit and missing organs.

Final Judge:
- Decides pass, park, repair, reject, or promote.

Data Waste:
- Burns live carry weight.
- Does not erase evidence.

## 17. First growth path

The first adapter should be EVIDENCE_PARK_ADAPTER.

Reason:

It already passed cleanly in live use:
- copy only
- hash
- manifest
- no run
- no delete
- no bypass
- no Git write

It gives the helper one harmless hand.

Only after repeated clean evidence parks should the helper get another hand.

The helper's first growth is custody, not execution.

## 18. No-go boundaries

This spec does not authorize:

- helper build
- helper execution
- bypass
- dashboard
- watcher
- scheduler
- automation
- doctrine
- ACTIVE_GUIDES change
- CURRENT_TRUTH_INDEX change
- broad helper manager
- self-promotion
- deletion
- cleanup
- unbounded Git staging

## 19. Promotion and rollback rules

Promotion requires:

- repeated proof
- artifact proof where action occurs
- telemetry receipt
- after-run wash
- seat ledger improvement
- no unresolved choke
- no trust-tainted run context
- bounded scope
- rollback condition

Rollback triggers:

- parser fail
- front-gate violation
- unknown target state
- interactive hang
- no artifact
- false PASS
- repeated same failure
- dirty authority route
- user interruption without close proof
- burden increase

Rollback action:

- stop helper lane
- preserve evidence
- return to direct road or read-only mode
- update passport state
- require Final Judge before reopen

## 20. Final close

The Full Wash helper can wash almost anything by classification, routing, trace, proof planning, and close.

It can act only through approved adapters.

Its first body movement is evidence custody, not execution.

It learns by rope, receipt, wash, ledger, and promotion.

It grows by earned capability, not broad permission.

Final verdict:

FULL_WASH_CYCLE_HELPER_HARNESS_SPEC_V1 fits the house as a narrow build spec.

Boundary held:

No code.
No helper execution.
No bypass.
No dashboard.
No automation.
No doctrine.
No ACTIVE_GUIDES.
No CURRENT_TRUTH_INDEX.
No broad helper manager.

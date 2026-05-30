# Dual-Shell Tandem Gate Bridge Session Protocol V1

Date: 2026-05-30
Status: SUPPORT PROTOCOL / DESIGN ONLY / NOT IMPLEMENTATION
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## 0. Focal law

One visible operator shell and one visible gate shell work in tandem under one visible session.

The operator shell is session authority.

When the operator shell is open, the bridge may be open.
When the operator shell is closed, the gate shell must close, park, or stop.
When operator side runs, gate side may work only through keyed packets.
When gate side runs, operator side receives visible state and receipts.

No hidden watcher.
No off-session helper.
No first-file trigger.
No script implementation in this protocol.

## 1. Roles

### Operator Shell

Role:
user authority surface.

May:
open session, submit packet, acknowledge receipt, pause session, close session.

May not:
silently grant broad authority by having a window open.

### Gate Shell

Role:
visible paired gate side.

May:
pair to an open session, read only session packets, route through Gate-for-Gates, run allowed bounded gate work, write receipts, stop/park on close.

May not:
watch the whole screen, read arbitrary terminal scrollback, run off-session, process unkeyed work, continue after close.

### Session Blackboard

Role:
middle lane for typed session state.

Contains:
session state, packets, claimed packets, running markers, receipts, acknowledgements, invalid packets, dead letters, parked-on-close records, logs.

May not:
become a trash folder.

### Gate-for-Gates Router

Role:
reads packet, validates it, checks key/ledger/map, checks session state, checks lock group, routes to specialist gate, writes route receipt.

May not:
do all work itself, invent missing authority, ignore missing return surface.

### Specialist Gate

Role:
performs one bounded gate job.

Examples:
Hash Intake Gate, Frame Contract Test Gate, Code Gate Runner Gate, Receipt Summary Gate, Pending Bay Gate, Dead Letter Review Gate.

### Final Judge

Role:
closes packet state after receipt, boundary proof, and next action.

## 2. Session state machine

Valid states:

SESSION_CLOSED
SESSION_OPENING
OPERATOR_READY
GATE_PAIRING
GATE_READY
PACKET_READY
PACKET_CLAIMED
GATE_ROUTING
GATE_RUNNING
RECEIPT_READY
OPERATOR_ACK_REQUIRED
OPERATOR_ACKED
SESSION_PAUSED
SESSION_CLOSING
PARKED_ON_SESSION_CLOSE
SESSION_CLOSED_CLEAN
SESSION_CLOSED_WITH_PARKED_WORK
SESSION_BLOCKED

## 3. State transition rules

SESSION_CLOSED -> SESSION_OPENING:
operator intentionally opens the bridge session.

SESSION_OPENING -> OPERATOR_READY:
operator shell exists and session id is created.

OPERATOR_READY -> GATE_PAIRING:
gate shell is opened and receives session id.

GATE_PAIRING -> GATE_READY:
gate shell confirms same session id and blackboard path.

GATE_READY -> PACKET_READY:
a keyed packet exists in the session inbox.

PACKET_READY -> PACKET_CLAIMED:
gate shell acquires packet claim lock.

PACKET_CLAIMED -> GATE_ROUTING:
packet passes shape, key, return surface, and blocked-action checks.

GATE_ROUTING -> GATE_RUNNING:
specialist gate route is selected and allowed.

GATE_RUNNING -> RECEIPT_READY:
receipt exists with status, output paths, boundary, and next action.

RECEIPT_READY -> OPERATOR_ACK_REQUIRED:
packet requires operator acknowledgement.

OPERATOR_ACK_REQUIRED -> OPERATOR_ACKED:
operator acknowledges receipt.

OPERATOR_ACKED -> GATE_READY:
gate can accept the next packet.

Any active state -> SESSION_PAUSED:
operator pauses; gate stops accepting new packets.

Any active state -> SESSION_CLOSING:
operator closes session or close packet is submitted.

SESSION_CLOSING -> PARKED_ON_SESSION_CLOSE:
work cannot cleanly finish before close and must be parked with reason.

SESSION_CLOSING -> SESSION_CLOSED_CLEAN:
no active work remains and close receipt exists.

SESSION_CLOSING -> SESSION_CLOSED_WITH_PARKED_WORK:
parked work exists and receipt lists it.

Any invalid state -> SESSION_BLOCKED:
state mismatch, missing receipt, stale session id, or unsafe ambiguity.

## 4. Session folder layout

Design target only; no implementation created here.

COMMAND_CENTER/DUAL_SHELL_TANDEM/SESSIONS/<SessionId>/

STATE/
INBOX/
CLAIMED/
RUNNING/
RECEIPTS/
ACKED/
INVALID/
DEAD_LETTER/
PARKED/
ARCHIVE/
LOGS/

## 5. Packet contract

Every packet must include:

SessionId
PacketId
PacketHash
PacketType
CreatedAt
CreatedBy
OperatorShellId
GateShellId
KeyCode
FrameId
RequestedGate
AllowedRoot
AllowedReads
AllowedWrites
BlockedActions
Mode
Priority
LockGroup
ExpectedReceipt
ReturnSurface
StopCondition
OperatorAckRequired
MaxRuntime
MaxOutputSize
RetryPolicy
InvalidMessageLane
DeadLetterLane
CloseBehavior
TerminalOutputPolicy

Invalid if missing:
SessionId, PacketId, KeyCode, RequestedGate, AllowedRoot, BlockedActions, ExpectedReceipt, ReturnSurface, StopCondition.

## 6. Packet types

HASH_INTAKE_REQUEST
FRAME_CONTRACT_TEST_REQUEST
CODE_GATE_REQUEST
RECEIPT_SUMMARY_REQUEST
OPEN_LANE_CAPTURE_REQUEST
PENDING_BAY_BUNDLE_REVIEW_REQUEST
DEAD_LETTER_REVIEW_REQUEST
SESSION_CLOSE_REQUEST
NO_SCRIPT_DECISION

## 7. Receipt contract

Every receipt must include:

SessionId
PacketId
ReceiptId
PacketHash
GateId
StartedAt
EndedAt
Status
Verdict
OutputFiles
OutputHashes
Warnings
Blockers
BoundaryHeld
NextAction
OperatorAckRequired
ReturnSurface
CloseState
FinalJudge

Valid receipt statuses:

PASS
PASS_WITH_WATCH
BLOCKED
FAILED
INVALID_PACKET
DEAD_LETTERED
PARKED_ON_SESSION_CLOSE
NEEDS_OPERATOR
SESSION_CLOSED

## 8. Gate-for-Gates router behavior

Router steps:

1. read packet from claimed lane;
2. validate packet schema;
3. validate session state;
4. validate key/ledger/map route;
5. validate allowed root/read/write/blocked actions;
6. validate return surface and expected receipt;
7. validate lock group and active packet limit;
8. choose specialist gate;
9. write route decision;
10. invoke only the allowed bounded route;
11. require receipt;
12. return to session blackboard;
13. stop.

Router must not:

read whole screen;
read arbitrary terminal transcript;
invent missing fields;
run unkeyed packet;
run broad root crawl;
continue off-session;
skip receipt;
promote helper/tool.

## 9. Specialist gate boundaries

Every specialist gate declares:

GateId
AllowedPacketTypes
AllowedRoots
AllowedReads
AllowedWrites
BlockedActions
ProofRequired
StopCondition
OutputLane
ReceiptSchema
MaxRuntime
MaxOutputSize
CloseBehavior

## 10. Terminal-safe copyback

Terminal is display, not memory.

Full reports go to files.
Shell prints minimal status only.
Status should be safe to accidentally paste.

Preferred shell status shape:

# GATE PASS: receipt=<path>
# GATE WATCH: report=<path>
# GATE BLOCKED: receipt=<path>
# GATE FAILED: receipt=<path>
# SESSION CLOSED: receipt=<path>

No long report text in command lane by default.

## 11. Close cascade

On operator close or explicit close packet:

1. set SESSION_CLOSING;
2. stop accepting new packets;
3. inspect active packet;
4. if no active packet, write clean close receipt;
5. if active packet is safe to stop, stop and receipt;
6. if active packet cannot safely stop, park with PARKED_ON_SESSION_CLOSE;
7. write close receipt;
8. move/mark session closed;
9. gate shell exits or returns to closed idle state.

No off-session work.

## 12. Failure lanes

Invalid packet:
missing fields, wrong session id, missing return surface, blocked action, bad key route.

Dead letter:
packet cannot complete after allowed route or retry policy.

Parked-on-close:
operator session closed before safe completion.

Blocked:
unsafe ambiguity, stale state, or proof mismatch.

Failure never continues silently.

## 13. Governors

MaxActivePackets:
default 1 for V0/V1.

MaxParallelGates:
default 1 until proven otherwise.

MaxRuntime:
packet-defined.

MaxOutputSize:
packet-defined.

LockGroup:
prevents conflicting work.

CircuitBreaker:
after repeated blocked/failed packets, require operator review.

Bulkhead:
separate lock groups for unrelated gates.

## 14. Version ladder

V0 — Manual Split Tandem:
two visible panes; operator manually submits; gate manually processes one packet.

V1 — File Packet Tandem:
gate processes explicit packet folder; no background watcher.

V2 — Visible Waiting Gate:
gate waits only inside one open session folder; still visible and session-tethered.

V3 — Session-Tethered Launch:
operator shortcut opens both panes and session folder; close cascade active.

V4 — Gate-for-Gates Router:
router selects specialist gates by key/ledger/map.

V5 — Receipt Dashboard:
local visible receipt summary; no broad automation.

V6 — Named Pipe Upgrade:
only after file packet protocol proves stable; named pipe is transport, not authority.

## 15. Hard blocks

No hidden watcher.
No broad terminal reader.
No screen scrape.
No off-session helper.
No detached job by default.
No first-file trigger.
No unkeyed packet.
No packet without return surface.
No receiptless close.
No named pipe in V0/V1.
No tool install from this protocol.
No .cmd launcher from this protocol.
No script implementation from this protocol.

## 16. Pass condition for this protocol

A human can read this protocol and know:

what opens the session;
what closes it;
what the operator shell owns;
what the gate shell owns;
what the middle blackboard holds;
what a packet requires;
what a receipt requires;
how a packet routes;
how close cascade works;
what is blocked.

## 17. Next clean move after save

Manual V0 session packet worksheet.

Goal:
prove that one explicit packet can be framed, claimed, routed, receipted, acknowledged, and closed without implementation or hidden behavior.

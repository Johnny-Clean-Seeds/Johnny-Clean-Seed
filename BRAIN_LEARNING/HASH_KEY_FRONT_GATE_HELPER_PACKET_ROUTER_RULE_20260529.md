# Hash-Key Front Gate Helper Packet Router Rule

Status: SUPPORT ARCHITECTURE / LIVING IDEA
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX; not automation

## Rule

The house should not make every helper read every file or push every lane.

The Front Gate reads the wider map, hash-key ledger, helper capability cards, parked logic labels, current state, proof receipts, and living helper ledgers. It then emits one small helper packet at a time.

The helper receives only what is needed for its narrow job.

## Core loop

`TASK / EVENT -> FRONT_GATE -> PACKET -> START_CHECK -> HELPER_WORK -> AFTER_PROOF -> STOP_REASON -> HANDOFF_PACKET -> LIVING_LEDGER -> FRONT_GATE`

## Front Gate duties

- classify the task/event;
- identify the active rope;
- search the hash-key ledger;
- identify relevant parked logic;
- select the smallest competent helper;
- create one bounded packet;
- name allowed actions and blocked actions;
- name proof needed;
- name ledger target;
- name next handoff options;
- block or no-start when the lane is not ready.

## Boundary

The Front Gate is not a broad crawler, not an autonomous actor, and not a doctrine engine. It plans and routes. Helpers act only from packets.

## Proof of use

A valid first implementation is read-only: `FRONT_GATE_PACKET_PLANNER_V0` creates one helper packet or one no-start packet from one active task.
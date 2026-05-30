# Front Gate Packet Planner V0 Read-Only Next Use TODO

Status: TODO / NEXT USE / READ-ONLY FIRST

## Next use

Build or run `FRONT_GATE_PACKET_PLANNER_V0` only as read-only planner.

## It receives

- one active task text;
- current rope;
- helper capability cards if present;
- helper living ledger map if present;
- relevant hash-key ledger entries if present.

## It outputs

- job type;
- recommended helper;
- can start / cannot start;
- start blocker if any;
- one helper packet or one no-start packet;
- proof required;
- allowed stop reasons;
- next helper candidate;
- living ledger target.

## Boundary

No edits. No Git. No moves. No deletes. No automation. No broad scan.
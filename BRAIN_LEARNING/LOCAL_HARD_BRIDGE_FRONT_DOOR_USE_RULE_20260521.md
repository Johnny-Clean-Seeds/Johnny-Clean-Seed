# Local Hard Bridge Front Door Use Rule

Date: 2026-05-21
Lane: BRAIN_LEARNING
Status: SUPPORT RULE / TOOL USE BOUNDARY / NOT DOCTRINE

## Purpose

Future assistants must know how to use the Local Hard Bridge front door without treating it as authority or an open PC shell.

The bridge is a local PowerShell-backed actuator for allowlisted actions. It is a carrier, proof surface, and front-door sensor. It is not Mr.Kleen authority.

## Current bridge

Bridge root:
C:\\Users\\13527\\Desktop\\123\\TOOLS\\LOCAL_HARD_BRIDGE_V1

Run once tool:
C:\\Users\\13527\\Desktop\\123\\TOOLS\\LOCAL_HARD_BRIDGE_V1\\TOOLS\\RUN_BRIDGE_ONCE.ps1

Current fixed runner SHA256:
613442DDB0C4A8850BA17B0B8E2BE8D71A9706B9692A2251B748CC5373567106

Policy SHA256:
574572C92D1E082F2A74EBBA01113468AD6BBA371595DE69CEC8B05FD7FA2A5D

Readme SHA256:
FD3ACD9954E906075CAEA4FBAE03E31D906E0D2C05AB9DD2204262A853897D72

Git sensor repair receipt SHA256:
CFF885DD18E784D1DAAC641650EAAA497466C7894AFC13EC794DE7FAFE7F5A83

## Use order

1. Treat the bridge as local-only support.
2. Create or inspect request files in HUB/REQUESTS only when needed.
3. Run RUN_BRIDGE_ONCE manually from PowerShell.
4. Read HUB/RESPONSES and HUB/RECEIPTS.
5. Trust only outputs that pass their own proof and boundary checks.
6. For house work, always read house_front_door before action.
7. If git status is not clean, stop or diagnose before writing.

## Front door check

The first bridge request for nontrivial house work should be house_front_door.

The response must show:
- house_root;
- branch;
- HEAD;
- short;
- origin/main;
- clean true or explicit status lines;
- ACTIVE_ANCHOR exists;
- CURRENT_TRUTH_INDEX exists.

If the response shows git usage text, missing fields, ok true with nonsense output, or stale root, the bridge has failed and must be repaired before use.

## Allowed use in V1

- write/read/hash inside bridge WORKSPACE;
- read/list/hash house files;
- read house git front door;
- produce receipts;
- support request/response flow.

## Blocked in V1

- no arbitrary shell;
- no delete;
- no overwrite;
- no house write;
- no git commit;
- no git push;
- no network service;
- no treating local bridge receipts as house proof unless mapped to a house save.

## House placement

Bridge rules belong in BRAIN_LEARNING and GEAR_RACK support cards.

Bridge results that matter to Mr.Kleen should be saved through normal house save gates with receipt and git proof.

Local bridge files in 123 are local-only tool material until intentionally imported or referenced in a house receipt.

## Relation to Assistant-Mule Exchange Bridge

Local Hard Bridge V1 moves between chat logic and the user's PC.

Assistant-Mule Exchange Bridge moves between assistant and mule inside Mr.Kleen.

These bridges are neighbors, not the same bridge and not authority.

## Failure classes to watch

- false success from tool output;
- stale root pointer;
- dirty house front door;
- path separator mismatch;
- long path failures;
- helper left loose after proof;
- support tool trying to become rule king.

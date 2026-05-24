# Existing Structure Inspection Before Invention Gate

Date: 2026-05-24
Status: BRAIN LEARNING / active support gate.

## Rule

Before creating a new room, rule, tool, protocol, or workflow, inspect whether the house already has a matching or neighboring structure.

Do not start from invention when the house may already contain the organ.

## Trigger

This gate fires when:

- the user asks to "find a way" or "make a gate";
- the assistant notices a recurring workflow problem;
- a new idea sounds like an existing room, lane, or tool family;
- the task touches intake, mail, porch, source custody, proof, parking, mule work, active guides, or root cleanup;
- a dropped file says the assistant may be missing existing structure.

## Minimum Walk

1. Name the desired function.
2. Search file names for exact and near matches.
3. Search current rule text for the function words.
4. Read the nearest existing structure before proposing a new one.
5. Decide whether to reuse, repair, extend, or create.
6. If creating, explain why the existing structure is not enough.

## Verdicts

- REUSE: existing structure works as-is.
- REPAIR: existing structure is right but broken or stale.
- EXTEND: existing structure works but needs one small addition.
- CREATE: no clean structure exists.
- PARK: idea is good but not needed now.

## Clean Pattern

Function wanted -> search house -> inspect nearest lane -> repair or extend -> only create if needed.

## Bad Pattern

Function wanted -> invent new doctrine -> later discover a half-working room already existed.

## Live Proof

The inbox request initially looked like a new process request. Inspection found an existing `MAIL_ROOM` and active one-shot tools. The right move was not to invent a second inbox, but to repair the existing mail room path logic and add a pulse-priority protocol around it.

The user's root drop `insepction.txt` correctly identified this as a broader missing gate. The dropped file was moved into:

`MAIL_ROOM\PROCESSED\ROOT_DROP_insepction_triaged_20260524.txt`

Source SHA256:

`7FFEE40A621ED6BD962A6C9C02B41351610C543128106E806D2E69E65DB4E9E3`


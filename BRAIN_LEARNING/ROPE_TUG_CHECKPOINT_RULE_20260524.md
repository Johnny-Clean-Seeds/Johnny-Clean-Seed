# Rope Tug Checkpoint Rule

Date: 2026-05-24

Status: active support rule / fog checkpoint.

## Rule

Tug the rope when the path is foggy enough that the next move might detach from source, proof, room,
or final destination.

A tug is a checkpoint, not a panic. It pulls the worker back to the live route.

## Trigger

Tug the rope when any of these happen:

- the active object cannot name why it is still active;
- the current note reaches rope-note visibility Level 3 or higher;
- the review list grows but the next boss is unclear;
- the room, owner, authority, proof, or final destination is uncertain;
- a note is about to be burned, cut, promoted, parked, or rejected;
- the soft suit is carrying more than three live candidates;
- the working tree, porch, root drop zone, or local-only split is dirty or mysterious;
- a schedule, return trigger, or quiet-down condition is missing;
- a user correction repeats a prior failure;
- continuing would risk false PASS, destructive cleanup, privacy leak, authority drift, or lost
  source custody.

## Tug Levels

| Level | Name | Use |
|---|---|---|
| 1 | Grip check | Quick object, room, next move, close condition. |
| 2 | Checkpoint tug | Source/proof/owner/final destination must be named before movement. |
| 3 | Gate tug | Stop and resolve proof, authority, safety, or destructive-action risk. |

Use the smallest tug that clears the fog.

## Tug Card

Every tug should be able to answer:

- Active object:
- Current room:
- Source or root:
- Owner rule or support link:
- Visibility level:
- Why tug now:
- Allowed next move:
- Blocked move:
- Proof needed:
- Quiet-down condition:
- Return trigger:
- Final destination:

## Clean Pattern

`fog -> tug -> object/source/room/proof named -> next move allowed or blocked -> note quiets`

## Dirty Pattern

- Tugging every note until the workflow stalls.
- Using tug as permission to keep exploring forever.
- Calling a tug complete without naming the final destination.
- Letting a loud note bypass source proof.

## Relation

This supports Rope Note Weight Visibility Gate, Note Burning Deadweight Release Rule, Active Object
Release And Signal Discipline Rule, Git Dirty Tree Disposition Before Lock/Save Rule, and Washer
Return Habit Loop Rule.

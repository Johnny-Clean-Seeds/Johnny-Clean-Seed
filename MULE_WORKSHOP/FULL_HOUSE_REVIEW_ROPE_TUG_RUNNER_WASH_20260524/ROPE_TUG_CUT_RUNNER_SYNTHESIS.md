# Rope Tug Cut Runner Synthesis

Status: SYNTHESIS / SUPPORT ONLY
Date: 2026-05-24

## Core Model

The rope is the active route.

Notes are tied to the rope.

Tugs are checkpoints when the route is foggy.

Cuts release active weight only after a runner trace preserves the path to root.

## Flow

```text
task
-> active object
-> source/root
-> room
-> note visibility
-> tug if foggy
-> classify
-> map zoom
-> decision
-> place
-> burn or cut
-> runner trace
-> wash
-> final destination
```

## Note Loudness

Notes get louder through:

- active-task fit;
- source/proof fit;
- fog pressure;
- repeated live failure;
- time-risk;
- neighbor-rule fit;
- user correction.

Notes get quieter through:

- proof;
- placement;
- parking with trigger;
- rejection-as-active;
- blocked status;
- receipt;
- source custody.

Age alone is not weight.

## Tug Rule In One Line

Tug when the next move might detach from source, proof, owner room, authority, or final destination.

## Cut Rule In One Line

Cut only after a runner trace can walk backward to root and forward to final destination.

## Runner Trace Minimum

Minimum trace:

```text
object id:
source/root:
relation word:
owner room:
linked rule:
final destination:
proof/receipt:
return trigger:
quiet-down condition:
```

## Final Destinations

A note may route to:

- final rule;
- checklist or template;
- evidence ledger;
- parked item;
- rejected-as-active item;
- blocked item;
- receipt line;
- source custody;
- TODO or next-use trigger;
- local-only hold;
- no-return release with proof.

## Bad Ideas Rejected

- "Everything links to everything" as a full graph requirement.
- "Cut" as delete.
- "Burn" as erase.
- "Tug" as constant hesitation.
- "Time" as authority.
- "Research" as adoption.
- "A clean-sounding metaphor" as proof.

## Clean Ideas Kept

- Rope as the working spine.
- Notes as bounded visibility signals.
- Checkpoints to prevent fog.
- Time-risk as one input, not the whole rule.
- Runner trace as a root map after release.
- Washer as a repeated habit, not just a final ceremony.
- Sorting, mapping, and scheduling as one stack.

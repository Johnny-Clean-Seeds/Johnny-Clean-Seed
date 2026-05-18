# Runtime Kernel Combined Promotion Gate

## Purpose

Define the gate that must be passed before any Runtime Kernel Soft Suit candidate can move toward Hard Suit or active runtime build.

This gate protects against promoting one good-looking candidate without checking neighbor effects.

## Candidate group

The current Runtime Kernel Soft Suit trio is:

1. Universal State Machine
2. Single System Ledger
3. Parent/Child Map

## Core rule

The trio may not be promoted separately just because each candidate looks useful.

Promotion requires combined proof.

## Promotion requirements

Before any candidate moves toward Hard Suit, all of these must be true:

1. The candidate has a named job.
2. The candidate has a clear lane.
3. The candidate has a proof path.
4. The candidate does not replace proof.
5. The candidate does not create authority by itself.
6. The candidate does not skip Soft Suit.
7. The candidate does not create /system by implication.
8. The candidate does not create commands by implication.
9. The candidate does not collapse source ore, proof, ledger, map, guides, or suit files into one pile.
10. The candidate passes neighbor-effect testing with the other two candidates.

## Combined neighbor checks

### Universal State Machine

Must prove:

- it defines legal movement only
- it does not become ledger
- it does not become parent/child map
- it does not authorize promotion by itself
- it prevents bad jumps

### Single System Ledger

Must prove:

- it records events only
- it remains pointer/index spine
- it is not proof
- it is not authority
- it does not replace parent/child containment
- it does not become a junk drawer

### Parent/Child Map

Must prove:

- it records containment/reporting only
- it is not proof
- it is not authority
- it does not replace ledger movement
- it does not flatten lanes
- it does not allow parent/child authority confusion

## Forbidden promotion

Do not promote if:

- any one candidate needs the others to make sense but is being promoted alone
- ledger starts acting like proof
- map starts acting like authority
- state machine starts acting like a command engine
- /system would be created before the live-build gate
- commands would be created before the command gate
- Hard Suit active pack slots would be filled without proof
- support links are treated as active pack slots
- failed proof is ignored or hidden

## Gate verdicts

Allowed verdicts:

- PASS
- FAIL
- PARTIAL
- BLOCKED
- PASS WITH HOLD

## PASS meaning

PASS means the gate is well-defined and can be used for later promotion testing.

PASS does not mean the Runtime Kernel trio is promoted.

## PASS WITH HOLD meaning

PASS WITH HOLD means the gate works, but promotion is still held until a separate promotion proof or live-build gate is run.

## Close condition

This gate passes only if it protects Soft Suit, Hard Suit, proof, authority, source ore, ledger, map, and state boundaries at the same time.

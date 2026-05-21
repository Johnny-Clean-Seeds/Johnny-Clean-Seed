# Intake Ledger Ouroboros Card

## Status

Rule-machine support card.

## Core Order

Data Collection -> Inventory -> Housekeeping -> Data Management -> Workflow -> Data Collection

## One-Line Machine

Collect. Count. Clean. Manage. Move. Return.

## Core Ledger Claim

Stale checking improves when intake identity is unavoidable.

A separate checker is weaker than a system where every entering object has custody.

## Intake Object Fields

Each entering object should eventually be able to carry:

- object ID
- human label
- source
- entry time
- type
- lane/room
- content hash when applicable
- parent ID
- stack ID
- relation links
- proof level
- status
- next allowed action
- owner/actor if relevant
- collapse target if merged
- retirement reason if retired

## ID Direction

Do not rely on pi or golden ratio for proof uniqueness.

Golden ratio or pi may be explored as naming flavor, rhythm, sequence aesthetics, or human-facing style.

Proof identity should rely on:

- timestamp
- monotonic counter
- short human label
- content SHA256
- optional UUID-style entropy

Example:

Human ID:
BITE-PHI-000021

Custody ID:
20260521-000021-RULEBLOOM

Proof:
SHA256 content hash

Relation:
parent stack ID + collapse target ID

## Stale Warning Flags

Flag an object as stale/suspicious when:

- no ledger entry
- no source
- no hash for hashable content
- wrong hash
- outdated parent
- duplicate active role
- broken relation
- unplaced file
- active object with no status
- workflow action without inventory
- collapsed rule with missing parent stack
- source ore treated as authority
- Soft Suit treated as Hard Suit without proof

## Rule Bloom Relation

When an issue is addressed:

1. collect it
2. inventory it
3. place it
4. manage proof/status
5. route the next action

When a stack appears:

1. give stack identity
2. preserve item identities
3. group without early collapse
4. watch firing evidence
5. collapse only after pattern proof

## File-First Relation

Large work should travel as a file packet when practical.

Chat steers.
Files carry the pile.
Receipts prove the route.

## Next Live Test

Use this card on the next incoming bulky file, rule stack, source-ore packet, or correction cluster.

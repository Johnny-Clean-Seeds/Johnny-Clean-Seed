# Proof Hash Custody and Parked Carryover Rule

Date: 20260527

## Status

Living proof workflow rule.

Not doctrine.
Not a new boss.
Not a new gate.
Not transcript material.
Not source material.

## Problem

A hash, PASS statement, or proof claim dropped only in chat is not durable house proof.

It may help immediate comparison, but it does not live in the house unless it is written into a receipt, manifest, proof file, index, or local custody report.

## Rule 1 - No chat-only proof theater

Do not make hashes or PASS claims look stronger than their custody.

If a hash is created, state:

- the exact object hashed;
- the object path or custody location;
- where the hash is saved;
- what the hash proves;
- what it does not prove.

If the hash is only in chat, call it temporary or do not create it.

## Rule 2 - Park proof instead of making extra saves

Do not create a separate file save only to preserve one chat hash or one small PASS claim.

Use parked proof-bundle carryover:

1. mark the item as pending proof;
2. keep the compact pointer;
3. include it in the next appropriate save receipt or manifest;
4. only then call it durable house proof.

## Parked proof fields

A parked proof item should carry:

- object name;
- object path or custody location;
- hash or PASS claim if available;
- date/time or context;
- why it was parked;
- where it should be written next;
- whether it is temporary chat proof or already saved proof.

## Next-save receipt fields

When a parked proof item is written into a later save receipt, include:

- old object name;
- old object path;
- parked hash/PASS;
- reason it was parked;
- new object name;
- new files saved;
- commit/push/remote/final-clean proof.

## Boundary

Parked proof is not full house proof yet.

It becomes durable only when written into the proper receipt, manifest, proof file, index, or custody report.

## Short form

Park small proof. Save it with the next real object.

# Child Shell + Recursive Core Architecture

## A small safe bridge for useful local AI work

Most AI-to-computer systems lean toward one of two extremes.

One side is chat-only: useful reasoning, no local action.

The other side is broad computer control: powerful, but harder to bound, audit, and explain.

**Child Shell** is a smaller middle layer.

```text
AI request -> policy gate -> child action -> local function -> response + receipt
```

The assistant does not receive raw terminal access.

It can only request named child actions. The local bridge checks policy, runs only the bounded function, then returns proof.

## Why this matters

The goal is not to make the AI more powerful.

The goal is to place intelligence cleanly.

Recursive Core Architecture says drift is caused by unplaced intelligence: intelligence without clean name, lane, boundary, authority, evidence, verdict path, and close condition.

Child Shell is that idea applied to local machine work.

## Proof status

Child Shell V1 passed an all-evidence test:

- allowed workspace write passed;
- overwrite blocked;
- raw shell blocked;
- path traversal blocked;
- `.ps1` write blocked;
- read-only file read/hash worked;
- state remained clean before and after;
- receipts and hashes were produced.

## Precise claim

A bounded local bridge can expose named child actions instead of raw terminal access, perform allowed work, block unsafe requests, produce auditable proof, and leave the working state clean.

Prototype behavior is proved.

Production hardening is not claimed yet.

# Provenance / Chain-of-Custody Thread Lens

State: Soft Suit candidate.
Created: 2026-05-19.
Starting local/brain position: main @ 907125b.

## Job

This lens helps trace where an artifact came from, what fed it, what changed it, what proof anchors it, and whether the next worker can trust the chain without pretending the lens itself is doctrine.

It is a paper-holding tool. It is not an authority file.

## Use When

Open this lens when a task has one or more of these risks:

- Several inputs fed one output.
- A receipt, review, note, or artifact may be confused with doctrine.
- A user handoff, assistant handoff, mule/Codex output, web/source-ore item, or anomaly thread needs clean custody.
- A candidate may be promoted too early because it looks useful.
- A future worker needs to know what is source, what is transform, what is proof, and what is only parked evidence.
- A public/local boundary, proof-history boundary, or Soft Suit boundary could be blurred.

## Do Not Use When

Do not open this lens for tiny mechanical changes with one obvious source, one obvious output, and no promotion/proof/authority risk.

## Thread Fields

For a chain to be clean, name these fields:

1. Source: where the material came from.
2. Intake: why it was brought into the house.
3. Transform: what was done to it.
4. Output: what artifact was produced.
5. Proof: what evidence checks the output.
6. Save point: what commit/hash or receipt anchors the chain.
7. Boundary: what the output is not allowed to become yet.
8. Missing link: any gap, unknown, weak proof, or untraced handoff.
9. Verdict: pass, fail, partial, blocked, or park.

## Pass Shape

A chain passes this lens only when the source, transform, output, proof, save point, and boundary can be named without guessing.

## Fail Shape

A chain fails this lens when an artifact exists but its source is vague, its proof is missing, its boundary is unclear, its receipt cannot be found, or the worker cannot tell whether it is source ore, support, proof, doctrine, runtime, or active authority.

## Boundary

This is Soft Suit only.

It does not install doctrine.
It does not rewrite active guides.
It does not create runtime automation.
It does not replace proof receipts.
It does not promote bitstring work.
It does not make a candidate authoritative.
It only helps hold the chain cleanly before a later decision.

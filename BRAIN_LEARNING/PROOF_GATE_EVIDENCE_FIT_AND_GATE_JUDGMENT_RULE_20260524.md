# Proof Gate Evidence-Fit And Gate-Judgment Rule

Status: SUPPORT GATE / PROOF FIT / NOT DOCTRINE
Date: 2026-05-24

## Purpose

Make Proof Gate usable as a clean, repeatable support gate.

The Proof Gate does not ask only, "does evidence exist?"

It asks:

`Does this proof fit this claim, at this point in the gate run, without letting the proof gate do another gate's job?`

## How This Was Found

Found during the 2026-05-24 house evidence and gate inspection.

Signals:

- `proof gate` appeared across many files and lanes;
- `fake PASS`, `PASS without`, and `skip proof` were high-pressure repeated patterns;
- active guides already contain Logic Proof Gate and Proof Ledger Lock;
- support rules already warn that proof gates may block fake PASS but must not kill unproven growth;
- recent puzzle/worker reviews needed a practical proof card for same-issue rerun, source custody, receipts, and gate behavior.

Finding:

The house already had proof doctrine and proof language. The missing support shape was a small Proof Gate that checks claim-proof fit and gate role fidelity in one live-use card.

## Placement

Use after Evidence / History has gathered support and before any claim of:

- PASS;
- done;
- clean;
- saved;
- locked;
- proven;
- flatline;
- promotion;
- gate correctness;
- "all ideas are intact";
- "no issue remains."

Final Judge still opens and closes the gate run.

Proof Gate supplies evidence-fit judgment for the current claim. It does not replace Final Judge.

## Trigger

Fire when:

- a result is called PASS, done, clean, saved, locked, verified, or proven;
- a support rule, card, template, receipt, or gate is added;
- the user asks whether ideas, files, evidence, maps, signs, gates, or concepts are intact;
- a gate run says flatline;
- a previous rule was named but not applied;
- a worker, script, mule, helper, or assistant gives a claim that depends on evidence;
- something goes wrong and the cause must be diagnosed before repair.

## Inputs

Required inputs:

| Field | Meaning |
|---|---|
| Active claim | The exact claim being judged. |
| Claim type | File state, concept coverage, gate behavior, source custody, fix effect, promotion, flatline, or final trust. |
| Proof object | The file, receipt, hash, command output, same-issue rerun, manifest, ledger, or observed behavior offered as proof. |
| Proof burden | Light, normal, high, final trust, or promotion-level. |
| Source custody | Where raw source lives and whether it may be used as authority. |
| Disproof test | What would show the claim is false. |
| Gate role | What this gate may judge and what it must not judge. |

## Checks

1. Does the proof object match the active claim?
2. Is the proof current enough for the claim?
3. Is the proof direct, or only supporting/indirect?
4. Does the claim require row-by-row ledger proof, same-issue rerun, hash proof, receipt proof, or behavior proof?
5. Does the proof show the rule/gate acted, or only that it exists?
6. Did the proof gate accidentally act as source gate, disproof gate, cleanup gate, promotion gate, or Final Judge?
7. Is unproven material being treated as disproven?
8. Is a receipt being treated as proof of more than it actually records?
9. Is the proof burden scaled to the risk?
10. Is the next state closed, parked, blocked, yielded, or watched with a return trigger?

## Verdicts

- PASS: proof fits the claim and burden.
- PASS WITH GUARDRAILS: proof is enough for bounded use, with named watch item.
- PARTIAL: some proof fits, but at least one required proof surface is weak.
- INVALID: available proof cannot prove the claim.
- YIELD: user judgment, missing access, or external confirmation is needed.
- BLOCKED: the claim cannot safely proceed.
- PARKED: useful but not active or not ready.

## Blocked

Proof Gate must not:

- kill a live candidate merely because it is unproven;
- promote source ore because a receipt exists;
- treat a hash as proof of semantic quality;
- treat a report as proof that every dependent file was checked;
- require final-trust proof for a low-risk support note;
- let a nice explanation count as behavior proof;
- accept "rule exists" as "rule fired";
- allow PASS when evidence only supports PARTIAL or GUARDRAILS.

## Creative Gate Relationship

Creative Gate may spawn candidate ideas, routes, tools, analogies, or unusual options.

Proof Gate judges only the proof claims attached to those candidates.

Creative output is not proof.

Proof output is not creativity.

They are neighbors.

## Same-Issue Rerun

When the proof claim is "this fixed the problem," the best proof is a same-issue rerun.

Required question:

`Did the same problem behave better after the fix, or did we only make a cleaner note about it?`

## Boundary

- Not doctrine.
- Not an ACTIVE_GUIDES rewrite.
- Not a CURRENT_TRUTH_INDEX rewrite.
- Not public authority.
- Not a cleanup or deletion permission.
- Not a replacement for Final Judge, Gate Judge, Evidence / History, or Deep Clean.

## Proof

Proof of this support gate is future live use where it:

- prevents fake PASS;
- catches proof/object mismatch;
- keeps unproven candidates alive but unpromoted;
- forces same-issue rerun when a fix claim needs it;
- gives the Final Judge a cleaner proof object to close.

# Creative Room Outside Idea Ledger

Status: OUTSIDE RESEARCH WASH / SUPPORT ONLY
Date: 2026-05-24

## Purpose

Use outside decoding and systems ideas against the house, keep what improves the house, and reject
anything that would become a foreign boss or fake precision.

## Sources Checked

| Source | Clean outside idea | House use |
|---|---|---|
| W3C PROV-DM, https://www.w3.org/TR/prov-dm/ | Provenance can track entities, activities, agents, and derivation. | Turn "how found" into a small provenance passport: source, activity, actor/tool, evidence, derived decision. |
| W3C SKOS Reference, https://www.w3.org/TR/skos-reference/ | Notes and semantic relations can be modeled with controlled relation types. | Keep a small relation vocabulary: parent, child/checkpoint, neighbor, source, proof, parking, blocks, promotes. |
| MIT STPA Primer, https://psas.scripts.mit.edu/home/wp-content/uploads/2013/10/An-STPA-Primer-version-0-4.pdf | Unsafe control actions include missing, wrong, too early/late/out of sequence, or stopped too soon/held too long. | Before moving or promoting a note/rule, ask whether the control action is missing, wrong, mistimed, or held too long. |
| Google SRE Monitoring Distributed Systems, https://sre.google/sre-book/monitoring-distributed-systems/ | Human alerts should have high signal, low noise, and be actionable. | Rope notes get louder only when they change a move; low-signal notes stay findable but quiet. |
| NASA Systems Engineering Handbook, https://www.nasa.gov/reference/systems-engineering-handbook/ | Complex systems need configuration management, verification, validation, and lifecycle discipline. | Treat house changes as configuration changes with baseline, affected scope, proof, and closeout. |
| Design Council Double Diamond, https://www.designcouncil.org.uk/resources/framework-for-innovation/ | Explore widely, define clearly, develop alternatives, deliver tested output. | Creative room gets a clean rhythm: widen, narrow, widen again, test, then wash. |
| Diataxis, https://diataxis.fr/ | Documentation types serve different user needs and should not blur. | Do not make one note serve as source, rule, proof, how-to, explanation, and receipt. Split lanes. |
| ADR family, https://github.com/adr | Decision records preserve important decisions with context and consequences. | Promotion or parking decisions should have a short decision record when they affect house structure. |

## Adopted

1. Provenance passport:

Every trust-affecting note or fix should be able to say what source became what decision by which
activity, evidence, and actor/tool.

2. Controlled relation vocabulary:

Keep relationship words small and legal. A note can be `source`, `checkpoint`, `neighbor`, `proof`,
`parking`, `blocker`, or `promotion candidate`; it should not invent a new authority class casually.

3. Unsafe control action check:

Before moving material, ask:

- Is the needed move missing?
- Is a bad move being made?
- Is the move too early, too late, or out of sequence?
- Is the note/rule being stopped too soon or held too long?

4. Actionable loudness:

A loud note must be able to change the next move. If it cannot change the move, it should be a link,
receipt, parking note, or silent custody.

5. Diverge/converge creative room:

Creative room is not random ideation. It is a two-pass rhythm:

`discover widely -> define the clean issue -> develop alternatives -> deliver the smallest tested support`

6. Documentation lane split:

Source, rule, template, proof, TODO, receipt, and explanation are different jobs. One file may link
them, but it should not pretend to be all of them.

## Parked

- Full graph database.
- Numeric confidence/ranking engine.
- Automated alerting for note loudness.
- Full ADR system for every small support change.
- Formal STPA worksheet for every move.

Return trigger:

Reopen only if manual relation grammar and receipts become too slow, inconsistent, or dependent on
assistant memory.

## Rejected As Active

- Outside frameworks as doctrine.
- Math-like scoring without proof.
- Loud alerts for interesting but non-actionable notes.
- Knowledge graph complexity before the house has a small controlled relation vocabulary.
- Creative-room exploration without a converge/wash close.

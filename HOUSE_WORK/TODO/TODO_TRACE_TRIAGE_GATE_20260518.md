# TODO Trace Triage Gate

Status: ACTIVE TODO METHOD
Role: main TODO-room gate for turning raw input into structured work
Authority: support gate only; not command authority

## Core Rule

Raw input may be captured.

Raw input cannot become a structured TODO, boss candidate, active boss, or repair until it passes trace and triage.

## Short Form

Trace first.

Boss second.

Proof decides.

## Full Method

Trace -> Triage -> Group -> Classify -> Rank -> WIP -> Proof

## Why This Method Was Chosen

Mr.Kleen is not mainly a productivity system.

It is an authority, proof, routing, neighbor-fit, and recursive-growth system.

A normal backlog asks:

What should we do next?

This gate asks first:

- What is this?
- Where did it come from?
- What proof state is it in?
- What room owns it?
- Can it command?
- What neighbor does it touch?
- What is blocked?
- What proof would make it real?

Only after those questions can the item be ranked.

## Trace Gate

Before an item can become structured work, record:

- ID
- title
- captured from
- source state
- item kind
- system group
- authority owner
- can command
- related files
- neighbor files
- neighbor risk
- blocked move
- proof needed
- verifiable end state
- prevents

Default:

CAN_COMMAND: no

## Source State Labels

Use exactly one:

- externally claimed
- suspected from source input
- verified by direct audit

## Item Kind Labels

Use exactly one primary kind:

- action
- risk
- assumption
- issue
- dependency
- decision
- blocked move
- proof need
- source input

## Triage Outcomes

After trace, route the item to one:

- accepted
- rejected
- parked
- blocked
- merged
- escalated
- needs proof

## Group Rule

Group by system seam, not by where the item was noticed.

Common groups:

- Front Door / Authority
- House Work Index
- TODO Room
- System Links
- Brain Learning
- Proof History
- Source Ore / Critique
- Lifecycle / Suit

## Classification Rule

Accepted items must be classified before ranking:

- parent boss
- child
- symptom
- ghost
- duplicate
- tool
- proof need
- parking item

## Ranking Rule

Rank only after trace, triage, group, and classification.

Ranking factors:

- entry impact
- authority impact
- routing impact
- proof impact
- next-move impact
- save-continuity impact
- downstream symptoms
- delay harm
- leverage
- confidence
- repair size

Scores are advisory.

Scores do not command action.

## WIP Rule

Active boss limit:

1

Direct support setup limit:

0 or 1

Open repairs without receipt:

0

If more than one boss appears active, pause and sort before repair.

## Proof Rule

Done is not real until proof shows:

- verifiable end state met
- receipt created
- neighbor fit checked
- authority boundary preserved
- blocked moves preserved
- superseded or parked items updated

## Promotion Rule

An item may not become a boss candidate unless it has:

- source state
- item kind
- system group
- authority owner
- neighbor risk
- proof needed
- next safe action
- can command set to no unless current authority says otherwise

## Boundary

This gate does not override ACTIVE_ANCHOR.txt.

This gate does not override current user command.

This gate does not turn TODOs into command authority.

This gate does not authorize repair by itself.

## Current Selected Use

This gate becomes the main TODO-room method.

Other researched list-making methods remain parked as source ore unless separately selected.

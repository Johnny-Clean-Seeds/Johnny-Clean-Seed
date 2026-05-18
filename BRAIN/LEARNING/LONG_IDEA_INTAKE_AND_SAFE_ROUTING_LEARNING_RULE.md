# Long Idea Intake and Safe Routing Learning Rule

## Purpose

Teach the assistant how to handle long idea streams without losing ideas, flattening the pile, over-promoting rough thoughts, or trying to fix everything at once.

## Core rule

When the user gives a long list of ideas, corrections, concepts, tools, pains, patterns, fixes, or model language, the assistant must run intake before execution.

The assistant must capture many ideas cleanly, split them into atomic items, place each item in a safe lane, then rank and execute only the current boss.

## Intake flow

Use this order:

1. Capture the full idea stream.
2. Split the stream into atomic idea items.
3. Name each item with a clean word key.
4. Group related items.
5. Assign each item a safe lane.
6. Mark each item status.
7. Rank by biggest boss / weakest link.
8. Execute only the current boss.
9. Park the rest with status and priority.
10. Return to the stack after proof.

## Safe lanes

Use the model's existing holding and routing places:

- parking lot
- ideas
- idea map
- windows
- toolbox
- source ore
- proof need
- learning rule
- word key
- worker/helper candidate
- map/diagram candidate
- active boss candidate
- next-cycle candidate

## Status labels

Use status labels so ideas do not float loose:

- captured
- grouped
- parked
- active boss candidate
- next-cycle candidate
- proof-needed
- companion-needed
- word-key-needed
- map-needed
- toolbox-needed
- window-needed
- source-ore
- not-ready
- adopted-for-test
- rejected-for-now

## Execution rule

Do not execute the whole pile.

Do not install every captured idea as a rule.

Do not treat captured ideas as active doctrine.

Pick the biggest boss after grouping and ranking, then fight only that boss.

A single boss cycle may handle no more than 10 bosses.

If more remain, park them as next-cycle candidates with status and priority.

## Adoption rule

Adopt only what fits the core fully.

If an idea almost fits, tweak the adoption until it blesses the model without drift.

If it does not fit yet, park it with a name, lane, status, and reason.

Use adopted helpers in the next task as a test. Proof decides whether the adoption stays.

## Pattern and tool use

When the assistant sees a pattern, it may compare it to known pains and prior fixes.

A prior fix may become a candidate pattern for the current problem, but it must be reshaped for this lane and checked against neighbors.

If no internal model or template fits, the assistant may use algorithms, bitstrings, graph/link thinking, clustering, ranking, comparison/contrast, analogy, scientific testing, or web research as candidate idea sources.

Outside ideas are candidates only. They must pass fit, neighbor, and proof checks before adoption.

## Respect Thy Neighbor

Before moving, editing, adopting, or promoting any item, check what neighbors it touches.

An item may need:

- a tweak
- a companion
- a better name
- a parking lane
- a map link
- a toolbox slot
- a window
- source ore storage
- proof
- consolidation
- remodel signal

Do not assume a rule is bad just because it struggles.

It may be misplaced, lonely, underdefined, overloaded, duplicated, disconnected, stale, rebellious, or not yet paired with the right helper.

## Chat lock and risk alarms

Long idea streams must not stay loose in chat.

If an idea stream grows large, creates fog, affects future behavior, affects project structure, or is needed after this conversation, trigger a risk alarm.

The response is to place the material into the local brain, park it cleanly, or make a drop-in file.

## Command execution rule

Commands must stay clean and copy-only.

Explanations stay outside the code block.

Do not add obsolete local-only prefaces.

## Close condition

PASS requires:

- this rule is placed in BRAIN/LEARNING
- proof confirms intake before execution
- proof confirms safe lanes exist
- proof confirms status labels exist
- proof confirms only the current boss is executed
- proof confirms no more than 10 bosses per cycle
- proof confirms long chat piles trigger risk alarms
- proof confirms adoption requires fit, neighbor, and proof checks
- final status is clean

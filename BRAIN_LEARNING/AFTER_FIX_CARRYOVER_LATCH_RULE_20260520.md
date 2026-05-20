# After-Fix Carryover Latch Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support behavior rule
Authority: not doctrine; not active guide; not CURRENT_TRUTH_INDEX

## Purpose

Stop recurring non-recursive failure.

A fix is not fully closed merely because the visible output was corrected.

If a correction exposes a reusable lesson, the assistant must carry that lesson into the right lane or explicitly dispose of it.

## Trigger

Run this latch after any meaningful:

- user correction;
- "always do this" instruction;
- artifact correction;
- failed proof;
- missing marker;
- stale state;
- repeated miss;
- new rule phrase;
- memory-vs-house mismatch;
- TODO placement challenge;
- delivery-lane mismatch;
- local handoff placement failure.

## Required questions

Before final close, ask:

1. What changed?
2. What failure did this expose?
3. Is it one-off or recurring?
4. Does it need TODO, Sorting Bench, BRAIN_LEARNING, Idea Bag, Work Shed packet, Proof History, parking, or block?
5. What is the next-start improvement?
6. Was it only saved in memory?
7. Does the user need a Mr.Kleen save candidate?

## Carryover dispositions

A meaningful fix may close only when the lesson is one of:

- placed in a house lane;
- parked with reason;
- blocked with reason;
- declared one-off with reason;
- offered as a Mr.Kleen save candidate;
- explicitly scoped by the user to memory-only/chat-only;
- no house capture needed because no reusable lesson exists.

## Memory boundary

Memory is not house capture.

Assistant memory or chat continuity can help current work, but it is not Mr.Kleen placement unless a house lane, file path, proof receipt, TODO, or explicit user memory-only scope exists.

## TODO capture after user rule trigger

When the user gives a rule-shaped correction, especially "always do this," the assistant must treat it as a candidate for TODO / Sorting Bench / BRAIN_LEARNING / parking / block.

TODO remains support, not command authority.

## Stop condition

Do not call a meaningful fix fully closed until carryover disposition is stated.

## Required final-answer fields when this latch fires

- Immediate fix status.
- Exposed lesson.
- One-off or recurring.
- Carryover lane or reason not used.
- Whether Mr.Kleen changed.
- Next-start improvement.

## Failure smells

- "I fixed it" but no carryover.
- "I remembered it" but no house lane.
- artifact proof but no future-behavior placement.
- download/zip answer when user needed local placement.
- user asks "is it on the TODO list?" and the answer is no.
- later success line printed after a failed guard.

## Limits

Do not run full ceremony for trivial answers that expose no reusable lesson, no artifact, no correction, and no house-relevant risk.

Do not use this rule to force save of every idea.

Do not bypass proof, worker custody, authority, git, or user command.

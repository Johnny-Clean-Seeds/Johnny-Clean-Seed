# Warning Self-Classification and Explanation Rule Capture

Saved: 20260603_134421

## Problem

The stack inspection before V0.6 passed but emitted WARNING_COUNT: 2.

Because the warnings were not self-classified, we had to run a second warning-review script.

That is not the clean pattern.

## Better pattern

The first script must explain its own warnings before returning control.

It must classify:

- blocking warnings
- non-blocking warnings
- watch warnings
- unknown warnings

It must also explain what is happening and why.

## Required explanation frame

For each warning:

1. Raw warning text.
2. Category.
3. Blocker status.
4. Why it landed there.
5. Evidence used.
6. What is happening.
7. Why it matters.
8. What it affects.
9. What it does not affect.
10. Whether second review is required.
11. Next legal action.

## Current case result

The review proved the two warnings were not blockers.

V0.6 design is allowed with watch.

## Boundary

This is a rule/capture save only.
No implementation.
No script rewrite.
No V0.6.
No full UI.
No Micro 004.

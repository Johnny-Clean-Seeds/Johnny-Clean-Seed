# SCENARIO 004 — HERE-STRING EXPANSION RISK

## Hazard shape

A generated runner contains literal text with quote-heavy content, variable-like markers, delimiters, or nested code blocks. The container may expand, terminate, escape, or reshape the content unexpectedly.

## What this tests

Whether the reviewer blocks execution when the literal-text transport layer is not proven.

## Expected judgment

`REQUIRES_NON_EXPANDING_TEMPLATE_PROOF`

Secondary judgment:

`BLOCK_STATIC_REVIEW`

## Required response

Keep the material in manual/static review.

Require a proven non-expanding template strategy before any future execution lane.

Separate content transport proof from target-helper proof.

## Forbidden response

Do not treat successful paste appearance as runtime proof.

Do not keep repairing quote damage with more generated quote-heavy code.

Do not bury the content inside a larger generated runner.

## Clean wording

Literal transport is the unknown; target execution stays closed.

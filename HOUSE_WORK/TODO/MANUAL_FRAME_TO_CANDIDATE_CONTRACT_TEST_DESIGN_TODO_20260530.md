# TODO — Manual Frame-to-Candidate Contract Test Design

Date: 2026-05-30
Status: TODO / OPEN NEXT LANE
Authority: not doctrine

## Purpose

Design one manual test proving whether a frame contains enough information for a helper to write a read/report .ps1 candidate without guessing.

## Test object

One frame requesting a read/report .ps1 candidate.

## Required proof questions

Does the frame define:

- identity;
- intent;
- authority;
- inputs;
- outputs;
- policy;
- template;
- candidate lane;
- Code Gate route;
- provenance;
- placement;
- handoff;
- neighbor compatibility;
- join-back;
- stop condition?

## Pass condition

A helper could write a candidate artifact from the frame without guessing roots, outputs, blocked moves, proof, or next action.

## Fail condition

Any root, output, policy, stop condition, candidate lane, Code Gate path, or join-back must be guessed.

## Boundary

No generator.
No .cmd launcher.
No tool placement.
No automation.
No doctrine.

## Return trigger

Resume after held ideas/open lanes save is clean.

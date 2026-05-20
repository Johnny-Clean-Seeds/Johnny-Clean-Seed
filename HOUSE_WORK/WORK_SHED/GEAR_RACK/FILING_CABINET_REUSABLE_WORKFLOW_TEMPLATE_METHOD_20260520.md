# Filing Cabinet / Reusable Workflow Skeleton Method

Date: 2026-05-20
Lane: HOUSE_WORK / WORK_SHED / GEAR_RACK
Status: reusable workflow method candidate
Authority: Gear Rack support; not doctrine; not installed runtime tool

## Purpose

Reduce repeated generation of near-identical local workflow code.

The assistant should retrieve a proven skeleton first, then tweak it for the current job.

## Applies to

- deep-scan scripts;
- intake scripts;
- save/lock scripts;
- proof receipts;
- mule handoffs;
- kickoff packets;
- artifact self-check scripts;
- file-placement validators;
- readback scripts;
- test runners;
- status checks;
- hash/checksum blocks;
- cleanup and restore guards;
- other recurring PowerShell/local workflows.

## Default rule

Before generating a repeated local workflow:

1. Ask what proven skeleton already exists.
2. Retrieve the closest prior skeleton/tool card.
3. Tweak only task-specific parts:
   - target files;
   - search terms;
   - output path;
   - required markers;
   - proof fields;
   - stop conditions.
4. Run proof.
5. If the tweak proves generally useful, update or propose a template improvement.

## Why

Repeated cousin scripts create risk:

- wasted compute/context;
- longer copy/paste blocks;
- drift between versions;
- guard inconsistencies;
- false-success hazards;
- weaker proof consistency.

## Proof of use

This candidate passes first live use when a future repeated workflow is built from a prior skeleton instead of generated from scratch.

## Boundary

This is not a command to build a full tool system now.

It is a retrieval-before-generation method.

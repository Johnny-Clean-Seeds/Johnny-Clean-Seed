# Source / Lane / Artifact Placement Alarm Firing Card

Date: 20260522_050405

Base:

446689fb420e001e2215c1339cc21072964fc6f0

## Use when

Use this card before creating or saving any durable:

1. Rule.
2. Method.
3. Handoff.
4. Mule packet.
5. Report.
6. Artifact.
7. Receipt package.
8. Current-status update.
9. Cabinet inventory.
10. Candidate system.

## Step 1 — Separate task directive from artifact content

Ask:

1. What did the user tell the assistant to do?
2. Which parts are instructions for assistant behavior?
3. Which parts are durable concepts that belong in the artifact?
4. Which parts are source ore that should be parked?
5. Which parts are current-route mechanics that should not become a permanent rule?

If live instructions are being copied into the artifact, stop and rewrite at concept level.

## Step 2 — Place material into the right lane

Classify each major piece as:

1. Active build material.
2. Candidate rule.
3. Evidence.
4. Parked source ore.
5. Other Noise.
6. Handoff instruction.
7. Receipt/proof material.
8. TODO/next route.
9. Blocked move.
10. Promotion request.

If a piece lacks a clean lane, park it rather than forcing it into the artifact.

## Step 3 — Check artifact scope

Ask:

1. What is this file supposed to be?
2. Does every section serve that purpose?
3. Did the artifact become a rule stack when it should be a report?
4. Did it become a linear checklist when the model needs recursive movement?
5. Did it include tool-specific details that should remain outside the durable concept?

If scope drift appears, revise before save.

## Step 4 — Link papers

For durable work, name the upstream paper trail:

1. Base commit.
2. Source file or source conversation object.
3. Upstream handoff if any.
4. Cabinet/source inventory if any.
5. Receipt path.
6. Hashes when available.
7. Downstream TODO or next route.

If the paper trail is missing, add it or stop.

## Step 5 — Final revision check

Before delivery/save, check:

1. Clean enough for current phase.
2. Not overfit to current chat wording.
3. Not falsely linear.
4. Not missing source/proof links.
5. Not claiming promotion.
6. Not injecting live task instructions.
7. Not leaving useful correction unparked.
8. Not too vague to guide action.

## Firing labels

WORKING:

The card changes the output before delivery/save.

LATE:

The user catches a placement error after output but before damage.

FAILED-TO-FIRE:

The placement error reaches a durable artifact/save and has to be repaired afterward.

PARTIAL:

Some risk is caught, but another placement issue slips through.

DECORATIVE / NO PROOF:

The card exists but there is no event showing it changed behavior.

# Worker Symptom Diagnostic Gate Rule

Status: SUPPORT DIAGNOSTIC GATE / WORKER-CAPABILITY FIT / NOT DOCTRINE
Date: 2026-05-24

## Purpose

Diagnose repeated assistant, model, mule, helper, or worker failures without turning the worker into the problem.

The target is the symptom pattern:

- rushed execution;
- weak communication;
- known rules not applied to the active issue;
- shallow or low-depth worker asked to carry a high-depth job;
- PASS-like closure before proof, rerun, or final judge;
- repeated same-shaped misses despite saved rules.

The gate asks:

`Is this a rule gap, a communication gap, a capability-fit gap, a proof gap, or a lifecycle gap?`

## Placement

Run this after a visible worker symptom appears and before blaming the worker, adding another full gate, or rewriting doctrine.

Clean route:

`Signal Before Object Type -> Worker Symptom Diagnostic -> Capability Fit -> Communication Surface -> Rule-Application Checksum -> Same-Issue Rerun -> Proof / Receipt -> Final Judge`

## Trigger

Fire when:

- the user says the assistant is rushing, shallow, hard to understand, or not applying rules;
- a worker completes a task but skips receipts, reruns, or rule application;
- the output says the right rule names but does not use them on the active issue;
- a lower-depth model is used for a task that needs deep synthesis, broad coverage, or careful file custody;
- communication gets worse after a support rule was supposedly added;
- repeated loops return the same result with no changed behavior.

## Diagnostic Questions

### 1. Symptom vs Cause

- What did the user or house actually observe?
- Is the visible issue communication, speed, missed evidence, wrong lane, shallow synthesis, stale memory, or proof mismatch?
- What underlying cause would produce that symptom?

### 2. Capability Fit

- Is this worker capable of the task depth?
- Does the task need a deeper model, tool run, file read, local proof, or human approval?
- Should the task be split into smaller pieces with stronger checklists?

### 3. Communication Surface

- Did the worker state the active object?
- Did it state the route?
- Did it state what changed?
- Did it state what proof exists?
- Did it state blockers and uncertainty?

### 4. Rule-Application Checksum

For each selected rule, prove it touched the issue:

| Rule | Where It Touched The Active Issue | Result | Proof |
|---|---|---|---|

If a rule was only named, mark `NAMED ONLY / NOT APPLIED`.

### 5. Same-Issue Rerun

After the fix, rerun the same active issue through the changed route.

Do not move to the next issue until the same issue shows whether the change helped.

## Output Labels

- CAPABILITY MISMATCH: task needs deeper worker, smaller pieces, or more tool support.
- COMMUNICATION SURFACE GAP: work may be correct but not readable or judgeable.
- RULE NAMED ONLY: rule was mentioned but did not touch the active issue.
- PROOF GAP: work lacks receipt, hash, rerun, comparison, or validation.
- LIFECYCLE GAP: object was created but not routed, homed, parked, or closed.
- TRUE RULE GAP: house lacks a needed rule/checkpoint/tool.
- WATCH AGAIN: possible pattern, not enough proof.
- RESOLVED LOCALLY: bounded support fix applied and same issue reran cleaner.

## Partner Checkpoints

Worker Symptom Diagnostic has four attached partner checkpoints:

1. Capability Fit Checkpoint.
2. Communication Surface Checkpoint.
3. Rule-Application Checksum.
4. Focus Reset Checkpoint.

They do not fire loose. They interpret the diagnostic output and prepare the next parent gate.

## Boundary

- Not medical advice.
- Not a judgment of the worker's worth.
- Not doctrine.
- No ACTIVE_GUIDES rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No public authority change.
- No proof bypass.
- No adding a full gate when a checkpoint or tool is enough.

## Proof

Proof is a live case where this gate turns a vague worker complaint into a specific repair:

- capability mismatch;
- communication surface fix;
- rule application checksum;
- same-issue rerun;
- receipt or local evidence.

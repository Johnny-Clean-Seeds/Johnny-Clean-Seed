# Broad Words / Worker Surface Extension Rule

Status: SUPPORT EXTENSION / CONCEPT-FAMILY COVERAGE / NOT DOCTRINE
Date: 2026-05-24

## Purpose

Extend broad-word coverage to worker and communication failures.

If a rule only says "assistant," a nearby failure may pass through as model, mule, helper, agent, worker, script, packet, or tool output.

If a rule only says "communication," a nearby failure may pass through as unclear route, missing active object, missing proof, unreadable summary, skipped blocker, or no final judge.

## Worker Surface Family

When diagnosing worker behavior, broaden across:

- assistant;
- model;
- mule;
- helper;
- worker;
- script;
- packet;
- tool output;
- handoff;
- generated artifact.

## Communication Surface Family

When diagnosing communication, broaden across:

- active object stated;
- task route stated;
- rule family stated;
- file changes stated;
- proof and receipt stated;
- uncertainty stated;
- blockers stated;
- final status stated;
- next action stated.

## Rule Application Family

When diagnosing whether rules were applied, broaden across:

- named rule;
- rule chosen before action;
- rule touched the active object;
- rule changed the fix;
- same issue reran after the fix;
- proof recorded;
- residue parked.

## Boundary

- Do not make broad wording vague.
- Do not blame the worker when the route, proof, or task fit is the actual issue.
- Do not scatter new rules everywhere.
- Do not rewrite the original broad-words rule unless a later proof path requires it.

## Proof

Proof is a worker-symptom case where broader wording catches a variant that a literal "assistant" or "communication" rule would miss.

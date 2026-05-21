# Tiny Common-Sense Test Template

Date: 2026-05-21
Status: TINY TEST TEMPLATE / SOURCE MATERIAL ONLY

Purpose:
Use this when a future worker or Mr.Kleen wants to test whether a "common sense" claim is clean enough to use in one bounded situation.

This is not a dashboard, runtime, automation, or doctrine install.

## Test Card

### 1. Claim

What exact common-sense claim is being tested?

Example:
"If a file path is named as the required output lane, write only there."

### 2. Active Meaning Of "Common Sense"

Which layer is active?

Choose one or more:

- perceptual;
- physical;
- biological;
- agent / theory of mind;
- social norm;
- language / common ground;
- event script;
- semantic memory;
- heuristic / satisficing;
- risk/proof threshold;
- local house rule;
- cultural default;
- other.

### 3. Situation

What exact situation does the claim apply to?

Name:

- task;
- lane;
- actor;
- object/file/source;
- risk;
- authority.

### 4. Ordinary Default

What would a normal fit judgment expect before deeper proof?

Format:

Given [situation], normally [default expectation], because [ordinary relation].

### 5. Source Anchors

What supports this default?

Use at least one:

- local rule or house file;
- external source;
- direct observation;
- prior receipt;
- human practice;
- domain expertise;
- tool output.

### 6. Scope

Common for whom?

Choose:

- broadly human;
- English-language pragmatic;
- local US cultural;
- local house/Mr.Kleen;
- domain expert;
- task-specific;
- unknown.

### 7. Defeat Conditions

What would make this common-sense default unsafe or false?

Examples:

- explicit contrary instruction;
- protected file boundary;
- high-stakes domain;
- unfamiliar culture;
- hidden technical constraint;
- stale source;
- missing proof;
- adversarial content;
- conflicting source;
- user says stop.

### 8. Risk Level

Low / Medium / High.

Risk depends on:

- cost of being wrong;
- reversibility;
- authority impact;
- file impact;
- user trust impact;
- whether protected lanes are touched.

### 9. Action

What is the smallest action that respects the default and defeat conditions?

Examples:

- answer chat only;
- write to return folder only;
- ask one clarifying question;
- park as source ore;
- run source-to-claim check;
- refuse install;
- escalate to proof.

### 10. Feedback

How will the result teach the model?

Examples:

- compare predicted default to actual user response;
- check file path result;
- record mismatch;
- update rejection ledger;
- mark as unknown;
- stop if default failed.

## Pass Shape

PASS WITH GUARDRAILS when:

- active meaning is named;
- source anchor exists;
- scope is named;
- defeat conditions are clear;
- smallest action fits the risk;
- feedback path exists.

PARTIAL when:

- the default is plausible but scope or defeat condition is weak.

FAIL when:

- "common sense" is used as authority without source, scope, or defeat.

INVALID when:

- available evidence cannot prove the common-sense claim applies.

## Example Mini Test

Claim:
"A deep research answer should not treat one discipline's definition as the whole definition."

Active meaning:
Risk/proof threshold + semantic memory + source-to-claim.

Situation:
User asked for full definition and proof of common sense.

Ordinary default:
Given a broad cross-disciplinary concept, a fit judgment expects multiple source layers, because the term is known to carry multiple uses.

Source anchors:
Etymonline, Reid, cognitive development, sociology, pragmatics, AI research.

Scope:
Task-specific and scholarly.

Defeat:
If the user asked for one discipline only, or if house rules required a narrow answer.

Risk:
Medium.

Action:
Build layered taxonomy and rejection ledger.

Feedback:
Check whether the final packet names layers, sources, caveats, and rejected shortcuts.

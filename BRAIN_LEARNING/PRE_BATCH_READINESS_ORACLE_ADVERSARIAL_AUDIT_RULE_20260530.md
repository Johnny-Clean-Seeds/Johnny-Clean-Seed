# Pre-Batch Readiness / Oracle / Adversarial Audit Rule

Date: 2026-05-30
Status: SUPPORT RULE / BATCH PERMISSION GATE
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Rule

Do not build or run a batch verifier immediately after manual chained proof.

First run a Pre-Batch Readiness / Oracle / Adversarial Audit.

Batch is not only "more rows." Batch changes the risk shape:

- one global PASS can hide row dirt;
- a weak oracle can manufacture confidence;
- one bad row can poison the run or disappear;
- repeated output can bury proof;
- batch size can create pressure/bloat;
- row provenance can become fog.

Therefore batch needs a permission gate before a batch verifier is allowed.

## Required hard verdicts

The audit must return one of these:

- BATCH_READY_FOR_TINY_TRIAL
- BATCH_BLOCKED_NEEDS_REPAIR
- BATCH_BLOCKED_ORACLE_TOO_WEAK
- BATCH_BLOCKED_ROW_ISOLATION_MISSING
- BATCH_BLOCKED_FAKE_PASS_RISK
- BATCH_BLOCKED_BACKPRESSURE_MISSING

## Ten required bases

1. Oracle base:
What can the verifier prove, what can it only WATCH, and what requires human review?

2. Metamorphic base:
What relation tests are valid, and where can they overfit?

Example:
For functional questions, action/function bridges should outrank form-only bridges, but this must not reward wordy fake bridges.

3. Adversarial base:
The audit must include circular, wordy fake, subtly dirty, malformed, random, tie, and expected-reject cases.

4. Row isolation base:
Each row needs its own input, question, candidate pack, selected candidate, verifier verdict, shell result, reject reason, proof/report pointer, and return trigger.

5. No global fake PASS base:
The batch cannot PASS when an unexpected row blocks or needs oracle review.

6. Dead-letter base:
Blocked rows must be recoverable and labeled with failed gate, reason, row key, source row, and return trigger.

7. Backpressure base:
First batch must be tiny and bounded. Expansion must stop on repeated unknowns, ties, dirty rows, or oracle weakness.

8. Traceability base:
Each row must be traceable from input to selection to verifier to outtake to report/hash.

9. Shell readability base:
User view must show row-level outcomes without dumping proof bloat.

10. Boundary base:
The audit and first tiny batch trial remain read/report only. No Git writes from audit trial, no watcher, no automation, no implementation, no Whirlpool.

## External pattern anchors

This rule was supported by a deeper washer pass using outside pattern families:

- testing standards and risk-based test strategy;
- AI test/evaluation/verification/validation;
- oracle problem in software testing;
- observability and trace context propagation;
- bulkhead/fault isolation;
- overload/backpressure;
- symptom-oriented monitoring;
- AI red teaming/adversarial testing.

These are support anchors, not imported doctrine.

## House fit

The house already has related pressure:

- Code Gate PASS is not job PASS;
- several rules together need compatibility apply gate;
- deep work needs checkpoints and real stop states;
- Intake Gate concepts require unknown/dead-letter lanes, backpressure, and decision tables;
- Whirlpool cycles cannot start until intake/proof/outtake/no-bleed/boundary checks pass.

## Hard blocks

No batch verifier until audit passes.
No Whirlpool.
No automation.
No watcher.
No implementation.
No doctrine promotion.
No ACTIVE_GUIDES edit.
No CURRENT_TRUTH_INDEX edit.
No fake PASS from sample count alone.

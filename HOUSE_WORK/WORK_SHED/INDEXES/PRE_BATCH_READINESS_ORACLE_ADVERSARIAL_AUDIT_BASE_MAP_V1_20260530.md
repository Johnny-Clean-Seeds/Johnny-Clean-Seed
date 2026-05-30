# Pre-Batch Readiness / Oracle / Adversarial Audit Base Map V1

Date: 2026-05-30
Status: BASE MAP / SUPPORT

## Final hard state

BATCH_NOT_READY_AS_NEXT_ACTION

PRE_BATCH_READINESS_ORACLE_ADVERSARIAL_AUDIT_READY_AS_NEXT_ACTION

## Permission gate sequence

1. Gear-change closeout / suit refresh.
2. Pre-Batch Readiness / Oracle / Adversarial Audit.
3. Only if the audit returns BATCH_READY_FOR_TINY_TRIAL, build tiny batch verifier.
4. If audit blocks, repair the exposed gap first.
5. Whirlpool remains blocked.

## Required bases and failure labels

| Base | Audit Question | Failure Label |
| --- | --- | --- |
| Oracle | Can the verifier prove this, only watch it, or require human review? | BATCH_BLOCKED_ORACLE_TOO_WEAK |
| Metamorphic | Are relation rules valid without overfitting? | BATCH_BLOCKED_NEEDS_REPAIR |
| Adversarial | Can circular/wordy/subtle/malformed/random cases be blocked? | BATCH_BLOCKED_NEEDS_REPAIR |
| Row Isolation | Does each row carry its own proof and verdict? | BATCH_BLOCKED_ROW_ISOLATION_MISSING |
| No Fake PASS | Can an unexpected row block the whole batch? | BATCH_BLOCKED_FAKE_PASS_RISK |
| Dead Letter | Are blocked rows recoverable with reason and return trigger? | BATCH_BLOCKED_NEEDS_REPAIR |
| Backpressure | Is tiny-run limit and stop rule defined? | BATCH_BLOCKED_BACKPRESSURE_MISSING |
| Traceability | Can row be followed input -> report/hash? | BATCH_BLOCKED_NEEDS_REPAIR |
| Shell Readability | Can row outcomes be shown without proof bloat? | BATCH_BLOCKED_NEEDS_REPAIR |
| Boundary | Does it remain read/report only with no Whirlpool? | BATCH_BLOCKED_NEEDS_REPAIR |

## Tiny-trial permission condition

The audit may return BATCH_READY_FOR_TINY_TRIAL only if:

- all ten bases are present;
- at least one negative control exists;
- at least one adversarial row exists;
- expected-reject rows are separated from unexpected blocks;
- every row has row-level proof fields;
- batch summary cannot override row failure;
- max first batch size is bounded;
- no implementation, watcher, automation, or Whirlpool starts.

## Block condition

Any missing base blocks batch.

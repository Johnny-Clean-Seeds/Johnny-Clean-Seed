# JOB 04 - MULE BATCH RISK REVIEW

Recommendation:
DO NOT RUN THREE YET.

If later approved, run sequentially, not parallel.

## Risk Review

Stale context risk:
HIGH if three runs start before Run 001 is intaken/dispositioned. The packet is based on snapshot HEAD 6b9336b and the live house may move after any intake.

Duplicate-work risk:
HIGH. Recent history already shows mule output recommendations were sometimes consumed by later house work. Every future mule output must be deduped against current house fixes before acceptance.

Support-rule whirlpool risk:
HIGH. The house has many useful support rules, selectors, suits, and watches. More mule output could produce more support surfaces instead of one clean route.

Command-authority confusion:
MEDIUM-HIGH. The anchor correctly blocks mule output adoption, but long reports can still feel like command pressure.

Intake burden:
HIGH for parallel. Manageable for sequential one-at-a-time.

Proof-history clutter:
MEDIUM-HIGH if every pass creates a save. Lower if outputs remain local packet-only until selected for intake.

Batch vs sequential:
Sequential only. Parallel is rejected for this phase.

## Decision

Run 3 parallel:
REJECT.

Run 3 immediately sequential:
REJECT for now.

Run fewer:
APPLY. Run zero more until Run 001 is intaken/dispositioned. After that, run at most one next mule packet if the selected seam is non-mundane and cannot be handled by direct local check.

Do not run 3 yet:
APPLY.

Disposition:
APPLY / ADAPT.

Proof needed:
- Run 001 output read/disposition complete.
- Current active anchor after disposition.
- Selected next seam is not mundane local search/cleanup.
- Packet has top block, start card, stale checker, and output contract.
- Stop condition defined before run.

Boundary:
Mule is worker/sharpener, not supervisor. House decides. No adoption from mule output alone.

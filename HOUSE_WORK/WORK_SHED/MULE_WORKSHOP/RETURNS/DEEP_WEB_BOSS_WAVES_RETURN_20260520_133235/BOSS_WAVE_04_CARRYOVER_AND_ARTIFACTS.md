# BOSS WAVE 04 - RECURSIVE CARRYOVER / ARTIFACTS

## Boss Target

Lessons, fixes, and artifact checks must carry into the next real event instead of staying memory-only.

## Candidate Fixes Considered

| # | Candidate | Source seed | Strength | Weakness | Score |
|---:|---|---|---|---|---:|
| 1 | FRACAS Lite: failure/report, action, verification event | WEB-FRACAS-DAU | Best closed-loop correction fit | Use only for actual miss/failure | 10 |
| 2 | PDSA Wear-Test Ledger | WEB-PDSA | Strong for testing improvements | Slightly less event-custody focused | 9 |
| 3 | A3 Follow-Up Section | WEB-A3-LEI | Good problem-solving closure | Report-shaped, less artifact-specific | 8 |
| 4 | Postmortem Action Tracker | WEB-SRE-POST | Strong action follow-through | Reactive | 8 |
| 5 | DORA Continuous Improvement Capability | WEB-DORA | Good for sustained capability | Too broad | 6 |
| 6 | Kanban Revisit Trigger | WEB-KANBAN | Good to prevent stuck follow-up | Needs board integration | 6 |
| 7 | NASA Lesson Card | prior NASA lessons source | Reusable | Archive pressure | 5 |
| 8 | Team Topologies Enabling Support | WEB-TEAMTOPO | Good for lowering cognitive load | Team metaphor too large | 5 |
| 9 | ADR Consequence Review | WEB-ADR | Good durable choices | Too decision-specific | 5 |
| 10 | FMEA future failure scan | WEB-FMEA-NASA | Good prevention | Heavy for every artifact | 5 |

## Best Fix

Winner:
FRACAS Lite.

Working shape:
Only when an artifact/check/fix actually fails or a repeated miss appears:
- Failure or miss.
- Affected lane.
- Cause or unknown.
- Corrective action candidate.
- Verification event needed.
- Status: open, verified, parked, rejected.

## Proof To Myself

Why this beats PDSA:
PDSA is excellent for planned tests. FRACAS is better for carryover failures because it explicitly connects failure report to corrective action and verification. The current house problem is often "we fixed it, but did the corrective action verify later?"

Why it is better:
- More closed-loop than a loose action tracker.
- More failure-specific than A3.
- Less archive-heavy than lessons learned.
- Matches artifact self-check and rule-not-fired misses.

Disproof:
If the event is not a failure/miss but a normal improvement trial, PDSA Wear-Test Ledger wins instead.

Verdict:
BEST CANDIDATE FOR WAVE 04 / USE ONLY ON REAL MISS OR REPEATED FAILURE.

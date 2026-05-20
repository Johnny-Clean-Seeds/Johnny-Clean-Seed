# BOSS WAVE 04 - RECURSIVE CARRYOVER / ARTIFACTS

## Boss Target

A fix can be found and even saved, but the lesson may fail to carry into the next artifact, source note, or point-of-work moment.

Local evidence:
- Boss/Ghost map lists Recursive Carryover / Point-of-Work Link Failure as a parent boss.
- Artifact Self-Check and Compose-Review/Reflect-Capture have first/varied proofs but remain open.

## Up To 10 Better Fix Candidates

| # | Candidate fix | Web seed | House fit | Tradeoff | Score |
|---:|---|---|---|---|---:|
| 1 | PDSA Wear-Test Ledger: prediction, use, study, next trigger, keep/narrow/park | WEB-DEMING-PDSA | Very high: directly tests whether a fix carries | Needs discipline to keep compact | 10 |
| 2 | Postmortem Action Tracker: action, owner, due trigger, verification | WEB-SRE-POST, WEB-ATL-POST | High: follow-through proof | Can feel like task management if overused | 8 |
| 3 | NASA Lesson Reuse Card: lesson, context, reuse condition | WEB-NASA-LL | High for reusable learning | Could become lesson-index pressure | 6 |
| 4 | OODA Feedback Stamp: after action, feed result back into orientation | WEB-USMC-OODA | High but abstract | Needs translation into ledger fields | 7 |
| 5 | ADR Consequence Check: consequence watched after decision | WEB-ADR | Medium-high for durable route decisions | Too decision-record heavy for artifacts | 6 |
| 6 | Toyota kaizen standardize-after-improve | WEB-TOYOTA-TPS | Medium-high: repeat improvement only after proof | Could imply broad standardization too early | 6 |
| 7 | Five Hows: how will prevention happen next time | WEB-ASQ-RCA | Medium: good after failure | Narrower than carryover as a whole | 5 |
| 8 | DRI Carryover Owner | WEB-GITLAB-DRI | Medium: ownership helps | Assistant/user authority split must stay clear | 5 |
| 9 | Runbook insertion | WEB-AWS-RUN | Medium: good once stable | Premature if fix is still soft | 5 |
| 10 | Cynefin probe before standardize | WEB-CYNEFIN | Medium: prevents over-standardizing complex work | Too abstract for every artifact | 4 |

## Best Fix

Selected:
Candidate 1 - PDSA Wear-Test Ledger.

Shape:
For a carryover item, record:
- Fix being worn.
- Prediction: what should improve next time.
- Use event.
- Study: helped, hurt, partial.
- Tradeoff.
- Decision: keep, narrow, park, reject-as-active.
- Next trigger.

## Proof To Myself

Claim:
PDSA Wear-Test Ledger is the best fit for recursive carryover.

Evidence:
- Deming PDSA explicitly requires studying results against prediction before acting.
- Local Tool Trial Ledger already uses helped/hurt/partial, tradeoff, decision, next direction.
- Artifact and source-note TODOs need varied proof, not immediate closure.

Inference:
This fix matches the house's existing ledger style and keeps carryover from being memory-only. It is stronger than a postmortem tracker because it tests whether the fix is actually worn at the next point of use.

Why not the others:
- Postmortem action trackers are useful but action-item-shaped, not wear-test-shaped.
- NASA lessons are too archive-oriented for point-of-work carryover.
- Runbook insertion should wait until the behavior is stable.

Disproof test:
If the ledger is not referenced at the next artifact/source-note event, it fails as carryover mechanism.

Verdict:
BEST / APPLY AS WATCH CANDIDATE.

Next clean action:
Use only when the next artifact, source note, or carryover event appears. Do not force it into the RCE inspection unless carryover proof is actually being judged.

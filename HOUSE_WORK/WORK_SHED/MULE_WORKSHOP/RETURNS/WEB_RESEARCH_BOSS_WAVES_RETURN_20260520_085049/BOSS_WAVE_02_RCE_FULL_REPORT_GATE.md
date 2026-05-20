# BOSS WAVE 02 - RCE / FULL REPORT GATE

## Boss Target

RCE/report gate remains PASS/PARTIAL because the full report gate is open. The prior return selected this as the next seam.

Local evidence:
- HOUSE_WORK\TODO\RULE_CONCEPT_EVENT_LINK_MAP_AND_REPORT_GATE_LIVE_USE_TODO_20260520.md says the full report gate is open.
- Prior return says inspect that TODO against the six-loop return package.

## Up To 10 Better Fix Candidates

| # | Candidate fix | Web seed | House fit | Tradeoff | Score |
|---:|---|---|---|---|---:|
| 1 | Claim-Scoped Postmortem/AAR Report Gate: what happened, expected, actual, evidence, cause, action/disposition, owner, proof gap | WEB-SRE-POST, WEB-ATL-POST, WEB-ASQ-RCA | Very high: directly matches full report gate | Must stay lightweight | 10 |
| 2 | NASA Lesson Record: event, lesson, recommendation, reusable path | WEB-NASA-LL | High: keeps lessons reusable | Could become archive-heavy | 7 |
| 3 | PDSA Report: plan/prediction, do, study, act | WEB-DEMING-PDSA | High: proves whether a fix worked | Less complete for evidence custody | 8 |
| 4 | ADR Report: context, options, decision, consequences | WEB-ADR | High for route decisions | Too decision-centered for report gate proof | 7 |
| 5 | Five Whys Root Report | WEB-ASQ-RCA | Medium-high when cause is unclear | Too narrow if report is not root-cause event | 6 |
| 6 | DRI Action Tracker | WEB-GITLAB-DRI | Medium-high: assigns follow-through | Does not prove report quality alone | 6 |
| 7 | OODA Report: observe/orient/decide/act/feedback | WEB-USMC-OODA | Medium: useful narrative | Not enough proof fields by itself | 5 |
| 8 | Configuration Impact Report | WEB-NIST-CM | Medium: good for file-state impact | Too technical for every report | 5 |
| 9 | Cynefin Mode Report | WEB-CYNEFIN | Medium: stops one-size-fits-all | Too abstract for closure proof | 4 |
| 10 | Toyota Kaizen Sheet | WEB-TOYOTA-TPS | Medium: improvement-focused | May understate evidence custody | 5 |

## Best Fix

Selected:
Candidate 1 - Claim-Scoped Postmortem/AAR Report Gate.

Shape:
For a full report event, require:
1. Trigger and claim.
2. Expected control state.
3. Actual evidence read.
4. Difference or gap.
5. Root/parent boss or "not proven."
6. Disposition: apply, adapt, park, reject, needs proof, or block.
7. Owner/judge boundary.
8. Proof artifact.
9. Next clean action.
10. What would disprove the conclusion.

## Proof To Myself

Claim:
Claim-scoped postmortem/AAR is the best fit for the full report gate.

Evidence:
- Google SRE and Atlassian postmortem sources stress learning, action items, and follow-through.
- ASQ root cause analysis supports structured evidence and cause/action thinking.
- The local RCE TODO asks for a full report gate that runs a raw feel pass, checks control state/drift/custody/proof/blocked moves, rewrites final report, and avoids pushing commands unless proven.

Inference:
This candidate matches the report gate's actual trigger and avoids installing a full framework. It gives enough fields to prove a report without making every note into a permanent lesson index.

Why not the others:
- PDSA is strong for experiments, weaker for custody/report completeness.
- ADR is strong for decisions, weaker for report proof.
- NASA lessons are useful for later reuse but could over-archive.
- Five Whys is too cause-heavy when the report may be a route judgment, not a failure.

Disproof test:
If the report gate can close accurately with fewer fields, this should be shortened. If it fails to catch missing proof or command-pressure errors, it is not enough.

Verdict:
BEST / NEXT INSPECTION TARGET.

Next clean action:
Inspect whether the previous six-loop return satisfies this shape or leaves exact gaps.

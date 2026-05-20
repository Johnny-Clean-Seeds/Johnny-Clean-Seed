# BOSS WAVE 01 - RULE ACTIVATION / WORK-ORDER CONTROL

## Boss Target

The right rule must fire before action, not be explained afterward.

## Candidate Fixes Considered

| # | Candidate | Source seed | Strength | Weakness | Score |
|---:|---|---|---|---|---:|
| 1 | Unsafe Control Action Check: before action, name the control action that would be unsafe, late, missing, or wrong | WEB-STPA-MIT | Hits the exact failure: wrong or missing control before action | Needs translation from safety language | 10 |
| 2 | Rule-Firing Runbook Card v2 | WEB-CISA-PLAY, WEB-AWS runbook from prior | Extends existing card cleanly | Less sharp about wrong-control modes | 8 |
| 3 | Jidoka Stop Hook | WEB-JIDOKA | Stops when abnormality appears | Detects after abnormality, not always before | 7 |
| 4 | FMEA Rule-Failure Table | WEB-FMEA-NASA | Systematic failure modes | Too broad for every action | 7 |
| 5 | A3 Problem Statement Before Action | WEB-A3-LEI | Prevents jumping to solution | Too much for small moves | 6 |
| 6 | Gemba Readback | WEB-GEMBA-LEI | Forces direct evidence | Already mostly present in file-first behavior | 6 |
| 7 | PDSA Prediction | WEB-PDSA | Great for testing rule changes | Less direct for normal action | 7 |
| 8 | NIST Govern/Map/Measure/Manage mini-loop | WEB-NIST-AI-RMF | Good risk language | Too broad as default | 5 |
| 9 | Kanban WIP gate before action | WEB-KANBAN | Good when too much is active | Not the core of rule firing | 5 |
| 10 | ADR for rule route decisions | WEB-ADR | Good for durable decision | Too heavy for frequent use | 4 |

## Best Fix

Winner:
Unsafe Control Action Check.

Working shape:
Before a nontrivial house-touching action, add one line to the existing card:

Unsafe control action to avoid:
- acting before active anchor;
- treating support as command;
- promoting partial proof;
- using stale packet/output;
- touching blocked files;
- selecting flat TODO instead of parent boss;
- explaining the rule after action.

## Proof To Myself

Why this beats the first better idea:
The previous run selected a Runbook Card Upgrade. That was good, but STPA gives a sharper question: what exact control action would be unsafe here? That maps directly to Mr.Kleen's parent boss, because the failure is usually an action-control failure.

Why it is better:
- Smaller than FMEA.
- More preventive than postmortem.
- More precise than generic runbook fields.
- Fits the active Rule-Firing Confirmation Card without creating a new authority.

Disproof:
If the unsafe-control line does not change action selection or catch a wrong move, it is only decoration and should be parked.

Verdict:
BEST CANDIDATE FOR WAVE 01 / APPLY AS NEXT-USE CARD LINE ONLY.

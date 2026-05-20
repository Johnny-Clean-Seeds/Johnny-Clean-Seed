# BOSS WAVE 01 - RULE ACTIVATION / WORK-ORDER CONTROL

## Boss Target

Rule exists but does not always fire before action.

Local evidence:
- ACTIVE_ANCHOR says route selection under Rule-Firing Confirmation Card.
- BOSS_RUN_6_LOOP_RETURN_20260520_082813 selected Rule Activation / Work-Order Control as top parent boss.
- BRAIN_LEARNING\RULE_FIRING_CONFIRMATION_BEFORE_ACTION_GATE_20260520.md already has a short confirmation card.

## Up To 10 Better Fix Candidates

| # | Candidate fix | Web seed | House fit | Tradeoff | Score |
|---:|---|---|---|---|---:|
| 1 | Runbook Card Upgrade: add outcome, owner, stop, proof, and allowed disposition to the existing card | WEB-AWS-RUN, WEB-AWS-OE | Very high: improves existing card without new doctrine | Could become ceremony if used on tiny tasks | 9 |
| 2 | OODA Entry Loop: observe control state, orient lane/rules, decide route, act, then feedback | WEB-USMC-OODA | High: matches active route selection | Slightly abstract unless converted into fields | 7 |
| 3 | PDSA Micro-Test: predict what rule should fire, do action, study whether it fired, act on result | WEB-DEMING-PDSA | High for live-use proof | Better for tests than every action | 8 |
| 4 | Jidoka Stop: stop immediately when a rule-not-fired abnormality appears | WEB-TOYOTA-JIDOKA | High: matches rule-not-fired alarm | Stop-only, not enough to choose route | 7 |
| 5 | Configuration Baseline Check: compare current control state to expected baseline before action | WEB-NIST-CM | High for state drift | Too heavy if done as full baseline every time | 7 |
| 6 | DRI Stamp: name who owns the next action or decision | WEB-GITLAB-DRI | Medium-high: reduces ambiguity | User owns final call, assistant owns working recommendation only | 6 |
| 7 | Mini Postmortem After Miss: if rule fails, write event, cause, action, owner, proof | WEB-SRE-POST, WEB-ATL-POST | High after failures | Reactive, not preventive by itself | 7 |
| 8 | Cynefin Mode Check: classify clear/complicated/complex before selecting method | WEB-CYNEFIN | Medium: blocks one-rule-fits-all | Too abstract for the current top seam | 5 |
| 9 | ADR for route decisions: record context, options, decision, consequences | WEB-ADR | Medium: good for durable choices | Too much for every route selection | 5 |
| 10 | Five Whys before every action | WEB-ASQ-RCA | Low-medium: good after failure | Overkill before normal work | 4 |

## Best Fix

Selected:
Candidate 1 - Runbook Card Upgrade.

Shape:
Use the existing Rule-Firing Confirmation Card, but require it to name:
- expected outcome;
- working owner/judge for this action;
- stop condition;
- proof artifact;
- allowed disposition.

This is not a new doctrine file. It is a recommended next-use improvement.

## Proof To Myself

Claim:
The Runbook Card Upgrade is the best fit for Boss Wave 01.

Evidence:
- Local rule already requires State, Intended action, Fired gate, Why it fired, Blocked, Proof needed, and Disposition.
- AWS runbook/playbook guidance supports documented steps for expected outcomes.
- Google/Atlassian postmortem sources show that action items need tracking and ownership after failures.
- NIST baseline thinking supports state verification before trust.

Inference:
Candidate 1 wins because it strengthens the existing house card instead of importing a new framework. It adds missing closure fields that directly prevent "rule was stored but did not actually fire."

Why not the others:
- OODA and PDSA are useful cycles but need translation into card fields.
- Jidoka catches misses but does not choose the route.
- Baseline checks are useful but heavier.
- ADR/Five Whys are too heavy as default entry behavior.

Disproof test:
If the upgraded card makes normal work slower without catching wrong-route starts, it should be narrowed or parked.

Verdict:
BEST / APPLY AS NEXT-USE CANDIDATE, not installed.

Next clean action:
Use the upgraded card shape on the next read-only RCE/full-report gate inspection.

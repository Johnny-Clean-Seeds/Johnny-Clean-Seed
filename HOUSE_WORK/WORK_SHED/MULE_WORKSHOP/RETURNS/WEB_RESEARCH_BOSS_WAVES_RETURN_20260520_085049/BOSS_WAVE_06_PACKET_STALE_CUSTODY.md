# BOSS WAVE 06 - PACKET / STALE / CUSTODY ROBUSTNESS

## Boss Target

Packet/stale/custody issues can create false success, false stale blocks, or unsafe adoption.

Local evidence:
- Whirlpool output noted wrapper/root and REPO_ROOT byte-form friction.
- Big Overall mule return disposition says packet-time PASS is evidence but later stale result blocks command-authority use.
- Current run is output-only and does not repair packet builders.

## Up To 10 Better Fix Candidates

| # | Candidate fix | Web seed | House fit | Tradeoff | Score |
|---:|---|---|---|---|---:|
| 1 | Packet Baseline Contract Test: manifest, expected root, immutable hashes, stale result, mutation block | WEB-NIST-CM, WEB-AWS-RUN | Very high: direct fit for stale/hash custody | Needs a later approved test/edit scope | 10 |
| 2 | Jidoka Hash Stop: stop on mismatch, classify custody vs adoption, no mutation | WEB-TOYOTA-JIDOKA | High: blocks unsafe adoption | Does not repair packet builder by itself | 8 |
| 3 | PDSA Packet Builder Trial: predict, build, stale-check, study, narrow | WEB-DEMING-PDSA | High for future repair | Needs test packet and approval | 8 |
| 4 | Configuration Change Record for packet templates | WEB-NIST-CM, WEB-ADR | High for durable template changes | Too heavy if no edit selected | 7 |
| 5 | Runbook for return intake | WEB-AWS-RUN | High: current house already has pieces | Needs exact local commands if installed later | 7 |
| 6 | Postmortem for stale-check false block | WEB-SRE-POST | Medium-high: good after failure | Reactive, not full prevention | 6 |
| 7 | Toil filter for packet automation | WEB-SRE-TOIL | Medium-high: prevents overbuilding checker system | Does not solve checksum semantics | 6 |
| 8 | DRI packet owner boundary | WEB-GITLAB-DRI | Medium: clarifies user/assistant/worker | Not enough technical proof | 5 |
| 9 | NASA lesson card for stale checks | WEB-NASA-LL | Medium: reusable lesson | Risk of lesson-index bloat | 4 |
| 10 | Cynefin domain check | WEB-CYNEFIN | Low-medium: not needed for concrete packet bug | Too abstract | 3 |

## Best Fix

Selected:
Candidate 1 - Packet Baseline Contract Test.

Shape:
For a future approved packet-builder repair:
- expected packet root;
- expected output lane;
- manifest hash list;
- allowed mutable files;
- stale-check result source;
- no manifest regeneration after mutation;
- custody/import allowed even when adoption is blocked;
- pass/fail text that separates packet-time PASS from current-command authority.

## Proof To Myself

Claim:
Packet Baseline Contract Test is the best fit for packet/stale/custody robustness.

Evidence:
- NIST configuration management supports baselines, controlled changes, and monitoring.
- AWS runbook idea supports repeatable steps for expected operations.
- Local Whirlpool and Big Overall evidence show stale/custody friction was real but not current top boss.

Inference:
This fix directly addresses the failure class without rewriting old packets or building a runtime. It is a future repair candidate because it needs an approved packet-builder test scope.

Why not the others:
- Jidoka stops unsafe behavior but does not define baseline contract.
- PDSA is the future test method, not the contract itself.
- ADR/change record is useful only once a repair is selected.
- Postmortem is reactive.

Disproof test:
If a future packet repair fails despite the contract, the contract missed a required field or allowed mutation path.

Verdict:
BEST / PARK UNTIL PACKET-BUILDER SCOPE IS SELECTED.

Next clean action:
Do not repair packet builder now. Keep this as a future candidate after RCE/full-report gate inspection.

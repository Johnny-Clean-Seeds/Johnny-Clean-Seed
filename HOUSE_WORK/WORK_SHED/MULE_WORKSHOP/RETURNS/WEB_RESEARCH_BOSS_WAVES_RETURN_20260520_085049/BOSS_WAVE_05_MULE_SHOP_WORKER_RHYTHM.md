# BOSS WAVE 05 - MULE / SHOP / WORKER RHYTHM

## Boss Target

Mule and shop work must sharpen the house without becoming supervisor, output treadmill, or stale active packet pressure.

Local evidence:
- ACTIVE_ANCHOR blocks another mule pass by inertia.
- Mule Workshop README says mule is a bounded worker/sharpener/critic, not supervisor.
- Active desk points to older packet/base and is a watch item.
- Whirlpool soft loadout says use mule/worker passes for heavier structured review or generation only.

## Up To 10 Better Fix Candidates

| # | Candidate fix | Web seed | House fit | Tradeoff | Score |
|---:|---|---|---|---|---:|
| 1 | Runbook/Playbook Split: local runbook for routine checks, mule playbook only for investigation/critique | WEB-AWS-RUN | Very high: directly decides when mule is worth it | Needs current-state check before use | 10 |
| 2 | DRI/RACI Worker Boundary: user approves, house judges, mule sharpens | WEB-GITLAB-DRI | High: protects authority | Needs local wording | 8 |
| 3 | Toil Filter: reject mule/output loops that add work without durable value | WEB-SRE-TOIL | High: fights output treadmill | Needs proof of toil/value | 8 |
| 4 | Postmortem action ownership for mule recommendations | WEB-SRE-POST, WEB-ATL-POST | High after returns | More intake/report focused than send/no-send | 7 |
| 5 | Jidoka stop on stale packet or custody mismatch | WEB-TOYOTA-JIDOKA | High for stale/custody | Stop condition only, not routing | 7 |
| 6 | OODA cadence: one worker pass, observe result, reorient before next | WEB-USMC-OODA | High: blocks batch by inertia | Abstract unless made into fields | 7 |
| 7 | PDSA mule trial | WEB-DEMING-PDSA | Medium-high: test one worker pass before standardizing | Already happened with Whirlpool 001 | 6 |
| 8 | ADR for mule send decision | WEB-ADR | Medium: good for big sends | Too heavy for normal send/no-send | 5 |
| 9 | NASA lesson reuse from past mule runs | WEB-NASA-LL | Medium: helpful history | Could become lesson-index pressure | 5 |
| 10 | Cynefin check for when outside critique is needed | WEB-CYNEFIN | Medium: helps complex cases | Too abstract as primary gate | 5 |

## Best Fix

Selected:
Candidate 1 - Runbook/Playbook Split.

Shape:
- Routine local check = runbook: direct file read/search/status, no mule.
- Unclear, conflicting, high-risk, broad critique, or edge-sharpening need = playbook: one bounded mule/worker pass.
- After any worker pass, intake/disposition before another pass.

## Proof To Myself

Claim:
Runbook/Playbook Split is the best fit for mule/shop rhythm.

Evidence:
- AWS distinguishes runbooks for routine expected work and playbooks for issue investigation.
- Local mule rule says use mule for deep sweeps, hard critique, edge sharpening, outside comparison, not standing supervision.
- Whirlpool Run 001 warned against three more runs before intake/disposition.

Inference:
This fix names the exact boundary that keeps mule useful: routine local state work stays local; non-mundane investigation may use a bounded worker. It is smaller than a dashboard or new shop index.

Why not the others:
- DRI/RACI helps authority but not when to call mule.
- Toil filter is important but follows after the split.
- OODA/PDSA are useful rhythm checks but less concrete.
- ADR is too heavy for every mule decision.

Disproof test:
If a local runbook check cannot answer the seam and a bounded mule playbook would clearly sharpen it, refusing mule would be too rigid.

Verdict:
BEST / APPLY AS ROUTING CANDIDATE.

Next clean action:
Do not run mule next. The visible RCE/full-report inspection is routine local work.

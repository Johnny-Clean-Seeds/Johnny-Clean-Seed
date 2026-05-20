# BOSS WAVE 07 - WIP / OUTPUT BURDEN / TOO MANY RETURNS

## Boss Target

The house can produce more reports, loops, and candidates than it can intake, causing proof burden and route fog.

## Candidate Fixes Considered

| # | Candidate | Source seed | Strength | Weakness | Score |
|---:|---|---|---|---|---:|
| 1 | Kanban WIP Limit: one open return awaiting intake before more analysis | WEB-KANBAN | Best direct fit for output burden | Needs user override path | 10 |
| 2 | SRE Toil Filter | WEB-SRE-TOIL | Strong value check | Needs definition of durable value | 8 |
| 3 | Toyota Waste Lens | WEB-TPS | Good anti-bloat | Must not become deletion/cleanup | 7 |
| 4 | DORA Flow Capability | WEB-DORA | Good throughput/quality lens | Software-delivery oriented | 6 |
| 5 | A3 problem alignment | WEB-A3-LEI | Good before a large report | Too much for every output | 6 |
| 6 | Team Topologies cognitive load pulse | WEB-TEAMTOPO | Good load awareness | Team metaphor | 6 |
| 7 | CISA playbook phase gate | WEB-CISA-PLAY | Good stage discipline | Incident-specific | 5 |
| 8 | NIST risk acceptance | WEB-ISO31000 | Good risk call | Too formal | 5 |
| 9 | ADR "why another return" | WEB-ADR | Good for big decisions | Too heavy | 4 |
| 10 | PDSA experiment cap | WEB-PDSA | Good trial discipline | Less direct than WIP | 5 |

## Best Fix

Winner:
Kanban WIP Limit.

Working shape:
Before creating another return/report:
- Are there un-intaken return packages?
- Is the new run explicitly requested by user?
- Does it produce new decision value?
- Will it name one next action?
- Does it avoid opening multiple active bosses?

Soft WIP rule:
One open recommended next inspection at a time, unless the user explicitly requests another evidence package.

## Proof To Myself

Why this wins:
Kanban directly addresses too much work in progress. The current pattern shows multiple output folders can exist before the next local inspection is worked. WIP limit is the smallest idea that stops report pileup without blocking explicit user requests.

Why not Toil Filter:
Toil filter is useful, but WIP limit gives a clearer operational rule.

Disproof:
If the user explicitly needs parallel evidence packages for comparison, a hard WIP limit would be wrong. This should stay soft and user-overridable.

Verdict:
BEST CANDIDATE FOR WAVE 07 / APPLY AS SOFT GUARD.

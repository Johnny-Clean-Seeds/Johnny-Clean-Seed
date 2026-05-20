# BOSS WAVE 05 - MULE / SHOP / WORKER RHYTHM

## Boss Target

The mule/shop must sharpen work without becoming supervisor, output treadmill, stale active packet, or cognitive load dump.

## Candidate Fixes Considered

| # | Candidate | Source seed | Strength | Weakness | Score |
|---:|---|---|---|---|---:|
| 1 | Team Topologies Role Split: house stream, mule enabling/complicated-subsystem helper, shop platform | WEB-TEAMTOPO | Best role/cognitive-load fit | Must be metaphor only, not org doctrine | 10 |
| 2 | Runbook/Playbook Split | prior AWS/CISA sources | Strong send/no-send rule | Less precise about roles | 9 |
| 3 | Toil Filter | WEB-SRE-TOIL | Blocks output treadmill | Needs value test | 8 |
| 4 | Kanban WIP Limit for mule returns | WEB-KANBAN | Prevents too many open returns | Needs explicit WIP policy if installed | 8 |
| 5 | Gemba Before Mule | WEB-GEMBA-LEI | Forces local read before outside worker | Already mostly active | 7 |
| 6 | A3 before mule send | WEB-A3-LEI | Clarifies problem before handoff | Too heavy for routine checks | 6 |
| 7 | CISA playbook for mule return intake | WEB-CISA-PLAY | Good process shape | Incident framing too heavy | 6 |
| 8 | DORA cognitive load/maintainability lens | WEB-DORA | Good capability framing | Indirect | 5 |
| 9 | ADR mule decision | WEB-ADR | Good for major mule pass | Too much for normal use | 5 |
| 10 | FRACAS for bad mule output | WEB-FRACAS-DAU | Good if mule creates failure | Reactive only | 4 |

## Best Fix

Winner:
Team Topologies Role Split.

Working shape:
- House = stream-aligned owner of current value/work.
- Mule = enabling or complicated-subsystem helper only when outside critique/deep search is worth it.
- Workshop = platform-like bench that reduces load, not a supervisor.
- Active anchor/user command = authority boundary.

## Proof To Myself

Why this beats Runbook/Playbook:
Runbook/playbook says when to use a worker. Team Topologies says what role the worker and shop have so they do not steal ownership. The current repeated risk is not only "when mule?" but "mule becomes supervisor." Role split is cleaner.

Why it is better:
- Reduces cognitive load without transferring authority.
- Explains why shop exists: platform bench, not boss.
- Explains why mule can help: enabling/complicated helper, not stream owner.

Disproof:
If team-topology language starts creating organizational bloat, drop the names and keep only the role split.

Verdict:
BEST CANDIDATE FOR WAVE 05 / USE AS ROLE LENS ONLY.

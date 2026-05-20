# BOSS WAVE 06 - PACKET / STALE / CUSTODY

## Boss Target

Packet checks must separate custody import, current adoption, stale state, and mutation risk.

## Candidate Fixes Considered

| # | Candidate | Source seed | Strength | Weakness | Score |
|---:|---|---|---|---|---:|
| 1 | FMEA Packet Failure Modes Table | WEB-FMEA-NASA, WEB-FMEA-SWEHB | Best for known packet failure classes | Needs future approved packet scope | 10 |
| 2 | Packet Baseline Contract Test | prior NIST-CM source | Strong state/hash control | Less exploratory than FMEA | 9 |
| 3 | Jidoka Hash Stop | WEB-JIDOKA | Strong stop condition | Does not enumerate failure modes | 8 |
| 4 | BowTie Packet Barrier Map | WEB-BOWTIE-SKY | Good prevention/recovery barrier view | Diagram-heavy | 7 |
| 5 | FRACAS for packet failure | WEB-FRACAS-DAU | Good after failure | Reactive | 7 |
| 6 | CISA playbook phases | WEB-CISA-PLAY | Good response flow | Cyber-specific | 5 |
| 7 | NIST AI RMF Manage/Measure | WEB-NIST-AI-RMF | Good risk loop | Too broad | 5 |
| 8 | ADR for packet format | WEB-ADR | Good durable template choice | Not enough test detail | 5 |
| 9 | Kanban WIP limit on packets | WEB-KANBAN | Prevents many packet repairs | Not packet correctness | 4 |
| 10 | A3 packet problem | WEB-A3-LEI | Good if doing repair | Too broad as packet guard | 5 |

## Best Fix

Winner:
FMEA Packet Failure Modes Table.

Working shape:
For future packet-builder repair only:
- Packet element.
- Failure mode.
- Effect.
- Cause.
- Detection.
- Prevention.
- Recovery.
- Proof test.

Known seed failure modes:
- wrong root path;
- stale snapshot;
- hash byte-form mismatch;
- manifest regenerated after mutation;
- output written to wrong lane;
- custody import mistaken for adoption;
- worker output treated as command authority.

## Proof To Myself

Why this beats Packet Baseline Contract:
The contract tells the packet what must be true. FMEA asks how each part can fail. Since the recent packet issues were specific failure modes, FMEA is better for designing the next repair without missing nearby failures.

Why it is better:
- Finds upstream/downstream effects.
- Fits NASA FMEA bottom-up failure propagation.
- Prevents one repaired bug from hiding the next packet bug.

Disproof:
If the next task is only verifying an already-fixed packet contract, baseline test beats FMEA. For designing the repair, FMEA wins.

Verdict:
BEST CANDIDATE FOR WAVE 06 / PARK UNTIL PACKET-BUILDER REPAIR IS SELECTED.

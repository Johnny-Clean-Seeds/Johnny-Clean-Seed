# JOB 02 - REAL WORK QUEUE TOP 10

Packet base HEAD: `e9bc566bb432817f266e6604595172f5e95afb21`

Stale checker passed: yes.

Files read:
- `STATE_SNAPSHOT\ACTIVE_ANCHOR.txt`
- `STATE_SNAPSHOT\TODO_ORDER.txt`
- `STATE_SNAPSHOT\BOSS_GHOST_MAP.txt`
- current TODO files as read-only evidence
- recent status tail

## Finding

EVIDENCE:
The current anchor selects `BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md` as next read target.

INFERENCE:
The top real-work queue should not be newest-file order. It should follow the active anchor, Parent Boss A, and the proof-ranked boss/ghost map.

## Top 10 Real-Work Queue

| Rank | Candidate | Parent Boss | Why Real Work | Proof Needed | First Read Target | Stop Condition | Save Decision | Meta-Loop Risk |
|---:|---|---|---|---|---|---|---|---|
| 1 | Boss/Ghost Rule-Firing Cycle Flow | A: Rule Activation / Work-Order Control | Makes TODO room stop acting like a flat pile. | One TODO route is selected by parent boss and proof. | `HOUSE_WORK\TODO\BOSS_GHOST_RULE_FIRING_CYCLE_FLOW_TODO_20260520.md` | Stop after one route is read-next/parked/blocked/advanced. | Save only if a narrow repair is needed. | Low if kept to one route. |
| 2 | TODO Control Board stale-current wording review | A / TODO support surface | Current-looking support headings can misroute starts. | Direct read proves wording still causes active-command fog. | `HOUSE_WORK\TODO\TODO_CONTROL_BOARD_20260518.md` | Stop if labels are support-only and not blocking. | Narrow wording save only if selected. | Medium. |
| 3 | PowerShell Command Safety active child | A | Repeated command delivery failures affect proof and save reliability. | A real command/script task needs the guard and passes. | `HOUSE_WORK\TODO\POWERSHELL_COMMAND_SAFETY_TODO_20260520.md` | Stop if no command task is active. | Save only if repeat failure exposes gap. | Medium. |
| 4 | Relevant Root Key selector varied use | A | Proves point-of-work selector beyond first TODO read. | Next nontrivial task selects 2-5 keys/tools and changes action. | `HOUSE_WORK\TODO\RELEVANT_ROOT_KEY_AND_TOOL_USE_SELECTOR_LIVE_USE_TODO_20260520.md` | Stop after recording pass/fail. | Do not promote. | Low. |
| 5 | Artifact Self-Check varied artifact use | B: Recursive Carryover | Proves artifact readiness beyond PowerShell/save packages. | Different artifact type is checked before ready. | `HOUSE_WORK\TODO\ARTIFACT_SELF_CHECK_AFTER_SEND_TODO_20260520.md` | Stop after pass/fail proof. | Do not close yet. | Low. |
| 6 | Compose-Review varied live use | B | Tests reflection/capture before long artifacts. | Future long artifact routes new structure or parks it. | `HOUSE_WORK\TODO\COMPOSE_REVIEW_REFLECT_CAPTURE_LIVE_USE_TODO_20260520.md` | Stop after disposition proof. | Do not promote. | Medium. |
| 7 | Filing Cabinet / Relation Method live use | A/B support, cross-lane | Reduces repeated workflow drift and catches cross-lane issues. | Natural repeated workflow or cross-lane issue occurs. | `HOUSE_WORK\TODO\FILING_CABINET_AND_RELATION_METHOD_LIVE_USE_TODO_20260520.md` | Stop if trigger is absent. | No save unless live proof created. | Medium. |
| 8 | No Rule King / Better-Fit live use | A | Prevents old/new rule monarchy when better-fit conflict appears. | Real conflict between old support and better-fit new item. | `HOUSE_WORK\TODO\NO_RULE_KING_BETTER_FIT_PROMOTION_LIVE_USE_TODO_20260520.md` | Stop if no conflict. | No promotion by theory. | Medium. |
| 9 | Source Note Quiet Self-Proof watch | B | Handles pressure/source notes without premature injection. | Future source note is classified, routed, or parked. | `HOUSE_WORK\TODO\SOURCE_NOTE_SELF_PROOF_CAPTURE_DISPOSITION_LIVE_USE_TODO_20260520.md` | Stop after source-note disposition. | Save only if trigger real. | Medium. |
| 10 | Growth Cycle Stage-Readiness lens | C: Growth / Maturity | Helps promotion/compression/scaffold decisions only on natural trigger. | Blocks premature install or names scaffold exit in real case. | `HOUSE_WORK\TODO\GROWTH_CYCLE_STAGE_READINESS_SCAFFOLD_EXIT_LIVE_USE_TODO_20260520.md` | Stop if no maturity trigger. | Park unless trigger appears. | High if forced. |

Recommendation:
APPLY rank 1 as first route. Keep ranks 2-10 as proof-ranked queue, not commands.

Proof needed:
Current assistant/user intake chooses one item and proves the chosen route.

Boundary:
This queue does not edit TODO files and does not override `ACTIVE_ANCHOR.txt`.

Disposition:
APPLY.


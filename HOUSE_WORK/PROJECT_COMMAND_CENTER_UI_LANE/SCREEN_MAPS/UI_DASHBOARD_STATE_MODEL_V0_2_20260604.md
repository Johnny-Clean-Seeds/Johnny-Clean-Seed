# UI Dashboard State Model V0.2

Date: 2026-06-04
Status: CANDIDATE STATE MODEL / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: UI-DASHBOARD-STATE-MODEL-V0-2-20260604

## Boundary

This model defines the panels and data contract for a future UI. It does not create UI code, watchers, live readers, or automation.

| Panel | Purpose | Data needed | Primary actions | Proof/guard |
|---|---|---|---|---|
| Active Task | show current lane, source, scope, StopLine | task id, source handoff, allowed scope, current phase | review last job, build lane | source hash and boundary |
| Root Status | show whether root has loose files | allowed root set, direct root file list, routed source copy | root check, route residue | `ROOT_NO_LOOSE_FILES_CHECK_PASS` |
| Proof Status | show whether claims have receipt support | receipt path, manifest path, hashes, final verdict | show proof | receipt hash and manifest hash |
| Git Status | show clean/staged/untracked state without raw diffs | branch, HEAD, origin/main, staged name-status, dirty leftovers | save gate, lock save | exact staged set and push proof |
| Blockers | show live blockers as work items | blocker id, class, owner, next action, StopLine | burn blocker, show blockers | blocker receipt or parked reason |
| Parked Material | show parked items without calling them closed | parked path, return trigger, reason | open parking, inspect object | return trigger present |
| File/Object Inspector | inspect one path at a time | path, type, hash, owner lane, status, receipt pointer | inspect object | no private/raw dump unless asked |
| Action Queue | show next safe actions | recipe id, target paths, proof needed, forbidden writes | run manual recipe, make handoff | allowed/forbidden file list |
| Receipts | find proof without flooding content | receipt summary, manifest link, hash list, rollback pointer | show proof, review last job | compact proof view |
| Final Judge | decide complete/save/block | required closeout lines, root result, git result, target/helper boundary | save gate, make handoff | no overclaim flags |

## State Lifecycles

| State | Meaning | Allowed next states | Not allowed |
|---|---|---|---|
| `source_intake` | source is read and hashed | `candidate`, `parked`, `rejected` | active claim |
| `candidate` | useful material shaped for lane | `proof_needed`, `ready_for_save`, `parked` | doctrine/current |
| `proof_needed` | needs manifest/receipt/test | `ready_for_save`, `blocked`, `parked` | commit claim |
| `ready_for_save` | exact set and checks are ready | `saved`, `blocked` | broad add |
| `saved` | committed and pushed with proof | `next_build`, `review` | claim external adoption |
| `parked` | intentionally deferred with trigger | `candidate`, `rejected` | closure |
| `blocked` | real stop/ask condition exists | `candidate` after decision | silent skip |

## Does Not Prove

This state model does not prove a live dashboard exists. It proves what a future dashboard must show to keep work reviewable.

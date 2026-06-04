# UI Command Registry V0.2

Date: 2026-06-04
Status: CANDIDATE REGISTRY / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: UI-COMMAND-REGISTRY-V0-2-20260604
Source: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/SOURCE_HANDOFFS/MULE_HANDOFF_UI_LANE_BIG_JOB_PHASE2_EXACT_SAVE_AND_BUILD_20260604.md`

## Boundary

This registry defines command intent, required inputs, output panels, proof needs, and stop gates. It does not run scripts, mutate pointers, install packages, start watchers, or activate tools.

## Command Families

| Family | Canonical command | Aliases | Input pattern | Output panel | Proof needed | Stop gate |
|---|---|---|---|---|---|---|
| Root discipline | `root check` | `check root`, `root status` | optional allowed-root set | Root Status | root file list and allowed/blocked result | loose unknown root item with unclear owner |
| Root discipline | `route residue` | `route root`, `clear root` | path plus route reason | Action Queue | source hash, routed path, post-route root check | destructive move/delete risk |
| Inspection | `inspect object` | `inspect file`, `show object` | path or manifest row id | File/Object Inspector | type, hash, owner lane, receipt pointer | private/credential uncertainty |
| Proof | `show proof` | `receipt`, `show receipt` | receipt path or object id | Proof/Receipt Viewer | receipt summary, manifest hash, verdict lines | missing manifest for claimed proof |
| Save gate | `save gate` | `stage check`, `exact save` | intended path set | Git Status + Final Judge | staged name-status, dirty leftovers, root check | unrelated staged material |
| Save gate | `lock save` | `commit save`, `push save` | approved staged set and message | Git Status | old/new HEAD, push result, HEAD == origin/main | commit requires unrelated unknown material |
| Blockers | `show blockers` | `blockers`, `open blockers` | optional lane | Blockers | blocker table with class and next legal action | blocker lacks owner lane |
| Blockers | `burn blocker` | `fix blocker`, `reduce blocker` | blocker id | Action Queue | before hash, action, after hash, receipt | real stop/ask condition |
| Parking | `open parking` | `show parked`, `parked` | optional lane | Parked Material | parked path, return trigger, reason | parking treated as closure |
| Lane build | `build lane` | `lane build`, `next build` | lane id and allowed scope | Active Task | source, deliverables, boundary, receipt | implementation needed but not authorized |
| Review | `review last job` | `last job`, `last receipt` | optional receipt id | Proof/Receipt Viewer | last receipt, manifest, final lines | missing source custody |
| Pointer read | `show active pointer` | `active pointer`, `current pointer` | pointer id | File/Object Inspector | read-only pointer path and hash | pointer mutation requested |
| Handoff | `make handoff` | `handoff`, `packet` | target lane and scope | Action Queue | compact map, paths, hashes, StopLine | raw dump/private content requested |
| Packaging | `cluster files` | `link cluster`, `package links` | related path set | Action Queue | link cluster, no nested zip proof | nested zip or private export risk |
| Packaging | `no nested zip check` | `zip check`, `package check` | folder or manifest | Proof/Receipt Viewer | archive inventory and verdict | nested archive found |

## Resolution Rule

Resolve commands in this order: exact canonical command, registered alias, family plus object hint, then blocked unknown command. Unknown commands must produce a question or a parked command card, not an invented action.

## Output Rule

Every command output must include: active object, status, proof pointer, next legal action, and a boundary line. Commands that touch files must also include before/after hashes or a reason no hash exists.

## Does Not Prove

This registry does not prove the UI exists, that commands are executable, or that helpers are safe to run. It only proves the intended command grammar for a future UI lane.

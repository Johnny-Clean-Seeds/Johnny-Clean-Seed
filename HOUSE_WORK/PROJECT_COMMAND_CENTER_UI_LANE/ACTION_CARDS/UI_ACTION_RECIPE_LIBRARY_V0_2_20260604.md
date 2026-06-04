# UI Action Recipe Library V0.2

Date: 2026-06-04
Status: CANDIDATE RECIPE LIBRARY / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: UI-ACTION-RECIPE-LIBRARY-V0-2-20260604
Source: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/SOURCE_HANDOFFS/MULE_HANDOFF_UI_LANE_BIG_JOB_PHASE2_EXACT_SAVE_AND_BUILD_20260604.md`

## Boundary

Recipes describe manual-safe action shapes. They do not authorize script execution, automation, watcher startup, pointer mutation, or broad cleanup.

| Trigger command | Required input | Action steps | Allowed files | Forbidden files | Proof required | Receipt output | Closeout verdict | Rollback/custody |
|---|---|---|---|---|---|---|---|---|
| `root check` | allowed-root set | list direct root files, compare to allowed set, report extras | root directory listing | repo code writes | file list and verdict | root check line in receipt | `ROOT_NO_LOOSE_FILES_CHECK_PASS` or blocked | no mutation |
| `route residue` | root path and route class | hash source, copy/move into owner lane, verify hash, remove root only after custody match | source handoff, parking, report rooms | unknown user originals without custody | before hash, routed path, after root check | route receipt row | `GOOD_MATERIAL_EXTRACTED_PROVED_INJECTED_PATHS_UPDATED_READY_FOR_USE` or parked | source path plus routed path |
| `inspect object` | path | classify type, hash, find owner lane, find receipt pointer | object metadata, manifests | content dumps unless asked | path, type, hash, owner lane | inspector summary | `OBJECT_INSPECTED_WITH_BOUNDARY` | no mutation |
| `show proof` | receipt or object id | load receipt summary, manifest hash, final lines | receipt, manifest, path map | full diffs/raw project dumps | receipt hash, manifest hash | proof viewer card | `PROOF_POINTER_FOUND` or missing proof | no mutation |
| `save gate` | intended path set | capture old HEAD, stage exact paths, show staged set, run checks | exact selected files | unrelated dirty/untracked files | staged name-status, root check | save-gate receipt | `EXACT_SET_READY` or exact blocker | unstaged leftovers listed |
| `lock save` | approved staged set | commit, push, verify new HEAD and origin | staged index only | broad git add | old/new HEAD, push result | commit proof receipt | `COMMIT_AND_PUSH_PROVED` | commit hash |
| `show blockers` | lane id | load blocker table, classify each item, choose next legal action | lane reports and receipts | unrelated scans | blocker id and class | blocker panel | `BLOCKERS_VISIBLE` | no mutation |
| `burn blocker` | blocker id | classify, hash affected files, fix/reduce/park, verify, continue | bounded owner lane | protected paths unless authorized | before/after hash and reason | blocker burn receipt | `BLOCKERS_ARE_WORK_ITEMS_NOT_STOP_EXCUSES` | rollback row |
| `open parking` | lane id | list parked items and return triggers | parking maps, TODOs | treating parking as closure | parked path and trigger | parking panel | `PARKED_WITH_RETURN_TRIGGER` | no mutation |
| `build lane` | lane id and allowed scope | read source handoff, build allowed docs/specs, manifest, receipt | chosen lane | live app, watcher, helper execution | manifest and receipt hashes | lane build receipt | lane-specific complete/blocker line | rollback manifest |
| `review last job` | optional receipt | read last receipt and manifest only | receipt/proof files | broad project crawl | source, manifest, verdict | review card | `REVIEW_CAN_VERIFY` | no mutation |
| `show active pointer` | pointer id | read pointer only, no mutation | pointer file if allowed | pointer write | path and hash | pointer read card | `POINTER_READ_ONLY` | no mutation |
| `make handoff` | target lane | produce compact paths/status/hashes/StopLine | report room | raw dumps/private exports | hashes and boundary | handoff file | `HANDOFF_READY_FOR_DECISION` | handoff path |
| `cluster files` | path set | group links by object, avoid nested zips, add manifest | reports/receipts | nested archive export | cluster map and no-nested proof | package receipt | `PACKAGING_LINK_CLUSTER_RULE_APPLIED` | manifest path |
| `no nested zip check` | folder/manifest | inspect archive names and nesting, report only | package metadata | opening private archives broadly | archive list and verdict | zip check card | `NO_NESTED_ZIPS` or blocked | no mutation |

## Recipe Closeout Rule

Any recipe that writes files must end with a manifest path, receipt path, root check, and explicit target/helper boundary.

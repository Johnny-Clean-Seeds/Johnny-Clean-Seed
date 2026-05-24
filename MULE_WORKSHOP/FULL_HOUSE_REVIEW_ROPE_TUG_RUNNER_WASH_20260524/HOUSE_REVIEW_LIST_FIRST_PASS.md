# House Review List First Pass

Status: FIRST WALK / REVIEW LIST / SUPPORT ONLY
Date: 2026-05-24

## Method

Walked the house through:

- root drop zone state;
- Git status and missing tracked files;
- current suit support;
- existing rope-note, washer, sorting, runner, and release rules;
- previous whole-house wash packets;
- top-level house directory shape.

This was not a line-by-line audit of all 3059 repo files. It was an affected-scope house walk for
the user's current request.

## First List

| # | Finding | Evidence | Disposition |
|---|---|---|---|
| 1 | Parent `123` drop zone had no loose top-level files, but it still had routed material in parent-level directories. | Parent root contained `COMMAND_CENTER`, `Tanscripts`, and a local-only idea cell; this pass also briefly created parent-level `BRAIN_LEARNING` and `MULE_WORKSHOP` before the placement snag was caught. | FIXED. Routed Git-safe/source material into the house and local-only material into ignored local-only house custody. |
| 2 | Git tree started clean. | `git status --short --branch` showed `## main...origin/main`. | PASS. No mystery dirty pile this pass. |
| 3 | All tracked files are present locally. | Missing tracked file check returned no paths. | PASS. Verify again before final lock. |
| 4 | Rope-note visibility already exists and is good. | `ROPE_NOTE_WEIGHT_VISIBILITY_GATE_20260524.md` scales notes by need, proof, fog, recurrence, time-risk, neighbor fit, and user correction. | KEEP. Do not duplicate. |
| 5 | Note burning exists but is buried. | Broad command washup says to burn dead weight into final rule, checklist, evidence ledger, parked item, rejected item, or receipt. | FIX. Add a dedicated note-burning hook. |
| 6 | Tug rule is implied but not named. | Rope-note and active-object rules say to pause when foggy, but "tug" is not a named checkpoint. | FIX. Add tug rule. |
| 7 | Cut-the-rope needs a safe release model. | Existing runner lifecycle closes used runners, but notes need a runner trace when active weight is cut. | FIX. Add cut with runner trace rule. |
| 8 | Washer exists but needs a repeatable return habit for this pattern. | Next Issue Clean Wash routine exists, but this request asks for repeated washer use across list, soft suit, creative room, and final lock. | FIX. Add washer return habit loop. |
| 9 | Sorting is strong, but sorting/mapping/scheduling are scattered. | Sort-before-judgment, work request formula, C4/PROV-style ideas, and scheduling routines live in separate places. | FIX. Add one small control stack. |
| 10 | Soft suit should stay light. | Current suit says max three active soft-suit bosses and support links do not count as hard-suit pack weight. | KEEP. Test candidates temporarily, do not overload. |
| 11 | Path/home truth remains a parked fog item. | Previous packet notes old path names and suit path labels that do not match the live `HOUSE_WORK/SUIT_SYSTEM` room. | PARK. Needs scoped path/home truth pass. |
| 12 | Raw transcript source from the parent drop zone needed clean custody. | `Tanscripts` held raw SRT source folders. | FIXED LOCAL. Raw SRT moved to ignored local-only house custody; Git-facing pointer saved in `SOURCE_ORE/USER_DROPS/ROOT_TANSCRIPTS_CLEARED_20260524_100700/README.md`. |
| 13 | Local-only idea/evidence cell belonged inside the house boundary but outside Git. | Parent root held a `TOP_SECRET...LOCAL_ONLY` cell. | FIXED LOCAL. Moved into `MULE_LOCAL_ONLY` under its ignored name; not staged. |
| 14 | Repo root surface has old tracked artifacts. | Top-level includes old scripts, public notes, data crawl, and root guides. They are tracked, not parent-drop loose files. | PARK. Do not move without scoped root-surface review. |
| 15 | Outside methods are useful only as lenses. | Prior packet already parked full graph databases, numeric engines, automation, and heavy ADR systems. | KEEP BOUNDARY. Use small checks only. |

## Note Burn Needs From First Pass

| Note | Burn result |
|---|---|
| "Get louder with weight or time" | Convert to bounded visibility and time-risk; reject age-alone loudness. |
| "Never let bad ideas in" | Convert to bad idea filter: source pressure is tested before adoption. |
| "Tug the rope" | Convert to named checkpoint rule. |
| "Cut the rope" | Convert to cut-with-runner trace, not forgetting or deletion. |
| "Runner trace to roots" | Convert to small root map: source/root -> object -> relation -> room -> rule -> destination -> proof -> return trigger. |
| "Best sorting/mapping/scheduling" | Convert to one control stack, not many foreign bosses. |
| "Washer as habit" | Convert to event-based wash cadence and stop condition. |

## First Pass Verdict

The house is not missing intelligence. It is missing a few named joints:

- a dedicated note burn hook;
- a tug checkpoint;
- a safe cut/release trace;
- an explicit washer habit;
- one small sort-map-schedule stack.

Those are clean additions if they stay support-level and do not rewrite active doctrine.

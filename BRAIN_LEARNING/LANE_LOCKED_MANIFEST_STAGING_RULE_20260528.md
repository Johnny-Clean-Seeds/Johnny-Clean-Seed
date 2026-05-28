# Lane-Locked Manifest Staging Rule — 20260528

Status: LOCK-SAVE CANDIDATE / ASSISTANT-FACING BEHAVIOR / SAVE-SCRIPT RULE
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX
Purpose: prevent ignored-path Git save failures and unsafe force-add repairs by requiring lane judgment, object identity proof, staged-scope proof, and explicit end-state proof.

## Core rule

Ignored paths may be force-added only through Lane-Locked Manifest Staging.

The order is:

1. Lane Lock — decide whether the ignored artifact belongs in tracked Git, local-only custody, or a different durable lane.
2. Manifest — list exact intended paths, role, lane, reason, allowed Git action, size, and SHA256.
3. Hash Key — prove object identity before staging and again immediately before any force-add.
4. Ignore Witness — record why Git considers the path ignored when an override is needed.
5. Force-Add Token — allow `git add -f` only per save, per exact file, per matching hash.
6. Staged Set Seal — verify the staged set equals the intended changed/staged set and contains no extra files.
7. Remote Seal — after commit/push, verify HEAD equals origin/main and final status is clean.
8. End-State Label — close as CLEAN_CLOSE, BLOCKED_WITH_RETURN_POINT, CHOKE_STOP, CHOKE_CAUSED_END, or USER_STOP.

## What the hash proves

A hash proves object identity. It does not prove quality, lane correctness, authority, doctrine, or PASS.

Hash proof must be paired with lane fit, washer/content judgment, staged-path scope verification, commit/push proof, and final clean Git proof.

## What the manifest proves

A manifest proves intended scope only if it was built from a locked save object and then verified against the staged set.

A manifest built by globbing whatever changed is not clean proof. It must come from the declared save object and expected artifact list.

## Ignored path three-door decision

When an intended artifact is ignored by `.gitignore`, choose one:

- MOVE_TO_TRACKED_LANE — the file belongs in Git, but the current lane is wrong.
- LOCAL_ONLY — the file should not be committed.
- TRACK_IGNORED_FORCE_ALLOWED — the ignored lane is intentionally tracked for this narrow save, with exact-file force-add only.

Default is not force-add. Default is lane judgment.

## Exact force-add only

Blocked:

- no folder force-add;
- no wildcard force-add;
- no parent-directory force-add;
- no force-add without a manifest entry;
- no force-add when the current hash differs from the manifest hash;
- no force-add permission carrying into later saves.

## Save-script close states

CLEAN_CLOSE means the save object completed, commit/push proof passed, remote matched, and final status was clean.

BLOCKED_WITH_RETURN_POINT means the save stopped safely with a known blocker and next return point.

CHOKE_STOP means a limit, tool failure, execution failure, or fog stopped the task before clean closure.

CHOKE_CAUSED_END means a choke made the work look finished or forced a fake ending. This is never done.

USER_STOP means the user stopped or redirected the run.

## Soft Suit behavior now locked by this save

Use this rule for lock-save scripts, generated local helpers that write Git artifacts, ignored-path exceptions, cockpit/drop-copy saves, and any repeated save route that previously failed from ignored path handling.

Do not use this rule to promote doctrine, rewrite ACTIVE_GUIDES, rewrite CURRENT_TRUTH_INDEX, or bypass Code Gate.
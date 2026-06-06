# Lossless Removal and Compression Accounting Rule

Date: 2026-06-04
Status: BRAIN LEARNING RULE / PROTECTED CORE / USER-CORRECTION CAPTURE
WorkKey: LOSSLESS-REMOVAL-COMPRESSION-ACCOUNTING-20260604
RuleId: CS-RULE-LOSSLESS-REMOVAL-COMPRESSION-ACCOUNTING-20260604

## Trigger

This rule fires before any action that compresses, removes, deletes, moves out, parks, routes, prunes, dedupes, retires, overwrites, replaces, shrinks, exports, archives, or changes live carry of data, files, folders, rules, tools, concepts, ledgers, receipts, scripts, prompts, or project materials.

Default judgment:

`NOT_ACCOUNTED_FOR_MEANS_NOT_ALLOWED`

## Protected Core

LOSSLESS_ACCOUNTING_PROTECTED_CORE_BEGIN

1. Any compression, archive creation, delete, move out, route to custody, prune, cleanout, dedupe, shrink, overwrite, replacement, retirement, removal from live carry, or data-bearing transformation must be fully accounted before finalization.
2. Fully accounted means the record names what was there before, what changed, what is there now, what rule/gate/method was applied before, what rule/gate/method is applied now, why the choice was made, who/what authorized the scope, source path, destination path, action kind, bytes, hashes when available, file counts for directories, timestamp, status, what was preserved, what was lost or not proven, where recovery/custody lives, and how to verify it.
3. If a rule, file, folder, tool, concept, receipt, ledger, prompt, script, archive, or source object is changed, the accounting must state the old rule/state, the new rule/state, exactly what the rule was, exactly what it is now, and why the change was chosen.
4. If proof cannot be made, the action is blocked or must be marked `UNPROVEN_ACCOUNTING_BLOCKED`; do not call it clean, done, compressed, removed, moved, parked, restored, or safe.
5. This protected core cannot be removed, weakened, bypassed, superseded, narrowed, paused, exempted, or overridden by any later rule, code, cleanup, compression, reducer, installer, helper, worker, automation, or interpretation. Conflicts resolve in favor of more accounting, more preservation, and more recovery proof.
6. This protected core may only be changed by additive language that keeps or strengthens every protection here. Additions cannot create exceptions that reduce protection.
7. If removal, alteration, weakening, or bypass is attempted, the attempt is invalid. The guard rule/code must restore or reinsert this protected core before any further compression, move, removal, cleanup, retirement, or live-carry change continues.
8. This rule protects all files, folders, rules, tools, concepts, receipts, ledgers, scripts, archives, prompts, source ore, proof history, live/project materials, and custody materials unless the user explicitly creates a narrower protected replacement with equal or stronger accounting language.

LOSSLESS_ACCOUNTING_PROTECTED_CORE_END

## What Fully Accounted Means

Minimum accounting record:

- item identity;
- original path;
- original role or lane;
- original bytes and file count when available;
- original hash for files and hash ledger for recovered/copied sets when reasonable;
- action attempted or completed;
- destination path or custody path;
- new bytes and file count when available;
- new hash or hash ledger when reasonable;
- reason for the action;
- rule/gate/method before the action;
- rule/gate/method after the action;
- user approval or active scope basis;
- what was preserved;
- what was not preserved or not proven;
- recovery route;
- verification command, receipt, manifest, or ledger;
- final status.

## Compression Rule

Compression is not deletion-proof by itself.

Before a zip, 7z, tar, gzip, packed folder, reduced summary, or compressed transfer replaces or removes live material, the work must prove:

1. the source set;
2. the archive path;
3. archive contents;
4. source-to-archive mapping;
5. byte/file-count comparison;
6. hash or manifest proof;
7. why compression was chosen;
8. whether the source remains, moves to custody, or is blocked from removal.

No source may be deleted or treated as disposable merely because an archive exists.

## Move-Out Rule

Moving data out of the active lane counts as removal from that lane.

The move must record:

- where it was;
- where it went;
- why the old lane stopped being correct;
- why the new lane is correct;
- what links, indexes, manifests, and receipts changed;
- what would disprove the move;
- how to recover or inspect the moved material.

## Rule-Change Rule

Changing a rule is a data-bearing transformation.

The change record must name:

- old rule text or old rule summary;
- new rule text or new rule summary;
- exact before/after difference;
- why the change was chosen;
- what protection stayed unchanged;
- what protection increased;
- what would count as weakening;
- where the proof and receipt live.

## Guard Rule

The companion guard is:

`_TOOLS_AND_SCRIPTS\LOSSLESS_ACCOUNTABILITY_RULE_GUARD_20260604.ps1`

The guard checks that the protected core exists in this file. If the rule file is missing or the protected core is absent/altered, the guard recreates or appends the protected core and writes a receipt.

The guard does not authorize deletion, broad cleanup, watcher installation, automation, or moving user files. It is a repair/proof tool for this rule only.

## Closeout Lines

Clean pass:

`LOSSLESS_ACCOUNTING_RULE_APPLIED`

Blocked:

`UNPROVEN_ACCOUNTING_BLOCKED`

Guard repaired:

`LOSSLESS_ACCOUNTING_PROTECTED_CORE_RESTORED`

Attempt rejected:

`LOSSLESS_ACCOUNTING_RULE_WEAKENING_ATTEMPT_INVALID`

## Boundary

This rule does not authorize cleanup by itself.
It does not authorize deletion.
It does not authorize moving user originals.
It does not authorize compressing source material away.
It does not rewrite ACTIVE_GUIDES or CURRENT_TRUTH_INDEX.
It does not install a watcher or automation.

It requires proof before any compression, removal, move-out, cleanup, or rule/data transformation can be called complete.

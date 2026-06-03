# CleanSeed Phase 1 Triage Source Custody Rule

Date: 2026-06-01
Status: BRAIN_LEARNING / SOURCE CUSTODY CANDIDATE / NOT DOCTRINE
SourceWork: _LOCAL_CUSTODY_AND_RECEIPTS/LEGACY_CLEANSEED_PHASE1_TRIAGE_20260516

## Purpose

Old cleanup inventories and safe snippets are source custody, not cleanup permission.

The Phase 1 triage report says its boundary was read-only:

- no delete;
- no move;
- no rename;
- no source edits;
- no script execution from target;
- no archive extraction;
- no hidden/system files included.

Those limits must travel with the files.

## Useful Concepts Preserved

- size-first triage;
- exact duplicate groups;
- normalized text duplicate groups;
- risky/skipped list;
- empty-file list;
- gold-pan review lane;
- safe snippets as preview only;
- big-bundle content skipped;
- next phase requires review before cleanup.

## Bad Crossings

```text
INVENTORY -> CLEANUP_PERMISSION
DUPLICATE_GROUP -> DELETE
SAFE_SNIPPET -> FULL_SOURCE
GOLD_REVIEW -> ADOPTION
EMPTY_FILE -> TRASH
OLD_TRIAGE -> CURRENT_STATE
```

## Use

When legacy cleanup reports return, load them as custody:

1. read the README first;
2. confirm target/source path;
3. confirm date and phase;
4. choose one review lane;
5. do not delete or move from inventory alone;
6. write a fresh decision receipt for any later cleanup action.

## DoesNotProve

This candidate does not prove the old inventory is current, complete, or safe for cleanup. It only preserves how to read the legacy triage reports without granting them authority.

## StopLine

Stop before cleanup, deletion, merge, archive extraction, or source edits unless a new bounded cleanup phase is explicitly opened and proved.

# Local Tree Disposition

Status: DIRTY TREE WASH LEDGER / SUPPORT ONLY
Date: 2026-05-24

## Trigger

The user named the repeated problem directly: the working tree had pre-existing modified and
untracked material, and it should not keep appearing as a mystery at the end of saves.

This pass added a prevention rule:

`BRAIN_LEARNING/GIT_DIRTY_TREE_DISPOSITION_BEFORE_LOCK_SAVE_RULE_20260524.md`

and linked it into:

`BRAIN_LEARNING/LOCAL_GIT_SAVE_TRIGGER_RULE_20260522.md`

## Starting Dirty State After Local-Only Split

Status count before this wash packet was written:

| Git status | Count | Disposition |
|---|---:|---|
| modified tracked | 5 | `UPDATE TRACKED` or current pass change |
| untracked | 79 | `ADD TO BUILD` unless content scan required local-only hold |

Modified tracked families:

| File | Disposition |
|---|---|
| `ACTIVE_GUIDES/README_START_HERE.txt` | `UPDATE TRACKED`; Gate Evidence / How-Found support already opened by prior wash. |
| `ACTIVE_GUIDES/CLEAN_SEED_WRAP_GUIDE.txt` | `UPDATE TRACKED`; active guide addendum from prior wash. |
| `ACTIVE_GUIDES/CLEAN_SEED_ALIGNMENT_CHECK.txt` | `UPDATE TRACKED`; alignment hook for Gate Evidence / How-Found. |
| `BRAIN_LEARNING/CONSOLIDATOR_GATE_TRIAL_WATCH_RULE_20260523.md` | `UPDATE TRACKED`; adds `PLACE AS CHECKPOINT` label to prevent loose tiny gates. |
| `BRAIN_LEARNING/LOCAL_GIT_SAVE_TRIGGER_RULE_20260522.md` | `UPDATE TRACKED`; adds dirty-tree disposition checkpoint from this pass. |

New tracked-candidate prevention rule:

| File | Disposition |
|---|---|
| `BRAIN_LEARNING/GIT_DIRTY_TREE_DISPOSITION_BEFORE_LOCK_SAVE_RULE_20260524.md` | `ADD TO BUILD`; direct prevention note requested by user. |

## Local-Only Hold

Sixteen files were moved out of Git-facing lanes into an outside-repo local-only evidence cell.

Hold label:

`GIT_HELD_LOCAL_ONLY_WASH_EVIDENCE_20260524_090000`

Ledger file name:

`LOCAL_ONLY_HOLD_LEDGER_20260524_090000.csv`

The full absolute path is intentionally kept out of the Git-facing packet and remains local-only.

Reason:

Content scan found local-only, raw transcript, sensitive-source, or explicit `local-only / No Git`
markers. These are not trash. They are held locally with a ledger and are not Git material for this
commit.

Additional explicit-no-Git files held during the second wash:

- `COMMAND_CENTER/PICKUP/_PARKING_NOTES/CONSOLIDATOR_TRIAL_WATCH_GATE_REVIEW_20260523_213713.md`
- `COMMAND_CENTER/PICKUP/_PARKING_NOTES/PARKING_TODO_CONSOLIDATOR_TRIAL_WATCH_OUTPUTS_20260523_213713.md`
- `COMMAND_CENTER/RECEIPTS/LOCAL_123_CONSOLIDATOR_TRIAL_WATCH_GATE_REVIEW_RECEIPT_20260523_213713.txt`
- `COMMAND_CENTER/TODO/TODO_CONSOLIDATOR_TRIAL_WATCH_NEXT_CLUSTERS_20260523_213713.md`

## Git-Facing Material Kept For Build

The remaining untracked families are safe house support material unless later staged diff checks show
otherwise:

- `BRAIN_LEARNING` support rules from the prior washer runs.
- `COMMAND_CENTER/PICKUP/_PARKING_NOTES` parking notes and review reports.
- `COMMAND_CENTER/RECEIPTS` source ledgers and receipts that are safe summaries.
- `COMMAND_CENTER/TEMPLATES` support card templates.
- `COMMAND_CENTER/TODO` return-trigger notes.
- `CORE_GUIDE_BACKUPS/CORE_GUIDES_BEFORE_GATE_EVIDENCE_HOW_FOUND_DOCTRINE_WASH_20260524_043525`
  backup copies.
- this whole-house wash packet.

## Clean Disposition Rule

Future broad saves must not treat a dirty tree as normal background noise.

Required closeout fields:

- committed material;
- local-only held material and ledger;
- parked material;
- blocked material;
- final local/Git alignment proof.

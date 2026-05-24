# Root Drop Zone Immediate Intake Rule

Date: 2026-05-24

Status: active housekeeping / source-intake rule.

## Rule

`C:\Users\13527\Desktop\123` is a drop-off zone, not a storage shelf.

When a plain file appears directly in the root of `123`, treat it as a porch/drop event. Read enough
to classify it, move it into the house, preserve a hash, write a receipt, and leave the root clean.

Do not leave root files behind as "already handled" proof. A copied source does not excuse a root
drop still sitting in the drop-off zone.

## Trigger

This fires when:

- a user says a file was dropped in root;
- `Get-ChildItem C:\Users\13527\Desktop\123 -File` shows any file;
- a root file has already been read, copied, or used but remains in place;
- the assistant is about to finish a save while root files remain.

## Clean Handling

1. Inventory root files only.
2. Hash each file before moving.
3. Read or sample enough content to classify it.
4. Move the file into the correct house lane.
5. Hash after move and verify it matches.
6. Write a source disposition and receipt.
7. Create a visible Command Center mail trigger when the drop affects future work.
8. Verify root has no loose files before final status.

## Default Lanes

- Source/user text drops: `SOURCE_ORE/USER_DROPS/<dated-root-drop-folder>/`
- Tool/script drops: command-center tool intake or package review lane.
- Sensitive, private, raw local-only, or credential-like drops: outside-repo local-only hold with
  ledger.
- Unclear drops: review/sorting lane with return trigger.

## Bad Pattern

- Reading a root file and leaving it in root.
- Copying a root file into the house while the original remains in root.
- Saying "handled" when the drop-off zone still contains files.
- Using root as a parking lot.
- Breaking a dropped folder apart before package review.

## Clean Pattern

Root files become named house objects:

`root file -> hash -> read/classify -> move into lane -> receipt -> mail trigger -> root clean`

## Relation

This is a checkpoint under Porch Drop Event Trigger + Package Intake Rule, Incoming Files Clean
Parking Rule, No Parking Without Fit Decision Rule, Root Drop source custody, and Git Dirty Tree
Disposition Before Lock/Save Rule.

It does not delete files. It prevents the drop-off zone from becoming hidden storage.

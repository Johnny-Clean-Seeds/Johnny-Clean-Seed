# TODO — Duplicate / Collision + Branch-Failure Manual Test

Date: 2026-05-30
Status: TODO / PARKED PROOF NEED
Authority: not doctrine

## Purpose

Test the parts that key-code manual intake evidence did not prove.

## Cases

1. Same hash + same key.
Expected: same object / duplicate; no repeat work.

2. Same hash + different key.
Expected: alias or custody review.

3. Different hash + same key.
Expected: collision or changed object; block until reviewed.

4. Broad/wildcard key.
Expected: block unless bounded and approved.

5. Branch A pass + Branch B fail.
Expected: vine does not continue; repair, park, block, or return to operator.

6. Join-back missing.
Expected: whole route remains incomplete.

## Boundary

Manual test only.
No helper script.
No generator.
No watcher.
No automation.
No broad intake.

## Return trigger

Before any scripted intake helper or frame-to-script generator.

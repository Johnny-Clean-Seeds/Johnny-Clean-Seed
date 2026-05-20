# Mule Return Known-Path Pickup And Brain Import Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Status: support rule / routine correction
Parent Boss: Mule Workshop / Return Intake / Rule Activation
Authority: not doctrine, not active guide, not CURRENT_TRUTH_INDEX, not dashboard

## Core correction

If the assistant created the mule packet, recorded the workshop path, and the user says the mule is done, the assistant must not ask where the files are.

The routine is:

1. Use the known mule workshop root.
2. Locate the latest or explicitly named mule packet.
3. Find its `MULE_OUTPUT_DUMP_ONLY` folder.
4. Run/read stale checker if available.
5. Copy the return into a brain custody lane.
6. Preserve the original local workshop evidence.
7. Create an intake report and initial disposition matrix.
8. Commit/push the custody import if the user asked to move/save it to the brain.
9. Only after custody import, read and disposition the return contents.

## Important wording

"Move to brain" in this workflow means place a custody copy into the Mr.Kleen repo/remote brain.

Do not delete the original mule workshop folder unless the user explicitly asks for cleanup after proof. Preserving source evidence is part of clean custody.

## Alarm condition

If the assistant knows the path and still asks the user where the files are, this is a rule-not-fired event.

The missed rule must trigger the rule-not-fired alarm:

- missed rule: known-path mule pickup;
- concept: worker return custody / retrieval routine;
- event: user says mule is done after assistant created packet;
- correction: auto-locate and import with PowerShell.

## Stale boundary

Stale checker result can block adoption but should not block custody import.

If the repo moved after packet creation, import the return as stale/needs-review source material and clearly mark it as not adopted.

## Rule-Concept-Event link

Rule:
Known mule return paths must be auto-used for pickup/import.

Concept:
Path/place/key memory health; worker return custody; rule exists must fire at the point of work.

Event:
After a local mule packet was created, the user said the mule was done and then corrected the assistant for asking where the files were even though the path was already known.

Proof state:
First live repair/import run created this rule and imported the known-path mule return into brain custody. This recovery save also records the proof-guard catch: an exact verification needle mismatch stopped the first script after writes but before commit, and recovery completed from allowed dirty state only.

Boundary:
This rule does not make mule output command authority. It only governs pickup, custody, and intake routing.

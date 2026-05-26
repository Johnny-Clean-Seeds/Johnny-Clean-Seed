# Mule Boss Pool Wheel — Apply-All Repair — V1.1

STATUS: LOCAL-ONLY REPAIR LOCK

VERDICT:
The previous save completed the local file surface but under-applied the same-pass behavior surface.

FAILURE:
The save treated "write local-only mule files" as complete even though the user also required:
- load it in chat;
- keep it in assistant head;
- use it to fill blanks when the actual brain is missing the three local-only mule files;
- make this the new mule-run lock shape.

ROOT CAUSES / WHYS:

1. TASK COLLAPSE TOO NARROW
The active task was collapsed to "create local files" instead of "create local files + apply new operating behavior."

2. LOCAL-ONLY BOUNDARY OVER-WEIGHTED
The no-Git/no-public boundary was handled correctly, but it crowded out the behavioral-carryover requirement.

3. ARTIFACT-VS-BEHAVIOR SPLIT
The file artifact was treated as separate from assistant behavior, even though the user explicitly tied them together.

4. MISSING APPLY-ALL GATE
The save did not require proof that every selected surface was updated before final report.

5. INSTRUCTION PARSING MISS
The phrase "you can load them in the chat too to keep it in your head" should have been interpreted as a required memory/carryover action, not optional commentary.

6. THREE-FILE ABSENCE SIGNAL MISREAD
The note "it is missing from the actual brain" should have triggered a blank-fill memory rule immediately.

7. FALSE COMPLETION RISK
The final report said the local save was done but did not explicitly prove behavioral carryover was also done.

8. MULTI-SURFACE SAVE NOT CHECKED
The task had multiple surfaces: local files, receipt, kickoff, operating memory, final report. The save checked only the local files/receipt surface.

9. NEW-WAY LOCK NOT TREATED AS NEW-WAY
"Make all of this now the new way lock and save" means the run shape becomes default behavior for that class of mule work. It was not enough to write files.

10. NO FINAL COMPLETENESS CHECK
Before final reporting, the assistant should have checked:
- Are all files saved?
- Is local-only boundary preserved?
- Is chat/head carryover applied?
- Is the fill-in-the-blanks rule active?
- Is the receipt/final report explicit about both surfaces?

REPAIR RULE:
For local-only mule support saves, apply-all-at-once is mandatory.

When the user asks for local-only mule run files and also asks to keep them in chat/head/use them to fill blanks/new way/new lock:
1. save/update local files;
2. write receipt;
3. apply chat/head behavior carryover;
4. explicitly report both surfaces;
5. block final PASS if either surface is missing.

BOUNDARY:
- Local-only.
- No Git.
- No push.
- No public export.
- No doctrine promotion.
- No ACTIVE_GUIDE rewrite.
- No CURRENT_TRUTH_INDEX rewrite.

STATE AFTER 20260526 UPDATE:
The old 0 Judge + 12 Gates mule boss-pool wheel is superseded by the Twelve-Gate Refinery for gate-run behavior.

Current order:
Alpha / House Authority Shell opens -> Main Light -> Mirror Water -> Quick Signal -> Sweet Fit -> Red Blade -> Big Sky -> Stone Wall -> Lightning Flip -> Deep Fog -> Root Pit -> Road Pull -> Old Weight Final speaks -> Omega / Outer Final Judge closes.

Current normal-mode speech:
middle gates muted; Old Weight Final speaks; Omega returns final result, placement, proof status, and next action.

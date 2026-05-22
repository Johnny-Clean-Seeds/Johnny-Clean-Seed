# Stop / Issue Notes / Options / Weigh / Verify Active Break Capture — 20260522

STATUS: SORTING BENCH CAPTURE / ACTIVE BREAK FIX / NO PROMOTION

WHAT HAPPENED:
The assistant tried to continue toward a parking-ledger proof-pointer correction after the user identified a deeper process failure. The user clarified the correct rule: when any issue occurs during active work, stop, list issues, take notes, find options, weigh them, fix the active issue, apply the fix to the same problem, and verify it before moving on.

ISSUES:
1. The assistant used rejected repair language.
2. The assistant selected a side issue instead of the active route-control failure.
3. The assistant did not treat STOP_AND_FIX_NOW as a hard stop condition.
4. The assistant needed an option-weighing step instead of jumping to the first useful-looking fix.
5. The assistant needed to prove the fix changed the current behavior/state.

FIX:
Save and apply the Stop / Issue Notes / Options / Weigh / Verify Gate locally and in brain learning.

CURRENT APPLICATION:
The next move after this save is receipt readback and then using the new gate shape. Only after that may the assistant decide whether the parking-ledger proof-pointer fix is the next allowed task.

BOUNDARY:
No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation, dashboard, or broad cleanup.

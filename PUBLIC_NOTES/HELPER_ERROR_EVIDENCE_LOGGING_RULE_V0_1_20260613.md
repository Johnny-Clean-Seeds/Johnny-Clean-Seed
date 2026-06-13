# Helper Error Evidence Logging Rule V0.1

Status: PUBLIC_NOTE / HELPER_ERROR_EVIDENCE_RULE / NOT_DOCTRINE
Date: 2026-06-13

Purpose:
Make helper-guided work preserve errors, proof, and outputs cleanly instead of leaving failures trapped in chat or console scrollback.

## Rule

Every helper-guided task that creates, edits, copies, verifies, scans, bundles, commits, pushes, or otherwise changes a work surface must keep a clean evidence lane.

If an error, blocker, parser issue, missing file, hash mismatch, stale helper, contradictory helper, failed copy, unset proof variable, or false-pass risk appears:

1. Stop the lane.
2. Preserve the exact error text.
3. Record the last clean point.
4. Record the first failing point.
5. Record the command or file path involved.
6. Record what evidence exists and what evidence is missing.
7. Record the lowest cause found so far.
8. Record the containment or fix.
9. Record DoesNotProve.
10. Return a scoped `FAILED`, `BLOCKED`, or `YIELD` verdict until proof passes.

If the problem is missing, stale, weak, contradictory, or too-broad helper coverage, also use:

`PUBLIC_NOTES\HELPER_GAP_AND_CAUSE_LADDER_RULE_V0_1_20260613.md`

That card decides whether the signal is `HELPER_GAP_DETECTED`, `HELPER_STALE_DETECTED`, or `HELPER_CAUSE_LADDER_CLEAR`.

## Negative Test And Cleared Suspect Rule

An intentional negative test is a deliberate bad command, bad path, bad input, missing folder, parser failure, or unsafe scenario run to prove the helper blocks the right thing.

A cleared suspect is a signal that looked like an error, blocker, stale file, bad route, or unsafe state, but was later cleared by evidence.

Do not erase either kind. Save intentional negative tests as `INTENTIONAL_NEGATIVE_TEST` evidence, and save cleared suspects as `CLEARED_SUSPECT` evidence. Both can teach future helpers how failures should look, what not to panic about, and what still needs watching.

For each intentional negative test or cleared suspect, record:

- evidence type;
- suspected issue or deliberate bad condition;
- trigger;
- evidence checked;
- expected result;
- actual result;
- why it passed, failed, or was cleared;
- remaining risk or watch note;
- DoesNotProve.

## Storage Shape

Use a timestamped evidence folder when a script or helper route creates output.

Minimum clean evidence set:

- `REPORTS\FRONT_DOOR_WALK.csv` or equivalent entry-state proof when front-door state matters;
- `REPORTS\CHAT_DROP_LOAD_SURFACE.csv` or equivalent load-surface proof when Chat Drop state matters;
- `REPORTS\BLOCKERS.txt` when blockers exist;
- `REPORTS\FAILED.txt` when the route fails;
- `REPORTS\NEGATIVE_TESTS_AND_CLEARED_SUSPECTS.csv` when intentional bad tests are run or apparent issues are cleared by evidence;
- manifest CSV when files are copied or bundled;
- final README/open-first file for the user;
- combined output file only after it passes validation.

## False Pass Block

No helper file, helper script, or helper-guided agent may print `PASS`, `COMPLETE`, `DONE`, or a green verdict after an unhandled error or missing proof.

If the route cannot prove the output, the route must leave evidence and close dirty.

## Does Not Prove

This rule does not authorize cleanup, deletion, overwrite, Git, GitHub, doctrine promotion, or broad helper creation. It only requires clean evidence capture and honest failure handling for helper-guided work.

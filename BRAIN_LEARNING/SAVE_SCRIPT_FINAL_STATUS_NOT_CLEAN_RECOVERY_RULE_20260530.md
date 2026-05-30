# Save Script Final Status Not Clean Recovery Rule

Date: 2026-05-30
RunId: 20260530_004308
WorkKey: KEY_2E6F99ED9EFE
Status: POWERPLAY LEARNING / SUPPORT RULE / CHECKPOINTED
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX.

## Failure family

A save script can commit/push most work and still fail final clean proof if it modifies or leaves expected artifacts after its last commit.

Live V1.2 failure:

```text
FINAL_STATUS_NOT_CLEAN:
 M HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
?? PROOF_HISTORY/HELPER_GROWTH_CHAIN_FLIGHT_RECORDER_IGNORED_PATH_MANIFEST_20260530_20260530_003414.txt
```

## What happened

V1.2 repaired earlier script errors and reached commit/push behavior, but final status found residual expected artifacts. The correct response is not to rerun old scripts or blame Git. The correct response is to treat those residuals as expected partials only if their exact paths match the known failure family, then stage/commit them with the repair and learning record.

## Repair pattern

- Check repo status before writing.
- Allow only exact expected residual paths.
- Block all unknown dirty paths.
- Carry expected residuals forward into the repair commit.
- Avoid post-commit file edits that cannot be staged before final clean proof.
- Put final HEAD/origin/clean proof in console output or a later explicit receipt pass, not in a file edited after final commit.

## Reopen trigger

Any save helper exits after push with modified/untracked expected artifacts still present.

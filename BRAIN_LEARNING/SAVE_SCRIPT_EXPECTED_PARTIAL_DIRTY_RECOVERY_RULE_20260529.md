# Save Script Expected Partial Dirty Recovery Rule

Status: SUPPORT RULE / HELPER ISSUE LEARNING
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX

## Trigger

Use this when a save route fails after writing or staging planned files, then the repaired save route starts from a dirty repository that contains only the expected partial files from the failed save.

## Failure learned

A repaired save script blocked itself with `DIRTY_REPO_BLOCKED_BEFORE_SAVE` because the earlier failed save had already written/staged the planned hash-key front gate files. The dirty status was not random contamination; it was expected partial state from the same package.

## Rule

Do not blindly continue through a dirty repo. Also do not blindly reset it.

First classify the dirty state:

- expected partial from the same failed save;
- unrelated dirty state;
- unknown dirty state.

Expected partial can be carried forward only when every dirty path matches the planned file set or exact receipt/manifest patterns from the same save family.

Unrelated or unknown dirty state blocks.

## Required behavior

When expected partial is allowed, the repaired script must:

1. capture the full pre-save dirty status;
2. label it as recovered expected partial;
3. include the recovered paths in staged-set verification;
4. preserve the partial evidence rather than pretending the repo was clean;
5. record the event in the save helper living ledger;
6. still finish with commit, push, HEAD equals origin/main, and clean final status.

## Reopen trigger

Reopen if a save route blocks on dirty status that is actually expected partial state, or if a repaired route continues through dirty status without classifying it.
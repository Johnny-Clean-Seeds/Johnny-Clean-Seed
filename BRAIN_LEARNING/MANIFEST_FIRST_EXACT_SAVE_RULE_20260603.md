# Manifest First Exact Save Rule

Status: SUPPORT RULE / SAVE CONTROL CANDIDATE / NOT DOCTRINE
Date: 2026-06-03
Source: RAW_HELPER_CONTROL_BLOCKER_CHAIN_SENTINEL_REPAIR_AND_ROUTER_LESSONS_20260603 root intake
SourceHashSHA256: 6B849A552C356FCFA962D8E7553B24FC8B5B10ED201317FC13D83A084F0254DF
Neighbor: `BRAIN_LEARNING/BRANCH_CUT_SAVE_WRAPPER_MANIFEST_AUTHORITY_RULE_20260529.md`

## Rule

Do not let Git status choose the save. Let the manifest choose the save, then use Git status as evidence.

The manifest must name the intended package before staging or commit-ready language.

## Required Manifest Fields

```text
ExpectedPaths
ExpectedIgnoredPaths
AllowedForceAddExceptions
BlockedPaths
RequiredChecks
FinalSentinel
CloseCondition
RollbackOrStopCondition
ReceiptPath
AfterActionLedgerPath
```

## Exact Save Chain

```text
Read manifest.
Confirm expected paths exist.
Confirm ignored expected paths are intentionally handled.
Stage only expected tracked paths.
Force-add only explicitly allowed exceptions.
Run required checks.
Confirm final sentinel.
Write receipt.
Only then describe the package as save-ready.
```

## Invalid Crossings

```text
GIT_STATUS_AS_PACKAGE_AUTHORITY
IGNORED_FILE_FORCED_WITHOUT_MANIFEST_EXCEPTION
UNTRACKED_FILE_SILENTLY_ABSORBED
STAGED_INDEX_STALE_AFTER_REWRITE
FINAL_SENTINEL_MISSING_BUT_PASS_PRINTED
REPORT_WRITTEN_AS_CLOSE_CONDITION
```

## Does Not Prove

```text
This does not create automation.
This does not install a save tool.
This does not authorize commit or push.
This does not make old WORK_SHED material durable.
```

## Return Trigger

Return here before any exact save, commit, or package-close operation where the staged set is not explicitly tied to a manifest.

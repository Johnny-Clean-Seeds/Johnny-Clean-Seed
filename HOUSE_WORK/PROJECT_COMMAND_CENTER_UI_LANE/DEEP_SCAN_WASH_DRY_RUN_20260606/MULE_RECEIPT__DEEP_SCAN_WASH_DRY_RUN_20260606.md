# Mule Receipt - Deep Scan Wash Dry Run - 2026-06-06

Receipt status: RECEIVED_AND_REPORTED

Working order honored: deep scan all files, run them through the wash, report what comes out, do not act on the findings.

Workspace root: C:\Users\13527\Desktop\123

Output folder: C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\DEEP_SCAN_WASH_DRY_RUN_20260606

## Action Ledger

- Inventory created: true
- Content signal scan created: true
- Filename signal scan created: true
- Human report created: true
- Source files edited: false
- Source files moved: false
- Source files deleted: false
- Source files installed: false
- Git commit made: false
- Git push made: false
- Outside sources used: false
- Root trash left behind: false

## Payload

- DEEP_SCAN_WASH_DRY_RUN_REPORT_20260606.md
- WASH_FILE_INVENTORY.csv
- WASH_TOP_LEVEL_COUNTS.csv
- WASH_EXTENSION_COUNTS.csv
- WASH_CLASS_COUNTS.csv
- WASH_LARGEST_100_FILES.csv
- WASH_ROOT_FILES.csv
- WASH_SIGNAL_CATEGORY_COUNTS.csv
- WASH_SIGNAL_FILE_COUNTS_TOP100_BY_CATEGORY.csv
- WASH_SIGNAL_HITS_SAMPLE.csv
- WASH_FILENAME_SIGNAL_COUNTS.csv
- WASH_FILENAME_SIGNAL_HITS_SAMPLE.csv
- WASH_SIGNAL_SUMMARY.json
- WASH_SAMPLE_REDACTION_NOTE.json

## Acceptance Notes

- Root check found only C:\Users\13527\Desktop\123\desktop.ini as a root file.
- Secret-surface sample rows were redacted inside the generated sample artifact.
- Binary/archive/executable files were inventoried and filename-scanned, but their contents were not decoded by the text wash.
- The verdict is REVIEW_REQUIRED, not clean-for-action.

## Does Not Prove

- Does not prove the workspace is clean.
- Does not prove secret-surface hits are real credentials.
- Does not prove mutation-language hits are current instructions.
- Does not approve any delete, move, archive, install, restore, commit, or push action.

## Next Legal Action Candidate

Build a bounded review queue from:

- 31 MUTATION_FLAG_TRUE files
- 760 SECRET_SURFACE files
- 1,369 PROOF_GAP files
- 460 BINARY_ARCHIVE_EXECUTABLE inventory files

No next action is authorized by this receipt.

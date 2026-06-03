# Helper Files Working Proof Gate Rule

Date: 2026-06-01
Status: BRAIN_LEARNING / HELPER PROOF CANDIDATE / NOT DOCTRINE
SourceWork: HELPER_CAPABILITY_SYSTEM_V2_3_ZIP_REPAIR_RECEIPT_20260601

## Purpose

Helper files should reduce live data load.

They only reduce load when they actually work as bounded helpers.

A helper pack that exists but has missing files, stale manifests, broken zips, vague read order, or untested scripts can increase data load instead of reducing it.

## Trigger

Use this gate before relying on helper packs, generated scripts, mule returns, package zips, research helpers, or local control surfaces.

## Required Helper Proof

Before a helper is allowed to carry work:

1. Read the start file or package index.
2. Verify manifest-listed files exist, or record exact missing files.
3. Verify hashes when the helper claims hash identity.
4. Parse scripts or structured files before running them.
5. Prefer dry-run or inspect-only mode for first use.
6. Record issues as repair receipts, not silent assumptions.
7. Load only the helper slice needed for the current task.

## Helper Status Labels

```text
UNKNOWN_HELPER
FOUND_NOT_VERIFIED
MANIFEST_PARTIAL
PARSE_PASS
DRYRUN_PASS
REPAIRED_WITH_RECEIPT
READY_FOR_BOUNDED_USE
BLOCKED_HELPER
```

## Bad Crossings

```text
HELPER_EXISTS -> HELPER_WORKS
MANIFEST_EXISTS -> PACKAGE_COMPLETE
ZIP_EXISTS -> HASH_MATCH
DRYRUN_RECEIPT -> RUN_PERMISSION
HELPER_OUTPUT -> JUDGMENT
SCRIPT_PARSE_PASS -> SAFE_TO_RUN
REPAIRED_PACKAGE -> ORIGINAL_PACKAGE
```

## Current Proof Note

During root intake on 2026-06-01, the helper capability harness pack had a real defect:

- original manifest listed 17 ZIPs;
- ZIP folder was empty;
- separate individual-package folder was empty;
- unpacked package folders existed;
- regenerated ZIPs were created and copied;
- original manifest still mismatches regenerated ZIP bytes/hashes;
- repair receipt records the distinction.

This proves why helper proof gates matter.

## DoesNotProve

This candidate does not prove all helpers are safe or that regenerated ZIPs are original. It proves only that helper packs need working-proof checks before they are trusted to reduce load.

## StopLine

Do not let helper output become authority. If a helper check finds missing files, stale hashes, parse errors, or unsafe run powers, block or repair with receipt before use.

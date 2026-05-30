# Scale-Step Chain Proof Review V1 Failure — Powerplay / Crime Scene

Date: 2026-05-30
Status: POWERPLAY / CRIME SCENE / REPAIRED BY V1.1
WorkKey: SCALECHAIN-20260530-MAX5-MAX8-MAX10-PROOF-REVIEW
RepairKey: POWERPLAY-CRIME-SCENE-20260530-SCALECHAIN-V1-MANIFEST-ORDER-REPAIR

## What happened

V1 Code Gate probe passed. Direct save failed after planned content writes because the script tried to hash the ignored-path manifest before the manifest existed.

Observed failure:

Get-FileHash could not find PROOF_HISTORY/SCALE_STEP_CHAIN_PROOF_REVIEW_IGNORED_PATH_MANIFEST_20260530.txt.

## Root cause

The exact-force-add candidate list included the ignored manifest and receipt. The manifest-building loop hashed every candidate before writing the manifest and receipt.

## Repair

V1.1 separates Work Shed exact-force-add targets from manifest/receipt files. It writes and hashes content first, writes/hashes manifest next, writes/hashes receipt after that, then stages and verifies the exact staged set.

## Boundary

The proof review concept did not fail. The save body ordering failed. No full batch, Max12 run, automation, watcher, implementation, doctrine, ACTIVE_GUIDES, or CURRENT_TRUTH_INDEX is authorized.
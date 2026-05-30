# Save Script Manifest / Receipt Order Guard

Date: 2026-05-30
Status: BRAIN LEARNING / SCRIPT-GENERATION GUARD / NOT DOCTRINE
WorkKey: SCALECHAIN-20260530-MAX5-MAX8-MAX10-PROOF-REVIEW
RepairKey: POWERPLAY-CRIME-SCENE-20260530-SCALECHAIN-V1-MANIFEST-ORDER-REPAIR
GuardKey: SAVE-SCRIPT-MANIFEST-RECEIPT-ORDER-GUARD-20260530

## Exposure

Scale-Step Chain Proof Review V1 passed Code Gate probe, then failed in direct save because the script attempted to hash every exact-force-add candidate before the ignored-path manifest and receipt had been written.

The concept was valid. The save-body ordering was wrong.

## Rule

Generated lock-save scripts must not include a file in a hash/manifest loop before that file exists.

Separate file groups:

1. Content targets: write first, then hash.
2. Ignored-path manifest: build from already-written target files only, then write, then hash.
3. Receipt: write after manifest hash is available, then hash receipt.
4. Staging: stage only after all repo files exist and expected staged set can be verified.

## Preferred order

write content files -> write drop copies/report -> hash content files -> write manifest -> hash manifest -> write receipt -> hash receipt -> stage -> commit -> push -> verify origin/head/final clean.

## Boundary

This guard does not authorize broad cleanup, automation, watcher, implementation, full batch, Whirlpool, doctrine, ACTIVE_GUIDES, or CURRENT_TRUTH_INDEX.
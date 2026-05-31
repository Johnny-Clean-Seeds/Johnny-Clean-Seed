# Helper Proof Surface Class Before Pair Strength Rule

Status: ACTIVE LEARNING RULE

## Rule

When a helper pairs a writer, tool, report, receipt, or proof surface, classify the proof surface before assigning pair strength.

Exact name, path, hash, family, or token matches are not enough by themselves.

A helper must distinguish:

- approval receipt;
- review index row;
- needed-row CSV;
- report;
- manifest;
- support proof surface;
- unclassified proof surface.

## Trust Boundary

An exact support surface is still support.

An exact review index row is still a review lead.

An exact needed-row CSV is still a need marker.

Only an approval-receipt-shaped surface can move into approval receipt review, and even then it is still a candidate until the exact version, hash, boundary, staged set, commit, push, and clean-state evidence are checked.

## Required Self-Test

Any receipt-pairing helper must include a self-test proving that `*_RECEIPT_NEEDED_ROWS.csv` or equivalent index-row evidence cannot score as strong approval evidence.

Any manual-review helper must include a learning row when exact support surfaces appear without approval receipts.

## Trigger

During Coding Room Lock-Save Writer Manual Receipt Review Wave 01, exact support evidence appeared for 67 writer rows, but exact approval receipt candidates were 0.

The helper chain must therefore route to approval receipt search, not approval trust.

## Evidence

Shape gate passed for repaired receipt-pairing V1.3:

`C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\CODING_ROOM\GENERATED_HELPER_SHAPE_CONTRACT_GATE_V1_1_LOCAL_ONLY_UNIQUE_20260531_1325_20260531_135056\GENERATED_HELPER_SHAPE_CONTRACT_GATE_V1_1_LOCAL_ONLY_UNIQUE_20260531_1325_RECEIPT.txt`

Receipt SHA256: D9BCF441EB5EEC1C463B21CE1C17D768E2A0C3F1F06F22753B2FA79A10DEE7DE

Repaired receipt-pairing V1.3 self-test passed:

`C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\CODING_ROOM\CODING_ROOM_LOCK_SAVE_WRITER_RECEIPT_PAIRING_WAVE_01_V1_3_UNIQUE_20260531_1350_20260531_135111\CODING_ROOM_LOCK_SAVE_WRITER_RECEIPT_PAIRING_WAVE_01_V1_3_UNIQUE_20260531_1350_RECEIPT.txt`

Receipt SHA256: 40F0A4C6377332235680C37C606266924B69D28E7A1AAE82B8A73264B172AEB1

Shape gate passed for manual review V1.1:

`C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\CODING_ROOM\GENERATED_HELPER_SHAPE_CONTRACT_GATE_V1_1_LOCAL_ONLY_UNIQUE_20260531_1325_20260531_135501\GENERATED_HELPER_SHAPE_CONTRACT_GATE_V1_1_LOCAL_ONLY_UNIQUE_20260531_1325_RECEIPT.txt`

Receipt SHA256: 6472A6B78C54B60D7A4DA8965B51E0534BA233D12C87637FCB5AD471FD1CB8EC

Manual review V1.1 found support-only evidence:

`C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\CODING_ROOM\CODING_ROOM_LOCK_SAVE_WRITER_MANUAL_RECEIPT_REVIEW_WAVE_01_V1_1_UNIQUE_20260531_1400_20260531_135510\CODING_ROOM_LOCK_SAVE_WRITER_MANUAL_RECEIPT_REVIEW_WAVE_01_V1_1_UNIQUE_20260531_1400_RECEIPT.txt`

Receipt SHA256: 3540670D4624D3AA255AC8D042836D88A23EB941D83C8914D26C10817156B41E

## Does Not Prove

This rule does not approve any lock-save writer.

This rule does not install any new save authority.

This rule does not make support surfaces useless; it keeps them in the correct lane.

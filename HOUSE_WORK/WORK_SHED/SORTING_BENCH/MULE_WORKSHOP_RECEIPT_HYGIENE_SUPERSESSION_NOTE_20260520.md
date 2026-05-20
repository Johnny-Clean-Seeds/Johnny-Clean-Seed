# Mule Workshop Receipt Hygiene / Supersession Note

Date: 2026-05-20
Base before save: main @ 22152a9
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: claim-scoped proof hygiene note, not doctrine

## Purpose

This note records a claim-scoped receipt hygiene correction from the mule file review return.

It does not rewrite proof history.

It does not delete or alter old receipts.

It clarifies which receipt should be trusted for which claim.

## Issue

The mule review identified a live proof-risk pattern:

PROOF_HISTORY\MULE_WORKSHOP_DESK_INSTALL_RECEIPT_20260520.txt

is useful as historical evidence of the mule workshop desk install attempt, but it is not strong enough to prove active packet placement because it contained blank or insufficient hash fields for the source/packet claim while still carrying PASS-style language.

This creates a false-confidence risk.

## Supersession decision

For the claim:

"Active mule packet is placed and available at the mule desk."

Do not rely on:

- PROOF_HISTORY\MULE_WORKSHOP_DESK_INSTALL_RECEIPT_20260520.txt

Rely instead on the later stronger chain:

1. PROOF_HISTORY\MULE_WORKSHOP_ACTIVE_PACKET_PLACEMENT_RECEIPT_20260520.txt
2. PROOF_HISTORY\MULE_FILE_REVIEW_RETURN_INTAKE_RECEIPT_20260520.txt
3. Current git proof from the intake save and later clean state.

## Claim-specific status

| Artifact | Status | Use |
|---|---|---|
| $WeakReceipt | PARTIAL / SUPERSEDED FOR ACTIVE-PACKET PLACEMENT CLAIM | Historical context for the desk install attempt only. Do not use as active-packet proof. |
| $StrongPacketReceipt | TRUSTED FOR ACTIVE-PACKET PLACEMENT CLAIM | Proves the active packet placement and hash. |
| $IntakeReceipt | TRUSTED FOR MULE RETURN INTAKE CLAIM | Proves the mule review return was saved and intaken. |
| $ActivePacket | CURRENT ACTIVE PACKET ARTIFACT | The packet itself. |

## Evidence hashes

- $WeakReceipt
  SHA256: 539EE32A620DFE9662C4B440CF4562E2417B134B3749964EF1DFA3BBB50973A0

- $StrongPacketReceipt
  SHA256: 0866F7EA033F2DFAC1D82B30C16A6DB9E511E09C801D6A17C8FB186D107D8901

- $IntakeReceipt
  SHA256: B676D97381B6B89E9F03E0061B84B11B0CF62C93F701F3DAD5BB231EDA34E976

- $ActivePacket
  SHA256: 457277F7EBB3F0475359503EE599E4166A28446CC02BAEBA63878806FD2E1DCB

- $MuleReview
  SHA256: F509DA5AEEDF71D17E602C6ACE5D414E02788BC9BD664181A3842909E34D1CC2

- $MuleDisposition
  SHA256: 72435239C2F4B8D49A7A8885A203086897DC6524CA508899BD72175F8B4E2FAB

## Rule learned

Receipt proof is claim-scoped.

A receipt can be valid for one claim and weak, partial, superseded, or insufficient for another.

Do not treat a PASS label as global proof.

When a later receipt repairs a failed or partial proof claim, mark the earlier receipt's claim boundary instead of rewriting history.

## Boundary

This note does not authorize:

- PROOF_HISTORY restructuring,
- receipt deletion,
- receipt rewriting,
- doctrine rewrite,
- active guide rewrite,
- CURRENT_TRUTH_INDEX rewrite,
- tool/checker promotion,
- runtime build,
- /system creation,
- automation,
- dashboard,
- knowledge graph,
- full lesson index,
- another mule pass.

## Verdict

PASS AS CLAIM-SCOPED RECEIPT HYGIENE NOTE.

No implementation beyond disposition/clarification.

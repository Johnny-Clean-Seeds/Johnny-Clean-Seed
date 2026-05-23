# Criss-Cross Root Pickup Custody Pointer

Date: 2026-05-23

Status: CUSTODY POINTER / NOT AUTHORITY / NOT A COPY OF THE WORK ORDER

## Source Object

Root pickup work order:
`C:\Users\13527\Desktop\123\COMMAND_CENTER\PICKUP\CRISS_CROSS_HOUSE_CLEANUP_WORK_ORDER_20260523.md`

SHA256:
`6B4CFB8EB45F3022F29853A4A5D0DB9115D159AA90B10DFB059CA9BC1CA7497B`

Root pickup repair receipt:
`C:\Users\13527\Desktop\123\COMMAND_CENTER\RECEIPTS\CRISS_CROSS_PICKUP_PATH_REPAIR_RECEIPT_20260523_171803.txt`

Receipt SHA256:
`787E74C589DF27E35F3CE3C186464D98D9AC7CF72E1E013246D36CCF3576E36B`

## Why This Pointer Exists

The criss-cross work order was dropped under the porch/root `COMMAND_CENTER`, while the active home has its own `COMMAND_CENTER\PICKUP` lane.

This pointer prevents the active-home pickup lane from appearing unaware of the root pickup source without copying, moving, or promoting the root work order.

## Boundary

- This pointer is not the work order body.
- This pointer does not move the root pickup source.
- This pointer does not rewrite `CURRENT_TRUTH_INDEX`.
- This pointer does not rewrite active guides.
- This pointer does not authorize Git commit or push.
- This pointer does not make the root `COMMAND_CENTER` the active home.

## Return Trigger

When a path/home sync or pickup-lane reconciliation task is explicitly selected, decide whether root `COMMAND_CENTER` should remain a porch pickup lane, be routed into active home, or be archived with receipt.

Until then, treat this file as a custody pointer only.

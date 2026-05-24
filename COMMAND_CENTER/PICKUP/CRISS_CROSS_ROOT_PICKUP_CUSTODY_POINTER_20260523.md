# Criss-Cross Root Pickup Custody Pointer

Date: 2026-05-23

Status: CUSTODY POINTER / ROOT PICKUP ROUTED INTO ACTIVE HOME / NOT AUTHORITY

## Source Object

Former root pickup work order, now routed into active home:
`C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz\COMMAND_CENTER\PICKUP\CRISS_CROSS_HOUSE_CLEANUP_WORK_ORDER_20260523.md`

SHA256:
`6B4CFB8EB45F3022F29853A4A5D0DB9115D159AA90B10DFB059CA9BC1CA7497B`

Former root pickup repair receipt, now routed into active home:
`C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz\COMMAND_CENTER\RECEIPTS\CRISS_CROSS_PICKUP_PATH_REPAIR_RECEIPT_20260523_171803.txt`

Receipt SHA256:
`787E74C589DF27E35F3CE3C186464D98D9AC7CF72E1E013246D36CCF3576E36B`

## Why This Pointer Exists

The criss-cross work order was dropped under the porch/root `COMMAND_CENTER`, while the active home has its own `COMMAND_CENTER\PICKUP` lane.

This pointer first prevented the active-home pickup lane from appearing unaware of the root pickup source.

On 2026-05-24, the parent `123` root was cleaned as a drop zone. The Git-safe pickup work order and
repair receipt were moved into the matching active-home lanes. This pointer now preserves the route
history and old hashes.

## Boundary

- This pointer is not the work order body.
- This pointer records that the root pickup source has been moved into active-home custody.
- This pointer does not rewrite `CURRENT_TRUTH_INDEX`.
- This pointer does not rewrite active guides.
- This pointer does not authorize Git commit or push.
- This pointer does not make the root `COMMAND_CENTER` the active home.

## Return Trigger

When a path/home sync or pickup-lane reconciliation task is explicitly selected, compare the moved
active-home files against this pointer and any historical packet references.

Until then, treat this file as a custody pointer only.

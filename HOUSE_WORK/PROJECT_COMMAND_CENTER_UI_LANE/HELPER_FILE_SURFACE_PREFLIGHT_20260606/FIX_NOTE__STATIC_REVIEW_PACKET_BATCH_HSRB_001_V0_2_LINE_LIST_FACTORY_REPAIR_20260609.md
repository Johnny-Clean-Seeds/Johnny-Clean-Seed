# Fix Note - Static Review Packet Batch HSRB-001 V0.2 Line List Factory Repair

Status: FIX_NOTE / SAME_OBJECT_REPAIR / NO_EXECUTION / NO_ROUTE / NO_CLEANUP

V0.1 failed because the empty generic list returned by New-LineList was unrolled by the PowerShell pipeline as no output. The caller received null. Add-Line then tried to call .Add() on null.

V0.2 repair:
- New-LineList returns the list with unary comma.
- Add-Line guards against null list input.
- Output paths are versioned to V0.2.
- Selected helper scripts are still read as static text only.

Physical actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0

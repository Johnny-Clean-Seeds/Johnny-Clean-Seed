# FIX NOTE — HSRB-005 NEXT BATCH SELECTOR V0.2

Status: FIX_NOTE / UNDERLYING_COLLECTION_PATTERN_REPAIR / NO_PHYSICAL_ACTION

V0.1 failed at queue row import because a generated collection variable was null before Add() was called.
V0.2 does not merely patch line 133. It removes the risky pattern for this selector.

Repair actions:
- No typed Generic List factory is used for queue loading.
- No pipeline Add() call is used for queue loading.
- Import-Csv output is normalized through Convert-ToSafeArray.
- Selected rows are built through direct enumeration and array append, small-batch safe.
- The same HSRB-005 object is preserved; this is not a new lane.
- Physical action counts remain zero.

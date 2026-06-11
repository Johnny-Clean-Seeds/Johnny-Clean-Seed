# FIX_NOTE__SAFE_TEMPLATE_FIELD_APPLY_V0_3_PARENT_FIRST_AND_CODE_AWARE_CHECK_20260608

Status: FIX_NOTE / PARENT_FIRST_COPY / CODE_AWARE_SELF_CHECK / SAFE_TEMPLATE_FIELD_APPLY_V0_3

Created: 2026-06-08 18:26:23

Problems:
01 V0_1 stopped on a false positive caused by raw text checking.
02 V0_2 attempted to freeze that false positive but copied into a missing incident folder.

Fix:
01 Create incident folder before copy operations.
02 Use Copy-FileSafe, which creates destination parent folders before Copy-Item.
03 Use code-aware text checking that removes here-string report bodies and comments before forbidden behavior checks.
04 Preserve both V0_1 and V0_2 failures as evidence.

DoesNotProve:
This is not a full PowerShell parser. It is a bounded field-apply repair for the generated-runner safe-template path.
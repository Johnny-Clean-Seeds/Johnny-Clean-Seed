# FIX_NOTE__SUPPORT_OPTION_SET_V0_2_ARRAY_WRAP_20260608

Status: FIX_NOTE / V0_2_REPAIR / ARRAY_COUNT_SAFE / PARENT_FIRST_WRITE

Created: 2026-06-08 19:06:43

Fix:
V0_2 wraps filtered line collections in array subexpressions before counting:
$GuardrailLines = @(...)
$PendingLines = @(...)

Reason:
PowerShell can collapse a single-item pipeline result into a scalar. In StrictMode Latest, .Count may fail on that scalar. Array wrapping preserves count behavior for zero, one, or many items.

Additional boundary:
V0_2 also freezes the V0_1 error and copies the failed/fixed runners into the incident folder when available.

No scope change:
- still read-only
- no promotion
- no moves
- no cleanup
- no routing
- no Git
- no script execution beyond this bounded runner

Freeze hash:
A871B1A2557061B0FB6C6AE5F56A05076CACEC65EDC8B0ECC11FD90063F0D642

Failed runner copy SHA256:
4D020C550899629BDDF01B0C493798585C86545167542AB9F4B44DDF861F6813

Fixed runner copy SHA256:
B40174F150AC0B698484A4F76A30E7CAD844787F9391D03A02053693983F3AAE

DoesNotProve:
This fix note does not prove support candidates are active support, doctrine, active guide, executor authority, cleanup authority, routing authority, or project complete.
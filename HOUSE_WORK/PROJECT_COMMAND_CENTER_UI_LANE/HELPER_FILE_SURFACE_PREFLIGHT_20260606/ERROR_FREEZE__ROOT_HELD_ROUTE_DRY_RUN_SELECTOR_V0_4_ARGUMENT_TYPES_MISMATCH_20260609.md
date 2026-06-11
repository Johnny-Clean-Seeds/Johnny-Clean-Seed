# ERROR FREEZE — ROOT HELD ROUTE DRY-RUN SELECTOR V0.4 ARGUMENT TYPES MISMATCH 20260609

Status: ERROR_FREEZE / SCRIPT_DEFECT_CAPTURE / NOT_ROUTE_FAILURE / NOT_USER_ERROR

## Trigger

V0.4 failed from the terminal with: `Argument types do not match`. The terminal did not return a useful line pointer. This is recorded as a continued generated-runner parser/input-shape defect in the same dry-run selector chain.

## Failure Family

V0.1 failed on scalar `.Count`; V0.2 failed on strict parameter binding; V0.3 failed on unescaped Windows path regex; V0.4 still failed on an argument-type mismatch. The common family is brittle parser/input-shape handling in generated PowerShell.

## DoesNotProve

This error does not prove route failure, Git failure, user misuse, file safety, cleanup approval, or movement approval. It proves only a generated-script dry-run selector defect.

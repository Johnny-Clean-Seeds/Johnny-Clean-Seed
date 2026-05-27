# PowerShell Code Gate / Parse-First Runner Wash
Date: 20260527
Mode: Think Tank / Gate Team / Code Safety Lane
Status: READY FOR SAVE ROUTE

## Source problem

Generated PowerShell repeatedly reached the user with parser/runtime mistakes. A post-save checker failed with a parser error. A prior read script failed with a runtime type/shape error. The repeated pattern shows a route failure, not a one-off typo.

## Parent problem

Generated executable material needs a mandatory read/parse/risk/proof lane before user execution.

## Gate decision

READY FOR SAVE ROUTE.

The object is a Generated Code Safety Lane with a first implementation in PowerShell:
PowerShell Code Gate / Parse-First Runner.

## Test proof used

Ladder report:
C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\POWERSHELL_CODE_GATE_TEST_LADDER_V1.1_REPORT_20260527_193549.md

Runner report:
C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\POWERSHELL_CODE_GATE_RUNNER_REPORT_V1.3_20260527_193549_POWERSHELL_CODE_GATE_TEST_LADDER_V1.1.ps1.md

Observed required proof:
- ladder final verdict included PASS WITH WATCH for core safety;
- no FAIL verdict rows were found in the ladder report;
- expected WATCH row was present;
- expected watch was the false-PASS fixture;
- runner V1.3 recognized child target status TARGET_PASS_WITH_WATCH.

## Covered bases

- parser errors block run;
- known brittle PowerShell generation patterns are watched;
- Git-write requires explicit allow/save lane;
- delete/move/network/system changes are blocked unless explicitly selected;
- PASS WITH WATCH is not generic failure;
- Code Gate PASS is not job PASS;
- reports are written to Misc Drawer;
- root slop is not the report lane;
- final save still needs Git proof.

## Final short form

Parse first. Run second. Save third.

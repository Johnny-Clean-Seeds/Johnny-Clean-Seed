# ERROR_FREEZE__OLD_SYSTEM_REVIEW_DESKTOP_INI_MISSING_AT_REVIEW_20260608

Status: ERROR_FREEZE / GENERATED_RUNNER_DEFECT_FAMILY / OLD_SYSTEM_REVIEW_V0_1_FAILED

Created: 2026-06-08 19:12:01

Failed command:
pwsh -NoProfile -ExecutionPolicy Bypass -File $ScriptPath

Failed runner:
C:\Users\13527\Downloads\RUN_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608.ps1

Reported error:
Get-Item: C:\Users\13527\Downloads\RUN_ROOT_DROP_INTAKE_WASHER_OLD_LOAD_OR_SYSTEM_REVIEW_DRY_RUN_20260608.ps1:284

Line:
$fileInfo = Get-Item -LiteralPath $observedPath

Error text:
Could not find item C:\Users\13527\Desktop\123\desktop.ini.

Working root:
C:\Users\13527\Desktop\123

Lane:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606

Suspected cause:
The queue previously captured C:\Users\13527\Desktop\123\desktop.ini as an old/system candidate, but the old/system review V0_1 assumed the file would still be present when Get-Item ran. A desktop.ini-style system metadata file can be missing, hidden, inaccessible, or changed by Windows/context between queue-time and review-time. Old/system review must record missing-at-review-time instead of crashing.

Blocked actions:
- do not claim V0_1 old/system review complete
- do not rerun V0_1
- do not delete anything
- do not infer cleanup happened
- do not recreate desktop.ini
- do not move or route anything
- do not stage full old/system files

Failed runner copy SHA256:
426B6E5CDE9BFC779F5CE19BBD9D3AC4775430866EB499B0D1B00633B7F164A2

Fixed runner copy SHA256:
4ED1D3AFD0597C3A998CD97C48B98B2449355CF2C579A6177346818C9CE422BD

DoesNotProve:
This freeze does not prove desktop.ini was deleted by our tools, safe to delete, safe to restore, stale, active, or irrelevant. It only proves V0_1 failed to handle missing-at-review-time old/system candidates.
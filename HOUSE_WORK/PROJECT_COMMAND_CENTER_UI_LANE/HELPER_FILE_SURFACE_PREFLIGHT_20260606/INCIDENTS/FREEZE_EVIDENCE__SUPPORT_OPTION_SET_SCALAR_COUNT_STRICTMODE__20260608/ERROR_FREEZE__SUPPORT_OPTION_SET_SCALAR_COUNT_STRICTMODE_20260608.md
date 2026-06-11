# ERROR_FREEZE__SUPPORT_OPTION_SET_SCALAR_COUNT_STRICTMODE_20260608

Status: ERROR_FREEZE / GENERATED_RUNNER_DEFECT_FAMILY / SUPPORT_OPTION_SET_V0_1_FAILED

Created: 2026-06-08 19:06:43

Failed command:
pwsh -NoProfile -ExecutionPolicy Bypass -File $ScriptPath

Failed runner:
C:\Users\13527\Downloads\BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.ps1

Reported error:
ParentContainsErrorRecordException: C:\Users\13527\Downloads\BUILD_ROOT_DROP_INTAKE_WASHER_SUPPORT_CANDIDATE_OPTION_SET_20260608.ps1:254

Line:
if ($GuardrailLines.Count -eq 0) {

Error text:
The property 'Count' cannot be found on this object. Verify that the property exists.

Working root:
C:\Users\13527\Desktop\123

Lane:
C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606

Suspected cause:
A PowerShell foreach expression assigned to $GuardrailLines returned a scalar string when only one support guardrail line existed. Under StrictMode Latest, .Count on that scalar string failed. This is a generated-runner robustness defect, not a washer support-candidate failure.

Blocked actions:
- do not claim support option set complete from V0_1
- do not re-run V0_1
- do not promote support candidates
- do not move files
- do not delete files
- do not route files
- do not stage full support files
- do not commit full support files

Failed runner copy SHA256:
4D020C550899629BDDF01B0C493798585C86545167542AB9F4B44DDF861F6813

Fixed runner copy SHA256:
B40174F150AC0B698484A4F76A30E7CAD844787F9391D03A02053693983F3AAE

DoesNotProve:
This freeze does not prove the support candidates are invalid. It proves V0_1 failed on scalar .Count handling and required V0_2 repair.
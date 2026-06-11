# ERROR_FREEZE__POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608

Status: FREEZE_EVIDENCE / INCIDENT_LOG / FIX_REQUIRED / NOT_DOCTRINE

Working root observed: C:\Users\13527\Desktop\123
Prompt root observed: PS C:\Users\13527\Desktop\123>

Observed command:
```powershell
$ScriptPath = "$env:USERPROFILE\Downloads\RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1"
pwsh -NoProfile -ExecutionPolicy Bypass -File $ScriptPath
```

Observed error:
```text
RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1: Cannot bind argument to parameter 'Lines' because it is an empty collection.
```

Failed runner path checked: C:\Users\13527\Downloads\RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1
Failed runner exists at capture time: True
Failed runner SHA256 at capture time: AA773E18BD60BAA9B0D4C27C8336598906F0AFCD11D22B503FAB9200433E9F45
Failed runner copy path: C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\INCIDENTS\FREEZE_EVIDENCE__POWERSHELL_FIELD_TEST_RUNNER_EMPTY_LINES_BIND__20260608\FAILED_SCRIPT_COPY__RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1
Failed runner copy SHA256: AA773E18BD60BAA9B0D4C27C8336598906F0AFCD11D22B503FAB9200433E9F45

Suspected cause: Original Add-Line declared [Parameter(Mandatory=$true)] on the List[string] parameter. PowerShell treats an empty collection passed to a mandatory parameter as invalid, so the first Add-Line call failed before report creation.

Fix summary: Removed the Mandatory binding from Add-Line list parameter and allowed an empty List[string] to be passed safely; added Freeze Evidence incident capture before report generation.

Blocked until fixed: selector field-test report creation.
Still not authorized by this incident: arbitrary script execution, cleanup, source mutation, Git, doctrine promotion, active guide promotion, current truth rewrite.
DoesNotProve: This error freeze proves an observed runner failure and preservation of available evidence only; it does not prove script safety, runtime correctness, doctrine, or project completion.

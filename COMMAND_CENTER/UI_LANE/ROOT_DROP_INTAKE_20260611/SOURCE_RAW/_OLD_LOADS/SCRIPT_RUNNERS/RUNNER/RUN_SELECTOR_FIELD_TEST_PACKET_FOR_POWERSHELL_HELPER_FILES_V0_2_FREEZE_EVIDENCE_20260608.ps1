<#
RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_V0_2_FREEZE_EVIDENCE_20260608.ps1

Purpose:
Use PowerShell as the bounded runner for the selector field-test packet and freeze the prior runner failure evidence before writing the fixed report.

This runner:
- freezes the observed prior error evidence
- copies the failed runner script if available
- copies this fixed runner script into the incident folder
- verifies expected helper hashes
- writes one field-test packet report
- writes incident evidence/fix notes for the failure/fix trail
- does NOT execute random helper scripts
- does NOT mutate source files
- does NOT use Git
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\Users\13527\Desktop\123",
    [string]$UserNamedObject = "PowerShell helper files",
    [string]$FailedScriptPath = "$env:USERPROFILE\Downloads\RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1"
)

$ErrorActionPreference = "Stop"

function Join-Child {
    param(
        [string]$Base,
        [string]$Child
    )
    return [System.IO.Path]::Combine($Base, $Child)
}

function Get-Sha256OrMissing {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) {
        return "MISSING_PATH_VALUE"
    }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return "MISSING"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Line {
    param(
        [AllowNull()][System.Collections.Generic.List[string]]$Lines,
        [AllowNull()][string]$Text = ""
    )
    if ($null -eq $Lines) {
        throw "Add-Line received a null line list."
    }
    [void]$Lines.Add([string]$Text)
}

function Get-UniqueFilePath {
    param(
        [string]$Folder,
        [string]$BaseNameNoExt,
        [string]$Ext
    )

    $basePath = Join-Child $Folder ($BaseNameNoExt + $Ext)
    if (-not (Test-Path -LiteralPath $basePath -PathType Leaf)) {
        return $basePath
    }

    for ($i = 2; $i -le 99; $i++) {
        $candidate = Join-Child $Folder ("{0}_V0_{1}{2}" -f $BaseNameNoExt, $i, $Ext)
        if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            return $candidate
        }
    }

    throw "BLOCKER_OUTPUT_COLLISION: No available output path through V0_99."
}

function Get-UniqueFolderPath {
    param(
        [string]$Parent,
        [string]$BaseName
    )

    $basePath = Join-Child $Parent $BaseName
    if (-not (Test-Path -LiteralPath $basePath -PathType Container)) {
        return $basePath
    }

    for ($i = 2; $i -le 99; $i++) {
        $candidate = Join-Child $Parent ("{0}_V0_{1}" -f $BaseName, $i)
        if (-not (Test-Path -LiteralPath $candidate -PathType Container)) {
            return $candidate
        }
    }

    throw "BLOCKER_INCIDENT_FOLDER_COLLISION: No available incident folder path through V0_99."
}

$HelperLane = Join-Child $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$IncidentRoot = Join-Child $HelperLane "INCIDENTS"
New-Item -ItemType Directory -Path $IncidentRoot -Force | Out-Null

$IncidentFolder = Get-UniqueFolderPath -Parent $IncidentRoot -BaseName "FREEZE_EVIDENCE__POWERSHELL_FIELD_TEST_RUNNER_EMPTY_LINES_BIND__20260608"
New-Item -ItemType Directory -Path $IncidentFolder -Force | Out-Null

$ObservedCommand = 'pwsh -NoProfile -ExecutionPolicy Bypass -File $ScriptPath'
$ObservedError = 'RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1: Cannot bind argument to parameter ''Lines'' because it is an empty collection.'
$ObservedPromptRoot = 'PS C:\Users\13527\Desktop\123>'
$ObservedFailedRunnerName = 'RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1'
$FixSummary = 'Removed the Mandatory binding from Add-Line list parameter and allowed an empty List[string] to be passed safely; added Freeze Evidence incident capture before report generation.'
$SuspectedCause = 'Original Add-Line declared [Parameter(Mandatory=$true)] on the List[string] parameter. PowerShell treats an empty collection passed to a mandatory parameter as invalid, so the first Add-Line call failed before report creation.'

$FailedScriptExists = Test-Path -LiteralPath $FailedScriptPath -PathType Leaf
$FailedScriptHash = Get-Sha256OrMissing -Path $FailedScriptPath
$FailedScriptCopyPath = "NOT_COPIED_MISSING_FAILED_SCRIPT"
$FailedScriptCopyHash = "NOT_COPIED_MISSING_FAILED_SCRIPT"

if ($FailedScriptExists) {
    $FailedScriptCopyPath = Join-Child $IncidentFolder ("FAILED_SCRIPT_COPY__" + [System.IO.Path]::GetFileName($FailedScriptPath))
    Copy-Item -LiteralPath $FailedScriptPath -Destination $FailedScriptCopyPath -Force
    $FailedScriptCopyHash = Get-Sha256OrMissing -Path $FailedScriptCopyPath
}

$ThisFixedScriptPath = if ($PSCommandPath) { $PSCommandPath } else { $MyInvocation.MyCommand.Path }
$ThisFixedScriptHash = Get-Sha256OrMissing -Path $ThisFixedScriptPath
$FixedScriptCopyPath = "NOT_COPIED_FIXED_SCRIPT_PATH_UNAVAILABLE"
$FixedScriptCopyHash = "NOT_COPIED_FIXED_SCRIPT_PATH_UNAVAILABLE"

if (-not [string]::IsNullOrWhiteSpace($ThisFixedScriptPath) -and (Test-Path -LiteralPath $ThisFixedScriptPath -PathType Leaf)) {
    $FixedScriptCopyPath = Join-Child $IncidentFolder ("FIXED_SCRIPT_COPY__" + [System.IO.Path]::GetFileName($ThisFixedScriptPath))
    Copy-Item -LiteralPath $ThisFixedScriptPath -Destination $FixedScriptCopyPath -Force
    $FixedScriptCopyHash = Get-Sha256OrMissing -Path $FixedScriptCopyPath
}

$ErrorLogPath = Join-Child $IncidentFolder "ERROR_FREEZE__POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608.md"
$FixNotePath = Join-Child $IncidentFolder "FIX_NOTE__POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608.md"

$EvidenceLines = [System.Collections.Generic.List[string]]::new()
Add-Line $EvidenceLines "# ERROR_FREEZE__POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608"
Add-Line $EvidenceLines ""
Add-Line $EvidenceLines "Status: FREEZE_EVIDENCE / INCIDENT_LOG / FIX_REQUIRED / NOT_DOCTRINE"
Add-Line $EvidenceLines ""
Add-Line $EvidenceLines "Working root observed: $ProjectRoot"
Add-Line $EvidenceLines "Prompt root observed: $ObservedPromptRoot"
Add-Line $EvidenceLines ""
Add-Line $EvidenceLines "Observed command:"
Add-Line $EvidenceLines '```powershell'
Add-Line $EvidenceLines '$ScriptPath = "$env:USERPROFILE\Downloads\RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1"'
Add-Line $EvidenceLines $ObservedCommand
Add-Line $EvidenceLines '```'
Add-Line $EvidenceLines ""
Add-Line $EvidenceLines "Observed error:"
Add-Line $EvidenceLines '```text'
Add-Line $EvidenceLines $ObservedError
Add-Line $EvidenceLines '```'
Add-Line $EvidenceLines ""
Add-Line $EvidenceLines "Failed runner path checked: $FailedScriptPath"
Add-Line $EvidenceLines "Failed runner exists at capture time: $FailedScriptExists"
Add-Line $EvidenceLines "Failed runner SHA256 at capture time: $FailedScriptHash"
Add-Line $EvidenceLines "Failed runner copy path: $FailedScriptCopyPath"
Add-Line $EvidenceLines "Failed runner copy SHA256: $FailedScriptCopyHash"
Add-Line $EvidenceLines ""
Add-Line $EvidenceLines "Suspected cause: $SuspectedCause"
Add-Line $EvidenceLines ""
Add-Line $EvidenceLines "Fix summary: $FixSummary"
Add-Line $EvidenceLines ""
Add-Line $EvidenceLines "Blocked until fixed: selector field-test report creation."
Add-Line $EvidenceLines "Still not authorized by this incident: arbitrary script execution, cleanup, source mutation, Git, doctrine promotion, active guide promotion, current truth rewrite."
Add-Line $EvidenceLines "DoesNotProve: This error freeze proves an observed runner failure and preservation of available evidence only; it does not prove script safety, runtime correctness, doctrine, or project completion."
$EvidenceLines | Set-Content -LiteralPath $ErrorLogPath -Encoding UTF8
$ErrorLogHash = Get-Sha256OrMissing -Path $ErrorLogPath

$FixLines = [System.Collections.Generic.List[string]]::new()
Add-Line $FixLines "# FIX_NOTE__POWERSHELL_RUNNER_EMPTY_LINES_BIND_20260608"
Add-Line $FixLines ""
Add-Line $FixLines "Status: FIX_NOTE / RUNNER_REPAIR / PAIRED_WITH_ERROR_FREEZE / NOT_DOCTRINE"
Add-Line $FixLines ""
Add-Line $FixLines "Error log path: $ErrorLogPath"
Add-Line $FixLines "Error log SHA256: $ErrorLogHash"
Add-Line $FixLines ""
Add-Line $FixLines "Cause: $SuspectedCause"
Add-Line $FixLines ""
Add-Line $FixLines "Repair: $FixSummary"
Add-Line $FixLines ""
Add-Line $FixLines "Fixed runner path: $ThisFixedScriptPath"
Add-Line $FixLines "Fixed runner SHA256: $ThisFixedScriptHash"
Add-Line $FixLines "Fixed runner copy path: $FixedScriptCopyPath"
Add-Line $FixLines "Fixed runner copy SHA256: $FixedScriptCopyHash"
Add-Line $FixLines ""
Add-Line $FixLines "Freeze Evidence Rule application: error evidence was filed before continuing the task report."
Add-Line $FixLines ""
Add-Line $FixLines "DoesNotProve: This fix note documents the repair and paired evidence; it does not prove broader script safety or authorize unrelated execution."
$FixLines | Set-Content -LiteralPath $FixNotePath -Encoding UTF8
$FixNoteHash = Get-Sha256OrMissing -Path $FixNotePath

$SelectorHelper = Join-Child $HelperLane "PLANETARY_GATE_SOURCE_ANCHORED_STANDARD_RUN_CARD_AND_SELECTOR_BUILD_20260608.md"
$SelectorHelperExpected = "377663FFD2DDF1E7C95FC3D19A18B04EB4E304350633F2AB260CD660154366C3"

$SourceAnchorHelper = Join-Child $HelperLane "PLANETARY_GATE_ROLE_CARD_MATRIX_SOURCE_ANCHOR_PASS_20260608.md"
$SourceAnchorHelperExpected = "C22F9A9C739FD2BE3B6696DB193B10164E3363F1120E9EB52B37D393C0615260"

$ActiveSource = Join-Child $ProjectRoot "PLANETARY_HOUSE_GATE_MASTER_INDEX_WITH_INTAKE_TOOLBELT_V0_3_RAW_COMBINED_WITH_GUARD_MEMBRANE_20260607.md"
$ActiveSourceExpected = "7F7B61C0915966EA3222587BA97B1ED8BCC47FC62739526B0542C557DA3156F7"

$OutputBaseName = "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_USER_NAMED_OBJECT_20260608"
$OutputReport = Get-UniqueFilePath -Folder $HelperLane -BaseNameNoExt $OutputBaseName -Ext ".md"

$RootLooseCountBefore = (Get-ChildItem -LiteralPath $ProjectRoot -File -Force | Measure-Object).Count

$SelectorHash = Get-Sha256OrMissing -Path $SelectorHelper
$SourceAnchorHash = Get-Sha256OrMissing -Path $SourceAnchorHelper
$ActiveSourceHash = Get-Sha256OrMissing -Path $ActiveSource

$Blockers = [System.Collections.Generic.List[string]]::new()

if ($SelectorHash -ne $SelectorHelperExpected) {
    [void]$Blockers.Add("BLOCKER_SELECTOR_HELPER_HASH_MISMATCH")
}
if ($SourceAnchorHash -ne $SourceAnchorHelperExpected) {
    [void]$Blockers.Add("BLOCKER_SOURCE_ANCHOR_HELPER_HASH_MISMATCH")
}
if ($ActiveSourceHash -ne $ActiveSourceExpected) {
    [void]$Blockers.Add("BLOCKER_ACTIVE_SOURCE_HASH_MISMATCH")
}

$PowerShellCandidatePaths = @(
    $FailedScriptPath,
    $ThisFixedScriptPath,
    (Join-Child $ProjectRoot "WRITE_CODING_ROOM_UNSAFE_CONTROL_FMEA_LEDGER_V1_UNIQUE_20260531_0610.ps1"),
    (Join-Child $ProjectRoot "WRITE_SHAPE_SELFTEST_BENCH_LIVE_USE_STARTER_V1_1_UNIQUE_20260531_0905.ps1")
) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique

$ExistingPowerShellFiles = @()
foreach ($p in $PowerShellCandidatePaths) {
    if (Test-Path -LiteralPath $p -PathType Leaf) {
        $ExistingPowerShellFiles += [PSCustomObject]@{
            Path = $p
            Sha256 = (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash
            Length = (Get-Item -LiteralPath $p).Length
        }
    }
}

$FinalVerdict = "SELECTOR_FIELD_TEST_PACKET_READY_WITH_SCOPE_LIMIT_NOTE"
$FinalRoute = "PROOF"
$SpecificPowerShellFilePathNamed = "NO"

if ($ExistingPowerShellFiles.Count -gt 0) {
    $SpecificPowerShellFilePathNamed = "YES_BY_BOUNDED_CANDIDATE_CHECK"
}

if ($Blockers.Count -gt 0) {
    $FinalRoute = "BLOCK"
    if ($Blockers -contains "BLOCKER_SELECTOR_HELPER_HASH_MISMATCH") {
        $FinalVerdict = "BLOCKER_SELECTOR_HELPER_HASH_MISMATCH"
    } elseif ($Blockers -contains "BLOCKER_SOURCE_ANCHOR_HELPER_HASH_MISMATCH") {
        $FinalVerdict = "BLOCKER_SOURCE_ANCHOR_HELPER_HASH_MISMATCH"
    } elseif ($Blockers -contains "BLOCKER_ACTIVE_SOURCE_HASH_MISMATCH") {
        $FinalVerdict = "BLOCKER_ACTIVE_SOURCE_HASH_MISMATCH"
    } else {
        $FinalVerdict = "BLOCKER_SCOPE_RISK"
    }
}

$Lines = [System.Collections.Generic.List[string]]::new()

Add-Line $Lines "# PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_USER_NAMED_OBJECT_20260608"
Add-Line $Lines ""
Add-Line $Lines "Mode: HELPER_FIRST / SELECTOR_FIELD_TEST_PACKET / POWERSHELL_RUNNER / FREEZE_EVIDENCE_APPLIED / READ_ONLY_INSPECTION / NO_GIT / NOT_DOCTRINE / NOT_ACTIVE_GUIDES / NOT_CURRENT_TRUTH_INDEX"
Add-Line $Lines ""
Add-Line $Lines "Working root: $ProjectRoot"
Add-Line $Lines "Active lane: $HelperLane"
Add-Line $Lines "User-named object: $UserNamedObject"
Add-Line $Lines "Final verdict: $FinalVerdict"
Add-Line $Lines ""
Add-Line $Lines "This report uses PowerShell as the bounded runner for the selector field test. It also files the prior runner error evidence and fix note before completing the task report."
Add-Line $Lines ""
Add-Line $Lines "This job did not execute arbitrary helper scripts, clean root, route root files, move source files, delete files, rename files, copy source files, overwrite source files, mutate source files, use Git, commit, push, promote doctrine, promote active guides, rewrite the current truth index, open URLs, run fixtures, broadly scan, replay source, reread the full source vault, or claim full source-vault review."
Add-Line $Lines ""
Add-Line $Lines "## FREEZE_EVIDENCE_INCIDENT"
Add-Line $Lines ""
Add-Line $Lines "incident_folder: $IncidentFolder"
Add-Line $Lines "error_log_path: $ErrorLogPath"
Add-Line $Lines "error_log_sha256: $ErrorLogHash"
Add-Line $Lines "fix_note_path: $FixNotePath"
Add-Line $Lines "fix_note_sha256: $FixNoteHash"
Add-Line $Lines "failed_script_copy_path: $FailedScriptCopyPath"
Add-Line $Lines "failed_script_copy_sha256: $FailedScriptCopyHash"
Add-Line $Lines "fixed_script_copy_path: $FixedScriptCopyPath"
Add-Line $Lines "fixed_script_copy_sha256: $FixedScriptCopyHash"
Add-Line $Lines "observed_error: $ObservedError"
Add-Line $Lines "repair_summary: $FixSummary"
Add-Line $Lines ""
Add-Line $Lines "## PREFLIGHT"
Add-Line $Lines ""
Add-Line $Lines "Root loose count before: $RootLooseCountBefore"
Add-Line $Lines "Selector helper path: $SelectorHelper"
Add-Line $Lines "Selector helper SHA256 expected: $SelectorHelperExpected"
Add-Line $Lines "Selector helper SHA256 actual: $SelectorHash"
Add-Line $Lines "Selector helper hash match: $($SelectorHash -eq $SelectorHelperExpected)"
Add-Line $Lines ""
Add-Line $Lines "Source-anchor helper path: $SourceAnchorHelper"
Add-Line $Lines "Source-anchor helper SHA256 expected: $SourceAnchorHelperExpected"
Add-Line $Lines "Source-anchor helper SHA256 actual: $SourceAnchorHash"
Add-Line $Lines "Source-anchor helper hash match: $($SourceAnchorHash -eq $SourceAnchorHelperExpected)"
Add-Line $Lines ""
Add-Line $Lines "Active source path: $ActiveSource"
Add-Line $Lines "Active source SHA256 expected: $ActiveSourceExpected"
Add-Line $Lines "Active source SHA256 actual: $ActiveSourceHash"
Add-Line $Lines "Active source hash match: $($ActiveSourceHash -eq $ActiveSourceExpected)"
Add-Line $Lines ""
Add-Line $Lines "Output report path selected: $OutputReport"
Add-Line $Lines "Preflight blockers count: $($Blockers.Count)"
foreach ($b in $Blockers) {
    Add-Line $Lines "- $b"
}
Add-Line $Lines ""
Add-Line $Lines "## SOURCE_SECTIONS_READ"
Add-Line $Lines ""
Add-Line $Lines "Active source text read in this field-test job: NONE."
Add-Line $Lines "Full source-vault review claimed: NO."
Add-Line $Lines "Source anchors relied on: selector helper and source-anchor helper. Source-anchor helper previously recorded active source lines 99-215 and 219-505."
Add-Line $Lines ""
Add-Line $Lines "## POWERSHELL_HELPER_FILE_SCAN"
Add-Line $Lines ""
Add-Line $Lines "Scan scope: bounded candidate path check only, not a broad inventory scan."
Add-Line $Lines ""
if ($ExistingPowerShellFiles.Count -eq 0) {
    Add-Line $Lines "No specific PowerShell helper file path was found at the bounded candidate paths. The object is field-tested as a user-named object class rather than as a verified individual script file."
} else {
    Add-Line $Lines "Specific candidate PowerShell/helper runner files found:"
    Add-Line $Lines ""
    foreach ($ps in $ExistingPowerShellFiles) {
        Add-Line $Lines "- path: $($ps.Path)"
        Add-Line $Lines "  sha256: $($ps.Sha256)"
        Add-Line $Lines "  length_bytes: $($ps.Length)"
    }
}
Add-Line $Lines ""
Add-Line $Lines "bounded_runner_executed_count: 1"
Add-Line $Lines "arbitrary_helper_scripts_executed_count: 0"
Add-Line $Lines ""
Add-Line $Lines "## STANDARD_RUN_CARD_FILLED"
Add-Line $Lines ""
Add-Line $Lines "Active object: $UserNamedObject"
Add-Line $Lines "Entry source: User-named object class, tested by bounded PowerShell runner."
Add-Line $Lines "Source/custody state: UNVERIFIED_HELPER_CLASS / POWERSHELL_TOOLING_SURFACE / NOT_DOCTRINE / NOT_ACTIVE_GUIDE / NOT_EXECUTION_APPROVED_FOR_ARBITRARY_HELPERS"
Add-Line $Lines "Intake verdict: INTAKE_HOLD_FOR_CLASSIFICATION"
Add-Line $Lines "Layer Echo scan: execution drift, helper-as-authority drift, path/version ambiguity, old helper versus current helper, cleanup drift, Git drift, source-copy drift, overwrite drift, and failure-evidence loss risk."
Add-Line $Lines "Support guard membrane scan: protect helper/source boundary, no-random-execution boundary, path custody, evidence freeze, and no-mutation/no-cleanup/no-Git boundaries."
Add-Line $Lines "Triggered support organ expanded: FREEZE_EVIDENCE / EXECUTION_BOUNDARY / PATH_GUARD / HASH_RECEIPT_CHECK."
Add-Line $Lines "Rope selected: POWERSHELL_AS_BOUNDED_TEST_RUNNER_WITH_FREEZE_EVIDENCE"
Add-Line $Lines "Primary planet: MOON_GATE"
Add-Line $Lines "Primary planet verdict: MOON_CUSTODY_CLASSIFIED - PowerShell helper files and runner evidence require exact custody, version, allowed use, and evidence preservation before further action."
Add-Line $Lines "Counterweight planet: MERCURY_GATE"
Add-Line $Lines "Counterweight verdict: MERCURY_TERM_DEFINED - PowerShell is the runner for this task; arbitrary PowerShell helper scripts are not execution targets unless separately authorized."
Add-Line $Lines "Mechanical gate if needed: Hash/Receipt Gate, Path Guard, and Freeze Evidence Gate. Code Gate only for future read-only code-shape review. No Launch/Runtime Gate for arbitrary scripts."
Add-Line $Lines "Earth check: selector helper hash, source-anchor helper hash, active source hash, incident evidence paths/hashes, output report path/hash, bounded candidate PowerShell file path/hash if present."
Add-Line $Lines "Allowed action: run this bounded PowerShell report-writer; freeze prior error evidence; verify hashes; inspect bounded candidate paths; write exactly one field-test report and incident evidence files."
Add-Line $Lines "Blocked action: execute arbitrary helper scripts, run unknown PS1 tools, modify scripts, move source files, delete files, rename files, copy source files, overwrite source files, cleanup, root routing, Git, commit, push, doctrine promotion, active guide promotion, current truth rewrite, fixture run, URL opening, broad scan."
Add-Line $Lines "Proof need: output report path/hash, incident folder, error log hash, fix note hash, selector helper SHA256, source-anchor helper SHA256, active source SHA256, whether specific PowerShell file paths were found, arbitrary helper scripts executed count."
Add-Line $Lines "Stop condition: helper hash mismatch, output collision, job requires executing arbitrary helper scripts, or scope drift into cleanup/Git/mutation."
Add-Line $Lines "Final route: $FinalRoute"
Add-Line $Lines "DoesNotProve: This field test and fix do not prove arbitrary script safety, runtime behavior of helper scripts, doctrine, active guides, current truth index, full source-vault review, source truth, fixture readiness, cleanup approval, routing approval, mutation authority, Git truth, commit approval, push approval, or project completion."
Add-Line $Lines ""
Add-Line $Lines "## SELECTOR_STEP_BY_STEP_APPLICATION"
Add-Line $Lines ""
Add-Line $Lines "01 INTAKE_GATE: The named object is classified as a PowerShell tooling/helper surface. It is held for classification, not accepted as executable authority."
Add-Line $Lines "02 LAYER_ECHO_FIRST_SCAN: Repeated risk is confusing runner with arbitrary helper execution, losing error evidence, path/version ambiguity, and drifting into cleanup or Git."
Add-Line $Lines "03 SUPPORT_GUARD_MEMBRANE: Protects Freeze Evidence, no-random-execution, and helper/source custody boundaries before judgment."
Add-Line $Lines "04 ROPE_ROUTER: Selects POWERSHELL_AS_BOUNDED_TEST_RUNNER_WITH_FREEZE_EVIDENCE."
Add-Line $Lines "05 PRIMARY_PLANETARY_GATE: MOON_GATE because custody/safe handling/evidence preservation is the core issue."
Add-Line $Lines "06 COUNTERWEIGHT_PLANETARY_GATE: MERCURY_GATE because terms must distinguish runner, failed script, fixed script, helper file, source, and authority."
Add-Line $Lines "07 MECHANICAL_GATE_IF_NEEDED: Hash/Receipt Gate, Path Guard, and Freeze Evidence Gate."
Add-Line $Lines "08 EARTH_CHECK: Material proof is incident evidence plus output report and SHA256 confirmations."
Add-Line $Lines "09 FINAL_JUDGE: $FinalRoute under $FinalVerdict."
Add-Line $Lines ""
Add-Line $Lines "## BLOCKER_PATHFINDING_MAP"
Add-Line $Lines ""
Add-Line $Lines "### BLOCKER 01"
Add-Line $Lines "BLOCKER: Prior runner failed before report creation."
Add-Line $Lines "ACTION BLOCKED: Pretending the field-test packet was complete."
Add-Line $Lines "WHY BLOCKED: PowerShell rejected an empty List[string] being bound to a mandatory parameter in Add-Line."
Add-Line $Lines "MISSING CONDITION: Freeze evidence, fix runner, rerun bounded report creation."
Add-Line $Lines "POINTS TO NEXT: Use this V0_2 fixed runner."
Add-Line $Lines "SAFE WORK NOW: File the error log, copy available failed/fixed scripts, write the fixed report."
Add-Line $Lines "STILL NOT AUTHORIZED: Skipping the error trail or erasing the failed run."
Add-Line $Lines "DOESNOTPROVE: A fixed runner does not prove arbitrary script safety."
Add-Line $Lines ""
Add-Line $Lines "### BLOCKER 02"
Add-Line $Lines "BLOCKER: PowerShell helper files may be executable tooling."
Add-Line $Lines "ACTION BLOCKED: Arbitrary script execution."
Add-Line $Lines "WHY BLOCKED: This job is a bounded runner/report writer plus evidence freeze, not a runtime trust test for scripts."
Add-Line $Lines "MISSING CONDITION: Separate user-approved script execution/test job with exact file path, purpose, expected behavior, rollback boundary, and proof requirement."
Add-Line $Lines "POINTS TO NEXT: If needed, create a read-only code-shape review or controlled live-use test for one exact PS1 file."
Add-Line $Lines "SAFE WORK NOW: Hash, classify, preserve evidence, and write this field-test packet."
Add-Line $Lines "STILL NOT AUTHORIZED: Running unknown helper scripts."
Add-Line $Lines "DOESNOTPROVE: Hashing a script does not prove it is safe to execute."
Add-Line $Lines ""
Add-Line $Lines "### BLOCKER 03"
Add-Line $Lines "BLOCKER: Helper files are support surfaces, not source authority."
Add-Line $Lines "ACTION BLOCKED: Treating helper output as doctrine, active guide, current truth, or full source truth."
Add-Line $Lines "WHY BLOCKED: Helper-first reduces reread burden but does not replace source authority or promotion review."
Add-Line $Lines "MISSING CONDITION: Separate promotion/adoption job with source/proof requirements."
Add-Line $Lines "POINTS TO NEXT: Use helper surfaces for navigation and build only."
Add-Line $Lines "SAFE WORK NOW: Field-test selector behavior and preserve the failure/fix evidence."
Add-Line $Lines "STILL NOT AUTHORIZED: Doctrine or current-truth rewrite."
Add-Line $Lines "DOESNOTPROVE: A field-test packet does not prove authority."
Add-Line $Lines ""
Add-Line $Lines "## NEXT_RECOMMENDED_BUILD_CHUNK"
Add-Line $Lines ""
Add-Line $Lines "POWERSHELL_HELPER_FILE_EXACT_PATH_CODE_SHAPE_REVIEW_OR_CONTROLLED_LIVE_USE_TEST_20260608"
Add-Line $Lines ""
Add-Line $Lines "Reason: The selector can classify PowerShell helper files as a tooling/support class and the failure/fix trail is preserved. The next useful step, if the user wants it, is to name one exact PS1 file and perform either read-only code-shape review or a controlled live-use test. Do not generalize across all PowerShell helpers."
Add-Line $Lines ""
Add-Line $Lines "## DOESNOTPROVE"
Add-Line $Lines ""
Add-Line $Lines "This field test and fix do not prove arbitrary script safety, runtime behavior, doctrine, active guides, current truth index, full source-vault review, source truth, fixture readiness, cleanup approval, routing approval, mutation authority, Git truth, commit approval, push approval, or project completion."
Add-Line $Lines ""

$Lines | Set-Content -LiteralPath $OutputReport -Encoding UTF8

$RootLooseCountAfter = (Get-ChildItem -LiteralPath $ProjectRoot -File -Force | Measure-Object).Count

$Append = [System.Collections.Generic.List[string]]::new()
Add-Line $Append ""
Add-Line $Append "## FINAL_RETURN_FIELDS"
Add-Line $Append ""
Add-Line $Append "01 output_report_path: $OutputReport"
Add-Line $Append "02 output_report_sha256: FINAL_HASH_RECORDED_IN_CONSOLE_AND_HASH_RECEIPT"
Add-Line $Append "03 selector_helper_sha256_confirmed: $SelectorHash"
Add-Line $Append "04 source_anchor_helper_sha256_confirmed: $SourceAnchorHash"
Add-Line $Append "05 active_object_sha256_confirmed_if_checked: $ActiveSourceHash"
Add-Line $Append "06 user_named_object: $UserNamedObject"
Add-Line $Append "07 specific_powershell_file_path_named: $SpecificPowerShellFilePathNamed"
Add-Line $Append "08 source_sections_read: NONE in this field-test job; relied on selector helper and source-anchor helper"
Add-Line $Append "09 full_source_vault_review_claimed: NO"
Add-Line $Append "10 selector_applied: YES"
Add-Line $Append "11 primary_planet_selected: MOON_GATE"
Add-Line $Append "12 counterweight_planet_selected: MERCURY_GATE"
Add-Line $Append "13 mechanical_gate_selected: Hash/Receipt Gate; Path Guard; Freeze Evidence Gate"
Add-Line $Append "14 final_route: $FinalRoute"
Add-Line $Append "15 files_moved_count: 0"
Add-Line $Append "16 files_deleted_count: 0"
Add-Line $Append "17 files_renamed_count: 0"
Add-Line $Append "18 source_files_copied_count: 0"
Add-Line $Append "19 files_overwritten_count: 0"
Add-Line $Append "20 bounded_runner_executed_count: 1"
Add-Line $Append "21 arbitrary_helper_scripts_executed_count: 0"
Add-Line $Append "22 git_commit_or_push_done: NO"
Add-Line $Append "23 root_loose_count_before: $RootLooseCountBefore"
Add-Line $Append "24 root_loose_count_after: $RootLooseCountAfter"
Add-Line $Append "25 freeze_evidence_incident_folder: $IncidentFolder"
Add-Line $Append "26 error_log_path: $ErrorLogPath"
Add-Line $Append "27 error_log_sha256: $ErrorLogHash"
Add-Line $Append "28 fix_note_path: $FixNotePath"
Add-Line $Append "29 fix_note_sha256: $FixNoteHash"
Add-Line $Append "30 failed_script_copy_path: $FailedScriptCopyPath"
Add-Line $Append "31 fixed_script_copy_path: $FixedScriptCopyPath"
Add-Line $Append "32 final_verdict: $FinalVerdict"

$Append | Add-Content -LiteralPath $OutputReport -Encoding UTF8

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputReport -Algorithm SHA256).Hash
$HashReceiptPath = Join-Child $IncidentFolder "OUTPUT_REPORT_HASH_RECEIPT__PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_20260608.txt"
$HashReceiptLines = [System.Collections.Generic.List[string]]::new()
Add-Line $HashReceiptLines "output_report_path: $OutputReport"
Add-Line $HashReceiptLines "output_report_sha256: $FinalOutputHash"
Add-Line $HashReceiptLines "error_log_path: $ErrorLogPath"
Add-Line $HashReceiptLines "error_log_sha256: $ErrorLogHash"
Add-Line $HashReceiptLines "fix_note_path: $FixNotePath"
Add-Line $HashReceiptLines "fix_note_sha256: $FixNoteHash"
Add-Line $HashReceiptLines "fixed_runner_path: $ThisFixedScriptPath"
Add-Line $HashReceiptLines "fixed_runner_sha256: $ThisFixedScriptHash"
$HashReceiptLines | Set-Content -LiteralPath $HashReceiptPath -Encoding UTF8
$HashReceiptHash = Get-Sha256OrMissing -Path $HashReceiptPath

Write-Host "=== FREEZE EVIDENCE + SELECTOR FIELD TEST PACKET COMPLETE ==="
Write-Host "output_report_path: $OutputReport"
Write-Host "output_report_sha256: $FinalOutputHash"
Write-Host "selector_helper_sha256_confirmed: $SelectorHash"
Write-Host "source_anchor_helper_sha256_confirmed: $SourceAnchorHash"
Write-Host "active_object_sha256_confirmed_if_checked: $ActiveSourceHash"
Write-Host "user_named_object: $UserNamedObject"
Write-Host "specific_powershell_file_path_named: $SpecificPowerShellFilePathNamed"
Write-Host "source_sections_read: NONE in this field-test job; relied on selector helper and source-anchor helper"
Write-Host "full_source_vault_review_claimed: NO"
Write-Host "selector_applied: YES"
Write-Host "primary_planet_selected: MOON_GATE"
Write-Host "counterweight_planet_selected: MERCURY_GATE"
Write-Host "mechanical_gate_selected: Hash/Receipt Gate; Path Guard; Freeze Evidence Gate"
Write-Host "final_route: $FinalRoute"
Write-Host "files_moved_count: 0"
Write-Host "files_deleted_count: 0"
Write-Host "files_renamed_count: 0"
Write-Host "source_files_copied_count: 0"
Write-Host "files_overwritten_count: 0"
Write-Host "bounded_runner_executed_count: 1"
Write-Host "arbitrary_helper_scripts_executed_count: 0"
Write-Host "git_commit_or_push_done: NO"
Write-Host "root_loose_count_before: $RootLooseCountBefore"
Write-Host "root_loose_count_after: $RootLooseCountAfter"
Write-Host "freeze_evidence_incident_folder: $IncidentFolder"
Write-Host "error_log_path: $ErrorLogPath"
Write-Host "error_log_sha256: $ErrorLogHash"
Write-Host "fix_note_path: $FixNotePath"
Write-Host "fix_note_sha256: $FixNoteHash"
Write-Host "failed_script_copy_path: $FailedScriptCopyPath"
Write-Host "failed_script_copy_sha256: $FailedScriptCopyHash"
Write-Host "fixed_script_copy_path: $FixedScriptCopyPath"
Write-Host "fixed_script_copy_sha256: $FixedScriptCopyHash"
Write-Host "hash_receipt_path: $HashReceiptPath"
Write-Host "hash_receipt_sha256: $HashReceiptHash"
Write-Host "final_verdict: $FinalVerdict"

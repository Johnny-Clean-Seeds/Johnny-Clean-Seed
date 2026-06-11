<# 
RUN_SELECTOR_FIELD_TEST_PACKET_FOR_POWERSHELL_HELPER_FILES_20260608.ps1

Purpose:
Use PowerShell as the bounded runner to create the selector field-test packet for:
USER_NAMED_OBJECT: PowerShell helper files

This runner:
- reads helper reports
- verifies expected hashes
- optionally verifies active source object hash
- writes exactly one new output report
- does NOT execute helper scripts
- does NOT mutate source files
- does NOT use Git
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\Users\13527\Desktop\123",
    [string]$UserNamedObject = "PowerShell helper files"
)

$ErrorActionPreference = "Stop"

function Join-Child {
    param(
        [Parameter(Mandatory=$true)][string]$Base,
        [Parameter(Mandatory=$true)][string]$Child
    )
    return [System.IO.Path]::Combine($Base, $Child)
}

function Get-Sha256OrMissing {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return "MISSING"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Line {
    param(
        [Parameter(Mandatory=$true)][System.Collections.Generic.List[string]]$Lines,
        [string]$Text = ""
    )
    [void]$Lines.Add($Text)
}

function Get-NextOutputPath {
    param(
        [Parameter(Mandatory=$true)][string]$Folder,
        [Parameter(Mandatory=$true)][string]$BaseNameNoExt,
        [Parameter(Mandatory=$true)][string]$Ext
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

$HelperLane = Join-Child $ProjectRoot "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"

$SelectorHelper = Join-Child $HelperLane "PLANETARY_GATE_SOURCE_ANCHORED_STANDARD_RUN_CARD_AND_SELECTOR_BUILD_20260608.md"
$SelectorHelperExpected = "377663FFD2DDF1E7C95FC3D19A18B04EB4E304350633F2AB260CD660154366C3"

$SourceAnchorHelper = Join-Child $HelperLane "PLANETARY_GATE_ROLE_CARD_MATRIX_SOURCE_ANCHOR_PASS_20260608.md"
$SourceAnchorHelperExpected = "C22F9A9C739FD2BE3B6696DB193B10164E3363F1120E9EB52B37D393C0615260"

$ActiveSource = Join-Child $ProjectRoot "PLANETARY_HOUSE_GATE_MASTER_INDEX_WITH_INTAKE_TOOLBELT_V0_3_RAW_COMBINED_WITH_GUARD_MEMBRANE_20260607.md"
$ActiveSourceExpected = "7F7B61C0915966EA3222587BA97B1ED8BCC47FC62739526B0542C557DA3156F7"

$OutputBaseName = "PLANETARY_GATE_SELECTOR_FIELD_TEST_PACKET_FOR_USER_NAMED_OBJECT_20260608"
$OutputReport = Get-NextOutputPath -Folder $HelperLane -BaseNameNoExt $OutputBaseName -Ext ".md"

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
    (Join-Child $ProjectRoot "WRITE_CODING_ROOM_UNSAFE_CONTROL_FMEA_LEDGER_V1_UNIQUE_20260531_0610.ps1"),
    (Join-Child $ProjectRoot "WRITE_SHAPE_SELFTEST_BENCH_LIVE_USE_STARTER_V1_1_UNIQUE_20260531_0905.ps1")
)

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
    $SpecificPowerShellFilePathNamed = "YES_BY_CANDIDATE_SCAN"
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
Add-Line $Lines "Mode: HELPER_FIRST / SELECTOR_FIELD_TEST_PACKET / POWERSHELL_RUNNER / READ_ONLY_INSPECTION / NO_GIT / NOT_DOCTRINE / NOT_ACTIVE_GUIDES / NOT_CURRENT_TRUTH_INDEX"
Add-Line $Lines ""
Add-Line $Lines "Working root: $ProjectRoot"
Add-Line $Lines ""
Add-Line $Lines "Active lane: $HelperLane"
Add-Line $Lines ""
Add-Line $Lines "User-named object: $UserNamedObject"
Add-Line $Lines ""
Add-Line $Lines "Final verdict: $FinalVerdict"
Add-Line $Lines ""
Add-Line $Lines "This report uses PowerShell as the bounded runner for the selector field test. It does not execute arbitrary helper scripts. It reads known helper reports, verifies hashes, checks candidate PowerShell helper file paths if present, writes this single report, and returns material proof."
Add-Line $Lines ""
Add-Line $Lines "This job did not clean root, route root files, move files, delete files, rename files, copy source files, overwrite files, mutate source files, use Git, commit, push, promote doctrine, promote active guides, rewrite the current truth index, open URLs, run fixtures, broadly scan, replay source, reread the full source vault, or claim full source-vault review."
Add-Line $Lines ""
Add-Line $Lines "## PREFLIGHT"
Add-Line $Lines ""
Add-Line $Lines "Root loose count before: $RootLooseCountBefore"
Add-Line $Lines ""
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
Add-Line $Lines ""
Add-Line $Lines "Preflight blockers count: $($Blockers.Count)"
foreach ($b in $Blockers) {
    Add-Line $Lines "- $b"
}
Add-Line $Lines ""
Add-Line $Lines "## SOURCE_SECTIONS_READ"
Add-Line $Lines ""
Add-Line $Lines "Active source text read in this field-test job: NONE."
Add-Line $Lines ""
Add-Line $Lines "Full source-vault review claimed: NO."
Add-Line $Lines ""
Add-Line $Lines "Source anchors relied on: selector helper and source-anchor helper. Source-anchor helper previously recorded active source lines 99-215 and 219-505."
Add-Line $Lines ""
Add-Line $Lines "## POWERSHELL_HELPER_FILE_SCAN"
Add-Line $Lines ""
Add-Line $Lines "Scan scope: bounded candidate path check only, not a broad inventory scan."
Add-Line $Lines ""
if ($ExistingPowerShellFiles.Count -eq 0) {
    Add-Line $Lines "No specific PowerShell helper file path was found at the bounded candidate paths."
    Add-Line $Lines ""
    Add-Line $Lines "The object is therefore field-tested as a user-named object class rather than as a verified individual script file."
} else {
    Add-Line $Lines "Specific candidate PowerShell helper files found:"
    Add-Line $Lines ""
    foreach ($ps in $ExistingPowerShellFiles) {
        Add-Line $Lines "- path: $($ps.Path)"
        Add-Line $Lines "  sha256: $($ps.Sha256)"
        Add-Line $Lines "  length_bytes: $($ps.Length)"
    }
}
Add-Line $Lines ""
Add-Line $Lines "Scripts executed count: 0"
Add-Line $Lines ""
Add-Line $Lines "## STANDARD_RUN_CARD_FILLED"
Add-Line $Lines ""
Add-Line $Lines "Active object: $UserNamedObject"
Add-Line $Lines ""
Add-Line $Lines "Entry source: User-named object class, tested by bounded PowerShell runner."
Add-Line $Lines ""
Add-Line $Lines "Source/custody state: UNVERIFIED_HELPER_CLASS / POWERSHELL_TOOLING_SURFACE / NOT_DOCTRINE / NOT_ACTIVE_GUIDE / NOT_EXECUTION_APPROVED"
Add-Line $Lines ""
Add-Line $Lines "Intake verdict: INTAKE_HOLD_FOR_CLASSIFICATION"
Add-Line $Lines ""
Add-Line $Lines "Layer Echo scan: execution drift, helper-as-authority drift, path/version ambiguity, old helper versus current helper, cleanup drift, Git drift, source-copy drift, overwrite drift."
Add-Line $Lines ""
Add-Line $Lines "Support guard membrane scan: protect helper/source boundary, no-execution boundary, path custody, and no-mutation/no-cleanup/no-Git boundaries."
Add-Line $Lines ""
Add-Line $Lines "Triggered support organ expanded: EXECUTION_BOUNDARY plus PATH_GUARD and HASH_RECEIPT_CHECK."
Add-Line $Lines ""
Add-Line $Lines "Rope selected: POWERSHELL_AS_BOUNDED_TEST_RUNNER_FOR_HELPER_FILE_FIELD_TEST"
Add-Line $Lines ""
Add-Line $Lines "Primary planet: MOON_GATE"
Add-Line $Lines ""
Add-Line $Lines "Primary planet verdict: MOON_CUSTODY_CLASSIFIED - PowerShell helper files are tooling/support surfaces requiring exact path, version, and allowed-use boundaries before any execution or mutation."
Add-Line $Lines ""
Add-Line $Lines "Counterweight planet: MERCURY_GATE"
Add-Line $Lines ""
Add-Line $Lines "Counterweight verdict: MERCURY_TERM_DEFINED - PowerShell is the runner for this test; PowerShell helper files are the named object class under classification, not automatic execution targets."
Add-Line $Lines ""
Add-Line $Lines "Mechanical gate if needed: Hash/Receipt Gate and Path Guard. Code Gate only for future read-only code-shape review. No Launch/Runtime Gate for arbitrary scripts."
Add-Line $Lines ""
Add-Line $Lines "Earth check: selector helper hash, source-anchor helper hash, active source hash, output report path/hash, bounded candidate PowerShell file path/hash if present."
Add-Line $Lines ""
Add-Line $Lines "Allowed action: run this bounded PowerShell report-writer; verify hashes; inspect bounded candidate paths; write exactly one output report."
Add-Line $Lines ""
Add-Line $Lines "Blocked action: execute helper scripts, run unknown PS1 tools, modify scripts, move files, delete files, rename files, copy source files, overwrite files, cleanup, root routing, Git, commit, push, doctrine promotion, active guide promotion, current truth rewrite, fixture run, URL opening, broad scan."
Add-Line $Lines ""
Add-Line $Lines "Proof need: output report path, output report SHA256, selector helper SHA256, source-anchor helper SHA256, active source SHA256, whether specific PowerShell file paths were found, scripts executed count."
Add-Line $Lines ""
Add-Line $Lines "Stop condition: helper hash mismatch, output collision, job requires executing arbitrary helper scripts, scope drift into cleanup/Git/mutation."
Add-Line $Lines ""
Add-Line $Lines "Final route: $FinalRoute"
Add-Line $Lines ""
Add-Line $Lines "DoesNotProve: This field test does not prove script safety, runtime behavior of helper scripts, doctrine, active guides, current truth index, full source-vault review, source truth, fixture readiness, cleanup approval, routing approval, mutation authority, Git truth, commit approval, push approval, or project completion."
Add-Line $Lines ""
Add-Line $Lines "## SELECTOR_STEP_BY_STEP_APPLICATION"
Add-Line $Lines ""
Add-Line $Lines "01 INTAKE_GATE: The named object is classified as a PowerShell tooling/helper surface. It is held for classification, not accepted as executable authority."
Add-Line $Lines ""
Add-Line $Lines "02 LAYER_ECHO_FIRST_SCAN: Repeated risk is confusing helper files with source authority, running scripts before reading/classifying, path/version ambiguity, and drifting into cleanup or Git."
Add-Line $Lines ""
Add-Line $Lines "03 SUPPORT_GUARD_MEMBRANE: Protects the no-execution boundary and helper/source custody boundary before judgment."
Add-Line $Lines ""
Add-Line $Lines "04 ROPE_ROUTER: Selects POWERSHELL_AS_BOUNDED_TEST_RUNNER_FOR_HELPER_FILE_FIELD_TEST."
Add-Line $Lines ""
Add-Line $Lines "05 PRIMARY_PLANETARY_GATE: MOON_GATE because custody/safe handling is the core issue."
Add-Line $Lines ""
Add-Line $Lines "06 COUNTERWEIGHT_PLANETARY_GATE: MERCURY_GATE because the wording must distinguish runner, helper file, script, source, and authority."
Add-Line $Lines ""
Add-Line $Lines "07 MECHANICAL_GATE_IF_NEEDED: Hash/Receipt Gate and Path Guard, because this test proves file identity and report creation, not runtime safety."
Add-Line $Lines ""
Add-Line $Lines "08 EARTH_CHECK: Material proof is the output report and SHA256 plus helper hash confirmations."
Add-Line $Lines ""
Add-Line $Lines "09 FINAL_JUDGE: $FinalRoute under $FinalVerdict."
Add-Line $Lines ""
Add-Line $Lines "## BLOCKER_PATHFINDING_MAP"
Add-Line $Lines ""
Add-Line $Lines "### BLOCKER 01"
Add-Line $Lines ""
Add-Line $Lines "BLOCKER: PowerShell helper files may be executable tooling."
Add-Line $Lines "ACTION BLOCKED: Arbitrary script execution."
Add-Line $Lines "WHY BLOCKED: This job is a selector field test and report writer, not a runtime trust test for scripts."
Add-Line $Lines "MISSING CONDITION: Separate user-approved script execution/test job with exact file path, purpose, expected behavior, rollback boundary, and proof requirement."
Add-Line $Lines "POINTS TO NEXT: If needed, create a read-only code-shape review or controlled live-use test for one exact PS1 file."
Add-Line $Lines "SAFE WORK NOW: Hash, classify, and write this field-test packet."
Add-Line $Lines "STILL NOT AUTHORIZED: Running unknown helper scripts."
Add-Line $Lines "DOESNOTPROVE: Hashing a script does not prove it is safe to execute."
Add-Line $Lines ""
Add-Line $Lines "### BLOCKER 02"
Add-Line $Lines ""
Add-Line $Lines "BLOCKER: Helper files are support surfaces, not source authority."
Add-Line $Lines "ACTION BLOCKED: Treating helper output as doctrine, active guide, current truth, or full source truth."
Add-Line $Lines "WHY BLOCKED: Helper-first reduces reread burden but does not replace source authority or promotion review."
Add-Line $Lines "MISSING CONDITION: Separate promotion/adoption job with source/proof requirements."
Add-Line $Lines "POINTS TO NEXT: Use helper surfaces for navigation and build only."
Add-Line $Lines "SAFE WORK NOW: Field-test selector behavior."
Add-Line $Lines "STILL NOT AUTHORIZED: Doctrine or current-truth rewrite."
Add-Line $Lines "DOESNOTPROVE: A field-test packet does not prove authority."
Add-Line $Lines ""
Add-Line $Lines "### BLOCKER 03"
Add-Line $Lines ""
Add-Line $Lines "BLOCKER: Git is not current truth for this lane."
Add-Line $Lines "ACTION BLOCKED: Git truth claim, commit, push, snapshot."
Add-Line $Lines "WHY BLOCKED: Current lane truth surface is local reports, hashes, and receipts."
Add-Line $Lines "MISSING CONDITION: Explicit user-approved Git snapshot/export/commit job."
Add-Line $Lines "POINTS TO NEXT: Keep local hash/report proof."
Add-Line $Lines "SAFE WORK NOW: Write local field-test report."
Add-Line $Lines "STILL NOT AUTHORIZED: Git, commit, push."
Add-Line $Lines "DOESNOTPROVE: Local report truth does not prove Git truth."
Add-Line $Lines ""
Add-Line $Lines "## NEXT_RECOMMENDED_BUILD_CHUNK"
Add-Line $Lines ""
Add-Line $Lines "POWERSHELL_HELPER_FILE_EXACT_PATH_CODE_SHAPE_REVIEW_OR_CONTROLLED_LIVE_USE_TEST_20260608"
Add-Line $Lines ""
Add-Line $Lines "Reason: The selector can classify PowerShell helper files as a tooling/support class. The next useful step, if the user wants it, is to name one exact PS1 file and perform either read-only code-shape review or a controlled live-use test. Do not generalize across all PowerShell helpers."
Add-Line $Lines ""
Add-Line $Lines "## DOESNOTPROVE"
Add-Line $Lines ""
Add-Line $Lines "This field test does not prove script safety, runtime behavior, doctrine, active guides, current truth index, full source-vault review, source truth, fixture readiness, cleanup approval, routing approval, mutation authority, Git truth, commit approval, push approval, or project completion."
Add-Line $Lines ""

# Write exactly one output report.
$Lines | Set-Content -LiteralPath $OutputReport -Encoding UTF8

$OutputHash = (Get-FileHash -LiteralPath $OutputReport -Algorithm SHA256).Hash
$RootLooseCountAfter = (Get-ChildItem -LiteralPath $ProjectRoot -File -Force | Measure-Object).Count

$Append = [System.Collections.Generic.List[string]]::new()
Add-Line $Append ""
Add-Line $Append "## FINAL_RETURN_FIELDS"
Add-Line $Append ""
Add-Line $Append "01 output_report_path: $OutputReport"
Add-Line $Append "02 output_report_sha256: $OutputHash"
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
Add-Line $Append "13 mechanical_gate_selected: Hash/Receipt Gate; Path Guard"
Add-Line $Append "14 final_route: $FinalRoute"
Add-Line $Append "15 files_moved_count: 0"
Add-Line $Append "16 files_deleted_count: 0"
Add-Line $Append "17 files_renamed_count: 0"
Add-Line $Append "18 source_files_copied_count: 0"
Add-Line $Append "19 files_overwritten_count: 0"
Add-Line $Append "20 scripts_executed_count: 0"
Add-Line $Append "21 git_commit_or_push_done: NO"
Add-Line $Append "22 root_loose_count_before: $RootLooseCountBefore"
Add-Line $Append "23 root_loose_count_after: $RootLooseCountAfter"
Add-Line $Append "24 final_verdict: $FinalVerdict"

$Append | Add-Content -LiteralPath $OutputReport -Encoding UTF8

$FinalOutputHash = (Get-FileHash -LiteralPath $OutputReport -Algorithm SHA256).Hash

Write-Host "=== SELECTOR FIELD TEST PACKET COMPLETE ==="
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
Write-Host "mechanical_gate_selected: Hash/Receipt Gate; Path Guard"
Write-Host "final_route: $FinalRoute"
Write-Host "files_moved_count: 0"
Write-Host "files_deleted_count: 0"
Write-Host "files_renamed_count: 0"
Write-Host "source_files_copied_count: 0"
Write-Host "files_overwritten_count: 0"
Write-Host "scripts_executed_count: 0"
Write-Host "git_commit_or_push_done: NO"
Write-Host "root_loose_count_before: $RootLooseCountBefore"
Write-Host "root_loose_count_after: $RootLooseCountAfter"
Write-Host "final_verdict: $FinalVerdict"

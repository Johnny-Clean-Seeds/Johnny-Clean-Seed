Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608"
$FinalVerdict = "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_READY_WITH_STRESS_BENCH_PASS"
$NextBuildChunk = "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_ROUGH_LOCAL_IMPORT_20260608"
$AfterImportNextBuildChunk = "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "deb16fa806cf8dc7d57a28c8ee653c2f59e321ac"

$ScriptQueueReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$ScriptQueueReportSha = "7852B77BA614A172B328AC2B422E0EF0D4443D4F0FDE0A84F75A218E0206EB2B"

$ScriptQueueReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$ScriptQueueReceiptSha = "6EA3AB7A96C4613B698A4542049378D1D604C40EA7E356C00D1B1025FCF70947"

$ScriptQueueStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_STRESS_BENCH_20260608.md"
$ScriptQueueStressSha = "2CB8467E1373490461583E4560819E9CE1201505661F6E01EBCA4374CDD8B818"

$ScriptQueueRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$ScriptQueueRoughLedgerSha = "0D1A89C2AAF3DC3DAC8FD1EDCCEA4EF7266BD4C6512CD2A2DB0BC0B02F745747"

$ScriptQueueRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$ScriptQueueRoughReceiptSha = "902C22F6FF50E03E0A2276E94DCE328564296E5BBA7589429034B9D624D5FA50"

$ScriptQueueGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1\ROUGH_LOCAL_ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$ScriptQueueGitImportPacketSha = "B6912304C74A90349782A86CA5D04CEC4957181894084170B693DADAA0FEB659"

$ReviewReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_OR_HOLD_DECISION_READ_ONLY_REVIEW_V0_2_20260608.md"
$ReviewReportSha = "5926E984B853D3422023BF6AA5F4180A81C3AFE716FB6E18F09906102CBCD20D"

$ReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$ReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$StressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_STRESS_BENCH_20260608.md"

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
}

function Add-Blocker {
    param([string]$Message)
    $script:Blockers.Add($Message) | Out-Null
}

function Escape-Cell {
    param([AllowNull()][string]$Value)
    if ($null -eq $Value) { return "" }
    return (($Value -replace "\|", "\|") -replace "`r?`n", " ")
}

function Get-ReviewSnapshotNonScriptNames {
    param([AllowNull()][AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines)

    $Names = New-Object System.Collections.Generic.HashSet[string]
    $InTable = $false

    if ($null -eq $Lines) { return $Names }

    foreach ($LineRaw in $Lines) {
        $Line = [string]$LineRaw

        if ($Line -eq "## Route-or-hold decision table") {
            $InTable = $true
            continue
        }

        if ($InTable -and $Line -match '^## ' -and $Line -ne "## Route-or-hold decision table") {
            break
        }

        if (-not $InTable) { continue }
        if ($Line -notmatch '^\|') { continue }
        if ($Line -match '^\|---') { continue }
        if ($Line -match '^\| Name \|') { continue }

        $Parts = $Line -split '\|'
        if ($Parts.Count -lt 8) { continue }

        $Name = $Parts[1].Trim()
        if ([string]::IsNullOrWhiteSpace($Name)) { continue }

        if ([System.IO.Path]::GetExtension($Name) -ine ".ps1") {
            [void]$Names.Add($Name)
        }
    }

    return $Names
}

function Get-NonScriptCustodyClass {
    param([Parameter(Mandatory=$true)][System.IO.FileInfo]$File)

    if ($File.Name -ieq "desktop.ini") {
        return "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE"
    }

    if ($File.Length -eq 0) {
        return "ZERO_BYTE_REVIEW_ONLY_NO_DELETE"
    }

    if ($File.Extension -ieq ".md") {
        return "ROOT_MARKDOWN_DOCUMENT"
    }

    if ($File.Extension -ieq ".txt") {
        return "ROOT_TEXT_OR_RECEIPT_DOCUMENT"
    }

    return "ROOT_NON_SCRIPT_OTHER"
}

function Get-NonScriptDecision {
    param([Parameter(Mandatory=$true)][string]$CustodyClass)

    switch ($CustodyClass) {
        "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE" {
            return [ordered]@{
                Decision = "LEAVE_IN_PLACE"
                ActionNow = "NO"
                Reason = "desktop.ini is Windows metadata. No cleanup or routing from this queue."
            }
        }
        "ZERO_BYTE_REVIEW_ONLY_NO_DELETE" {
            return [ordered]@{
                Decision = "HOLD_PENDING_MANUAL_REVIEW_NO_DELETE"
                ActionNow = "NO"
                Reason = "Zero-byte does not mean trash. Manual review required before any action."
            }
        }
        "ROOT_MARKDOWN_DOCUMENT" {
            return [ordered]@{
                Decision = "HOLD_PENDING_DOCUMENT_CUSTODY_REVIEW"
                ActionNow = "NO"
                Reason = "Root Markdown document needs custody sorting before routing."
            }
        }
        "ROOT_TEXT_OR_RECEIPT_DOCUMENT" {
            return [ordered]@{
                Decision = "HOLD_PENDING_TEXT_CUSTODY_REVIEW"
                ActionNow = "NO"
                Reason = "Root text or receipt file needs custody sorting before routing."
            }
        }
        default {
            return [ordered]@{
                Decision = "HOLD_PENDING_NON_SCRIPT_CUSTODY_REVIEW"
                ActionNow = "NO"
                Reason = "Non-script root file needs custody sorting before any movement."
            }
        }
    }
}

$Blockers = New-Object System.Collections.Generic.List[string]
$StressResults = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]

Write-Host "=== ROOT HELD GROUP NON-SCRIPT CUSTODY REVIEW QUEUE V0_1 ==="

$RequiredFiles = [ordered]@{
    ScriptQueueReport = [ordered]@{ Path = $ScriptQueueReportPath; Sha256 = $ScriptQueueReportSha }
    ScriptQueueReceipt = [ordered]@{ Path = $ScriptQueueReceiptPath; Sha256 = $ScriptQueueReceiptSha }
    ScriptQueueStress = [ordered]@{ Path = $ScriptQueueStressPath; Sha256 = $ScriptQueueStressSha }
    ScriptQueueRoughLedger = [ordered]@{ Path = $ScriptQueueRoughLedgerPath; Sha256 = $ScriptQueueRoughLedgerSha }
    ScriptQueueRoughReceipt = [ordered]@{ Path = $ScriptQueueRoughReceiptPath; Sha256 = $ScriptQueueRoughReceiptSha }
    ScriptQueueGitImportPacket = [ordered]@{ Path = $ScriptQueueGitImportPacketPath; Sha256 = $ScriptQueueGitImportPacketSha }
    ReviewReport = [ordered]@{ Path = $ReviewReportPath; Sha256 = $ReviewReportSha }
}

foreach ($Key in $RequiredFiles.Keys) {
    $Path = [string]$RequiredFiles[$Key].Path
    $Want = [string]$RequiredFiles[$Key].Sha256

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Blocker "REQUIRED_FILE_MISSING: $Key :: $Path"
        continue
    }

    $Got = Get-Sha256 -Path $Path
    if ($Got -ne $Want) {
        Add-Blocker "SHA256_MISMATCH: $Key :: expected $Want :: got $Got :: path $Path"
        continue
    }

    $VerifiedLines.Add("$Key SHA256 confirmed: $Got") | Out-Null
}

$ScriptQueueText = Get-Content -LiteralPath $ScriptQueueReportPath -Raw
$ScriptQueueReceiptText = Get-Content -LiteralPath $ScriptQueueReceiptPath -Raw
$ScriptQueueStressText = Get-Content -LiteralPath $ScriptQueueStressPath -Raw
$ReviewLines = @(Get-Content -LiteralPath $ReviewReportPath | ForEach-Object { [string]$_ })

$Signals = @(
    "final_verdict: ROOT_HELD_GROUP_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_READY_WITH_STRESS_BENCH_PASS",
    "current_root_script_count: 53",
    "post_review_root_script_count: 11",
    "action_now_row_count: 0",
    "files_executed_count: 0"
)

foreach ($Signal in $Signals) {
    if (
        $ScriptQueueText -notmatch [regex]::Escape($Signal) -and
        $ScriptQueueReceiptText -notmatch [regex]::Escape($Signal) -and
        $ScriptQueueStressText -notmatch [regex]::Escape($Signal)
    ) {
        Add-Blocker "SCRIPT_QUEUE_SIGNAL_MISSING: $Signal"
    }
}

$GitHead = (& git -C $GitTop rev-parse HEAD 2>&1)
if ($LASTEXITCODE -ne 0) {
    Add-Blocker "GIT_HEAD_READ_FAILED: $GitHead"
} elseif ($GitHead.Trim() -ne $ExpectedGitHead) {
    Add-Blocker "GIT_HEAD_MISMATCH: expected $ExpectedGitHead :: got $($GitHead.Trim())"
}

$GitStatus = (& git -C $GitTop status --short 2>&1)
if ($LASTEXITCODE -ne 0) {
    Add-Blocker "GIT_STATUS_READ_FAILED: $GitStatus"
} elseif (($GitStatus | Out-String).Trim().Length -ne 0) {
    Add-Blocker "GIT_STATUS_NOT_CLEAN: $($GitStatus | Out-String)"
}

foreach ($OutputPath in @($ReportPath, $ReceiptPath, $StressPath)) {
    if (Test-Path -LiteralPath $OutputPath -PathType Leaf) {
        Add-Blocker "OUTPUT_ALREADY_EXISTS_NO_OVERWRITE: $OutputPath"
    }
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND BEFORE NON-SCRIPT QUEUE WRITE ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_NON_SCRIPT_QUEUE_V0_1_BLOCKED_BEFORE_WRITE"
    exit 2
}

$ReviewSnapshotNonScriptNames = Get-ReviewSnapshotNonScriptNames -Lines $ReviewLines
$ReviewSnapshotNonScriptCount = $ReviewSnapshotNonScriptNames.Count

$CurrentNonScripts = @(Get-ChildItem -LiteralPath $Root -File -Force | Where-Object { $_.Extension -ine ".ps1" } | Sort-Object Name)
$CurrentNonScriptCount = $CurrentNonScripts.Count

$QueueRows = New-Object System.Collections.Generic.List[object]

foreach ($File in $CurrentNonScripts) {
    $SeenInReviewSnapshot = "NO"
    if ($ReviewSnapshotNonScriptNames.Contains($File.Name)) {
        $SeenInReviewSnapshot = "YES"
    }

    $CustodyClass = Get-NonScriptCustodyClass -File $File
    $Decision = Get-NonScriptDecision -CustodyClass $CustodyClass
    $Sha = Get-Sha256 -Path $File.FullName

    $QueueRows.Add([pscustomobject]@{
        Name = $File.Name
        SizeBytes = [int64]$File.Length
        Sha256 = $Sha
        LastWriteTime = $File.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        SeenInReviewSnapshot = $SeenInReviewSnapshot
        CustodyClass = $CustodyClass
        Decision = [string]$Decision.Decision
        ActionNow = [string]$Decision.ActionNow
        Reason = [string]$Decision.Reason
    }) | Out-Null
}

$SeenInReviewCount = @($QueueRows | Where-Object { $_.SeenInReviewSnapshot -eq "YES" }).Count
$PostReviewNonScriptCount = @($QueueRows | Where-Object { $_.SeenInReviewSnapshot -eq "NO" }).Count
$ActionNowCount = @($QueueRows | Where-Object { $_.ActionNow -ne "NO" }).Count
$BadShaRows = @($QueueRows | Where-Object { $_.Sha256 -notmatch '^[A-F0-9]{64}$' })
$DecisionBlankRows = @($QueueRows | Where-Object { [string]::IsNullOrWhiteSpace($_.Decision) })
$DeleteNowRows = @($QueueRows | Where-Object { $_.Decision -match "DELETE_NOW|APPROVED_TO_DELETE" })
$MoveRouteNowRows = @($QueueRows | Where-Object { $_.Decision -match "MOVE_NOW|ROUTE_NOW|APPROVED_TO_ROUTE" })

$CustodyClassGroups = $QueueRows | Group-Object CustodyClass | Sort-Object Name
$DecisionGroups = $QueueRows | Group-Object Decision | Sort-Object Name

if ($CurrentNonScriptCount -lt 1) {
    Add-Blocker "STRESS_FAIL_NO_CURRENT_NON_SCRIPT_FILES_FOUND"
} else {
    $StressResults.Add("PASS current non-script files found") | Out-Null
}

if ($ActionNowCount -ne 0) {
    Add-Blocker "STRESS_FAIL_ACTION_NOW_ROWS: $ActionNowCount"
} else {
    $StressResults.Add("PASS no non-script row authorizes action now") | Out-Null
}

if ($BadShaRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_BAD_SHA_ROWS: $($BadShaRows.Count)"
} else {
    $StressResults.Add("PASS all non-script rows have plain SHA256 values") | Out-Null
}

if ($DecisionBlankRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_BLANK_DECISION_ROWS: $($DecisionBlankRows.Count)"
} else {
    $StressResults.Add("PASS every non-script row has a custody decision") | Out-Null
}

if ($DeleteNowRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_DELETE_NOW_ROWS: $($DeleteNowRows.Count)"
} else {
    $StressResults.Add("PASS no non-script decision authorizes delete") | Out-Null
}

if ($MoveRouteNowRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_MOVE_ROUTE_NOW_ROWS: $($MoveRouteNowRows.Count)"
} else {
    $StressResults.Add("PASS no non-script decision authorizes move or route") | Out-Null
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND DURING NON-SCRIPT QUEUE STRESS BENCH ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_NON_SCRIPT_QUEUE_V0_1_STRESS_BENCH_BLOCKED"
    exit 2
}

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$StressLines = New-Object System.Collections.Generic.List[string]
$StressLines.Add("# ROOT HELD GROUP NON-SCRIPT CUSTODY REVIEW QUEUE V0_1 STRESS BENCH 20260608") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("Status: NON_SCRIPT_CUSTODY_QUEUE_STRESS_BENCH / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH") | Out-Null
$StressLines.Add("Created: $Now") | Out-Null
$StressLines.Add("Active object: $ActiveObject") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("## Stress results") | Out-Null
$StressLines.Add("") | Out-Null
foreach ($Result in $StressResults) { $StressLines.Add("- $Result") | Out-Null }
$StressLines.Add("") | Out-Null
$StressLines.Add("## Counts") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("- review_snapshot_non_script_count: $ReviewSnapshotNonScriptCount") | Out-Null
$StressLines.Add("- current_root_non_script_count: $CurrentNonScriptCount") | Out-Null
$StressLines.Add("- non_scripts_seen_in_review_snapshot_count: $SeenInReviewCount") | Out-Null
$StressLines.Add("- post_review_non_script_count: $PostReviewNonScriptCount") | Out-Null
$StressLines.Add("- action_now_row_count: $ActionNowCount") | Out-Null
$StressLines.Add("- bad_sha_row_count: $($BadShaRows.Count)") | Out-Null
$StressLines.Add("- blank_decision_row_count: $($DecisionBlankRows.Count)") | Out-Null
$StressLines.Add("- delete_now_row_count: $($DeleteNowRows.Count)") | Out-Null
$StressLines.Add("- move_route_now_row_count: $($MoveRouteNowRows.Count)") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("final_verdict: ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_QUEUE_V0_1_STRESS_BENCH_PASS") | Out-Null

$ReportLines = New-Object System.Collections.Generic.List[string]
$ReportLines.Add("# ROOT HELD GROUP NON-SCRIPT CUSTODY REVIEW QUEUE V0_1 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: NON_SCRIPT_CUSTODY_REVIEW_QUEUE / READ_ONLY / STRESS_BENCHED / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Queue summary") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- review_snapshot_non_script_count: $ReviewSnapshotNonScriptCount") | Out-Null
$ReportLines.Add("- current_root_non_script_count: $CurrentNonScriptCount") | Out-Null
$ReportLines.Add("- non_scripts_seen_in_review_snapshot_count: $SeenInReviewCount") | Out-Null
$ReportLines.Add("- post_review_non_script_count: $PostReviewNonScriptCount") | Out-Null
$ReportLines.Add("- action_now_row_count: $ActionNowCount") | Out-Null
$ReportLines.Add("- bad_sha_row_count: $($BadShaRows.Count)") | Out-Null
$ReportLines.Add("- git_head_confirmed: $($GitHead.Trim())") | Out-Null
$ReportLines.Add("- git_status_confirmed: CLEAN") | Out-Null
$ReportLines.Add("- git_commit_or_push_done_by_this_queue_card: NO") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Custody class counts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| CustodyClass | Count |") | Out-Null
$ReportLines.Add("|---|---:|") | Out-Null
foreach ($Group in $CustodyClassGroups) {
    $ReportLines.Add("| $(Escape-Cell $Group.Name) | $($Group.Count) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Decision counts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| Decision | Count |") | Out-Null
$ReportLines.Add("|---|---:|") | Out-Null
foreach ($Group in $DecisionGroups) {
    $ReportLines.Add("| $(Escape-Cell $Group.Name) | $($Group.Count) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Non-script custody queue") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| Name | SizeBytes | SHA256 | LastWriteTime | SeenInReviewSnapshot | CustodyClass | Decision | ActionNow | Reason |") | Out-Null
$ReportLines.Add("|---|---:|---|---|---|---|---|---|---|") | Out-Null
foreach ($Row in $QueueRows) {
    $ReportLines.Add("| $(Escape-Cell $Row.Name) | $($Row.SizeBytes) | $($Row.Sha256) | $($Row.LastWriteTime) | $($Row.SeenInReviewSnapshot) | $(Escape-Cell $Row.CustodyClass) | $(Escape-Cell $Row.Decision) | $($Row.ActionNow) | $(Escape-Cell $Row.Reason) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Stop lines") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- no cleanup") | Out-Null
$ReportLines.Add("- no delete") | Out-Null
$ReportLines.Add("- no rename") | Out-Null
$ReportLines.Add("- no move") | Out-Null
$ReportLines.Add("- no routing yet") | Out-Null
$ReportLines.Add("- no helper execution") | Out-Null
$ReportLines.Add("- no root script execution") | Out-Null
$ReportLines.Add("- no source replay") | Out-Null
$ReportLines.Add("- no source rewrite") | Out-Null
$ReportLines.Add("- no doctrine promotion") | Out-Null
$ReportLines.Add("- no commit or push from this queue card") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next selected action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("next_build_chunk_selected: $NextBuildChunk") | Out-Null
$ReportLines.Add("after_import_next_build_chunk_selected: $AfterImportNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## DoesNotProve") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This queue proves only that non-script root files were listed and classified for custody review. It does not prove any file is safe to move, delete, route, rewrite, commit, push, or promote.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

$StressLines | Set-Content -LiteralPath $StressPath -Encoding UTF8
$StressSha = Get-Sha256 -Path $StressPath

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "stress_bench_path: $StressPath",
    "stress_bench_sha256: $StressSha",
    "parent_script_queue_report_path: $ScriptQueueReportPath",
    "parent_script_queue_report_sha256: $ScriptQueueReportSha",
    "parent_script_queue_rough_local_sha256: $ScriptQueueRoughLedgerSha",
    "git_top: $GitTop",
    "git_head_confirmed: $($GitHead.Trim())",
    "git_status_confirmed: CLEAN",
    "review_snapshot_non_script_count: $ReviewSnapshotNonScriptCount",
    "current_root_non_script_count: $CurrentNonScriptCount",
    "non_scripts_seen_in_review_snapshot_count: $SeenInReviewCount",
    "post_review_non_script_count: $PostReviewNonScriptCount",
    "action_now_row_count: $ActionNowCount",
    "bad_sha_row_count: $($BadShaRows.Count)",
    "blank_decision_row_count: $($DecisionBlankRows.Count)",
    "delete_now_row_count: $($DeleteNowRows.Count)",
    "move_route_now_row_count: $($MoveRouteNowRows.Count)",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "git_commit_or_push_done: NO",
    "next_build_chunk_selected: $NextBuildChunk",
    "after_import_next_build_chunk_selected: $AfterImportNextBuildChunk",
    "does_not_prove: file safe to move; file safe to delete; file safe to route; source safe to rewrite; doctrine safe to promote; push approved",
    "final_verdict: $FinalVerdict"
)

$ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptSha = Get-Sha256 -Path $ReceiptPath

Write-Host "=== ROOT HELD GROUP NON-SCRIPT CUSTODY REVIEW QUEUE V0_1 COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "stress_bench_path: $StressPath"
Write-Host "stress_bench_sha256: $StressSha"
Write-Host "review_snapshot_non_script_count: $ReviewSnapshotNonScriptCount"
Write-Host "current_root_non_script_count: $CurrentNonScriptCount"
Write-Host "non_scripts_seen_in_review_snapshot_count: $SeenInReviewCount"
Write-Host "post_review_non_script_count: $PostReviewNonScriptCount"
Write-Host "action_now_row_count: $ActionNowCount"
Write-Host "bad_sha_row_count: $($BadShaRows.Count)"
Write-Host "blank_decision_row_count: $($DecisionBlankRows.Count)"
Write-Host "delete_now_row_count: $($DeleteNowRows.Count)"
Write-Host "move_route_now_row_count: $($MoveRouteNowRows.Count)"
Write-Host "git_head_confirmed: $($GitHead.Trim())"
Write-Host "git_status_confirmed: CLEAN"
Write-Host "git_commit_or_push_done: NO"
Write-Host "files_moved_count: 0"
Write-Host "files_deleted_count: 0"
Write-Host "files_renamed_count: 0"
Write-Host "files_routed_count: 0"
Write-Host "files_executed_count: 0"
Write-Host "next_build_chunk_selected: $NextBuildChunk"
Write-Host "after_import_next_build_chunk_selected: $AfterImportNextBuildChunk"
Write-Host "final_verdict: $FinalVerdict"

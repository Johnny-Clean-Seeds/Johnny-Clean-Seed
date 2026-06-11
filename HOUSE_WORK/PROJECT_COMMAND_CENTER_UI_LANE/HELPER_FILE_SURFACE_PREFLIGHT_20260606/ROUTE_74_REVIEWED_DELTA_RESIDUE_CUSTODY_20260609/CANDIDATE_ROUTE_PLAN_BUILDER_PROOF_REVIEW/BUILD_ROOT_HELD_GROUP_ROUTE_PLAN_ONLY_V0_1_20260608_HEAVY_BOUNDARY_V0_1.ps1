Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ActiveObject = "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608"
$FinalVerdict = "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_READY_WITH_STRESS_BENCH_PASS"
$NextBuildChunk = "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_ROUGH_LOCAL_IMPORT_20260608"
$AfterImportNextBuildChunk = "USER_APPROVED_ROOT_HELD_GROUP_ROUTE_DRY_RUN_SELECTOR_20260608"

$Root = "$env:USERPROFILE\Desktop\123"
$LaneDir = Join-Path $Root "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
$GitTop = Join-Path $Root "Jxhnny_Kl33N_Seedz"

$ExpectedGitHead = "a713660d17f481cbb59a4309d4fae5d6a03c84ef"

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

$NonScriptQueueReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$NonScriptQueueReportSha = "561F28FABEDC9F75620B7BE44E35DB8E678C7BE116F8BF390EBB4712953676B9"

$NonScriptQueueReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$NonScriptQueueReceiptSha = "25D3B81B6BE7574EF0CB3479C4C82869749D5F9611AD19FB58D21EF3467B8BE4"

$NonScriptQueueStressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_STRESS_BENCH_20260608.md"
$NonScriptQueueStressSha = "418E9A80E21A172CF51F1516ACB91A9E32BC21F5DAD44550DB718047FD1F9A2D"

$NonScriptQueueRoughLedgerPath = Join-Path $LaneDir "ROUGH_LOCAL__ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_20260608.md"
$NonScriptQueueRoughLedgerSha = "9F1F7FCE144848D3A5619C23D4685DC77AC03EC95630264D56B0B2206E332D70"

$NonScriptQueueRoughReceiptPath = Join-Path $LaneDir "ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_RECEIPT_20260608.txt"
$NonScriptQueueRoughReceiptSha = "2B0621AAE1B2A9B9846251C14A7C915D49CF66373CF88DAADCCE1F2945E468C9"

$NonScriptQueueGitImportPacketPath = Join-Path $GitTop "HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROUGH_LOCAL_GIT_IMPORT_20260608\ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1\ROUGH_LOCAL_ROOT_HELD_GROUP_NON_SCRIPT_CUSTODY_REVIEW_QUEUE_V0_1_GIT_IMPORT_PACKET_RECEIPT_20260608.md"
$NonScriptQueueGitImportPacketSha = "1CE8471CA8EBE19C9D69B1566903855D8937ACB82DA0339B8DF1C517CCA03061"

$ReportPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md"
$ReceiptPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_RECEIPT_20260608.txt"
$StressPath = Join-Path $LaneDir "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_STRESS_BENCH_20260608.md"

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

function Get-MarkdownTableRows {
    param(
        [AllowNull()][AllowEmptyCollection()][AllowEmptyString()][string[]]$Lines,
        [Parameter(Mandatory=$true)][string]$SectionName,
        [Parameter(Mandatory=$true)][string]$QueueType
    )

    $Rows = New-Object System.Collections.Generic.List[object]
    $InSection = $false

    if ($null -eq $Lines) { return $Rows }

    foreach ($LineRaw in $Lines) {
        $Line = [string]$LineRaw

        if ($Line -eq $SectionName) {
            $InSection = $true
            continue
        }

        if ($InSection -and $Line -match '^## ' -and $Line -ne $SectionName) {
            break
        }

        if (-not $InSection) { continue }
        if ($Line -notmatch '^\|') { continue }
        if ($Line -match '^\|---') { continue }
        if ($Line -match '^\| Name \|') { continue }

        $Parts = $Line -split '\|'

        if ($QueueType -eq "SCRIPT") {
            if ($Parts.Count -lt 11) { continue }
            $Rows.Add([pscustomobject]@{
                QueueType = "SCRIPT"
                Name = $Parts[1].Trim()
                SizeBytes = $Parts[2].Trim()
                Sha256 = $Parts[3].Trim()
                LastWriteTime = $Parts[4].Trim()
                SeenInReviewSnapshot = $Parts[5].Trim()
                IsCurrentRunner = $Parts[6].Trim()
                CustodyClass = $Parts[7].Trim()
                SourceDecision = $Parts[8].Trim()
                ActionNow = $Parts[9].Trim()
                SourceReason = $Parts[10].Trim()
            }) | Out-Null
        }

        if ($QueueType -eq "NON_SCRIPT") {
            if ($Parts.Count -lt 10) { continue }
            $Rows.Add([pscustomobject]@{
                QueueType = "NON_SCRIPT"
                Name = $Parts[1].Trim()
                SizeBytes = $Parts[2].Trim()
                Sha256 = $Parts[3].Trim()
                LastWriteTime = $Parts[4].Trim()
                SeenInReviewSnapshot = $Parts[5].Trim()
                IsCurrentRunner = "NO"
                CustodyClass = $Parts[6].Trim()
                SourceDecision = $Parts[7].Trim()
                ActionNow = $Parts[8].Trim()
                SourceReason = $Parts[9].Trim()
            }) | Out-Null
        }
    }

    return $Rows
}

function Get-ProposedBucket {
    param(
        [Parameter(Mandatory=$true)][string]$QueueType,
        [Parameter(Mandatory=$true)][string]$CustodyClass,
        [Parameter(Mandatory=$true)][string]$IsCurrentRunner
    )

    if ($QueueType -eq "SCRIPT") {
        if ($IsCurrentRunner -eq "YES") { return "HOLD_IN_ROOT_CURRENT_RUNNER_NO_ROUTE" }
        if ($CustodyClass -eq "BUILD_RUNNER_SCRIPT") { return "_OLD_LOADS/SCRIPT_RUNNERS/BUILD" }
        if ($CustodyClass -eq "ROUGH_LOCAL_IMPORT_RUNNER_SCRIPT") { return "_OLD_LOADS/SCRIPT_RUNNERS/ROUGH_LOCAL_IMPORT" }
        if ($CustodyClass -eq "WRITE_OR_GENERATOR_SCRIPT") { return "_OLD_LOADS/SCRIPT_RUNNERS/WRITE_OR_GENERATOR" }
        if ($CustodyClass -eq "RUNNER_SCRIPT") { return "_OLD_LOADS/SCRIPT_RUNNERS/RUNNER" }
        return "_OLD_LOADS/SCRIPT_RUNNERS/OTHER"
    }

    if ($CustodyClass -eq "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE") { return "LEAVE_IN_PLACE" }
    if ($CustodyClass -eq "ZERO_BYTE_REVIEW_ONLY_NO_DELETE") { return "HOLD_ZERO_BYTE_REVIEW_NO_DELETE" }
    if ($CustodyClass -eq "ROOT_MARKDOWN_DOCUMENT") { return "DOCUMENT_CUSTODY_REVIEW/MARKDOWN" }
    if ($CustodyClass -eq "ROOT_TEXT_OR_RECEIPT_DOCUMENT") { return "DOCUMENT_CUSTODY_REVIEW/TEXT_OR_RECEIPT" }

    return "NON_SCRIPT_CUSTODY_REVIEW/OTHER"
}

function Get-FutureActionOnly {
    param(
        [Parameter(Mandatory=$true)][string]$QueueType,
        [Parameter(Mandatory=$true)][string]$CustodyClass,
        [Parameter(Mandatory=$true)][string]$IsCurrentRunner
    )

    if ($IsCurrentRunner -eq "YES") { return "NO_ROUTE_HOLD_CURRENT_RUNNER" }
    if ($CustodyClass -eq "WINDOWS_SYSTEM_METADATA_LEAVE_IN_PLACE") { return "LEAVE_IN_PLACE" }

    return "FUTURE_ROUTE_AFTER_USER_APPROVAL_AND_DRY_RUN_ONLY"
}

$Blockers = New-Object System.Collections.Generic.List[string]
$StressResults = New-Object System.Collections.Generic.List[string]
$VerifiedLines = New-Object System.Collections.Generic.List[string]

Write-Host "=== ROOT HELD GROUP ROUTE PLAN ONLY V0_1 ==="

if (Test-Path -LiteralPath $PSCommandPath -PathType Leaf) {
    $SelfText = Get-Content -LiteralPath $PSCommandPath -Raw
    if ($SelfText -match '\[Parameter\(Mandatory=\$true\)\]\[string\[\]\]\$Lines') {
        Add-Blocker "FORBIDDEN_MARKDOWN_LINE_PARAM_SIGNATURE"
    }
}

$RequiredFiles = [ordered]@{
    ScriptQueueReport = [ordered]@{ Path = $ScriptQueueReportPath; Sha256 = $ScriptQueueReportSha }
    ScriptQueueReceipt = [ordered]@{ Path = $ScriptQueueReceiptPath; Sha256 = $ScriptQueueReceiptSha }
    ScriptQueueStress = [ordered]@{ Path = $ScriptQueueStressPath; Sha256 = $ScriptQueueStressSha }
    ScriptQueueRoughLedger = [ordered]@{ Path = $ScriptQueueRoughLedgerPath; Sha256 = $ScriptQueueRoughLedgerSha }
    ScriptQueueRoughReceipt = [ordered]@{ Path = $ScriptQueueRoughReceiptPath; Sha256 = $ScriptQueueRoughReceiptSha }
    ScriptQueueGitImportPacket = [ordered]@{ Path = $ScriptQueueGitImportPacketPath; Sha256 = $ScriptQueueGitImportPacketSha }
    NonScriptQueueReport = [ordered]@{ Path = $NonScriptQueueReportPath; Sha256 = $NonScriptQueueReportSha }
    NonScriptQueueReceipt = [ordered]@{ Path = $NonScriptQueueReceiptPath; Sha256 = $NonScriptQueueReceiptSha }
    NonScriptQueueStress = [ordered]@{ Path = $NonScriptQueueStressPath; Sha256 = $NonScriptQueueStressSha }
    NonScriptQueueRoughLedger = [ordered]@{ Path = $NonScriptQueueRoughLedgerPath; Sha256 = $NonScriptQueueRoughLedgerSha }
    NonScriptQueueRoughReceipt = [ordered]@{ Path = $NonScriptQueueRoughReceiptPath; Sha256 = $NonScriptQueueRoughReceiptSha }
    NonScriptQueueGitImportPacket = [ordered]@{ Path = $NonScriptQueueGitImportPacketPath; Sha256 = $NonScriptQueueGitImportPacketSha }
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
    Write-Host "=== BLOCKERS FOUND BEFORE ROUTE PLAN WRITE ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_BLOCKED_BEFORE_WRITE"
    exit 2
}

$ScriptQueueLines = @(Get-Content -LiteralPath $ScriptQueueReportPath | ForEach-Object { [string]$_ })
$NonScriptQueueLines = @(Get-Content -LiteralPath $NonScriptQueueReportPath | ForEach-Object { [string]$_ })

$ScriptRows = @(Get-MarkdownTableRows -Lines $ScriptQueueLines -SectionName "## Script custody queue" -QueueType "SCRIPT")
$NonScriptRows = @(Get-MarkdownTableRows -Lines $NonScriptQueueLines -SectionName "## Non-script custody queue" -QueueType "NON_SCRIPT")

$PlanRows = New-Object System.Collections.Generic.List[object]

foreach ($Row in @($ScriptRows + $NonScriptRows)) {
    $Bucket = Get-ProposedBucket -QueueType $Row.QueueType -CustodyClass $Row.CustodyClass -IsCurrentRunner $Row.IsCurrentRunner
    $FutureAction = Get-FutureActionOnly -QueueType $Row.QueueType -CustodyClass $Row.CustodyClass -IsCurrentRunner $Row.IsCurrentRunner

    $PlanRows.Add([pscustomobject]@{
        QueueType = $Row.QueueType
        Name = $Row.Name
        Sha256 = $Row.Sha256
        SizeBytes = $Row.SizeBytes
        SeenInReviewSnapshot = $Row.SeenInReviewSnapshot
        IsCurrentRunner = $Row.IsCurrentRunner
        CustodyClass = $Row.CustodyClass
        SourceDecision = $Row.SourceDecision
        ProposedBucket = $Bucket
        FutureActionOnly = $FutureAction
        ActionNow = "NO"
        RequiresDryRun = $(if ($FutureAction -like "FUTURE_ROUTE*") { "YES" } else { "NO" })
        RequiresUserApproval = "YES"
        Reason = "Plan-only row from locked custody queue. No physical file action is authorized by this card."
    }) | Out-Null
}

$ScriptPlanCount = @($PlanRows | Where-Object { $_.QueueType -eq "SCRIPT" }).Count
$NonScriptPlanCount = @($PlanRows | Where-Object { $_.QueueType -eq "NON_SCRIPT" }).Count
$TotalPlanCount = $PlanRows.Count
$ActionNowCount = @($PlanRows | Where-Object { $_.ActionNow -ne "NO" }).Count
$BadShaRows = @($PlanRows | Where-Object { $_.Sha256 -notmatch '^[A-F0-9]{64}$' })
$BlankBucketRows = @($PlanRows | Where-Object { [string]::IsNullOrWhiteSpace($_.ProposedBucket) })
$DeleteNowRows = @($PlanRows | Where-Object { $_.FutureActionOnly -match "DELETE_NOW|APPROVED_TO_DELETE" })
$MoveRouteNowRows = @($PlanRows | Where-Object { $_.FutureActionOnly -match "MOVE_NOW|ROUTE_NOW|APPROVED_TO_ROUTE" })
$CurrentRunnerRows = @($PlanRows | Where-Object { $_.IsCurrentRunner -eq "YES" })
$LeaveInPlaceRows = @($PlanRows | Where-Object { $_.ProposedBucket -eq "LEAVE_IN_PLACE" })
$DryRunRows = @($PlanRows | Where-Object { $_.RequiresDryRun -eq "YES" })

$BucketGroups = $PlanRows | Group-Object ProposedBucket | Sort-Object Name
$FutureActionGroups = $PlanRows | Group-Object FutureActionOnly | Sort-Object Name

if ($ScriptPlanCount -ne 53) {
    Add-Blocker "STRESS_FAIL_SCRIPT_PLAN_ROW_COUNT: expected 53 :: got $ScriptPlanCount"
} else {
    $StressResults.Add("PASS script_plan_row_count_is_53") | Out-Null
}

if ($NonScriptPlanCount -ne 5) {
    Add-Blocker "STRESS_FAIL_NON_SCRIPT_PLAN_ROW_COUNT: expected 5 :: got $NonScriptPlanCount"
} else {
    $StressResults.Add("PASS non_script_plan_row_count_is_5") | Out-Null
}

if ($TotalPlanCount -ne 58) {
    Add-Blocker "STRESS_FAIL_TOTAL_PLAN_ROW_COUNT: expected 58 :: got $TotalPlanCount"
} else {
    $StressResults.Add("PASS total_plan_row_count_is_58") | Out-Null
}

if ($ActionNowCount -ne 0) {
    Add-Blocker "STRESS_FAIL_ACTION_NOW_ROWS: $ActionNowCount"
} else {
    $StressResults.Add("PASS no route plan row authorizes action now") | Out-Null
}

if ($BadShaRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_BAD_SHA_ROWS: $($BadShaRows.Count)"
} else {
    $StressResults.Add("PASS all route plan rows have plain SHA256 values") | Out-Null
}

if ($BlankBucketRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_BLANK_BUCKET_ROWS: $($BlankBucketRows.Count)"
} else {
    $StressResults.Add("PASS every route plan row has a proposed bucket") | Out-Null
}

if ($DeleteNowRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_DELETE_NOW_ROWS: $($DeleteNowRows.Count)"
} else {
    $StressResults.Add("PASS no route plan row authorizes delete now") | Out-Null
}

if ($MoveRouteNowRows.Count -ne 0) {
    Add-Blocker "STRESS_FAIL_MOVE_ROUTE_NOW_ROWS: $($MoveRouteNowRows.Count)"
} else {
    $StressResults.Add("PASS no route plan row authorizes move or route now") | Out-Null
}

if ($CurrentRunnerRows.Count -ne 1) {
    Add-Blocker "STRESS_FAIL_CURRENT_RUNNER_ROUTE_PLAN_ROWS: expected 1 :: got $($CurrentRunnerRows.Count)"
} else {
    $StressResults.Add("PASS exactly one current runner is held no-route") | Out-Null
}

if ($Blockers.Count -gt 0) {
    Write-Host "=== BLOCKERS FOUND DURING ROUTE PLAN STRESS BENCH ==="
    foreach ($Blocker in $Blockers) { Write-Host $Blocker }
    Write-Host "final_verdict: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_STRESS_BENCH_BLOCKED"
    exit 2
}

$Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$StressLines = New-Object System.Collections.Generic.List[string]
$StressLines.Add("# ROOT HELD GROUP ROUTE PLAN ONLY V0_1 STRESS BENCH 20260608") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("Status: ROUTE_PLAN_ONLY_STRESS_BENCH / READ_ONLY / NO_MOVE_NO_DELETE_NO_COMMIT_NO_PUSH") | Out-Null
$StressLines.Add("Created: $Now") | Out-Null
$StressLines.Add("Active object: $ActiveObject") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("## Stress results") | Out-Null
$StressLines.Add("") | Out-Null
foreach ($Result in $StressResults) { $StressLines.Add("- $Result") | Out-Null }
$StressLines.Add("") | Out-Null
$StressLines.Add("## Counts") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("- script_plan_row_count: $ScriptPlanCount") | Out-Null
$StressLines.Add("- non_script_plan_row_count: $NonScriptPlanCount") | Out-Null
$StressLines.Add("- total_plan_row_count: $TotalPlanCount") | Out-Null
$StressLines.Add("- action_now_row_count: $ActionNowCount") | Out-Null
$StressLines.Add("- bad_sha_row_count: $($BadShaRows.Count)") | Out-Null
$StressLines.Add("- blank_bucket_row_count: $($BlankBucketRows.Count)") | Out-Null
$StressLines.Add("- delete_now_row_count: $($DeleteNowRows.Count)") | Out-Null
$StressLines.Add("- move_route_now_row_count: $($MoveRouteNowRows.Count)") | Out-Null
$StressLines.Add("- current_runner_route_plan_row_count: $($CurrentRunnerRows.Count)") | Out-Null
$StressLines.Add("- leave_in_place_row_count: $($LeaveInPlaceRows.Count)") | Out-Null
$StressLines.Add("- dry_run_required_row_count: $($DryRunRows.Count)") | Out-Null
$StressLines.Add("") | Out-Null
$StressLines.Add("final_verdict: ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_STRESS_BENCH_PASS") | Out-Null

$ReportLines = New-Object System.Collections.Generic.List[string]
$ReportLines.Add("# ROOT HELD GROUP ROUTE PLAN ONLY V0_1 20260608") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Status: ROUTE_PLAN_ONLY / READ_ONLY / STRESS_BENCHED / NOT_CLEANUP_ORDER / NOT_ROUTE_ORDER / NOT_DOCTRINE") | Out-Null
$ReportLines.Add("Created: $Now") | Out-Null
$ReportLines.Add("Active object: $ActiveObject") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Purpose") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Build a route plan only from the locked script and non-script custody queues. This card does not move, delete, rename, route, execute, rewrite, commit, push, clean up, or promote anything.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Verified load-bearing evidence") | Out-Null
$ReportLines.Add("") | Out-Null
foreach ($Line in $VerifiedLines) { $ReportLines.Add("- $Line") | Out-Null }
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Scope") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- route_plan_scope: LOCKED_CUSTODY_QUEUES_ONLY") | Out-Null
$ReportLines.Add("- live_root_delta_check_required_before_any_future_route: YES") | Out-Null
$ReportLines.Add("- git_head_confirmed: $($GitHead.Trim())") | Out-Null
$ReportLines.Add("- git_status_confirmed: CLEAN") | Out-Null
$ReportLines.Add("- git_commit_or_push_done_by_this_plan_card: NO") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Route plan summary") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- script_plan_row_count: $ScriptPlanCount") | Out-Null
$ReportLines.Add("- non_script_plan_row_count: $NonScriptPlanCount") | Out-Null
$ReportLines.Add("- total_plan_row_count: $TotalPlanCount") | Out-Null
$ReportLines.Add("- action_now_row_count: $ActionNowCount") | Out-Null
$ReportLines.Add("- bad_sha_row_count: $($BadShaRows.Count)") | Out-Null
$ReportLines.Add("- blank_bucket_row_count: $($BlankBucketRows.Count)") | Out-Null
$ReportLines.Add("- delete_now_row_count: $($DeleteNowRows.Count)") | Out-Null
$ReportLines.Add("- move_route_now_row_count: $($MoveRouteNowRows.Count)") | Out-Null
$ReportLines.Add("- current_runner_route_plan_row_count: $($CurrentRunnerRows.Count)") | Out-Null
$ReportLines.Add("- leave_in_place_row_count: $($LeaveInPlaceRows.Count)") | Out-Null
$ReportLines.Add("- dry_run_required_row_count: $($DryRunRows.Count)") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Proposed bucket counts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| ProposedBucket | Count |") | Out-Null
$ReportLines.Add("|---|---:|") | Out-Null
foreach ($Group in $BucketGroups) {
    $ReportLines.Add("| $(Escape-Cell $Group.Name) | $($Group.Count) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Future action counts") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| FutureActionOnly | Count |") | Out-Null
$ReportLines.Add("|---|---:|") | Out-Null
foreach ($Group in $FutureActionGroups) {
    $ReportLines.Add("| $(Escape-Cell $Group.Name) | $($Group.Count) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Route plan table") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("| QueueType | Name | SHA256 | SizeBytes | SeenInReviewSnapshot | IsCurrentRunner | CustodyClass | SourceDecision | ProposedBucket | FutureActionOnly | ActionNow | RequiresDryRun | RequiresUserApproval | Reason |") | Out-Null
$ReportLines.Add("|---|---|---|---:|---|---|---|---|---|---|---|---|---|---|") | Out-Null
foreach ($Row in $PlanRows) {
    $ReportLines.Add("| $($Row.QueueType) | $(Escape-Cell $Row.Name) | $($Row.Sha256) | $($Row.SizeBytes) | $($Row.SeenInReviewSnapshot) | $($Row.IsCurrentRunner) | $(Escape-Cell $Row.CustodyClass) | $(Escape-Cell $Row.SourceDecision) | $(Escape-Cell $Row.ProposedBucket) | $(Escape-Cell $Row.FutureActionOnly) | $($Row.ActionNow) | $($Row.RequiresDryRun) | $($Row.RequiresUserApproval) | $(Escape-Cell $Row.Reason) |") | Out-Null
}
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Required future gate before any physical routing") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Before any future route executor exists, build a dry-run selector that rechecks live root files, detects new scripts/files since these custody queues, proves exact source and destination paths, proves no source-authority rewrite, and requires explicit user approval.") | Out-Null
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
$ReportLines.Add("- no commit or push from this plan card") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next selected action") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("next_build_chunk_selected: $NextBuildChunk") | Out-Null
$ReportLines.Add("after_import_next_build_chunk_selected: $AfterImportNextBuildChunk") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## DoesNotProve") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("This route plan proves only that a plan was generated from locked custody queues. It does not prove live root has no new files, and it does not approve file movement, deletion, routing, execution, cleanup, source rewrite, doctrine promotion, commit, or push.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("final_verdict: $FinalVerdict") | Out-Null

$StressLines | Set-Content -LiteralPath $StressPath -Encoding UTF8
$StressSha = Get-Sha256 -Path $StressPath

$ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
$ReportSha = Get-Sha256 -Path $ReportPath

$ReceiptLines = @(
    "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_RECEIPT_20260608",
    "created: $Now",
    "active_object: $ActiveObject",
    "report_path: $ReportPath",
    "report_sha256: $ReportSha",
    "stress_bench_path: $StressPath",
    "stress_bench_sha256: $StressSha",
    "parent_script_queue_rough_local_sha256: $ScriptQueueRoughLedgerSha",
    "parent_non_script_queue_rough_local_sha256: $NonScriptQueueRoughLedgerSha",
    "git_top: $GitTop",
    "git_head_confirmed: $($GitHead.Trim())",
    "git_status_confirmed: CLEAN",
    "route_plan_scope: LOCKED_CUSTODY_QUEUES_ONLY",
    "live_root_delta_check_required_before_any_future_route: YES",
    "script_plan_row_count: $ScriptPlanCount",
    "non_script_plan_row_count: $NonScriptPlanCount",
    "total_plan_row_count: $TotalPlanCount",
    "action_now_row_count: $ActionNowCount",
    "bad_sha_row_count: $($BadShaRows.Count)",
    "blank_bucket_row_count: $($BlankBucketRows.Count)",
    "delete_now_row_count: $($DeleteNowRows.Count)",
    "move_route_now_row_count: $($MoveRouteNowRows.Count)",
    "current_runner_route_plan_row_count: $($CurrentRunnerRows.Count)",
    "leave_in_place_row_count: $($LeaveInPlaceRows.Count)",
    "dry_run_required_row_count: $($DryRunRows.Count)",
    "files_moved_count: 0",
    "files_deleted_count: 0",
    "files_renamed_count: 0",
    "files_routed_count: 0",
    "files_executed_count: 0",
    "git_commit_or_push_done: NO",
    "next_build_chunk_selected: $NextBuildChunk",
    "after_import_next_build_chunk_selected: $AfterImportNextBuildChunk",
    "does_not_prove: live root has no new files; file safe to move; file safe to delete; file safe to route; source safe to rewrite; doctrine safe to promote; push approved",
    "final_verdict: $FinalVerdict"
)

$ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
$ReceiptSha = Get-Sha256 -Path $ReceiptPath

Write-Host "=== ROOT HELD GROUP ROUTE PLAN ONLY V0_1 COMPLETE ==="
Write-Host "output_report_path: $ReportPath"
Write-Host "output_report_sha256: $ReportSha"
Write-Host "receipt_path: $ReceiptPath"
Write-Host "receipt_sha256: $ReceiptSha"
Write-Host "stress_bench_path: $StressPath"
Write-Host "stress_bench_sha256: $StressSha"
Write-Host "route_plan_scope: LOCKED_CUSTODY_QUEUES_ONLY"
Write-Host "live_root_delta_check_required_before_any_future_route: YES"
Write-Host "script_plan_row_count: $ScriptPlanCount"
Write-Host "non_script_plan_row_count: $NonScriptPlanCount"
Write-Host "total_plan_row_count: $TotalPlanCount"
Write-Host "action_now_row_count: $ActionNowCount"
Write-Host "bad_sha_row_count: $($BadShaRows.Count)"
Write-Host "blank_bucket_row_count: $($BlankBucketRows.Count)"
Write-Host "delete_now_row_count: $($DeleteNowRows.Count)"
Write-Host "move_route_now_row_count: $($MoveRouteNowRows.Count)"
Write-Host "current_runner_route_plan_row_count: $($CurrentRunnerRows.Count)"
Write-Host "leave_in_place_row_count: $($LeaveInPlaceRows.Count)"
Write-Host "dry_run_required_row_count: $($DryRunRows.Count)"
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

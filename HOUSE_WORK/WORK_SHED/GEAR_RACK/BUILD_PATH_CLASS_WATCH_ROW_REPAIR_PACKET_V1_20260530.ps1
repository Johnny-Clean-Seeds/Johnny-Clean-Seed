# BUILD_PATH_CLASS_WATCH_ROW_REPAIR_PACKET_V1_20260530.ps1
# Read-only path-class review for Intake Gate and Root-Layer parked watch rows.
# Boundary: reads audit CSVs and writes local read reports only. No repo writes, no commit, no push, no delete, no move.

[CmdletBinding()]
param(
    [int]$MaxTickets = 50,
    [string]$IntakeRecordsCsv,
    [string]$IntakeFindingsCsv,
    [string]$RootRecordsCsv,
    [string]$RootFindingsCsv
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Add-Line {
    param(
        [Parameter(Mandatory=$true, Position=0)][object]$Lines,
        [Parameter(Position=1)][AllowEmptyString()][string]$Text = ""
    )
    $Lines.Add($Text) | Out-Null
}

function Resolve-HouseRoot {
    $Candidate = Join-Path $env:USERPROFILE "Desktop\123"
    $Items = @(Get-Item -LiteralPath $Candidate -ErrorAction SilentlyContinue)
    if ($Items.Count -gt 0) { return (Resolve-Path -LiteralPath $Candidate).Path }
    throw "Missing house root: $Candidate"
}

function Resolve-RepoRoot {
    param([Parameter(Mandatory=$true)][string]$HouseRoot)
    $Candidates = @((Join-Path $HouseRoot "Jxhnny_Kl33N_Seedz"), (Get-Location).Path)
    foreach ($Candidate in $Candidates) {
        if ([string]::IsNullOrWhiteSpace($Candidate)) { continue }
        $GitItems = @(Get-Item -LiteralPath (Join-Path $Candidate ".git") -Force -ErrorAction SilentlyContinue)
        if ($GitItems.Count -gt 0) { return (Resolve-Path -LiteralPath $Candidate).Path }
    }
    throw "Missing repo root."
}

function Resolve-LatestReport {
    param(
        [Parameter(Mandatory=$true)][string]$ReportRoot,
        [Parameter(Mandatory=$true)][string]$Pattern
    )
    $Matches = @(Get-ChildItem -LiteralPath $ReportRoot -File -Filter $Pattern -ErrorAction Stop | Sort-Object LastWriteTime -Descending)
    if ($Matches.Count -eq 0) { throw "Missing report matching $Pattern in $ReportRoot" }
    return $Matches[0].FullName
}

function Convert-ToRepoPath {
    param(
        [Parameter(Mandatory=$true)][string]$RepoRoot,
        [Parameter(Mandatory=$true)][string]$RelativePath
    )
    return Join-Path $RepoRoot ($RelativePath -replace '/', [System.IO.Path]::DirectorySeparatorChar)
}

function Read-TextSafe {
    param([Parameter(Mandatory=$true)][string]$Path)
    try { return [System.IO.File]::ReadAllText($Path) } catch { return "" }
}

function Has-Any {
    param(
        [Parameter(Mandatory=$true)][AllowEmptyString()][string]$Text,
        [Parameter(Mandatory=$true)][string[]]$Patterns
    )
    foreach ($Pattern in $Patterns) {
        if ($Text -match $Pattern) { return $true }
    }
    return $false
}

function Test-SafeRepoRelativePath {
    param([Parameter(Mandatory=$true)][AllowEmptyString()][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    if ($Path -match "^[A-Za-z]:\\") { return $false }
    if ($Path.StartsWith("/") -or $Path.StartsWith("\")) { return $false }
    if ($Path -match "(^|/|\\)\.\.($|/|\\)") { return $false }
    return $true
}

function Get-PathClass {
    param([Parameter(Mandatory=$true)][string]$Path)
    $Upper = $Path.ToUpperInvariant()

    if ($Upper -like "BRAIN/LEARNING/*" -or $Upper -like "BRAIN/SUIT/*") { return "needs human review" }
    if ($Upper -like "SOURCE_ORE/*" -or $Upper -like "RULE_INTAKE/*" -or $Upper -like "LEARNING_ROOT/*") { return "stale/proof-only" }
    if ($Upper -like "HOUSE_WORK/INTAKE/*/SOURCE/*" -or $Upper -like "HOUSE_WORK/INTAKE/*/HANDOFFS/*") { return "stale/proof-only" }
    if ($Upper -match "(^|/)PROOF_HISTORY/" -or $Upper -match "RECEIPT" -or $Upper -match "BACKUP|ARCHIVE|CUSTODY|SOURCE_COPY|SOURCE_TRANSFER|YT_TRANSCRIPTS|TOOL_PACKS|TEST_LANES|MULE_WORKSHOP|_MERGE_AUDIT") { return "stale/proof-only" }
    if ($Upper -like "CLEANSEEDSBUILD/*" -or $Upper -like "GPT_PROMPTS_CUSTODY/*") { return "stale/proof-only" }
    if ($Upper -like "COMMAND_CENTER/RECEIPTS/*") { return "stale/proof-only" }
    if ($Upper -match "\.PS1$" -or $Upper -match "(^|/)GEAR_RACK/" -or $Upper -match "HELPER|RUNNER|SCRIPT|TOOL") { return "helper/tool issue" }
    if ($Upper -match "ROUTE|PATH|INDEX|MAP|TODO") { return "route/path issue" }
    if ($Upper -match "INTAKE|HASH|KEY|PROTOCOL|LIVING_OBJECT|ORGANIC_PATHING|TRUE_PATHING|REPAIR_WAVE") { return "key/hash/intake issue" }
    return "needs human review"
}

function Get-ReviewDisposition {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$PathClass,
        [Parameter(Mandatory=$true)][string]$SourceKind,
        [Parameter(Mandatory=$true)][string]$FieldOrClass,
        [Parameter(Mandatory=$true)][string]$FullPath,
        [Parameter(Mandatory=$true)][AllowEmptyString()][string]$Content
    )

    if (!(Test-SafeRepoRelativePath -Path $Path)) { return "rejected rows" }
    if (!(Test-Path -LiteralPath $FullPath)) { return "stale/proof-only" }

    $Extension = [System.IO.Path]::GetExtension($FullPath).ToLowerInvariant()
    if ($Extension -notin @(".md",".txt",".ps1",".psm1")) { return "rejected rows" }

    if ($Content -match "PATH_CLASS_50_WAVE_REPAIR|PATH-CLASS-50-WAVE-REPAIR") { return "already handled" }

    if ($SourceKind -eq "INTAKE") {
        if ($FieldOrClass -eq "Keying" -and (Has-Any -Text $Content -Patterns @("(?i)WorkKey:|controlled key|Registry key|Key tags|TAG =|KEY ="))) { return "already handled" }
        if ($FieldOrClass -eq "Hash" -and (Has-Any -Text $Content -Patterns @("(?i)SHA256|Hash-to-receipt|Hash purpose|Fixity|Manifest"))) { return "already handled" }
        if ($FieldOrClass -eq "HashToReceiptPurpose" -and (Has-Any -Text $Content -Patterns @("(?i)What this proves|What this does not prove|Proof purpose|hash-to-receipt"))) { return "already handled" }
        if ($FieldOrClass -eq "RouteLedgerMap" -and (Has-Any -Text $Content -Patterns @("(?i)Route|Map|Ledger|Route index"))) { return "already handled" }
        if ($FieldOrClass -eq "Boundary" -and (Has-Any -Text $Content -Patterns @("(?i)Boundary|not doctrine|Forbidden|Do not"))) { return "already handled" }
        if ($FieldOrClass -eq "Return" -and (Has-Any -Text $Content -Patterns @("(?i)Return path|Next condition|Return trigger|Next clean move"))) { return "already handled" }
        if ($FieldOrClass -eq "CurrentnessDisposition" -and (Has-Any -Text $Content -Patterns @("(?i)Currentness|Disposition|PARKED|PROOF_ONLY|SOURCE_ORE"))) { return "already handled" }
    }

    if ($SourceKind -eq "ROOT_LAYER") {
        if ($FieldOrClass -eq "POSSIBLE_SKIPPED_LOWER_ROOT_REVIEW") {
            $HasSeparation = Has-Any -Text $Content -Patterns @("(?i)Upper object|Lower object|drop one layer|root cause|do not judge")
            $HasRuntime = Has-Any -Text $Content -Patterns @("(?i)runtime|rerun|EndState|CLEAN_CLOSE|direct run|proof")
            if ($HasSeparation -and $HasRuntime) { return "already handled" }
        }
        if ($FieldOrClass -eq "MISSING_DISPOSITION_REVIEW" -and (Has-Any -Text $Content -Patterns @("(?i)Disposition|Return path|Next condition|PARKED|PROOF_ONLY"))) { return "already handled" }
        if ($FieldOrClass -eq "NOOP_COMMIT_TRUTH_REVIEW" -and (Has-Any -Text $Content -Patterns @("(?i)NO-OP NO-COMMIT|No-op.*no commit|Commit message truth|RepairedTargets"))) { return "already handled" }
    }

    if ($PathClass -eq "stale/proof-only") { return "parked rows" }
    if ($PathClass -eq "needs human review") { return "parked rows" }
    if ($PathClass -eq "helper/tool issue") { return "helper/tool repair rows" }
    return "confirmed next 50 repair candidates"
}

function New-TicketObject {
    param(
        [Parameter(Mandatory=$true)][string]$SourceKind,
        [Parameter(Mandatory=$true)][object]$Row,
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$FieldOrClass,
        [Parameter(Mandatory=$true)][string]$Message,
        [Parameter(Mandatory=$true)][string]$PathClass,
        [Parameter(Mandatory=$true)][string]$Disposition,
        [Parameter(Mandatory=$true)][string]$Sha256
    )

    $RepairType = "PATH_CLASS_REPAIR"
    if ($SourceKind -eq "INTAKE") { $RepairType = "INTAKE_GATE_KEY_HASH_GUARD" }
    if ($SourceKind -eq "ROOT_LAYER") { $RepairType = "ROOT_LAYER_DROP_DOWN" }
    if ($PathClass -eq "route/path issue") { $RepairType = "ROUTE_PATH_REPAIR" }
    if ($PathClass -eq "helper/tool issue") { $RepairType = "HELPER_TOOL_REPAIR" }

    [pscustomobject]@{
        SourceKind = $SourceKind
        Path = $Path
        FieldOrClass = $FieldOrClass
        Message = $Message
        PathClass = $PathClass
        ReviewDisposition = $Disposition
        RepairType = $RepairType
        SHA256 = $Sha256
    }
}

$HouseRoot = Resolve-HouseRoot
$RepoRoot = Resolve-RepoRoot -HouseRoot $HouseRoot
$ReportRoot = Join-Path $HouseRoot "_MISC_DRAWER\READ_REPORTS"
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$Head = (& git -C $RepoRoot rev-parse HEAD).Trim()
$StatusShort = @(& git -C $RepoRoot status --short)

if ([string]::IsNullOrWhiteSpace($IntakeRecordsCsv)) { $IntakeRecordsCsv = Resolve-LatestReport -ReportRoot $ReportRoot -Pattern "INTAKE_GATE_KEY_HASH_JOIN_AUDIT_RECORDS_*.csv" }
if ([string]::IsNullOrWhiteSpace($IntakeFindingsCsv)) { $IntakeFindingsCsv = Resolve-LatestReport -ReportRoot $ReportRoot -Pattern "INTAKE_GATE_KEY_HASH_JOIN_AUDIT_FINDINGS_*.csv" }
if ([string]::IsNullOrWhiteSpace($RootRecordsCsv)) { $RootRecordsCsv = Resolve-LatestReport -ReportRoot $ReportRoot -Pattern "ROOT_LAYER_SKIPPED_ISSUE_HISTORY_AUDIT_RECORDS_*.csv" }
if ([string]::IsNullOrWhiteSpace($RootFindingsCsv)) { $RootFindingsCsv = Resolve-LatestReport -ReportRoot $ReportRoot -Pattern "ROOT_LAYER_SKIPPED_ISSUE_HISTORY_AUDIT_FINDINGS_*.csv" }

$IntakeRecords = @(Import-Csv -LiteralPath $IntakeRecordsCsv)
$IntakeFindings = @(Import-Csv -LiteralPath $IntakeFindingsCsv)
$RootRecords = @(Import-Csv -LiteralPath $RootRecordsCsv)
$RootFindings = @(Import-Csv -LiteralPath $RootFindingsCsv)

$ShaByPath = @{}
foreach ($Row in @($IntakeRecords + $RootRecords)) {
    if ($null -ne $Row.Path -and $null -ne $Row.SHA256 -and !$ShaByPath.ContainsKey($Row.Path)) {
        $ShaByPath[$Row.Path] = $Row.SHA256
    }
}

$AllRows = New-Object System.Collections.Generic.List[object]

foreach ($Row in $IntakeFindings) {
    $Path = [string]$Row.Path
    $Field = [string]$Row.Field
    if ([string]::IsNullOrWhiteSpace($Path)) { continue }
    $PathClass = Get-PathClass -Path $Path
    $FullPath = Convert-ToRepoPath -RepoRoot $RepoRoot -RelativePath $Path
    $Content = Read-TextSafe -Path $FullPath
    $Disposition = Get-ReviewDisposition -Path $Path -PathClass $PathClass -SourceKind "INTAKE" -FieldOrClass $Field -FullPath $FullPath -Content $Content
    $Sha = if ($ShaByPath.ContainsKey($Path)) { $ShaByPath[$Path] } else { "UNKNOWN" }
    $AllRows.Add((New-TicketObject -SourceKind "INTAKE" -Row $Row -Path $Path -FieldOrClass $Field -Message ([string]$Row.Message) -PathClass $PathClass -Disposition $Disposition -Sha256 $Sha)) | Out-Null
}

foreach ($Row in $RootFindings) {
    $Path = [string]$Row.Path
    $Class = [string]$Row.Class
    if ([string]::IsNullOrWhiteSpace($Path)) { continue }
    $PathClass = Get-PathClass -Path $Path
    $FullPath = Convert-ToRepoPath -RepoRoot $RepoRoot -RelativePath $Path
    $Content = Read-TextSafe -Path $FullPath
    $Disposition = Get-ReviewDisposition -Path $Path -PathClass $PathClass -SourceKind "ROOT_LAYER" -FieldOrClass $Class -FullPath $FullPath -Content $Content
    $Sha = if ($ShaByPath.ContainsKey($Path)) { $ShaByPath[$Path] } else { "UNKNOWN" }
    $AllRows.Add((New-TicketObject -SourceKind "ROOT_LAYER" -Row $Row -Path $Path -FieldOrClass $Class -Message ([string]$Row.Message) -PathClass $PathClass -Disposition $Disposition -Sha256 $Sha)) | Out-Null
}

$ConfirmedPool = @($AllRows | Where-Object { $_.ReviewDisposition -eq "confirmed next 50 repair candidates" })
$HelperRows = @($AllRows | Where-Object { $_.ReviewDisposition -eq "helper/tool repair rows" })
$AlreadyHandled = @($AllRows | Where-Object { $_.ReviewDisposition -eq "already handled" })
$Parked = @($AllRows | Where-Object { $_.ReviewDisposition -eq "parked rows" })
$Rejected = @($AllRows | Where-Object { $_.ReviewDisposition -eq "rejected rows" })

$RankedConfirmedPool = New-Object System.Collections.Generic.List[object]
foreach ($Row in $ConfirmedPool) {
    $Priority = 4
    if ($Row.SourceKind -eq "INTAKE" -and $Row.FieldOrClass -eq "Hash") {
        $Priority = 0
    } elseif ($Row.SourceKind -eq "INTAKE") {
        $Priority = 1
    } elseif ($Row.FieldOrClass -eq "NOOP_COMMIT_TRUTH_REVIEW") {
        $Priority = 2
    } elseif ($Row.FieldOrClass -eq "POSSIBLE_SKIPPED_LOWER_ROOT_REVIEW") {
        $Priority = 3
    }

    $RankedConfirmedPool.Add([pscustomobject]@{
        ReviewPriority = $Priority
        SourceKind = $Row.SourceKind
        Path = $Row.Path
        FieldOrClass = $Row.FieldOrClass
        Message = $Row.Message
        PathClass = $Row.PathClass
        ReviewDisposition = $Row.ReviewDisposition
        RepairType = $Row.RepairType
        SHA256 = $Row.SHA256
    }) | Out-Null
}

$RootFloor = [Math]::Min(15, $MaxTickets)
$RootSlice = @($RankedConfirmedPool | Where-Object { $_.SourceKind -eq "ROOT_LAYER" } | Sort-Object ReviewPriority, Path, FieldOrClass | Select-Object -First $RootFloor)
$SelectedKeys = @{}
foreach ($Row in $RootSlice) {
    $SelectedKeys["$($Row.SourceKind)|$($Row.Path)|$($Row.FieldOrClass)"] = $true
}

$RemainingSlots = $MaxTickets - $RootSlice.Count
$IntakeSlice = @(
    $RankedConfirmedPool |
        Where-Object {
            $_.SourceKind -eq "INTAKE" -and
            !$SelectedKeys.ContainsKey("$($_.SourceKind)|$($_.Path)|$($_.FieldOrClass)")
        } |
        Sort-Object ReviewPriority, Path, FieldOrClass |
        Select-Object -First $RemainingSlots
)
foreach ($Row in $IntakeSlice) {
    $SelectedKeys["$($Row.SourceKind)|$($Row.Path)|$($Row.FieldOrClass)"] = $true
}

$Combined = @($RootSlice + $IntakeSlice)
if ($Combined.Count -lt $MaxTickets) {
    $FillSlots = $MaxTickets - $Combined.Count
    $FillRows = @(
        $RankedConfirmedPool |
            Where-Object { !$SelectedKeys.ContainsKey("$($_.SourceKind)|$($_.Path)|$($_.FieldOrClass)") } |
            Sort-Object ReviewPriority, Path, FieldOrClass |
            Select-Object -First $FillSlots
    )
    $Combined = @($Combined + $FillRows)
}

$Confirmed = @($Combined | Select-Object -First $MaxTickets)

$ConfirmedCsv = Join-Path $ReportRoot "PATH_CLASS_CONFIRMED_50_REPAIR_PACKET_$RunId.csv"
$ParkedCsv = Join-Path $ReportRoot "PATH_CLASS_PARKED_ROWS_$RunId.csv"
$RejectedCsv = Join-Path $ReportRoot "PATH_CLASS_REJECTED_ROWS_$RunId.csv"
$HelperCsv = Join-Path $ReportRoot "PATH_CLASS_HELPER_TOOL_ROWS_$RunId.csv"
$ReviewMd = Join-Path $ReportRoot "PATH_CLASS_REVIEW_CLOSEOUT_$RunId.md"
$PacketMd = Join-Path $ReportRoot "PATH_CLASS_CONFIRMED_50_REPAIR_PACKET_$RunId.md"

$Confirmed | Export-Csv -LiteralPath $ConfirmedCsv -NoTypeInformation -Encoding UTF8
$Parked | Export-Csv -LiteralPath $ParkedCsv -NoTypeInformation -Encoding UTF8
$Rejected | Export-Csv -LiteralPath $RejectedCsv -NoTypeInformation -Encoding UTF8
$HelperRows | Export-Csv -LiteralPath $HelperCsv -NoTypeInformation -Encoding UTF8

$Verdict = "PASS_WITH_REVIEW"
if ($Confirmed.Count -lt $MaxTickets) { $Verdict = "PARTIAL_NEEDS_NEXT_PASS" }
if ($StatusShort.Count -gt 0) { $Verdict = "BLOCKED_BY_DIRTY_STATE" }

$Md = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $Md -Text "# Path-Class Review Closeout"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "RunId: $RunId"
Add-Line -Lines $Md -Text "Mode: READ_REPORT_ONLY"
Add-Line -Lines $Md -Text "Head: $Head"
Add-Line -Lines $Md -Text "StatusShortCount: $($StatusShort.Count)"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "## Input check"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "- Intake Gate findings present: $($IntakeFindings.Count -gt 0)"
Add-Line -Lines $Md -Text "- Intake Gate records: $($IntakeRecords.Count)"
Add-Line -Lines $Md -Text "- Intake Gate findings: $($IntakeFindings.Count)"
Add-Line -Lines $Md -Text "- Root-Layer skipped-history findings present: $($RootFindings.Count -gt 0)"
Add-Line -Lines $Md -Text "- Root-Layer records: $($RootRecords.Count)"
Add-Line -Lines $Md -Text "- Root-Layer findings: $($RootFindings.Count)"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "## Classification counts"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "- Confirmed next 50 repair candidates: $($Confirmed.Count)"
Add-Line -Lines $Md -Text "- Confirmed pool before floor: $($ConfirmedPool.Count)"
Add-Line -Lines $Md -Text "- Parked rows: $($Parked.Count)"
Add-Line -Lines $Md -Text "- Rejected rows: $($Rejected.Count)"
Add-Line -Lines $Md -Text "- Helper/tool repair rows: $($HelperRows.Count)"
Add-Line -Lines $Md -Text "- Already handled rows: $($AlreadyHandled.Count)"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "## Confirmed next 50 repair candidates"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "| # | Source | Path class | Field/Class | Path |"
Add-Line -Lines $Md -Text "|---:|---|---|---|---|"
$Index = 0
foreach ($Row in $Confirmed) {
    $Index++
    Add-Line -Lines $Md -Text "| $Index | $($Row.SourceKind) | $($Row.PathClass) | $($Row.FieldOrClass) | $($Row.Path) |"
}
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "## Helper/tool repair rows"
Add-Line -Lines $Md
if ($HelperRows.Count -eq 0) {
    Add-Line -Lines $Md -Text "No helper/tool repair rows found in the parked-row inputs."
} else {
    $HelperTopRows = @($HelperRows | Select-Object -First 40)
    foreach ($Row in $HelperTopRows) {
        Add-Line -Lines $Md -Text "- $($Row.SourceKind) :: $($Row.FieldOrClass) :: $($Row.Path)"
    }
}
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "## Parked/rejected rule"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "Proof-only, backup, custody, legacy BRAIN/LEARNING, missing target, unsupported extension, and already-handled rows do not enter the 50-ticket repair packet."
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "## Outputs"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "- Confirmed packet CSV: $ConfirmedCsv"
Add-Line -Lines $Md -Text "- Confirmed packet MD: $PacketMd"
Add-Line -Lines $Md -Text "- Parked rows CSV: $ParkedCsv"
Add-Line -Lines $Md -Text "- Rejected rows CSV: $RejectedCsv"
Add-Line -Lines $Md -Text "- Helper/tool rows CSV: $HelperCsv"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "## Final review verdict"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "````text"
Add-Line -Lines $Md -Text $Verdict
Add-Line -Lines $Md -Text "````"
Add-Line -Lines $Md
Add-Line -Lines $Md -Text "Next clean move: run a bounded repair runner against only the confirmed packet CSV."
[System.IO.File]::WriteAllText($ReviewMd, ($Md -join "`r`n"), [System.Text.UTF8Encoding]::new($false))

$Pkt = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $Pkt -Text "# Confirmed 50-Ticket Repair Packet"
Add-Line -Lines $Pkt
Add-Line -Lines $Pkt -Text "RunId: $RunId"
Add-Line -Lines $Pkt -Text "Source review: $ReviewMd"
Add-Line -Lines $Pkt -Text "Input Intake findings: $IntakeFindingsCsv"
Add-Line -Lines $Pkt -Text "Input Root-Layer findings: $RootFindingsCsv"
Add-Line -Lines $Pkt -Text "Rule: repair only rows below. Skip-only is not repair. No-op is no commit."
Add-Line -Lines $Pkt
$Index = 0
foreach ($Row in $Confirmed) {
    $Index++
    Add-Line -Lines $Pkt -Text "### Ticket $Index"
    Add-Line -Lines $Pkt -Text "- SourceKind: $($Row.SourceKind)"
    Add-Line -Lines $Pkt -Text "- Path: $($Row.Path)"
    Add-Line -Lines $Pkt -Text "- PathClass: $($Row.PathClass)"
    Add-Line -Lines $Pkt -Text "- FieldOrClass: $($Row.FieldOrClass)"
    Add-Line -Lines $Pkt -Text "- RepairType: $($Row.RepairType)"
    Add-Line -Lines $Pkt -Text "- Message: $($Row.Message)"
    Add-Line -Lines $Pkt -Text "- SHA256: $($Row.SHA256)"
    Add-Line -Lines $Pkt
}
[System.IO.File]::WriteAllText($PacketMd, ($Pkt -join "`r`n"), [System.Text.UTF8Encoding]::new($false))

Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
Write-Host "PATH_CLASS_REVIEW_CLOSEOUT_COMPLETE"
Write-Host "EndState: CLEAN_CLOSE"
Write-Host "RunId: $RunId"
Write-Host "Head: $Head"
Write-Host "FinalReviewVerdict: $Verdict"
Write-Host "IntakeFindingsPresent: $($IntakeFindings.Count -gt 0)"
Write-Host "RootLayerFindingsPresent: $($RootFindings.Count -gt 0)"
Write-Host "ConfirmedNext50: $($Confirmed.Count)"
Write-Host "ParkedRows: $($Parked.Count)"
Write-Host "RejectedRows: $($Rejected.Count)"
Write-Host "HelperToolRepairRows: $($HelperRows.Count)"
Write-Host "AlreadyHandledRows: $($AlreadyHandled.Count)"
Write-Host "ReviewReport: $ReviewMd"
Write-Host "ConfirmedPacketCsv: $ConfirmedCsv"
Write-Host "ConfirmedPacketMd: $PacketMd"
Write-Host "BoundaryHeld: read/report only; no Git writes; no commit; no push; no delete; no move."
Write-Host "NextCleanMove: run hardened repair runner on confirmed packet only."
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"

# APPLY_PATH_CLASS_REVIEW_REPAIR_PACKET_V1_20260530.ps1
# Applies bounded repair notes from a confirmed path-class packet.
# Boundary: confirmed packet rows only. No doctrine, no ACTIVE_GUIDES, no CURRENT_TRUTH_INDEX, no broad refactor, no delete, no move, no automation, no watcher.

[CmdletBinding()]
param(
    [switch]$AllowGitWrites,
    [switch]$SkipPush,
    [int]$MaxTickets = 50,
    [Parameter(Mandatory=$true)][string]$ConfirmedPacketCsv,
    [string]$ReviewReportPath,
    [string]$PacketMarkdownPath
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

function Convert-ToRepoPath {
    param([Parameter(Mandatory=$true)][string]$RelativePath)
    return Join-Path $RepoRoot ($RelativePath -replace '/', [System.IO.Path]::DirectorySeparatorChar)
}

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory=$true)][string]$RelativePath,
        [Parameter(Mandatory=$true)][AllowEmptyString()][string]$Content
    )
    $Full = Convert-ToRepoPath -RelativePath $RelativePath
    $Dir = Split-Path -Parent $Full
    $DirItems = @(Get-Item -LiteralPath $Dir -ErrorAction SilentlyContinue)
    if ($DirItems.Count -eq 0) { New-Item -ItemType Directory -Path $Dir -Force | Out-Null }
    [System.IO.File]::WriteAllText($Full, $Content, [System.Text.UTF8Encoding]::new($false))
}

function Get-Sha256 {
    param([Parameter(Mandatory=$true)][string]$Path)
    $Items = @(Get-Item -LiteralPath $Path -ErrorAction SilentlyContinue)
    if ($Items.Count -eq 0) { return "MISSING" }
    return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
}

function Invoke-GitChecked {
    param([Parameter(Mandatory=$true)][string[]]$GitArguments)
    & git -C $RepoRoot @GitArguments
    if ($LASTEXITCODE -ne 0) { throw "git command failed: git $($GitArguments -join ' ')" }
}

function Test-SafeRepoRelativePath {
    param([Parameter(Mandatory=$true)][AllowEmptyString()][string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    if ($Path -match "^[A-Za-z]:\\") { return $false }
    if ($Path.StartsWith("/") -or $Path.StartsWith("\")) { return $false }
    if ($Path -match "(^|/|\\)\.\.($|/|\\)") { return $false }
    return $true
}

function New-TargetMarker {
    param([Parameter(Mandatory=$true)][string]$Path)
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes("PATH_CLASS_50_WAVE_REPAIR|$Path")
    $Hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($Bytes)
    return "PATH_CLASS_50_WAVE_REPAIR:" + (([BitConverter]::ToString($Hash) -replace "-", "").Substring(0, 16))
}

function New-RepairBlock {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][object[]]$Tickets,
        [Parameter(Mandatory=$true)][string]$Marker,
        [Parameter(Mandatory=$true)][string]$BeforeSha,
        [Parameter(Mandatory=$true)][string]$RunId,
        [Parameter(Mandatory=$true)][string]$RouteIndexPath,
        [Parameter(Mandatory=$true)][string]$ReceiptPath
    )

    $Fields = @($Tickets | ForEach-Object { $_.FieldOrClass } | Sort-Object -Unique)
    $Sources = @($Tickets | ForEach-Object { $_.SourceKind } | Sort-Object -Unique)
    $Classes = @($Tickets | ForEach-Object { $_.PathClass } | Sort-Object -Unique)
    $RepairTypes = @($Tickets | ForEach-Object { $_.RepairType } | Sort-Object -Unique)
    $TicketList = ($Fields -join ", ")
    $SourceList = ($Sources -join ", ")
    $ClassList = ($Classes -join ", ")
    $RepairTypeList = ($RepairTypes -join ", ")

    $Core = @"
<!-- $Marker -->
## Path-Class 50-Wave Repair Note

Status: CONFIRMED_PATH_CLASS_REPAIR / NOT_DOCTRINE
WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
RunId: $RunId

Object path: $Path
Source inputs: $SourceList
Path class: $ClassList
Repair type: $RepairTypeList
Confirmed fields/classes: $TicketList

Controlled key:
- WorkKey: PATH-CLASS-50-WAVE-REPAIR-20260530-V1
- Key tags: PATH_CLASS_REVIEW, CONFIRMED_50_PACKET, INTAKE_GATE_KEY_HASH_GUARD, ROOT_LAYER_DROP_DOWN

Hash-to-receipt join:
- Target SHA256 before repair: $BeforeSha
- Receipt: $ReceiptPath
- Route index: $RouteIndexPath
- What this hash proves: the bounded pre-repair target state for this packet.
- What this hash does not prove: doctrine promotion, full object cleanliness, or unrelated field closure.

Route / ledger / map:
- Ledger home: confirmed path-class packet saved with this repair.
- Map relation: Intake Gate finding and Root-Layer watch row -> path-class review -> confirmed packet -> bounded target note -> re-audit compare.
- Return path: confirmed packet and re-audit compare report.

Root-layer drop-down:
- Upper object: parked watch-row finding for this path.
- Lower object: path class, helper/tool, route/path, key/hash/intake, proof-only, or stale-currentness cause.
- Root cause tested: row was reviewed against current target content before repair.
- Separation verdict: repair only the named reviewed fields/classes; do not judge unrelated object health.
- Runtime proof needed: re-run Intake Gate and Root-Layer helpers after repair.

No-op / skip-only latch:
- NO-OP NO-COMMIT LATCH applies to the runner.
- SKIP-ONLY IS NOT REPAIR.
- Commit allowed only when RepairedTargets > 0.
- Commit message must match actual action.

Currentness and disposition:
- Currentness: CURRENT_SUPPORT_REPAIR_NOTE
- Disposition: KEEP_WITH_OBJECT_UNTIL_REAUDIT
- Next condition: re-audit and compare closure for this path and these fields/classes.

Boundary:
- confirmed packet rows only
- no doctrine
- no ACTIVE_GUIDES
- no CURRENT_TRUTH_INDEX
- no broad refactor
- no delete
- no move
- no automation
- no watcher
<!-- /$Marker -->
"@

    $Extension = [System.IO.Path]::GetExtension((Convert-ToRepoPath -RelativePath $Path)).ToLowerInvariant()
    if ($Extension -in @(".ps1",".psm1")) {
        $Body = $Core -replace "<!--", "" -replace "-->", ""
        return "<#`r`n$Body`r`n#>"
    }
    return $Core
}

$HouseRoot = Resolve-HouseRoot
$RepoRoot = Resolve-RepoRoot -HouseRoot $HouseRoot
$RunId = Get-Date -Format "yyyyMMdd_HHmmss"
$WorkKey = "PATH-CLASS-50-WAVE-REPAIR-20260530-V1"

$PacketRows = @(Import-Csv -LiteralPath $ConfirmedPacketCsv)
$Tickets = @($PacketRows | Select-Object -First $MaxTickets)
$TicketCount = $Tickets.Count
if ($TicketCount -eq 0) { throw "Confirmed packet has no tickets: $ConfirmedPacketCsv" }

if (!$AllowGitWrites) {
    Write-Host "PATH_CLASS_REVIEW_REPAIR_PACKET_PROBE"
    Write-Host "EndState: PROBE_ONLY"
    Write-Host "RunId: $RunId"
    Write-Host "MaxTickets: $MaxTickets"
    Write-Host "TicketsRead: $TicketCount"
    Write-Host "ConfirmedPacketCsv: $ConfirmedPacketCsv"
    Write-Host "Message: Re-run with -AllowGitWrites to apply bounded repair notes."
    Write-Host "BoundaryHeld: no repo writes; no commit; no push; no delete; no move."
    exit 0
}

$InitialStatus = @(& git -C $RepoRoot status --short)
if ($LASTEXITCODE -ne 0) { throw "git status failed before repair." }
if ($InitialStatus.Count -gt 0) {
    Write-Host "DIRTY_STATUS_BEFORE_REPAIR:"
    foreach ($Line in $InitialStatus) { Write-Host $Line }
    throw "Repo is dirty before path-class repair."
}

$OldHead = (& git -C $RepoRoot rev-parse HEAD).Trim()
$RouteIndexPath = "HOUSE_WORK/WORK_SHED/INDEXES/PATH_CLASS_50_WAVE_REPAIR_ROUTE_INDEX_20260530.md"
$RepairDir = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/PATH_CLASS_50_WAVE_REPAIR_PACKET_20260530"
$RepairReportPath = "$RepairDir/PATH_CLASS_50_WAVE_BOUNDED_REPAIR_REPORT_20260530.md"
$SkippedReportPath = "$RepairDir/PATH_CLASS_50_WAVE_BOUNDED_REPAIR_SKIPPED_TARGETS_20260530.md"
$ReviewCopyPath = "$RepairDir/PATH_CLASS_REVIEW_CLOSEOUT_SOURCE_COPY_20260530.md"
$PacketCopyPath = "$RepairDir/PATH_CLASS_CONFIRMED_50_REPAIR_PACKET_SOURCE_COPY_20260530.md"
$PacketCsvCopyPath = "$RepairDir/PATH_CLASS_CONFIRMED_50_REPAIR_PACKET_SOURCE_COPY_20260530.csv"
$CompareTodoPath = "HOUSE_WORK/TODO/PATH_CLASS_50_WAVE_REAUDIT_COMPARE_TODO_20260530.md"
$ReceiptPath = "PROOF_HISTORY/PATH_CLASS_50_WAVE_BOUNDED_REPAIR_RECEIPT_20260530.txt"
$ManifestPath = "PROOF_HISTORY/PATH_CLASS_50_WAVE_BOUNDED_REPAIR_MANIFEST_20260530.txt"

$Grouped = @($Tickets | Group-Object Path)
$RepairedTargets = New-Object System.Collections.Generic.List[object]
$RepairedTickets = New-Object System.Collections.Generic.List[object]
$Skipped = New-Object System.Collections.Generic.List[object]
$StagePaths = New-Object System.Collections.Generic.List[string]

foreach ($Group in $Grouped) {
    $Path = [string]$Group.Name
    $GroupTickets = @($Group.Group)

    if (!(Test-SafeRepoRelativePath -Path $Path)) {
        foreach ($Ticket in $GroupTickets) { $Skipped.Add([pscustomobject]@{ Path=$Path; FieldOrClass=$Ticket.FieldOrClass; Reason="Unsafe or non-relative path" }) | Out-Null }
        continue
    }

    $Full = Convert-ToRepoPath -RelativePath $Path
    $TargetItems = @(Get-Item -LiteralPath $Full -ErrorAction SilentlyContinue)
    if ($TargetItems.Count -eq 0) {
        foreach ($Ticket in $GroupTickets) { $Skipped.Add([pscustomobject]@{ Path=$Path; FieldOrClass=$Ticket.FieldOrClass; Reason="Target missing" }) | Out-Null }
        continue
    }

    $Extension = [System.IO.Path]::GetExtension($Full).ToLowerInvariant()
    if ($Extension -notin @(".md",".txt",".ps1",".psm1")) {
        foreach ($Ticket in $GroupTickets) { $Skipped.Add([pscustomobject]@{ Path=$Path; FieldOrClass=$Ticket.FieldOrClass; Reason="Unsupported extension: $Extension" }) | Out-Null }
        continue
    }

    $Existing = [System.IO.File]::ReadAllText($Full)
    $Marker = New-TargetMarker -Path $Path
    if ($Existing.Contains($Marker)) {
        foreach ($Ticket in $GroupTickets) { $Skipped.Add([pscustomobject]@{ Path=$Path; FieldOrClass=$Ticket.FieldOrClass; Reason="Path-class repair marker already present" }) | Out-Null }
        continue
    }

    $BeforeSha = Get-Sha256 -Path $Full
    $Block = New-RepairBlock -Path $Path -Tickets $GroupTickets -Marker $Marker -BeforeSha $BeforeSha -RunId $RunId -RouteIndexPath $RouteIndexPath -ReceiptPath $ReceiptPath
    [System.IO.File]::WriteAllText($Full, $Existing.TrimEnd() + "`r`n`r`n" + $Block.Trim() + "`r`n", [System.Text.UTF8Encoding]::new($false))
    $AfterSha = Get-Sha256 -Path $Full

    $RepairedTargets.Add([pscustomobject]@{
        Path = $Path
        TicketCount = $GroupTickets.Count
        BeforeSha256 = $BeforeSha
        AfterSha256 = $AfterSha
        Marker = $Marker
    }) | Out-Null
    foreach ($Ticket in $GroupTickets) {
        $RepairedTickets.Add([pscustomobject]@{ Path=$Path; FieldOrClass=$Ticket.FieldOrClass; SourceKind=$Ticket.SourceKind; PathClass=$Ticket.PathClass }) | Out-Null
    }
    $StagePaths.Add($Path) | Out-Null
}

if ($RepairedTargets.Count -eq 0) {
    $LocalReportRoot = Join-Path $HouseRoot "_MISC_DRAWER\READ_REPORTS"
    $LocalNoOp = Join-Path $LocalReportRoot "PATH_CLASS_50_WAVE_REPAIR_NOOP_$RunId.md"
    $NoOpLines = New-Object System.Collections.Generic.List[string]
    Add-Line -Lines $NoOpLines -Text "# Path-Class 50-Wave Repair No-Op Report"
    Add-Line -Lines $NoOpLines
    Add-Line -Lines $NoOpLines -Text "RunId: $RunId"
    Add-Line -Lines $NoOpLines -Text "Tickets read: $TicketCount"
    Add-Line -Lines $NoOpLines -Text "RepairedTargets: 0"
    Add-Line -Lines $NoOpLines -Text "SkippedTargets: $($Skipped.Count)"
    Add-Line -Lines $NoOpLines -Text "Verdict: NO_OP_NO_COMMIT"
    Add-Line -Lines $NoOpLines -Text "Boundary: skip-only/no-op local report only; no commit."
    [System.IO.File]::WriteAllText($LocalNoOp, ($NoOpLines -join "`r`n"), [System.Text.UTF8Encoding]::new($false))
    Write-Host "PATH_CLASS_50_WAVE_REPAIR_NOOP"
    Write-Host "EndState: NO_OP_NO_COMMIT"
    Write-Host "RunId: $RunId"
    Write-Host "TicketsRead: $TicketCount"
    Write-Host "RepairedTargets: 0"
    Write-Host "SkippedTargets: $($Skipped.Count)"
    Write-Host "LocalReport: $LocalNoOp"
    Write-Host "CommitCreated: False"
    exit 0
}

$RouteRows = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $RouteRows -Text "# Path-Class 50-Wave Repair Route Index"
Add-Line -Lines $RouteRows
Add-Line -Lines $RouteRows -Text "Date: 2026-05-30"
Add-Line -Lines $RouteRows -Text "Status: ROUTE INDEX / CONFIRMED PACKET REPAIR / NOT DOCTRINE"
Add-Line -Lines $RouteRows -Text "WorkKey: $WorkKey"
Add-Line -Lines $RouteRows
Add-Line -Lines $RouteRows -Text "## Repaired targets"
Add-Line -Lines $RouteRows
Add-Line -Lines $RouteRows -Text "| Path | Ticket count | Marker |"
Add-Line -Lines $RouteRows -Text "|---|---:|---|"
foreach ($Row in $RepairedTargets) {
    Add-Line -Lines $RouteRows -Text "| `$($Row.Path)` | $($Row.TicketCount) | `$($Row.Marker)` |"
}
Add-Line -Lines $RouteRows
Add-Line -Lines $RouteRows -Text "## Return"
Add-Line -Lines $RouteRows
Add-Line -Lines $RouteRows -Text "Return path: $CompareTodoPath"
Add-Line -Lines $RouteRows -Text "Proof pointer: $ReceiptPath"
Add-Line -Lines $RouteRows -Text "Next condition: run Intake Gate and Root-Layer re-audits, then compare closure."
Write-Utf8NoBom -RelativePath $RouteIndexPath -Content ($RouteRows -join "`r`n")
$StagePaths.Add($RouteIndexPath) | Out-Null

$ReportRows = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $ReportRows -Text "# Path-Class 50-Wave Bounded Repair Report"
Add-Line -Lines $ReportRows
Add-Line -Lines $ReportRows -Text "RunId: $RunId"
Add-Line -Lines $ReportRows -Text "WorkKey: $WorkKey"
Add-Line -Lines $ReportRows -Text "Status: REPAIR REPORT / NOT DOCTRINE"
Add-Line -Lines $ReportRows
Add-Line -Lines $ReportRows -Text "## Counts"
Add-Line -Lines $ReportRows
Add-Line -Lines $ReportRows -Text "- Tickets read: $TicketCount"
Add-Line -Lines $ReportRows -Text "- Repaired tickets: $($RepairedTickets.Count)"
Add-Line -Lines $ReportRows -Text "- Repaired targets: $($RepairedTargets.Count)"
Add-Line -Lines $ReportRows -Text "- Skipped targets: $($Skipped.Count)"
Add-Line -Lines $ReportRows
Add-Line -Lines $ReportRows -Text "## Repaired targets"
Add-Line -Lines $ReportRows
foreach ($Row in $RepairedTargets) {
    Add-Line -Lines $ReportRows -Text "- $($Row.Path) :: tickets=$($Row.TicketCount) :: before=$($Row.BeforeSha256) :: after=$($Row.AfterSha256)"
}
Add-Line -Lines $ReportRows
Add-Line -Lines $ReportRows -Text "## Boundary"
Add-Line -Lines $ReportRows
Add-Line -Lines $ReportRows -Text "- confirmed packet rows only"
Add-Line -Lines $ReportRows -Text "- no doctrine"
Add-Line -Lines $ReportRows -Text "- no ACTIVE_GUIDES"
Add-Line -Lines $ReportRows -Text "- no CURRENT_TRUTH_INDEX"
Add-Line -Lines $ReportRows -Text "- no broad refactor"
Add-Line -Lines $ReportRows -Text "- no delete"
Add-Line -Lines $ReportRows -Text "- no move"
Add-Line -Lines $ReportRows -Text "- no automation"
Write-Utf8NoBom -RelativePath $RepairReportPath -Content ($ReportRows -join "`r`n")
$StagePaths.Add($RepairReportPath) | Out-Null

$SkippedRows = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $SkippedRows -Text "# Path-Class 50-Wave Bounded Repair Skipped Targets"
Add-Line -Lines $SkippedRows
Add-Line -Lines $SkippedRows -Text "RunId: $RunId"
Add-Line -Lines $SkippedRows
if ($Skipped.Count -eq 0) {
    Add-Line -Lines $SkippedRows -Text "No skipped targets."
} else {
    foreach ($Row in $Skipped) { Add-Line $SkippedRows "- $($Row.Path) :: $($Row.FieldOrClass) :: $($Row.Reason)" }
}
Write-Utf8NoBom -RelativePath $SkippedReportPath -Content ($SkippedRows -join "`r`n")
$StagePaths.Add($SkippedReportPath) | Out-Null

if (![string]::IsNullOrWhiteSpace($ReviewReportPath) -and (Test-Path -LiteralPath $ReviewReportPath)) {
    $ReviewText = [System.IO.File]::ReadAllText($ReviewReportPath)
    Write-Utf8NoBom -RelativePath $ReviewCopyPath -Content $ReviewText
    $StagePaths.Add($ReviewCopyPath) | Out-Null
}
if (![string]::IsNullOrWhiteSpace($PacketMarkdownPath) -and (Test-Path -LiteralPath $PacketMarkdownPath)) {
    $PacketText = [System.IO.File]::ReadAllText($PacketMarkdownPath)
    Write-Utf8NoBom -RelativePath $PacketCopyPath -Content $PacketText
    $StagePaths.Add($PacketCopyPath) | Out-Null
}
$PacketCsvText = [System.IO.File]::ReadAllText($ConfirmedPacketCsv)
Write-Utf8NoBom -RelativePath $PacketCsvCopyPath -Content $PacketCsvText
$StagePaths.Add($PacketCsvCopyPath) | Out-Null

$TodoRows = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $TodoRows -Text "# Path-Class 50-Wave Re-Audit Compare TODO"
Add-Line -Lines $TodoRows
Add-Line -Lines $TodoRows -Text "Date: 2026-05-30"
Add-Line -Lines $TodoRows -Text "Status: TODO / RETURN TRIGGER / NOT DOCTRINE"
Add-Line -Lines $TodoRows -Text "WorkKey: $WorkKey"
Add-Line -Lines $TodoRows
Add-Line -Lines $TodoRows -Text "Run Intake Gate key/hash audit and Root-Layer skipped-history audit after the repair. Compare closure only for the confirmed packet rows."
Add-Line -Lines $TodoRows
Add-Line -Lines $TodoRows -Text "Required guards:"
Add-Line -Lines $TodoRows -Text "- 50-WAVE FLOOR"
Add-Line -Lines $TodoRows -Text "- NO-OP NO-COMMIT LATCH"
Add-Line -Lines $TodoRows -Text "- SKIP-ONLY IS NOT REPAIR"
Add-Line -Lines $TodoRows -Text "- ROOT-LAYER DROP-DOWN"
Add-Line -Lines $TodoRows -Text "- INTAKE GATE KEY/HASH GUARD"
Add-Line -Lines $TodoRows -Text "- COMMIT MESSAGE TRUTH GATE"
Write-Utf8NoBom -RelativePath $CompareTodoPath -Content ($TodoRows -join "`r`n")
$StagePaths.Add($CompareTodoPath) | Out-Null

$ManifestRows = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $ManifestRows -Text "PATH_CLASS_50_WAVE_BOUNDED_REPAIR_MANIFEST"
Add-Line -Lines $ManifestRows -Text "RunId: $RunId"
Add-Line -Lines $ManifestRows -Text "WorkKey: $WorkKey"
Add-Line -Lines $ManifestRows -Text "TicketsRead: $TicketCount"
Add-Line -Lines $ManifestRows -Text "RepairedTickets: $($RepairedTickets.Count)"
Add-Line -Lines $ManifestRows -Text "RepairedTargets: $($RepairedTargets.Count)"
Add-Line -Lines $ManifestRows -Text "SkippedTargets: $($Skipped.Count)"
Add-Line -Lines $ManifestRows
Add-Line -Lines $ManifestRows -Text "Repaired target hashes:"
foreach ($Row in $RepairedTargets) {
    Add-Line -Lines $ManifestRows -Text "- $($Row.Path) :: BEFORE $($Row.BeforeSha256) :: AFTER $($Row.AfterSha256) :: $($Row.Marker)"
}
Write-Utf8NoBom -RelativePath $ManifestPath -Content ($ManifestRows -join "`r`n")
$StagePaths.Add($ManifestPath) | Out-Null

$ReceiptRows = New-Object System.Collections.Generic.List[string]
Add-Line -Lines $ReceiptRows -Text "PATH_CLASS_50_WAVE_BOUNDED_REPAIR_RECEIPT"
Add-Line -Lines $ReceiptRows -Text "RunId: $RunId"
Add-Line -Lines $ReceiptRows -Text "WorkKey: $WorkKey"
Add-Line -Lines $ReceiptRows -Text "OldHead: $OldHead"
Add-Line -Lines $ReceiptRows -Text "TicketsRead: $TicketCount"
Add-Line -Lines $ReceiptRows -Text "RepairedTickets: $($RepairedTickets.Count)"
Add-Line -Lines $ReceiptRows -Text "RepairedTargets: $($RepairedTargets.Count)"
Add-Line -Lines $ReceiptRows -Text "SkippedTargets: $($Skipped.Count)"
Add-Line -Lines $ReceiptRows -Text "CommitGate: RepairedTargets > 0, so commit is allowed."
Add-Line -Lines $ReceiptRows -Text "CommitMessage: Repair path-class reviewed watch rows"
Add-Line -Lines $ReceiptRows -Text "Boundary: confirmed packet rows only; no doctrine; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX; no broad refactor; no delete; no move; no automation."
Write-Utf8NoBom -RelativePath $ReceiptPath -Content ($ReceiptRows -join "`r`n")
$StagePaths.Add($ReceiptPath) | Out-Null

foreach ($PathItem in @($StagePaths | Select-Object -Unique)) {
    $Full = Convert-ToRepoPath -RelativePath $PathItem
    $Items = @(Get-Item -LiteralPath $Full -ErrorAction SilentlyContinue)
    if ($Items.Count -gt 0) { Invoke-GitChecked -GitArguments @("add", "-f", "--", $PathItem) }
}

$Staged = @(& git -C $RepoRoot diff --cached --name-only)
if ($LASTEXITCODE -ne 0) { throw "Could not inspect staged files." }
if ($Staged.Count -eq 0) {
    Write-Host "PATH_CLASS_50_WAVE_REPAIR_NO_STAGED_CHANGES"
    Write-Host "EndState: NO_OP_NO_COMMIT"
    Write-Host "CommitCreated: False"
    exit 0
}

Invoke-GitChecked -GitArguments @("commit", "-m", "Repair path-class reviewed watch rows")
if (!$SkipPush) { Invoke-GitChecked -GitArguments @("push", "origin", "main") }

$NewHead = (& git -C $RepoRoot rev-parse HEAD).Trim()
$OriginHash = ""
if (!$SkipPush) {
    $OriginLine = @(& git -C $RepoRoot ls-remote origin refs/heads/main)
    if ($LASTEXITCODE -ne 0) { throw "Could not read origin/main." }
    if ($OriginLine.Count -gt 0) { $OriginHash = (($OriginLine[0]) -split "\s+")[0] }
}
$FinalStatus = @(& git -C $RepoRoot status --short)
$HeadMatchesOrigin = $true
if (!$SkipPush) { $HeadMatchesOrigin = ($NewHead -eq $OriginHash) }

Write-Host "XxXxX ===== COPY BACK TO CHAT START ===== XxXxX"
Write-Host "PATH_CLASS_50_WAVE_REPAIR_COMPLETE"
Write-Host "EndState: CLEAN_CLOSE"
Write-Host "RunId: $RunId"
Write-Host "OldHead: $OldHead"
Write-Host "NewHead: $NewHead"
if (!$SkipPush) { Write-Host "OriginMain: $OriginHash" }
Write-Host "HeadMatchesOrigin: $HeadMatchesOrigin"
Write-Host "FinalStatusClean: $($FinalStatus.Count -eq 0)"
Write-Host "TicketsRead: $TicketCount"
Write-Host "RepairedTickets: $($RepairedTickets.Count)"
Write-Host "RepairedTargets: $($RepairedTargets.Count)"
Write-Host "SkippedTargets: $($Skipped.Count)"
Write-Host "CommitMessage: Repair path-class reviewed watch rows"
Write-Host "RouteIndex: $RouteIndexPath"
Write-Host "RepairReport: $RepairReportPath"
Write-Host "Receipt: $ReceiptPath"
Write-Host "BoundaryHeld: confirmed packet rows only; no doctrine; no ACTIVE_GUIDES; no CURRENT_TRUTH_INDEX; no broad refactor; no delete; no move; no automation."
Write-Host "NextCleanMove: re-audit and compare closure."
Write-Host "XxXxX ===== COPY BACK TO CHAT END ===== XxXxX"

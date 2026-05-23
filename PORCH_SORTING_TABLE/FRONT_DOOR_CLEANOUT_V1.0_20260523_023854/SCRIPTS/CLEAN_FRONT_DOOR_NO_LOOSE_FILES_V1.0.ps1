$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-HashOrBlank {
    param([string]$Path)
    try {
        if (Test-Path -LiteralPath $Path -PathType Leaf) {
            return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        }
    } catch {
        return ""
    }
    return ""
}

function Get-Category {
    param([System.IO.FileInfo]$File)

    $name = $File.Name
    $ext = $File.Extension.ToLowerInvariant()

    if ($ext -eq ".ps1") { return "SCRIPTS" }
    if ($ext -eq ".md") { return "MARKDOWN_NOTES" }
    if ($ext -in @(".zip",".7z",".rar")) { return "PACKAGES" }
    if ($ext -eq ".url") { return "SHORTCUTS" }

    if ($ext -in @(".txt",".log",".csv")) {
        if ($name -match "(?i)receipt|log|report|ledger|manifest|checkpoint|output|readback") {
            return "RECEIPTS_REPORTS_LOGS"
        }
        return "TEXT_NOTES"
    }

    if ($ext -in @(".png",".jpg",".jpeg",".webp",".gif")) { return "IMAGES" }

    return "OTHER_FILES"
}

function New-UniqueDestination {
    param(
        [string]$Directory,
        [string]$Name
    )

    $target = Join-Path $Directory $Name
    if (-not (Test-Path -LiteralPath $target)) { return $target }

    $base = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $ext = [System.IO.Path]::GetExtension($Name)
    $i = 1
    do {
        $candidateName = "{0}__DUP{1}{2}" -f $base, $i, $ext
        $target = Join-Path $Directory $candidateName
        $i += 1
    } while (Test-Path -LiteralPath $target)

    return $target
}

function Move-OneLooseFile {
    param(
        [System.IO.FileInfo]$File,
        [string]$CleanoutRoot,
        [System.Collections.Generic.List[object]]$MoveRows
    )

    $category = Get-Category -File $File
    $destDir = Join-Path $CleanoutRoot $category
    if (-not (Test-Path -LiteralPath $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    $old = $File.FullName
    $hashBefore = Get-HashOrBlank -Path $old
    $dest = New-UniqueDestination -Directory $destDir -Name $File.Name

    Move-Item -LiteralPath $old -Destination $dest -Force

    $hashAfter = Get-HashOrBlank -Path $dest
    if ($hashBefore -and $hashAfter -and $hashBefore -ne $hashAfter) {
        throw "Hash mismatch after move: $old -> $dest"
    }

    $MoveRows.Add([pscustomobject]@{
        OriginalPath = $old
        NewPath = $dest
        Category = $category
        SHA256 = $hashAfter
    }) | Out-Null
}

$Porch = Join-Path $env:USERPROFILE "Desktop\123"
if (-not (Test-Path -LiteralPath $Porch)) {
    throw "Porch not found: $Porch"
}

$Now = Get-Date -Format "yyyyMMdd_HHmmss"

$SortingRoot = Join-Path $Porch "PORCH_SORTING_TABLE"
$CleanoutRoot = Join-Path $SortingRoot "FRONT_DOOR_CLEANOUT_V1.0_$Now"
$ReceiptDir = Join-Path $SortingRoot "_RECEIPTS"
$GuestRuleDir = Join-Path $SortingRoot "GUEST_RULES"

$Dirs = @(
    $SortingRoot,
    $CleanoutRoot,
    $ReceiptDir,
    $GuestRuleDir,
    (Join-Path $CleanoutRoot "SCRIPTS"),
    (Join-Path $CleanoutRoot "MARKDOWN_NOTES"),
    (Join-Path $CleanoutRoot "RECEIPTS_REPORTS_LOGS"),
    (Join-Path $CleanoutRoot "TEXT_NOTES"),
    (Join-Path $CleanoutRoot "PACKAGES"),
    (Join-Path $CleanoutRoot "SHORTCUTS"),
    (Join-Path $CleanoutRoot "IMAGES"),
    (Join-Path $CleanoutRoot "OTHER_FILES")
)

foreach ($d in $Dirs) {
    if (-not (Test-Path -LiteralPath $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

$RulePath = Join-Path $GuestRuleDir "FRONT_DOOR_GUEST_RULE_V1.0.md"
$LedgerPath = Join-Path $CleanoutRoot "FRONT_DOOR_MOVE_LEDGER_V1.0_$Now.csv"
$ReceiptPath = Join-Path $ReceiptDir "FRONT_DOOR_CLEANOUT_RECEIPT_V1.0_$Now.txt"

$RuleText = @"
# Front Door Guest Rule — V1.0

Status: LOCAL PORCH RULE / HOUSEKEEPING BOUNDARY
Scope: Desktop\123 front-door porch.
Boundary: local cleanup rule only; no Git, no doctrine, no delete.

Rule:
Guests do not get to leave loose files at the front door.

Guest means:
- assistant-generated scripts;
- mule outputs;
- receipts;
- bridge files;
- copied notes;
- downloads;
- pickup/drop helper files;
- any outside helper output.

Front-door behavior:
- Loose files in Desktop\123 root are not allowed to pile up.
- Files must go to a lane, pickup folder, receipt folder, package intake, or sorting table.
- A guest that cannot obey the house rule does not get to work loose at the porch.
- The assistant must enforce placement and cleanup instead of becoming the janitor for guest debris.

Allowed cleanup:
- Move loose root files into a dated cleanout lane.
- Keep hashes and ledger.
- Do not delete.
- Do not move folders during this cleanup.
"@

Set-Content -LiteralPath $RulePath -Value $RuleText -Encoding UTF8

$MoveRows = New-Object System.Collections.Generic.List[object]

# Move loose files in the Desktop\123 root only. Do not move folders.
# Exclude Windows hidden/system files and any file currently under the sorting root by only scanning root files.
$LooseFiles = @(Get-ChildItem -LiteralPath $Porch -File -Force -ErrorAction Stop |
    Where-Object {
        ($_.Attributes -band [System.IO.FileAttributes]::System) -eq 0 -and
        $_.Name -notin @("desktop.ini","Thumbs.db")
    })

foreach ($file in $LooseFiles) {
    Move-OneLooseFile -File $file -CleanoutRoot $CleanoutRoot -MoveRows $MoveRows
}

$MoveRows | Export-Csv -LiteralPath $LedgerPath -NoTypeInformation -Encoding UTF8

# Verify the porch root has no loose files after cleanup.
$RemainingLoose = @(Get-ChildItem -LiteralPath $Porch -File -Force -ErrorAction Stop |
    Where-Object {
        ($_.Attributes -band [System.IO.FileAttributes]::System) -eq 0 -and
        $_.Name -notin @("desktop.ini","Thumbs.db")
    })

$MovedCount = $MoveRows.Count
$RemainingCount = $RemainingLoose.Count
$LedgerHash = Get-HashOrBlank -Path $LedgerPath
$RuleHash = Get-HashOrBlank -Path $RulePath

$Receipt = @"
FRONT DOOR CLEANOUT RECEIPT — V1.0

Timestamp: $Now
Porch: $Porch
Cleanout root: $CleanoutRoot
Move ledger: $LedgerPath
Guest rule: $RulePath

Active issue:
Loose assistant/guest-generated files were sitting in Desktop\123 root.

Corrected mechanism:
Move loose root files into a dated cleanout lane under PORCH_SORTING_TABLE, grouped by type, with hash ledger and receipt.

Moved loose root files: $MovedCount
Remaining loose root files after cleanup: $RemainingCount

Ledger SHA256: $LedgerHash
Guest rule SHA256: $RuleHash

Boundary:
- No delete.
- No folders moved.
- No Git commit.
- No public upload.
- No doctrine promotion.
- Local porch housekeeping only.

Guest rule:
Guests do not get to leave loose files at the front door. If they cannot obey house rules, they do not work loose at the porch.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8
$ReceiptHash = Get-HashOrBlank -Path $ReceiptPath

if ($RemainingCount -ne 0) {
    Write-Host "REMAINING LOOSE ROOT FILES:"
    $RemainingLoose | ForEach-Object { Write-Host $_.FullName }
    throw "Front door cleanup incomplete: $RemainingCount loose root files remain."
}

Write-Host ""
Write-Host "FRONT DOOR CLEANOUT COMPLETE"
Write-Host "Porch: $Porch"
Write-Host "Moved loose root files: $MovedCount"
Write-Host "Remaining loose root files: $RemainingCount"
Write-Host "Cleanout root: $CleanoutRoot"
Write-Host "Ledger: $LedgerPath"
Write-Host "Ledger SHA256: $LedgerHash"
Write-Host "Guest rule: $RulePath"
Write-Host "Guest rule SHA256: $RuleHash"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Receipt SHA256: $ReceiptHash"
Write-Host "Verdict: PASS / FRONT DOOR CLEAN / NO DELETE / NO FOLDERS MOVED"

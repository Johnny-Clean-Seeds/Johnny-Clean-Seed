[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string[]]$ChatDropRoots = @(
        'C:\Users\13527\Desktop\123\Chat Drop',
        'C:\Users\13527\Desktop\Chat Drop'
    ),
    [switch]$RequireClean
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}

if (-not (Test-Path -LiteralPath $RepoRoot -PathType Container)) {
    Write-Output "HELPER_GAP_DETECTED: repo root missing: $RepoRoot"
    exit 1
}

$RepoRoot = (Resolve-Path -LiteralPath $RepoRoot).Path

$publicCard = 'PUBLIC_NOTES\HELPER_GAP_AND_CAUSE_LADDER_RULE_V0_1_20260613.md'
$chatDropCard = 'CHAT_DROP_COPY__HELPER_GAP_AND_CAUSE_LADDER_RULE_V0_1_20260613.md'
$anchorName = '00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__V0_1_20260613.md'
$workbenchRoot = 'HOUSE_WORK\HELPER_GAP_AND_CAUSE_LADDER_20260613'
$packetFolder = Join-Path $workbenchRoot 'PACKETS'

$requiredRepoFiles = @(
    'CURRENT_TRUTH_INDEX.txt',
    'FRONT_DOOR_UPDATE_BOARD.md',
    $publicCard,
    (Join-Path $workbenchRoot 'README.md'),
    (Join-Path $workbenchRoot 'HELPER_GAP_CAUSE_LADDER_JOB_CONTRACT_V0_1_20260613.md'),
    (Join-Path $workbenchRoot 'HELPER_GAP_PACKET_TEMPLATE_V0_1_20260613.md'),
    'TOOLS\HelperGapCauseScanner.ps1',
    'TOOLS\Invoke-HelperDryRunSuite.ps1',
    'PUBLIC_NOTES\HELPER_ERROR_CATALOG_RULE_V0_1_20260613.md',
    'TOOLS\Invoke-HelperErrorCatalogBuild.ps1',
    'PUBLIC_NOTES\WEB_SEARCH_CRAWL_LADDER_RULE_V0_1_20260613.md',
    'PUBLIC_NOTES\SAFE_CODING_HELPER_SEED_RULE_V0_1_20260613.md',
    'TOOLS\Invoke-CleanWebCrawl.ps1',
    'TOOLS\New-SafeCodingHelperPacket.ps1',
    'TOOLS\Test-SafeCodingHelperPacket.ps1',
    'PUBLIC_NOTES\HELPER_THINKING_LOGIC_LADDER_RULE_V0_1_20260613.md',
    'TOOLS\Invoke-HelperThinkingPatternBuild.ps1'
)

function Add-Row {
    param(
        [System.Collections.Generic.List[object]]$Rows,
        [string]$Area,
        [string]$Status,
        [string]$Path,
        [string]$Evidence,
        [string]$LowestCause
    )

    $Rows.Add([PSCustomObject]@{
        Area = $Area
        Status = $Status
        Path = $Path
        Evidence = $Evidence
        LowestCause = $LowestCause
    })
}

function Test-Text {
    param(
        [string]$Path,
        [string]$Pattern
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $false
    }

    $text = Get-Content -LiteralPath $Path -Raw
    return ($text -like ('*' + $Pattern + '*'))
}

$rows = New-Object System.Collections.Generic.List[object]

foreach ($rel in $requiredRepoFiles) {
    $path = Join-Path $RepoRoot $rel
    if (Test-Path -LiteralPath $path -PathType Leaf) {
        Add-Row $rows 'repo-helper-surface' 'FOUND' $path 'Required helper gap surface exists.' 'helper presence and helper state'
    } else {
        Add-Row $rows 'repo-helper-surface' 'MISSING' $path 'Required helper gap surface is missing.' 'helper presence and helper state'
    }
}

$cti = Join-Path $RepoRoot 'CURRENT_TRUTH_INDEX.txt'
if (Test-Text -Path $cti -Pattern 'HELPER GAP AND CAUSE LADDER') {
    Add-Row $rows 'front-door' 'VISIBLE' $cti 'Current truth index names the helper gap cause ladder.' 'active object and current authority'
} else {
    Add-Row $rows 'front-door' 'NOT_VISIBLE' $cti 'Current truth index does not name the helper gap cause ladder.' 'active object and current authority'
}

$board = Join-Path $RepoRoot 'FRONT_DOOR_UPDATE_BOARD.md'
$boardText = if (Test-Path -LiteralPath $board -PathType Leaf) { Get-Content -LiteralPath $board -Raw } else { '' }
$openCount = ([regex]::Matches($boardText, '\| `FDB-[^`]+` .+ \| open \|')).Count
if ($openCount -gt 7) {
    Add-Row $rows 'front-door-board' 'BOARD_CLEAR_NEEDED' $board "Open anchor count is $openCount." 'public, board, and Chat Drop sync'
} elseif ($openCount -eq 7) {
    Add-Row $rows 'front-door-board' 'BOARD_FULL_NO_NEW_ANCHOR' $board 'Open anchor count is 7; merge into existing anchors.' 'public, board, and Chat Drop sync'
} else {
    Add-Row $rows 'front-door-board' 'BOARD_HAS_ROOM' $board "Open anchor count is $openCount." 'public, board, and Chat Drop sync'
}

foreach ($root in $ChatDropRoots) {
    if (-not (Test-Path -LiteralPath $root -PathType Container)) {
        Add-Row $rows 'chat-drop' 'MISSING_ROOT' $root 'Required Chat Drop root missing.' 'source, custody, and path freshness'
        continue
    }

    $anchor = Join-Path $root $anchorName
    $card = Join-Path $root $chatDropCard
    if (Test-Path -LiteralPath $anchor -PathType Leaf) {
        Add-Row $rows 'chat-drop' 'ANCHOR_FOUND' $anchor 'Load-first anchor exists.' 'source, custody, and path freshness'
        if (Test-Text -Path $anchor -Pattern $chatDropCard) {
            Add-Row $rows 'chat-drop' 'ANCHOR_NAMES_CARD' $anchor 'Anchor names helper gap cause card.' 'public, board, and Chat Drop sync'
        } else {
            Add-Row $rows 'chat-drop' 'ANCHOR_MISSING_CARD' $anchor 'Anchor does not name helper gap cause card.' 'public, board, and Chat Drop sync'
        }
    } else {
        Add-Row $rows 'chat-drop' 'ANCHOR_MISSING' $anchor 'Load-first anchor missing.' 'source, custody, and path freshness'
    }

    if (Test-Path -LiteralPath $card -PathType Leaf) {
        Add-Row $rows 'chat-drop' 'CARD_FOUND' $card 'Helper gap cause card is mirrored.' 'public, board, and Chat Drop sync'
    } else {
        Add-Row $rows 'chat-drop' 'CARD_MISSING' $card 'Helper gap cause card missing from Chat Drop mirror.' 'public, board, and Chat Drop sync'
    }
}

$packetRoot = Join-Path $RepoRoot $packetFolder
if (Test-Path -LiteralPath $packetRoot -PathType Container) {
    $openPackets = @(Get-ChildItem -LiteralPath $packetRoot -Filter '*.md' -File -ErrorAction SilentlyContinue | Where-Object {
        $text = Get-Content -LiteralPath $_.FullName -Raw
        $text -notlike '*Status: closed*'
    })
    if ($openPackets.Count -gt 0) {
        Add-Row $rows 'helper-gap-packets' 'OPEN_PACKETS_FOUND' $packetRoot "$($openPackets.Count) open packet file(s) found." 'proof, receipt, and DoesNotProve'
    } else {
        Add-Row $rows 'helper-gap-packets' 'NO_OPEN_HELPER_GAP_PACKETS' $packetRoot 'No open helper-gap packets found.' 'proof, receipt, and DoesNotProve'
    }
} else {
    Add-Row $rows 'helper-gap-packets' 'PACKET_FOLDER_MISSING' $packetRoot 'Packet folder missing.' 'helper presence and helper state'
}

$rows | Format-Table -AutoSize | Out-String -Width 260

$badRows = @($rows | Where-Object { $_.Status -match 'MISSING|NOT_VISIBLE|ANCHOR_MISSING_CARD|BOARD_CLEAR_NEEDED|OPEN_PACKETS_FOUND' })
$staleRows = @($rows | Where-Object { $_.Status -match 'STALE|ANCHOR_MISSING_CARD|BOARD_CLEAR_NEEDED|OPEN_PACKETS_FOUND' })

if ($badRows.Count -gt 0) {
    if ($staleRows.Count -gt 0) {
        Write-Output "HELPER_STALE_DETECTED: $($staleRows.Count) stale helper signal(s); $($badRows.Count) total issue row(s)."
    } else {
        Write-Output "HELPER_GAP_DETECTED: $($badRows.Count) helper gap issue row(s)."
    }
    Write-Output 'DOES_NOT_PROVE: This read-only scan does not mutate files, prove Git state, approve cleanup, or promote any helper.'
    if ($RequireClean) {
        exit 1
    }
} else {
    Write-Output 'HELPER_CAUSE_LADDER_CLEAR: helper gap surfaces, Chat Drop mirrors, and packet lane are visible for this scoped check.'
    Write-Output 'DOES_NOT_PROVE: This read-only scan does not mutate files, prove Git state, approve cleanup, or prove every helper is correct.'
}

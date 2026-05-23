$ErrorActionPreference = "Stop"

$Root = Join-Path $env:USERPROFILE "Desktop\GPT_Prompts"
$Current = Join-Path $Root "CURRENT"
$CustodyRoot = Join-Path $env:USERPROFILE "Desktop\123\GPT_PROMPTS_CUSTODY\CURRENT_OLD_SCAFFOLD_CLEANOUTS"
$ReceiptDir = Join-Path $env:USERPROFILE "Desktop\123\GPT_PROMPTS_CUSTODY\RECEIPTS"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Dest = Join-Path $CustodyRoot "CURRENT_OLD_SCAFFOLD_CLEANOUT_$Stamp"

$OldNames = @(
    "00_LOAD_FIRST__CHAT_GATE_SYSTEM.md",
    "01_TASK_ROUTER_GATE.md",
    "08_LOCAL_ONLY_PROMPT_PACKAGE_GATE.md",
    "14_CHAT_SUIT_HOUSE_LINK_MAP.md",
    "15_RESPECTFUL_SUIT_MAP_AND_FORKS_GATE.md",
    "16_SOURCE_LINKS_AND_PROOF.md",
    "MANIFEST.md"
)

$ExpectedCurrent = @{
    "CHAT_SOFT_SUIT_MAP.md" = "BBD216EC18E0056D19C9B7301E81131945EF063A5F1F4E262B24DC69D2DDF7E9"
    "CHAT_SOFT_SUIT_IDEA_LEDGER.md" = "65BF45F64177200374113324E74E5C9D6CF08655789CDA72A2EFD366D9BFE075"
}

if (!(Test-Path -LiteralPath $Current)) { throw "Missing CURRENT folder: $Current" }

New-Item -ItemType Directory -Path $Dest,$ReceiptDir -Force | Out-Null

$Moved = @()
$Missing = @()

foreach ($Name in $OldNames) {
    $Path = Join-Path $Current $Name
    if (Test-Path -LiteralPath $Path) {
        Move-Item -LiteralPath $Path -Destination (Join-Path $Dest $Name) -Force
        $Moved += $Name
    } else {
        $Missing += $Name
    }
}

$Rows = @()
foreach ($Name in $ExpectedCurrent.Keys) {
    $Path = Join-Path $Current $Name
    $Exists = Test-Path -LiteralPath $Path
    $Hash = ""
    $Match = $false
    if ($Exists) {
        $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
        $Match = ($Hash -eq $ExpectedCurrent[$Name])
    }
    $Rows += [pscustomobject]@{
        File = $Name
        ExistsInCurrent = $Exists
        HashMatches = $Match
        SHA256 = $Hash
    }
}

$OldCurrent = @(Get-ChildItem -LiteralPath $Current -File -Force -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -eq "MANIFEST.md" -or $_.Name -match "^(00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16)_"
})

$RootKeep = @("CURRENT","READY_TO_DROP_IN_CHAT","desktop.ini")
$UnexpectedRoot = @(Get-ChildItem -LiteralPath $Root -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $RootKeep })

$BadHash = @($Rows | Where-Object { -not $_.HashMatches })

$Receipt = Join-Path $ReceiptDir "CHAT_SOFT_SUIT_CURRENT_OLD_SCAFFOLD_CLEANOUT_$Stamp.txt"

@(
"CHAT SOFT SUIT CURRENT OLD SCAFFOLD CLEANOUT",
"Timestamp: $Stamp",
"Root: $Root",
"Current: $Current",
"Destination: $Dest",
"",
"Moved count: $($Moved.Count)",
"Moved items:",
($Moved -join [Environment]::NewLine),
"",
"Missing old items count: $($Missing.Count)",
"Missing old items:",
($Missing -join [Environment]::NewLine),
"",
"Active current check:",
($Rows | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Old scaffold files remaining in CURRENT root: $($OldCurrent.Count)",
($OldCurrent | Select-Object Name,FullName | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Unexpected root items remaining: $($UnexpectedRoot.Count)",
($UnexpectedRoot | Select-Object Name,FullName | Format-Table -Auto | Out-String).TrimEnd(),
"",
"Boundary: local-only; no Git; no public export; moved old scaffold to custody, not deleted; active two-file CURRENT preserved.",
"Verdict: $(if($OldCurrent.Count -eq 0 -and $UnexpectedRoot.Count -eq 0 -and $BadHash.Count -eq 0){"PASS / CHAT SOFT SUIT CURRENT IS CLEAN"}else{"REVIEW / CLEANUP STILL NEEDED"})"
) | Set-Content -LiteralPath $Receipt -Encoding UTF8

Get-Content -LiteralPath $Receipt -Raw

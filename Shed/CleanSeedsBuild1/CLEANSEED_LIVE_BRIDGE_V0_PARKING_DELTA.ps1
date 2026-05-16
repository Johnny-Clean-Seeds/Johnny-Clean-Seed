$ApprovedRoots = @(
    "$env:USERPROFILE\Desktop\Clean Milk not-BLOAT",
    "$env:USERPROFILE\Desktop\Shed"
)

$OutputRoot = "$env:USERPROFILE\Desktop\CleanSeed_LiveBridge_V0"
$MaxTextBytes = 262144

function Get-V0Hash($Path) {
    try { (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash }
    catch { "HASH_ERROR" }
}

function Get-V0Rel($Root, $Path) {
    $r = [IO.Path]::GetFullPath($Root).TrimEnd('\')
    $p = [IO.Path]::GetFullPath($Path)
    if ($p.StartsWith($r, [StringComparison]::OrdinalIgnoreCase)) {
        return $p.Substring($r.Length).TrimStart('\')
    }
    return $p
}

function Get-V0Mode($File) {
    $blocked = @(".exe",".dll",".bat",".cmd",".ps1",".lnk",".url",".zip",".7z",".rar",".png",".jpg",".jpeg",".gif",".webp",".ico",".mp3",".mp4",".pdf",".docx",".xlsx",".pptx",".db",".bin")
    $text = @(".txt",".md",".json",".csv",".log",".yaml",".yml",".xml",".html",".css",".lua",".py",".js",".ts",".ini",".cfg",".conf")

    $ext = $File.Extension.ToLowerInvariant()

    if ($File.Length -gt $MaxTextBytes) { return "METADATA_ONLY_SIZE_CAP" }
    if ($File.Name -match '(?i)(secret|password|token|api[_-]?key|private[_-]?key|credential|cookie|session)') { return "METADATA_ONLY_SUSPICIOUS_NAME" }
    if ($blocked -contains $ext) { return "METADATA_ONLY_BLOCKED_TYPE" }
    if ($text -contains $ext) { return "TEXT_INCLUDED" }

    return "METADATA_ONLY_UNKNOWN_TYPE"
}

function Read-V0Text($Path) {
    try {
        $bytes = [IO.File]::ReadAllBytes($Path)
        $n = [Math]::Min($bytes.Length, 4096)
        for ($i = 0; $i -lt $n; $i++) {
            if ($bytes[$i] -eq 0) { return "[CONTENT BLOCKED: binary/null byte detected]" }
        }
        $utf8 = New-Object Text.UTF8Encoding($false, $false)
        return $utf8.GetString($bytes)
    }
    catch {
        return "[CONTENT READ ERROR]"
    }
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$StateDir = Join-Path $OutputRoot "STATE"
$RunDir = Join-Path $OutputRoot "RUN_$Stamp"
$StatePath = Join-Path $StateDir "LAST_MANIFEST.json"

New-Item -ItemType Directory -Force -Path $StateDir | Out-Null
New-Item -ItemType Directory -Force -Path $RunDir | Out-Null

$Prev = @{}
$HadPrev = $false

if (Test-Path -LiteralPath $StatePath -PathType Leaf) {
    try {
        $Old = Get-Content -LiteralPath $StatePath -Raw | ConvertFrom-Json
        foreach ($x in $Old.Files) { $Prev[[string]$x.Key] = $x }
        $HadPrev = $true
    }
    catch {
        $HadPrev = $false
    }
}

$Records = @()
$CurrentKeys = New-Object 'System.Collections.Generic.HashSet[string]'
$Labels = @("PROJECT","SHED")

for ($i = 0; $i -lt $ApprovedRoots.Count; $i++) {
    $Root = $ApprovedRoots[$i]
    $Label = $Labels[$i]

    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        $Records += [pscustomobject]@{
            Key="$Label|__ROOT_MISSING__"; RootLabel=$Label; RelativePath="__ROOT_MISSING__"; FullPath="";
            SizeBytes=0; ModifiedUtc=""; SHA256=""; Mode="ROOT_MISSING"; Status="ROOT_MISSING"
        }
        continue
    }

    $Files = Get-ChildItem -LiteralPath $Root -Recurse -File -Force -ErrorAction SilentlyContinue

    foreach ($File in $Files) {
        $Rel = Get-V0Rel $Root $File.FullName
        $Key = "$Label|$Rel"
        [void]$CurrentKeys.Add($Key)

        $Hash = Get-V0Hash $File.FullName
        $Mode = Get-V0Mode $File

        $Status = "BASELINE"
        if ($HadPrev) {
            if (-not $Prev.ContainsKey($Key)) { $Status = "NEW" }
            elseif ([string]$Prev[$Key].SHA256 -ne [string]$Hash) { $Status = "CHANGED" }
            else { $Status = "UNCHANGED" }
        }

        $Records += [pscustomobject]@{
            Key=$Key; RootLabel=$Label; RelativePath=$Rel; FullPath=$File.FullName;
            SizeBytes=$File.Length; ModifiedUtc=$File.LastWriteTimeUtc.ToString("o");
            SHA256=$Hash; Mode=$Mode; Status=$Status
        }
    }
}

if ($HadPrev) {
    foreach ($OldKey in $Prev.Keys) {
        if (-not $CurrentKeys.Contains($OldKey)) {
            $Old = $Prev[$OldKey]
            $Records += [pscustomobject]@{
                Key=[string]$Old.Key; RootLabel=[string]$Old.RootLabel; RelativePath=[string]$Old.RelativePath; FullPath=[string]$Old.FullPath;
                SizeBytes=[int64]$Old.SizeBytes; ModifiedUtc=[string]$Old.ModifiedUtc; SHA256=[string]$Old.SHA256;
                Mode="METADATA_ONLY_MISSING"; Status="MISSING"
            }
        }
    }
}

$Current = @($Records | Where-Object { $_.Status -ne "MISSING" -and $_.Status -ne "ROOT_MISSING" } | Sort-Object RootLabel, RelativePath)

$Manifest = [pscustomobject]@{
    Tool="CLEANSEED_LIVE_BRIDGE_V0"
    Generated=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz")
    ApprovedRoots=$ApprovedRoots
    Files=$Current
}

$ManifestPath = Join-Path $RunDir "PARKING_LOT_MANIFEST.json"
$ReportPath = Join-Path $RunDir "DELTA_REPORT.txt"
$BundlePath = Join-Path $RunDir "CHATGPT_DELTA_UPLOAD_BUNDLE.txt"
$ReceiptPath = Join-Path $RunDir "BRIDGE_V0_RECEIPT.txt"

$Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $ManifestPath -Encoding UTF8
$Manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $StatePath -Encoding UTF8

if (-not $HadPrev) {
    $Delta = @()
}
else {
    $Delta = @($Records | Where-Object { $_.Status -eq "NEW" -or $_.Status -eq "CHANGED" -or $_.Status -eq "MISSING" } | Sort-Object RootLabel, RelativePath)
}

$New = @($Records | Where-Object { $_.Status -eq "NEW" })
$Changed = @($Records | Where-Object { $_.Status -eq "CHANGED" })
$Missing = @($Records | Where-Object { $_.Status -eq "MISSING" })
$TextCount = @($Current | Where-Object { $_.Mode -eq "TEXT_INCLUDED" }).Count
$BlockedCount = @($Current | Where-Object { $_.Mode -ne "TEXT_INCLUDED" }).Count

$Report = @()
$Report += "CLEAN SEED LIVE BRIDGE V0 — DELTA REPORT"
$Report += "Generated: $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz'))"
$Report += ""
$Report += "COUNTS:"
$Report += "- Previous manifest existed: $HadPrev"
$Report += "- Total current files: $($Current.Count)"
$Report += "- Text-includable current files: $TextCount"
$Report += "- Metadata-only / blocked current files: $BlockedCount"
$Report += "- New files: $($New.Count)"
$Report += "- Changed files: $($Changed.Count)"
$Report += "- Missing files: $($Missing.Count)"
$Report += "- Delta records in bundle: $($Delta.Count)"
$Report += ""
$Report += "OUTPUTS:"
$Report += "- Parking manifest: $ManifestPath"
$Report += "- Delta report: $ReportPath"
$Report += "- ChatGPT delta upload bundle: $BundlePath"
$Report += "- Receipt: $ReceiptPath"
$Report += ""
$Report += "BOUNDARIES:"
$Report += "- Files deleted: NO"
$Report += "- Files moved: NO"
$Report += "- Files renamed: NO"
$Report += "- Project files edited: NO"
$Report += "- ACTIVE_GUIDES edited: NO"
$Report += "- CURRENT_TRUTH_INDEX edited: NO"
$Report += "- OpenAI/API call: NO"
$Report += "- Public URL created: NO"
$Report += ""
if (-not $HadPrev) {
    $Report += "VERDICT: BASELINE CREATED — no delta exported yet."
    $Report += "NEXT: add or edit one small .txt file inside an approved root, then run V0 again."
}
else {
    $Report += "VERDICT: DELTA CREATED."
    $Report += "NEXT: upload CHATGPT_DELTA_UPLOAD_BUNDLE.txt for review."
}
$Report | Set-Content -LiteralPath $ReportPath -Encoding UTF8

$Bundle = @()
$Bundle += "CLEAN SEED LIVE BRIDGE V0 — CHATGPT DELTA UPLOAD BUNDLE"
$Bundle += "Generated: $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz'))"
$Bundle += "Run folder: $RunDir"
$Bundle += ""
$Bundle += "CLEAN RULE: Parking is not promotion. Detection is not approval. Delta is not truth. User is final authority."
$Bundle += ""
$Bundle += "COUNTS:"
$Bundle += "- Previous manifest existed: $HadPrev"
$Bundle += "- Total current files: $($Current.Count)"
$Bundle += "- Text-includable current files: $TextCount"
$Bundle += "- Metadata-only / blocked current files: $BlockedCount"
$Bundle += "- New files: $($New.Count)"
$Bundle += "- Changed files: $($Changed.Count)"
$Bundle += "- Missing files: $($Missing.Count)"
$Bundle += "- Delta records in this bundle: $($Delta.Count)"
$Bundle += ""
$Bundle += "DELTA MANIFEST:"

if ($Delta.Count -eq 0) {
    $Bundle += "NO_DELTA_RECORDS"
}
else {
    foreach ($Item in $Delta) {
        $Bundle += "$($Item.Status) | $($Item.RootLabel) | $($Item.RelativePath) | size=$($Item.SizeBytes) | mode=$($Item.Mode) | sha256=$($Item.SHA256)"
    }
}

$Bundle += ""
$Bundle += "INCLUDED TEXT CONTENT:"

foreach ($Item in $Delta) {
    if ($Item.Mode -eq "TEXT_INCLUDED" -and $Item.Status -ne "MISSING") {
        $Bundle += ""
        $Bundle += "----- BEGIN FILE -----"
        $Bundle += "STATUS: $($Item.Status)"
        $Bundle += "ROOT: $($Item.RootLabel)"
        $Bundle += "RELATIVE_PATH: $($Item.RelativePath)"
        $Bundle += "SHA256: $($Item.SHA256)"
        $Bundle += "----- CONTENT -----"
        $Bundle += (Read-V0Text $Item.FullPath)
        $Bundle += "----- END FILE -----"
    }
}

$Bundle | Set-Content -LiteralPath $BundlePath -Encoding UTF8

$Receipt = @()
$Receipt += "CLEAN SEED LIVE BRIDGE V0 — RECEIPT"
$Receipt += "Generated: $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz'))"
$Receipt += "Run folder: $RunDir"
$Receipt += "Parking manifest: $ManifestPath"
$Receipt += "Delta report: $ReportPath"
$Receipt += "ChatGPT delta upload bundle: $BundlePath"
$Receipt += "Files deleted: NO"
$Receipt += "Files moved: NO"
$Receipt += "Files renamed: NO"
$Receipt += "Project files edited: NO"
$Receipt += "OpenAI/API call: NO"
$Receipt += "Public URL created: NO"
$Receipt | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

Write-Host "============================================================"
Write-Host "CLEAN SEED LIVE BRIDGE V0 COMPLETE"
Write-Host "============================================================"
Write-Host "Run folder: $RunDir"
Write-Host "Total current files: $($Current.Count)"
Write-Host "New: $($New.Count) | Changed: $($Changed.Count) | Missing: $($Missing.Count)"
Write-Host "Delta records in bundle: $($Delta.Count)"
Write-Host ""
Write-Host "UPLOAD THIS ONLY WHEN YOU WANT CHATGPT TO REVIEW THE DELTA:"
Write-Host $BundlePath
Write-Host ""
if (-not $HadPrev) {
    Write-Host "VERDICT: BASELINE CREATED. Add/edit one small safe text file, then run V0 again."
}
else {
    Write-Host "VERDICT: DELTA CREATED."
}
Write-Host "============================================================"

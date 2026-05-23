& {
    $ErrorActionPreference = "Stop"

    $Repo = "$env:USERPROFILE\Desktop\Jxhnny_Kleen_C3dz"
    $ZipName = "SAM_REVIEW_CHILD_SHELL_RECURSIVE_CORE_PACKET_20260521.zip"
    $ExpectedZipSha256 = "62FA95B55CB8B8F52B5D39EFEC002957BFB6D7489B304C6499F9C4D234A6056C"
    $DestRel = "PUBLIC_PROOF_PACKETS\SAM_REVIEW_CHILD_SHELL_RECURSIVE_CORE_PACKET_20260521"
    $StatusFile = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $AnchorFile = "ACTIVE_ANCHOR.txt"
    $ReceiptRel = "PROOF_HISTORY\SAM_REVIEW_CHILD_SHELL_RECURSIVE_CORE_PACKET_SAVE_RECEIPT_20260521.txt"

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Lock Sam review packet to Mr.Kleen git."
    Write-Host "Boundary: packet placement + status/anchor + receipt only. No doctrine install. No ACTIVE_GUIDES rewrite. No CURRENT_TRUTH_INDEX rewrite. No bridge permission expansion."
    Write-Host ""

    if (-not (Test-Path -LiteralPath $Repo)) {
        throw "STOP. Repo not found: $Repo"
    }

    Set-Location $Repo

    if (-not (Test-Path ".git")) {
        throw "STOP. Not in git repo: $Repo"
    }

    if ((git branch --show-current).Trim() -ne "main") {
        throw "STOP. Wrong branch. Expected main."
    }

    $StatusBefore = @(git status --short)
    if ($StatusBefore.Count -gt 0) {
        Write-Host "Dirty state before save:"
        $StatusBefore | ForEach-Object { Write-Host $_ }
        throw "STOP. Repo must be clean before locking review packet."
    }

    $HeadBefore = (git rev-parse HEAD).Trim()
    $ShortBefore = (git rev-parse --short HEAD).Trim()

    $CandidateZips = @(
        (Join-Path "$env:USERPROFILE\Desktop\123" $ZipName),
        (Join-Path "$env:USERPROFILE\Downloads" $ZipName),
        (Join-Path "$env:USERPROFILE\Desktop" $ZipName)
    )

    $ZipSource = $null
    foreach ($Candidate in $CandidateZips) {
        if (Test-Path -LiteralPath $Candidate) {
            $ZipSource = $Candidate
            break
        }
    }

    if ($null -eq $ZipSource) {
        Write-Host "Looked for:"
        $CandidateZips | ForEach-Object { Write-Host $_ }
        throw "STOP. Sam review packet ZIP not found. Download it to Desktop\123 or Downloads first."
    }

    $ZipHash = (Get-FileHash -LiteralPath $ZipSource -Algorithm SHA256).Hash
    if ($ZipHash -ne $ExpectedZipSha256) {
        throw "STOP. ZIP hash mismatch. Expected $ExpectedZipSha256 but got $ZipHash at $ZipSource"
    }

    if (Test-Path -LiteralPath $DestRel) {
        throw "STOP. Destination already exists, not overwriting: $DestRel"
    }

    New-Item -ItemType Directory -Force -Path $DestRel | Out-Null

    $ZipDest = Join-Path $DestRel $ZipName
    Copy-Item -LiteralPath $ZipSource -Destination $ZipDest -Force

    $UnpackedDest = Join-Path $DestRel "UNPACKED"
    New-Item -ItemType Directory -Force -Path $UnpackedDest | Out-Null
    Expand-Archive -LiteralPath $ZipDest -DestinationPath $UnpackedDest -Force

    $UnpackedCount = @(Get-ChildItem -LiteralPath $UnpackedDest -Recurse -File).Count

    Add-Content -LiteralPath $StatusFile -Encoding UTF8 -Value @(
        "",
        "---",
        "",
        "## Sam Review Packet - Child Shell + Recursive Core",
        "",
        "Status: PACKET LOCKED TO GIT",
        "Date: 2026-05-21",
        "Base before save: main @ $ShortBefore",
        "",
        "Packet:",
        "$DestRel",
        "",
        "Meaning:",
        "Public-review packet for Child Shell, Recursive Core Architecture, LocalBot machine evidence, and doctrine visuals.",
        "",
        "ZIP SHA256:",
        "$ZipHash",
        "",
        "Boundary:",
        "No doctrine install, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no bridge permission expansion."
    )

    Set-Content -LiteralPath $AnchorFile -Encoding UTF8 -Value @(
        "# ACTIVE ANCHOR",
        "",
        "Recorded base before this save:",
        "main @ $ShortBefore",
        "",
        "Current active ball:",
        "Sam review packet for Child Shell + Recursive Core Architecture has been locked to git as a public-review proof packet.",
        "",
        "Next allowed move:",
        "Choose public review route, or run next bridge hardening test. Do not expand bridge power without separate proof.",
        "",
        "Blocked moves:",
        "- Do not call this production-security proof.",
        "- Do not install doctrine from the packet.",
        "- Do not rewrite ACTIVE_GUIDES.",
        "- Do not rewrite CURRENT_TRUTH_INDEX.",
        "- Do not expand bridge permissions.",
        "- Do not expose private paths beyond what the packet intentionally contains."
    )

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $ReceiptRel) | Out-Null

    $DestZipHash = (Get-FileHash -LiteralPath $ZipDest -Algorithm SHA256).Hash
    $StatusHash = (Get-FileHash -LiteralPath $StatusFile -Algorithm SHA256).Hash
    $AnchorHash = (Get-FileHash -LiteralPath $AnchorFile -Algorithm SHA256).Hash

    Set-Content -LiteralPath $ReceiptRel -Encoding UTF8 -Value @(
        "SAM REVIEW CHILD SHELL RECURSIVE CORE PACKET SAVE RECEIPT",
        "Date: $(Get-Date -Format o)",
        "",
        "Verdict: PACKET LOCKED TO GIT",
        "",
        "Base before save:",
        "$HeadBefore",
        "",
        "Packet destination:",
        "$DestRel",
        "",
        "ZIP source:",
        "$ZipSource",
        "",
        "ZIP destination:",
        "$ZipDest",
        "",
        "ZIP SHA256:",
        "$DestZipHash",
        "",
        "Unpacked destination:",
        "$UnpackedDest",
        "",
        "Unpacked file count:",
        "$UnpackedCount",
        "",
        "Status file:",
        "$StatusFile",
        "Status SHA256:",
        "$StatusHash",
        "",
        "Anchor file:",
        "$AnchorFile",
        "Anchor SHA256:",
        "$AnchorHash",
        "",
        "Boundary:",
        "Public review packet only; no doctrine install; no ACTIVE_GUIDES rewrite; no CURRENT_TRUTH_INDEX rewrite; no bridge permission expansion; no production-security claim."
    )

    $ReceiptHash = (Get-FileHash -LiteralPath $ReceiptRel -Algorithm SHA256).Hash

    git add -- $DestRel $StatusFile $AnchorFile
    if ($LASTEXITCODE -ne 0) { throw "STOP. git add failed." }

    git add -f -- $ReceiptRel
    if ($LASTEXITCODE -ne 0) { throw "STOP. git add -f receipt failed." }

    git commit -m "Add child shell recursive core review packet"
    if ($LASTEXITCODE -ne 0) { throw "STOP. git commit failed." }

    git push origin main
    if ($LASTEXITCODE -ne 0) { throw "STOP. git push failed." }

    git fetch origin main | Out-Null

    $HeadAfter = (git rev-parse HEAD).Trim()
    $OriginAfter = (git rev-parse origin/main).Trim()
    $ShortAfter = (git rev-parse --short HEAD).Trim()
    $StatusAfter = @(git status --short)

    if ($HeadAfter -ne $OriginAfter) {
        throw "STOP. HEAD does not match origin/main after push."
    }

    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
    Write-Host "SAM REVIEW PACKET LOCKED TO GIT"
    Write-Host "Verdict: SAVED AND PUSHED"
    Write-Host "Packet: $DestRel"
    Write-Host "ZIP SHA256: $DestZipHash"
    Write-Host "Unpacked file count: $UnpackedCount"
    Write-Host "Receipt: $ReceiptRel"
    Write-Host "Receipt SHA256: $ReceiptHash"
    Write-Host "Commit: $ShortAfter"
    Write-Host "HEAD: $HeadAfter"
    Write-Host "origin/main: $OriginAfter"
    if ($StatusAfter.Count -gt 0) {
        Write-Host "Repo status after: NOT CLEAN"
        $StatusAfter | ForEach-Object { Write-Host $_ }
    } else {
        Write-Host "Repo status after: clean"
    }
    Write-Host "Boundary: public review packet only; no doctrine install; no ACTIVE_GUIDES/CURRENT_TRUTH_INDEX rewrite; no bridge permission expansion."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
}
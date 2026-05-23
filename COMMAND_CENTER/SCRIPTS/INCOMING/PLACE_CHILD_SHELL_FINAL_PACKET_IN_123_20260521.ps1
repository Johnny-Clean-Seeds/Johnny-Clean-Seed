& {
    $ErrorActionPreference = "Stop"

    $Root123 = "$env:USERPROFILE\Desktop\123"
    $ZipName = "CHILD_SHELL_FINAL_CONCEPT_FORMULA_PROOF_PACKET_20260521.zip"
    $ExpectedZipSha256 = "42809833C1C1F257D3C8848B5B00DF0E9AA64A64D73CEF45598DC8CCEA4DE444"
    $PacketFolder = Join-Path $Root123 "CHILD_SHELL_FINAL_CONCEPT_FORMULA_PROOF_PACKET_20260521"
    $UnpackedFolder = Join-Path $PacketFolder "UNPACKED_FILES"
    $ReceiptFolder = Join-Path $PacketFolder "RECEIPTS"
    $ReceiptPath = Join-Path $ReceiptFolder "CHILD_SHELL_FINAL_PACKET_123_PLACEMENT_RECEIPT_20260521.txt"

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Place Child Shell final concept/formula/proof packet under Desktop\123."
    Write-Host "Boundary: local file placement only. No Mr.Kleen repo write. No git add/commit/push. No bridge permission expansion."
    Write-Host ""

    if (-not (Test-Path -LiteralPath $Root123)) {
        throw "STOP. Desktop\123 not found: $Root123"
    }

    if (Test-Path -LiteralPath $PacketFolder) {
        throw "STOP. Packet folder already exists, not overwriting: $PacketFolder"
    }

    $CandidateZips = @(
        (Join-Path $Root123 $ZipName),
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
        throw "STOP. Final packet ZIP not found. Download it first and put it in Desktop\123 or Downloads."
    }

    $ActualZipSha256 = (Get-FileHash -LiteralPath $ZipSource -Algorithm SHA256).Hash
    if ($ActualZipSha256 -ne $ExpectedZipSha256) {
        throw "STOP. ZIP hash mismatch. Expected $ExpectedZipSha256 but got $ActualZipSha256 at $ZipSource"
    }

    New-Item -ItemType Directory -Force -Path $PacketFolder, $UnpackedFolder, $ReceiptFolder | Out-Null

    $ZipInPacket = Join-Path $PacketFolder $ZipName
    Copy-Item -LiteralPath $ZipSource -Destination $ZipInPacket -Force

    Expand-Archive -LiteralPath $ZipInPacket -DestinationPath $UnpackedFolder -Force

    $UnpackedFiles = @(Get-ChildItem -LiteralPath $UnpackedFolder -File | Sort-Object Name)
    if ($UnpackedFiles.Count -lt 8) {
        throw "STOP. Too few unpacked files. Expected packet contents, got $($UnpackedFiles.Count)."
    }

    $ZipInPacketSha256 = (Get-FileHash -LiteralPath $ZipInPacket -Algorithm SHA256).Hash

    $Lines = New-Object System.Collections.Generic.List[string]
    $Lines.Add("CHILD SHELL FINAL PACKET 123 PLACEMENT RECEIPT") | Out-Null
    $Lines.Add("Date: $(Get-Date -Format o)") | Out-Null
    $Lines.Add("") | Out-Null
    $Lines.Add("Verdict: PLACED") | Out-Null
    $Lines.Add("") | Out-Null
    $Lines.Add("Boundary: local file placement only; no Mr.Kleen repo write; no git add/commit/push; no bridge permission expansion.") | Out-Null
    $Lines.Add("") | Out-Null
    $Lines.Add("Root 123: $Root123") | Out-Null
    $Lines.Add("Packet folder: $PacketFolder") | Out-Null
    $Lines.Add("ZIP source: $ZipSource") | Out-Null
    $Lines.Add("ZIP copied to: $ZipInPacket") | Out-Null
    $Lines.Add("ZIP SHA256: $ZipInPacketSha256") | Out-Null
    $Lines.Add("Unpacked folder: $UnpackedFolder") | Out-Null
    $Lines.Add("") | Out-Null
    $Lines.Add("Unpacked files:") | Out-Null

    foreach ($File in $UnpackedFiles) {
        $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash
        $Lines.Add("- $($File.Name) | SHA256: $Hash") | Out-Null
    }

    $Lines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
    $ReceiptSha256 = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
    Write-Host "CHILD SHELL FINAL PACKET PLACED IN 123"
    Write-Host "Verdict: PLACED"
    Write-Host "Packet folder: $PacketFolder"
    Write-Host "ZIP source: $ZipSource"
    Write-Host "ZIP copied to: $ZipInPacket"
    Write-Host "ZIP SHA256: $ZipInPacketSha256"
    Write-Host "Unpacked folder: $UnpackedFolder"
    Write-Host "Unpacked file count: $($UnpackedFiles.Count)"
    Write-Host "Receipt: $ReceiptPath"
    Write-Host "Receipt SHA256: $ReceiptSha256"
    Write-Host "Boundary: local 123 placement only; no Mr.Kleen repo write; no git add/commit/push; no bridge permission expansion."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
}
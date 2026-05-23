$ErrorActionPreference = "Stop"

$Url = "https://youtu.be/Dgbci0GC1vk?si=7crYcmEuPIr3tyAe"
$VideoId = "Dgbci0GC1vk"
$Title = "Inside a Jumping Spider's Brain | ScienceTake | The New York Times"

$Root123 = Join-Path $env:USERPROFILE "Desktop\123"
$Base = Join-Path $Root123 "YT_TRANSCRIPTS\$VideoId"
$Raw = Join-Path $env:USERPROFILE "Desktop\YOUTUBE_TRANSCRIPT_$VideoId"
$Chunks = Join-Path $Base "CHUNKS"

New-Item -ItemType Directory -Force -Path $Base,$Raw,$Chunks | Out-Null

Get-ChildItem $Raw -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Extension -in ".srt",".vtt" } |
    Remove-Item -Force -ErrorAction SilentlyContinue

yt-dlp --skip-download --write-auto-subs --write-subs --sub-lang "en.*,en" --convert-subs srt -o "$Raw\video.%(ext)s" $Url

$Subs = Get-ChildItem $Raw -File |
    Where-Object { $_.Extension -in ".srt",".vtt" } |
    Sort-Object Length -Descending

if (-not $Subs) { throw "No subtitle files found for $VideoId" }

$Best = $Subs | Select-Object -First 1
$Text = Get-Content $Best.FullName -Raw
if ([string]::IsNullOrWhiteSpace($Text)) { throw "Subtitle source empty: $($Best.FullName)" }

$Lines = $Text -split "`r?`n" |
    Where-Object {
        $_ -and
        $_ -notmatch '^\d+$' -and
        $_ -notmatch '^\d{2}:\d{2}:\d{2}[,.]\d{3}\s+-->\s+\d{2}:\d{2}:\d{2}[,.]\d{3}' -and
        $_ -notmatch '^WEBVTT|^Kind:|^Language:'
    } |
    ForEach-Object {
        ($_ -replace '<[^>]+>','' `
            -replace '&amp;','&' `
            -replace '&lt;','<' `
            -replace '&gt;','>' `
            -replace '&quot;','"' `
            -replace '&#39;',"'").Trim()
    }

$Clean = New-Object System.Collections.Generic.List[string]
$Prev = ""
foreach ($L in $Lines) {
    $T = ($L -replace '\s+',' ').Trim()
    if ($T -and $T -ne $Prev) {
        $Clean.Add($T)
        $Prev = $T
    }
}

$CleanText = (($Clean -join " ") -replace '\s+',' ').Trim()
if ($CleanText.Length -lt 200) { throw "Clean transcript too short: $($CleanText.Length) chars" }

$Full = Join-Path $Base "TRANSCRIPT_CLEAN_FULL_$VideoId.txt"
$Receipt = Join-Path $Base "TRANSCRIPT_FULL_RECEIPT_$VideoId.txt"
$Note = Join-Path $Base "SOURCE_INTAKE_NOTE_$VideoId.txt"

Remove-Item (Join-Path $Chunks "*") -Force -ErrorAction SilentlyContinue

$CleanText | Set-Content $Full -Encoding UTF8

@"
SOURCE INTAKE NOTE
VIDEO ID: $VideoId
URL: $Url
TITLE SEEN BY CHATGPT: $Title
INITIAL ROUTE: source-safe transcript capture only.
PROBABLE LANE: spider cognition / tiny brain computation / sensory processing / embodied intelligence / biological decision systems source ore.
USE BOUNDARY: inspect for useful ideas about small-brain cognition, perception-action loops, neural economy, prediction, attention, embodied agency, and compact intelligence. Do not promote. Do not treat as doctrine. Do not treat as medical advice. Park until dissection.
"@ | Set-Content $Note -Encoding UTF8

$i = 1
$ChunkSize = 12000
for ($p = 0; $p -lt $CleanText.Length; $p += $ChunkSize) {
    $Len = [Math]::Min($ChunkSize, $CleanText.Length - $p)
    $ChunkPath = Join-Path $Chunks ("TRANSCRIPT_CHUNK_{0:D3}_$VideoId.txt" -f $i)
    $CleanText.Substring($p,$Len) | Set-Content $ChunkPath -Encoding UTF8
    $i++
}

$SourceHash = (Get-FileHash -Algorithm SHA256 $Best.FullName).Hash
$FullHash = (Get-FileHash -Algorithm SHA256 $Full).Hash
$NoteHash = (Get-FileHash -Algorithm SHA256 $Note).Hash

@(
    "VIDEO ID: $VideoId",
    "URL: $Url",
    "TITLE SEEN BY CHATGPT: $Title",
    "SOURCE USED: $($Best.FullName)",
    "SOURCE BYTES: $($Best.Length)",
    "SOURCE SHA256: $SourceHash",
    "FULL CLEAN TRANSCRIPT: $Full",
    "FULL CLEAN CHARACTERS: $($CleanText.Length)",
    "FULL CLEAN SHA256: $FullHash",
    "SOURCE INTAKE NOTE: $Note",
    "SOURCE INTAKE NOTE SHA256: $NoteHash",
    "CHUNKS CREATED: $($i-1)",
    "VERDICT: PASS - JUMPING SPIDER BRAIN SOURCE TRANSCRIPT CAPTURED",
    "BOUNDARY: Desktop 123 only; no Mr.Kleen repo write; no git; no doctrine promotion."
) | Set-Content $Receipt -Encoding UTF8

Write-Host "PASS - JUMPING SPIDER BRAIN SOURCE TRANSCRIPT CAPTURED"
Write-Host "Base: $Base"
Write-Host "Full transcript: $Full"
Write-Host "Source note: $Note"
Write-Host "Receipt: $Receipt"
Write-Host "Full SHA256: $FullHash"

$ErrorActionPreference = "Stop"

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"

$DropFileName = "CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$DesktopDrop = Join-Path $env:USERPROFILE "Desktop\$DropFileName"
$Desktop123Drop = Join-Path $env:USERPROFILE "Desktop\123\$DropFileName"

if (-not (Test-Path -LiteralPath $Repo)) {
    throw "Repo not found: $Repo"
}

Set-Location -LiteralPath $Repo

if (-not (Test-Path -LiteralPath ".git")) {
    throw "Not in a git repo: $Repo"
}

$DirtyBefore = git status --short
if ($DirtyBefore) {
    Write-Host "BLOCKED - REPO NOT CLEAN"
    Write-Host "Dirty status before save:"
    $DirtyBefore | ForEach-Object { Write-Host $_ }
    exit 1
}

$OldHead = (git rev-parse HEAD).Trim()

$ProtocolPath = "BRAIN_LEARNING/CHAT_COCKPIT_DROP_COPY_EXPORT_PROTOCOL_20260522.md"
$CapturePath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/CHAT_COCKPIT_DROP_COPY_EXPORT_FRAMING_CAPTURE_20260522.md"
$CockpitPath = "HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md"
$ReceiptPath = "PROOF_HISTORY/CHAT_COCKPIT_DROP_COPY_EXPORT_PROTOCOL_RECEIPT_20260522.txt"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"

New-Item -ItemType Directory -Force -Path (Split-Path $ProtocolPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $CapturePath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $CockpitPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $ReceiptPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $StatusPath) | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $Desktop123Drop) | Out-Null

$Protocol = @"
# Chat Cockpit Drop-Copy Export Protocol — 20260522

## Status

Type: chat cockpit visibility/export protocol.

Boundary:
- This is not a doctrine promotion.
- This is not an active guide rewrite.
- This is not a CURRENT_TRUTH_INDEX rewrite.
- This is not automation.
- This does not create new house rules by itself.
- This does not replace the canonical project file.
- This does not make Desktop the authority source.

## Framing

The chat cockpit/drop-copy is not a new house-rule generator.

Its job is to bring already-relevant assistant-facing project rules closer to the live chat so the assistant obeys them more reliably.

It is a visibility and obedience cockpit card.

It is not:
- doctrine
- authority replacement
- new-rule promotion
- house replacement
- proof bypass
- source of new rules by itself

## Problem Fixed

The chat cockpit/card was updated in the project repo, but no clearly labeled Desktop drop-copy appeared for the user to drag/drop into chat.

That leaves the cockpit hidden.

A chat-facing file must be easy to find, clearly labeled as CHAT, and available where the user can use it.

## Core Protocol

When the chat cockpit/card is updated, export the current cockpit file to:

1. Canonical project file:
   HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

2. Desktop chat drop-copy:
   C:\Users\<user>\Desktop\CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

3. Desktop\123 chat transfer copy:
   C:\Users\<user>\Desktop\123\CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

## Naming Rule

The user-facing drop-copy must include CHAT in the filename.

Use:

CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

Reason:

The filename itself must show this is the file to drop into chat.

## Authority Split

Repo copy:
Canonical saved project file.

Desktop drop-copy:
User-facing transport file for dragging/dropping into chat.

Desktop\123 copy:
Source pickup / transfer support copy.

The copies serve different jobs.

Do not confuse them.

## Completion Rule

A cockpit update is incomplete if:

- repo cockpit is updated but no Desktop drop-copy exists;
- Desktop copy is not clearly labeled as CHAT;
- the file is framed as creating new house rules;
- the user cannot tell what file to drop into chat.

## Short Form

If chat cockpit changes, export a clearly labeled CHAT drop-copy to Desktop and Desktop\123.

It obeys closer.
It does not start making new house rules.
"@

$Capture = @"
# Chat Cockpit Drop-Copy Export Framing Capture — 20260522

## Status

Type: correction capture / framing capture.

Boundary:
- Capture only.
- No doctrine promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No automation.

## Trigger

The user asked where the chat log/card was after the cockpit update, because it needs to appear on Desktop so it can be dropped into chat.

The user also clarified that the file must be labeled as CHAT and framed correctly.

## Founding Original / Source Root

User correction included:

- "wheres the chat log at that needs to appear on desktp when you update so i can drop into chat"
- "also in files"
- "be sure to label chat as chat so its understood"
- "it doesnt start making ne w house rules but obeys closer"
- "make sure the framing is right"

## Clean Translation

When the assistant updates the chat cockpit/card:

1. keep the canonical copy in the project files;
2. export a clearly labeled CHAT drop-copy to Desktop;
3. export a clearly labeled CHAT transfer copy to Desktop\123 when useful;
4. frame the card as an obedience/visibility cockpit, not a new-house-rule generator.

## Failure Pattern

The assistant updated repo state but did not complete the user-handling path.

The user should not need to dig through project folders to find the chat drop-copy.

## Repair

This protocol saves the framing and exports the current cockpit card to:

- Desktop
- Desktop\123

using an explicit CHAT_DROP_COPY filename.
"@

Set-Content -LiteralPath $ProtocolPath -Value $Protocol -Encoding UTF8
Set-Content -LiteralPath $CapturePath -Value $Capture -Encoding UTF8

if (Test-Path -LiteralPath $CockpitPath) {
    $CockpitText = Get-Content -LiteralPath $CockpitPath -Raw
} else {
    $CockpitText = @"
# Chat House Rules Cockpit Card — Applied Version — 20260522

## Status

Type: in-chat assistant operating card / cockpit sheet.

Purpose: hold assistant-facing project rules close enough to use during live work.

Boundary:
- This does not replace Mr.Kleen.
- This does not rewrite doctrine.
- This does not promote new doctrine.
- This is a working cockpit card for chat behavior.
"@
}

$Marker = "## 2.24 Chat Cockpit Drop-Copy Export Protocol"
$Addendum = @"

---

$Marker

This cockpit card is not a new-house-rule generator.

Its job is to bring already-relevant assistant-facing project rules closer to the live chat so the assistant obeys them more reliably.

When this cockpit card is updated, the updated file must also be exported as clearly labeled CHAT drop-copies.

Canonical saved project file:
HOUSE_WORK/CHAT_COCKPIT/CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

Desktop chat drop-copy:
C:\Users\<user>\Desktop\CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

Desktop\123 chat transfer copy:
C:\Users\<user>\Desktop\123\CHAT_DROP_COPY__CHAT_HOUSE_RULES_COCKPIT_CARD_APPLIED_20260522.md

Blocked:
- do not frame this card as doctrine;
- do not frame it as creating new house rules by itself;
- do not update repo cockpit without creating the visible Desktop CHAT drop-copy;
- do not leave the user guessing which file belongs in chat.

Short form:
If chat cockpit changes, export a clearly labeled CHAT drop-copy. It obeys closer; it does not start making new house rules.
"@

if ($CockpitText -notlike "*$Marker*") {
    Set-Content -LiteralPath $CockpitPath -Value ($CockpitText.TrimEnd() + $Addendum) -Encoding UTF8
} else {
    $Pattern = [regex]::Escape($Marker) + ".*?(?=\r?\n---\r?\n|\z)"
    $NewCockpit = [regex]::Replace($CockpitText, $Pattern, $Addendum.TrimStart(), [System.Text.RegularExpressions.RegexOptions]::Singleline)
    Set-Content -LiteralPath $CockpitPath -Value $NewCockpit -Encoding UTF8
}

Copy-Item -LiteralPath $CockpitPath -Destination $DesktopDrop -Force
Copy-Item -LiteralPath $CockpitPath -Destination $Desktop123Drop -Force

$ProtocolHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $ProtocolPath).Hash
$CaptureHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CapturePath).Hash
$CockpitHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $CockpitPath).Hash
$DesktopDropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $DesktopDrop).Hash
$Desktop123DropHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Desktop123Drop).Hash

$Receipt = @"
CHAT COCKPIT DROP-COPY EXPORT PROTOCOL RECEIPT — 20260522

Verdict:
PASS - CHAT COCKPIT DROP COPY EXPORT PROTOCOL SAVED

Old HEAD:
$OldHead

Saved project files:
$ProtocolPath
SHA256: $ProtocolHash

$CapturePath
SHA256: $CaptureHash

$CockpitPath
SHA256: $CockpitHash

Exported Desktop chat drop-copy:
$DesktopDrop
SHA256: $DesktopDropHash

Exported Desktop\123 chat transfer copy:
$Desktop123Drop
SHA256: $Desktop123DropHash

Boundary:
Chat-cockpit visibility/export protocol, cockpit addendum, and labeled CHAT drop-copy export only.
No doctrine promotion.
No active guide rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No automation.
No runtime change.
Does not create new house rules by itself.

Short form:
If chat cockpit changes, export a clearly labeled CHAT drop-copy.
It obeys closer; it does not start making new house rules.
"@

Set-Content -LiteralPath $ReceiptPath -Value $Receipt -Encoding UTF8

$StatusAppend = @"

## 20260522 — Chat Cockpit Drop-Copy Export Protocol

Position before commit: $OldHead

Saved:
- $ProtocolPath
- $CapturePath
- $CockpitPath
- $ReceiptPath

Exported:
- $DesktopDrop
- $Desktop123Drop

Verdict:
PASS - CHAT COCKPIT DROP COPY EXPORT PROTOCOL SAVED

Boundary:
Chat-cockpit visibility/export protocol, cockpit addendum, and labeled CHAT drop-copy export only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation. Does not create new house rules by itself.

Short form:
If chat cockpit changes, export a clearly labeled CHAT drop-copy. It obeys closer; it does not start making new house rules.
"@

Add-Content -LiteralPath $StatusPath -Value $StatusAppend -Encoding UTF8

git add -- $ProtocolPath $CapturePath $CockpitPath $StatusPath
git add -f -- $ReceiptPath

$Staged = git diff --cached --name-only
if (-not $Staged) {
    throw "No staged changes found; nothing to commit."
}

git commit -m "Add chat cockpit drop copy export protocol" | Out-Host
git push origin main | Out-Host

$NewHead = (git rev-parse HEAD).Trim()
$RemoteHead = (git rev-parse origin/main).Trim()
$FinalStatus = git status --short

if ($NewHead -ne $RemoteHead) {
    Write-Host "BLOCKED - REMOTE HEAD DOES NOT MATCH"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    exit 1
}

if ($FinalStatus) {
    Write-Host "BLOCKED - FINAL STATUS NOT CLEAN"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "New HEAD: $NewHead"
    Write-Host "Remote HEAD: $RemoteHead"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    exit 1
}

Write-Host "PASS - CHAT COCKPIT DROP COPY EXPORT PROTOCOL SAVED"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Cockpit repo file: $CockpitPath"
Write-Host "Desktop CHAT drop-copy: $DesktopDrop"
Write-Host "Desktop 123 CHAT copy: $Desktop123Drop"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Boundary: chat-cockpit visibility/export protocol, cockpit addendum, and labeled CHAT drop-copy export only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation; does not create new house rules by itself."

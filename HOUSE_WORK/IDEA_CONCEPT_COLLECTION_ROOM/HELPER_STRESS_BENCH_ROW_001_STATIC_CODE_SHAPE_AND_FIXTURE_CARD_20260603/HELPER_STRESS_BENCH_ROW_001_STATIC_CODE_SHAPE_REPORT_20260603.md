# Helper Stress Bench Row 001 Static Code Shape Report

Date: 20260603
RunId: 20260603_220810
Target: READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1
TargetPath: C:\Users\13527\Desktop\123\_TOOLS_AND_SCRIPTS\ROOT_LOOSE_HELPERS_20260603\READ_ONLY_INSPECT\READ_ONLY_INSPECT_ACTIVE_TASK_V0.ps1
TargetSha256: 343B84EC0F81A813829D4FFC059C7563AC5B0128021BB26B6D2DCF0E753F7B84
Verdict: REPAIR_BEFORE_RUN

## Boundary

This packet is static review only.

The target helper was not run.
The target helper was not dot-sourced.
The target helper was not imported.
No Git add, commit, push, reset, checkout, clean, or cleanup was performed by this review script.

## Repo State

Head: 50bf9f4404fc49b569472b20639785d12923aedf
OriginMain: 50bf9f4404fc49b569472b20639785d12923aedf
HeadEqualsOrigin: True

## Target Shape

Lines: 411
Bytes: 17455
ParseErrorCount: 0
FunctionCount: 5
ParamBlockCount: 6
AssignmentCount: 78
CommandCount: 84
MutationSurfaceCount: 2
ExecutionSurfaceCount: 0
ProtectedOrStateSurfaceCount: 4
PassSurfaceWordCount: 23

## Parse Errors

- none

## Command Surface

- line 41: New-Object -- New-Object System.Collections.Generic.List[string]
- line 42: New-Object -- New-Object System.Collections.Generic.List[object]
- line 43: New-Object -- New-Object System.Collections.Generic.List[string]
- line 44: New-Object -- New-Object System.Collections.Generic.List[string]
- line 73: Out-Null -- Out-Null
- line 92: ForEach-Object -- ForEach-Object { [string]$_ }
- line 104: Push-Location -- Push-Location $WorkDir
- line 105: git -- & git @GitArgs 2>$null
- line 107: Pop-Location -- Pop-Location
- line 109: ForEach-Object -- ForEach-Object { [string]$_ }
- line 111: Pop-Location -- Pop-Location
- line 119: Push-Location -- Push-Location $WorkDir
- line 120: git -- & git status --short 2>$null
- line 122: Pop-Location -- Pop-Location
- line 124: ForEach-Object -- ForEach-Object { [string]$_ }
- line 128: Pop-Location -- Pop-Location
- line 146: Test-Path -- Test-Path $BaseRoot -PathType Container
- line 147: Out-Null -- Out-Null
- line 150: Test-Path -- Test-Path $RepoRoot -PathType Container
- line 151: Out-Null -- Out-Null
- line 155: Read-GitValue -- Read-GitValue -WorkDir $RepoRoot -GitArgs @("rev-parse", "HEAD") -Fallback "[unavailable]"
- line 156: Read-GitValue -- Read-GitValue -WorkDir $RepoRoot -GitArgs @("rev-parse", "origin/main") -Fallback "[unavailable]"
- line 157: Read-GitStatusShort -- Read-GitStatusShort -WorkDir $RepoRoot
- line 161: Add-WarningObject -- Add-WarningObject `       -RawWarningText "ExpectedRepoHead does not match current HEAD. Expected=$ExpectedRepoHead Actual=$RepoHead" `       -WarningCategory "GIT_READ_STATUS_MISMATCH" `       -BlockerStatus "WATCH" `       -WhyThisCategory "The script is read-only and does not mutate Git, but the caller supplied a head expectation that does not match current state." `       -EvidenceUsed "git rev-parse HEAD returned $RepoHead." `       -WhatIsHappening "The repository has moved relative to the caller's expected head." `       -WhyItMatters "Inspect output may describe a newer or different state than the caller expected." `       -WhatItAffects "It affects confidence in time-sensitive inspection." `       -WhatItDoesNotAffect "It does not mutate files, write pointer state, or execute next actions." `       -SecondReviewRequired "NO unless the caller required exact head lock." `       -NextLegalAction "RETURN_INSPECT_CARD_WITH_HEAD_MISMATCH_WATCH"
- line 193: Test-Path -- Test-Path $PointerPath -PathType Leaf
- line 195: Get-Content -- Get-Content -Path $PointerPath -Raw
- line 196: Out-Null -- Out-Null
- line 197: Get-FileHash -- Get-FileHash $PointerPath -Algorithm SHA256
- line 198: ConvertFrom-Json -- ConvertFrom-Json
- line 200: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "PointerStatus"
- line 209: Add-WarningObject -- Add-WarningObject `       -RawWarningText "Pointer file exists but could not be parsed as JSON: $PointerPath" `       -WarningCategory "POINTER_PARSE_WARNING" `       -BlockerStatus "BLOCKING" `       -WhyThisCategory "A malformed pointer cannot be trusted for active task inspection." `       -EvidenceUsed $_.Exception.Message `       -WhatIsHappening "The pointer file was readable as text but not parseable as JSON." `       -WhyItMatters "The inspect command cannot safely resolve active task state from malformed pointer data." `       -WhatItAffects "It blocks active task inspection from pointer state." `       -WhatItDoesNotAffect "It does not mutate the pointer, repo, or files." `       -SecondReviewRequired "YES" `       -NextLegalAction "RUN_POINTER_REPAIR_ROUTE_SEPARATELY"
- line 223: Out-Null -- Out-Null
- line 224: Add-WarningObject -- Add-WarningObject `     -RawWarningText "Pointer file missing: $PointerPath" `     -WarningCategory "POINTER_STATE_ABSENT" `     -BlockerStatus "WATCH" `     -WhyThisCategory "Missing pointer is expected before pointer implementation exists. The correct read-only behavior is to return POINTER_MISSING_CARD, not to guess from transcript." `     -EvidenceUsed "Test-Path returned false for PointerPath." `     -WhatIsHappening "There is no active task pointer JSON file available to inspect." `     -WhyItMatters "The command cannot resolve ActiveLane, ActiveObject, or NextLegalAction from an official pointer." `     -WhatItAffects "It affects only active-task inspection detail." `     -WhatItDoesNotAffect "It does not affect repo status, command safety, or no-mutation proof." `     -SecondReviewRequired "NO" `     -NextLegalAction "RETURN_POINTER_MISSING_CARD"
- line 238: New-Object -- New-Object System.Collections.Generic.List[string]
- line 241: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name $Field
- line 243: Out-Null -- Out-Null
- line 249: Add-WarningObject -- Add-WarningObject `       -RawWarningText "Pointer is missing required fields: $($MissingFields -join ', ')" `       -WarningCategory "POINTER_REQUIRED_FIELD_WARNING" `       -BlockerStatus "BLOCKING" `       -WhyThisCategory "The pointer exists but lacks fields required for safe active task inspection." `       -EvidenceUsed "Required field validation against V0.5 inspect command contract." `       -WhatIsHappening "The pointer does not meet the minimum inspect schema." `       -WhyItMatters "Missing fields can cause the system to infer state instead of reading it." `       -WhatItAffects "It blocks trustworthy active task inspection." `       -WhatItDoesNotAffect "It does not mutate pointer state or repo state." `       -SecondReviewRequired "YES" `       -NextLegalAction "RUN_POINTER_REPAIR_ROUTE_SEPARATELY"
- line 273: Add-WarningObject -- Add-WarningObject `           -RawWarningText "Unknown PointerStatus: $PointerStatus" `           -WarningCategory "POINTER_STATUS_UNKNOWN" `           -BlockerStatus "UNKNOWN" `           -WhyThisCategory "The implementation cannot safely classify an unrecognized pointer status." `           -EvidenceUsed "PointerStatus value from pointer JSON." `           -WhatIsHappening "The pointer contains a status outside the known V0.5 status set." `           -WhyItMatters "Unknown status can cause wrong next-action assumptions." `           -WhatItAffects "It blocks authoritative active task inspection." `           -WhatItDoesNotAffect "It does not mutate files or repo state." `           -SecondReviewRequired "YES" `           -NextLegalAction "STOP_AND_REVIEW_POINTER_STATUS"
- line 290: Where-Object -- Where-Object { $_.BlockerStatus -eq "BLOCKING" }
- line 291: Where-Object -- Where-Object { $_.BlockerStatus -eq "NON_BLOCKING" }
- line 292: Where-Object -- Where-Object { $_.BlockerStatus -eq "WATCH" }
- line 293: Where-Object -- Where-Object { $_.BlockerStatus -eq "UNKNOWN" }
- line 305: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "PointerId"
- line 306: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "PointerVersion"
- line 307: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "UpdatedAt"
- line 308: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "ActiveLane"
- line 309: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "ActiveObject"
- line 310: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "ActiveStage"
- line 311: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "ActiveMode"
- line 312: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "LastCompletedStep"
- line 313: Get-ArrayText -- Get-ArrayText (Get-PropertyValue -Object $PointerObject -Name "CurrentProofState")
- line 313: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "CurrentProofState"
- line 314: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "NextLegalAction"
- line 315: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "NextLegalActionMode"
- line 316: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "NextActionRequiresConfirmation"
- line 317: Get-ArrayText -- Get-ArrayText (Get-PropertyValue -Object $PointerObject -Name "AllowedPowers")
- line 317: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "AllowedPowers"
- line 318: Get-ArrayText -- Get-ArrayText (Get-PropertyValue -Object $PointerObject -Name "BlockedPowers")
- line 318: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "BlockedPowers"
- line 319: Get-ArrayText -- Get-ArrayText (Get-PropertyValue -Object $PointerObject -Name "FilesToRead")
- line 319: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "FilesToRead"
- line 320: Get-ArrayText -- Get-ArrayText (Get-PropertyValue -Object $PointerObject -Name "EvidenceReports")
- line 320: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "EvidenceReports"
- line 321: Get-ArrayText -- Get-ArrayText (Get-PropertyValue -Object $PointerObject -Name "SaveReceipts")
- line 321: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "SaveReceipts"
- line 322: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "DoesNotProve"
- line 323: Get-PropertyValue -- Get-PropertyValue -Object $PointerObject -Name "StopLine"
- line 332: New-Object -- New-Object System.Collections.Generic.List[string]
- line 334: Out-Null -- Out-Null
- line 339: Out-Null -- Out-Null
- line 340: Out-Null -- Out-Null
- line 341: Out-Null -- Out-Null
- line 342: Out-Null -- Out-Null
- line 343: Out-Null -- Out-Null
- line 344: Out-Null -- Out-Null
- line 345: Out-Null -- Out-Null
- line 346: Out-Null -- Out-Null
- line 347: Out-Null -- Out-Null
- line 348: Out-Null -- Out-Null
- line 349: Out-Null -- Out-Null
- line 350: Out-Null -- Out-Null
- line 351: Out-Null -- Out-Null
- line 389: Get-ArrayText -- Get-ArrayText $FilesRead.ToArray()
- line 390: Get-ArrayText -- Get-ArrayText $FilesNotRead.ToArray()

## Risk / Watch Surface

- [MUTATION_COMMAND] line 105: git
- [MUTATION_COMMAND] line 120: git
- [PASS_SURFACE_WORD] line 197: SHA256
- [PASS_SURFACE_WORD] line 208: LOCK
- [PASS_SURFACE_WORD] line 212: LOCK
- [PASS_SURFACE_WORD] line 248: LOCK
- [PASS_SURFACE_WORD] line 252: LOCK
- [PASS_SURFACE_WORD] line 265: SAVED
- [PASS_SURFACE_WORD] line 267: LOCK
- [PASS_SURFACE_WORD] line 272: LOCK
- [PASS_SURFACE_WORD] line 290: LOCK
- [PASS_SURFACE_WORD] line 291: LOCK
- [PASS_SURFACE_WORD] line 296: FAIL
- [PASS_SURFACE_WORD] line 302: COMPLETE
- [PASS_SURFACE_WORD] line 321: Receipt
- [PASS_SURFACE_WORD] line 356: FAIL
- [PASS_SURFACE_WORD] line 358: LOCK
- [PASS_SURFACE_WORD] line 360: PASS
- [PASS_SURFACE_WORD] line 362: PASS
- [PASS_SURFACE_WORD] line 372: SHA256
- [PASS_SURFACE_WORD] line 392: Receipt
- [PASS_SURFACE_WORD] line 398: LOCK
- [PASS_SURFACE_WORD] line 399: LOCK
- [PASS_SURFACE_WORD] line 406: FAIL
- [PASS_SURFACE_WORD] line 408: FAIL
- [PROTECTED_OR_STATE_SURFACE] line 20: cleanup
- [PROTECTED_OR_STATE_SURFACE] line 21: ACTIVE_GUIDES
- [PROTECTED_OR_STATE_SURFACE] line 22: CURRENT_TRUTH_INDEX
- [PROTECTED_OR_STATE_SURFACE] line 156: origin/main

## Decision

REPAIR_BEFORE_RUN

If verdict is SAFE_STATIC_ONLY_CANDIDATE, the script may be considered for a later Code Gate path.
If verdict is SAFE_STATIC_ONLY_WITH_WATCH_SURFACES, fixture review must explain the watch surfaces first.
If verdict is REPAIR_BEFORE_RUN, do not run the helper; repair or replace risky surfaces first.
If verdict is BLOCKED_STATIC_PARSE_ERROR, do not run the helper; fix parse errors first.
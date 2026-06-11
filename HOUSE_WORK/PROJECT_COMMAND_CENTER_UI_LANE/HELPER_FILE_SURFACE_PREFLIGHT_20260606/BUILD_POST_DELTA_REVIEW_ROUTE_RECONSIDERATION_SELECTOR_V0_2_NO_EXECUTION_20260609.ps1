param(
  [string]$RootPath = "C:\Users\13527\Desktop\123",
  [string]$Base = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606",
  [string]$RoutePlanPath = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md",
  [string]$DeltaRollupCsvPath = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606\ROLLUP__74_LIVE_ROOT_DELTA_BATCH_REVIEW_COVERAGE_NO_EXECUTION_20260609.csv"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

$ReportPath = Join-Path $Base "POST_DELTA_RECONSIDERATION_V0_2_REPORT_20260609_$RunStamp.md"
$PlanRowsCsvPath = Join-Path $Base "POST_DELTA_RECONSIDERATION_V0_2_58_PLAN_ROWS_20260609_$RunStamp.csv"
$ReviewedDeltaCsvPath = Join-Path $Base "POST_DELTA_RECONSIDERATION_V0_2_74_REVIEWED_DELTA_ROWS_20260609_$RunStamp.csv"
$RouteCandidatesCsvPath = Join-Path $Base "POST_DELTA_RECONSIDERATION_V0_2_ROUTE_CANDIDATES_20260609_$RunStamp.csv"
$HoldOrLeaveCsvPath = Join-Path $Base "POST_DELTA_RECONSIDERATION_V0_2_HOLD_OR_LEAVE_ROWS_20260609_$RunStamp.csv"
$NewDeltaCsvPath = Join-Path $Base "POST_DELTA_RECONSIDERATION_V0_2_NEW_DELTA_ROWS_20260609_$RunStamp.csv"
$CollisionCsvPath = Join-Path $Base "POST_DELTA_RECONSIDERATION_V0_2_DESTINATION_COLLISIONS_20260609_$RunStamp.csv"
$ParentMissingCsvPath = Join-Path $Base "POST_DELTA_RECONSIDERATION_V0_2_DESTINATION_PARENT_MISSING_20260609_$RunStamp.csv"
$ReceiptPath = Join-Path $Base "HASH_RECEIPT__POST_DELTA_RECONSIDERATION_SELECTOR_V0_2_RUN_20260609_$RunStamp.txt"
$FreezePath = Join-Path $Base "FREEZE__POST_DELTA_RECONSIDERATION_SELECTOR_V0_2_FAILURE_20260609_$RunStamp.md"

function New-ObjectList {
  $List = [System.Collections.ArrayList]::new()
  return ,$List
}

function Add-ObjectRow {
  param(
    [System.Collections.ArrayList]$List,
    [object]$Row
  )
  [void]$List.Add($Row)
}

function Normalize-Header {
  param([string]$Text)
  if ($null -eq $Text) { return "" }
  return (($Text.Trim().ToLowerInvariant()) -replace "[^a-z0-9]", "")
}

function Split-MarkdownRow {
  param([string]$Line)
  $Trimmed = $Line.Trim()
  if ($Trimmed.StartsWith("|")) { $Trimmed = $Trimmed.Substring(1) }
  if ($Trimmed.EndsWith("|")) { $Trimmed = $Trimmed.Substring(0, $Trimmed.Length - 1) }
  return @($Trimmed -split "\|" | ForEach-Object { $_.Trim() })
}

function Test-MarkdownSeparatorRow {
  param([string]$Line)
  if ($null -eq $Line) { return $false }
  if ($Line -notmatch "^\s*\|") { return $false }
  if ($Line -notmatch "---") { return $false }
  $Stripped = $Line -replace "[\|\s:\-]", ""
  return ($Stripped.Length -eq 0)
}

function Test-MarkdownDataRow {
  param([string]$Line)
  if ($null -eq $Line) { return $false }
  return ($Line -match "^\s*\|")
}

function Get-Cell {
  param(
    [hashtable]$Row,
    [string[]]$CandidateHeaders
  )

  foreach ($Candidate in $CandidateHeaders) {
    $Key = Normalize-Header -Text $Candidate
    if ($Row.ContainsKey($Key)) {
      return [string]$Row[$Key]
    }
  }

  return ""
}

function Resolve-PathLike {
  param(
    [string]$PathText,
    [string]$DefaultRoot
  )

  if ([string]::IsNullOrWhiteSpace($PathText)) {
    return ""
  }

  $Clean = $PathText.Trim().Trim("`"").Trim("'")
  if ([System.IO.Path]::IsPathRooted($Clean)) {
    return [System.IO.Path]::GetFullPath($Clean)
  }

  return [System.IO.Path]::GetFullPath((Join-Path $DefaultRoot $Clean))
}

function Assert-OutputPathInBase {
  param([string]$PathText)

  $FullBase = [System.IO.Path]::GetFullPath($Base).TrimEnd("\")
  $FullPath = [System.IO.Path]::GetFullPath($PathText)

  if (-not $FullPath.StartsWith($FullBase, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "STOP: output path is outside helper preflight work area: $FullPath"
  }
}

function Test-HoldOrLeaveBucket {
  param([string]$ProposedBucket)

  if ($ProposedBucket -eq "HOLD_IN_ROOT_CURRENT_RUNNER_NO_ROUTE") { return $true }
  if ($ProposedBucket -eq "HOLD_ZERO_BYTE_REVIEW_NO_DELETE") { return $true }
  if ($ProposedBucket -eq "LEAVE_IN_PLACE") { return $true }

  return $false
}

function Test-RouteCandidateByContract {
  param(
    [string]$ActionNow,
    [string]$RequiresDryRun,
    [string]$RequiresUserApproval,
    [string]$FutureActionOnly,
    [string]$ProposedBucket
  )

  if ($ActionNow -ne "NO") { return $false }
  if ($RequiresDryRun -ne "YES") { return $false }
  if ($RequiresUserApproval -ne "YES") { return $false }
  if ($FutureActionOnly -ne "FUTURE_ROUTE_AFTER_USER_APPROVAL_AND_DRY_RUN_ONLY") { return $false }
  if (Test-HoldOrLeaveBucket -ProposedBucket $ProposedBucket) { return $false }
  if ([string]::IsNullOrWhiteSpace($ProposedBucket)) { return $false }

  return $true
}

function Write-FreezeEvidence {
  param([string]$FailureMessage)

  Assert-OutputPathInBase -PathText $FreezePath

  $FreezeText = @"
# FREEZE: POST-DELTA ROUTE RECONSIDERATION SELECTOR V0_2 FAILURE

Status:
FAILED_BEFORE_VALID_READY_VERDICT / FREEZE_WRITTEN

Failure message:
$FailureMessage

Script path:
$PSCommandPath

Run stamp:
$RunStamp

Root path:
$RootPath

Base path:
$Base

Route plan path:
$RoutePlanPath

Delta rollup CSV path:
$DeltaRollupCsvPath

Blocked actions:
move=0
delete=0
rename=0
route=0
cleanup=0
execute_helpers=0
commit=0
push=0

Final verdict:
ROUTE_RECONSIDERATION_V0_2_FAILED_FREEZE_WRITTEN
"@

  $FreezeText | Set-Content -LiteralPath $FreezePath -Encoding UTF8
  return $FreezePath
}

function Read-RoutePlanRowsFromMarkdown {
  param([string]$PathText)

  $Lines = @(Get-Content -LiteralPath $PathText)
  $CandidateTables = New-ObjectList

  for ($Index = 0; $Index -lt ($Lines.Count - 1); $Index++) {
    $HeaderLine = [string]$Lines[$Index]
    $SeparatorLine = [string]$Lines[$Index + 1]

    if ((Test-MarkdownDataRow -Line $HeaderLine) -and (Test-MarkdownSeparatorRow -Line $SeparatorLine)) {
      $Headers = @(Split-MarkdownRow -Line $HeaderLine)
      $NormalizedHeaders = @($Headers | ForEach-Object { Normalize-Header -Text $_ })

      $Rows = New-ObjectList
      $RowIndex = $Index + 2

      while ($RowIndex -lt $Lines.Count) {
        $CurrentLine = [string]$Lines[$RowIndex]

        if (-not (Test-MarkdownDataRow -Line $CurrentLine)) {
          break
        }

        if (Test-MarkdownSeparatorRow -Line $CurrentLine) {
          $RowIndex++
          continue
        }

        $Cells = @(Split-MarkdownRow -Line $CurrentLine)
        $Hash = @{}

        for ($CellIndex = 0; $CellIndex -lt $NormalizedHeaders.Count; $CellIndex++) {
          $HeaderKey = [string]$NormalizedHeaders[$CellIndex]
          $Value = ""
          if ($CellIndex -lt $Cells.Count) {
            $Value = [string]$Cells[$CellIndex]
          }

          if (-not [string]::IsNullOrWhiteSpace($HeaderKey)) {
            $Hash[$HeaderKey] = $Value
          }
        }

        Add-ObjectRow -List $Rows -Row $Hash
        $RowIndex++
      }

      Add-ObjectRow -List $CandidateTables -Row ([pscustomobject]@{
        StartLine = $Index + 1
        HeaderCount = $Headers.Count
        RowCount = $Rows.Count
        Rows = @($Rows)
      })
    }
  }

  $ExactTables = @($CandidateTables | Where-Object { $_.RowCount -eq 58 })
  if ($ExactTables.Count -gt 0) {
    return @($ExactTables[0].Rows)
  }

  throw "STOP: could not parse exact 58-row route-plan markdown table."
}

function Convert-ToRoutePlanRecordV02 {
  param([hashtable]$RawRow)

  $QueueType = Get-Cell -Row $RawRow -CandidateHeaders @("QueueType")
  $Name = Get-Cell -Row $RawRow -CandidateHeaders @("Name")
  $ExpectedSha = Get-Cell -Row $RawRow -CandidateHeaders @("SHA256")
  $SizeText = Get-Cell -Row $RawRow -CandidateHeaders @("SizeBytes")
  $SeenInReviewSnapshot = Get-Cell -Row $RawRow -CandidateHeaders @("SeenInReviewSnapshot")
  $IsCurrentRunner = Get-Cell -Row $RawRow -CandidateHeaders @("IsCurrentRunner")
  $CustodyClass = Get-Cell -Row $RawRow -CandidateHeaders @("CustodyClass")
  $SourceDecision = Get-Cell -Row $RawRow -CandidateHeaders @("SourceDecision")
  $ProposedBucket = Get-Cell -Row $RawRow -CandidateHeaders @("ProposedBucket")
  $FutureActionOnly = Get-Cell -Row $RawRow -CandidateHeaders @("FutureActionOnly")
  $ActionNow = Get-Cell -Row $RawRow -CandidateHeaders @("ActionNow")
  $RequiresDryRun = Get-Cell -Row $RawRow -CandidateHeaders @("RequiresDryRun")
  $RequiresUserApproval = Get-Cell -Row $RawRow -CandidateHeaders @("RequiresUserApproval")
  $Reason = Get-Cell -Row $RawRow -CandidateHeaders @("Reason")

  $SourcePathResolved = ""
  if (-not [string]::IsNullOrWhiteSpace($Name)) {
    $SourcePathResolved = Resolve-PathLike -PathText $Name -DefaultRoot $RootPath
  }

  $ExpectedSize = [long]0
  $ExpectedSizeParsed = $false
  if (-not [string]::IsNullOrWhiteSpace($SizeText)) {
    $CleanSize = ($SizeText -replace "[^0-9\-]", "")
    $ExpectedSizeParsed = [long]::TryParse($CleanSize, [ref]$ExpectedSize)
  }

  $IsHoldOrLeave = Test-HoldOrLeaveBucket -ProposedBucket $ProposedBucket
  $IsRouteCandidate = Test-RouteCandidateByContract -ActionNow $ActionNow -RequiresDryRun $RequiresDryRun -RequiresUserApproval $RequiresUserApproval -FutureActionOnly $FutureActionOnly -ProposedBucket $ProposedBucket

  $DerivedDestinationPath = ""
  $DerivedDestinationParent = ""
  if ($IsRouteCandidate) {
    $DerivedDestinationParent = Resolve-PathLike -PathText $ProposedBucket -DefaultRoot $RootPath
    $DerivedDestinationPath = Join-Path $DerivedDestinationParent $Name
    $DerivedDestinationPath = [System.IO.Path]::GetFullPath($DerivedDestinationPath)
  }

  return [pscustomobject]@{
    QueueType = $QueueType
    Name = $Name
    SourcePath = $SourcePathResolved
    ExpectedSHA256 = $ExpectedSha.Trim().ToUpperInvariant()
    ExpectedSizeBytesText = $SizeText
    ExpectedSizeBytes = $ExpectedSize
    ExpectedSizeParsed = $ExpectedSizeParsed
    SeenInReviewSnapshot = $SeenInReviewSnapshot
    IsCurrentRunner = $IsCurrentRunner
    CustodyClass = $CustodyClass
    SourceDecision = $SourceDecision
    ProposedBucket = $ProposedBucket
    FutureActionOnly = $FutureActionOnly
    ActionNow = $ActionNow
    RequiresDryRun = $RequiresDryRun
    RequiresUserApproval = $RequiresUserApproval
    Reason = $Reason
    IsRouteCandidate = $IsRouteCandidate
    IsHoldOrLeave = $IsHoldOrLeave
    DerivedDestinationParent = $DerivedDestinationParent
    DerivedDestinationPath = $DerivedDestinationPath
  }
}

try {
  foreach ($OutputPath in @($ReportPath, $PlanRowsCsvPath, $ReviewedDeltaCsvPath, $RouteCandidatesCsvPath, $HoldOrLeaveCsvPath, $NewDeltaCsvPath, $CollisionCsvPath, $ParentMissingCsvPath, $ReceiptPath, $FreezePath)) {
    Assert-OutputPathInBase -PathText $OutputPath
  }

  if (-not (Test-Path -LiteralPath $RootPath)) {
    throw "STOP: root path missing: $RootPath"
  }
  if (-not (Test-Path -LiteralPath $Base)) {
    throw "STOP: base path missing: $Base"
  }
  if (-not (Test-Path -LiteralPath $RoutePlanPath)) {
    throw "STOP: route plan missing: $RoutePlanPath"
  }
  if (-not (Test-Path -LiteralPath $DeltaRollupCsvPath)) {
    throw "STOP: delta rollup CSV missing: $DeltaRollupCsvPath"
  }

  $ScriptHash = (Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash
  $RoutePlanHash = (Get-FileHash -LiteralPath $RoutePlanPath -Algorithm SHA256).Hash
  $DeltaRollupHash = (Get-FileHash -LiteralPath $DeltaRollupCsvPath -Algorithm SHA256).Hash

  $RawRouteRows = @(Read-RoutePlanRowsFromMarkdown -PathText $RoutePlanPath)

  $PlanRowsList = New-ObjectList
  foreach ($RawRow in $RawRouteRows) {
    $Record = Convert-ToRoutePlanRecordV02 -RawRow $RawRow
    if (-not [string]::IsNullOrWhiteSpace($Record.Name)) {
      Add-ObjectRow -List $PlanRowsList -Row $Record
    }
  }

  $PlanRows = @($PlanRowsList)
  if ($PlanRows.Count -ne 58) {
    throw "STOP: expected 58 planned route rows, found $($PlanRows.Count)."
  }

  $DeltaRows = @(Import-Csv -LiteralPath $DeltaRollupCsvPath)
  if ($DeltaRows.Count -ne 74) {
    throw "STOP: expected 74 reviewed delta rows, found $($DeltaRows.Count)."
  }

  $NotActiveAuthorityCount = @($DeltaRows | Where-Object { $_.AuthorityStatus -eq "NOT_ACTIVE_AUTHORITY" }).Count
  $DoNotExecuteCount = @($DeltaRows | Where-Object { $_.ExecutionStatus -eq "DO_NOT_EXECUTE" }).Count
  $NoPhysicalActionCount = @($DeltaRows | Where-Object { $_.PhysicalActionAuthorized -eq "NO" }).Count

  if ($NotActiveAuthorityCount -ne 74) {
    throw "STOP: expected 74 NOT_ACTIVE_AUTHORITY rows, found $NotActiveAuthorityCount."
  }
  if ($DoNotExecuteCount -ne 74) {
    throw "STOP: expected 74 DO_NOT_EXECUTE rows, found $DoNotExecuteCount."
  }
  if ($NoPhysicalActionCount -ne 74) {
    throw "STOP: expected 74 PhysicalActionAuthorized=NO rows, found $NoPhysicalActionCount."
  }

  $LiveFiles = @(Get-ChildItem -LiteralPath $RootPath -File -Force)

  $LiveByName = @{}
  foreach ($File in $LiveFiles) {
    $LiveByName[$File.Name] = $File
  }

  $PlanNameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
  foreach ($Row in $PlanRows) {
    [void]$PlanNameSet.Add([string]$Row.Name)
  }

  $DeltaNameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
  foreach ($Row in $DeltaRows) {
    [void]$DeltaNameSet.Add([string]$Row.Name)
  }

  $OverlapNames = @($PlanRows | Where-Object { $DeltaNameSet.Contains([string]$_.Name) })
  if ($OverlapNames.Count -ne 0) {
    throw "STOP: planned set and reviewed-delta set overlap by name: $($OverlapNames.Count)."
  }

  $PlanVerification = New-ObjectList
  $RouteCandidateRows = New-ObjectList
  $HoldOrLeaveRows = New-ObjectList
  $CollisionRows = New-ObjectList
  $ParentMissingRows = New-ObjectList

  foreach ($Row in $PlanRows) {
    $ExistsInLiveRoot = $LiveByName.ContainsKey([string]$Row.Name)

    $LivePath = ""
    $LiveSHA256 = ""
    $LiveSizeBytes = [long]0

    if ($ExistsInLiveRoot) {
      $LiveFile = $LiveByName[[string]$Row.Name]
      $LivePath = [string]$LiveFile.FullName
      $LiveSHA256 = (Get-FileHash -LiteralPath $LivePath -Algorithm SHA256).Hash
      $LiveSizeBytes = [long]$LiveFile.Length
    }

    $MissingExpectedSHA = [string]::IsNullOrWhiteSpace([string]$Row.ExpectedSHA256)
    $MissingExpectedSize = -not [bool]$Row.ExpectedSizeParsed
    $SHAChanged = $false
    $SizeChanged = $false

    if ($ExistsInLiveRoot -and -not $MissingExpectedSHA) {
      $SHAChanged = (-not $LiveSHA256.Equals([string]$Row.ExpectedSHA256, [System.StringComparison]::OrdinalIgnoreCase))
    } elseif ($MissingExpectedSHA) {
      $SHAChanged = $true
    }

    if ($ExistsInLiveRoot -and -not $MissingExpectedSize) {
      $SizeChanged = ($LiveSizeBytes -ne [long]$Row.ExpectedSizeBytes)
    } elseif ($MissingExpectedSize) {
      $SizeChanged = $true
    }

    $ChangedOrMissing = ((-not $ExistsInLiveRoot) -or $SHAChanged -or $SizeChanged)

    $DestinationParentExists = $false
    $DestinationExists = $false
    $DestinationCollision = $false
    $DestinationSHA256 = ""
    $DestinationSizeBytes = [long]0

    if ([bool]$Row.IsRouteCandidate) {
      $DestinationParentExists = Test-Path -LiteralPath ([string]$Row.DerivedDestinationParent)
      if (-not $DestinationParentExists) {
        Add-ObjectRow -List $ParentMissingRows -Row ([pscustomobject]@{
          Name = $Row.Name
          SourcePath = $LivePath
          ProposedBucket = $Row.ProposedBucket
          DestinationParent = $Row.DerivedDestinationParent
          DestinationPath = $Row.DerivedDestinationPath
          ParentMissingReason = "Derived destination parent folder does not exist."
        })
      } else {
        $DestinationExists = Test-Path -LiteralPath ([string]$Row.DerivedDestinationPath)
        if ($DestinationExists) {
          $SourceFull = [System.IO.Path]::GetFullPath($LivePath)
          $DestinationFull = [System.IO.Path]::GetFullPath([string]$Row.DerivedDestinationPath)

          if (-not $SourceFull.Equals($DestinationFull, [System.StringComparison]::OrdinalIgnoreCase)) {
            $DestinationCollision = $true
            if ((Get-Item -LiteralPath ([string]$Row.DerivedDestinationPath)).PSIsContainer -eq $false) {
              $DestinationSHA256 = (Get-FileHash -LiteralPath ([string]$Row.DerivedDestinationPath) -Algorithm SHA256).Hash
              $DestinationSizeBytes = [long](Get-Item -LiteralPath ([string]$Row.DerivedDestinationPath)).Length
            }

            Add-ObjectRow -List $CollisionRows -Row ([pscustomobject]@{
              Name = $Row.Name
              SourcePath = $LivePath
              ProposedBucket = $Row.ProposedBucket
              DestinationPath = $Row.DerivedDestinationPath
              DestinationExists = $DestinationExists
              DestinationSHA256 = $DestinationSHA256
              DestinationSizeBytes = $DestinationSizeBytes
              CollisionReason = "Derived destination path already exists and is not the source path."
            })
          }
        }
      }

      Add-ObjectRow -List $RouteCandidateRows -Row ([pscustomobject]@{
        Name = $Row.Name
        SourcePath = $LivePath
        ProposedBucket = $Row.ProposedBucket
        DestinationParent = $Row.DerivedDestinationParent
        DestinationPath = $Row.DerivedDestinationPath
        DestinationParentExists = $DestinationParentExists
        DestinationExists = $DestinationExists
        DestinationCollision = $DestinationCollision
        ChangedOrMissing = $ChangedOrMissing
        RequiresDryRun = $Row.RequiresDryRun
        RequiresUserApproval = $Row.RequiresUserApproval
        FutureActionOnly = $Row.FutureActionOnly
      })
    } elseif ([bool]$Row.IsHoldOrLeave) {
      Add-ObjectRow -List $HoldOrLeaveRows -Row ([pscustomobject]@{
        Name = $Row.Name
        SourcePath = $LivePath
        ProposedBucket = $Row.ProposedBucket
        HoldOrLeaveReason = "ProposedBucket is hold-or-leave by V0_2 contract."
        ChangedOrMissing = $ChangedOrMissing
        FutureActionOnly = $Row.FutureActionOnly
      })
    }

    Add-ObjectRow -List $PlanVerification -Row ([pscustomobject]@{
      QueueType = $Row.QueueType
      Name = $Row.Name
      SourcePath = $Row.SourcePath
      LivePath = $LivePath
      ExpectedSHA256 = $Row.ExpectedSHA256
      LiveSHA256 = $LiveSHA256
      ExpectedSizeBytes = $Row.ExpectedSizeBytes
      LiveSizeBytes = $LiveSizeBytes
      ExistsInLiveRoot = $ExistsInLiveRoot
      MissingExpectedSHA256 = $MissingExpectedSHA
      MissingExpectedSizeBytes = $MissingExpectedSize
      SHA256Changed = $SHAChanged
      SizeChanged = $SizeChanged
      ChangedOrMissing = $ChangedOrMissing
      ProposedBucket = $Row.ProposedBucket
      FutureActionOnly = $Row.FutureActionOnly
      ActionNow = $Row.ActionNow
      RequiresDryRun = $Row.RequiresDryRun
      RequiresUserApproval = $Row.RequiresUserApproval
      IsRouteCandidate = $Row.IsRouteCandidate
      IsHoldOrLeave = $Row.IsHoldOrLeave
      DerivedDestinationParent = $Row.DerivedDestinationParent
      DerivedDestinationPath = $Row.DerivedDestinationPath
      DestinationParentExists = $DestinationParentExists
      DestinationExists = $DestinationExists
      DestinationCollision = $DestinationCollision
    })
  }

  $ReviewedDeltaVerification = New-ObjectList

  foreach ($Row in $DeltaRows) {
    $Name = [string]$Row.Name
    $ExpectedSHA = ([string]$Row.SHA256).Trim().ToUpperInvariant()
    $ExistsInLiveRoot = $LiveByName.ContainsKey($Name)
    $LivePath = ""
    $LiveSHA256 = ""
    $LiveSizeBytes = [long]0

    if ($ExistsInLiveRoot) {
      $LiveFile = $LiveByName[$Name]
      $LivePath = [string]$LiveFile.FullName
      $LiveSHA256 = (Get-FileHash -LiteralPath $LivePath -Algorithm SHA256).Hash
      $LiveSizeBytes = [long]$LiveFile.Length
    }

    $MissingExpectedSHA = [string]::IsNullOrWhiteSpace($ExpectedSHA)
    $SHAChanged = $false

    if ($ExistsInLiveRoot -and -not $MissingExpectedSHA) {
      $SHAChanged = (-not $LiveSHA256.Equals($ExpectedSHA, [System.StringComparison]::OrdinalIgnoreCase))
    } elseif ($MissingExpectedSHA) {
      $SHAChanged = $true
    }

    $ChangedOrMissing = ((-not $ExistsInLiveRoot) -or $SHAChanged)

    Add-ObjectRow -List $ReviewedDeltaVerification -Row ([pscustomobject]@{
      Name = $Name
      SourcePath = $Row.SourcePath
      LivePath = $LivePath
      ExpectedSHA256 = $ExpectedSHA
      LiveSHA256 = $LiveSHA256
      LiveSizeBytes = $LiveSizeBytes
      ExistsInLiveRoot = $ExistsInLiveRoot
      SHA256Changed = $SHAChanged
      ChangedOrMissing = $ChangedOrMissing
      AuthorityStatus = $Row.AuthorityStatus
      ExecutionStatus = $Row.ExecutionStatus
      PhysicalActionAuthorized = $Row.PhysicalActionAuthorized
      ProposedDisposition = $Row.ProposedDisposition
    })
  }

  $AllowedLooseNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
  [void]$AllowedLooseNames.Add("desktop.ini")

  $NewDeltaRows = New-ObjectList

  foreach ($File in $LiveFiles) {
    $Name = [string]$File.Name

    if ($PlanNameSet.Contains($Name)) { continue }
    if ($DeltaNameSet.Contains($Name)) { continue }
    if ($AllowedLooseNames.Contains($Name)) { continue }

    $LiveSHA = (Get-FileHash -LiteralPath ([string]$File.FullName) -Algorithm SHA256).Hash

    Add-ObjectRow -List $NewDeltaRows -Row ([pscustomobject]@{
      Name = $Name
      SourcePath = $File.FullName
      SizeBytes = [long]$File.Length
      SHA256 = $LiveSHA
      DeltaStatus = "NEW_UNREVIEWED_LIVE_ROOT_DELTA"
    })
  }

  $PlanRowsOut = @($PlanVerification)
  $ReviewedDeltaRowsOut = @($ReviewedDeltaVerification)
  $RouteCandidateRowsOut = @($RouteCandidateRows)
  $HoldOrLeaveRowsOut = @($HoldOrLeaveRows)
  $NewDeltaRowsOut = @($NewDeltaRows)
  $CollisionRowsOut = @($CollisionRows)
  $ParentMissingRowsOut = @($ParentMissingRows)

  $ChangedPlanCount = @($PlanRowsOut | Where-Object { $_.ChangedOrMissing -eq $true }).Count
  $ChangedReviewedDeltaCount = @($ReviewedDeltaRowsOut | Where-Object { $_.ChangedOrMissing -eq $true }).Count
  $NewUnreviewedDeltaCount = @($NewDeltaRowsOut).Count
  $DestinationCollisionCount = @($CollisionRowsOut).Count
  $DestinationParentMissingCount = @($ParentMissingRowsOut).Count

  $FinalVerdict = "ROUTE_RECONSIDERATION_V0_2_READY_FOR_USER_APPROVAL"

  if ($NewUnreviewedDeltaCount -gt 0) {
    $FinalVerdict = "ROUTE_RECONSIDERATION_V0_2_BLOCKED_NEW_DELTA"
  } elseif ($ChangedPlanCount -gt 0) {
    $FinalVerdict = "ROUTE_RECONSIDERATION_V0_2_BLOCKED_CHANGED_58_PLAN"
  } elseif ($ChangedReviewedDeltaCount -gt 0) {
    $FinalVerdict = "ROUTE_RECONSIDERATION_V0_2_BLOCKED_CHANGED_REVIEWED_DELTA"
  } elseif ($DestinationCollisionCount -gt 0) {
    $FinalVerdict = "ROUTE_RECONSIDERATION_V0_2_BLOCKED_DESTINATION_COLLISION"
  } elseif ($DestinationParentMissingCount -gt 0) {
    $FinalVerdict = "ROUTE_RECONSIDERATION_V0_2_BLOCKED_DESTINATION_PARENT_MISSING"
  }

  $PlanRowsOut | Export-Csv -LiteralPath $PlanRowsCsvPath -NoTypeInformation -Encoding UTF8
  $ReviewedDeltaRowsOut | Export-Csv -LiteralPath $ReviewedDeltaCsvPath -NoTypeInformation -Encoding UTF8
  $RouteCandidateRowsOut | Export-Csv -LiteralPath $RouteCandidatesCsvPath -NoTypeInformation -Encoding UTF8
  $HoldOrLeaveRowsOut | Export-Csv -LiteralPath $HoldOrLeaveCsvPath -NoTypeInformation -Encoding UTF8
  $NewDeltaRowsOut | Export-Csv -LiteralPath $NewDeltaCsvPath -NoTypeInformation -Encoding UTF8
  $CollisionRowsOut | Export-Csv -LiteralPath $CollisionCsvPath -NoTypeInformation -Encoding UTF8
  $ParentMissingRowsOut | Export-Csv -LiteralPath $ParentMissingCsvPath -NoTypeInformation -Encoding UTF8

  $PlanRowsCsvHash = (Get-FileHash -LiteralPath $PlanRowsCsvPath -Algorithm SHA256).Hash
  $ReviewedDeltaCsvHash = (Get-FileHash -LiteralPath $ReviewedDeltaCsvPath -Algorithm SHA256).Hash
  $RouteCandidatesCsvHash = (Get-FileHash -LiteralPath $RouteCandidatesCsvPath -Algorithm SHA256).Hash
  $HoldOrLeaveCsvHash = (Get-FileHash -LiteralPath $HoldOrLeaveCsvPath -Algorithm SHA256).Hash
  $NewDeltaCsvHash = (Get-FileHash -LiteralPath $NewDeltaCsvPath -Algorithm SHA256).Hash
  $CollisionCsvHash = (Get-FileHash -LiteralPath $CollisionCsvPath -Algorithm SHA256).Hash
  $ParentMissingCsvHash = (Get-FileHash -LiteralPath $ParentMissingCsvPath -Algorithm SHA256).Hash

  $ReportText = @"
# POST-DELTA ROUTE RECONSIDERATION V0_2 REPORT

Status:
REPORT_BUILT / NO_ROUTE / NO_CLEANUP / NO_PHYSICAL_ACTION

Script path:
$PSCommandPath

Script SHA256:
$ScriptHash

Route plan path:
$RoutePlanPath

Route plan SHA256:
$RoutePlanHash

Delta rollup CSV:
$DeltaRollupCsvPath

Delta rollup SHA256:
$DeltaRollupHash

Counts:
- planned_route_row_count: $($PlanRowsOut.Count)
- reviewed_delta_row_count: $($ReviewedDeltaRowsOut.Count)
- route_candidate_count: $($RouteCandidateRowsOut.Count)
- hold_or_leave_count: $($HoldOrLeaveRowsOut.Count)
- new_unreviewed_delta_count: $NewUnreviewedDeltaCount
- changed_planned_count: $ChangedPlanCount
- changed_reviewed_delta_count: $ChangedReviewedDeltaCount
- destination_collision_count: $DestinationCollisionCount
- destination_parent_missing_count: $DestinationParentMissingCount

Output hashes:
- plan_rows_csv_sha256: $PlanRowsCsvHash
- reviewed_delta_csv_sha256: $ReviewedDeltaCsvHash
- route_candidates_csv_sha256: $RouteCandidatesCsvHash
- hold_or_leave_csv_sha256: $HoldOrLeaveCsvHash
- new_delta_csv_sha256: $NewDeltaCsvHash
- collision_csv_sha256: $CollisionCsvHash
- parent_missing_csv_sha256: $ParentMissingCsvHash

Final verdict:
$FinalVerdict

Boundary:
This report does not execute routing.
This report does not approve physical action by itself.
A READY verdict requires separate user approval before any future route operation.

Physical actions:
move=0
delete=0
rename=0
route=0
cleanup=0
execute_helpers=0
commit=0
push=0
"@

  $ReportText | Set-Content -LiteralPath $ReportPath -Encoding UTF8
  $ReportHash = (Get-FileHash -LiteralPath $ReportPath -Algorithm SHA256).Hash

  $ReceiptText = @"
report_path: $ReportPath
report_sha256: $ReportHash
plan_rows_csv_path: $PlanRowsCsvPath
plan_rows_csv_sha256: $PlanRowsCsvHash
reviewed_delta_csv_path: $ReviewedDeltaCsvPath
reviewed_delta_csv_sha256: $ReviewedDeltaCsvHash
route_candidates_csv_path: $RouteCandidatesCsvPath
route_candidates_csv_sha256: $RouteCandidatesCsvHash
hold_or_leave_csv_path: $HoldOrLeaveCsvPath
hold_or_leave_csv_sha256: $HoldOrLeaveCsvHash
new_delta_csv_path: $NewDeltaCsvPath
new_delta_csv_sha256: $NewDeltaCsvHash
collision_csv_path: $CollisionCsvPath
collision_csv_sha256: $CollisionCsvHash
parent_missing_csv_path: $ParentMissingCsvPath
parent_missing_csv_sha256: $ParentMissingCsvHash
script_sha256: $ScriptHash
source_route_plan_sha256: $RoutePlanHash
delta_rollup_sha256: $DeltaRollupHash
planned_route_row_count: $($PlanRowsOut.Count)
reviewed_delta_row_count: $($ReviewedDeltaRowsOut.Count)
route_candidate_count: $($RouteCandidateRowsOut.Count)
hold_or_leave_count: $($HoldOrLeaveRowsOut.Count)
new_unreviewed_delta_count: $NewUnreviewedDeltaCount
changed_planned_count: $ChangedPlanCount
changed_reviewed_delta_count: $ChangedReviewedDeltaCount
destination_collision_count: $DestinationCollisionCount
destination_parent_missing_count: $DestinationParentMissingCount
final_verdict: $FinalVerdict
artifact_writes: report=1 plan_rows_csv=1 reviewed_delta_csv=1 route_candidates_csv=1 hold_or_leave_csv=1 new_delta_csv=1 collision_csv=1 parent_missing_csv=1 receipt=1
physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0
"@

  $ReceiptText | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
  $ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

  "=== POST-DELTA ROUTE RECONSIDERATION SELECTOR V0_2 COMPLETE ==="
  "script_path: $PSCommandPath"
  "script_sha256: $ScriptHash"
  "source_route_plan_sha256: $RoutePlanHash"
  "delta_rollup_sha256: $DeltaRollupHash"
  "report_path: $ReportPath"
  "report_sha256: $ReportHash"
  "receipt_path: $ReceiptPath"
  "receipt_sha256: $ReceiptHash"
  "planned_route_row_count: $($PlanRowsOut.Count)"
  "reviewed_delta_row_count: $($ReviewedDeltaRowsOut.Count)"
  "route_candidate_count: $($RouteCandidateRowsOut.Count)"
  "hold_or_leave_count: $($HoldOrLeaveRowsOut.Count)"
  "new_unreviewed_delta_count: $NewUnreviewedDeltaCount"
  "changed_planned_count: $ChangedPlanCount"
  "changed_reviewed_delta_count: $ChangedReviewedDeltaCount"
  "destination_collision_count: $DestinationCollisionCount"
  "destination_parent_missing_count: $DestinationParentMissingCount"
  "final_verdict: $FinalVerdict"
  "artifact_writes: report=1 plan_rows_csv=1 reviewed_delta_csv=1 route_candidates_csv=1 hold_or_leave_csv=1 new_delta_csv=1 collision_csv=1 parent_missing_csv=1 receipt=1"
  "physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0"

} catch {
  $Freeze = Write-FreezeEvidence -FailureMessage $_.Exception.Message
  $FreezeHash = (Get-FileHash -LiteralPath $Freeze -Algorithm SHA256).Hash

  "=== POST-DELTA ROUTE RECONSIDERATION SELECTOR V0_2 FAILED ==="
  "freeze_path: $Freeze"
  "freeze_sha256: $FreezeHash"
  "final_verdict: ROUTE_RECONSIDERATION_V0_2_FAILED_FREEZE_WRITTEN"
  "physical_actions: move=0 delete=0 rename=0 route=0 cleanup=0 execute_helpers=0 commit=0 push=0"

  throw
}

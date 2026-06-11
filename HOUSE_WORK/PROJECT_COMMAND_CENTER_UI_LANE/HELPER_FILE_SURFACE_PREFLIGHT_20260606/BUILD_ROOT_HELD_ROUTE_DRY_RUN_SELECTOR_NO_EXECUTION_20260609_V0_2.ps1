[CmdletBinding()]
param(
  [string]$Root = "C:\Users\13527\Desktop\123",
  [string]$Base = "C:\Users\13527\Desktop\123\HOUSE_WORK\PROJECT_COMMAND_CENTER_UI_LANE\HELPER_FILE_SURFACE_PREFLIGHT_20260606"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

$PlanPath = Join-Path $Base "ROOT_HELD_GROUP_ROUTE_PLAN_ONLY_V0_1_20260608.md"
$ScopePath = Join-Path $Base "SCOPE__ROOT_HELD_ROUTE_DRY_RUN_EXPANSION_NO_EXECUTION_20260609.md"
$DesignPath = Join-Path $Base "DESIGN__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_NO_EXECUTION_20260609.md"
$ContractPath = Join-Path $Base "CONTRACT__ROOT_HELD_ROUTE_DRY_RUN_SELECTOR_BUILD_NO_EXECUTION_20260609.md"

$ReportPath = Join-Path $Base ("DRY_RUN__ROOT_HELD_ROUTE_SELECTOR_REPORT_20260609_V0_2_{0}.md" -f $RunStamp)
$RowsCsvPath = Join-Path $Base ("DRY_RUN__ROOT_HELD_ROUTE_SELECTOR_ROWS_20260609_V0_2_{0}.csv" -f $RunStamp)
$DeltaCsvPath = Join-Path $Base ("DRY_RUN__ROOT_HELD_ROUTE_SELECTOR_LIVE_ROOT_DELTA_20260609_V0_2_{0}.csv" -f $RunStamp)
$CollisionCsvPath = Join-Path $Base ("DRY_RUN__ROOT_HELD_ROUTE_SELECTOR_COLLISIONS_20260609_V0_2_{0}.csv" -f $RunStamp)
$ReceiptPath = Join-Path $Base ("HASH_RECEIPT__ROOT_HELD_ROUTE_SELECTOR_DRY_RUN_20260609_V0_2_{0}.txt" -f $RunStamp)
$FreezePath = Join-Path $Base ("FREEZE__ROOT_HELD_ROUTE_SELECTOR_DRY_RUN_FAILURE_20260609_V0_2_{0}.md" -f $RunStamp)

function New-ObjectList {
  $List = [System.Collections.Generic.List[object]]::new()
  return ,$List
}

function New-StringList {
  $List = [System.Collections.Generic.List[string]]::new()
  return ,$List
}

function Add-ObjectRow {
  param(
    [System.Collections.Generic.List[object]]$List,
    [object]$Item
  )
  if ($null -eq $List) { throw "Add-ObjectRow received null list." }
  if ($null -eq $Item) { return }
  [void]$List.Add($Item)
}

function Add-StringLine {
  param(
    [System.Collections.Generic.List[string]]$List,
    [string]$Line
  )
  if ($null -eq $List) { throw "Add-StringLine received null list." }
  if ($null -eq $Line) { $Line = "" }
  [void]$List.Add($Line)
}

function Write-FreezeEvidence {
  param(
    [string]$Message,
    [object]$ErrorObject
  )

  $FreezeLines = New-StringList
  Add-StringLine $FreezeLines "# ROOT-HELD ROUTE SELECTOR DRY-RUN FAILURE FREEZE"
  Add-StringLine $FreezeLines ""
  Add-StringLine $FreezeLines "status: FREEZE_EVIDENCE / NO_ROUTE / NO_CLEANUP / NO_EXECUTION"
  Add-StringLine $FreezeLines ("timestamp: {0}" -f (Get-Date -Format o))
  Add-StringLine $FreezeLines ("message: {0}" -f $Message)
  Add-StringLine $FreezeLines ("root: {0}" -f $Root)
  Add-StringLine $FreezeLines ("base: {0}" -f $Base)
  Add-StringLine $FreezeLines ("plan_path: {0}" -f $PlanPath)
  if ($null -ne $ErrorObject) {
    Add-StringLine $FreezeLines ("error: {0}" -f [string]$ErrorObject)
  }
  Add-StringLine $FreezeLines ""
  Add-StringLine $FreezeLines "blocked_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0"
  $FreezeLines | Set-Content -LiteralPath $FreezePath -Encoding UTF8
}

function Normalize-Cell {
  param([string]$Value)
  if ($null -eq $Value) { return "" }
  return $Value.Trim()
}

function Split-MarkdownRow {
  param([string]$Line)

  if ([string]::IsNullOrWhiteSpace($Line)) {
    return [string[]]@()
  }

  $Trimmed = $Line.Trim()
  if (-not $Trimmed.StartsWith("|")) {
    return [string[]]@()
  }

  if ($Trimmed.EndsWith("|")) {
    $Trimmed = $Trimmed.Substring(0, $Trimmed.Length - 1)
  }

  if ($Trimmed.StartsWith("|")) {
    $Trimmed = $Trimmed.Substring(1)
  }

  [string[]]$RawCells = @($Trimmed -split "\|")
  $CleanCells = New-ObjectList

  foreach ($Cell in $RawCells) {
    Add-ObjectRow $CleanCells ([string](Normalize-Cell ([string]$Cell)))
  }

  [string[]]$Result = @()
  foreach ($Cell in $CleanCells) {
    $Result += [string]$Cell
  }
  return $Result
}

function Get-DestinationInfo {
  param(
    [string]$ProposedBucket,
    [string]$Name,
    [string]$RootPath
  )

  $Bucket = Normalize-Cell $ProposedBucket
  $FileName = Normalize-Cell $Name

  $IsRouteBucket = $false
  if ($Bucket -like "_OLD_LOADS/*") { $IsRouteBucket = $true }
  if ($Bucket -like "DOCUMENT_CUSTODY_REVIEW/*") { $IsRouteBucket = $true }

  $DestinationFolder = ""
  $DestinationPath = ""
  $DestinationFolderExists = $false
  $DestinationFileExists = $false
  $Collision = $false

  if ($IsRouteBucket -eq $true) {
    $Relative = $Bucket.Replace("/", [System.IO.Path]::DirectorySeparatorChar)
    $DestinationFolder = Join-Path $RootPath $Relative
    $DestinationPath = Join-Path $DestinationFolder $FileName
    $DestinationFolderExists = Test-Path -LiteralPath $DestinationFolder -PathType Container
    $DestinationFileExists = Test-Path -LiteralPath $DestinationPath -PathType Leaf
    if ($DestinationFileExists -eq $true) {
      $Collision = $true
    }
  }

  return [pscustomobject]@{
    IsRouteBucket = $IsRouteBucket
    DestinationFolder = $DestinationFolder
    DestinationPath = $DestinationPath
    DestinationFolderExists = $DestinationFolderExists
    DestinationFileExists = $DestinationFileExists
    Collision = $Collision
  }
}

try {
  foreach ($RequiredPath in @($PlanPath, $ScopePath, $DesignPath, $ContractPath)) {
    if (-not (Test-Path -LiteralPath $RequiredPath -PathType Leaf)) {
      throw ("Required input missing: {0}" -f $RequiredPath)
    }
  }

  if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
    throw ("Approved live root missing: {0}" -f $Root)
  }

  $PlanLines = New-StringList
  foreach ($Line in Get-Content -LiteralPath $PlanPath) {
    Add-StringLine $PlanLines ([string]$Line)
  }

  $HeaderIndex = -1
  for ($i = 0; $i -lt $PlanLines.Count; $i++) {
    $LineText = [string]$PlanLines[$i]
    if ($LineText -like "| QueueType | Name | SHA256 | SizeBytes |*") {
      $HeaderIndex = $i
      break
    }
  }

  if ($HeaderIndex -lt 0) {
    throw "Route-plan table header not found."
  }

  [string[]]$Headers = @(Split-MarkdownRow ([string]$PlanLines[$HeaderIndex]))
  if ($Headers.Length -lt 10) {
    throw "Route-plan table header did not parse into enough columns."
  }

  $RouteRows = New-ObjectList

  $StartIndex = $HeaderIndex + 2
  for ($i = $StartIndex; $i -lt $PlanLines.Count; $i++) {
    $LineText = [string]$PlanLines[$i]
    if ([string]::IsNullOrWhiteSpace($LineText)) { break }
    if (-not $LineText.Trim().StartsWith("|")) { break }

    [string[]]$Cells = @(Split-MarkdownRow $LineText)
    if ($Cells.Length -lt $Headers.Length) { continue }

    $Obj = [ordered]@{}
    for ($c = 0; $c -lt $Headers.Length; $c++) {
      $Obj[[string]$Headers[$c]] = Normalize-Cell ([string]$Cells[$c])
    }

    Add-ObjectRow $RouteRows ([pscustomobject]$Obj)
  }

  if ($RouteRows.Count -eq 0) {
    throw "No route-plan rows parsed."
  }

  $LiveRows = New-ObjectList
  foreach ($File in Get-ChildItem -LiteralPath $Root -File -Force) {
    $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash
    Add-ObjectRow $LiveRows ([pscustomobject]@{
      Name = [string]$File.Name
      FullName = [string]$File.FullName
      SizeBytes = [int64]$File.Length
      SHA256 = [string]$Hash
    })
  }

  $LiveByName = [System.Collections.Generic.Dictionary[string,object]]::new([System.StringComparer]::OrdinalIgnoreCase)
  foreach ($Live in $LiveRows) {
    $LiveName = [string]$Live.Name
    if (-not $LiveByName.ContainsKey($LiveName)) {
      $LiveByName.Add($LiveName, $Live)
    }
  }

  $PlanByName = [System.Collections.Generic.Dictionary[string,object]]::new([System.StringComparer]::OrdinalIgnoreCase)
  foreach ($Route in $RouteRows) {
    $RouteName = [string]$Route.Name
    if (-not [string]::IsNullOrWhiteSpace($RouteName)) {
      if (-not $PlanByName.ContainsKey($RouteName)) {
        $PlanByName.Add($RouteName, $Route)
      }
    }
  }

  $DryRows = New-ObjectList
  $DeltaRows = New-ObjectList
  $CollisionRows = New-ObjectList

  foreach ($Route in $RouteRows) {
    $Name = [string]$Route.Name
    $ExpectedHash = [string]$Route.SHA256
    $ExpectedSizeText = [string]$Route.SizeBytes
    $ActionNow = [string]$Route.ActionNow
    $FutureActionOnly = [string]$Route.FutureActionOnly
    $ProposedBucket = [string]$Route.ProposedBucket

    $StopReasons = New-StringList

    if ([string]::IsNullOrWhiteSpace($Name)) {
      Add-StringLine $StopReasons "BLANK_NAME"
    }

    if ($ExpectedHash -notmatch "^[A-Fa-f0-9]{64}$") {
      Add-StringLine $StopReasons "MALFORMED_SHA256"
    }

    if ($ActionNow -ne "NO") {
      Add-StringLine $StopReasons "ACTION_NOW_NOT_NO"
    }

    [int64]$ExpectedSize = 0
    if (-not [int64]::TryParse($ExpectedSizeText, [ref]$ExpectedSize)) {
      Add-StringLine $StopReasons "BAD_SIZE_BYTES"
    }

    $SourceExists = $false
    $SourcePath = ""
    $ActualHash = ""
    [int64]$ActualSize = -1

    if (-not [string]::IsNullOrWhiteSpace($Name)) {
      if ($LiveByName.ContainsKey($Name)) {
        $Live = $LiveByName[$Name]
        $SourceExists = $true
        $SourcePath = [string]$Live.FullName
        $ActualHash = [string]$Live.SHA256
        $ActualSize = [int64]$Live.SizeBytes
      } else {
        Add-StringLine $StopReasons "SOURCE_MISSING"
      }
    }

    if ($SourceExists -eq $true) {
      if ($ActualHash -ne $ExpectedHash) {
        Add-StringLine $StopReasons "SOURCE_HASH_CHANGED"
      }
      if ($ActualSize -ne $ExpectedSize) {
        Add-StringLine $StopReasons "SOURCE_SIZE_CHANGED"
      }
    }

    $Dest = Get-DestinationInfo -ProposedBucket $ProposedBucket -Name $Name -RootPath $Root

    if ($Dest.IsRouteBucket -eq $true) {
      if ([string]::IsNullOrWhiteSpace([string]$Dest.DestinationPath)) {
        Add-StringLine $StopReasons "DESTINATION_PATH_MISSING"
      }
      if ($Dest.Collision -eq $true) {
        Add-StringLine $StopReasons "DESTINATION_COLLISION"
        Add-ObjectRow $CollisionRows ([pscustomobject]@{
          Name = $Name
          ProposedBucket = $ProposedBucket
          DestinationPath = [string]$Dest.DestinationPath
          Collision = "YES"
        })
      }
    }

    $RouteRecommendation = "HOLD_OR_LEAVE_IN_PLACE"
    if ($Dest.IsRouteBucket -eq $true) {
      $RouteRecommendation = "FUTURE_ROUTE_DRY_RUN_ONLY"
    }

    if ($StopReasons.Count -gt 0) {
      $RouteRecommendation = "NO_ROUTE_RECOMMENDATION"
    }

    $StopReasonText = ""
    if ($StopReasons.Count -gt 0) {
      $StopReasonText = [string]::Join(";", $StopReasons)
    }

    Add-ObjectRow $DryRows ([pscustomobject]@{
      QueueType = [string]$Route.QueueType
      Name = $Name
      SourcePath = $SourcePath
      ExpectedSHA256 = $ExpectedHash
      ActualSHA256 = $ActualHash
      ExpectedSizeBytes = $ExpectedSize
      ActualSizeBytes = $ActualSize
      SourceExists = $SourceExists
      ProposedBucket = $ProposedBucket
      FutureActionOnly = $FutureActionOnly
      ActionNow = $ActionNow
      RequiresDryRun = [string]$Route.RequiresDryRun
      RequiresUserApproval = [string]$Route.RequiresUserApproval
      DestinationFolder = [string]$Dest.DestinationFolder
      DestinationPath = [string]$Dest.DestinationPath
      DestinationFolderExists = [bool]$Dest.DestinationFolderExists
      DestinationFileExists = [bool]$Dest.DestinationFileExists
      DestinationCollision = [bool]$Dest.Collision
      RouteRecommendation = $RouteRecommendation
      StopReason = $StopReasonText
    })
  }

  foreach ($Live in $LiveRows) {
    $LiveName = [string]$Live.Name
    if (-not $PlanByName.ContainsKey($LiveName)) {
      Add-ObjectRow $DeltaRows ([pscustomobject]@{
        Name = $LiveName
        FullName = [string]$Live.FullName
        SizeBytes = [int64]$Live.SizeBytes
        SHA256 = [string]$Live.SHA256
        DeltaDisposition = "ROOT_DELTA_UNREVIEWED_HOLD"
      })
    }
  }

  $RoutePlanRowCount = $RouteRows.Count
  $LiveRootFileCount = $LiveRows.Count

  $MatchedSourceCount = 0
  $MissingSourceCount = 0
  $ChangedHashCount = 0
  $ChangedSizeCount = 0
  $ProposedRouteCount = 0
  $HoldCount = 0
  $ActionNowCount = 0
  $DeleteNowCount = 0
  $MoveNowCount = 0
  $ExecutionAuthorityCount = 0
  $StopConditionCount = 0

  foreach ($Row in $DryRows) {
    if ([bool]$Row.SourceExists) { $MatchedSourceCount++ } else { $MissingSourceCount++ }
    if (($Row.ActualSHA256 -ne "") -and ($Row.ActualSHA256 -ne $Row.ExpectedSHA256)) { $ChangedHashCount++ }
    if (($Row.ActualSizeBytes -ge 0) -and ($Row.ActualSizeBytes -ne $Row.ExpectedSizeBytes)) { $ChangedSizeCount++ }
    if ($Row.RouteRecommendation -eq "FUTURE_ROUTE_DRY_RUN_ONLY") { $ProposedRouteCount++ } else { $HoldCount++ }
    if ($Row.ActionNow -ne "NO") { $ActionNowCount++ }
    if (($Row.ActionNow -match "DELETE") -or ($Row.FutureActionOnly -match "DELETE")) { $DeleteNowCount++ }
    if (($Row.ActionNow -match "MOVE") -or ($Row.FutureActionOnly -match "MOVE")) { $MoveNowCount++ }
    if (($Row.ActionNow -match "EXECUTE") -or ($Row.FutureActionOnly -match "EXECUTE")) { $ExecutionAuthorityCount++ }
    if (-not [string]::IsNullOrWhiteSpace([string]$Row.StopReason)) { $StopConditionCount++ }
  }

  $LiveRootDeltaUnreviewedCount = $DeltaRows.Count
  $DestinationCollisionCount = $CollisionRows.Count

  if ($LiveRootDeltaUnreviewedCount -gt 0) { $StopConditionCount = $StopConditionCount + $LiveRootDeltaUnreviewedCount }
  if ($DestinationCollisionCount -gt 0) { $StopConditionCount = $StopConditionCount + $DestinationCollisionCount }

  $FinalVerdict = "DRY_RUN_PASS_PENDING_USER_APPROVAL"
  if ($StopConditionCount -gt 0) {
    $FinalVerdict = "NO_ROUTE_RECOMMENDATION"
  }

  $DryRows | Export-Csv -LiteralPath $RowsCsvPath -NoTypeInformation -Encoding UTF8
  $DeltaRows | Export-Csv -LiteralPath $DeltaCsvPath -NoTypeInformation -Encoding UTF8
  $CollisionRows | Export-Csv -LiteralPath $CollisionCsvPath -NoTypeInformation -Encoding UTF8

  $ReportLines = New-StringList
  Add-StringLine $ReportLines "# ROOT-HELD ROUTE DRY-RUN SELECTOR REPORT"
  Add-StringLine $ReportLines ""
  Add-StringLine $ReportLines "Status: DRY_RUN_REPORT / NO_EXECUTION / NO_ROUTE / NO_CLEANUP"
  Add-StringLine $ReportLines ("Created: {0}" -f (Get-Date -Format o))
  Add-StringLine $ReportLines ("PlanPath: {0}" -f $PlanPath)
  Add-StringLine $ReportLines ("Root: {0}" -f $Root)
  Add-StringLine $ReportLines ""
  Add-StringLine $ReportLines "## Counts"
  Add-StringLine $ReportLines ("- route_plan_row_count: {0}" -f $RoutePlanRowCount)
  Add-StringLine $ReportLines ("- live_root_file_count: {0}" -f $LiveRootFileCount)
  Add-StringLine $ReportLines ("- matched_source_count: {0}" -f $MatchedSourceCount)
  Add-StringLine $ReportLines ("- missing_source_count: {0}" -f $MissingSourceCount)
  Add-StringLine $ReportLines ("- changed_hash_count: {0}" -f $ChangedHashCount)
  Add-StringLine $ReportLines ("- changed_size_count: {0}" -f $ChangedSizeCount)
  Add-StringLine $ReportLines ("- live_root_delta_unreviewed_count: {0}" -f $LiveRootDeltaUnreviewedCount)
  Add-StringLine $ReportLines ("- proposed_route_count: {0}" -f $ProposedRouteCount)
  Add-StringLine $ReportLines ("- hold_count: {0}" -f $HoldCount)
  Add-StringLine $ReportLines ("- destination_collision_count: {0}" -f $DestinationCollisionCount)
  Add-StringLine $ReportLines ("- action_now_count: {0}" -f $ActionNowCount)
  Add-StringLine $ReportLines ("- execution_authority_count: {0}" -f $ExecutionAuthorityCount)
  Add-StringLine $ReportLines ("- delete_now_count: {0}" -f $DeleteNowCount)
  Add-StringLine $ReportLines ("- move_now_count: {0}" -f $MoveNowCount)
  Add-StringLine $ReportLines ("- stop_condition_count: {0}" -f $StopConditionCount)
  Add-StringLine $ReportLines ""
  Add-StringLine $ReportLines "## Output files"
  Add-StringLine $ReportLines ("- dry_run_rows_csv: {0}" -f $RowsCsvPath)
  Add-StringLine $ReportLines ("- live_root_delta_csv: {0}" -f $DeltaCsvPath)
  Add-StringLine $ReportLines ("- collision_csv: {0}" -f $CollisionCsvPath)
  Add-StringLine $ReportLines ""
  Add-StringLine $ReportLines "## DoesNotProve"
  Add-StringLine $ReportLines "This dry-run does not authorize route execution, cleanup, deletion, rename, helper execution, source rewrite, doctrine promotion, commit, or push."
  Add-StringLine $ReportLines ""
  Add-StringLine $ReportLines ("final_verdict: {0}" -f $FinalVerdict)

  $ReportLines | Set-Content -LiteralPath $ReportPath -Encoding UTF8

  $ReportHash = (Get-FileHash -LiteralPath $ReportPath -Algorithm SHA256).Hash
  $RowsHash = (Get-FileHash -LiteralPath $RowsCsvPath -Algorithm SHA256).Hash
  $DeltaHash = (Get-FileHash -LiteralPath $DeltaCsvPath -Algorithm SHA256).Hash
  $CollisionHash = (Get-FileHash -LiteralPath $CollisionCsvPath -Algorithm SHA256).Hash

  $ReceiptLines = New-StringList
  Add-StringLine $ReceiptLines ("report_path: {0}" -f $ReportPath)
  Add-StringLine $ReceiptLines ("report_sha256: {0}" -f $ReportHash)
  Add-StringLine $ReceiptLines ("rows_csv_path: {0}" -f $RowsCsvPath)
  Add-StringLine $ReceiptLines ("rows_csv_sha256: {0}" -f $RowsHash)
  Add-StringLine $ReceiptLines ("delta_csv_path: {0}" -f $DeltaCsvPath)
  Add-StringLine $ReceiptLines ("delta_csv_sha256: {0}" -f $DeltaHash)
  Add-StringLine $ReceiptLines ("collision_csv_path: {0}" -f $CollisionCsvPath)
  Add-StringLine $ReceiptLines ("collision_csv_sha256: {0}" -f $CollisionHash)
  Add-StringLine $ReceiptLines ("final_verdict: {0}" -f $FinalVerdict)
  Add-StringLine $ReceiptLines "physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0"

  $ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8
  $ReceiptHash = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash

  "=== ROOT-HELD ROUTE DRY-RUN SELECTOR COMPLETE ==="
  "report_path: $ReportPath"
  "report_sha256: $ReportHash"
  "rows_csv_path: $RowsCsvPath"
  "rows_csv_sha256: $RowsHash"
  "delta_csv_path: $DeltaCsvPath"
  "delta_csv_sha256: $DeltaHash"
  "collision_csv_path: $CollisionCsvPath"
  "collision_csv_sha256: $CollisionHash"
  "receipt_path: $ReceiptPath"
  "receipt_sha256: $ReceiptHash"
  "final_verdict: $FinalVerdict"
  "physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0"

} catch {
  Write-FreezeEvidence -Message "DRY_RUN_SELECTOR_FAILED_BEFORE_VALID_VERDICT" -ErrorObject $_
  "=== ROOT-HELD ROUTE DRY-RUN SELECTOR FAILED ==="
  "freeze_path: $FreezePath"
  "physical_actions: move=0 delete=0 rename=0 route=0 execute=0 commit=0 push=0"
  throw
}


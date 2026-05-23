# RUN_DEEP_COBWEB_HOUSE_SCAN_RESTART_V1.2.ps1
# Fresh restart of the serious deep scan.
# Keeps useful ideas from V1.0/V1.1, but starts the task over from a clean frame.
# Read-only scan. Examines cobwebs; does not clean them.
# No move, no delete, no Git commit, no push, no public export, no doctrine promotion.

$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Desktop = Join-Path $env:USERPROFILE "Desktop"
$AssistantRoot = Join-Path $Desktop "ASSISTANT_LOCAL"
$Porch = Join-Path $Desktop "123"
$ReceiptDir = Join-Path $AssistantRoot "_RECEIPTS"

if (-not (Test-Path -LiteralPath $AssistantRoot)) { throw "ASSISTANT_LOCAL missing: $AssistantRoot" }

$BrainCandidates = @(
    (Join-Path $Desktop "Jxhnny_Kleen_C3dz"),
    (Join-Path $Desktop "Jxhnny_Kleen_C33dz")
)

$BrainRepo = $null
foreach ($Candidate in $BrainCandidates) {
    if (Test-Path -LiteralPath (Join-Path $Candidate ".git")) {
        $BrainRepo = $Candidate
        break
    }
}
if (-not $BrainRepo) { throw "Mr.Kleen repo not found in expected candidate folders." }

$ScanRoot = Join-Path $AssistantRoot ("HOUSE_DEEP_SCANS\DEEP_COBWEB_SCAN_RESTART_V1.2_{0}" -f $Stamp)
New-Item -ItemType Directory -Path $ScanRoot,$ReceiptDir -Force | Out-Null

$StartOverFrame = Join-Path $ScanRoot "START_OVER_FRAME.md"
$InventoryCsv = Join-Path $ScanRoot "FILE_INVENTORY.csv"
$CobwebCsv = Join-Path $ScanRoot "COBWEB_SIGNALS.csv"
$IdeaCsv = Join-Path $ScanRoot "IDEA_CANDIDATES_AND_MISSED_IDEAS.csv"
$ConnectionMap = Join-Path $ScanRoot "HOUSE_CONNECTION_MAP.md"
$LastMessageAudit = Join-Path $ScanRoot "LAST_MESSAGE_AND_SCAN_DESIGN_AUDIT.md"
$RoomsReport = Join-Path $ScanRoot "ROOMS_BEINGS_FEELINGS_REPORT.md"
$GitReport = Join-Path $ScanRoot "GIT_STATE_READ_ONLY.txt"
$MasterReport = Join-Path $ScanRoot "DEEP_COBWEB_HOUSE_SCAN_RESTART_REPORT.md"
$ReceiptPath = Join-Path $ReceiptDir ("DEEP_COBWEB_HOUSE_SCAN_RESTART_V1.2_RECEIPT_{0}.txt" -f $Stamp)

$Boundary = @(
    "Examined only",
    "No cleaning",
    "No move",
    "No delete",
    "No Git commit",
    "No push",
    "No public export",
    "No doctrine promotion",
    "No ACTIVE_GUIDES rewrite",
    "No CURRENT_TRUTH_INDEX rewrite",
    "Old ideas carried forward; old route not blindly continued"
)

$Rooms = @(
    [PSCustomObject]@{Name="MR_KLEEN_BRAIN"; Path=$BrainRepo; Role="brain repo / house doctrine-adjacent material"},
    [PSCustomObject]@{Name="ASSISTANT_LOCAL"; Path=$AssistantRoot; Role="local assistant support root"},
    [PSCustomObject]@{Name="PORCH_DESKTOP_123"; Path=$Porch; Role="porch / intake / active dropped files"}
)

$TextExts = @(".md",".txt",".ps1",".json",".csv",".yml",".yaml",".xml",".html",".css",".js",".ts",".py",".url")
$ExcludedDirNames = @(".git","node_modules",".venv","venv","__pycache__",".pytest_cache",".mypy_cache")
$MaxReadBytes = 2MB

$Inventory = New-Object System.Collections.Generic.List[object]
$Signals = New-Object System.Collections.Generic.List[object]
$Ideas = New-Object System.Collections.Generic.List[object]

function Test-ExcludedPath {
    param([string]$FullPath)
    $Parts = $FullPath.Split([System.IO.Path]::DirectorySeparatorChar,[System.IO.Path]::AltDirectorySeparatorChar)
    foreach ($P in $Parts) {
        if ($ExcludedDirNames -contains $P) { return $true }
    }
    return $false
}

function Get-Rel {
    param([string]$Base,[string]$Path)
    try { return [System.IO.Path]::GetRelativePath($Base,$Path) } catch { return $Path }
}

function Get-HashOrNote {
    param([string]$Path)
    try { return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash } catch { return "HASH_FAILED" }
}

function Add-Signal {
    param([string]$Room,[string]$Path,[string]$Signal,[string]$Severity,[string]$Why,[string]$LearningUse)
    $Signals.Add([PSCustomObject]@{
        Room=$Room
        Path=$Path
        Signal=$Signal
        Severity=$Severity
        Why=$Why
        LearningUse=$LearningUse
    }) | Out-Null
}

function Add-Idea {
    param(
        [string]$Room,[string]$Path,[int]$LineNumber,[string]$Marker,[string]$Excerpt,
        [string]$SourceKind,[string]$Fit,[string]$Risk,[string]$Lane,[string]$ReturnTrigger,[string]$ProofNeed
    )
    $CleanExcerpt = ($Excerpt -replace "\s+"," ").Trim()
    if ($CleanExcerpt.Length -gt 520) { $CleanExcerpt = $CleanExcerpt.Substring(0,520) }
    $Ideas.Add([PSCustomObject]@{
        Room=$Room
        Path=$Path
        LineNumber=$LineNumber
        Marker=$Marker
        Excerpt=$CleanExcerpt
        SourceKind=$SourceKind
        Fit=$Fit
        Risk=$Risk
        Lane=$Lane
        ReturnTrigger=$ReturnTrigger
        ProofNeed=$ProofNeed
    }) | Out-Null
}

# Start-over frame.
$Frame = @()
$Frame += "# Start-Over Frame — Deep Cobweb Scan Restart V1.2"
$Frame += ""
$Frame += "Timestamp: $Stamp"
$Frame += ""
$Frame += "## Active Issue"
$Frame += "The deep scan task became tangled while new requirements were added. The task restarts from the beginning without killing useful old ideas."
$Frame += ""
$Frame += "## Visible Issues"
$Frame += "1. The scan must examine cobwebs, not clean them."
$Frame += "2. Problems must become learning signals and possible solutions."
$Frame += "3. Ideas must be captured from user words/actions, assistant words/actions, old reports, receipts, messages, files, scan outputs, and missed wording."
$Frame += "4. The assistant must self-audit its last plan/message before continuing."
$Frame += "5. The scan must use existing house tools and connect rooms instead of inventing isolated surfaces."
$Frame += "6. Old ideas from V1.0/V1.1 should be carried forward as ingredients, not blindly continued."
$Frame += ""
$Frame += "## Notes"
$Frame += "- V1.0 and V1.1 are held as old attempts, not deleted."
$Frame += "- V1.2 is the clean restart."
$Frame += "- The scan is read-only."
$Frame += "- The output is a scan folder and receipt."
$Frame += ""
$Frame += "## Options"
$Frame += "A. Run V1.0. Rejected: missing newer self-audit requirements."
$Frame += "B. Run V1.1 unchanged. Rejected: task was tangled and user asked to restart from beginning."
$Frame += "C. Build V1.2 as clean restart carrying forward the useful ideas. Chosen."
$Frame += ""
$Frame += "## Chosen Fix"
$Frame += "Use V1.2: clean frame, same useful ingredients, no cleaning, idea capture, last-message audit, house connection map, cobweb signals, rooms/beings/feelings, receipt."
$Frame += ""
$Frame += "## Boundary"
foreach ($B in $Boundary) { $Frame += "- $B" }
Set-Content -LiteralPath $StartOverFrame -Value ($Frame -join [Environment]::NewLine) -Encoding UTF8

# Current chat/user/assistant ideas explicitly seeded.
Add-Idea -Room "CURRENT_CHAT" -Path "user instruction: start over" -LineNumber 0 -Marker "START_OVER_WITH_CARRY_FORWARD" -Excerpt "Start the task over from the start, use old ideas still, do not kill it all, just start over." -SourceKind "user_instruction" -Fit "HIGH" -Risk "Restart can lose useful work if old ideas are not carried forward." -Lane "HOUSE_DEEP_SCANS / START_OVER_FRAME / TASK_RESET_METHOD" -ReturnTrigger "When a route is tangled but contains useful material." -ProofNeed "V1.2 frame must mark old attempts held, not killed."
Add-Idea -Room "CURRENT_CHAT" -Path "user instruction: broad self-audit" -LineNumber 0 -Marker "LAST_MESSAGE_SELF_AUDIT" -Excerpt "After assistant gives a plan or says this is it, double-check the last message for correctness, missing ideas, over-explanation, confusion, vagueness, order, maps, house tools, and connections." -SourceKind "user_instruction" -Fit "HIGH" -Risk "Can become endless checking if not tied to plan/rule/scan transitions." -Lane "CHAT_RULES_LOCAL_ONLY / HOUSE_DEEP_SCANS / BRAIN_LEARNING" -ReturnTrigger "Before continuing after plans/rules/scans or when user returns." -ProofNeed "Output a last-message audit file and use it before next move."
Add-Idea -Room "CURRENT_CHAT" -Path "user instruction: problems as solutions" -LineNumber 0 -Marker "PROBLEM_TO_POWER_PLAY" -Excerpt "Use problems as solutions; adverse effects are evidence/proof/answer material." -SourceKind "user_instruction" -Fit "HIGH" -Risk "Must not glorify failure; must verify changed behavior." -Lane "SMOKE_BREAK_FOCUS_RESET / STOP_GATE / POWER_PLAY_CANDIDATES" -ReturnTrigger "When a problem appears during active work." -ProofNeed "Apply to same problem and verify."

# Git read-only state.
$GitLines = @()
Push-Location $BrainRepo
try {
    $GitLines += "Brain repo: $BrainRepo"
    $GitLines += "Branch: $((& git rev-parse --abbrev-ref HEAD 2>&1) -join ' ')"
    $GitLines += "HEAD: $((& git rev-parse HEAD 2>&1) -join ' ')"
    $GitLines += "Status short:"
    $Status = & git status --short 2>&1
    if (($Status -join "`n").Trim().Length -eq 0) { $GitLines += "[clean]" } else { $GitLines += $Status }
} finally {
    Pop-Location
}
Set-Content -LiteralPath $GitReport -Value ($GitLines -join [Environment]::NewLine) -Encoding UTF8

$IdeaMarkers = @(
    @{Name="IDEA"; Pattern="(?i)\b(new idea|idea|concept|thought)\b"; Fit="CANDIDATE"; Lane="IDEA_CANDIDATES / PARKING"},
    @{Name="GATE_METHOD"; Pattern="(?i)\b(rule|gate|method|protocol|workflow|loop|trigger|audit|check)\b"; Fit="LIKELY USEFUL"; Lane="CHAT_RULES_LOCAL_ONLY / BRAIN_LEARNING / SORTING_BENCH"},
    @{Name="MAP_ORDER_CONNECTION"; Pattern="(?i)\b(map|plan|order|sequence|layout|connect|connection|bring.*together|room|tool)\b"; Fit="STRUCTURE CANDIDATE"; Lane="MAPS / INDEX / HOUSE_CONNECTION_MAP"},
    @{Name="POWER_PLAY"; Pattern="(?i)\b(power play|problem.*solution|failure.*signal|adverse effect|evidence|proof)\b"; Fit="LIKELY USEFUL"; Lane="STOP_GATE / SMOKE_BREAK / POWER_PLAY_CANDIDATES"},
    @{Name="BOUNDARY"; Pattern="(?i)\b(boundary|blocked|do not|no git|no push|no public|not doctrine|ACTIVE_GUIDES|CURRENT_TRUTH_INDEX)\b"; Fit="BOUNDARY WATCH"; Lane="INVALID_RECEIPTS / HOUSE_WORK / PARKING"},
    @{Name="MISSING_OR_VAGUE"; Pattern="(?i)\b(missed|forgot|left out|vague|confusing|over.?explain|unknown|missing|needs more source)\b"; Fit="COBWEB CANDIDATE"; Lane="COBWEB_SIGNALS / PARKING"}
)

foreach ($Room in $Rooms) {
    if (-not (Test-Path -LiteralPath $Room.Path)) {
        Add-Signal -Room $Room.Name -Path $Room.Path -Signal "ROOM_MISSING" -Severity "HIGH" -Why "Expected room is absent." -LearningUse "Confirm moved/renamed/retired state before using route."
        continue
    }

    $Files = Get-ChildItem -LiteralPath $Room.Path -File -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { -not (Test-ExcludedPath -FullPath $_.FullName) }

    foreach ($File in $Files) {
        $Rel = Get-Rel -Base $Room.Path -Path $File.FullName
        $Ext = $File.Extension.ToLowerInvariant()
        $Hash = Get-HashOrNote -Path $File.FullName

        $Inventory.Add([PSCustomObject]@{
            Room=$Room.Name
            Role=$Room.Role
            RelativePath=$Rel
            FullPath=$File.FullName
            Extension=$Ext
            SizeBytes=$File.Length
            LastWriteTime=$File.LastWriteTime.ToString("s")
            SHA256=$Hash
        }) | Out-Null

        if ($Room.Name -eq "PORCH_DESKTOP_123") {
            Add-Signal -Room $Room.Name -Path $Rel -Signal "PORCH_LOOSE_FILE" -Severity "MEDIUM" -Why "Loose porch file may be active drop, retained source, or unclosed intake." -LearningUse "Classify; do not move during scan."
        }

        if ($File.Length -eq 0) {
            Add-Signal -Room $Room.Name -Path $Rel -Signal "EMPTY_FILE" -Severity "LOW" -Why "Empty file may be intentional marker or failed output." -LearningUse "Classify before use."
        }

        if ($TextExts -contains $Ext -and $File.Length -le $MaxReadBytes) {
            $Text = ""
            try { $Text = Get-Content -LiteralPath $File.FullName -Raw -ErrorAction Stop } catch { $Text = "" }

            if ($Text -match "current build receipt|latest receipt|receipt pending|TODO proof|proof pending") {
                Add-Signal -Room $Room.Name -Path $Rel -Signal "VAGUE_PROOF_POINTER" -Severity "HIGH" -Why "Vague proof lets future assistants trust unclear state." -LearningUse "Replace with exact path/hash or mark unknown."
            }
            if ($Text -match "PASS" -and $Text -match "Exception|ParserError|failed|BLOCKED|PARTIAL|error") {
                Add-Signal -Room $Room.Name -Path $Rel -Signal "PASS_NEAR_ERROR_OR_BLOCKER" -Severity "HIGH" -Why "PASS near errors can create false confidence." -LearningUse "Route to invalid-receipts review before trusting."
            }
            if ($Text -match "(?i)patch") {
                Add-Signal -Room $Room.Name -Path $Rel -Signal "OLD_REPAIR_LANGUAGE_OR_NAMING_DEBT" -Severity "MEDIUM" -Why "Old repair wording may conflict with current project language." -LearningUse "Treat as naming debt unless it is an old filename."
            }
            if ($Text -match "NEEDS MORE SOURCE|needs more source|UNKNOWN|MISSING") {
                Add-Signal -Room $Room.Name -Path $Rel -Signal "UNKNOWN_OR_SOURCE_GAP" -Severity "MEDIUM" -Why "Known unknown should not become fake certainty." -LearningUse "Park with source need and return trigger."
            }

            $LineNo = 0
            foreach ($Line in ($Text -split "`r?`n")) {
                $LineNo++
                foreach ($Marker in $IdeaMarkers) {
                    if ($Line -match $Marker.Pattern) {
                        Add-Idea -Room $Room.Name -Path $Rel -LineNumber $LineNo -Marker $Marker.Name -Excerpt $Line -SourceKind "file_scan" -Fit $Marker.Fit -Risk "Needs triage; do not promote from scan alone." -Lane $Marker.Lane -ReturnTrigger "Review during idea/cobweb triage." -ProofNeed "Confirm source, fit, lane, risk, and small proof."
                        break
                    }
                }
                $CountForFile = @($Ideas | Where-Object { $_.Room -eq $Room.Name -and $_.Path -eq $Rel }).Count
                if ($CountForFile -ge 10) { break }
            }
        }
    }
}

# House connection map: use existing tools.
$ToolPatterns = @(
    [PSCustomObject]@{Name="ASSISTANT_LOCAL_INDEX"; Pattern="ASSISTANT_LOCAL_INDEX"; Role="front door / read order"},
    [PSCustomObject]@{Name="STOP_ISSUE_NOTE_OPTION_WEIGHT_GATE"; Pattern="STOP_ISSUE_NOTE_OPTION_WEIGHT"; Role="problem gate loop"},
    [PSCustomObject]@{Name="SMOKE_BREAK_FOCUS_RESET_POWER_PLAY"; Pattern="SMOKE_BREAK_FOCUS_RESET"; Role="focus reset / adverse effects as evidence"},
    [PSCustomObject]@{Name="SAME_SHAPE_HOUSE_WALK"; Pattern="SAME_SHAPE|BEFORE_AFTER_SAME_SHAPE"; Role="before/after comparison"},
    [PSCustomObject]@{Name="PARKING_LEDGER"; Pattern="PARKING_LEDGER"; Role="parked idea/problem custody"},
    [PSCustomObject]@{Name="INVALID_RECEIPTS_INDEX"; Pattern="INVALID_RECEIPTS_INDEX"; Role="bad-proof custody"},
    [PSCustomObject]@{Name="DATA_LOGS"; Pattern="DATA_LOGS|SESSION_LOG|GAP_BACKFILL"; Role="operational session record"},
    [PSCustomObject]@{Name="REVIEW_SURFACES"; Pattern="REVIEW_SURFACES"; Role="house/base/clean-room selector"},
    [PSCustomObject]@{Name="CHAT_COCKPIT_ROUTER_MAP"; Pattern="CHAT_COCKPIT_ROUTER_MAP"; Role="route map"},
    [PSCustomObject]@{Name="MULE_REVIEW"; Pattern="MULE_REVIEW"; Role="outside/local review return"}
)

$MapLines = @()
$MapLines += "# House Connection Map — Restart V1.2"
$MapLines += ""
$MapLines += "Timestamp: $Stamp"
$MapLines += ""
$MapLines += "Rule: Before creating a new surface, connect each cobweb or idea to an existing tool/room if one fits."
$MapLines += ""
$MapLines += "| Tool | Role | Found Count | Scan Use |"
$MapLines += "|---|---|---|---|"
foreach ($Tool in $ToolPatterns) {
    $Matches = @($Inventory | Where-Object { $_.RelativePath -match $Tool.Pattern -or $_.FullPath -match $Tool.Pattern })
    $Use = switch -Regex ($Tool.Role) {
        "front" { "Start here; memory orients, files prove."; break }
        "problem" { "When any issue appears, stop/list/notes/options/weigh/apply/verify."; break }
        "focus" { "Use only to reset and return to same active issue."; break }
        "before" { "Use for direction comparisons; same check twice."; break }
        "parked" { "Give ideas/problems source, lane, return trigger, proof need."; break }
        "bad-proof" { "Route false PASS, superseded, and proof gaps here."; break }
        "operational" { "Record session events honestly; do not fake live logs."; break }
        "selector" { "Choose House/Base/Clean-room review surface."; break }
        "route" { "Route to support card; not doctrine."; break }
        "review" { "Use returns as evidence; triage before adopting."; break }
        default { "Use when matching signal appears." }
    }
    $MapLines += "| $($Tool.Name) | $($Tool.Role) | $($Matches.Count) | $Use |"
}
Set-Content -LiteralPath $ConnectionMap -Value ($MapLines -join [Environment]::NewLine) -Encoding UTF8

# Last message / scan design audit.
$Audit = @()
$Audit += "# Last Message and Scan Design Audit — Restart V1.2"
$Audit += ""
$Audit += "Timestamp: $Stamp"
$Audit += ""
$Audit += "## Audit Target"
$Audit += "The prior deep-scan plan and generated V1.0/V1.1 scan routes."
$Audit += ""
$Audit += "## Questions"
$Audit += "- Was it right? Partly."
$Audit += "- Was anything left out? Yes: clean restart handling and explicit carry-forward of old ideas."
$Audit += "- Was it too vague? It was clear but still expanding while the user was changing task shape."
$Audit += "- Was it over-explained? The response was moderate, but the script was heavy."
$Audit += "- Was it confusing? Risk: multiple versions V1.0/V1.1 before user approved running."
$Audit += "- Did it use existing tools? Partly: gate, smoke break, same-shape, index, parking, invalid receipts were referenced."
$Audit += "- Did it connect rooms? V1.1 added a map; V1.2 keeps the map but restarts from a clean frame."
$Audit += "- Did it capture new ideas? It captured some, but user added a broader last-message audit requirement."
$Audit += ""
$Audit += "## Fix Applied"
$Audit += "Start over as V1.2. Keep old ideas as ingredients. Mark old attempts held, not killed. Produce a start-over frame, connection map, idea audit, cobweb signals, and receipt."
Set-Content -LiteralPath $LastMessageAudit -Value ($Audit -join [Environment]::NewLine) -Encoding UTF8

# Duplicate path/custody signal.
$DupGroups = $Inventory | Group-Object RelativePath | Where-Object { $_.Count -gt 1 }
foreach ($Group in $DupGroups) {
    $Hashes = @($Group.Group | Select-Object -ExpandProperty SHA256 -Unique)
    $Severity = if ($Hashes.Count -gt 1) { "MEDIUM" } else { "LOW" }
    Add-Signal -Room "MULTI_ROOM" -Path $Group.Name -Signal "DUPLICATE_RELATIVE_PATH" -Severity $Severity -Why "Same relative path appears in multiple scan rooms." -LearningUse "Check if intentional copy, stale duplicate, or custody ambiguity."
}

$Inventory | Export-Csv -LiteralPath $InventoryCsv -NoTypeInformation -Encoding UTF8
$Signals | Export-Csv -LiteralPath $CobwebCsv -NoTypeInformation -Encoding UTF8
$Ideas | Export-Csv -LiteralPath $IdeaCsv -NoTypeInformation -Encoding UTF8

# Rooms/beings/feelings report.
$RoomLines = @()
$RoomLines += "# Rooms / Beings / Feelings Report — Restart V1.2"
$RoomLines += ""
$RoomLines += "Timestamp: $Stamp"
$RoomLines += "Mode: read-only; examine cobwebs, do not clean."
$RoomLines += ""
foreach ($Room in $Rooms) {
    $F = @($Inventory | Where-Object { $_.Room -eq $Room.Name })
    $S = @($Signals | Where-Object { $_.Room -eq $Room.Name })
    $I = @($Ideas | Where-Object { $_.Room -eq $Room.Name })
    $High = @($S | Where-Object { $_.Severity -eq "HIGH" }).Count
    $Med = @($S | Where-Object { $_.Severity -eq "MEDIUM" }).Count
    $Low = @($S | Where-Object { $_.Severity -eq "LOW" }).Count
    $RoomLines += "## $($Room.Name)"
    $RoomLines += "- Path: $($Room.Path)"
    $RoomLines += "- Role: $($Room.Role)"
    $RoomLines += "- Files: $($F.Count)"
    $RoomLines += "- Cobwebs: $($S.Count) ($High high / $Med medium / $Low low)"
    $RoomLines += "- Idea candidates: $($I.Count)"
    if ($High -gt 0) { $RoomLines += "- Feeling: active cobwebs present; examine before any clean/build." }
    elseif ($S.Count -gt 0) { $RoomLines += "- Feeling: mild/medium signals; likely triage needed." }
    else { $RoomLines += "- Feeling: quiet by automated scan; human review still needed." }
    $RoomLines += ""
}
Set-Content -LiteralPath $RoomsReport -Value ($RoomLines -join [Environment]::NewLine) -Encoding UTF8

# Master report.
$SeveritySummary = $Signals | Group-Object Severity | Sort-Object Name
$SignalSummary = $Signals | Group-Object Signal | Sort-Object Count -Descending
$IdeaSummary = $Ideas | Group-Object Marker | Sort-Object Count -Descending

$Master = @()
$Master += "# Deep Cobweb House Scan Restart Report — V1.2"
$Master += ""
$Master += "Timestamp: $Stamp"
$Master += ""
$Master += "## Mission"
$Master += "Restart the serious house scan from the beginning while keeping useful old ideas. Examine every available room/corner/cobweb signal and capture ideas from user, assistant, reports, receipts, messages, scan outputs, and missed wording."
$Master += ""
$Master += "## Boundary"
foreach ($B in $Boundary) { $Master += "- $B" }
$Master += ""
$Master += "## Old Ideas Carried Forward"
$Master += "- Examine cobwebs; do not clean."
$Master += "- Problems become learning signals and possible solutions."
$Master += "- Use stop/list/notes/options/weigh/apply/verify."
$Master += "- Use smoke break only to reset and return to same active issue."
$Master += "- Capture ideas from user and assistant wording."
$Master += "- Audit old reports/messages for missed ideas."
$Master += "- Audit the assistant's last message/plan before moving forward."
$Master += "- Use maps and existing house tools before creating new surfaces."
$Master += ""
$Master += "## Output Files"
$Master += "- Start-over frame: $StartOverFrame"
$Master += "- Inventory: $InventoryCsv"
$Master += "- Cobweb signals: $CobwebCsv"
$Master += "- Idea candidates: $IdeaCsv"
$Master += "- House connection map: $ConnectionMap"
$Master += "- Last-message audit: $LastMessageAudit"
$Master += "- Rooms report: $RoomsReport"
$Master += "- Git state: $GitReport"
$Master += ""
$Master += "## Counts"
$Master += "- Files inventoried: $($Inventory.Count)"
$Master += "- Cobweb signals: $($Signals.Count)"
$Master += "- Idea candidates: $($Ideas.Count)"
$Master += ""
$Master += "## Severity Summary"
foreach ($X in $SeveritySummary) { $Master += "- $($X.Name): $($X.Count)" }
$Master += ""
$Master += "## Signal Summary"
foreach ($X in $SignalSummary | Select-Object -First 25) { $Master += "- $($X.Name): $($X.Count)" }
$Master += ""
$Master += "## Idea Summary"
foreach ($X in $IdeaSummary | Select-Object -First 25) { $Master += "- $($X.Name): $($X.Count)" }
$Master += ""
$Master += "## Top Cobwebs To Examine"
foreach ($Sig in ($Signals | Sort-Object @{Expression={ if ($_.Severity -eq "HIGH") {0} elseif ($_.Severity -eq "MEDIUM") {1} else {2} }}, Room, Path | Select-Object -First 50)) {
    $Master += "- [$($Sig.Severity)] $($Sig.Signal) :: $($Sig.Room) :: $($Sig.Path)"
    $Master += "  - Why: $($Sig.Why)"
    $Master += "  - Learning use: $($Sig.LearningUse)"
}
$Master += ""
$Master += "## Top Ideas To Triage"
foreach ($Idea in ($Ideas | Select-Object -First 50)) {
    $Master += "- [$($Idea.Marker)] $($Idea.Room) :: $($Idea.Path) :: line $($Idea.LineNumber)"
    $Master += "  - Excerpt: $($Idea.Excerpt)"
    $Master += "  - Fit: $($Idea.Fit)"
    $Master += "  - Lane: $($Idea.Lane)"
    $Master += "  - Proof need: $($Idea.ProofNeed)"
}
$Master += ""
$Master += "## Next Options"
$Master += "A. High-cobweb triage first."
$Master += "B. Idea triage first."
$Master += "C. House-connection map review first."
$Master += "D. Rooms/beings/feelings review first."
$Master += ""
$Master += "## Weighing"
$Master += "- A protects safety/proof."
$Master += "- B protects growth and missed ideas."
$Master += "- C prevents isolated new tools."
$Master += "- D gives orientation before detailed triage."
$Master += ""
$Master += "## Recommended Next Move"
$Master += "Read the master report and start-over frame. Then choose A or C. Do not clean."
if (($Signals | Where-Object { $_.Severity -eq "HIGH" }).Count -gt 0) {
    $Master += ""
    $Master += "Final Judge: SCAN COMPLETE / HIGH COBWEBS FOUND / TRIAGE REQUIRED / NO CLEANING DONE"
} else {
    $Master += ""
    $Master += "Final Judge: SCAN COMPLETE / NO HIGH COBWEBS FOUND BY AUTOMATED PASS / HUMAN TRIAGE STILL REQUIRED"
}
Set-Content -LiteralPath $MasterReport -Value ($Master -join [Environment]::NewLine) -Encoding UTF8

$Outputs = @($StartOverFrame,$InventoryCsv,$CobwebCsv,$IdeaCsv,$ConnectionMap,$LastMessageAudit,$RoomsReport,$GitReport,$MasterReport)
$Receipt = @()
$Receipt += "DEEP COBWEB HOUSE SCAN RESTART V1.2 RECEIPT"
$Receipt += "Timestamp: $Stamp"
$Receipt += "Verdict: SCAN COMPLETE / RESTARTED CLEANLY / OLD IDEAS CARRIED FORWARD / READ-ONLY / NO CLEANING"
$Receipt += ""
$Receipt += "Brain repo:"
$Receipt += "- $BrainRepo"
$Receipt += ""
$Receipt += "Scan folder:"
$Receipt += "- $ScanRoot"
$Receipt += ""
$Receipt += "Counts:"
$Receipt += "- Files inventoried: $($Inventory.Count)"
$Receipt += "- Cobweb signals: $($Signals.Count)"
$Receipt += "- Idea candidates: $($Ideas.Count)"
$Receipt += ""
$Receipt += "Outputs:"
foreach ($File in $Outputs) {
    $Receipt += "- $File"
    $Receipt += "  SHA256: $(Get-HashOrNote -Path $File)"
}
$Receipt += ""
$Receipt += "Boundary:"
foreach ($B in $Boundary) { $Receipt += "- $B" }
$Receipt += ""
$Receipt += "Next:"
$Receipt += "- Read master report and start-over frame. Do not clean. Triage first."
Set-Content -LiteralPath $ReceiptPath -Value ($Receipt -join [Environment]::NewLine) -Encoding UTF8

Write-Host "DEEP COBWEB HOUSE SCAN RESTART V1.2 COMPLETE"
Write-Host "Scan folder: $ScanRoot"
Write-Host "Master report: $MasterReport"
Write-Host "Start-over frame: $StartOverFrame"
Write-Host "Connection map: $ConnectionMap"
Write-Host "Idea candidates: $IdeaCsv"
Write-Host "Cobweb signals: $CobwebCsv"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Files inventoried: $($Inventory.Count)"
Write-Host "Cobweb signals: $($Signals.Count)"
Write-Host "Idea candidates: $($Ideas.Count)"
Write-Host "Verdict: SCAN COMPLETE / RESTARTED CLEANLY / OLD IDEAS CARRIED FORWARD / READ-ONLY / NO CLEANING"

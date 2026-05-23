& {
    $ErrorActionPreference = "Stop"

    $Unit123 = "$env:USERPROFILE\Desktop\123"
    $RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Build 123 as a useful outside storage unit that mimics the house without becoming authority."
    Write-Host "Boundary: 123 support/storage only. No Mr.Kleen repo writes. No doctrine. No runtime. No automation. No dashboard."
    Write-Host "Safety: creates rooms, maps, indexes, ledgers, and loose-file report. Does not move existing loose files."
    Write-Host ""

    if (-not (Test-Path -LiteralPath $Unit123)) {
        New-Item -ItemType Directory -Force -Path $Unit123 | Out-Null
    }

    $Rooms = @(
        "_INDEX",
        "_LEDGERS",
        "_TEMPLATES",
        "INBOX",
        "ACTIVE_HANDOFFS",
        "ACTIVE_DESK",
        "TO_MULE",
        "FROM_MULE",
        "TO_MR_KLEEN",
        "RECEIPTS",
        "SCRATCH",
        "TOOLS",
        "TOOL_CANDIDATES",
        "SOURCE_ORE",
        "STORAGE_SHED",
        "STORAGE_SHED\HANDOFF_ARCHIVE",
        "STORAGE_SHED\PACKET_ARCHIVE",
        "STORAGE_SHED\OLD_HELPERS",
        "STORAGE_SHED\SUPERSEDED",
        "QUARANTINE",
        "OUTBOX"
    )

    foreach ($Room in $Rooms) {
        New-Item -ItemType Directory -Force -Path (Join-Path $Unit123 $Room) | Out-Null
    }

    $ReadMe = Join-Path $Unit123 "00_READ_ME_FIRST_123_UNIT.md"
    $Map = Join-Path $Unit123 "_INDEX\123_UNIT_MAP.md"
    $State = Join-Path $Unit123 "_INDEX\CURRENT_123_UNIT_STATE.md"
    $RoomIndex = Join-Path $Unit123 "_INDEX\ROOM_INDEX.md"
    $LooseReport = Join-Path $Unit123 "_INDEX\LOOSE_FILES_FOUND_$RunStamp.md"
    $TransferLog = Join-Path $Unit123 "_LEDGERS\TRANSFER_LOG_$RunStamp.md"
    $RoomPassportTemplate = Join-Path $Unit123 "_TEMPLATES\ROOM_PASSPORT_TEMPLATE.md"
    $PacketIntakeTemplate = Join-Path $Unit123 "_TEMPLATES\PACKET_INTAKE_CARD_TEMPLATE.md"
    $ToolPassportTemplate = Join-Path $Unit123 "_TEMPLATES\TOOL_PASSPORT_TEMPLATE.md"
    $MuleDropTemplate = Join-Path $Unit123 "_TEMPLATES\MULE_DROP_CARD_TEMPLATE.md"
    $UnitReceipt = Join-Path $Unit123 "RECEIPTS\123_UNIT_BUILD_RECEIPT_$RunStamp.txt"

    @(
        "# 123 Unit - Read First",
        "",
        "Date: 2026-05-21",
        "Status: OUTSIDE STORAGE UNIT / SUPPORT ONLY / NOT AUTHORITY",
        "",
        "123 is the assistant outside storage unit.",
        "",
        "Purpose:",
        "The user drops files here so the assistant can find them, classify them, copy them into the correct Mr.Kleen lane, or package them for mule work.",
        "",
        "Boundary:",
        "123 is not Mr.Kleen authority.",
        "123 is not doctrine.",
        "123 is not proof by itself.",
        "123 is not CURRENT_TRUTH_INDEX.",
        "123 is not ACTIVE_GUIDES.",
        "123 is not a dumping ground for loose helpers.",
        "",
        "Working rule:",
        "Drop new files in INBOX when possible.",
        "Current handoffs go in ACTIVE_HANDOFFS.",
        "Files being prepared go in ACTIVE_DESK.",
        "Packets going to mule go in TO_MULE.",
        "Mule returns go in FROM_MULE until copied into Mr.Kleen.",
        "Files selected for house intake go in TO_MR_KLEEN.",
        "Old packets move to STORAGE_SHED.",
        "Temporary work goes in SCRATCH and should decay.",
        "Suspicious or unclear files go in QUARANTINE.",
        "",
        "Clean sentence:",
        "123 is the bridge-side storage unit: useful, organized, and supportive, but never authority."
    ) | Set-Content -LiteralPath $ReadMe -Encoding UTF8

    @(
        "# 123 Unit Map",
        "",
        "Date: 2026-05-21",
        "",
        "123 mimics the house lightly. It has rooms, maps, ledgers, templates, and storage lanes, but it does not become the house.",
        "",
        "Room map:",
        "",
        "_INDEX",
        "Orientation files, current unit state, room list, loose-file reports.",
        "",
        "_LEDGERS",
        "Transfer logs and local 123-side event notes.",
        "",
        "_TEMPLATES",
        "Reusable cards for room passports, packet intake, tool passports, and mule drops.",
        "",
        "INBOX",
        "New unsorted user drops.",
        "",
        "ACTIVE_HANDOFFS",
        "Current handoff packets that are live now.",
        "",
        "ACTIVE_DESK",
        "In-progress staging for the current local unit task.",
        "",
        "TO_MULE",
        "Packets prepared to send to the mule.",
        "",
        "FROM_MULE",
        "Mule returns before Mr.Kleen intake.",
        "",
        "TO_MR_KLEEN",
        "Files selected for house intake, not yet saved/proved inside Mr.Kleen.",
        "",
        "RECEIPTS",
        "Local 123 receipts and build notes.",
        "",
        "SCRATCH",
        "Temporary work. Should be cleaned or decayed.",
        "",
        "TOOLS",
        "Kept tools that have a passport or clear role.",
        "",
        "TOOL_CANDIDATES",
        "Unproved tools or helper candidates.",
        "",
        "SOURCE_ORE",
        "Useful material that is not command authority.",
        "",
        "STORAGE_SHED",
        "Archive/storage for old packets, old handoffs, old helpers, and superseded material.",
        "",
        "QUARANTINE",
        "Unclear, suspicious, malformed, or risky files.",
        "",
        "OUTBOX",
        "Files ready for the user to move/send elsewhere.",
        "",
        "Core rule:",
        "Current vs old, source vs authority, input vs output, and temporary vs kept must stay separated."
    ) | Set-Content -LiteralPath $Map -Encoding UTF8

    @(
        "# Current 123 Unit State",
        "",
        "Date: 2026-05-21",
        "Last build stamp: $RunStamp",
        "",
        "Status:",
        "Unit rooms created or verified.",
        "",
        "Current active use:",
        "Outside storage and staging for assistant/mule/Mr.Kleen file traffic.",
        "",
        "Current rule:",
        "Do not treat 123 as authority. Do not leave helpers loose. Route selected material into Mr.Kleen with proof when chosen.",
        "",
        "Next likely use:",
        "Drop mule packets, returns, helper files, or source packets here for classification and routing.",
        "",
        "Watch:",
        "Loose files in the root should be classified later instead of staying loose forever."
    ) | Set-Content -LiteralPath $State -Encoding UTF8

    @(
        "# Room Index",
        "",
        "Date: 2026-05-21",
        "",
        "INBOX: New drops.",
        "ACTIVE_HANDOFFS: Current live handoffs.",
        "ACTIVE_DESK: Current staging.",
        "TO_MULE: Prepared mule packets.",
        "FROM_MULE: Mule returns before house intake.",
        "TO_MR_KLEEN: Selected files for house intake.",
        "RECEIPTS: 123-side receipts.",
        "SCRATCH: Temporary work.",
        "TOOLS: Kept helper tools with clear role.",
        "TOOL_CANDIDATES: Unproved helper candidates.",
        "SOURCE_ORE: Useful non-authority material.",
        "STORAGE_SHED: Old packets, old helpers, archive.",
        "QUARANTINE: Suspicious or unclear files.",
        "OUTBOX: Ready for user to move/send."
    ) | Set-Content -LiteralPath $RoomIndex -Encoding UTF8

    @(
        "# Room Passport Template",
        "",
        "ROOM NAME:",
        "MISSION:",
        "WHAT BELONGS HERE:",
        "WHAT DOES NOT BELONG HERE:",
        "INPUTS:",
        "OUTPUTS:",
        "AUTHORITY BOUNDARY:",
        "CLEANUP / ARCHIVE RULE:",
        "STALE CONDITION:",
        "DECAY CONDITION:",
        "NEIGHBOR ROOMS:",
        "CURRENT WATCH:"
    ) | Set-Content -LiteralPath $RoomPassportTemplate -Encoding UTF8

    @(
        "# Packet Intake Card Template",
        "",
        "PACKET NAME:",
        "SOURCE LOCATION:",
        "DATE SEEN:",
        "INTENDED ROUTE:",
        "FILES INCLUDED:",
        "EXPECTED READ-FIRST FILE:",
        "AUTHORITY STATE:",
        "WHAT IT CAN DO:",
        "WHAT IT MUST NOT DO:",
        "MISSING FILES:",
        "HASHES NEEDED:",
        "NEXT ACTION:",
        "ARCHIVE / CLEANUP RULE:"
    ) | Set-Content -LiteralPath $PacketIntakeTemplate -Encoding UTF8

    @(
        "# Tool Passport Template",
        "",
        "TOOL NAME:",
        "HOME:",
        "TYPE:",
        "TRIGGER:",
        "INPUTS:",
        "OUTPUTS:",
        "ALLOWED TOUCH:",
        "BLOCKED TOUCH:",
        "AUTHORITY BOUNDARY:",
        "PROOF NEEDED:",
        "SELF-CLEAN / ARCHIVE RULE:",
        "REPLACES:",
        "OVERLAPS:",
        "NEIGHBORS:",
        "STALE CONDITION:",
        "DECAY CONDITION:",
        "OWNER / JUDGE:",
        "LAST PROVED USE:",
        "EVENT TRACE HOOK:",
        "NEXT TEST:"
    ) | Set-Content -LiteralPath $ToolPassportTemplate -Encoding UTF8

    @(
        "# Mule Drop Card Template",
        "",
        "DROP NAME:",
        "READ FIRST FILE:",
        "TASK:",
        "READ ORDER:",
        "SOURCE FILES:",
        "OUTPUT LANE:",
        "RETURN FOLDER:",
        "BOUNDARY:",
        "BLOCKED MOVES:",
        "PASS STANDARD:",
        "MISSING FILE RULE:",
        "ARCHIVE RULE:",
        "KICKOFF TEXT:"
    ) | Set-Content -LiteralPath $MuleDropTemplate -Encoding UTF8

    $LooseFiles = @(Get-ChildItem -LiteralPath $Unit123 -File -Force -ErrorAction SilentlyContinue | Sort-Object Name)
    $LooseLines = @(
        "# Loose Files Found In 123 Root",
        "",
        "Date: 2026-05-21",
        "Build stamp: $RunStamp",
        "",
        "This report does not move files. It only lists loose root files for later classification.",
        "",
        "Recommended later actions:",
        "- handoff packets -> ACTIVE_HANDOFFS or TO_MULE;",
        "- mule returns -> FROM_MULE;",
        "- selected house intake -> TO_MR_KLEEN;",
        "- temporary helpers -> delete after proof or move to TOOL_CANDIDATES;",
        "- old packets -> STORAGE_SHED;",
        "- unclear/risky -> QUARANTINE.",
        "",
        "Loose files:"
    )

    if ($LooseFiles.Count -eq 0) {
        $LooseLines += "NONE"
    } else {
        foreach ($File in $LooseFiles) {
            $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash
            $LooseLines += "- $($File.Name) | SHA256: $Hash | LastWrite: $($File.LastWriteTime.ToString('o'))"
        }
    }

    $LooseLines | Set-Content -LiteralPath $LooseReport -Encoding UTF8

    @(
        "# 123 Transfer Log",
        "",
        "Date: 2026-05-21",
        "Build stamp: $RunStamp",
        "",
        "EVENT: UNIT BUILD",
        "ACTION: Created or verified house-mimic room structure for 123.",
        "MOVED FILES: NONE",
        "COPIED FILES: NONE",
        "DELETED FILES: only temporary RUN_BUILD_123_UNIT_HOUSE_MIMIC helper after successful proof, if present.",
        "BOUNDARY: 123 remains support/storage, not authority.",
        "",
        "Loose file report:",
        $LooseReport
    ) | Set-Content -LiteralPath $TransferLog -Encoding UTF8

    $FilesForReceipt = @($ReadMe, $Map, $State, $RoomIndex, $LooseReport, $TransferLog, $RoomPassportTemplate, $PacketIntakeTemplate, $ToolPassportTemplate, $MuleDropTemplate)

    $ReceiptLines = @(
        "123 UNIT HOUSE-MIMIC BUILD RECEIPT",
        "Date: " + (Get-Date -Format o),
        "",
        "Verdict:",
        "PASS AS 123 OUTSIDE STORAGE UNIT STRUCTURE / NO MR.KLEEN REPO WRITE",
        "",
        "Unit path:",
        $Unit123,
        "",
        "Boundary:",
        "123 is support/storage only.",
        "123 is not authority, doctrine, proof by itself, ACTIVE_GUIDES, or CURRENT_TRUTH_INDEX.",
        "",
        "Rooms created or verified:"
    )

    foreach ($Room in $Rooms) {
        $ReceiptLines += (Join-Path $Unit123 $Room)
    }

    $ReceiptLines += @("", "Files written:")

    foreach ($FilePath in $FilesForReceipt) {
        $Hash = (Get-FileHash -LiteralPath $FilePath -Algorithm SHA256).Hash
        $ReceiptLines += $FilePath
        $ReceiptLines += "SHA256: $Hash"
    }

    $ReceiptLines += @(
        "",
        "Moved existing loose files:",
        "NONE",
        "",
        "Next:",
        "Use INBOX for new drops, ACTIVE_HANDOFFS for current handoffs, TO_MULE/FROM_MULE for mule traffic, TO_MR_KLEEN for selected house intake, and STORAGE_SHED for old packets."
    )

    $ReceiptLines | Set-Content -LiteralPath $UnitReceipt -Encoding UTF8
    $ReceiptHash = (Get-FileHash -LiteralPath $UnitReceipt -Algorithm SHA256).Hash

    $CleanupMessages = @()
    $Helpers = @(Get-ChildItem -LiteralPath $Unit123 -File -Filter "RUN_BUILD_123_UNIT_HOUSE_MIMIC*.ps1" -ErrorAction SilentlyContinue)
    foreach ($Helper in $Helpers) {
        try {
            Remove-Item -LiteralPath $Helper.FullName -Force
            $CleanupMessages += "REMOVED TEMP HELPER: $($Helper.FullName)"
        }
        catch {
            $CleanupMessages += "FAILED TEMP HELPER CLEANUP: $($Helper.FullName) :: $($_.Exception.Message)"
        }
    }

    if ($CleanupMessages.Count -eq 0) {
        $CleanupMessages += "NO TEMP HELPERS FOUND FOR CLEANUP"
    }

    Write-Host ""
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
    Write-Host "123 UNIT HOUSE-MIMIC BUILD COMPLETE"
    Write-Host "Verdict: PASS AS 123 OUTSIDE STORAGE UNIT STRUCTURE / NO MR.KLEEN REPO WRITE"
    Write-Host "Unit path: $Unit123"
    Write-Host "Read first: $ReadMe"
    Write-Host "Unit map: $Map"
    Write-Host "Current state: $State"
    Write-Host "Loose file report: $LooseReport"
    Write-Host "Transfer log: $TransferLog"
    Write-Host "Receipt: $UnitReceipt"
    Write-Host "Receipt SHA256: $ReceiptHash"
    foreach ($Line in $CleanupMessages) {
        Write-Host "Temporary helper cleanup: $Line"
    }
    Write-Host "Rooms: _INDEX, _LEDGERS, _TEMPLATES, INBOX, ACTIVE_HANDOFFS, ACTIVE_DESK, TO_MULE, FROM_MULE, TO_MR_KLEEN, RECEIPTS, SCRATCH, TOOLS, TOOL_CANDIDATES, SOURCE_ORE, STORAGE_SHED, QUARANTINE, OUTBOX"
    Write-Host "Boundary: 123 is support/storage, not authority. No repo write, no doctrine, no runtime, no dashboard."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
}
& {
    $ErrorActionPreference = "Stop"

    $Root123 = "$env:USERPROFILE\Desktop\123"
    $CommandCenter = Join-Path $Root123 "COMMAND_CENTER"
    $Rooms = Join-Path $CommandCenter "ROOMS"
    $Teleporters = Join-Path $CommandCenter "TELEPORTERS"
    $Receipts = Join-Path $CommandCenter "RECEIPTS"
    $Snapshots = Join-Path $CommandCenter "SNAPSHOTS"
    $Templates = Join-Path $CommandCenter "TEMPLATES"
    $Outbox = Join-Path $CommandCenter "OUTBOX_TO_CHAT"
    $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"

    $HouseRoot = "$env:USERPROFILE\Desktop\Jxhnny_Kleen_C3dz"
    $DockRoot = "$env:USERPROFILE\Desktop\123\MR_KLEEN_HOUSE_DOCK\Jxhnny_Kleen_C33dz"
    $BridgeRoot = "$env:USERPROFILE\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1"
    $MuleWorkshopLocal = "$env:USERPROFILE\Desktop\MR_KLEEN_MULE_WORKSHOP_LOCAL"
    $Downloads = "$env:USERPROFILE\Downloads"

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Build No-Git Command Center V1 in Desktop\123."
    Write-Host "Boundary: local 123 setup only. No Mr.Kleen repo write. No git add/commit/push. No bridge permission expansion. No junction/symlink teleporter."
    Write-Host ""

    if (-not (Test-Path -LiteralPath $Root123)) {
        throw "STOP. Desktop\123 not found: $Root123"
    }

    if (Test-Path -LiteralPath $CommandCenter) {
        throw "STOP. COMMAND_CENTER already exists. Not overwriting: $CommandCenter"
    }

    function Bool-Text {
        param([bool]$Value)
        if ($Value) { return "YES" }
        return "NO"
    }

    function Path-Exists {
        param([string]$Path)
        return (Test-Path -LiteralPath $Path)
    }

    function Write-Utf8 {
        param(
            [string]$Path,
            [string[]]$Lines
        )
        $Dir = Split-Path -Parent $Path
        if ($Dir -and -not (Test-Path -LiteralPath $Dir)) {
            New-Item -ItemType Directory -Force -Path $Dir | Out-Null
        }
        $Lines | Set-Content -LiteralPath $Path -Encoding UTF8
    }

    function New-RoomCard {
        param(
            [string]$RoomPath,
            [string]$RoomName,
            [string]$Purpose,
            [string]$TargetPath,
            [string[]]$AllowedInputs,
            [string[]]$AllowedOutputs,
            [string[]]$AllowedActions,
            [string[]]$BlockedActions,
            [string[]]$ProofRequired,
            [string]$CloseCondition,
            [string]$ReturnPath
        )

        New-Item -ItemType Directory -Force -Path $RoomPath | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $RoomPath "INBOX"), (Join-Path $RoomPath "OUTBOX"), (Join-Path $RoomPath "RECEIPTS"), (Join-Path $RoomPath "WORK") | Out-Null

        $Lines = New-Object System.Collections.Generic.List[string]
        $Lines.Add("# ROOM CARD - $RoomName") | Out-Null
        $Lines.Add("") | Out-Null
        $Lines.Add("Created: $(Get-Date -Format o)") | Out-Null
        $Lines.Add("Status: CONTROLLED ATMOSPHERE ROOM / V1") | Out-Null
        $Lines.Add("") | Out-Null
        $Lines.Add("## Purpose") | Out-Null
        $Lines.Add($Purpose) | Out-Null
        $Lines.Add("") | Out-Null
        $Lines.Add("## Target Path") | Out-Null
        $Lines.Add($TargetPath) | Out-Null
        $Lines.Add("") | Out-Null
        $Lines.Add("## Allowed Inputs") | Out-Null
        foreach ($Item in $AllowedInputs) { $Lines.Add("- $Item") | Out-Null }
        $Lines.Add("") | Out-Null
        $Lines.Add("## Allowed Outputs") | Out-Null
        foreach ($Item in $AllowedOutputs) { $Lines.Add("- $Item") | Out-Null }
        $Lines.Add("") | Out-Null
        $Lines.Add("## Allowed Actions") | Out-Null
        foreach ($Item in $AllowedActions) { $Lines.Add("- $Item") | Out-Null }
        $Lines.Add("") | Out-Null
        $Lines.Add("## Blocked Actions") | Out-Null
        foreach ($Item in $BlockedActions) { $Lines.Add("- $Item") | Out-Null }
        $Lines.Add("") | Out-Null
        $Lines.Add("## Proof Required") | Out-Null
        foreach ($Item in $ProofRequired) { $Lines.Add("- $Item") | Out-Null }
        $Lines.Add("") | Out-Null
        $Lines.Add("## Receipt Lane") | Out-Null
        $Lines.Add("RECEIPTS") | Out-Null
        $Lines.Add("") | Out-Null
        $Lines.Add("## Close Condition") | Out-Null
        $Lines.Add($CloseCondition) | Out-Null
        $Lines.Add("") | Out-Null
        $Lines.Add("## Return Path") | Out-Null
        $Lines.Add($ReturnPath) | Out-Null
        $Lines.Add("") | Out-Null
        $Lines.Add("## Boundary") | Out-Null
        $Lines.Add("This room does not grant global PC access. It only defines a controlled atmosphere, intended route, and proof requirement.") | Out-Null

        Write-Utf8 -Path (Join-Path $RoomPath "ROOM_CARD.md") -Lines $Lines.ToArray()
    }

    function New-PointerRoom {
        param(
            [string]$PointerPath,
            [string]$PointerName,
            [string]$TargetPath,
            [string]$Purpose,
            [string[]]$AllowedActions,
            [string[]]$BlockedActions
        )

        New-Item -ItemType Directory -Force -Path $PointerPath | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $PointerPath "RECEIPTS") | Out-Null

        Write-Utf8 -Path (Join-Path $PointerPath "TARGET_PATH.txt") -Lines @($TargetPath)

        Write-Utf8 -Path (Join-Path $PointerPath "POINTER_CARD.md") -Lines @(
            "# POINTER ROOM - $PointerName",
            "",
            "Created: $(Get-Date -Format o)",
            "Status: TEXT POINTER ONLY / NO JUNCTION / NO SYMLINK",
            "",
            "## Purpose",
            $Purpose,
            "",
            "## Target Path",
            $TargetPath,
            "",
            "## Target Exists",
            (Bool-Text (Path-Exists $TargetPath)),
            "",
            "## Allowed Actions",
            ($AllowedActions | ForEach-Object { "- $_" }),
            "",
            "## Blocked Actions",
            ($BlockedActions | ForEach-Object { "- $_" }),
            "",
            "## Proof Required",
            "- before/after path readback;",
            "- file count or hash when relevant;",
            "- receipt saved in RECEIPTS;",
            "- copy-back summary to chat when assistant is involved.",
            "",
            "## Boundary",
            "This pointer does not link the filesystem. It is not a junction or symlink. It is a controlled map to an outside room."
        )
    }

    New-Item -ItemType Directory -Force -Path $CommandCenter, $Rooms, $Teleporters, $Receipts, $Snapshots, $Templates, $Outbox | Out-Null

    Write-Utf8 -Path (Join-Path $CommandCenter "README_START_HERE.md") -Lines @(
        "# No-Git Command Center V1",
        "",
        "Created: $(Get-Date -Format o)",
        "",
        "## Purpose",
        "",
        "This folder is the live working doorway for the assistant.",
        "",
        "Git is no longer required as the live thinking doorway. Git may still be used later for export, backup, public proof, or version history.",
        "",
        "## Core Formula",
        "",
        "user request -> chat direction prompt -> COMMAND_CENTER -> room card -> child action/manual route -> receipt -> context cart back to chat",
        "",
        "## Main Rule",
        "",
        "Git is for locked/public proof when selected. COMMAND_CENTER is for live working truth.",
        "",
        "## Read Order",
        "",
        "1. CURRENT_CONTEXT_CART.md",
        "2. NEXT_ON_THE_PLATE.md",
        "3. BLOCKED_MOVES.md",
        "4. ROOM_INDEX.md",
        "5. relevant ROOM_CARD.md or POINTER_CARD.md",
        "",
        "## Boundary",
        "",
        "This is a local 123 setup only. It does not write to Mr.Kleen. It does not run git. It does not install doctrine. It does not expand bridge permissions. It does not create junctions or symlinks.",
        "",
        "## Controlled Atmosphere Principle",
        "",
        "A folder can be more than storage. A folder can be a bounded operating room with purpose, rules, proof, and exit."
    )

    Write-Utf8 -Path (Join-Path $CommandCenter "ASSISTANT_DIRECTION_PROMPT.md") -Lines @(
        "# Assistant Direction Prompt - Command Center V1",
        "",
        "When the user asks what is next, asks where something goes, asks to drop a file to mule, asks to build a packet, asks to use a bridge, or asks for current state:",
        "",
        "1. Treat COMMAND_CENTER as the live working doorway.",
        "2. Read CURRENT_CONTEXT_CART.md first.",
        "3. Read NEXT_ON_THE_PLATE.md and BLOCKED_MOVES.md.",
        "4. Use ROOM_INDEX.md to choose the correct controlled atmosphere room.",
        "5. Use ROOM_CARD.md or POINTER_CARD.md before acting.",
        "6. Produce or request a receipt for meaningful actions.",
        "7. Do not use Git as the live thinking doorway unless the user explicitly selects a lock/save/public-proof route.",
        "",
        "Never assume global PC access. Never treat a pointer room as permission to operate outside its card."
    )

    Write-Utf8 -Path (Join-Path $CommandCenter "CURRENT_CONTEXT_CART.md") -Lines @(
        "# Current Context Cart",
        "",
        "Created: $(Get-Date -Format o)",
        "",
        "## Active Boss",
        "",
        "No-Git Command Center / Controlled Atmosphere Rooms V1 setup.",
        "",
        "## Current State",
        "",
        "Child Shell V1 behavior is proved.",
        "Sam review packet is locked to Git.",
        "Command Center V1 is being created in Desktop\\123 as the live working doorway.",
        "",
        "## Current Claim",
        "",
        "A local command center can carry live working truth without making Git the required thinking doorway.",
        "",
        "## Current Formula",
        "",
        "user request -> chat direction prompt -> COMMAND_CENTER -> room card -> child action/manual route -> receipt -> context cart back to chat",
        "",
        "## Known House Root",
        "",
        $HouseRoot,
        "",
        "Exists: $(Bool-Text (Path-Exists $HouseRoot))",
        "",
        "## Known Bridge Root",
        "",
        $BridgeRoot,
        "",
        "Exists: $(Bool-Text (Path-Exists $BridgeRoot))",
        "",
        "## Known 123 Root",
        "",
        $Root123,
        "",
        "Exists: YES",
        "",
        "## Proof Boundary",
        "",
        "This setup is local-only and does not replace Git as public proof yet. It replaces Git as the live working doorway."
    )

    Write-Utf8 -Path (Join-Path $CommandCenter "NEXT_ON_THE_PLATE.md") -Lines @(
        "# Next On The Plate",
        "",
        "Created: $(Get-Date -Format o)",
        "",
        "## Current next",
        "",
        "Use this Command Center on the next real work request.",
        "",
        "## Suggested next proof",
        "",
        "Ask: 'what is next on the plate?' and use this folder as the source of the answer.",
        "",
        "## Next possible rooms",
        "",
        "- THINK_TANK: shape concepts and packets.",
        "- MULE_WORKSHOP_ROOM: stage packets/returns for mule work.",
        "- CHILD_SHELL_ROOM: bridge tests and local helper proof.",
        "- PUBLIC_PACKET_ROOM: public review packets and outward-facing proof packages.",
        "- IDEA_QUARANTINE_ROOM: strange/raw ideas before promotion.",
        "",
        "## Close condition",
        "",
        "V1 is proved when a fresh request can be routed from chat through COMMAND_CENTER to the correct room without needing Git as the live source."
    )

    Write-Utf8 -Path (Join-Path $CommandCenter "BLOCKED_MOVES.md") -Lines @(
        "# Blocked Moves",
        "",
        "Created: $(Get-Date -Format o)",
        "",
        "- Do not use Git as the default live thinking doorway.",
        "- Do not remove Git as archive/public proof yet.",
        "- Do not create junctions or symlinks for teleporters yet.",
        "- Do not expand Child Shell permissions.",
        "- Do not write to Mr.Kleen from this setup script.",
        "- Do not treat pointer rooms as global PC access.",
        "- Do not install doctrine from this prototype.",
        "- Do not overwrite existing command center folders.",
        "- Do not route strange/raw ideas straight into public packets or doctrine."
    )

    Write-Utf8 -Path (Join-Path $CommandCenter "ROOM_INDEX.md") -Lines @(
        "# Room Index",
        "",
        "Created: $(Get-Date -Format o)",
        "",
        "## Rooms",
        "",
        "| Room | Purpose | First file |",
        "|---|---|---|",
        "| THINK_TANK | compose, review, sort, and shape ideas | ROOMS/THINK_TANK/ROOM_CARD.md |",
        "| MULE_WORKSHOP_ROOM | stage mule drops/returns through controlled lanes | ROOMS/MULE_WORKSHOP_ROOM/ROOM_CARD.md |",
        "| CHILD_SHELL_ROOM | child shell bridge tests and helper proof | ROOMS/CHILD_SHELL_ROOM/ROOM_CARD.md |",
        "| PUBLIC_PACKET_ROOM | public review packets and proof packages | ROOMS/PUBLIC_PACKET_ROOM/ROOM_CARD.md |",
        "| IDEA_QUARANTINE_ROOM | raw strange ideas before translation/proof | ROOMS/IDEA_QUARANTINE_ROOM/ROOM_CARD.md |",
        "",
        "## Pointer Rooms",
        "",
        "| Pointer | Target type | First file |",
        "|---|---|---|",
        "| MR_KLEEN_HOUSE_POINTER | active house pointer | TELEPORTERS/MR_KLEEN_HOUSE_POINTER/POINTER_CARD.md |",
        "| MULE_WORKSHOP_POINTER | mule workshop pointer | TELEPORTERS/MULE_WORKSHOP_POINTER/POINTER_CARD.md |",
        "| LOCAL_HARD_BRIDGE_POINTER | bridge pointer | TELEPORTERS/LOCAL_HARD_BRIDGE_POINTER/POINTER_CARD.md |",
        "| DOWNLOADS_POINTER | download intake pointer | TELEPORTERS/DOWNLOADS_POINTER/POINTER_CARD.md |",
        "| PACKETS_POINTER | packet staging pointer | TELEPORTERS/PACKETS_POINTER/POINTER_CARD.md |"
    )

    Write-Utf8 -Path (Join-Path $Templates "CONTROLLED_ATMOSPHERE_ROOM_TEMPLATE.md") -Lines @(
        "# Controlled Atmosphere Room Template",
        "",
        "ROOM NAME:",
        "PURPOSE:",
        "TARGET PATH:",
        "ALLOWED INPUTS:",
        "ALLOWED OUTPUTS:",
        "ALLOWED ACTIONS:",
        "BLOCKED ACTIONS:",
        "PROOF REQUIRED:",
        "RECEIPT LANE:",
        "CLOSE CONDITION:",
        "RETURN PATH:",
        "",
        "Rule: A room is not a vibe. A room is a bounded environment with purpose, route, proof, and close condition."
    )

    New-RoomCard -RoomPath (Join-Path $Rooms "THINK_TANK") -RoomName "THINK_TANK" `
        -Purpose "Compose, review, edit, pressure-test, and shape ideas before they become packets, rules, tools, or public material." `
        -TargetPath (Join-Path $Rooms "THINK_TANK") `
        -AllowedInputs @("raw idea notes", "concept drafts", "review/edit targets", "proof-plan sketches") `
        -AllowedOutputs @("clean concept cards", "packet outlines", "review notes", "park/revise/prove decisions") `
        -AllowedActions @("draft", "review", "split", "merge", "park", "prepare packet source") `
        -BlockedActions @("doctrine install", "public post", "bridge permission expansion", "git commit/push", "treat raw idea as truth") `
        -ProofRequired @("decision note", "source/claim split", "limits", "next proof step if promoted") `
        -CloseCondition "Idea is either parked, split, rejected, or promoted to a proof plan." `
        -ReturnPath "CURRENT_CONTEXT_CART.md or OUTBOX_TO_CHAT"

    New-RoomCard -RoomPath (Join-Path $Rooms "MULE_WORKSHOP_ROOM") -RoomName "MULE_WORKSHOP_ROOM" `
        -Purpose "Stage mule handoffs, mule returns, manifests, request cards, and return receipts without letting mule work bleed into the house." `
        -TargetPath $MuleWorkshopLocal `
        -AllowedInputs @("handoff packets", "request cards", "return folders", "manifest files") `
        -AllowedOutputs @("return readbacks", "intake receipts", "disposition notes", "archive decisions") `
        -AllowedActions @("stage packet", "read manifest", "inventory return", "copy return to intake lane", "write receipt") `
        -BlockedActions @("direct doctrine install", "silent overwrite", "delete return evidence", "git commit/push", "unbounded folder crawl") `
        -ProofRequired @("manifest", "file count", "hashes when relevant", "receipt") `
        -CloseCondition "Mule work is staged, returned, archived, or parked with receipt." `
        -ReturnPath "COMMAND_CENTER/OUTBOX_TO_CHAT"

    New-RoomCard -RoomPath (Join-Path $Rooms "CHILD_SHELL_ROOM") -RoomName "CHILD_SHELL_ROOM" `
        -Purpose "Hold bridge helper tests, child shell evidence, hardening scouts, and local-action proof." `
        -TargetPath $BridgeRoot `
        -AllowedInputs @("bridge request files", "helper scripts", "test reports", "response/receipt readbacks") `
        -AllowedOutputs @("green proof blocks", "evidence reports", "hardening findings", "safe helper files") `
        -AllowedActions @("run local diagnostic", "read response", "read receipt", "hash output", "prepare hardening note") `
        -BlockedActions @("arbitrary shell expansion", "delete action", "overwrite action", "house write mode", "git commit/push", "network service") `
        -ProofRequired @("request ids", "responses", "receipts", "hashes", "front door state when relevant") `
        -CloseCondition "Test passes, fails, or yields with evidence report." `
        -ReturnPath "COMMAND_CENTER/OUTBOX_TO_CHAT"

    New-RoomCard -RoomPath (Join-Path $Rooms "PUBLIC_PACKET_ROOM") -RoomName "PUBLIC_PACKET_ROOM" `
        -Purpose "Build, review, polish, and stage public-review packets without turning public attention into the active boss." `
        -TargetPath $Root123 `
        -AllowedInputs @("proof packets", "public briefs", "GitHub packet folders", "screenshots used as support material") `
        -AllowedOutputs @("final packet zip", "manifest", "hash list", "public one-pager") `
        -AllowedActions @("pack", "review-edit", "hash", "stage", "prepare send text") `
        -BlockedActions @("overpost", "inflate claim", "call prototype production-secure", "install doctrine", "bridge expansion") `
        -ProofRequired @("manifest", "hashes", "limits", "read-first file", "review/edit QA") `
        -CloseCondition "Packet is built, staged, locked, or parked." `
        -ReturnPath "COMMAND_CENTER/OUTBOX_TO_CHAT"

    New-RoomCard -RoomPath (Join-Path $Rooms "IDEA_QUARANTINE_ROOM") -RoomName "IDEA_QUARANTINE_ROOM" `
        -Purpose "Hold raw strange ideas safely before translation, proof, promotion, or rejection." `
        -TargetPath (Join-Path $Rooms "IDEA_QUARANTINE_ROOM") `
        -AllowedInputs @("raw strange idea", "fear/excitement note", "metaphor", "unproven architecture hunch") `
        -AllowedOutputs @("plain translation", "mechanism split", "risk note", "smallest test", "park/prove/reject decision") `
        -AllowedActions @("capture raw", "translate", "split mechanism from metaphor", "park", "prepare smallest test") `
        -BlockedActions @("doctrine install", "public packet", "system expansion", "treat feeling as proof", "delete source idea") `
        -ProofRequired @("raw claim", "plain translation", "risk", "smallest test", "disposition") `
        -CloseCondition "Idea is parked, translated, split, rejected, or moved to Think Tank for proof design." `
        -ReturnPath "COMMAND_CENTER/OUTBOX_TO_CHAT"

    New-PointerRoom -PointerPath (Join-Path $Teleporters "MR_KLEEN_HOUSE_POINTER") -PointerName "MR_KLEEN_HOUSE_POINTER" `
        -TargetPath $HouseRoot `
        -Purpose "Text pointer to the active Mr.Kleen house. Not live authority by itself." `
        -AllowedActions @("read pointer", "request front door readback", "request selected file readback", "prepare save route only when user selects it") `
        -BlockedActions @("silent write", "doctrine install", "git commit/push by default", "global crawl", "overwrite")

    New-PointerRoom -PointerPath (Join-Path $Teleporters "MULE_WORKSHOP_POINTER") -PointerName "MULE_WORKSHOP_POINTER" `
        -TargetPath $MuleWorkshopLocal `
        -Purpose "Text pointer to mule workshop local area." `
        -AllowedActions @("stage handoff", "find return manifest", "copy selected packet with receipt", "read inventory") `
        -BlockedActions @("delete return", "overwrite return", "install return directly", "treat mule output as doctrine")

    New-PointerRoom -PointerPath (Join-Path $Teleporters "LOCAL_HARD_BRIDGE_POINTER") -PointerName "LOCAL_HARD_BRIDGE_POINTER" `
        -TargetPath $BridgeRoot `
        -Purpose "Text pointer to Local Hard Bridge V1." `
        -AllowedActions @("run approved helper", "read response", "read receipt", "hash evidence") `
        -BlockedActions @("add raw shell", "add delete", "add overwrite", "house write expansion", "network service")

    New-PointerRoom -PointerPath (Join-Path $Teleporters "DOWNLOADS_POINTER") -PointerName "DOWNLOADS_POINTER" `
        -TargetPath $Downloads `
        -Purpose "Text pointer for downloaded packets/helpers before staging." `
        -AllowedActions @("locate known filename", "verify hash", "copy to 123 staging") `
        -BlockedActions @("run unknown downloads", "delete", "bulk move", "trust without hash")

    New-PointerRoom -PointerPath (Join-Path $Teleporters "PACKETS_POINTER") -PointerName "PACKETS_POINTER" `
        -TargetPath $Root123 `
        -Purpose "Text pointer to 123 packet staging." `
        -AllowedActions @("stage packet folder", "unpack zip", "hash files", "write placement receipt") `
        -BlockedActions @("overwrite packet", "publish by default", "install doctrine", "delete old packet without user command")

    $SnapshotPath = Join-Path $Snapshots "COMMAND_CENTER_V1_INITIAL_SNAPSHOT_$Stamp.txt"
    $FileList = @(Get-ChildItem -LiteralPath $CommandCenter -Recurse -File | Sort-Object FullName)
    $SnapshotLines = New-Object System.Collections.Generic.List[string]
    $SnapshotLines.Add("COMMAND CENTER V1 INITIAL SNAPSHOT") | Out-Null
    $SnapshotLines.Add("Date: $(Get-Date -Format o)") | Out-Null
    $SnapshotLines.Add("Root: $CommandCenter") | Out-Null
    $SnapshotLines.Add("File count before snapshot write: $($FileList.Count)") | Out-Null
    $SnapshotLines.Add("") | Out-Null
    foreach ($File in $FileList) {
        $Rel = $File.FullName.Substring($CommandCenter.Length).TrimStart('\')
        $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash
        $SnapshotLines.Add("$Rel | SHA256: $Hash") | Out-Null
    }
    $SnapshotLines | Set-Content -LiteralPath $SnapshotPath -Encoding UTF8

    $ReceiptPath = Join-Path $Receipts "COMMAND_CENTER_V1_BUILD_RECEIPT_$Stamp.txt"
    $AllFiles = @(Get-ChildItem -LiteralPath $CommandCenter -Recurse -File | Sort-Object FullName)
    $ReceiptLines = New-Object System.Collections.Generic.List[string]
    $ReceiptLines.Add("NO-GIT COMMAND CENTER V1 BUILD RECEIPT") | Out-Null
    $ReceiptLines.Add("Date: $(Get-Date -Format o)") | Out-Null
    $ReceiptLines.Add("") | Out-Null
    $ReceiptLines.Add("Verdict: BUILT") | Out-Null
    $ReceiptLines.Add("") | Out-Null
    $ReceiptLines.Add("Command Center: $CommandCenter") | Out-Null
    $ReceiptLines.Add("File count: $($AllFiles.Count)") | Out-Null
    $ReceiptLines.Add("") | Out-Null
    $ReceiptLines.Add("Boundary: local 123 setup only; no Mr.Kleen repo write; no git add/commit/push; no bridge permission expansion; no junction/symlink teleporter.") | Out-Null
    $ReceiptLines.Add("") | Out-Null
    $ReceiptLines.Add("Known roots:") | Out-Null
    $ReceiptLines.Add("123: $Root123 | exists=YES") | Out-Null
    $ReceiptLines.Add("House: $HouseRoot | exists=$(Bool-Text (Path-Exists $HouseRoot))") | Out-Null
    $ReceiptLines.Add("Dock: $DockRoot | exists=$(Bool-Text (Path-Exists $DockRoot))") | Out-Null
    $ReceiptLines.Add("Bridge: $BridgeRoot | exists=$(Bool-Text (Path-Exists $BridgeRoot))") | Out-Null
    $ReceiptLines.Add("Mule Workshop: $MuleWorkshopLocal | exists=$(Bool-Text (Path-Exists $MuleWorkshopLocal))") | Out-Null
    $ReceiptLines.Add("") | Out-Null
    $ReceiptLines.Add("Files:") | Out-Null
    foreach ($File in $AllFiles) {
        $Rel = $File.FullName.Substring($CommandCenter.Length).TrimStart('\')
        $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash
        $ReceiptLines.Add("$Rel | SHA256: $Hash") | Out-Null
    }
    $ReceiptLines | Set-Content -LiteralPath $ReceiptPath -Encoding UTF8

    $ReceiptSha256 = (Get-FileHash -LiteralPath $ReceiptPath -Algorithm SHA256).Hash
    $SnapshotSha256 = (Get-FileHash -LiteralPath $SnapshotPath -Algorithm SHA256).Hash
    $FinalFileCount = @(Get-ChildItem -LiteralPath $CommandCenter -Recurse -File).Count

    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
    Write-Host "NO-GIT COMMAND CENTER V1 BUILT"
    Write-Host "Verdict: BUILT"
    Write-Host "Command Center: $CommandCenter"
    Write-Host "File count: $FinalFileCount"
    Write-Host "House root exists: $(Bool-Text (Path-Exists $HouseRoot))"
    Write-Host "Dock root exists: $(Bool-Text (Path-Exists $DockRoot))"
    Write-Host "Bridge root exists: $(Bool-Text (Path-Exists $BridgeRoot))"
    Write-Host "Mule workshop exists: $(Bool-Text (Path-Exists $MuleWorkshopLocal))"
    Write-Host "Receipt: $ReceiptPath"
    Write-Host "Receipt SHA256: $ReceiptSha256"
    Write-Host "Snapshot: $SnapshotPath"
    Write-Host "Snapshot SHA256: $SnapshotSha256"
    Write-Host "Read first: $(Join-Path $CommandCenter 'README_START_HERE.md')"
    Write-Host "Context cart: $(Join-Path $CommandCenter 'CURRENT_CONTEXT_CART.md')"
    Write-Host "Room index: $(Join-Path $CommandCenter 'ROOM_INDEX.md')"
    Write-Host "Boundary: local 123 setup only; no Mr.Kleen repo write; no git add/commit/push; no bridge permission expansion; no junction/symlink teleporter."
    Write-Host "Next proof: ask 'what is next on the plate?' and use COMMAND_CENTER instead of Git as the live source."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
}
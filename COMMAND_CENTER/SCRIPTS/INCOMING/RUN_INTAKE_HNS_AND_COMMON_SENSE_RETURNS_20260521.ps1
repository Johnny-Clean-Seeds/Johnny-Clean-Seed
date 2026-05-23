& {
    $ErrorActionPreference = "Stop"

    $Root = "$env:USERPROFILE\Desktop\Jxhnny_Kleen_C3dz"
    $Unit123 = "$env:USERPROFILE\Desktop\123"
    $RunStamp = Get-Date -Format "yyyyMMdd_HHmmss"

    Set-Location $Root

    Write-Host "POINT OF WORK READBACK"
    Write-Host "Task: Intake and save HNS Mesh V2 return plus Common Sense deep research return."
    Write-Host "Boundary: return intake/disposition only. No doctrine install. No ACTIVE_GUIDES rewrite. No CURRENT_TRUTH_INDEX rewrite. No runtime. No automation. No dashboard. No exchange bridge install in this script."
    Write-Host ""

    if (-not (Test-Path ".git")) {
        throw "STOP. Not in Mr.Kleen root."
    }

    if ((git branch --show-current).Trim() -ne "main") {
        throw "STOP. Wrong branch. Expected main."
    }

    $HnsReturn = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520"
    $CommonReturn = "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521"

    if (-not (Test-Path -LiteralPath $HnsReturn)) {
        throw "STOP. HNS return folder missing: $HnsReturn"
    }

    if (-not (Test-Path -LiteralPath $CommonReturn)) {
        throw "STOP. Common Sense return folder missing: $CommonReturn"
    }

    $StatusBefore = @(git status --short | Sort-Object)
    $ExpectedStatus = @(
        "?? HOUSE_WORK/WORK_SHED/MULE_WORKSHOP/RETURNS/COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521/",
        "?? HOUSE_WORK/WORK_SHED/MULE_WORKSHOP/RETURNS/HNS_MESH_V2_REVISION_RETURN_20260520/"
    ) | Sort-Object

    $DiffA = Compare-Object -ReferenceObject $ExpectedStatus -DifferenceObject $StatusBefore

    if ($DiffA) {
        Write-Host "Actual git status:"
        $StatusBefore | ForEach-Object { Write-Host $_ }
        Write-Host ""
        Write-Host "Expected only:"
        $ExpectedStatus | ForEach-Object { Write-Host $_ }
        throw "STOP. Dirty state is not exactly the two mule return folders. Do not mix intake with other changes."
    }

    $HeadBefore = (git rev-parse HEAD).Trim()
    $ShortBefore = (git rev-parse --short HEAD).Trim()

    $HnsFiles = @(Get-ChildItem -LiteralPath $HnsReturn -Recurse -File | Sort-Object FullName)
    $CommonFiles = @(Get-ChildItem -LiteralPath $CommonReturn -Recurse -File | Sort-Object FullName)

    if ($HnsFiles.Count -ne 19) {
        throw "STOP. HNS return file count changed. Expected 19, found $($HnsFiles.Count). Freeze/readback is stale."
    }

    if ($CommonFiles.Count -ne 11) {
        throw "STOP. Common Sense return file count changed. Expected 11, found $($CommonFiles.Count). Freeze/readback is stale."
    }

    $ExpectedHashes = @{
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\CLAIM_TO_SOURCE_MAP.md" = "08928F07FDCC79FA3345A9D46C831E6D3E2DDAA3C18B869009444F02830725FE"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\DEEP_ISSUE_LEDGER_AND_REPAIR_BACKLOG_20260521.md" = "69A77F7177FDDA682C14CCB22D95D3D886631C74B7D354722BC0F3FF7D0DBF30"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\DEEP_SOURCE_SEARCH_AND_SYNTHESIS_20260521.md" = "CC11D96E48BF3A8C56EEBA7350CB31CD1D74580692BDD556D16D85E68181E2FA"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\DEEPENING_PASS_RETURN_RECEIPT_20260521.md" = "E013E02F27A217246AB2CBDF68EDC7E1F8EBD5F1B95E1BDA41C781E1E90B2143"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\EXTENDED_SOURCE_TO_CLAIM_MAP_20260521.md" = "F3B8FEAE004B298611D9C86B6EE617A3C404105D697162DFFC3F613C5445C6A4"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\FINAL_HASH_LEDGER_20260521.md" = "B67E48FD7DDF5194297A4BF9F08DF875B2E8B8598F6C92CF6D1A5B04C2C74A72"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\HNS_CORE_MODEL_AND_FOCUS_PROTOCOL_20260521.md" = "2A915317A28AEA780858550DA484F7F60D395E718AEB6249351E618892BF705A"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\HNS_DEEP_LINK_MAP_EXPANSION_20260521.md" = "4003F4443B810F7B04D2A2BB7F598F09EEA6C87A5B598E9920E1A69D7C08972D"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\LINK_MAP.md" = "749A9B795B07228CE6213AE96C48CE32D037D9AA93DE23530F7FBA45B666A723"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\MTER_REVISION_TRACE.md" = "DAB2EC6CC326339692E70280B45242C5471EF8AB866AF40C234109ED79B969E0"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\MULE_REVISED_HNS_MESH_V2_SOURCE_PATTERN.md" = "437E779E56AB66201AE1A7C75BE16AE14E1E634EE540E32EF216A7BBD86D31E7"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\MULE_WORKSHOP_CLEANUP_NOTE.md" = "E6145D4C52EEB9D8E8F8EEACDA17EEA8C56545C1FC4FF346B81A7CA1485556C4"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\MULE_WORKSHOP_RULES_COEXISTENCE_20260521.md" = "165F3A719B99BD13D3A05543E817A7146C434B12336648CEE6E1E682B6DEFCEC"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\RAW_CAPTURE_AND_GROUPING.md" = "845EC6729DA4EFCEB01BE5EBC37723513DF86367CB9052FF99F79DB0A0F532C5"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\REJECTION_LEDGER.md" = "95FC1F6746761F7B052BAEDB34548794BCA49F9A152F67EA42A154C2606F423B"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\RETURN_MANIFEST_AND_RECEIPT.md" = "602FF79D8B4DFABC6C101FFDC4E8D79B893F854CD46E1F6DBE1D4A5AC4F1FBDF"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\REVISION_DELTA.md" = "5C8F19F0B4031F5F7DA637D2251AD83A787BD9D2E86067C8672E4139B7CAF991"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\SEARCH_LOG_AND_SOURCE_INDEX_20260521.md" = "77C03A693FA956B19F0CEE4DCDAE21D17636CF882CF76A2FEE6F9AD7C0E3F1D9"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\HNS_MESH_V2_REVISION_RETURN_20260520\TINY_NERVE_TEST_TEMPLATE.md" = "AB42FC03EF5A4E6FB92C0105D550A44C525DBC92964031E88956FE22C3BA4BD3"

        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\00_MTER_TRACE_AND_BOUNDARY.md" = "40D12C00B97E64C7587C62B76A364A6FE438BE07C8AC5FEED27D2C308AB75AF4"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\01_RAW_CAPTURE_AND_GROUPING.md" = "C3027DBA66B234D14CB32D2C61F3A2E95711D6AB37F107ADEF42DDEB918F7F39"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\02_DEEP_SYNTHESIS_WHAT_COMMON_SENSE_IS.md" = "FD7DB9FA99C7DF1B6800C4DBB0756D6C5041B7971457F36BC49E04E3635217F4"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\03_SOURCE_TO_CLAIM_MAP.md" = "90F566F19E886D0A9C8747EA483BA445DF5B55B3A625EF1EF5A17CF6AF7CFB97"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\04_LINK_MAP.md" = "B9F04336B63C0D1FF29157DDDF11F512FBA83CA96AC5230CCE1989759B957B20"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\05_REJECTION_LEDGER.md" = "F3B79011FEBE66C5D1F03B22646BE063D9890B6477161E0BBD3F94474AAD7ED8"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\06_REVISION_DELTA.md" = "9B620366322D35AED8DA3B2378FC5381F4B430AF2ECD93833C5B51D736F6E485"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\07_TINY_TEST_TEMPLATE.md" = "FEF65D6CD0E09EDB7E1A9B65269F84B2DBD22DCCF411EEDD89163E30E6FC9C33"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\08_SOURCE_INDEX.md" = "D67BAAC425B3F6BF643F16E3DA343E908B77588227B2A155CB7CAB31076D58E6"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\09_MANIFEST.md" = "9930ACE4CEBB2863098FD6509C3C09E2933EF5BC0528CD3BDD1C34A8D4E0397C"
        "HOUSE_WORK\WORK_SHED\MULE_WORKSHOP\RETURNS\COMMON_SENSE_DEEP_RESEARCH_RETURN_20260521\10_FINAL_HASH_LEDGER.md" = "A153C970AB8C606D21DC49D95FCE632F4272D17A96401582C80A26224140337F"
    }

    foreach ($RelPath in $ExpectedHashes.Keys) {
        if (-not (Test-Path -LiteralPath $RelPath)) {
            throw "STOP. Expected file missing: $RelPath"
        }
        $ActualHash = (Get-FileHash -LiteralPath $RelPath -Algorithm SHA256).Hash
        if ($ActualHash -ne $ExpectedHashes[$RelPath]) {
            throw "STOP. Hash mismatch for $RelPath. Expected $($ExpectedHashes[$RelPath]) found $ActualHash"
        }
    }

    $IntakeNote = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\HNS_AND_COMMON_SENSE_MULE_RETURNS_INTAKE_DISPOSITION_20260521.md"
    $DirectionNote = "HOUSE_WORK\WORK_SHED\SORTING_BENCH\MODEL_SPINE_FOCUS_COMMON_SENSE_DIRECTION_CLARITY_20260521.md"
    $TodoFile = "HOUSE_WORK\TODO\MODEL_SPINE_FOCUS_COMMON_SENSE_NEXT_TINY_TESTS_TODO_20260521.md"
    $StatusFile = "HOUSE_WORK\INDEXES\CURRENT_HOUSE_WORK_STATUS.md"
    $AnchorFile = "ACTIVE_ANCHOR.txt"
    $Receipt = "PROOF_HISTORY\HNS_AND_COMMON_SENSE_MULE_RETURNS_INTAKE_RECEIPT_20260521.txt"

    foreach ($Target in @($IntakeNote, $DirectionNote, $TodoFile, $Receipt)) {
        if (Test-Path -LiteralPath $Target) {
            throw "STOP. Target already exists, not overwriting: $Target"
        }
    }

    foreach ($Dir in @((Split-Path -Parent $IntakeNote), (Split-Path -Parent $DirectionNote), (Split-Path -Parent $TodoFile), (Split-Path -Parent $Receipt))) {
        New-Item -ItemType Directory -Force -Path $Dir | Out-Null
    }

    @(
        "# HNS And Common Sense Mule Returns Intake Disposition",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH",
        "Status: PASS AS RETURN INTAKE / SUPPORT EVIDENCE SAVED / NO ADOPTION",
        "Base before save: main @ $ShortBefore",
        "",
        "## Source returns",
        "",
        "1. $HnsReturn",
        "File count: $($HnsFiles.Count)",
        "",
        "2. $CommonReturn",
        "File count: $($CommonFiles.Count)",
        "",
        "## Verification",
        "",
        "Both return folders were present as the only dirty repo state before intake.",
        "",
        "Every expected file hash matched the final freeze/readback hash set.",
        "",
        "## HNS Mesh V2 content verdict",
        "",
        "Verdict: PASS WITH GUARDRAILS AS SOURCE-PATTERN RETURN.",
        "",
        "Useful direction:",
        "- HNS is not more alarms. It is a model-centered routed sensing/debugging/proof/decay pattern.",
        "- Model Spine is the strongest new core candidate.",
        "- Focus Nerve is the strongest guard against source-volume drift and attention loss.",
        "- Alarm Quality, Correct Quiet, Alarm Half-Life, Dead Nerve, Alarm Storm, Source Ore Quarantine, and Attention Budget are strong candidate organs.",
        "- Tiny nerve tests should precede broad adoption.",
        "",
        "Boundary:",
        "No HNS doctrine install, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime, no dashboard, no automation, no permanent alarm feed.",
        "",
        "## Common Sense content verdict",
        "",
        "Verdict: PASS WITH GUARDRAILS AS DEEP RESEARCH RETURN.",
        "",
        "Useful direction:",
        "- Common sense is best treated as a layered, situated, defeasible fit system.",
        "- It acts as an ordinary-world fit engine under limited time, limited attention, and incomplete proof.",
        "- The house-use adaptation is a Common Sense Gate: ground, room, role, authority, fit, proportion, consequence, reversibility, proof, common ground, boundary, and quiet.",
        "- Common sense must not become proof or authority by itself. It chooses proof routes and fit judgments.",
        "",
        "Boundary:",
        "No common-sense doctrine install, no proof replacement, no authority override.",
        "",
        "## Combined direction",
        "",
        "The two returns converge on one clearer direction:",
        "",
        "HNS Mesh needs Model Spine and Focus Nerve.",
        "Common Sense supplies fit judgment, room sense, proportion, and defeat checks.",
        "Together they point to a model-centered operating loop:",
        "",
        "ground state -> model spine -> common-sense fit gate -> salience/focus -> alarm quality -> tiny reversible test -> proof -> save/lock, park, reject, or decay",
        "",
        "## Disposition",
        "",
        "Adopt now:",
        "- The return folders are saved as support evidence.",
        "- The direction clarity is saved as a support note.",
        "",
        "Do not adopt now:",
        "- HNS Mesh as doctrine.",
        "- Common Sense Gate as doctrine.",
        "- Any runtime, dashboard, automation, permanent feed, ACTIVE_GUIDES edit, or CURRENT_TRUTH_INDEX edit.",
        "",
        "Park as save/lock candidates:",
        "- Model Spine.",
        "- Focus Nerve.",
        "- Common Sense Gate.",
        "- Alarm Quality Gate.",
        "- Correct Quiet.",
        "- Triggered/Fired Event Ledger.",
        "- Tool Passport / Tool Surface Custody.",
        "- Dense Idea Intake and Comparative Revise Rule.",
        "",
        "Next clean action:",
        "Save the Assistant-Mule Exchange Bridge into Mule Workshop after this intake is clean, then use it for future assistant/mule file interchange."
    ) | Set-Content -LiteralPath $IntakeNote -Encoding UTF8

    @(
        "# Model Spine / Focus Nerve / Common Sense Direction Clarity",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH",
        "Status: DIRECTION NOTE / SUPPORT EVIDENCE / NOT DOCTRINE",
        "",
        "## Clearer direction from both mule returns",
        "",
        "The research convergence is now clear enough to name without installing.",
        "",
        "The house should move toward model-centered practical control, not more lists.",
        "",
        "## The spine",
        "",
        "Model Spine keeps the active ball, authority state, object role, expected clean state, observed signal, route, proof, memory, decay, and close condition in view.",
        "",
        "## The focus",
        "",
        "Focus Nerve keeps deep search, mule work, and multi-source synthesis tied to the current active ball, current file/output role, and current claim family.",
        "",
        "## The common-sense gate",
        "",
        "Common Sense Gate checks ground, room, role, authority, fit, proportion, consequence, reversibility, proof, common ground, boundary, and quiet.",
        "",
        "## The combined loop",
        "",
        "1. Name ground/current state.",
        "2. Fill Model Spine.",
        "3. Run Common Sense Gate.",
        "4. Use Focus Nerve to limit attention and source volume.",
        "5. If a signal crosses threshold, run Alarm Quality Gate.",
        "6. Use one tiny reversible test.",
        "7. Record proof.",
        "8. Save/lock, park, reject, block, or decay.",
        "",
        "## Proof direction",
        "",
        "The next proof should not be a full build.",
        "",
        "Recommended tiny tests:",
        "",
        "1. Mule Custody Nerve on these two returns.",
        "2. Common Sense Gate on Assistant-Mule Exchange Bridge placement.",
        "3. Focus Nerve on a deep search/source-volume task.",
        "4. Tool Passport on the exchange bridge helper.",
        "",
        "## Boundary",
        "",
        "This note does not install the loop. It names the direction proven by return content and parks it for tiny tests."
    ) | Set-Content -LiteralPath $DirectionNote -Encoding UTF8

    @(
        "# TODO - Model Spine / Focus Nerve / Common Sense Tiny Tests",
        "",
        "Date: 2026-05-21",
        "Lane: HOUSE_WORK / TODO",
        "Status: OPEN / NATURAL-TRIGGER TEST QUEUE",
        "",
        "## Purpose",
        "",
        "Test the strongest candidate organs from the HNS and Common Sense returns without installing doctrine, runtime, dashboard, automation, or a permanent alarm feed.",
        "",
        "## Candidate tiny tests",
        "",
        "1. Mule Custody Nerve",
        "Trigger: a mule return is about to be used.",
        "Expected behavior: read, hash, classify, disposition, and prevent mule-as-authority.",
        "",
        "2. Common Sense Gate",
        "Trigger: an action is technically possible but practically misplaced.",
        "Expected behavior: check ground, room, role, authority, fit, proportion, consequence, reversibility, proof, common ground, boundary, and quiet.",
        "",
        "3. Focus Nerve",
        "Trigger: deep search/source volume starts widening.",
        "Expected behavior: keep active ball, current output role, and claim family visible; route repeats to source index or park.",
        "",
        "4. Tool Passport",
        "Trigger: a helper, bridge, checker, or mule exchange surface is built or reused.",
        "Expected behavior: define trigger, home, allowed touch, blocked touch, proof, cleanup, stale state, decay, and authority boundary.",
        "",
        "5. Alarm Quality Gate",
        "Trigger: an HNS alarm is proposed.",
        "Expected behavior: judge hit/miss/false alarm/correct quiet, route, reset, and close condition.",
        "",
        "## Blocked",
        "",
        "- no doctrine install;",
        "- no ACTIVE_GUIDES rewrite;",
        "- no CURRENT_TRUTH_INDEX rewrite;",
        "- no runtime;",
        "- no dashboard;",
        "- no automation;",
        "- no permanent alarm feed;",
        "- no mule-as-authority.",
        "",
        "## Next",
        "",
        "After return intake is saved clean, save the Assistant-Mule Exchange Bridge into Mule Workshop and use it as the first Common Sense Gate / Tool Passport placement test."
    ) | Set-Content -LiteralPath $TodoFile -Encoding UTF8

    Add-Content -LiteralPath $StatusFile -Encoding UTF8 -Value @(
        "",
        "---",
        "",
        "## HNS Mesh V2 And Common Sense Mule Returns Intake",
        "",
        "Status: RETURNS SAVED AS SUPPORT EVIDENCE / NO ADOPTION",
        "Date: 2026-05-21",
        "Base before save: main @ $ShortBefore",
        "",
        "HNS return:",
        $HnsReturn,
        "",
        "Common Sense return:",
        $CommonReturn,
        "",
        "Intake note:",
        $IntakeNote,
        "",
        "Direction note:",
        $DirectionNote,
        "",
        "TODO:",
        $TodoFile,
        "",
        "Meaning:",
        "The two returns establish a clearer direction: Model Spine plus Focus Nerve plus Common Sense Gate. These are support evidence and save/lock candidates, not installed doctrine.",
        "",
        "Next:",
        "Save Assistant-Mule Exchange Bridge into Mule Workshop after this intake commit is clean.",
        "",
        "Boundary:",
        "No doctrine, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime, no dashboard, no automation, no permanent alarm feed, no mule-as-authority."
    )

    @(
        "# ACTIVE ANCHOR",
        "",
        "Recorded base before this save:",
        "main @ $ShortBefore",
        "",
        "Current active ball:",
        "HNS Mesh V2 and Common Sense mule returns have been intaken and saved as support evidence; next clean move is Assistant-Mule Exchange Bridge save into Mule Workshop.",
        "",
        "Next allowed move:",
        "Run the Assistant-Mule Exchange Bridge save helper or rebuild it if needed, now that the mule returns are no longer loose dirty state after this save.",
        "",
        "Blocked moves:",
        "- Do not install HNS Mesh as doctrine.",
        "- Do not install Common Sense Gate as doctrine.",
        "- Do not rewrite ACTIVE_GUIDES.",
        "- Do not rewrite CURRENT_TRUTH_INDEX.",
        "- Do not build runtime, dashboard, automation, permanent alarm feed, or knowledge graph.",
        "- Do not treat mule output as authority.",
        "- Do not skip tiny tests before promotion.",
        "- Do not let source research become command."
    ) | Set-Content -LiteralPath $AnchorFile -Encoding UTF8

    $IntakeHash = (Get-FileHash -LiteralPath $IntakeNote -Algorithm SHA256).Hash
    $DirectionHash = (Get-FileHash -LiteralPath $DirectionNote -Algorithm SHA256).Hash
    $TodoHash = (Get-FileHash -LiteralPath $TodoFile -Algorithm SHA256).Hash
    $StatusHash = (Get-FileHash -LiteralPath $StatusFile -Algorithm SHA256).Hash
    $AnchorHash = (Get-FileHash -LiteralPath $AnchorFile -Algorithm SHA256).Hash

    $ReceiptLines = @(
        "HNS AND COMMON SENSE MULE RETURNS INTAKE RECEIPT",
        "Date: " + (Get-Date -Format o),
        "",
        "Base before save:",
        $HeadBefore,
        "",
        "Verdict:",
        "PASS AS RETURN INTAKE / SUPPORT EVIDENCE SAVED / NO ADOPTION",
        "",
        "HNS return:",
        $HnsReturn,
        "File count: $($HnsFiles.Count)",
        "",
        "Common Sense return:",
        $CommonReturn,
        "File count: $($CommonFiles.Count)",
        "",
        "Hash verification:",
        "All expected return file hashes matched final freeze/readback values.",
        "",
        "Intake note:",
        $IntakeNote,
        "SHA256:",
        $IntakeHash,
        "",
        "Direction note:",
        $DirectionNote,
        "SHA256:",
        $DirectionHash,
        "",
        "TODO:",
        $TodoFile,
        "SHA256:",
        $TodoHash,
        "",
        "Updated status:",
        $StatusFile,
        "SHA256:",
        $StatusHash,
        "",
        "Updated anchor:",
        $AnchorFile,
        "SHA256:",
        $AnchorHash,
        "",
        "Adopted now:",
        "Return custody and support-evidence preservation only.",
        "",
        "Not adopted:",
        "No doctrine, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite, no runtime, no dashboard, no automation, no permanent alarm feed, no mule-as-authority.",
        "",
        "Direction captured:",
        "Model Spine + Focus Nerve + Common Sense Gate as clearer candidate direction for tiny tests.",
        "",
        "Next:",
        "Save Assistant-Mule Exchange Bridge into Mule Workshop after this commit is clean."
    )

    $ReceiptLines | Set-Content -LiteralPath $Receipt -Encoding UTF8
    $ReceiptHash = (Get-FileHash -LiteralPath $Receipt -Algorithm SHA256).Hash

    $PathsToAdd = @(
        $HnsReturn,
        $CommonReturn,
        $IntakeNote,
        $DirectionNote,
        $TodoFile,
        $StatusFile,
        $AnchorFile,
        $Receipt
    )

    git add -f -- $PathsToAdd
    if ($LASTEXITCODE -ne 0) {
        throw "STOP. git add failed."
    }

    $Unstaged = @(git diff --name-only)
    if ($Unstaged.Count -gt 0) {
        Write-Host "Unstaged changes remain:"
        $Unstaged | ForEach-Object { Write-Host $_ }
        throw "STOP. Unstaged changes remain."
    }

    git commit -m "Intake HNS and common sense mule returns"
    if ($LASTEXITCODE -ne 0) {
        throw "STOP. Commit failed."
    }

    git push origin main
    if ($LASTEXITCODE -ne 0) {
        throw "STOP. Push failed."
    }

    git fetch origin main | Out-Null

    $HeadAfter = (git rev-parse HEAD).Trim()
    $OriginAfter = (git rev-parse origin/main).Trim()
    $ShortAfter = (git rev-parse --short HEAD).Trim()
    $StatusAfter = @(git status --short)

    if ($HeadAfter -ne $OriginAfter) {
        throw "STOP. HEAD does not match origin/main after push."
    }

    $CleanupMessages = @()

    if (Test-Path -LiteralPath $Unit123) {
        $Helpers = @(Get-ChildItem -LiteralPath $Unit123 -File -Filter "RUN_INTAKE_HNS_AND_COMMON_SENSE_RETURNS*.ps1" -ErrorAction SilentlyContinue)
        foreach ($Helper in $Helpers) {
            try {
                Remove-Item -LiteralPath $Helper.FullName -Force
                $CleanupMessages += "REMOVED TEMP HELPER: $($Helper.FullName)"
            }
            catch {
                $CleanupMessages += "FAILED TEMP HELPER CLEANUP: $($Helper.FullName) :: $($_.Exception.Message)"
            }
        }
    }

    if ($CleanupMessages.Count -eq 0) {
        $CleanupMessages += "NO TEMP HELPERS FOUND FOR CLEANUP"
    }

    Write-Host ""
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT START ===== XxXxX" -ForegroundColor Green
    Write-Host "HNS AND COMMON SENSE MULE RETURNS INTAKE COMPLETE"
    Write-Host "Verdict: PASS AS RETURN INTAKE / SUPPORT EVIDENCE SAVED / NO ADOPTION"
    Write-Host "HNS return: $HnsReturn"
    Write-Host "HNS file count: $($HnsFiles.Count)"
    Write-Host "Common Sense return: $CommonReturn"
    Write-Host "Common Sense file count: $($CommonFiles.Count)"
    Write-Host "Intake note: $IntakeNote"
    Write-Host "Intake note SHA256: $IntakeHash"
    Write-Host "Direction note: $DirectionNote"
    Write-Host "Direction note SHA256: $DirectionHash"
    Write-Host "TODO: $TodoFile"
    Write-Host "TODO SHA256: $TodoHash"
    Write-Host "Receipt: $Receipt"
    Write-Host "Receipt SHA256: $ReceiptHash"
    foreach ($Line in $CleanupMessages) {
        Write-Host "Temporary helper cleanup: $Line"
    }
    Write-Host "Commit: $ShortAfter"
    Write-Host "HEAD: $HeadAfter"
    Write-Host "origin/main: $OriginAfter"
    if ($StatusAfter.Count -gt 0) {
        Write-Host "Repo status after: NOT CLEAN"
        $StatusAfter | ForEach-Object { Write-Host $_ }
    } else {
        Write-Host "Repo status after: clean"
    }
    Write-Host "Next: Save Assistant-Mule Exchange Bridge into Mule Workshop."
    Write-Host "Boundary: no doctrine/ACTIVE_GUIDES/CURRENT_TRUTH_INDEX/runtime/dashboard/automation/permanent alarm feed. Mule output saved as support evidence only."
    Write-Host "XxXxX ===== COPY BLOCK TO CHAT END ===== XxXxX" -ForegroundColor Green
}
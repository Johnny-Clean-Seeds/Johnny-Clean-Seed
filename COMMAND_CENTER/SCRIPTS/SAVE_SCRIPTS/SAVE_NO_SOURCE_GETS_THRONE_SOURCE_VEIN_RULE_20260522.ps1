$ErrorActionPreference = "Stop"

function Stop-Fog {
    param([string]$Message)
    Write-Host "FOG / CUSTODY FAIL: STOP - $Message"
    exit 1
}

function Invoke-Git {
    param([Parameter(Mandatory=$true)][string[]]$Args)
    & git @Args
    if ($LASTEXITCODE -ne 0) {
        Stop-Fog "git $($Args -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )
    $Parent = Split-Path -Parent $Path
    if ($Parent -and -not (Test-Path $Parent)) {
        New-Item -ItemType Directory -Path $Parent -Force | Out-Null
    }
    [System.IO.File]::WriteAllText((Resolve-Path -LiteralPath $Parent).Path + [System.IO.Path]::DirectorySeparatorChar + (Split-Path -Leaf $Path), $Content, [System.Text.UTF8Encoding]::new($false))
}

function Set-ManagedSection {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$StartMarker,
        [Parameter(Mandatory=$true)][string]$EndMarker,
        [Parameter(Mandatory=$true)][string]$Section
    )
    $Existing = ""
    if (Test-Path $Path) {
        $Existing = Get-Content -Raw -LiteralPath $Path
    }
    $Pattern = [regex]::Escape($StartMarker) + "(?s).*?" + [regex]::Escape($EndMarker)
    $Replacement = $StartMarker + "`r`n" + $Section.Trim() + "`r`n" + $EndMarker
    if ([regex]::IsMatch($Existing, $Pattern)) {
        $New = [regex]::Replace($Existing, $Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $Replacement }, 1)
    } else {
        if ($Existing.Trim().Length -gt 0) {
            $New = $Existing.TrimEnd() + "`r`n`r`n" + $Replacement + "`r`n"
        } else {
            $New = $Replacement + "`r`n"
        }
    }
    Write-Utf8NoBom -Path $Path -Content $New
}

$Repo = Join-Path $env:USERPROFILE "Desktop\Jxhnny_Kleen_C3dz"
if (-not (Test-Path $Repo)) { Stop-Fog "Repo not found at $Repo" }
Set-Location $Repo
if (-not (Test-Path ".git")) { Stop-Fog "Not in Mr.Kleen repo root: $Repo" }

$InitialStatus = (& git status --short)
if ($LASTEXITCODE -ne 0) { Stop-Fog "git status failed before write" }
if ($InitialStatus) {
    Write-Host "BLOCKED - REPO NOT CLEAN BEFORE SOURCE VEIN SAVE"
    Write-Host "Current status:"
    $InitialStatus | ForEach-Object { Write-Host $_ }
    exit 1
}

$OldHead = (& git rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($OldHead)) { Stop-Fog "Could not read old HEAD" }

$RulePath = "BRAIN_LEARNING/NO_SOURCE_GETS_THRONE_SOURCE_VEIN_LANE_RULE_20260522.md"
$MapPath = "HOUSE_WORK/WORK_SHED/SORTING_BENCH/FOUNDING_ROOTS_AND_SOURCE_VEINS_MAP_20260522.md"
$StatusPath = "HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md"
$ReceiptPath = "PROOF_HISTORY/NO_SOURCE_GETS_THRONE_SOURCE_VEIN_RULE_RECEIPT_20260522.txt"

$RuleContent = @'
# No Source Gets the Throne / Source Vein Lane Rule — 20260522

## Status

Type: authority-placement behavior rule / source-integration guard.

Lifecycle state: active behavior support candidate, saved for use before source extraction and source-ore integration.

Core rule:

**No source gets the throne. Every source gets a lane.**

## Purpose

Stop any outside source, including Richard Phillips Feynman, biology/perception material, spider cognition, whale syntax, brain dysfunction systems, structured-awareness material, myth/mechanism sources, bridge/heartbeat concepts, or future research lanes, from becoming the foundation, ruler, or shortcut authority of the Clean Seed house.

This rule protects the house from source-idol drift.

## Boundary

This save is source integration and authority placement only.

It does not:
- promote a source to doctrine
- rewrite active guides
- rewrite `CURRENT_TRUTH_INDEX`
- install automation
- expand runtime permissions
- replace the user's founding originals
- make any thinker, paper, animal system, myth pattern, or outside framework the house foundation

## Founding Original / Source Root

Preserved source-root wording:

1. `ok i guess but with your logic we got so much more than richard`
2. `yes good`
3. `lol yeah we said this good next`

These are not old ideas. They are founding source pressure for this rule.

## Clean Translation / Working Use Form

Feynman and other outside thinkers are source veins, not the foundation or throne. The foundation is the Clean Seed house/core plus the user's founding originals, proof gates, growth-safe candidate handling, gate judge, clean bloat/placed growth, linked-pair method, source-safe reframing, mechanism-before-myth, signal syntax, heartbeat bridge, Desktop\123 source custody, Git proof discipline, and other already-formed system pieces.

Outside sources may feed lanes. They may not crown themselves.

## Foundation / Root System

The following are foundation-side house material:

- Clean Seed core / house structure
- user founding originals
- proof gates
- Growth-Safe Undisproved Candidate Rule
- Gate Judge / Gate Role Boundary
- Clean-Placed Growth / Clean BLOAT
- Founding Original -> Clean Translation linked-pair method
- Source-safe reframe placement
- Mechanism before myth
- Signal syntax / receiver-context logic
- Heartbeat bridge / event-driven freshness model
- Desktop\123 source custody
- Git save/push/proof discipline
- No-long-tall PowerShell delivery rule
- Rule-Fit / No Side-Mutation Gate

These are not interchangeable with outside source veins.

## Source Veins

The following are source veins:

- Richard Phillips Feynman
- biology / perception / third-eye boundary
- jumping spider compact cognition
- whale communication syntax
- brain disease / dysfunction systems
- structured awareness / ambiguity tolerance
- odd identity-pressure / authenticity source
- bridge / heartbeat direction
- future outside thinkers, papers, videos, frameworks

A source vein can provide:
- source ore
- critique
- language
- mechanism examples
- comparison patterns
- proof material
- research leads
- candidate lenses
- analogy material

A source vein cannot provide by itself:
- doctrine
- active guide authority
- CURRENT_TRUTH_INDEX authority
- proof bypass
- promotion bypass
- gate override
- source-custody override
- replacement of founding originals

## Anti-Throne Drift Tests

A source is drifting toward the throne if any of these appear:

1. A named thinker is treated as the reason a Clean Seed claim is true.
2. A metaphor is used as proof.
3. A famous source outranks the user's founding originals.
4. A source vein changes doctrine without explicit proof route.
5. A cleaned interpretation replaces the raw source.
6. The system starts copying a source's identity/personality instead of extracting clean use.
7. A source is used to skip gate judge, proof language, linked-pair custody, or save discipline.
8. A source becomes a master explanation for unrelated rooms.
9. A source-lane object starts acting like a root object.
10. A research packet is treated as PASS when it is only source ore, candidate, partial, or needs proof.

If any test fires, stop and re-lane the source.

## Correct Source Handling Path

Use this path:

`Source -> source custody -> clean translation -> lane assignment -> neighbor fit -> proof need -> parked / candidate / active support`

Do not use this path:

`Source -> throne -> doctrine`

## Relation to Growth-Safe Candidate Logic

This rule does not kill unproven source material.

Missing proof blocks PASS, promotion, and doctrine.

Only positive disproof kills.

A source vein can remain useful as source ore, candidate material, watch item, partial pattern, or research lead even when it is not proven enough to promote.

## Relation to Gate Judge

The Gate Judge keeps source gates in their lane.

A source-custody gate may say whether source handling is clean.

It may not say the idea is false just because it is unproven.

A proof gate may block PASS.

It may not crown a source.

A promotion gate may approve promotion only by explicit route and proof.

It may not promote because a source is famous, strong, elegant, or emotionally resonant.

## Use Condition

Use this rule before:

- Feynman linked-pair extraction
- source-ore research maps
- biology/perception analogies
- spider cognition analogies
- whale syntax analogies
- brain dysfunction failure-pattern work
- myth/mechanism source work
- bridge/heartbeat source integration
- any future outside thinker/framework integration

## Retirement / Revision Condition

Revise if a later saved house rule provides a stronger authority-placement structure or if this rule conflicts with higher saved house authority.

Do not remove useful source veins merely because a cleaner map exists. Park, link, or re-lane them unless stale, unsafe, duplicate with no value, rejected with reason, or positively disproven.
'@

$MapContent = @'
# Founding Roots and Source Veins Map — 20260522

## Status

Type: source-safe map / authority placement map / anti-throne guard.

Lifecycle state: saved map for source integration. Not doctrine promotion.

Master line:

**No source gets the throne. Every source gets a lane.**

## Purpose

Show what is truly foundational versus what is a source vein feeding the house, so no outside thinker, animal system, science field, myth pattern, bridge concept, or future framework accidentally becomes king.

## Boundary

This map does not promote any source.
It does not rewrite active guides.
It does not rewrite `CURRENT_TRUTH_INDEX`.
It does not install automation.
It does not replace proof/save discipline.

It only places source relationships.

## Foundation / Root System

| Foundation Root | Role | Protected Against |
|---|---|---|
| Clean Seed core / house structure | Defines native recursive growth, clean lanes, proof-first operation, and house identity. | Outside source replacing the house. |
| User founding originals | Preserve source truth, pressure, raw language, first corrections, and native model roots. | Clean translations erasing source roots. |
| Proof gates | Block fake PASS and require evidence for claims, saves, and promotions. | Metaphor-as-proof and source fame as proof. |
| Growth-Safe Undisproved Candidate Rule | Keeps unknown/unproven material alive without falsely promoting it. | Killing candidates because proof is missing. |
| Gate Judge / Gate Role Boundary | Keeps gates from acting outside their lane. | Proof gates acting as disproof gates or promotion gates. |
| Clean-Placed Growth / Clean BLOAT | Allows more structure when named, placed, bounded, fitted, proof-tagged, and retireable. | Dirty bloat and unplaced rule piles. |
| Founding Original -> Clean Translation linked-pair method | Keeps raw source/founding wording tied to operational clean form. | Clean version drifting away from source custody. |
| Source-safe reframe placement | Separates source, interpretation, analogy, candidate, and rule. | Reframe masquerading as source. |
| Mechanism before myth | Requires mechanism before symbolic meaning can guide operations. | Myth replacing proof or mechanism. |
| Signal syntax / receiver-context logic | Supports pattern, message, receiver, and context reasoning. | Treating signal-like patterns as automatic language proof. |
| Heartbeat bridge / event-driven freshness model | Supports pulse, wake, status, and freshness without pretending continuous hidden work. | Bridge concept becoming unbounded automation authority. |
| Desktop\123 source custody | Keeps local source pickup rooted and placed. | Random source scattering and loss of origin. |
| Git save/push/proof discipline | Makes durable objects prove commit, remote match, clean status, receipt, and boundary. | Unsaved or false-saved authority. |
| No-long-tall PowerShell delivery rule | Keeps code delivery usable and not chat-bloating. | Giant code walls and delivery drift. |
| Rule-Fit / No Side-Mutation Gate | Makes new rules change only the intended behavior. | One rule mutating unrelated rooms. |

## Source Veins

| Source Vein | Lane | Can Feed | Must Not Become |
|---|---|---|---|
| Richard Phillips Feynman | Source ore / mechanism and explanation lens | Clarity, first-principles checking, anti-fake-understanding pressure, mechanism-first discipline. | Guru, doctrine, personality import, foundation, authority shortcut. |
| Biology / perception / third-eye boundary | Science source lane | Sensing, feedback, perception limits, embodiment, boundary between source fact and analogy. | Medical claim, diagnosis, literal model proof, mystical override. |
| Jumping spider compact cognition | Cognition source lane | Small-system intelligence, distributed sensing, compact routing, body-world computation. | Mascot throne, proof of Clean Seed, animal identity import. |
| Whale communication syntax | Signal / communication lane | Patterned calls, family signal structure, syntax-like ordering, long-distance coordination. | Mystical language proof, direct equivalence without source proof. |
| Brain disease / dysfunction systems | Failure-pattern source lane | Collapse modes, routing failure, overload, disconnection, repair analogies. | Diagnosis, treatment logic, literal disease model for the house. |
| Structured awareness / ambiguity tolerance | Awareness routing lane | Attention routing, idea capture, uncertainty holding, not killing candidates too early. | Vague consciousness doctrine or proof bypass. |
| Odd identity-pressure / authenticity source | Source-root pressure lane | Detecting identity drift, fake form, external costume, and loss of native core. | Unchecked mythology, self-crowning identity layer. |
| Bridge / heartbeat direction | Operations / signal-room lane | Pulse, lease, handoff, wake, mailbox, event-driven freshness, room-before-room routing. | Runtime expansion without proof, automation authority, uncontrolled bridge. |
| Future outside thinkers, papers, videos, frameworks | Parking / source ore / TODO lanes | New candidates, vocabulary, comparisons, tests, methods, and critique. | Automatic install, doctrine replacement, foundation takeover. |

## Placement Rule

Every source must answer:

1. What lane does it feed?
2. What exact source custody is preserved?
3. What clean translation is being proposed?
4. What proof is missing?
5. What authority does it not have?
6. What house foundation does it support without replacing?
7. What would count as source-throne drift?

If those are not answered, the source stays parked or source ore.

## Blocked Dirty Moves

Blocked:

- Feynman as house foundation
- source as guru
- famous thinker as proof
- metaphor as mechanism
- myth as evidence
- biology analogy as medical claim
- source vein overriding proof gates
- source vein replacing user founding originals
- cleaned translation replacing founding original
- source map becoming promotion route
- unproven source pattern being killed instead of parked

## Correct Flow

Clean flow:

`Founding root stays root.`

`Source vein enters source lane.`

`Source custody remains linked.`

`Clean translation gets a boundary.`

`Proof gate blocks only what proof can block.`

`Gate Judge keeps gates in lane.`

`Promotion requires explicit proof route.`

Bad flow:

`Useful source -> famous source -> throne -> doctrine -> proof skipped.`

## Working Use

Use this map as the first check before extracting the first Feynman linked pair or any future source-linked concept.

The source can strengthen the house only after it accepts a lane.

No source gets the throne.
Every source gets a lane.
'@

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"
$ReceiptContent = @"
NO SOURCE GETS THE THRONE / SOURCE VEIN LANE RULE RECEIPT - 20260522

Timestamp: $Timestamp
Old HEAD before write: $OldHead

Saved objects:
- $RulePath
- $MapPath
- $StatusPath

Receipt role:
- records source-vein/throne-boundary save packet
- preserves boundary: source integration and authority placement only
- confirms no doctrine promotion was intended
- confirms no active guide rewrite was intended
- confirms no CURRENT_TRUTH_INDEX rewrite was intended
- confirms no automation was intended

Core rule:
No source gets the throne. Every source gets a lane.

Founding originals preserved:
1. ok i guess but with your logic we got so much more than richard
2. yes good
3. lol yeah we said this good next

Clean translation:
Feynman and other outside thinkers are source veins, not the foundation or throne. The foundation is the Clean Seed house/core plus the user's founding originals, proof gates, growth-safe candidate handling, gate judge, clean bloat/placed growth, linked-pair method, source-safe reframing, mechanism-before-myth, signal syntax, heartbeat bridge, and other already-formed system pieces.

Next intended work after this save:
Cargo Cult Science -> Form Is Not Function / Anti-Fake-PASS Gate, obeying:
- Missing proof blocks PASS. Only disproof kills.
- No source gets the throne. Every source gets a lane.
"@

Write-Utf8NoBom -Path $RulePath -Content $RuleContent
Write-Utf8NoBom -Path $MapPath -Content $MapContent
Write-Utf8NoBom -Path $ReceiptPath -Content $ReceiptContent

$StatusSection = @'
## 20260522 — No Source Gets the Throne / Source Vein Lane Rule

Current save packet:
- `BRAIN_LEARNING/NO_SOURCE_GETS_THRONE_SOURCE_VEIN_LANE_RULE_20260522.md`
- `HOUSE_WORK/WORK_SHED/SORTING_BENCH/FOUNDING_ROOTS_AND_SOURCE_VEINS_MAP_20260522.md`
- `PROOF_HISTORY/NO_SOURCE_GETS_THRONE_SOURCE_VEIN_RULE_RECEIPT_20260522.txt`

Verdict: source integration boundary saved as authority-placement support. No doctrine promotion. No active guide rewrite. No `CURRENT_TRUTH_INDEX` rewrite. No automation.

Current guard line:

**No source gets the throne. Every source gets a lane.**

Next planned work: Cargo Cult Science -> Form Is Not Function / Anti-Fake-PASS Gate, with proof boundary preserved: missing proof blocks PASS; only positive disproof kills.
'@

Set-ManagedSection -Path $StatusPath -StartMarker "<!-- START NO_SOURCE_GETS_THRONE_SOURCE_VEIN_RULE_20260522 -->" -EndMarker "<!-- END NO_SOURCE_GETS_THRONE_SOURCE_VEIN_RULE_20260522 -->" -Section $StatusSection

$PostWriteStatus = (& git status --short)
if ($LASTEXITCODE -ne 0) { Stop-Fog "git status failed after write" }
if (-not $PostWriteStatus) {
    Write-Host "BLOCKED - NO CHANGES TO SAVE"
    Write-Host "Old HEAD: $OldHead"
    Write-Host "Final status: clean"
    exit 1
}

Invoke-Git @("add", $RulePath, $MapPath, $StatusPath)
Invoke-Git @("add", "-f", $ReceiptPath)
Invoke-Git @("commit", "-m", "Add source vein throne boundary rule")
Invoke-Git @("push", "origin", "main")

$NewHead = (& git rev-parse HEAD).Trim()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($NewHead)) { Stop-Fog "Could not read new HEAD" }
$RemoteHead = (& git rev-parse origin/main).Trim()
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($RemoteHead)) { Stop-Fog "Could not read origin/main" }
$FinalStatus = (& git status --short)
if ($LASTEXITCODE -ne 0) { Stop-Fog "git status failed at final proof" }

if ($NewHead -ne $RemoteHead) {
    Write-Host "BLOCKED - REMOTE HEAD DOES NOT MATCH LOCAL HEAD"
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
    Write-Host "Final status:"
    $FinalStatus | ForEach-Object { Write-Host $_ }
    exit 1
}

Write-Host "PASS - SOURCE VEIN THRONE BOUNDARY RULE SAVED"
Write-Host "Old HEAD: $OldHead"
Write-Host "New HEAD: $NewHead"
Write-Host "Remote HEAD: $RemoteHead"
Write-Host "Final status: clean"
Write-Host "Receipt: $ReceiptPath"
Write-Host "Boundary: source integration and authority placement only; no doctrine promotion; no active guide rewrite; no CURRENT_TRUTH_INDEX rewrite; no automation."

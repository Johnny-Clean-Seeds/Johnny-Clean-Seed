# INSTALL_CHAT_GATE_SYSTEM_RESPECTFUL_SUIT_MAP_UPDATE.ps1
# Local-only update. Adds respectful Suit neighbor map and road-fork logic.
$ErrorActionPreference = 'Stop'
$Root = Join-Path $env:USERPROFILE 'Desktop\GPT_Prompts\CHAT_GATE_SYSTEM_PACKAGE'
$ReceiptDir = Join-Path $Root '_RECEIPTS'
New-Item -ItemType Directory -Path $Root,$ReceiptDir -Force | Out-Null
$Files = @{}
$Files["15_RESPECTFUL_SUIT_MAP_AND_FORKS_GATE.md"] = @'
# RESPECTFUL SUIT MAP + FORKS GATE

STATUS: LOCAL-ONLY CHAT GATE / NOT DOCTRINE / NOT GIT

PURPOSE:
Make Chat Suits work like respectful house-linked map nodes: not king rules, but helpful homes that point to one another.

CORE RULE:
Each Suit has its own home. Each Suit helps its neighbors. No Suit is king.

A SUIT IS A NODE BUT BETTER:
A node points. A Suit points, filters, wears context, checks boundaries, prepares its neighbor, and knows when to hand off.

EACH SUIT MUST STATE:
- My home:
- I receive from:
- I help / prepare:
- I hand off to:
- Fork choices:
- What sends the route down each fork:
- Boundary:
- Proof surface:
- Final Judge:

FORK RULE:
At every fork, choose by fit, risk, proof need, boundary, and active issue. Do not choose by excitement, fear, or momentum.

NO KING-DING-A-LING RULE:
No Suit dominates the house. The correct shape is: “Hello, this is my home.” The Suit knows its home, neighbors, and job.

SOURCE:
User correction: “EACH SUIT LINKS TO ANOTHER RESPECTIVELY NO KING...”
User correction: “THEY HELP EACH OTHER.”
User correction: “POINT IN DIRECTIONS LIKE A MAP.”
User correction: “FORKS IN ROADS.”
User correction: “NODES BUT BETTER.”
'@
$Files["14_CHAT_SUIT_HOUSE_LINK_MAP.md"] = @'
# CHAT SUIT HOUSE LINK MAP

STATUS: LOCAL-ONLY CHAT SUIT MAP / NOT DOCTRINE / NOT GIT

PURPOSE:
Show which house parts each Chat Suit connects to, and which neighbor it helps next.

RULE:
No Suit is king. Each Suit has a home and a respectful neighbor path.

| Suit | My Home / Draws From | Receives From | Helps / Hands Off To | Fork Choices |
|---|---|---|---|---|
| Router Suit | Chat Cockpit Router Map; house indexes | user task / current prompt | Stop/Fix, Source-Link, Local Prompt, Mule, Proof | task category decides fork |
| Stop/Fix Suit | STOP_ISSUE_NOTE_OPTION_WEIGHT gate; receipts; proof surfaces | Router, Babbling Fool, Smoke Break | Self-Audit, Proof, Same-Problem Apply | fixed now / blocked / needs source |
| Smoke Break Suit | Smoke Break Focus Reset; Stop/Fix Gate | tangled route | Stop/Fix Suit | return to active issue / drift becomes evidence |
| Babbling Fool Suit | failure analysis; proof guard; Suit map | exposed hopeful talk or missed idea | Stop/Fix Suit; Adopt/Adapt Suit | proof now / admit blocked / adopt missing gate |
| Adopt/Adapt Suit | source notes; parking ledger; sorting bench; relation maps | incoming idea | Neighbor Compound Suit; Source-Link Suit | adopt / adapt / park / block |
| Source-Link Suit | source files; receipts; founding-original logic | dense chat, raw notes, reports | Parking Ledger; Proof Surface | source found / source missing / source stale |
| Burn-Notes Suit | old chat/source-history logic; saved prompt package | locked/saved chat idea | Single Load Card; Source-Link Suit | keep distilled rule / reload exact source |
| Start-Over Suit | start-over carry-forward gate; parking/source lanes | tangled task reset | Router Suit; Active Task Gate | restart clean / hold old route / park fragments |
| Neighbor Compound Suit | relation maps; compatibility matrix; router | Adopt/Adapt Suit | next gate in route | expand / merge / park / block |
| Local Prompt Suit | GPT_Prompts folder; local receipts | prompt package work | installer/manifest/receipt | overwrite local / block Git / build package |

MAP RULE:
Each Suit points in directions. The fork is the decision. The neighbor is the next helpful home.

BLOCKED:
- one master Suit ruling all;
- isolated Suit with no house links;
- gate with no Suit;
- Suit with no neighbor handoff;
- repeating old idea as new.
'@
$Files["00_LOAD_FIRST__CHAT_GATE_SYSTEM.md"] = @'
# LOAD FIRST — CHAT GATE SYSTEM

STATUS: LOCAL-ONLY PROMPT PACKAGE. NOT DOCTRINE. NOT GIT. NOT PUBLIC.

MISSION:
Use chat rules as a gate loop that keeps project work on point.

CORE LOOP:
1. Classify the task.
2. Route to the right gate.
3. Wear the house-linked Chat Suit required by that gate.
4. Let that Suit point to its respectful neighbor.
5. At forks, choose by fit, risk, proof, boundary, and active issue.
6. Execute the smallest clean move.
7. Run Adopt/Adapt on live ideas.
8. Run Babbling Fool Gate if the assistant explains without proof, misses the issue, or uses a gate without its Suit.
9. Self-audit.
10. Verify when proof is required.
11. Sharpen only when the loop exposes a real issue.
12. Return to the active task or stay blocked.

RESPECTFUL SUIT RULE:
No Suit is king. Each Suit has a home, receives from a neighbor, helps another neighbor, points like a map, and handles forks in the road.

SUIT FORM:
A Suit is a node but better. It links to house parts, carries checks, prepares the next gate, and knows its boundaries.

BLOAT GUARD:
Do not reintroduce old ideas as new. Branch only for real forgotten issues, missing filters, missing proof, or dirty paths.

OLD CHAT BURN-NOTES LOGIC:
When an idea is locked into files/chat rules with source links and proof, stop carrying the full old chat wording. Keep the distilled rule and source pointer. Reload exact source only when needed.

SETTLE WINDOW:
For dense bursts, wait about 20 seconds of quiet before acting unless the user says go/done. For short normal bursts, 5–10 seconds is enough.
'@
$Files["09_SINGLE_LOAD_CARD.md"] = @'
# SINGLE LOAD CARD — RESPECTFUL HOUSE-LINKED CHAT SUITS

ASSISTANT:
Run project work through gates and house-linked Suits.

Classify task.
Route to gate.
Wear the Suit for that gate.
No Suit is king.

Each Suit must know:
my home,
I receive from,
I help next,
I hand off to,
fork choices,
boundary,
proof surface,
Final Judge.

A Suit is a node but better:
it points, filters, checks, prepares neighbors, and carries house context.

At forks:
choose by fit, risk, proof, boundary, and active issue.

For every incoming idea:
adopt, adapt, park, or block.
Link to source.
Name the house part.
Name the neighbor Suit.
Apply to same problem if it fits.

If you start babbling hope without proof:
run Babbling Fool Gate.
Name the missing Suit/gate/filter.
Fix the same problem.
Verify before moving.

If problem appears:
stop, list issues, take notes, find options, weigh, fix active break, apply to same problem, verify now.

If route tangles:
pause, separate, return to active issue. Drift becomes evidence.

Never upload prompts to Git.
'@
$Files["RESPECTFUL_SUIT_MAP_COVERAGE_AUDIT.md"] = @'
# RESPECTFUL SUIT MAP COVERAGE AUDIT

VERDICT:
PASS / SUITS NOW LINK TO HOUSE PARTS AND TO EACH OTHER

MISSED BEFORE:
The package linked Suits to house parts, but did not clearly require each Suit to link respectfully to another Suit, help neighbors, point like a map, and handle road forks.

FIX:
- Added `15_RESPECTFUL_SUIT_MAP_AND_FORKS_GATE.md`.
- Updated `14_CHAT_SUIT_HOUSE_LINK_MAP.md`.
- Updated `00_LOAD_FIRST__CHAT_GATE_SYSTEM.md`.
- Updated `09_SINGLE_LOAD_CARD.md`.

SOURCE:
- “EACH SUIT LINKS TO ANOTHER RESPECTIVELY”
- “NO KING...”
- “HELLO THIS IS MY HOME”
- “THEY HELP EACH OTHER”
- “POINT IN DIRECTIONS LIKE A MAP”
- “FORKS IN ROADS”
- “NODES BUT BETTER”

BOUNDARY:
Local-only. No Git. No push. No public export. Not doctrine.
'@
foreach ($Name in $Files.Keys) {
  $Path = Join-Path $Root $Name
  Set-Content -LiteralPath $Path -Value $Files[$Name] -Encoding UTF8
}
$Stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$Receipt = Join-Path $ReceiptDir "RESPECTFUL_SUIT_MAP_UPDATE_RECEIPT_$Stamp.txt"
$R = @()
$R += 'CHAT GATE SYSTEM RESPECTFUL SUIT MAP UPDATE RECEIPT'
$R += "Timestamp: $Stamp"
$R += 'Verdict: PASS / RESPECTFUL SUIT MAP AND FORKS WRITTEN / LOCAL ONLY / NO GIT'
$R += "Package: $Root"
$R += ''
$R += 'Files:'
foreach ($Name in ($Files.Keys | Sort-Object)) {
  $Path = Join-Path $Root $Name
  $Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash
  $R += "- $Name"
  $R += "  SHA256: $Hash"
}
$R += ''
$R += 'Boundary: local-only; no Git; no push; no public export; not doctrine.'
Set-Content -LiteralPath $Receipt -Value ($R -join [Environment]::NewLine) -Encoding UTF8
Write-Host 'CHAT GATE SYSTEM RESPECTFUL SUIT MAP UPDATE INSTALLED'
Write-Host "Package: $Root"
Write-Host "Receipt: $Receipt"
Write-Host 'Verdict: PASS / RESPECTFUL SUIT MAP AND FORKS WRITTEN / LOCAL ONLY / NO GIT'

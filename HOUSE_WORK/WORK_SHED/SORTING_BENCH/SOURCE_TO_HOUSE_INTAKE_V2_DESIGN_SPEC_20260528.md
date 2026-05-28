# SOURCE_TO_HOUSE_INTAKE_V2 Design Spec V1

Date: 2026-05-28  
Status: design spec / pre-code / candidate helper evolution  
Parent saved TODO: `HOUSE_WORK/TODO/SOURCE_TO_HOUSE_INTAKE_V2_MECHANISM_EXTRACTION_TODO_20260528.md`  
Boundary: design only. No script is produced here. No raw transcript Git staging. No helper authority expansion. Code Gate is required before any generated helper is live-used.

---

## 0. Object lock

Active object:

```text
SOURCE_TO_HOUSE_INTAKE_V2
```

Job:

```text
Read an exact local source folder and produce a bounded source-to-house intake packet that extracts mechanism chains, claim structure, source sequence, signal/proof separation, and house-fit decisions.
```

Not the job:

```text
No broad drive scan.
No raw transcript promotion.
No doctrine creation.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No autonomous Git save.
No helper output treated as authority.
```

Why V2 exists:

V1.2 proved the basic local read/report road, but its output was shallow. It counted/dissected terms and made a rough digest. The metacognition no-gaps run proved that a useful source helper needs mechanism extraction, not term count.

---

## 1. Proof ladder required

V2 must report the ladder explicitly:

```text
BUILT: yes/no
PACKAGED: yes/no
HASHED: yes/no
CODE-GATED: yes/no
LIVE-RUN: yes/no
OUTPUT-JUDGED: yes/no
PLACED: yes/no
PROVEN: yes/no
```

Rules:

- `CODE-GATED: yes` means only the script parsed/self-tested.
- `LIVE-RUN: yes` means the script actually ran on a selected source folder.
- `OUTPUT-JUDGED: yes` means the generated output was compared against source or user judgment.
- `PLACED: yes` means output was put in the right local lane or saved route.
- `PROVEN: yes` needs all required prior steps, not just a file existing.

---

## 2. Inputs

Required input:

```text
-SourceFolder <exact folder path>
```

Optional inputs:

```text
-RunName <safe run label>
-MaxFiles <default 25>
-MaxMB <default 20>
-ChunkLines <default 80>
-CodeGateSelfTest
```

Allowed source file types:

```text
.txt
.md
.csv
.json
```

Default exclusions:

```text
.git
node_modules
.venv
__pycache__
zip files
binary/media files
system folders
```

Hard boundary:

V2 reads only the exact selected folder and bounded child files. It does not scan Desktop, Documents, drives, GitHub, browser history, or external URLs.

---

## 3. Output folder

Default local output lane:

```text
C:\Users\<user>\Desktop\123\COMMAND_CENTER\SOURCE_INTAKE\SOURCE_TO_HOUSE_INTAKE_<RunName>_<timestamp>
```

The folder must contain:

```text
00_READ_ME_FIRST.md
SOURCE_INVENTORY.md
SOURCE_SEQUENCE_MAP.md
CLAIM_LEDGER.csv
MECHANISM_CHAINS.md
SIGNAL_PROOF_SPLIT.md
HOUSE_FIT_TABLE.md
DEAD_WEIGHT_BURN.md
FINAL_JUDGE.md
HOUSE_CONTEXT_DIGEST_FOR_CHAT.md
RECEIPT_SHA256.txt
```

Optional support:

```text
SOURCE_LINE_INDEX.csv
SOURCE_CHUNKS_LEDGER.csv
WARNINGS_AND_LIMITS.md
```

---

## 4. Output contract

### 4.1 `00_READ_ME_FIRST.md`

Purpose:

Give the next assistant/human the exact meaning of the packet.

Must include:

```text
source folder
run name
timestamp
file count
boundary
proof ladder
what to read first
what not to assume
```

### 4.2 `SOURCE_INVENTORY.md`

Purpose:

Custody and file identity.

Fields:

```text
file name
relative path
extension
bytes
line count
SHA256
read status
skipped reason if skipped
```

### 4.3 `SOURCE_SEQUENCE_MAP.md`

Purpose:

Identify what each source contributes and how the source set moves.

Required sections:

```text
Source order
Source 1 contribution
Source 2 contribution
Source 3 contribution
What changed across sources
Repeated spine
Contradictions / tensions
Missing source gaps
```

### 4.4 `CLAIM_LEDGER.csv`

Purpose:

Separate claims from examples and evidence.

Columns:

```text
claim_id
source_file
line_span
claim_text_short
claim_type
evidence_type_inside_source
house_relevance
risk_level
decision
notes
```

Claim types:

```text
definition
mechanism
example
warning
practice
analogy
broad_claim
clinical_claim
social_claim
tool_design_claim
house_fit_claim
```

Evidence types:

```text
direct statement
example only
analogy
unsourced assertion
source-internal reasoning
needs external proof
```

Decisions:

```text
ADOPT
ADAPT
PARK
BLOCK
PROOF
LEAVE-BE
```

### 4.5 `MECHANISM_CHAINS.md`

Purpose:

Extract movement, not keywords.

Mechanism chain forms:

```text
trigger -> state -> interpretation -> control move -> outcome
signal -> inspection -> evidence -> verdict
instruction -> practice -> proceduralization -> automatic behavior
source object -> map -> fit decision -> placement
error -> root cause -> exact repair -> proof
```

Each chain must include:

```text
name
source support
chain
house translation
boundary
proof needed
```

### 4.6 `SIGNAL_PROOF_SPLIT.md`

Purpose:

Prevent confidence becoming verdict.

Must classify:

```text
signals
evidence
proof surfaces
verdict blockers
missing proof
```

Examples:

```text
fit feeling = signal
keyword count = signal
source line = evidence
hash = custody proof
Code Gate = parser/self-test proof
live run = run proof
output judged against source = quality proof
commit/push/clean = save proof
```

### 4.7 `HOUSE_FIT_TABLE.md`

Purpose:

No parking without fit decision.

Columns:

```text
extracted_item
decision
lane
why
boundary
next_action
return_trigger
```

Lanes:

```text
BRAIN_LEARNING candidate
HOUSE_WORK/SORTING_BENCH report
HOUSE_WORK/TODO
Soft Suit
Think Tank
Proof History
Source Ore local-only
Blocked
Leave-be
```

### 4.8 `DEAD_WEIGHT_BURN.md`

Purpose:

Drop active burden after useful extraction.

Must include:

```text
burn from live carry
keep as proof trail
keep as source ore
carry as key
```

Rule:

Burn means stop carrying live chat weight. It does not delete source/proof.

### 4.9 `FINAL_JUDGE.md`

Purpose:

Close the run.

Must include:

```text
final verdict
placement
proof status
promotion status
blocked moves
next clean action
```

Allowed verdicts:

```text
ACCEPT
ACCEPT WITH GUARDRAILS
REFINE
SPLIT
PARK WITH RETURN TRIGGER
NEEDS SOURCE
NEEDS PROOF
BLOCK
READY FOR NARROW LIVE USE
READY FOR SAVE ROUTE
NOT PROMOTED
```

### 4.10 `HOUSE_CONTEXT_DIGEST_FOR_CHAT.md`

Purpose:

Small context handoff, not full raw transcript.

Must include:

```text
source object
top source sequence
top mechanism chains
fit decisions
proof status
blocked assumptions
next action
```

Hard cap:

Keep it short enough to paste into chat without dragging raw transcript weight.

### 4.11 `RECEIPT_SHA256.txt`

Purpose:

Output identity and proof.

Must include hashes for every generated output file and source inventory hashes.

---

## 5. Processing passes inside V2

### Pass 1 — Inventory and custody

Actions:

```text
validate source folder
collect allowed files
enforce MaxFiles / MaxMB
read lines safely
compute SHA256
write SOURCE_INVENTORY.md
write SOURCE_LINE_INDEX.csv
```

Fail conditions:

```text
source folder missing
no readable files
too many files without explicit limit increase
binary or oversized source attempted
```

### Pass 2 — Sequence and claim extraction

Actions:

```text
identify source order
extract headings/sections if present
find repeated terms
extract candidate claims around cue words
classify claim type
write SOURCE_SEQUENCE_MAP.md
write CLAIM_LEDGER.csv
```

Cue families:

```text
definition: is, means, refers to, called
mechanism: causes, allows, directs, controls, becomes, leads to
warning: false, wrong, bias, illusion, not true, dangerous
practice: train, practice, technique, method, instruction
proof: evidence, test, verify, data, study, shows
house-fit: process, system, map, control, awareness, source, proof, state
```

### Pass 3 — Mechanism chains and signal/proof

Actions:

```text
convert claims into mechanism chains
separate signals from proof
mark missing proof
write MECHANISM_CHAINS.md
write SIGNAL_PROOF_SPLIT.md
```

Important:

Term frequency can support search, but term frequency cannot be the main output.

### Pass 4 — House fit and burn

Actions:

```text
make ADOPT/ADAPT/PARK/BLOCK/PROOF/LEAVE-BE decisions
assign lane
write HOUSE_FIT_TABLE.md
write DEAD_WEIGHT_BURN.md
```

### Pass 5 — Final Judge and receipt

Actions:

```text
write FINAL_JUDGE.md
write HOUSE_CONTEXT_DIGEST_FOR_CHAT.md
write RECEIPT_SHA256.txt
print final summary to console
```

---

## 6. Console output contract

Final stdout should look like:

```text
SOURCE TO HOUSE INTAKE V2 COMPLETE
Source folder: <path>
Output folder: <path>
Files read: <n>
Claims extracted: <n>
Mechanism chains: <n>
Fit decisions: <n>
Warnings: <n>
Digest: <path>
Final Judge: <path>
Receipt: <path>
Proof ladder:
BUILT: yes
PACKAGED: no
HASHED: yes
CODE-GATED: no
LIVE-RUN: yes
OUTPUT-JUDGED: no
PLACED: local-output
PROVEN: no
```

The script must not print fake PASS.

---

## 7. Safety and Code Gate requirements

Before live use:

```text
assistant writes script
script is saved as Desktop drop with V name
PowerShell Code Gate runs target
parser must PASS
blockers must be 0
watch warnings must be named
only then live-run exact source folder
```

Generated script rules:

```text
ASCII-safe PowerShell strings
no smart quotes
no em dash in script strings
no Markdown backtick escapes inside double-quoted PowerShell strings
use pwsh for live run when available
avoid dense one-liners
precompute values before writing output
```

Blocked operations:

```text
Git write
network
delete
move source files
rename source files
write outside output folder except receipt/report lane
broad root scan
```

---

## 8. Test plan before script is trusted

### Test 1 — Code Gate self-test

Input:

```text
-CodeGateSelfTest
```

Expected:

```text
Syntax PASS
self-test PASS
no live source read
no Git/network/delete
```

### Test 2 — tiny sample folder

Input:

```text
3 small text files
```

Expected:

```text
all required output files exist
receipt hashes match
claim ledger non-empty
mechanism chains non-empty
Final Judge present
```

### Test 3 — metacognition folder

Input:

```text
C:\Users\13527\Desktop\123\META COGNITION
```

Expected:

```text
reads the V3 packet as a handoff packet
does not pretend it is raw transcript
reports packet identity correctly
```

### Test 4 — original transcript folder

Input:

```text
C:\Users\13527\Desktop\YouTube Transcript Tool\Transcripts\Metacognition explained (part 3)
```

Expected:

```text
reads 3 transcript files
builds sequence map matching V3 no-gaps report
extracts signal/proof and proceduralization chains
marks clinical/broad claims as PARK
does not promote raw transcript
```

### Test 5 — bad folder

Input:

```text
missing folder
```

Expected:

```text
clean error
no output packet claiming PASS
```

---

## 9. V2 proof standard

V2 is not proven by being built.

V2 is proven only after:

```text
BUILT: yes
PACKAGED: yes
HASHED: yes
CODE-GATED: yes
LIVE-RUN: yes on exact source folder
OUTPUT-JUDGED: yes against V3/no-gaps standard
PLACED: yes local output packet
PROVEN: yes for bounded source-intake helper use only
```

No helper authority expansion.

---

## 10. Save-route recommendation

Design spec may be saved before script as:

```text
HOUSE_WORK/WORK_SHED/SORTING_BENCH/SOURCE_TO_HOUSE_INTAKE_V2_DESIGN_SPEC_20260528.md
PROOF_HISTORY/SOURCE_TO_HOUSE_INTAKE_V2_DESIGN_SPEC_RECEIPT_20260528.txt
HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md
```

Script package should remain local-only until Code Gate and live proof.

---

## 11. Final design verdict

Verdict:

```text
READY FOR DESIGN SAVE ROUTE
NOT READY FOR SCRIPT BUILD UNTIL USER APPROVES
```

Next clean actions:

```text
1. lock/save this design spec; or
2. build SOURCE_TO_HOUSE_INTAKE_V2 script package from this spec.
```

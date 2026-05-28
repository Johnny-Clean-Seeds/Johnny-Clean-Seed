# File Registry Candidate Shape V1

Date: 2026-05-28  
Status: CANDIDATE / SHAPE FILE / NOT SAVE ROUTE  
Doc type: INDEX / CATALOG / SCHEMA  
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX  
Boundary: registry shape only; no filesystem scan; no helper code; no move/copy/delete; no Git action; no proof-index replacement; no helper-registry replacement  

---

## 1. Target-Reader Scent

Target reader:

```text
fresh assistant / future worker / user returning after context loss
```

Target question:

```text
I know the lane or object, but which file matters, where is it, what does it do, what is its status, and what proof or custody should I trust?
```

This file answers:

```text
what a File Registry is;
what belongs in it;
what does not belong in it;
which fields every important file entry needs;
how it differs from Helper Registry and Proof Index;
when to create/populate it;
what proof closes V1.
```

This file does not answer:

```text
every file in the house;
all helper scripts;
all proof receipts;
all folder manifests;
full doctrine;
current Git status;
runtime helper inventory.
```

Best next file:

```text
ASSISTANT_ENTRY_PATH_CANDIDATE_V1.md
```

Proof pointer:

```text
The Entry Path fresh-reader test exposed a weak spot around “which helper/status map matters next.”
That pressure revealed a missing parent: File Registry.
```

Stale trigger:

```text
This shape becomes stale when the house adopts a different registry model, when helper/proof/file roles are merged or split differently, or when a real File Registry V1 is created and proves a better schema.
```

---

## 2. Main Job

The File Registry is the house-level catalog of important project files.

Clean short form:

```text
File Registry tells what important files are, where they live, why they matter, and what proof/custody/status belongs to them.
```

It is not a search helper.

It is not a crawler.

It is not a folder manifest.

It is not a proof index.

It is not a helper registry.

It is the catalog that lets a reader answer:

```text
What is this file?
Where does it live?
What lane/home owns it?
What authority level does it have?
What status is it in?
What proof or receipt supports it?
What is stale, parked, live, blocked, or superseded?
What should happen next?
What must not be assumed?
```

---

## 3. Why This Exists

The Entry Path can tell the reader where to start.

But once the reader knows the lane, a second question appears:

```text
Which file is the right file?
```

That is not solved by a helper registry.

It is not solved by raw search.

Raw search can find text, but it does not judge:

```text
file role
authority level
current status
custody
proof pointer
staleness
next action
do-not-touch boundary
```

The File Registry gives search and humans a target shape.

---

## 4. Clean Split From Neighbor Registries

### File Registry

Job:

```text
catalog important files and their house meaning.
```

Answers:

```text
what file matters, where it lives, what role/status/authority/custody/proof it has.
```

### Helper Registry

Job:

```text
catalog tools/scripts/helpers.
```

Answers:

```text
what helper exists, what it does, inputs, outputs, risk boundary, Code Gate proof, when to use, when not to use.
```

### Proof Index

Job:

```text
catalog proof outcomes.
```

Answers:

```text
what object has been proven, by which receipt/report/hash/commit, with what status and remaining watch items.
```

### Folder Manifest

Job:

```text
explain a folder at a decision point.
```

Answers:

```text
what belongs here, what does not, entry file, key files, common next actions, do-not-touch notes.
```

### File Search Helper

Job:

```text
perform bounded local read/search/report when exact local evidence is required.
```

Answers:

```text
what files match a query under an approved root and bounded scan.
```

Rule:

```text
The File Registry defines meaning.
The search helper may later help find candidates.
The helper does not become authority.
```

---

## 5. What Belongs In File Registry

Include only important project files where future orientation benefits.

Candidate classes:

```text
authority pointers
active guides
entry paths
cockpit/chat cards
Soft Suit cards
proof/status indexes
helper registries
tool passports
wayfinding/path files
decision records
current lane cards
important receipts/receipt indexes
source custody maps
parking/TODO maps
folder manifests that become decision signs
```

Do not include by default:

```text
every generated report
every raw receipt
temporary downloads
old chat dumps
bulk logs
all helper scripts
binary assets
backup copies
duplicate exports
one-off local throwaway files
```

Exception rule:

```text
A normally excluded file may be registered if it becomes a landmark, proof source, source root, or active dependency.
```

---

## 6. Minimum Registry Entry Shape

Each registered file should use this shape.

```text
Registry ID:
File name:
Current path:
Path type: LOCAL / GIT-DURABLE / CHAT-UPLOADED / URL / UNKNOWN
Lane/home:
Doc type:
Purpose:
Target reader:
Target question:
Authority level:
Status:
Source/custody:
Created by / actor:
Inputs:
Outputs:
Related files:
Proof pointer:
Hash/commit:
Last verified:
Drift trigger:
Next action:
Do-not-touch / do-not-assume:
Tags:
```

---

## 7. Field Meanings

### Registry ID

Stable short ID for the registry row.

Example:

```text
FILE-ENTRY-PATH-V1
```

### File name

Visible filename.

### Current path

Exact known path, if known.

If exact local path is not known yet, mark:

```text
UNKNOWN / NEEDS SOURCE
```

Do not invent paths.

### Path type

Allowed values:

```text
LOCAL
GIT-DURABLE
CHAT-UPLOADED
URL
UNKNOWN
```

### Lane/home

Where the file belongs conceptually.

Examples:

```text
HOUSE_WORK/ASSISTANT_PATH
HOUSE_WORK/CHAT_COCKPIT
PROOF_HISTORY
COMMAND_CENTER/RECEIPTS
LOCAL_ONLY/TOOLS
```

If not saved yet:

```text
candidate lane only
```

### Doc type

Use the doc-type split.

Allowed first types:

```text
NAVIGATION / CURRENT STATE
REFERENCE
EXPLANATION
HOW-TO / PLAYBOOK
INDEX / CATALOG
RECEIPT / PROOF
DECISION RECORD
MANIFEST / SIGN
SOURCE / CUSTODY
TOOL PASSPORT
CHAT CARD
```

### Authority level

Allowed values:

```text
DOCTRINE
ACTIVE_GUIDE
CURRENT_TRUTH_INDEX
ACTIVE_ANCHOR
DURABLE_STATUS
PROOF_RECEIPT
CHAT_COCKPIT
SOFT_SUIT_CANDIDATE
CANDIDATE
PARKED
LOCAL_ONLY
UNKNOWN
```

### Status

Allowed values:

```text
LIVE
CANDIDATE
PASS
PASS WITH WATCH
NOT PASS
PARKED
STALE
DEAD
BLOCKED
NEEDS SOURCE
NEEDS PROOF
SUPERSEDED
```

### Proof pointer

Must point to a proof/receipt/report when a proof claim is made.

If no proof:

```text
PENDING / NO PROOF CLAIM
```

### Drift trigger

Condition that makes the row stale.

Examples:

```text
current lane changes
Git HEAD changes
helper status changes
new version created
authority file moved
proof result superseded
```

---

## 8. Starter Candidate Rows

These are not final registry entries. They show the shape only.

### Row 1

```text
Registry ID: FILE-ENTRY-PATH-CANDIDATE-V1
File name: ASSISTANT_ENTRY_PATH_CANDIDATE_V1.md
Current path: chat-created downloadable artifact / exact house path not assigned
Path type: CHAT-UPLOADED
Lane/home: candidate for HOUSE_WORK/ASSISTANT_PATH
Doc type: NAVIGATION / CURRENT STATE
Purpose: tell a fresh reader where to start today without rereading the whole house
Target reader: fresh assistant / future worker / user returning after context loss
Target question: where do I start right now?
Authority level: CANDIDATE
Status: PASS WITH WATCH / READY FOR NARROW LIVE USE
Source/custody: created from loaded Think Tank + Compatibility Review + cockpit + current proof state
Created by / actor: ChatGPT current conversation
Inputs: Think Tank packet; Compatibility Review packet; cockpit card; V1.4 proof state
Outputs: one candidate entry path file
Related files: HOUSE_WAYFINDING_PROOF_MEMORY_SYSTEM_COMPATIBILITY_REVIEW_V1.md
Proof pointer: Fresh-Reader Orientation Test V1 result in chat, 9/10 PASS WITH WATCH
Hash/commit: not hashed; not committed
Last verified: 2026-05-28
Drift trigger: current lane/proof/helper status changes
Next action: decide whether to create File Registry candidate shape
Do-not-touch / do-not-assume: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX; not save route
Tags: entry-path, wayfinding, candidate, current-state
```

### Row 2

```text
Registry ID: FILE-WAYFINDING-COMPAT-REVIEW-V1
File name: HOUSE_WAYFINDING_PROOF_MEMORY_SYSTEM_COMPATIBILITY_REVIEW_V1.md
Current path: chat-uploaded file / exact house path not assigned
Path type: CHAT-UPLOADED
Lane/home: review / candidate support
Doc type: REVIEW / COMPATIBILITY PACKET
Purpose: judge first wayfinding packet and narrow implementation
Target reader: assistant/user reviewing whether to add the wayfinding concept
Target question: does the concept fit and what is the smallest next move?
Authority level: CANDIDATE
Status: USEFUL REVIEW PACKET / NOT SAVE ROUTE BY ITSELF
Source/custody: generated from Think Tank packet, cockpit card, current proof memory, and outside concept checks
Created by / actor: assistant/mule-style review packet
Inputs: Think Tank packet; cockpit card; current proof memory
Outputs: compatibility matrix and corrected next move
Related files: HOUSE_WAYFINDING_PROOF_MEMORY_SYSTEM_THINK_TANK_V1.md
Proof pointer: review packet content; not a save receipt
Hash/commit: not hashed; not committed
Last verified: 2026-05-28
Drift trigger: exact source checks reveal conflict or first path test changes next move
Next action: use as pressure, not authority
Do-not-touch / do-not-assume: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX
Tags: compatibility, wayfinding, review, candidate
```

### Row 3

```text
Registry ID: FILE-WAYFINDING-THINK-TANK-V1
File name: HOUSE_WAYFINDING_PROOF_MEMORY_SYSTEM_THINK_TANK_V1.md
Current path: chat-uploaded file / exact house path not assigned
Path type: CHAT-UPLOADED
Lane/home: think tank / candidate source
Doc type: EXPLANATION / THINK TANK
Purpose: explain House Wayfinding + Proof Memory System concept
Target reader: assistant/user exploring the concept
Target question: what is the parent idea and branch tree?
Authority level: CANDIDATE
Status: ACCEPT WITH GUARDRAILS / NOT PROMOTED
Source/custody: concept wash from internal cards and external concepts
Created by / actor: assistant/mule-style concept wash
Inputs: Soft Suit/cockpit/current proof context and outside concepts
Outputs: concept tree, branches, clean standards, proposed implementation
Related files: HOUSE_WAYFINDING_PROOF_MEMORY_SYSTEM_COMPATIBILITY_REVIEW_V1.md
Proof pointer: compatibility review narrowed it; not a save receipt
Hash/commit: not hashed; not committed
Last verified: 2026-05-28
Drift trigger: path proof fails or compatibility source checks alter the concept
Next action: wear as candidate suit only
Do-not-touch / do-not-assume: not doctrine; not save route; not full implementation approval
Tags: think-tank, wayfinding, candidate, explanation
```

---

## 9. Source-Required Rule

Before any real File Registry is saved, rows must not invent file paths, proof, hashes, commits, or authority.

Allowed source states:

```text
EXACT SOURCE
CHAT-UPLOADED
URL VERIFIED
LOCAL VERIFIED
GIT VERIFIED
UNKNOWN / NEEDS SOURCE
```

If the source is not exact:

```text
mark NEEDS SOURCE;
do not claim compatibility;
do not claim saved status;
do not claim proof.
```

---

## 10. Burden Budget

This registry shape should reduce:

```text
confusion between file registry, helper registry, proof index, and folder manifest;
search-before-meaning behavior;
fake path claims;
repeated explanation of what a file does;
future broad scans to identify important files.
```

It adds:

```text
a new catalog maintenance burden if adopted.
```

Burden verdict:

```text
REDUCES BURDEN WITH WATCH
```

Watch reason:

```text
A File Registry can become a pile if it tries to register every file or if rows are not kept fresh.
```

---

## 11. When To Populate File Registry V1

Do not populate the registry just because the shape exists.

Populate only when one is true:

```text
fresh-reader test fails because file identity/status/path is unclear;
save route needs durable orientation for important path files;
helper registry repair needs important-file landmarks;
proof index work needs file/object separation;
the user explicitly selects File Registry as the active boss.
```

---

## 12. When To Build A File-Search Helper

A file-search helper is later than this shape.

Build only when:

```text
the File Registry shape says what must be found;
exact root/lane is known;
manual lookup is causing real burden;
the task needs local evidence, not judgment;
bounds are defined: root, MaxFiles, MaxDepth, batching, SleepMs;
Code Gate route is available;
output is read/report only.
```

Blocked:

```text
no whole-drive crawler;
no service;
no door;
no authority from search results alone;
no moving files;
no deleting files;
no Git action;
no registry overwrite without review.
```

---

## 13. Close Condition

This shape closes as:

```text
PASS WITH WATCH:
It cleanly separates File Registry from helper/proof/folder/search roles and gives a usable row schema.

REPAIR:
A reader still confuses file registry with helper registry or proof index.

PARK:
User stops registry work with return trigger.

BLOCK:
It causes broad inventory pressure, fake path claims, or another map pile.
```

Current close status:

```text
PENDING REVIEW
```

---

## 14. One-Line Clean Wrap

```text
File Registry is the meaning catalog for important files: what they are, where they live, what status and authority they carry, what proof/custody supports them, and what happens next.
```

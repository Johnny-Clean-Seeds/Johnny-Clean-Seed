# MULE_HANDOFF__HELPER_FILE_SURFACE_PREFLIGHT_AND_BOUNDED_OUTSIDE_SOURCE_RULE

Date: 2026-06-06
Status: MULE HANDOFF / HELPER-FILE PREFLIGHT / WRITE_REPORTS_ONLY / NOT DOCTRINE
WorkKey: HELPER-FILE-SURFACE-PREFLIGHT-BOUNDED-OUTSIDE-SOURCE-RULE-20260606

## 1. Assignment

Before the next large source-processing, command-center, custody, or review-packet job, perform a helper-file surface preflight.

This means:

Find the helper files that already exist for this house.
Read the ones that apply.
Classify what each helper file is for.
Use them to route the work before building anything large.
Return proof of which helper files were found, read, used, skipped, or missing.

This job is about helper files first.

Do not treat this as an "agent" search.
Do not replace helper-file preflight with outside sources.
Do not rely only on the pasted handoff.
Do not rely only on the raw source file.
Do not rely only on ad hoc shell scans.

## 2. Definitions

`HELPER FILE` means a carrier file that helps route, constrain, explain, prove, or structure work.

Helper files may include:

- front-door pointers
- start-here ledgers
- load manifests
- suit cards
- source/map/key files
- toolbelt registries
- command grammar files
- active-object pointers
- status files
- custody rules
- blocker cards
- parking cards
- mule orders
- return receipts
- receipt templates
- guard cards
- final judge cards
- proof ledgers
- source maps
- command-center helper files
- run notes
- review indexes

A helper file can route, constrain, explain, or prove.

A helper file does not act by itself.

Do not call helper files agents.
Do not expect helper files to execute anything.
Do not confuse a helper file with an outside worker.

## 3. Outside Source Rule

Outside sources are allowed only when needed.

Use outside sources for:

- current product/tool behavior
- current OpenAI/Codex/MCP documentation
- external standards
- outside pattern comparison
- unfamiliar or uncertain terms
- web/source research requested by the user
- Roof-zone pressure testing when the packet explicitly asks for deep research

Do not use outside sources by default when the job is internal helper-file routing.

Outside source use must be bounded.

If outside sources are used, return:

`OutsideSourcesUsed: true`
`WhyOutsideSourcesWereNeeded:`
`SourcesConsulted:`
`WhatTheyChanged:`
`DoesNotProve:`

If outside sources are not needed, return:

`OutsideSourcesUsed: false`
`Reason: internal helper-file and source packet were sufficient`

## 4. Operating Mode

Mule operating mode:

`WRITE_REPORTS_ONLY`

Allowed:

- search for helper files
- read helper files
- classify helper files
- build a helper-file surface map
- identify which helper files apply to the active task
- identify helper files that are missing or stale
- write a helper preflight report
- write a helper-use receipt
- recommend next legal action

Not allowed:

- delete
- move
- compress
- archive
- dedupe
- restore
- install live command-center files
- commit
- push
- create watcher
- create automation
- rewrite doctrine
- rewrite ACTIVE_GUIDES
- rewrite CURRENT_TRUTH_INDEX
- mutate live command-center state
- treat outside sources as authority over house source

## 5. Helper File Search Order

Search in this order.

### Step 1 - Root / Front Door

Look for current entry files:

- `START_HERE.md`
- `START_HERE_CURRENT_HOUSE_LEDGER.md`
- `ACTIVE_ANCHOR.txt`
- `CURRENT_HOUSE_WORK_STATUS.md`
- root command-center pointer files
- current active-object pointer files

### Step 2 - Command Center Lane

Look for command-center helper files:

- user command center files
- assistant command center files
- active job files
- next legal action files
- blocker files
- receipt pointer files
- human approval files
- backstage view files
- command grammar files
- state schema files

### Step 3 - Work Shed / Index Lane

Look for routing and map files:

- node registries
- bridge/tunnel registries
- hub toolbelt registries
- load manifests
- source/map/key files
- drift reviews
- same-process checkpoint ledgers
- front-door ledgers

### Step 4 - Custody / Receipts Lane

Look for proof and custody files:

- return receipts
- hash ledgers
- proof history
- run reports
- manifest files
- receipt indexes
- mutation flags
- blocker receipts
- final judge files

### Step 5 - Task-Local Lane

Look in the active task folder for:

- task handoff
- task manifest
- task receipt
- task source map
- task output list
- task blocker list
- task DoesNotProve section

## 6. Helper File Classification

Classify every found helper file as one of:

`FRONT_DOOR`
`LOAD_MANIFEST`
`SOURCE_MAP`
`SUIT_CARD`
`TOOLBELT`
`COMMAND_GRAMMAR`
`ACTIVE_POINTER`
`STATUS`
`CUSTODY_RULE`
`RECEIPT`
`HASH_LEDGER`
`PROOF_LEDGER`
`MULE_ORDER`
`RETURN_RECEIPT`
`GUARD_CARD`
`BLOCKER_CARD`
`PARKING_CARD`
`FINAL_JUDGE`
`STATE_SCHEMA`
`VIEW_TEMPLATE`
`UNKNOWN_HELPER`

For each helper file, record:

`FileName`
`Path`
`Classification`
`Current / stale / unknown`
`Read: true/false`
`Used: true/false`
`Skipped: true/false`
`WhyUsed`
`WhySkipped`
`DoesNotProve`

## 7. Helper Use Rules

Do not read every helper file just because it exists.

Use helper files in layers:

1. Read the front door.
2. Read the load manifest.
3. Read the active pointer/status.
4. Read the source/map/key file if routing is unclear.
5. Read the toolbelt file only if the task needs a tool/method decision.
6. Read receipts/proof only if proof or completion is being judged.
7. Read guard files only if rule survival, authority, or mutation risk is involved.
8. Read outside sources only if the outside-source rule is triggered.

The goal is:

`MAXIMUM REACH / MINIMUM CARRY`

Do not carry the whole house into context.

## 8. Required Helper Preflight Output

Before starting the main job, return or write:

```text
HELPER_FILE_PREFLIGHT

Status:
ActiveObject:
WorkingLane:
RawSource:
HandoffRead:

HelperFilesFound:
HelperFilesRead:
HelperFilesUsed:
HelperFilesSkipped:
HelperFilesMissing:
UnknownHelperFiles:

CurrentFrontDoorFound:
LoadManifestFound:
ActivePointerFound:
ToolbeltFound:
CustodyRuleFound:
ReceiptTemplateFound:
GuardCardFound:
CommandCenterHelperFound:

OutsideSourcesUsed:
WhyOutsideSourcesWereNeeded:
OutsideSourcesConsulted:

HelperLayerVerdict:
NextLegalAction:
DoesNotProve:
```

## 9. Stop Conditions

Stop and return `HELPER_PREFLIGHT_BLOCKED` if:

- no active object is known
- root/front-door pointer is missing and the job depends on it
- helper files are found but cannot be read
- helper files conflict with the task packet
- helper files are stale and no current helper exists
- helper files imply a different active task
- task requires mutation but no custody/helper rule is found
- outside source is needed but the task forbids outside research
- the raw source and helper files disagree on authority
- the job would proceed without a receipt path

## 10. Helper Surface Verdicts

Use one of these:

`HELPER_SURFACE_READY`

Helper files were found, read, and enough were used to route the job.

`HELPER_SURFACE_PARTIAL`

Some helper files were found/read, but a current helper or needed layer is missing.

`HELPER_SURFACE_NOT_FOUND`

No relevant helper files were found.

`HELPER_SURFACE_CONFLICT`

Helper files conflict with the handoff or source.

`HELPER_SURFACE_STALE`

Found helper files appear old/stale and should not govern the task without review.

`HELPER_SURFACE_NOT_USED`

Relevant helper files existed but were not read or used.

`OUTSIDE_SOURCE_USED_BOUNDED`

Outside sources were used for a specific justified reason.

`OUTSIDE_SOURCE_NOT_NEEDED`

Internal source/helper surface was enough.

## 11. DoesNotProve

This preflight does not prove:

- the main job is complete
- the command center is installed
- any mutation is authorized
- helper files are doctrine
- outside sources override house source
- all helper files are current
- all helper files were needed
- skipped helper files are useless
- a receipt has been accepted
- user approval exists

## 12. Required Receipt

Write a receipt named:

`MULE_RECEIPT__HELPER_FILE_SURFACE_PREFLIGHT_<DATE>.md`

Receipt must include:

```text
Status:
Actor: MULE
OperatingMode: WRITE_REPORTS_ONLY
ActiveObject:
WorkingLane:

HelperFilesFound:
HelperFilesRead:
HelperFilesUsed:
HelperFilesSkipped:
HelperFilesMissing:
OutsideSourcesUsed:
WhyOutsideSourcesWereNeeded:

Deleted: false
Moved: false
Compressed: false
Archived: false
Deduped: false
RestoredInPlace: false
Committed: false
Pushed: false
WatcherInstalled: false
AutomationInstalled: false

BlockedItems:
Conflicts:
DoesNotProve:
NextLegalAction:
```

## 13. Final Carry Line

`HELPER FILES FIRST. OUTSIDE SOURCES ONLY WHEN NEEDED. HELPER FILES CARRY ROUTES, RULES, STATE, AND PROOF. THEY ARE NOT AGENTS. MULE MUST PROVE WHICH HELPER FILES WERE FOUND, READ, USED, SKIPPED, OR MISSING BEFORE LARGE WORK STARTS.`


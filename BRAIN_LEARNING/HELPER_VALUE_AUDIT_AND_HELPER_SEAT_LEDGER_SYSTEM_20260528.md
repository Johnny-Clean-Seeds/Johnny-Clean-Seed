# Helper Value Audit + Helper Seat Ledger System

Status: SAVED HOUSE PROCESS CANDIDATE / NOT DOCTRINE / NOT ACTIVE_GUIDES / NOT CURRENT_TRUTH_INDEX
Saved: 20260528_233902
Source: deep helper-value research checkpoint from chat
Boundary: candidate helper evaluation system only; no doctrine promotion; no mule rule change; no helper build.

---
# Helper Value Audit + Helper Seat Ledger System

Status: SAVED HOUSE PROCESS CANDIDATE / NOT DOCTRINE / NOT ACTIVE_GUIDES / NOT CURRENT_TRUTH_INDEX
Object: Helper Value / Tight Bounded Helper System
Purpose: decide whether helpers are actually helping, prevent helper sprawl, and require every helper to earn its seat through proof, keys, hashes, receipts, and net-burden reduction.

## A Checkpoint Source

A CHECKPOINT — deep house walk / helper-value research pass complete enough to stop, not final enough to save.

I am not opening a helper build yet. This is the research/checkpoint layer: how to know whether helpers are truly helping, and how to make the helper system tight, bounded, keyed, hashed, and not another bloat machine.

Current object: **Helper Value / Tight Bounded Helper System**.

Active house rules used:

The cockpit says the front door selects the command shape, Alpha locks the object, the router sends it to the right family, gates judge, and Final Judge closes. For this task, the object is not “repair transcript helper”; it is “measure whether helpers are actually helping.”

The local workaround card says helper scripts are only justified when the task needs local evidence, batch reading, hashes, ledgers, repeatable filtering, path custody, or weak-PC-safe scanning. If it is only judgment, lane choice, or explanation, chat should not make code.

The compression card says to carry only useful active state, burn old failed helper chatter, keep failed versions as proof trail only, treat working helpers as patterns rather than authority, and decide before every next move whether the task is judgment or local evidence.

The failure wash says the transcript helper failure was a boundary-chain failure: the URL survived chat → script but died script → `yt-dlp`; the real extracted rule was that a helper passes only when the active object survives every boundary and the final artifact proves it.

The cockpit also now has the deeper key/hash direction: keyed, mapped, proof-aware toolsets can be clean; hashes prove identity, not quality; snap-links do not merge authority; capability keys grant exact bounded actions only.

External research cross-check:

Google SRE’s postmortem model supports the same root idea: document the incident, understand contributing root causes, and create preventive actions that reduce recurrence; it also warns against blame because blame hides the facts needed to prevent the next failure.

After-Action Review is a compact learning loop: what was planned, what happened, why, and what will be done next. That matches the house’s run-close pattern, but the house version adds boundary trace, object survival, hashes, helper lifecycle, proof split, and dead-weight burn.

PDSA/PDCA supports the same learning rhythm: plan, do, study/check, act. The important translation for the house is that a helper run is not “done” after execution; it enters study/check, then only earns the next action if the proof says it helped.

DORA-style thinking gives a measurement warning: do not judge a system by vibes; measure flow and stability. For helper work, the equivalents are helper lead time, failure rate, recovery time, artifact success, and burden reduction.

SRE toil research is directly relevant: toil is manual, repetitive, automatable, tactical work with little enduring value that scales as the system grows. A helper is only good if it reduces toil; if it creates more repeated debugging, paste loops, and proof confusion, it has become toil itself.

Observability research says systems need logs, metrics, and traces, not just a final message. House translation: helper runs need receipt logs, value metrics, and boundary traces. OpenTelemetry’s model of generating, collecting, and exporting telemetry maps cleanly to helper receipts and run ledgers.

Human automation research warns about automation bias: people can overtrust automated aids, miss failures, or follow the tool despite contradictory evidence. This exactly matches the transcript helper V1 failure: official-looking helper output made the bad surface feel controlled while the job failed.

PowerShell’s own parsing rules matter because helpers cross a fragile boundary: command text → PowerShell parser → native command arguments. Wrapper helpers must audit final external arguments, not merely accept parameters.

## House-Native Result

The helper system needs three layers:

1. Helper Identity / Keys.
2. Helper Runtime Receipt.
3. Helper Value Audit.

## Layer 1 — Helper Identity / Keys

Every helper needs a key before it gets trust.

Minimum key set:

- `HELPER_KEY`: stable helper name.
- `VERSION_KEY`: V1, V1.1, V2, etc.
- `PURPOSE_KEY`: exact job.
- `OBJECT_KEY`: what object it carries, such as URL, file path, folder, hash list, transcript.
- `BOUNDARY_KEY`: boundaries it crosses.
- `CAPABILITY_KEY`: what it is allowed to do.
- `RISK_KEY`: read-only, write local, git write, delete/move, network, system.
- `PROOF_KEY`: what proves job success.
- `HASH_KEY`: file identity hashes.
- `STATE_KEY`: lifecycle status.

Helper key example:

```text
HELPER_KEY: YOUTUBE_TRANSCRIPT_DESKTOP_TOOL
VERSION_KEY: V1
OBJECT_KEY: YouTube URL
BOUNDARY_CHAIN: chat -> PowerShell -> helper -> yt-dlp -> VTT -> TXT -> Explorer -> verification
CAPABILITY: network read via yt-dlp; local Desktop output; no repo save
PROOF: TXT exists and Length > 0
STATE: REPAIR_CANDIDATE / DO NOT USE
```

## Layer 2 — Helper Runtime Receipt

Every helper run needs a receipt that proves the active object survived.

Minimum receipt:

```text
HELPER_RUN_RECEIPT

RunId:
Helper:
Version:
HelperSHA256:
CommandMode: parameter / interactive / batch
InputObjectType:
InputObjectPresent: yes/no
InputObjectHashOrLength:
ResolvedTool:
OutputFolder:
BoundaryChain:
ExternalArgsCount:
ExternalArgsIncludeObject: yes/no
ScriptStatus:
JobStatus:
ExitCode:
ArtifactsCreated:
ArtifactHashes:
ArtifactLengths:
ElapsedTime:
UserStepsRequired:
FailureNote:
NextAction:
FinalVerdict:
```

This fixes the transcript failure class. V1 printed official status, but it did not prove the URL reached `yt-dlp`. A runtime receipt would have caught `ExternalArgsIncludeObject: no` before running.

## Layer 3 — Helper Value Audit

This is the part that tells whether helpers are worth keeping.

The helper must answer five value questions:

1. Did it reduce manual steps?
2. Did it reduce chat burden?
3. Did it preserve object custody?
4. Did it produce proof faster than manual/direct road?
5. Did it fail cleaner than manual/direct road?

Full scorecard:

```text
HELPER VALUE AUDIT

1. Helper:
2. Version:
3. Task object:
4. Direct road available:
5. Direct road cost:
6. Helper run cost:
7. User steps saved:
8. Chat turns saved:
9. Debug turns added:
10. Artifact produced:
11. Artifact proof:
12. Object survived every boundary:
13. Failure was readable:
14. Failure gave next action:
15. Receipt created:
16. Hashes created:
17. Repeat use likely:
18. Risk added:
19. Net burden:
20. Net value:
```

Value verdicts:

- `KEEP_ACTIVE`: clearly reduces burden and passes proof.
- `KEEP_WITH_GUARDRAILS`: useful but needs bounded use.
- `REPAIR_CANDIDATE`: useful idea, failed implementation.
- `DIRECT_ROAD_ONLY`: helper is not worth it yet; use raw command.
- `PARK_PROOF_TRAIL`: keep evidence, do not use.
- `BURN_FROM_LIVE_CARRY`: stop carrying it as active work.
- `REJECT`: not worth repair.

## Current Tool/Helper Scoring From Transcript Run

`YOUTUBE_TRANSCRIPT_DESKTOP_TOOL_MIN_HELPER_V1.ps1`: `REPAIR_CANDIDATE / DO NOT USE`. It hurt live execution because it dropped the URL at the external command boundary.

Direct `yt-dlp` road: `KEEP_AS_PROVEN_ROAD`. It produced VTT files and proved the URL/video/subtitle path.

.NET VTT→TXT conversion: `KEEP_AS_PROVEN_MECHANISM`. It worked after `Set-Content -Encoding` failed.

PowerShell Code Gate: `KEEP_ACTIVE`. It prevented parser-risk and false-save behavior; it also let V1.1 fail before commit and V1.2 pass with exact staged-set proof.

Lock-save V1.2: `KEEP_AS_PATTERN_WITH_GUARDRAILS`. It handled ignored path force-add correctly by using a manifest and exact staged-set verification.

After-Run Breadcrumb Wash / Leap-Close: `KEEP_ACTIVE_SOFT_SUIT`. It converted failure into mechanism, proof, and next-leap control.

## Helper Seat Ledger

The big missing structure is a **Helper Seat Ledger**.

Not every helper gets a throne. Every helper gets a seat only if it earns one.

Helper Seat Ledger columns:

```text
HelperKey
Version
Purpose
Capability
RiskClass
CurrentState
LastRunId
LastRunVerdict
ArtifactProof
HelperSHA256
ReceiptPath
FailureCount
SuccessCount
RepeatFailureCount
DirectRoadCost
HelperRunCost
DebugCost
NetValue
NextAction
ReturnTrigger
```

This ledger lets the house answer the core question later with proof: “Are helpers helping?” Not vibes. Data.

## Tight Bounded Helper System

1. **Judgment first.** Before code, decide whether this is judgment or local evidence. If judgment, no helper.

2. **Direct road before helper.** Raw command must work once before wrapper/helper repair or wrapper creation.

3. **Helper key before helper trust.** A helper without identity, capability, risk, proof, and lifecycle state is loose machinery.

4. **Boundary receipt before PASS.** Helper PASS requires object survival across every boundary and final artifact proof.

5. **Hash identity, not quality.** Hash proves exact file identity. It does not prove the helper is good.

6. **Two same failures demote.** One failure gets inspection. Two same failures stop use. Direct road or repair candidate only.

7. **Helper value audit after meaningful helper runs.** No helper gets to keep being active without a value verdict.

8. **No helper sprawl.** Do not build a manager, icon, dashboard, or broad scanner until one helper proves repeated value.

9. **Weak-PC defaults.** Bounded root, small batch, MaxFiles, MaxDepth, SleepMs pauses, progress output, exact paths.

10. **Receipts stay local unless routed.** Local run receipts are enough for tool work unless the result becomes house-process material.

11. **Helper promotion ladder.**

```text
IDEA
DIRECT_ROAD_PROVEN
HELPER_DRAFT
CODE_GATE_PARSE_PASS
FIRST_RUN_PASS
NARROW_LIVE_USE
REPEAT_PASS
REUSE_PATTERN
HOUSE_CANDIDATE
```

Blocked moves:

- `FIRST_RUN_PASS` does not equal `REUSE_PATTERN`.
- `CODE_GATE_PARSE_PASS` does not equal `JOB_PASS`.
- `HASH_MATCH` does not equal `QUALITY_PASS`.
- `OFFICIAL_OUTPUT` does not equal `CONTROLLED_WORK`.

This is the hard lesson from the transcript helper.

## External System Translation

SRE says reduce toil, but only with preventive action and monitoring; otherwise automation can create more operational burden.

AAR/PDSA say every action must feed learning and change the next action, not just produce a recap.

DORA says measure throughput, failure, and recovery, so helpers need lead-time, failure-rate, and recovery-cost metrics.

Automation-bias research warns that helper-looking tools can make humans trust automation too much, so every helper must expose proof and failure state clearly.

## Checkpoint Verdict

Final result: **REFINE / STRONG CANDIDATE FOR HELPER VALUE SYSTEM**.

Placement: not doctrine yet. Best fit is probably `BRAIN_LEARNING` plus a Gear Rack card later, linked to local-helper / Code Gate / After-Run Breadcrumb Wash.

Proof status: supported by house rules, transcript failure evidence, saved After-Run Breadcrumb Wash, and external SRE/AAR/PDSA/DORA/observability/automation-bias sources.

Next action: build the full **Helper Value Audit + Helper Seat Ledger** as a house candidate, then use it to score the existing helper/tool set before building or repairing another helper.

## References

- Google SRE, Postmortem Culture: https://sre.google/sre-book/postmortem-culture/
- Google SRE, Eliminating Toil: https://sre.google/sre-book/eliminating-toil/
- After-Action Review overview, The Systems Thinker: https://thesystemsthinker.com/emergent-learning-in-action-the-after-action-review/
- W. Edwards Deming Institute, PDSA Cycle: https://deming.org/explore/pdsa/
- DORA Metrics: https://dora.dev/guides/dora-metrics/
- OpenTelemetry overview: https://opentelemetry.io/docs/what-is-opentelemetry/
- Automation bias research: https://pmc.ncbi.nlm.nih.gov/articles/PMC7651899/
- PowerShell parsing reference: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_parsing


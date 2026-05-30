# Root-Layer Drop-Down Repair Tickets

Date: 2026-05-30
Status: ACTIVE TICKETS / CONFIRMED ONLY / NOT DOCTRINE
WorkKey: ROOT-LAYER-DROPDOWN-ISSUE-REPAIR-20260530-V1

## RT-ROOT-LAYER-001 - Missing expected root-layer packet and helpers

Symptom: The work order named a Downloads lock-save packet and two saved helper paths, but the packet and requested helper versions were not present.

Upper object: Root-layer drop-down history audit.

Lower object: Source/path/custody route for the packet and helper install.

Likely root: Expected packet was not available in Downloads, and the saved helper lane only held the older Intake helper.

Evidence path: C:/Users/13527/.codex/attachments/2a1961f0-d098-4b7e-9591-4e905eba4a6e/pasted-text.txt

Repair path: Save missing living rule surfaces, save the `V1_1` Intake helper, and save the skipped-history audit helper in Gear Rack.

Proof needed: git status, helper runtime reports, receipt, final clean status.

Affects: rules, helpers, proof, ledgers, maps, intake.

## RT-INTAKE-GATE-001 - Intake helper blank-line binding failure

Symptom: Escalated runtime of `CHECK_INTAKE_GATE_KEY_HASH_JOIN_V1_20260530.ps1` failed with `Cannot bind argument to parameter 'Lines' because it is an empty string`.

Upper object: Intake Gate key/hash audit result.

Lower object: PowerShell report-writer binding in `Add-Line`.

Likely root: Advanced function parameters had no explicit positions, so blank-line calls mis-bound under pwsh 7.

Evidence path: HOUSE_WORK/WORK_SHED/GEAR_RACK/CHECK_INTAKE_GATE_KEY_HASH_JOIN_V1_20260530.ps1

Repair path: Add `CHECK_INTAKE_GATE_KEY_HASH_JOIN_V1_1_20260530.ps1` and repair `Add-Line` with explicit parameter positions.

Proof needed: Direct runtime completion with `EndState: CLEAN_CLOSE`.

Affects: helper, proof, intake.

## RT-INTAKE-GATE-002 - Intake TODO command route typo

Symptom: TODO command pointed at `$env:USERPROFILE\DesktopS\Jxhnny_Kl33N_Seedz...`.

Upper object: Intake Gate audit TODO.

Lower object: Command route path.

Likely root: Typo in route text, not an Intake Gate concept failure.

Evidence path: HOUSE_WORK/TODO/INTAKE_GATE_KEY_HASH_JOIN_AUDIT_TODO_20260530.md

Repair path: Point TODO command to `$env:USERPROFILE\Desktop\123\Jxhnny_Kl33N_Seedz\...V1_1...`.

Proof needed: TODO readback plus direct helper runtime.

Affects: TODO, helper route, intake.

## RT-INTAKE-GATE-003 - V1.1 wrapper parameter forwarding failure

Symptom: First runtime of `CHECK_INTAKE_GATE_KEY_HASH_JOIN_V1_1_20260530.ps1` failed because array splatting passed `-MaxTopFindings` as a positional integer value.

Upper object: Intake Gate V1.1 helper route.

Lower object: PowerShell wrapper parameter forwarding.

Likely root: Array splatting is positional; the wrapper needed hashtable splatting for named script parameters.

Evidence path: HOUSE_WORK/WORK_SHED/GEAR_RACK/CHECK_INTAKE_GATE_KEY_HASH_JOIN_V1_1_20260530.ps1

Repair path: Replace array splatting with `$InvokeArgs = @{ MaxTopFindings = $MaxTopFindings }` and add `Strict` by key.

Proof needed: Direct V1.1 runtime completion with `EndState: CLEAN_CLOSE`.

Affects: helper, proof, intake.

## RT-ROOT-LAYER-002 - Skipped-history helper generic-list CSV export failure

Symptom: First runtime of `CHECK_ROOT_LAYER_SKIPPED_ISSUE_HISTORY_V1_20260530.ps1` failed at `@($Records) | Export-Csv` with `Argument types do not match`.

Upper object: Root-layer skipped issue history audit report.

Lower object: PowerShell one-object/many-object normalization around generic lists.

Likely root: `@($Records)` wrapped the generic list object instead of exporting the contained records cleanly.

Evidence path: HOUSE_WORK/WORK_SHED/GEAR_RACK/CHECK_ROOT_LAYER_SKIPPED_ISSUE_HISTORY_V1_20260530.ps1

Repair path: Export `$Records.ToArray()` and `$Findings.ToArray()`.

Proof needed: Direct runtime completion with `EndState: CLEAN_CLOSE`.

Affects: helper, proof, root-layer audit.

## Parking

Watch rows from the skipped-history audit are suspects until classified. Do not create repair waves from them without review.

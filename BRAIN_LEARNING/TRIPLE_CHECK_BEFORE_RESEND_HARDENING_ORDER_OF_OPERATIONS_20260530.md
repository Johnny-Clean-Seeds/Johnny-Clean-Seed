# Triple-Check Before Resend Hardening — Order of Operations

Date: 2026-05-30
WorkKey: TRIPLECHECK-RESEND-HARDENING-20260530
RuleKey: TRIPLE-CHECK-BEFORE-RESEND-HARDENING-ORDER-V1
Status: BRAIN LEARNING / PROCESS RULE / NOT DOCTRINE
RepairNote: V1.2 save route repaired V1 report-writer null collection primitive and V1.1 dirty-status path parsing by using array-backed report construction plus robust status-prefix normalization.

## Object

This record saves the operational order used when a helper file had to be resent after repeated lower-layer failures.

The important thing is not only that the later first-live-use helper passed. The important thing is the decision process that prevented a soft resend from becoming another false clean route.

## Spur

The active line began after the Helper Script Generation Base-Layer Guard was saved.

A first live-use helper was generated to prove that guard. V1 failed at the report-writing primitive layer because the old report-line helper received a null Lines collection. The user then reported the download link problem and asked for the same repaired helper to be resent. After that, the user asked for the file to be gone back over and triple checked.

That request exposed a process risk: a repeated-failure lane should not merely resend the last helper. The last helper may be a partial repair that still does not prove its own claims.

## What came before

The lower-layer breadcrumb chain had already shown repeated failures in:

- PowerShell parser and string generation.
- Markdown backtick handling inside PowerShell strings.
- Sort-Object argument composition.
- PowerShell automatic variable collision with `$Matches`.
- old line-helper/report-helper collection binding.
- Git status scalar-versus-array collection shape.
- Hash-line collection null handling.
- Manifest and receipt save order.
- Operator command mash from pasted commands.
- Code Gate probe passing while direct run later hit an unexercised branch.

The saved Helper Script Generation Base-Layer Guard then placed the rule that generated helpers should use safe primitives before more helper work continued.

## What the user asked

The user did not ask for another abstract rule first.

The user asked to resend or re-check the helper file after the link problem and after repeated base-layer failures. This made the active object a file-resend/reuse decision under a known failure trail.

## Order of operations used

### 1. Stop the resend impulse

The first hidden risk was treating "send the same file again" as a mechanical file action.

The correct move was to stop before resending and ask whether the existing file was strong enough under the latest guard.

### 2. Re-lock the active object

Active object:

RUN_HELPER_SCRIPT_GENERATION_BASE_LAYER_GUARD_FIRST_LIVE_USE_V1.1.ps1

Mode:

local-only first live-use proof helper.

Boundary:

no Git writes, no delete, no move, no doctrine, no ACTIVE_GUIDES, no CURRENT_TRUTH_INDEX, no automation, no watcher.

### 3. Read the live failure trail

The file was not judged in isolation.

It was judged against the lower-layer breadcrumb chain and the saved Helper Script Generation Base-Layer Guard.

The relevant prior failures were not random. They formed a pattern: helpers were passing one layer but failing another because the generated script primitives were too soft.

### 4. Ask what proof the helper must produce

The helper was not supposed to merely write a report.

It was supposed to prove first live use of the saved base-layer guard.

Therefore the real proof conditions were:

- guard files are present;
- safe report-line primitive works;
- null text handling is safe;
- scalar-to-array wrapping works before count checks;
- `$Matches` automatic variable collision is avoided;
- parser-safe sorting is used;
- Git status is handled as an array;
- old dangerous patterns are absent;
- HEAD and origin/main are known;
- Git status is known;
- failures block instead of creating a soft report.

### 5. Detect that V1.1 was too soft

V1.1 could produce a report without enforcing all required proof conditions.

That meant it might look like a proof artifact while not proving the object. This is a false-clean risk.

### 6. Harden before resending

The file was upgraded to V1.2 before being sent.

The hardening added:

- required guard-file presence checks;
- fourteen primitive checks;
- required-failure counting;
- watch-row counting;
- self-scan for old dangerous patterns;
- HEAD / origin / Git status capture;
- explicit FIRST_LIVE_USE_BLOCKED behavior;
- nonzero exit if required proof failed.

### 7. Make failure useful

The repair did not hide the failure.

It changed the helper so that if proof was missing, the helper would write the report and exit nonzero. That turns a failure into a clean return point instead of a fake pass.

### 8. Send only after hardening

Only after the resend object was hardened against the live guard was it given to the user as V1.2.

### 9. Prove through Code Gate first

The user ran V1.2 through Code Gate.

The Code Gate route verified parser/run surface first.

### 10. Prove direct run second

The user then ran V1.2 direct.

Both the Code Gate run and the direct run completed CLEAN_CLOSE with:

- Head equals OriginMain.
- GitStatus clean.
- GuardFilesPresent 6/6.
- PrimitiveChecks 14.
- RequiredFailures 0.
- WatchRows 0.
- Verdict FIRST_LIVE_USE_PASS / BASE_LAYER_PRIMITIVES_HELD / GUARD_FILES_PRESENT.

## What this process fixes

This process fixes a subtle failure mode:

A helper can be "the repaired one" and still be too soft.

A resend can become a false pass if the assistant does not re-check the file against the newest guard and failure trail.

A report can look like proof while lacking required proof conditions.

## Rule

When a helper, script, handoff, file, or save route is requested again after repeated lower-layer failures, do not merely resend it.

Run Triple-Check Before Resend:

1. Re-lock the object.
2. Load the active guard and breadcrumb trail.
3. Ask what the file must prove, not merely what it must do.
4. Check whether the current file enforces those proof conditions.
5. Self-scan for known dangerous old patterns.
6. Harden the file if it is soft.
7. Require blocked/nonzero exit if proof fails.
8. Send only the hardened file.
9. Prove through Code Gate.
10. Prove through direct run only after Code Gate passes.
11. Save the process when it produces reusable system learning.

## Relation to existing house tools

### Swift Scan

This rule supports one active object, one active pointer, and one next condition. It blocks file-resend momentum from replacing judgment.

### Lower-Level Error Powerplay Freeze

This rule operates when repeated lower-layer failures have already shown that the base layer is risky. It keeps the upper task frozen until the file/route proves clean.

### Helper Script Generation Base-Layer Guard

This rule is a caller of the guard. It says when to re-check a helper against the guard before re-sending.

### Grandmaster Node Root Ledger

This rule creates a node for the process and a feeler to the proof report. The return path is: resend request -> triple-check process -> hardened helper -> first live-use proof -> helper base-layer guard -> Grandmaster.

### Code Gate

Code Gate remains required. Code Gate PASS is not job PASS.

## What is proven

The order of operations was used once and produced a better helper shape before resend.

The hardened V1.2 first live-use helper passed Code Gate and direct run.

The saved guard files were present during the proof.

The safe primitive checks held in the proof run.

## What is not proven

This does not prove all future helpers are safe.

This does not prove broad audit authority.

This does not implement a generator.

This does not automate helper generation.

This does not change doctrine, ACTIVE_GUIDES, or CURRENT_TRUTH_INDEX.

## Required future use

Use this rule when:

- a file link breaks after a repeated-failure route;
- the user asks for "same one" after helper failures;
- the user asks to triple check a helper before running;
- Code Gate passes but direct run previously failed;
- a breadcrumb trail suggests the last file may be a partial repair;
- a helper can create a report without proving required conditions.

## Close condition

This rule closes only when it is saved with receipt and later used as a live check before re-sending a helper or save script after repeated lower-layer failures.
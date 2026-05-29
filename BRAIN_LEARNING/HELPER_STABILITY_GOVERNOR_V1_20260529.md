# Helper Stability Governor V1

Date: 2026-05-29
Status: PATTERN CANDIDATE / READY FOR LOCK SAVE
Placement: Local Code Workbench -> Helper Runtime Patterns -> Helper Stability Governor
Authority: not doctrine; not ACTIVE_GUIDES; not CURRENT_TRUTH_INDEX
Source basis: user-provided Helper Stability Governor expansion text
Source SHA256: E70445F90939EB4DFB861C47A1D2DD1C54D3EA52A88D28B8A9E68F545C2C781E

## 0. Final object lock

The object is:

`HELPER_STABILITY_GOVERNOR_V1`

The child implementation target is:

`RUN_SOURCE_WASH_FULL_CYCLE_V1.1.ps1`

The governor is a helper-wide runtime stabilizer. It is not a wash-only patch.

The governor's job is to let local helpers start conservatively, measure runtime pressure, adjust work bite size and pacing, record every adjustment, force checkpoints, and stop cleanly before fake PASS or machine choke.

Short form:

`measure -> score -> decide -> adjust -> ledger -> checkpoint / continue / stop`

Full cycle:

`HELPER_INIT -> GOVERNOR_INIT -> WORK_WINDOW -> SENSOR_SNAPSHOT -> PRESSURE_SCORE -> GOVERNOR_DECISION -> KNOB_ADJUSTMENT -> GOVERNOR_LEDGER_WRITE -> CHECKPOINT_OR_NEXT_WINDOW -> FINAL_CLOSE`

## 1. Why this exists

Fixed helper limits prove early safety, but fixed limits are too crude for repeated local work.

Fixed limits say:

- `MaxFiles 25`
- `MaxDepth 2`
- `BatchSize 5`
- `SleepMs 25`

That protects a weak machine at first, but it cannot adapt.

When the run is smooth, fixed limits stay too small.
When the run is heavy, fixed limits may still be too large.
When rough spots begin, the helper needs to slow down before the run becomes a choke.
When output/state/receipt writes fail, the helper must stop cleanly and preserve the failure.

The missing object is a regulator, not a bigger limit.

Clean principle:

`Fixed limits prove safety. A governor proves controlled growth.`

## 2. Non-goals and blocked authority

The governor is not intelligence.
The governor is not a doctrine judge.
The governor is not a save helper.
The governor is not a broad scanner.
The governor is not allowed to hide failure.

Blocked:

- no doctrine decision;
- no ACTIVE_GUIDES edit;
- no CURRENT_TRUTH_INDEX edit;
- no Git save;
- no move/delete/system action;
- no hidden broad scan;
- no expanding root, depth, or approved total scope;
- no converting pressure score into truth;
- no skipping evidence silently to look clean;
- no overriding Code Gate;
- no fake PASS when RED or BLACK appears;
- no helper continuing after `StopRequired = true`.

The governor may adjust pace only. It may not adjust authority.

## 3. Role separation

Helper Work Engine:
Runs the actual local task: read files, hash files, chunk text, scan folders, cut transcripts, inspect packages, write reports, write receipts.

Helper Stability Governor:
Controls runtime stability: pace, bite size, sleep, byte window, checkpoint timing, safe stop, choke stop, governor ledger.

Assistant / user:
Judges meaning, adoption, promotion, save route, and whether a pattern should become stronger after proof.

Final Judge:
Verifies whether the helper and governor each did their job, whether boundaries held, whether proof is real, and whether PASS language is allowed.

## 4. Runtime architecture

A governed helper has these pieces:

1. Helper work engine.
2. Stability governor.
3. State ledger / state JSON.
4. Work-result ledger.
5. Rough-spot ledger.
6. Governor ledger.
7. Final report.
8. Final receipt.

For Source Wash Controller V1.1:

`SOURCE_WASH_CONTROLLER -> HELPER_STABILITY_GOVERNOR -> BATCH WASH -> DECISION LEDGER -> ROUGH-SPOT LEDGER -> GOVERNOR LEDGER -> REPORT -> RECEIPT`

New artifact:

`HELPER_GOVERNOR_LEDGER_V1_<RunId>.csv`

Updated artifacts:

- state JSON includes `GovernorState`;
- report includes governor summary;
- receipt includes governor verdict and governor-ledger hash.

## 5. Capability keys

The governor must be keyed so it cannot become vague self-authority.

`READ_SENSOR_KEY`
May read runtime counters and helper result data.

`ADJUST_BATCH_KEY`
May adjust batch size inside approved min/max bounds.

`ADJUST_SLEEP_KEY`
May adjust sleep/pause timing inside approved min/max bounds.

`ADJUST_BYTE_WINDOW_KEY`
May reduce or cautiously increase the byte window inside approved bounds.

`CHECKPOINT_KEY`
May require an A checkpoint before the next work window.

`SAFE_STOP_KEY`
May stop a run cleanly when pressure becomes unsafe.

`CHOKE_STOP_KEY`
May force a choke close when a proof-corrupting failure appears.

`LEDGER_KEY`
Must write every governor decision.

`NO_AUTHORITY_KEY`
Cannot decide doctrine, truth, adoption, promotion, or save.

`NO_SCOPE_EXPANSION_KEY`
Cannot expand root, depth, total work ceiling, mode, Git behavior, or save behavior.

`NO_HIDE_ROUGH_SPOT_KEY`
Cannot smooth over skips/errors by hiding them.

## 6. Hard distinction: pace versus scope

The governor may change:

- `CurrentBatchSize`;
- `CurrentSleepMs`;
- `CurrentMaxBytesPerBatch`;
- `CheckpointEveryBatches`;
- `CurrentWorkWindow`;
- `RampLevel`;
- `BackoffLevel`.

The governor must not automatically change:

- `Root`;
- `MaxDepth`;
- approved total `MaxFiles` / `MaxItems` ceiling;
- mode;
- Git behavior;
- save behavior;
- authority lane;
- source custody;
- final truth/adoption judgment.

If broader scope is needed, the assistant/user decides. The governor only paces within the already locked scope.

## 7. Sensor pack

Every governed helper needs a sensor snapshot per work window.

Minimum sensors:

`ItemsPlannedWindow`
Items assigned to the window.

`ItemsAttemptedWindow`
Items attempted.

`ItemsProcessedWindow`
Items completed successfully.

`ItemsSkippedWindow`
Items skipped with record.

`BytesPlannedWindow`
Expected byte load if known.

`BytesProcessedWindow`
Actual byte load touched.

`BatchDurationMs`
Elapsed time for the window.

`AverageItemMs`
`BatchDurationMs / max(ItemsAttemptedWindow, 1)`.

`WarningsWindow`
WATCH rough spots.

`ErrorsWindow`
BLOCKER or CHOKE rough spots.

`UnreadableCountWindow`
Read/encoding/permission failures.

`OversizeCountWindow`
Items skipped because of size ceiling.

`OutputWriteFailureCount`
Report/ledger/state/receipt write failures.

`LimitHitFlag`
Approved scope/window ceiling reached.

`RemainderKnownFlag`
There is known material left outside the approved window.

`ConsecutiveCleanBatches`
Clean run windows in a row.

`ConsecutivePressureBatches`
Pressure windows in a row.

`StateWriteOk`
State write succeeded.

`GovernorLedgerWriteOk`
Governor ledger write succeeded.

`ReceiptWriteOk`
Receipt write succeeded.

`ChokeSignal`
Unexpected exception, wrapper confusion, path mismatch, unsafe flag, or proof-corrupting event.

Optional sensors for later versions:

`DiskFreeHint`
Useful for heavy-output helpers.

`OutputFolderFileCount`
Prevents report folder explosion.

`DuplicateRunIdFlag`
Prevents overwrite.

`CpuHint` and `MemoryHint`
Allowed only if simple, safe, and not invasive. The governor must not depend on them for V1.

## 8. Control knobs

Governor-controlled knobs:

`CurrentBatchSize`
How many work items to try next.

`CurrentSleepMs`
Pause between items/windows.

`CurrentMaxBytesPerBatch`
Max byte load per work window.

`CheckpointEveryBatches`
How often A checkpoints are required.

`HardStopOnChoke`
Always true for V1.

`RampLevel`
Trust earned from stable windows.

`BackoffLevel`
Throttle severity from pressure windows.

`MinBatchSize`
Usually 1.

`MaxBatchSizeApproved`
Hard ceiling. The governor cannot exceed it.

`MinSleepMs`
Usually 0.

`MaxSleepMs`
Usually 1000 or 2000.

`MaxBytesPerBatchApproved`
Hard byte ceiling.

Early proof defaults:

- `InitialBatchSize = 5`
- `MinBatchSize = 1`
- `MaxBatchSizeApproved = 25 or 50`
- `InitialSleepMs = 25`
- `MinSleepMs = 0`
- `MaxSleepMs = 1000`
- `InitialMaxBytesPerBatch = 2MB`
- `MaxBytesPerBatchApproved = 10MB`

## 9. RPM gauge model

The RPM gauge is a pressure gauge, not a speed brag.

`GREEN`
Stable. No rough spots. Output writes OK. Duration and byte load normal.

`YELLOW`
Mild pressure. Some watch signal, slight duration/byte increase, or limit pressure.

`ORANGE`
Real pressure. Multiple watch signals, repeated pressure, large byte load, rising duration, or clustered skips.

`RED`
Unsafe. Blocker signal, output/state/receipt write risk, path issue, repeated rough spots, or state mismatch.

`BLACK`
Choke. Unexpected exception, proof-corrupting event, hard failure, or impossible metrics.

Meaning:

- `GREEN = earn more bite`
- `YELLOW = hold steady`
- `ORANGE = throttle`
- `RED = safe stop`
- `BLACK = choke stop`

YELLOW and ORANGE are not automatic failure. They are control signals. RED and BLACK block clean PASS.

## 10. Pressure score

Start each work window with:

`PressureScore = 0`

Add pressure:

- `+10` if batch duration is noticeably slower than moving average.
- `+10` if bytes processed exceed the soft byte target.
- `+15` for each WATCH rough spot.
- `+20` if any unreadable item appears.
- `+20` if any oversize item appears.
- `+25` if a limit is hit earlier than expected.
- `+30` if `ConsecutivePressureBatches >= 2`.
- `+50` for a blocker condition.
- `+100` for choke signal, impossible metric, output write failure, state write failure, governor ledger write failure, or receipt write failure.

Subtract stability:

- `-10` for a clean batch.
- `-10` if `ConsecutiveCleanBatches >= 2`.
- `-5` if duration is below moving average and byte load is normal.

Clamp:

`0 <= PressureScore <= 100`

Gauge map:

- `0-20 = GREEN`
- `21-40 = YELLOW`
- `41-65 = ORANGE`
- `66-89 = RED`
- `90-100 = BLACK`

The pressure score is a routing signal only. It is not source truth.

## 11. Moving averages

The governor compares the current window to the current run, not to a random global number.

Track:

- `AverageBatchDurationMs`
- `AverageItemMs`
- `AverageBytesPerBatch`

V1 formula:

`NewAverage = ((OldAverage * PriorBatchCount) + CurrentValue) / (PriorBatchCount + 1)`

Later versions may use EWMA, but V1 should stay simple.

## 12. Decision ladder and exact actions

`RAMP_UP`

Condition:

- gauge GREEN;
- no rough spots;
- output writes OK;
- consecutive clean batches >= 2;
- current batch size below approved ceiling.

Action:

- `NextBatchSize = min(MaxBatchSizeApproved, CurrentBatchSize + RampStep)`
- `RampStep = 1 or 2`
- `NextSleepMs = max(MinSleepMs, CurrentSleepMs - 5)`
- `CheckpointRequired = false unless normal checkpoint interval says true`

`HOLD`

Condition:

- GREEN but not enough clean streak;
- or YELLOW without repeated pressure;
- or stable but near ceiling.

Action:

- keep batch size;
- keep or slightly increase sleep if YELLOW;
- write ledger;
- continue.

`THROTTLE_DOWN`

Condition:

- repeated YELLOW;
- ORANGE;
- watch rough spots cluster;
- duration or byte load rises sharply.

Action:

- `NextBatchSize = max(MinBatchSize, floor(CurrentBatchSize / 2))`
- `NextSleepMs = min(MaxSleepMs, CurrentSleepMs + 50)`
- `CheckpointRequired = true if ORANGE`

`BACKOFF_HARD`

Condition:

- repeated ORANGE;
- unreadable/oversize cluster;
- unstable output pattern;
- pressure score rising after throttle.

Action:

- `NextBatchSize = MinBatchSize`
- `NextSleepMs = min(MaxSleepMs, CurrentSleepMs + 250)`
- `CheckpointRequired = true`
- continue only if no RED/BLACK condition exists.

`SAFE_STOP`

Condition:

- RED gauge;
- blocker condition;
- path mismatch;
- state mismatch;
- output write problem;
- governor ledger cannot be trusted.

Action:

- `StopRequired = true`
- `FinalLabel = B_BLOCKED_WITH_RETURN_POINT`
- write state, rough-spot ledger, governor ledger, receipt if possible.

`CHOKE_STOP`

Condition:

- BLACK gauge;
- unexpected exception;
- proof-corrupting failure;
- impossible metrics;
- receipt/state write cannot be preserved.

Action:

- `StopRequired = true`
- `FinalLabel = B_CHOKE_STOP` or `B_CHOKE_CAUSED_END`
- no PASS language.

## 13. Control law

Use additive increase and multiplicative decrease.

Smooth run:

`5 -> 7 -> 9 -> 11 -> 13`

Pressure run:

`13 -> 6 -> 3 -> 1`

Unsafe:

`1 -> stop`

The governor earns larger bites slowly and cuts back quickly. This avoids a dumb jump such as `25 -> 500`.

## 14. Governor ledger contract

Every governor decision must be written.

File:

`HELPER_GOVERNOR_LEDGER_V1_<RunId>.csv`

Required columns:

`RunId`
`HelperName`
`HelperVersion`
`GovernorVersion`
`Phase`
`BatchId`
`GaugeState`
`PressureScore`
`GovernorDecision`
`BatchSizeBefore`
`BatchSizeAfter`
`SleepBeforeMs`
`SleepAfterMs`
`MaxBytesBefore`
`MaxBytesAfter`
`ItemsPlanned`
`ItemsAttempted`
`ItemsProcessed`
`ItemsSkipped`
`BytesPlanned`
`BytesProcessed`
`DurationMs`
`AverageItemMs`
`Warnings`
`Errors`
`RoughSpots`
`LimitHitFlag`
`RemainderKnownFlag`
`ConsecutiveCleanBatches`
`ConsecutivePressureBatches`
`CheckpointRequired`
`StopRequired`
`Reason`
`ReturnPoint`
`Timestamp`

No ledger means no trusted adaptive behavior.

## 15. State JSON contract

Every governed helper state file should include:

`GovernorState`

Required fields:

- `GovernorName`
- `GovernorVersion`
- `Enabled`
- `CurrentGaugeState`
- `CurrentPressureScore`
- `CurrentBatchSize`
- `CurrentSleepMs`
- `CurrentMaxBytesPerBatch`
- `MinBatchSize`
- `MaxBatchSizeApproved`
- `MinSleepMs`
- `MaxSleepMs`
- `MaxBytesPerBatchApproved`
- `ConsecutiveCleanBatches`
- `ConsecutivePressureBatches`
- `AverageBatchDurationMs`
- `AverageItemMs`
- `AverageBytesPerBatch`
- `LastDecision`
- `LastReason`
- `CheckpointRequired`
- `StopRequired`
- `GovernorVerdict`

This lets a run be inspected from the state file without opening only the CSV.

## 16. Receipt contract

Any governed helper receipt must include:

- `GovernorEnabled: True`
- `GovernorVersion: HELPER_STABILITY_GOVERNOR_V1`
- `FinalGaugeState`
- `FinalPressureScore`
- `GovernorVerdict`
- `GovernorLedger`
- `GovernorLedgerSHA256`
- `RampEvents`
- `HoldEvents`
- `ThrottleEvents`
- `BackoffEvents`
- `SafeStopEvents`
- `ChokeStopEvents`
- `MaxBatchSizeReached`
- `ApprovedScopeCompleted`
- `RemainderKnown`
- `BoundaryHeld`

The receipt proves not only that outputs exist, but that adaptive behavior stayed inside lane.

## 17. Helper integration contract

A helper adopts the governor through two required calls.

Before work window:

`GovernorBeforeBatch(helperState)`

Returns:

- `BatchSize`
- `SleepMs`
- `MaxBytesPerBatch`
- `CheckpointRequired`
- `StopRequired`
- `Reason`

After work window:

`GovernorAfterBatch(batchResult)`

Returns:

- `GaugeState`
- `PressureScore`
- `GovernorDecision`
- `NextBatchSize`
- `NextSleepMs`
- `NextMaxBytesPerBatch`
- `CheckpointRequired`
- `StopRequired`
- `Reason`
- `ReturnPoint`

Required behavior:

- helper must obey `StopRequired`;
- helper must write a governor ledger entry;
- helper must record rough spots separately;
- helper must not claim clean close if final gauge is RED or BLACK;
- helper must not silently skip items to keep pressure low.

## 18. Interaction with rough-spot ledger

The governor does not replace rough-spot handling.

Rough-spot ledger records what happened.
Governor ledger records how the helper reacted.

Example:

Rough spot:

`OVERSIZE_FILE / WATCH / SKIP_WITH_RECORD`

Governor reaction:

`YELLOW / HOLD` or `ORANGE / THROTTLE_DOWN`

If the governor stops:

Rough spot ledger records the cause.
Governor ledger records the control decision.
Receipt records the final close truth.

## 19. Limits, remainder, and truth language

The governor must distinguish:

`APPROVED_SCOPE_COMPLETED`
The helper completed the approved window.

`LIMIT_HIT_SOURCE_REMAINS`
The helper reached the approved ceiling but more source remains.

`PRESSURE_STOP_REMAINDER`
The helper stopped because pressure rose.

`BLOCKED_REMAINDER`
The helper stopped because a blocker appeared.

This matters because:

`APPROVED_SCOPE_COMPLETED` can support `CLEAN_WASH`.
`LIMIT_HIT_SOURCE_REMAINS` supports `WASH_WITH_PARKED_ITEMS`.
`PRESSURE_STOP_REMAINDER` supports `WASH_NEEDS_PROOF` or `WASH_WITH_PARKED_ITEMS`.
`BLOCKED_REMAINDER` supports `WASH_BLOCKED`.

Do not use "complete" when only the approved window completed and source remains.

## 20. Governor verdicts

Separate governor verdict from helper verdict.

`GOVERNOR_STABLE`
No major intervention needed.

`GOVERNOR_STABLE_WITH_RAMP`
The governor safely increased bite size within ceiling.

`GOVERNOR_HELD_STEADY`
The governor held settings because ramp was not earned or pressure was mild.

`GOVERNOR_THROTTLED_AND_CLOSED`
The governor reduced load and the helper still closed safely.

`GOVERNOR_BACKED_OFF_AND_CLOSED`
The governor dropped to minimum bite and closed safely.

`GOVERNOR_PARKED_REMAINDER`
The governor closed with known remaining material.

`GOVERNOR_SAFE_STOP`
The governor stopped safely before damage.

`GOVERNOR_CHOKE_STOP`
The governor hit choke; no PASS.

Example:

`HelperVerdict: WASH_WITH_PARKED_ITEMS`
`GovernorVerdict: GOVERNOR_STABLE_WITH_RAMP`
`EndState: B_CLEAN_CLOSE`

That means the helper ran well, but the approved window left source parked.

## 21. Helper-wide use map

The pattern applies to helper classes, not just Source Wash.

Source Wash Controller:
item = file or source object.

Long File Reader:
item = chunk or section.

Transcript Cutter:
item = transcript segment.

Porch Intake Helper:
item = package member.

Hash Receipt Helper:
item = file hash target.

Code Gate Batch Runner:
item = script.

Source-to-House Intake Helper:
item = intake object.

Folder Inventory Helper:
item = file or folder node.

Cleaner/Sorter Helper:
item = route candidate.

Each helper maps its own item type, but the governor contract stays the same.

## 22. Proof ladder

`Proof 0 — Contract complete`
Spec defines boundaries, sensors, knobs, decisions, ledgers, receipt, integration, failure behavior.

`Proof 1 — Passive ledger proof`
Governor records decisions without changing behavior.

`Proof 2 — Ramp proof`
Governor increases batch size after clean consecutive batches.

`Proof 3 — Throttle proof`
Governor reduces batch size under forced watch/pressure.

`Proof 4 — Backoff proof`
Governor drops to minimum bite under repeated pressure.

`Proof 5 — Safe stop proof`
Governor stops on forced output/state/governor-ledger failure or forbidden condition.

`Proof 6 — Real helper integration proof`
Source Wash Controller V1.1 runs against bounded real root with governor enabled.

`Proof 7 — Cross-helper reuse proof`
A second helper uses the same contract.

`Proof 8 — Candidate pattern upgrade review`
Only after cross-helper proof should this be considered for stronger helper-pattern status.

One helper proves a child implementation. It does not prove the whole pattern as universal.

## 23. V1 implementation scope

Do not create a separate module yet.

First implementation should embed governor functions inside:

`RUN_SOURCE_WASH_FULL_CYCLE_V1.1.ps1`

Reason:

A separate shared module is premature until at least one child helper proves the behavior and a second helper proves reuse.

Source Wash V1.1 should add parameters:

- `-UseGovernor` default true;
- `-InitialBatchSize 5`;
- `-MinBatchSize 1`;
- `-MaxBatchSizeApproved 50`;
- `-InitialSleepMs 25`;
- `-MinSleepMs 0`;
- `-MaxSleepMs 1000`;
- `-InitialMaxBytesPerBatchMB 2`;
- `-MaxBytesPerBatchApprovedMB 10`;
- `-ConsecutiveCleanBatchesForRamp 2`;
- `-RampStep 2`.

New artifact:

`HELPER_GOVERNOR_LEDGER_V1_<RunId>.csv`

Updated artifacts:

- `FULL_WASH_CYCLE_STATE_V1_<RunId>.json`;
- `FULL_WASH_CYCLE_REPORT_V1_<RunId>.md`;
- `FULL_WASH_CYCLE_RECEIPT_V1_<RunId>.txt`.

## 24. V1.1 success standard

A governed helper run succeeds only if:

- Code Gate parser PASS;
- Code Gate probe PASS;
- real bounded run starts conservative;
- governor ledger exists;
- at least one governor decision is recorded per batch;
- batch size never exceeds approved ceiling;
- sleep stays within bounds;
- byte window stays within bounds;
- rough spots remain visible;
- state includes governor state;
- receipt hashes governor ledger;
- final governor verdict is not RED/BLACK when claiming clean close;
- end state is `B_CLEAN_CLOSE`, `B_BLOCKED_WITH_RETURN_POINT`, or honest choke close;
- boundary remains no Git, no move/delete, no doctrine.

If smooth and source remains because the approved ceiling was reached:

- `EndState: B_CLEAN_CLOSE`
- `HelperVerdict: WASH_WITH_PARKED_ITEMS`
- `GovernorVerdict: GOVERNOR_STABLE_WITH_RAMP` or `GOVERNOR_PARKED_REMAINDER`

If throttled and closed:

- `EndState: B_CLEAN_CLOSE`
- `HelperVerdict: WASH_WITH_PARKED_ITEMS` or `WASH_NEEDS_PROOF`
- `GovernorVerdict: GOVERNOR_THROTTLED_AND_CLOSED`

If stopped safely:

- `EndState: B_BLOCKED_WITH_RETURN_POINT`
- `GovernorVerdict: GOVERNOR_SAFE_STOP`

If choked:

- `EndState: B_CHOKE_STOP`
- `GovernorVerdict: GOVERNOR_CHOKE_STOP`

## 25. Final verdict

`HELPER_STABILITY_GOVERNOR_V1 = ACCEPT AS BROADER HELPER PATTERN CANDIDATE`

Save boundary:

- save as helper-pattern candidate;
- no doctrine promotion;
- no ACTIVE_GUIDES edit;
- no CURRENT_TRUTH_INDEX edit;
- no module build yet;
- no automation;
- no dashboard;
- no claim that the governor is proven reusable yet.

Next build route:

`RUN_SOURCE_WASH_FULL_CYCLE_V1.1.ps1` should embed the governor, Code Gate first, then run the same bounded `SORTING_BENCH` proof.

The cleaner fix is:

`small safe start -> governor earns larger bites -> pressure causes throttle -> every adjustment is ledged -> final receipt proves close truth`


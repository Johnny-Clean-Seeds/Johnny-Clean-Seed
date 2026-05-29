# PowerShell Front-Gate / Helper Trust Incident Rule Pack V1.1

Status: INCIDENT REPAIR PACK / NOT DOCTRINE
Incident: `POWERSHELL_FRONT_GATE_BYPASS_AND_COPY_SURFACE_FAILURE_20260529`
Close state: `B_CHOKE_STOP / BLOCKED_WITH_RETURN_POINT / HANGING_PROCESS_CLEANED`
Current command state: `NO HELPER CONTINUATION / NO BYPASS / NO EVIDENCE DELETE`
Current proven transcript road: `DIRECT_YT_DLP_ROAD_ONLY`
Current helper lane: `SUSPENDED`

## 1. Final incident verdict

This was a connected failure system:

`COPY_SURFACE_FAILURE + FRONT_GATE_SKIP + HELPER_ROUTE_OVERMOMENTUM + CODE_GATE_SCOPE_CONFUSION + REPAIR_ESCALATION_AFTER_PARSER_FAIL + TRUST_CHAIN_DAMAGE + HANGING_INTERACTIVE_TARGET`

The shell did not go bad by itself. Human document/spec text entered a terminal-active surface and PowerShell tried to execute it as commands.

The helper did not pass.

V1.1 failed Code Gate syntax and did not run.

V1.1.1 reached `CODE GATE PASSED PARSER. RUNNING TARGET...` under a PowerShell process launched with `-ExecutionPolicy Bypass`; final completion proof was not provided. A later process check found an active helper child process and force-stopped it.

Correct V1.1.1 state:

`YOUTUBE_TRANSCRIPT_DESKTOP_TOOL_MIN_HELPER_V1.1.1.ps1 = TARGET_PROCESS_FOUND_AND_FORCE_STOPPED / PID_12332 / EXECUTIONPOLICY_BYPASS_CONTEXT / HANGING_INTERACTIVE_TARGET / COMPLETION_UNKNOWN / TRUST_TAINTED / DO_NOT_CONTINUE`

## 2. Primary rule: no default bypass

Rule name: `POWERSHELL_FRONT_GATE_NO_DEFAULT_BYPASS_RULE`

Do not use `-ExecutionPolicy Bypass` by default for generated helpers, repair scripts, save scripts, test scripts, or Code Gate launches.

PowerShell has a script-start gate. It may stop `.ps1` files before they run. `-ExecutionPolicy Bypass` tells the launched PowerShell process not to enforce that gate for that process.

House meaning: the front gate was skipped.

Correct default: use normal `pwsh -File ...` first.

A one-process execution-policy override may be considered only when all are true:

1. normal `pwsh -File ...` was tried first;
2. PowerShell returned an actual execution-policy block;
3. the exact block message is shown;
4. the blocked script is trusted or already reviewed;
5. the user explicitly approves;
6. the command labels the action plainly as a temporary PowerShell execution-policy override for this process;
7. the target still goes through the active gate path;
8. artifact proof still decides PASS.

Blocked: silent bypass, habit bypass, bypass because Code Gate exists, bypass for unreviewed generated helpers, bypass during trust incidents, and bypass without exact block plus approval.

## 3. Controlled force is not gate removal

Rule name: `CONTROLLED_FORCE_IS_NOT_GATE_REMOVAL`

Forcing or override can be valid in bounded cases, but it is not the same thing as removing a gate or making bypass normal.

A force action must include:

- reason;
- scope;
- target gate;
- duration;
- what protection remains active;
- who approved it;
- proof expected;
- restore condition;
- confirmation that the gate was put back or that the temporary condition ended.

Never shut the whole front gate down unless the active object is the front gate itself.

## 4. Force requires restore

Rule name: `FORCE_REQUIRES_RESTORE_RULE`

A forced gate action is incomplete until the gate is restored or the temporary exception ends.

No override becomes the new normal. No muted gate stays muted after the bounded job closes.

## 5. Layered gate rule

Rule name: `ALL_GATES_STAY_ON_BY_DEFAULT`

Correct order:

1. Windows/PowerShell front gate.
2. Code Gate or equivalent parser/risk gate.
3. Target/helper proof.
4. Artifact proof.
5. Helper value audit.
6. Seat ledger.

No gate cancels another gate.

ExecutionPolicy is not Code Gate. Code Gate is not job proof. Job proof is not helper value. Helper value is not doctrine. A hash proves identity, not quality. A clean-looking receipt proves nothing unless the artifact exists.

## 6. Document/terminal separation rule

Rule name: `DOCUMENT_NOT_TERMINAL_RULE`

Human specs, incident reports, contracts, checklists, failure-mode tables, markdown notes, and rule packs must not be placed in terminal-ready copy flow during an active PowerShell session.

Document text belongs in notes, markdown files, downloadable `.md` files, or save packets.

Terminal copy blocks are only for commands.

Required labels:

`READ ONLY - DO NOT PASTE INTO POWERSHELL`
`POWERSHELL COMMAND - RUN THIS ONLY`
`DOCUMENT TEXT - PASTE INTO NOTES ONLY`

Failure condition: if prose reaches `PS C:\...>`, the copy surface failed.

## 7. Mode switch before copy

Rule name: `MODE_SWITCH_BEFORE_COPY`

Before giving copyable material, declare the mode:

`DOC` = read/save text only.
`CMD` = terminal command.
`SCRIPT` = downloadable script file.
`RECEIPT` = pasteback proof.
`REVIEW` = user reads and approves.

Never mix document text and terminal command action in the same immediate motion.

If the user is in PowerShell, assume copy-risk is high.

## 8. Code Gate scope rule

Rule name: `CODE_GATE_IS_SECOND_GATE_NOT_FIRST_GATE`

Code Gate is a project/local parser and risk gate. It does not justify skipping PowerShell's own front gate.

Code Gate PASS does not mean job PASS.

Parser FAIL means target does not run, stop, record state, do not repair-sprint, and wash the incident first.

## 9. Helper overmomentum rule

Rule name: `FIRST_HELPER_FAIL_STOPS_THE_HELPER_LANE`

If a generated helper fails Code Gate syntax, stop helper work.

Do not immediately generate V-next. Do not keep moving because "we are close."

After parser FAIL: record target state, name error class, mark target not run, burn helper from live use, review why the bad script was generated, decide whether repair is worth it, and only rebuild if user approves after close.

## 10. Direct road before button

Rule name: `ROAD_BEFORE_BUTTON`

Before building a wrapper, icon, shortcut, helper, manager, queue, dashboard, or installer, prove the raw road.

For transcript work:

`URL -> yt-dlp subtitle download -> VTT -> .NET VTT-to-TXT conversion -> TXT -> length proof`

Current state: direct road is proven. Helper route is not proven. Use direct road until helper lane is reopened cleanly.

## 11. Active object survival

Rule name: `OBJECT_SURVIVES_EVERY_BOUNDARY_OR_FAIL`

A helper passes only if the active object survives every boundary.

For transcript work, active object = YouTube URL.

Boundary chain:

`chat -> PowerShell -> helper parameter/prompt -> URL validation -> external argument list -> yt-dlp -> VTT -> TXT -> artifact check -> receipt -> user verification`

V1 failed because the URL reached the helper but did not reach `yt-dlp`.

Before external tool call, helper must prove: URL present, URL length > 0, tool resolved, output folder exists, external args count known, external args include URL, and last arg is URL or URL position is explicitly verified.

## 12. Script status is not job status

Rule name: `SCRIPT_RAN_DOES_NOT_MEAN_JOB_DONE`

`SCRIPT_STATUS` asks whether the script started, parsed, ran, blocked, or failed internally.

`JOB_STATUS` asks whether the real task produced the intended artifact.

`FINAL_VERDICT` asks whether proof supports PASS, PASS_WITH_WATCH, FAIL_WITH_NOTE, BLOCKED_INPUT, BLOCKED_TOOL_MISSING, or REPAIR_REQUIRED.

A script can run while the job fails. A parser can pass while the job fails. A helper can print organized output while the task is dead.

## 13. Artifact proof

Rule name: `ARTIFACT_OR_NO_PASS`

PASS requires artifact proof.

For transcript helper: TXT file exists, TXT length > 0, receipt exists, receipt proves URL reached `yt-dlp`, and copyback includes TXT path, TXT length, receipt path, and verdict.

No artifact, no PASS.

## 14. Receipt required but not sufficient

Rule name: `RECEIPT_REQUIRED_BUT_NOT_SUFFICIENT`

A receipt is required for meaningful helper runs. A receipt is not enough by itself.

Minimum receipt fields: RunId, helper name, version, helper SHA256 if available, command mode, input object present, input object length/hash if safe, resolved tool path, output folder, boundary chain, external args count, external args include object yes/no, last arg is object yes/no where applicable, exit code, artifact created yes/no, artifact path, artifact length, ScriptStatus, JobStatus, FinalVerdict, FailureNote, and NextAction.

Receipt cannot claim PASS unless artifact proof exists.

## 15. Repeat failure breaker

Rule name: `TWO_SAME_FAILURES_STOP_THE_TOOL`

One failure: inspect. Two same failures: stop helper. Three related failures: treat as system issue.

Current recurrence is enough to suspend the lane: V1 repeated no-URL failure, V1.1 parser failed, V1.1.1 run context tainted by bypass and completion unknown.

## 16. Helper seat ledger

Rule name: `LEDGER_CONTROLS_LIVE_HELPER_TRUST`

Current states:

`YOUTUBE_TRANSCRIPT_DESKTOP_TOOL_MIN_HELPER_V1.ps1 = REPAIR_CANDIDATE / DO_NOT_USE`

`YOUTUBE_TRANSCRIPT_DESKTOP_TOOL_MIN_HELPER_V1.1.ps1 = CODE_GATE_SYNTAX_FAIL / TARGET_NOT_RUN / DO_NOT_USE`

`YOUTUBE_TRANSCRIPT_DESKTOP_TOOL_MIN_HELPER_V1.1.1.ps1 = TARGET_PROCESS_FOUND_AND_FORCE_STOPPED / PID_12332 / EXECUTIONPOLICY_BYPASS_CONTEXT / HANGING_INTERACTIVE_TARGET / COMPLETION_UNKNOWN / TRUST_TAINTED / DO_NOT_CONTINUE`

`Direct yt-dlp road = ONLY_PROVEN_TRANSCRIPT_ROAD`

## 17. Downloads is arrival, not trust

Rule name: `DOWNLOADS_IS_ARRIVAL_NOT_TRUST`

Downloads means arrived, not trusted.

Generated helpers should move through states: DOWNLOADED_UNTRUSTED, HASHED_UNREVIEWED, PLACED_FOR_REVIEW, CODE_GATE_SYNTAX_FAIL, CODE_GATE_PARSE_PASS_ONLY, TARGET_ATTEMPTED_UNDER_TAINT, ARTIFACT_PASS, REJECTED, PARKED_EVIDENCE.

No helper earns trust by existing in Downloads.

## 18. Evidence custody

Rule name: `DO_NOT_DELETE_THE_CRIME_SCENE`

Failed helpers, reports, logs, and receipts are evidence.

Do not delete during incident review. Classify and park.

Burn means stop carrying live weight, not erase proof.

## 19. Unknown is a valid state

Rule name: `UNKNOWN_IS_A_VALID_STATE`

Do not force PASS/FAIL language when proof is missing.

Allowed states: known failed, known passed, known not run, unknown, tainted.

V1.1.1 is unknown/tainted even after force-stop because no final artifact/receipt proof closed the target job.

## 20. Window closed is not process closed

Rule name: `WINDOW_CLOSED_IS_NOT_PROCESS_CLOSED`

Closing a terminal tab/window is not proof that child PowerShell processes stopped. After a hanging helper or runner, check for matching `pwsh.exe` / `powershell.exe` processes before calling containment complete.

## 21. Interrupted run is not clean close

Rule name: `INTERRUPTED_RUN_IS_NOT_CLEAN_CLOSE`

If the user interrupts with Ctrl+C or closes a window during or after target start, state is USER_INTERRUPTED or USER_CLOSED_WINDOW plus COMPLETION_UNKNOWN unless final report proves the target ended first.

Do not call it PASS. Do not call it clean.

## 22. No interactive target under Code Gate by default

Rule name: `NO_INTERACTIVE_TARGET_UNDER_CODE_GATE_BY_DEFAULT`

Do not run a Code Gate target that may wait for live user input. Parser check and target execution must be separated when interaction is possible.

For transcript helpers, target tests must use explicit `-Url`, not a hidden prompt inside the runner.

## 23. Run context proof

Rule name: `RUN_CONTEXT_IS_PART_OF_PROOF`

Record PowerShell version, command shape, whether `-ExecutionPolicy` was used, whether the file was downloaded/unblocked, runner path, target path, whether Code Gate ran target, whether target wrote artifact, and whether target wrote receipt.

Helper behavior cannot be judged apart from run context.

## 24. Unblock is also front-gate change

Rule name: `UNBLOCK_IS_ALSO_FRONT_GATE_CHANGE`

Do not replace blind bypass with blind `Unblock-File`.

Review first, hash first, place in review lane first, and ask user before changing blocked/unblocked state.

No broad folder unblock.

## 25. User surface clarity

Rule name: `USER_ACTION_MUST_BE_OBVIOUS`

If the user can reasonably paste a URL alone into PowerShell, the surface failed.

Future helper must support `-Url` parameter mode, interactive prompt mode, blank URL stop, and clear message not to type URL at raw PowerShell prompt.

## 26. Recovery command shape

Rule name: `RECOVERY_MODE_USES_SMALL_COMMANDS`

When terminal is already dirty, commands must be small.

Use one command, one purpose, one expected output, one stop point.

Avoid long pipelines, mixed prose/code, dependence on prior variables, and multi-step paste blocks.

## 27. External tool handoff

Rule name: `WRAPPER_MUST_PROVE_EXTERNAL_ARGS`

A wrapper around an external tool must prove what it sends.

For `yt-dlp`: tool path, arg count, output template, URL present, URL in final argument list, last arg or verified URL position, and exit code.

No handoff proof, no PASS.

## 28. Compatibility wash

Rule name: `SHELL_COMPATIBILITY_BEFORE_REUSE`

Known local issue: `Set-Content -Encoding UTF8` failed in the user's shell.

Stable mechanism: .NET file writing for transcript TXT conversion.

Use proven local mechanism over generic PowerShell habit.

## 29. False diagnosis burn

Rule name: `BURN_WRONG_EXPLANATIONS`

Burn: PowerShell is broken; the user typed it wrong as root cause; yt-dlp failed as root cause; the helper passed because it started; Code Gate PASS means job PASS; bypass is harmless because Code Gate exists.

Carry: the workflow failed layered gate order and copy-surface separation.

## 30. No repair sprint after trust violation

Rule name: `TRUST_INCIDENT_CLOSES_BEFORE_REPAIR`

After a trust violation: stop helper route, write incident facts, identify bypassed gate, identify copy-surface failure, mark object states, define repairs, and only reopen with explicit approval.

## 31. Incident function map

Govern: no default bypass, document/terminal separation, helper trust ladder.

Identify: name gates, files, states, and affected surfaces.

Protect: keep PowerShell front gate first, use Code Gate second, keep helper files in review lane.

Detect: parser reports, terminal storm logs, artifact checks, receipts, and process checks for hanging child processes.

Respond: choke-stop, suspend helper lane, preserve evidence, stop hanging process, return to direct road.

Recover: use direct route, save repair rule if approved, reopen helper work only under clean conditions.

## 32. Action items

Action item 1: assistant command generation uses normal `pwsh -File` first. Return trigger: execution-policy block.

Action item 2: chat copy output keeps document text out of terminal-ready flow. Return trigger: long spec or active terminal flow.

Action item 3: helper testing stops after parser fail. Return trigger: Code Gate syntax FAIL.

Action item 4: helper value system requires artifact proof and audit before seat. Return trigger: any helper run.

Action item 5: hanging helper containment checks child processes before calling containment complete. Return trigger: hanging target or closed terminal after target start.

Action item 6: controlled force actions require scope, reason, approval, proof, duration, and restoration. Return trigger: any override/force/mute/bypass proposal.

## 33. Reopen conditions

Helper lane may reopen only when: front-gate rule is accepted or explicitly waived, document/terminal separation is accepted, helper files are routed to review lane, normal `pwsh -File` is used first, no bypass unless approved after exact block, Code Gate or equivalent parser/risk gate runs, artifact proof is required, after-run wash is ready, value audit is ready, and interactive targets are tested with explicit parameters unless prompt behavior itself is the bounded test object.

## 34. Authority boundary

This pack does not automatically rewrite doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, mule map, dashboard, automation, or repo status. It is incident repair until lock/save.

## 35. Final carry key

PowerShell front gate stays on by default.

Controlled force is not gate removal.

Force requires restore.

Documents are not terminal commands.

Code Gate is second gate, not first gate.

Parser FAIL stops helper lane.

Bypass requires exact block plus user approval.

Unknown stays unknown until proof closes it.

Window closed is not process closed.

Interactive targets do not run under Code Gate by default.

Artifact proof decides job PASS.

Helper value audit decides tool seat.

Direct road is the current transcript road.

## 36. Save recommendation

Save as a narrow incident repair pack, not doctrine.

Suggested repo targets:

`BRAIN_LEARNING/POWERSHELL_FRONT_GATE_NO_DEFAULT_BYPASS_AND_DOCUMENT_NOT_TERMINAL_RULE_20260529.md`

Support card:

`HOUSE_WORK/WORK_SHED/GEAR_RACK/CODE_CABINET/POWERSHELL_FRONT_GATE_AND_COPY_SURFACE_INCIDENT_CARD_20260529.md`

Receipt:

`PROOF_HISTORY/POWERSHELL_FRONT_GATE_BYPASS_COPY_SURFACE_REPAIR_RECEIPT_20260529.txt`

Boundary: no doctrine, no ACTIVE_GUIDES, no CURRENT_TRUTH_INDEX, no helper rebuild, no helper run, no bypass, no evidence deletion, no dashboard.

Final verdict:

`SAVE_READY / INCIDENT_REPAIR_PACK / HELPER_ROUTE_SUSPENDED / HANGING_PROCESS_CLEANED / DIRECT_ROAD_RETURN`

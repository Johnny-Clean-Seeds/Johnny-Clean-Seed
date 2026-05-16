# Evidence File: LocalBot Machine Evidence for Recursive Core Architecture

## Purpose

This file collects the evidence from the LocalBot project files that supports the
Recursive Core Architecture theory. It is meant to sit beside the two GitHub theory
files already created: the seed-test file and the full architecture file. The purpose is
not to claim that AI never fails. The purpose is to show that failure, drift, weak
lanes, false success, uncontrolled expansion, and authority leakage can be made visible,
bounded, judged, repaired, parked, or closed.

This file uses only information from the uploaded LocalBot project files. It does not
add outside claims. It is organized formally so the evidence can be read as a proof
packet instead of as scattered project notes.

## Source Files Used

The source files used for this evidence packet are LOCALBOT_BASE_AND_CORE_BUILD_ROADMAP,
LOCALBOT_CHECKPOINT, LOCALBOT_FINAL_WRAP_NOTE, LOCALBOT_MASTER_HANDOFF,
LOCALBOT_OCTAGON_ROUTE_MODEL_REFERENCE, LOCALBOT_OPEN_ISSUES, LOCALBOT_PHASES,
LOCALBOT_STUDIO_FILE_INDEX, LOCALBOT_STUDIO_FILE_INTEGRITY,
LOCALBOT_STUDIO_REFERENCE_PARKING, LOCALBOT_STUDIO_RULE_LIBRARY,
LOCALBOT_STUDIO_VALIDATOR_RULES, LOCALBOT_UNIFIED_HANDOFF, and SAVE_NOTE.

## Core Evidence Claim

The LocalBot files support the central Recursive Core Architecture claim by showing a
small AI system that was kept local, bounded, inspectable, recoverable, and
human-verifiable. The evidence does not prove unlimited autonomy. It proves something
more useful at the seed level: the system can separate completion from correctness,
preserve evidence before repair, classify failures, prevent unchecked expansion, park
weak lanes, and close the core instead of expanding by momentum.

## LocalBot as the Practical Seed

LocalBot is defined as a tiny local AI task loop on one Windows PC using Python and
Ollama. Its active path is C:\LocalBot\. Its mission is to protect what works, keep
LocalBot small, local, stable, and practical, and move Phase 4 forward without
architecture drift.

The final working identity recorded in the closeout state is: LocalBot is a controlled
local task runner for one Windows PC using Python, Ollama, pending/running/done/failed
folders, output files, timeout handling, recovery, and human judgment.

This supports Recursive Core Architecture because it gives the theory a concrete seed.
The seed is not a vague agent. It has a working identity, a runtime root, file-based
state, a known model, a known config, task folders, outputs, logs, a coordinator, a
worker, and a final closeout record.

## Runtime Root and Final Folder Structure

The final runtime root is C:\LocalBot. The final runtime root contains coordinator.py,
worker.py, config.txt, tasks, outputs, logs, and Handoff_Stack. The final handoff stack
location is C:\LocalBot\Handoff_Stack. The handoff stack contains the final project
record files and support/reference files.

The final verification after cleanup recorded PASS for coordinator.py, worker.py,
config.txt, tasks, outputs, logs, and Handoff_Stack. This matters because the proof
object is not only conceptual. The files record a concrete structure with named parts
and a verified final placement.

## Expected Runtime Configuration

The expected config is MODEL_NAME=qwen2.5-coder:3b, WORKER_TIMEOUT_SECONDS=120, and
RECOVER_RUNNING_TO_PENDING=1. The daily default model is qwen2.5-coder:3b. The files
repeatedly state not to change model, config, code, or architecture unless live evidence
forces it.

This supports the theory by showing that the seed is bounded. The project does not treat
every issue as a reason to reopen the model, rewrite the system, or expand the
architecture.

## What LocalBot Does

LocalBot reads one pending task, claims it, runs one model call, writes one output,
marks the task done or failed, and exits cleanly. The rebuild roadmap states that the
goal is not maximum features. The design goal is small, inspectable, recoverable,
practical, and stable on real hardware.

The target task lifecycle is pending to running to done, or pending to running to
failed. This file-based lifecycle is evidence for clean placement because state is
visible without a database, failures are easier to inspect, and the task route has a
clear beginning, middle, and end.

## Core File Roles

The roadmap defines config.txt as the file that stores simple runtime settings,
including model name, timeout, and recovery flag. It defines coordinator.py as the main
loop controller that reads config, checks pending tasks, claims one task, runs
worker.py, applies timeout, moves the task to done or failed, logs the result, and
exits. It defines worker.py as the file that performs one model call, reads the task
text, calls Ollama, writes one output file, and returns control to the coordinator.

The tasks folders are defined as pending equals waiting, running equals claimed, done
equals completed, and failed equals failed or timed out. The outputs folder stores task
outputs. The logs folder stores coordinator log and related traces.

This supports the idea that intelligence must be placed. The project does not use vague
agent language as the main proof. It assigns concrete roles to files and folders.

## Build Phases

Phase 1 was to make one tiny working loop. One task goes from pending to running to done
or failed. One worker call only. No hanging forever. Status: COMPLETE.

Phase 2 was to keep what works and harden it. Timeout stays. Logging stays. Failure path
stays. Status: COMPLETE.

Phase 3 was recovery. If a task was left in running, move it back to pending on startup.
Status: COMPLETE.

Phase 4 was practical use. Run real short prompts. Keep tasks small and stable. Refine
prompt/task fit without reopening settled system decisions casually. The phase file
later records FINAL PHASE 4 CLOSEOUT: Phase 4 status closed as a completed practical
core.

This phased record supports controlled growth. The system did not begin with a large
autonomous architecture. It moved from loop, to hardening, to recovery, to practical
use, then closeout.

## Rebuild Roadmap Evidence

The rebuild roadmap says the project is for rebuilding the same class of project: one
small local AI task loop, one Windows PC, Python, Ollama, one task at a time, one worker
call at a time, clean file-based task movement, clear failure handling, and no
unnecessary architecture.

The roadmap’s core principles are to protect simplicity, use one task at a time, treat
file-based state as good enough, harden before expanding, prefer practical proof over
theory, prefer machine fit over generic architecture, treat prompt problems as not
automatically code problems, and not add moving parts without evidence.

This supports the theory because it shows a seed-first process. The machine was not
expanded before the smaller route was proven.

## Validation Checkpoints from the Roadmap

The roadmap defines checkpoint A as tiny loop proved: one pending task processed
correctly, output written, and task moved correctly. Checkpoint B is timeout proved:
worker times out cleanly, task moves to failed, and coordinator exits. Checkpoint C is
recovery proved: stale running task restored to pending and next run continues normally.
Checkpoint D is practical lane proved: rewrite holds, classification holds, cleanup
judged separately if strict cleanup remains unstable, and summary judged separately if
weaker. Checkpoint E is operating loop proved: lane is named before the batch, exact
output is read, pass continues without extra debate, failures are classified once, stop
gates create clean decisions, and status summaries make the current state easy to
recover.

This supports the theory because each checkpoint has a proof shape. It does not rely on
general confidence. It asks what was tested, what passed, what failed, and what should
stop or continue.

## Full Six-Test Checkpoint Suite

The unified handoff records a full six-test checkpoint suite with overall result PASS.
All six required checkpoint tests passed.

Test 1 was Core loop. The file was checkpoint_core_001.txt. The expected output was
LOCALBOT_CORE_OK. The actual output was LOCALBOT_CORE_OK. The final state was found in
tasks\done. The verdict was PASS. The finding was that the core pending-to-done output
path worked.

Test 2 was Timeout / failure path. The first attempt was checkpoint_timeout_001.txt. The
first attempt result was not valid timeout proof because the model shortcut the giant
list output with ellipsis and completed. The controlled proof file was
checkpoint_timeout_002.txt. The temporary config change was WORKER_TIMEOUT_SECONDS=1.
The expected state was tasks\failed. The actual state was checkpoint_timeout_002.txt
found in tasks\failed. The config was restored afterward to MODEL_NAME=qwen2.5-coder:3b,
WORKER_TIMEOUT_SECONDS=120, and RECOVER_RUNNING_TO_PENDING=1. The verdict was PASS. The
finding was that timeout/failure path worked and config was restored safely.

Test 3 was Recovery. The recovery signal observed was RECOVERY
checkpoint_timeout_001.txt -> pending. The final state was checkpoint_timeout_001.txt
found in tasks\done. The verdict was PASS. The finding was that recovery restored a
running task to pending and the recovered task later completed cleanly.

Test 4 was Rewrite baseline. The file was checkpoint_rewrite_001.txt. The final state
was found in tasks\done. The output was: Check pending task files. Review completed task
files. Inspect failed task files. Read the newest output files. Watch the coordinator
log. The verdict was PASS. The finding was that rewrite baseline held.

Test 5 was Classification baseline. The file was checkpoint_classify_001.txt. The
expected output was done. The actual output was done. The final state was found in
tasks\done. The verdict was PASS. The finding was that exact-label classification held.

Test 6 was Cleanup baseline. The file was checkpoint_cleanup_001.txt. The expected
output was: Check pending tasks now. Review done tasks. Inspect failed tasks. Read new
outputs now. Watch coordinator.log. The actual output was: Check pending tasks now.
Review done tasks. Inspect failed tasks. Read new outputs now. Watch coordinator.log.
The final state was found in tasks\done. The verdict was PASS. The finding was that
cleanup baseline held with all required checks together.

This six-test suite is one of the strongest evidence blocks in the project. It proves
the core loop, timeout/failure path, recovery, rewrite baseline, classification
baseline, and cleanup baseline.

## Post-Checkpoint Read

The post-checkpoint read states that LocalBot has a full six-test checkpoint pass and
that the system is healthy. The strongest baselines are core loop: checkpoint_core_001,
timeout: checkpoint_timeout_002, recovery: checkpoint_timeout_001 recovery path,
rewrite: checkpoint_rewrite_001 and practical_154, classification:
checkpoint_classify_001 and practical_155, and cleanup: checkpoint_cleanup_001 and
practical_163. No lasting code, config, model, or architecture changes were made.

This supports the theory because proof did not require uncontrolled mutation. A
temporary timeout change was used for proof, then restored.

## Practical Baselines

The recent practical baselines were rewrite practical_154 with PASS and a clean 5-line
rewrite, classification practical_155 with PASS and exact output done, and cleanup
practical_163 with PASS and all cleanup checks hit together.

The cleanup target output was: Check pending tasks now. Review done tasks. Inspect
failed tasks. Read new outputs now. Watch coordinator.log.

This evidence matters because it shows the machine moved beyond artificial startup tests
into practical output control.

## Cleanup Wave Chain Evidence

The cleanup wave chain recorded a failure-to-repair path rather than hiding the failed
attempts. practical_156 / Wave 1A was Failure 9 with merged lines. practical_157 / Wave
1B was partial because 5 lines held but coordinator.log changed. practical_158 / Wave 2A
was partial because coordinator.log held but comma missed. practical_159 / Wave 2B was
partial because comma was removed but now was dropped. practical_160 / Wave 3A was
partial because shape, now, and log held but punctuation missed. practical_161 / Wave 3B
was partial because shape, now, and log held but exclamations stayed. practical_162 /
Wave 4A was partial because punctuation and log held but comma stayed. practical_163 /
Wave 4B was PASS because all cleanup checks hit together.

The cleanup wave branch was closed. The record says not to extend it by momentum.

This directly supports “done is not pass” and “evidence before repair.” The project did
not call early movement success. It kept the failure path visible until all checks
passed together.

## Cleanup Prompt-Shape Wave Evidence

The cleanup prompt-shape wave from practical_177 to practical_187 identified copy-block
target-lock as the strongest confirmed cleanup prompt shape. The winning prompt shape
was to tell the model to output only the lines inside a COPY BLOCK, exclude the COPY
BLOCK markers, do not explain, do not rewrite, and return every required line.

The evidence was practical_177 / Wave 1A: Failure 9; practical_178 / Wave 1B: PASS;
practical_179 / Wave 2A: partial success; practical_180 / Wave 2B: workflow mistake /
invalid proof; practical_181 / Wave 2B Retry: PASS; practical_182 / Wave 3A: PASS;
practical_183 / Wave 3B: partial success; practical_184 / Wave 4A: partial success;
practical_185 / Wave 4B: partial success / incomplete output; practical_186 / Wave 5A:
PASS; and practical_187 / Wave 5B: PASS.

The decision was to use copy-block target-lock when exact cleanup output matters, not to
treat this as a reason to change code, config, model, or architecture, and to pause the
wave chain.

This supports the theory because it shows that the clean fix was better prompt
placement, not a system rebuild.

## Phase 4 Mini-Run and Log Evidence Path

The current save point for Phase 4 mini-run and log evidence path recorded that the
branch closed as PASS after repair, with freeform cleanup parked as a weak lane. The
best current finding was that copy-block target-lock remains the strongest confirmed
cleanup prompt shape when exact output matters. Freeform cleanup was not trustworthy for
exact capitalization and punctuation without further testing.

The evidence was practical_192: FAIL because blank lines appeared between otherwise
correct lines. practical_193: PASS with exact five-line repair and no blank lines.
practical_194: PASS with classification returned exactly done. practical_195: PASS with
rewrite returned five clean command-style sentences. practical_196: FAIL because
freeform cleanup kept lowercase starts and an unwanted comma. practical_197: PASS
because copy-block target-lock returned the exact approved cleaned output. The log
evidence route check was PASS after path correction, and the coordinator log is at
C:\LocalBot\logs\coordinator.log.

The decision was to use copy-block target-lock when exact cleanup output matters, park
freeform cleanup as a known weak lane unless deliberately reopened, and use
logs\coordinator.log for future coordinator log evidence from C:\LocalBot unless live
machine state proves a different path.

This supports multiple ideas: exact output needs clean placement, weak lanes should be
parked rather than pretended strong, log evidence matters, and path mistakes should be
corrected without rewriting the core.

## Phase 4 Practical Return Batch

The unified handoff records a Phase 4 practical return batch and repair evidence rule.
Classification practical_164 passed cleanly with exact output done. Cleanup reached a
pass at practical_170 after repair waves; the final output held five lines, correct
words, correct order, periods, no numbering, no bullets, no blank lines, and no
paragraph collapse. Rewrite reached a pass at practical_175 as a reset-baseline /
exact-output control; it held the target five-line output exactly.

The result pattern was that LocalBot runtime stayed healthy across the batch. The
coordinator claimed tasks, the worker ran, outputs were written, tasks landed in done,
and failed checks did not show failed task files. Classification remained stable.
Cleanup required repair but closed cleanly. Free rewrite remained fragile because recent
free-rewrite attempts showed numbering, wrapping, synonym drift, noun drift, and one
encoding/punctuation issue. Rewrite was strongest when source-tied tightly or
target-locked.

The decision was to lock the current practical batch progress: classification
practical_164 PASS, cleanup practical_170 PASS after repair, and rewrite practical_175
PASS as reset-baseline / exact-output control. The record kept the distinction that
reset-baseline rewrite pass does not prove broad free-rewrite stability. The Repair
Evidence Check Rule was added so future failed/partial repair waves must consider prior
evidence before the next repair.

This supports the theory because it distinguishes stable lanes from fragile lanes and
avoids turning one controlled pass into an overbroad claim.

## Normal Response Recheck Evidence

The final wrap note records that the run and wave record is clean only when written with
the repair sequence included. It says not to record the normal response suite as a
first-try full pass.

The correct final truth was: Core response passed directly. Classification passed
directly. Rewrite passed directly. Exact cleanup failed once because the output merged
physical lines. Exact cleanup repair passed with stricter physical-line wording. Final
normal response test verdict: PASS after repair.

The task record was normal_recheck_001_core: PASS; normal_recheck_002_classify: PASS;
normal_recheck_003_rewrite: PASS; normal_recheck_004_cleanup_exact: FAIL, line merge /
physical-line loss; and normal_recheck_005_cleanup_exact_repair: PASS.

The carry-forward rule was: for exact cleanup or exact multi-line output, require
physical lines explicitly. Use wording such as: Return exactly five physical output
lines. Each approved line must be on its own separate line. Do not merge lines together.
Do not wrap one approved line across two lines. Do not add blank lines.

The run evidence handling lesson was to read each output file separately, not smash
multiple output files together without separators, check done state and failed state
separately, use logs\coordinator.log for log evidence, and not treat tasks\done as
automatic PASS.

This is direct evidence for the core theory. Completion is not correctness. The record
includes the failed attempt instead of rewriting history.

## Final Closeout Evidence

The final LocalBot wrap / closeout state is dated 2026-05-04. Its status says LocalBot
Phase 4 is wrapped as a completed practical local AI task-loop core. The final closeout
verification was final_closeout_001 returning exactly LOCALBOT_PHASE4_CLOSEOUT_OK.

The final proven strengths were core loop, failure path, recovery, classification,
source-tied rewrite, exact cleanup by copy-block target-lock, and final closeout
verification.

The final parked / non-blocking items were freeform cleanup is weak, summary lane is
parked, long backlog behavior is unproven future work, Roblox / Studio expansion is a
separate future lane, and zero-byte junk files are cleanup-only, not system blockers.

The hard judgment was that LocalBot is done enough to stop building the core and that
more testing now is drift unless a new project lane is deliberately opened. The final
order was wrap LocalBot, save the final project state, and clean folder/file clutter
last.

This is evidence that the project can close. It did not keep expanding to prove more by
momentum.

## Final Placement and Cleanup Evidence

The locked final state says LocalBot is wrapped, saved, placed, tested, and cleaned. The
final cleanup removed zero-byte junk command-name files from C:\LocalBot after
confirming them as zero bytes. The removed files were dir, powershell, py, python,
start, and type.

The final verification after cleanup recorded coordinator.py: PASS, worker.py: PASS,
config.txt: PASS, tasks: PASS, outputs: PASS, logs: PASS, and Handoff_Stack: PASS.

The final judgment was that LocalBot runtime root is correct, the handoff stack is
placed, the normal response test passed after repair, final closeout passed, root junk
files are removed, and no further testing is needed unless a new lane is deliberately
opened.

This supports the theory because clutter was treated as cleanup-only, not as a core
failure. The proof object remained intact.

## Open Issues and Parked Items

The open issues file says current system issue status is no active system issue. It says
the full six-test checkpoint passed: core loop, timeout / failure path, recovery,
rewrite baseline, classification baseline, and cleanup baseline. It says open project /
documentation issues are none in the current cleanup set.

The final closeout open-issue read states that blocking open issues are none for
LocalBot core closeout. Parked / non-blocking items are freeform cleanup is weak and
should not be trusted for exact output, summary lane is parked unless deliberately
reopened, long backlog behavior is not checkpoint-proven, zero-byte junk files in
C:\LocalBot are cleanup-only and not a system blocker, and Roblox / Studio expansion is
separate future work. The closeout judgment says these items do not block final LocalBot
core wrap.

This is evidence for honest limits. The project does not inflate unproven features into
proven claims.

## Whole-Project Judgment

The proof-safe whole-project judgment says LocalBot is a strong completed core for a
small local AI task-loop system. It is proven live by the six-test checkpoint: core loop
passed, timeout / failure path passed, recovery passed, rewrite baseline passed,
classification baseline passed, and cleanup baseline passed.

The important distinction is that system completion and output correctness are not the
same thing. A completed task is only a true pass when the loop completes cleanly and all
required output checks hit together. Completed-but-wrong outputs remain Failure 9,
partial, failed, or invalid proof.

The project comparison says LocalBot is stronger than many hobby AI bots because it is
narrow, inspectable, recoverable, and not overbuilt. It is not a production fleet, cloud
service, or autonomous multi-agent system. Its strength is controlled local execution on
one Windows PC.

The design judgment says LocalBot is stable as a personal local AI core and safe to
build from as long as the clean architecture is protected. Human review is still
required for model output quality. Prompt/task fit remains the main practical
limitation, not loop survival.

This supports the theory because the judgment is proof-safe. It names strengths without
pretending the system is something it is not.

## Proof of Done Is Not Pass

The clearest evidence for “done is not pass” appears in the six-test checkpoint, cleanup
waves, and normal response recheck. Test 1 proved that a task can land in tasks\done
with expected and actual output matching. Test 2 also showed that an initial timeout
attempt was not valid timeout proof because the model shortcut the giant list output
with ellipsis and completed. That result was not treated as proof. A controlled timeout
file and temporary timeout setting were used instead.

The normal response recheck also proves the doctrine directly. Core, classification, and
rewrite passed directly, but exact cleanup failed once because physical lines merged.
The record says not to record the normal response suite as a first-try full pass. The
final result was PASS after repair, not PASS by ignoring the failed attempt.

This is the theory operating in practice: done is movement, pass is judgment.

## Proof of Evidence Before Repair

The evidence-before-repair principle appears in the checkpoint process, run evidence
handling, repair waves, and log path correction. The project preserved exact task
numbers, expected outputs, actual outputs, verdicts, failures, and repair outcomes. It
distinguished Failure 9, partial success, workflow mistake / invalid proof, and PASS. It
recorded that output files should be read separately, done and failed state should be
checked separately, and logs\coordinator.log should be used for log evidence.

Recovery proof also supports evidence-before-repair. The recovery signal RECOVERY
checkpoint_timeout_001.txt -> pending was recorded, and the recovered task later
completed cleanly. The system did not erase the running-state issue; it captured the
recovery path.

## Proof of Mission Lock

Mission Lock is supported by repeated records that no code, config, model, checkpoint,
runtime architecture, or real phase change was made during documentation/control saves.
The project kept Phase 4 practical work separate from Studio, Roblox, automation,
memory, brain, planner, and backlog testing unless deliberately chosen.

The open issues and reference parking files kept future ideas parked instead of active.
Parked items included summary lane, long backlog behavior, freeform cleanup, Roblox /
Studio expansion, autonomous Studio control, workspace agent behavior, multi-agent or
large AI-helper systems, and deep tree/editor-bot model.

This supports the theory because the project preserved useful future ideas without
letting them hijack the current core.

## Proof of Patch Balance

Patch Balance is supported by the way cleanup and governance rules were added, reviewed,
consolidated, and sometimes stopped from growing further. The unified handoff records
that the user noticed the governance rule list was growing and paused to prevent drift.
The correct direction was consolidation, not more scattered rules.

The open issues file lists many resolved cleanup items that were placed into the correct
handoff stack areas, including Phase 4 practical protection rules, Over-Cleaning Stop
Rule, Detailed Report Rule, Proof Symbol Rule, Symbol Integrity, Direction Mismatch
Yield Rule, Cleanup Auto-Roll Rule, Rule-Fix Auto-Roll Rule, Open Issues File Shape,
Save Roadmap / Legend decision, Whole-Project Judgment Report cleanup, Governance
Placement, Save Report Summary Behavior, Search for Loose Ends Before Save,
Evidence-Based Percent Behavior, Fix-Issues Screen Behavior, No Images / Text-Only Rule,
Placement-Uncertainty Yield Rule, Save screen style with Yielded / Open Issues before
Files, Action Safety Gates, Operator terms and official lock wording, Rule Approval and
Execution Order, Save/File Output Gate wording clarification, Full Stack Audit Before
Lock or Save, Screens and Lists Registry, No Loose Ends / Section Closure,
Future-Binding Resolver, Repeated Issue / Loop Closure, Review Screen Box Rule,
Saved-stack cleanup retry wording pass, Resolved-check suppression / no looping review
rule, Review Gate Screen reference removed / undefined screen cleanup, Control Layer /
Support Layer cleanup pattern, Rule Wording Normalization Rule, Sequential Rule Lock
Rule, Status Screen required progress meter, Status Screen square-block inline-code
meter style, Status Screen minimal underscore divider style, Global Screen Style Rule,
Next on the Plate Detail Rule, Repair Evidence Check Rule, Stacked Wave Evidence Review
Rule, Lock vs Save Terminology Rule, Active filename style / auto-version suffix rule
retired, Free-Rewrite Lane Caution Rule, Command Paste Discipline Rule, Rule Lock Impact
Review Rule / Real Negative Impact Only update, Unsaved Locked-Changes Reminder Rule,
Boot Screen Routing / gate-stack cleanup, and Slash Help Command Screen / slash-command
orientation shortcut.

This supports the theory because the project did not treat new rules as automatically
clean. It created rules to prevent drift, then also created anti-overcleaning and
placement rules to prevent rules from becoming drift.

## Proof of Truth-Bound Editing

The master handoff records the Truth-Bound Editing Rule. The rule says that when
editing, adding, moving, saving, or rewriting any LocalBot project file text, every
added or changed sentence should be treated as future instruction material. Before
saving wording, it must be checked against live machine evidence, the user’s current
approved decision, LOCALBOT_MASTER_HANDOFF, proven checkpoint evidence, an existing
active project file, or clearly labeled parked, optional, future, or reference status.
Guesses, preferences, future ideas, and unproven plans should not be written as active
truth. If uncertain, wording should be labeled recommendation, optional, parked, future,
reference, or needs review. If wording could give a lower-authority file too much
control, pause and fix it before saving.

This supports Recursive Core Architecture because it shows that documents themselves can
become control surfaces. The project treated wording as a future instruction material,
not harmless decoration.

## Proof of Name, Root, and File Hygiene

The roadmap, file index, file integrity file, and rule library all preserve
root-reference and clean filename behavior. Project files should be referenced by root
role/name, not exact version filenames. Stable roots include LOCALBOT_MASTER_HANDOFF,
LOCALBOT_BASE_AND_CORE_BUILD_ROADMAP, LOCALBOT_STUDIO_RULE_LIBRARY,
LOCALBOT_UNIFIED_HANDOFF, LOCALBOT_CHECKPOINT, LOCALBOT_STUDIO_FILE_INDEX,
LOCALBOT_STUDIO_FILE_INTEGRITY, LOCALBOT_STUDIO_VALIDATOR_RULES,
LOCALBOT_STUDIO_REFERENCE_PARKING, LOCALBOT_PHASES, and LOCALBOT_STUDIO_PHASES.

The root lookup rule says to search by root name first, treat the newest clean version
of that root as active, ignore old versions unless reviewing history, and treat
duplicate download suffixes such as “(1)” or “(2)” as cleanup issues. Active project
files should use clean root filenames unless the user explicitly asks for another naming
style. Internal file text should use root names only.

This supports the “names are compression keys” idea. Clean names prevent stale internal
links, false missing-file errors, version confusion, and accidental authority drift.

## Proof of File Role Separation

The file integrity file defines file roles. Master handoff is for active identity,
scope, and top authority. Rule library is for hierarchy, command chain, octagon/symbol
ledger, checkpoint command, and collision rules. Phases is for lifecycle status only.
Checkpoint is for fast current-state read and checkpoint procedure. Validator is for
helper AI checks only. Reference parking is for parked old/future ideas only. File
integrity is for naming, versioning, placement, and cleanup.

This supports clean placement because each file has one job. A file with one job is less
likely to become a junk drawer or hidden authority source.

## Proof of Whole-System Route Closure

The Studio rule library defines a whole-system route closure pattern. Every project
route should have an open trigger or reason, next immediate action, loop
repair/check/retry path if needed, pass close condition, stop hard-stop condition, park
condition if the route is not active, and documentation location if the result changes
project truth. If a rule, file, lane, or task has no close condition, the wording should
be fixed before the system expands.

The bottom-to-top route map is file roots and versions first, then one task through
coordinator and exact output read, then result judgment, then repair if needed, then
hard stop total evaluation, then documentation, then expansion only after the smaller
route is stable.

This supports the theory because it gives a concrete operating order for preventing
open-ended drift.

## Proof of Human Verification and Validator Boundary

The Studio validator rules define a strict role split. The builder creates the answer,
simple Luau, corrected script, or edit steps. The validator checks whether the builder
stayed inside the rules and gives PASS, FAIL, or INVALID_VALIDATOR_REPORT. The validator
does not redesign. The owner is the user, who has final authority on direction.

PASS means no failed rule was found and the answer can be used. FAIL means one exact
failed rule was found, the validator names that rule, explains why in one plain
sentence, and gives one direct fix. INVALID_VALIDATOR_REPORT means the validator said
FAIL without naming the exact failed rule, gave a middle-ground report, contradicted
itself, redesigned or expanded the answer, or acted like a builder instead of a checker.

The validator file rejects middle-ground reports such as mostly passed, failed but
covered the points, acceptable but failed, pass with concerns, probably okay, and
partial pass. If the validator cannot name the exact failed rule, the validator report
is invalid.

This supports the human-verification claim and prevents helper AI from becoming a hidden
boss. The validator is a gate/check, not a hub. It must not become the project.

## Proof of Parked Ideas and Controlled Promotion

The Studio reference parking file exists to preserve old overbuilt/future ideas without
letting them control V1. It says the file is not a trash file; it is where useful but
non-active ideas live.

Parked ideas include the Roblox work-order builder pipeline, manifest/compiler approach,
autonomous Studio control, workspace agent behavior, multi-agent or large AI-helper
systems, and deep tree/editor-bot model. The status of these ideas is reference only,
later-only, not active, or future design inspiration only.

Parked ideas may explain why a choice was made, provide future options, help recover old
context, and inspire later design after V1 proves useful. Parked ideas must not override
active Studio V1 rules, force manifest/generator work, restart large architecture, turn
simple tasks into systems, or contradict the user’s current direction.

The promotion rule says a parked idea can become active only if the user explicitly asks
to reopen it, the active master/rule library is updated, the checkpoint records why it
was promoted, and the change stays clear and intentional.

This directly supports controlled promotion. Future ideas are preserved, but they cannot
silently become active.

## Proof of Octagon / 8-Gate Route Discipline

The octagon route model file preserves the octagon / 8-gate / sector route-model idea as
detailed future LocalBot reference material without making it an active LocalBot
pathway. Its current status is reference only, future LocalBot idea only, no active
pathway, no hidden pathway, no backdoor, no automatic escalation, no bypass of user
control, not active command behavior, not active route logic, not active runtime
behavior, not a replacement for LOCALBOT_MASTER_HANDOFF, and not a runtime, model,
config, checkpoint, or phase change.

This is important evidence because it shows the system can preserve a large future idea
without accidentally activating it.

The useful future value of the octagon model is bounded movement, visible route logic,
named gate checks, clear sectors/homes, yield as a brake, explicit stop points, no route
expansion by momentum, and future design memory without active control drift.

The core idea is that a normal assistant may start with “save this” and then widen into
deciding file placement, rewriting rules, updating roadmap, updating checkpoint,
creating a new control process, explaining a theory, or promoting future behavior. The
octagon idea says not to let the route keep widening. A risky route should move through
known sides/gates only. If it reaches something outside the allowed shape, it yields
instead of inventing a new side.

This supports the claim that the route is safer when its allowed movement is smaller
than its imagination.

## The 8-Gate Map

The possible 8-gate map contains command_recognized, current_state, permission,
file_ownership, placement, conflict, evidence_present, and output_authorized.

command_recognized confirms what the user actually asked for. current_state checks what
state the project is currently in before acting. permission confirms the user gave
enough permission for the kind of action being taken. file_ownership identifies which
file owns the content. placement checks whether content is placed in the right part of
the stack. conflict checks whether action conflicts with active rules, scope, file
roles, or the user’s current decision. evidence_present checks whether action is backed
by evidence or only attractive theory. output_authorized checks whether the output being
created is authorized and safe to deliver.

This supports Recursive Core Architecture by turning vague caution into visible route
shape.

## Route Contract Shape

The small route contract shape is target home, named check set, allowed results, bridge
allowed yes/no, and result conditions. The working rule is that a route contract must
make a route narrower, not more descriptive. If the contract starts sounding smarter
than the route itself, trim it. If the route needs more checks than its named set
allows, yield it. If the route is simple, do not wrap it in contract language just to
make it look organized.

The selective use rule says the route contract model is a high-risk-route tool, not a
whole-project operating law. Good candidates include save, audit, rule/control changes,
file output, and future Studio lane only if deliberately reopened. It should not be
forced onto help, status, ordinary chat, normal practical rewrite, normal cleanup,
normal classification, or anything simple where the contract is bigger than the work.

This supports Patch Balance because the model itself is controlled. It is not allowed to
become ceremony.

## Octagon Trim, Park, and Kill Criteria

The octagon reference defines trim, park, and kill criteria. Trim if the contract sounds
smarter than the route, the file starts creating ceremony, terms make active work harder
to understand, the model pressures the master handoff, or a simple task starts needing
control language to feel valid. Park if the idea is interesting but unproven, belongs to
future LocalBot, would add overhead now, or is not needed for current practical work.
Kill as active behavior if it creates hidden pathways, weakens user control, blurs
authority, makes LocalBot feel like a control machine, or creates more confusion than
safety.

This supports the theory because even control structures must remain bounded and
testable.

## Save Note Evidence

SAVE_NOTE records the saved-stack folder LOCALBOT_SAVED_STACK_2026-05-04 and says the
saved-stack changes included LOCALBOT_HIGH_RISK_ROUTE_CONTRACTS as an experimental
support file, LOCALBOT_OCTAGON_ROUTE_MODEL_REFERENCE as a visible future-reference file,
LOCALBOT_STUDIO_FILE_INDEX recording support/reference file roles,
LOCALBOT_BASE_AND_CORE_BUILD_ROADMAP recording parked/experimental control-model
references and Truth-Bound Editing Rule, LOCALBOT_MASTER_HANDOFF recording active
safety/editing/run gates, LOCALBOT_PHASES recording no real phase change and warning not
to pre-build future phase-rule structures, LOCALBOT_UNIFIED_HANDOFF recording decision
history, and LOCALBOT_STUDIO_RULE_LIBRARY recording the supporting Planned Wave Packet
Rule.

The same save note records that no code, config, model, checkpoint, runtime
architecture, or real phase change was made. This supports the distinction between
documentation/control-process cleanup and runtime mutation.

## Evidence of No Active System Issue

The open issues file states current system issue status: no active system issue. It
states full 6-test checkpoint passed and says passed checkpoint items should not be
listed as open issues. It states open project / documentation issues: none in the
current cleanup set.

This supports clean closure. The project does not carry solved items as active problems.

## Evidence of Honest Limits

The project explicitly lists unproven or parked areas. Long task-list / backlog behavior
is not checkpoint-proven and should not be called proven until checkpoint-tested.
Summary lane is known weaker and parked unless deliberately reopened. Freeform cleanup
is known weak from practical_196 and should not be trusted for exact output. Roblox /
Studio expansion is separate future work. Broad open-ended tasks and long reasoning
tasks require human review. LocalBot should not be treated as fully autonomous.

This supports the claim ledger. The system does not use confident language to turn
untested capability into fact.

## Evidence of Practical Safety

The whole-project judgment says LocalBot is unlikely to crash the PC in normal use
because it uses a small local one-worker pattern, timeout handling, and a file-based
task lifecycle. The bigger practical risk is wrong or shape-broken model output, not
system survival.

This supports the architecture decision to focus on output control and prompt/task fit
instead of rebuilding the core.

## Evidence of Correct Failure Classification

The roadmap distinguishes system problems, prompt/output problems, and workflow/operator
problems. System problem examples include task never claimed, worker never launched,
coordinator hangs, timeout path fails, recovery fails, and file movement breaks.
Prompt/output problem examples include numbering appears, output collapses into one
line, summary drifts from source, punctuation cleanup collides, label choice is wrong
even though the loop worked. Workflow/operator problem examples include task text pasted
into Command Prompt instead of Notepad, two commands mashed together, and wrong output
file read back.

This supports the theory because each failure type needs a different repair. The project
specifically warns not to solve prompt mistakes with system redesign.

## Evidence of Closed-Loop Roadmap Cycle

The roadmap’s closed-loop cycle is to choose the active lane, define why this lane is
being run, run the planned batch, judge each result, classify any failure once, repair
or reset only when needed, stop at the batch gate, record the decision, choose the next
lane or pause, and show a short milestone/status summary when a gate is reached.

The loop rule says pass equals continue to the next planned run, failure equals classify
once then repair or review, two bad repairs equals compare the run chain, choose the
best candidate, then reset or enter a comparison wave, and batch gate equals decide
whether to lock, continue, enter a comparison wave, switch lanes, or update docs.

This supports the theory because work is not allowed to drift indefinitely. Every route
has a loop, a stop condition, and a decision.

## Evidence of No Loose Ends

The master handoff contains a No Loose Ends / Section Closure rule. It says never call a
cleanup, screen, list, rule section, save, or file pass clean while loose ends remain.
Loose ends must be closed, parked, reported, or brought to the user. Every major rule
section must include or inherit trigger, action, owner/location, stop/next, and close
condition.

This supports the Recursive Core principle that a system should not scale open loops.

## Evidence of Information Overflow Control

The master handoff contains an Information Overflow / Split Gate. When rules, terms,
menu items, notes, or other information grow too large and start bleeding into unrelated
areas, the system should check whether content needs to be split, moved, merged,
summarized, or parked. A new list, section, or file should exist only when it reduces
confusion and has a clean purpose, correct role, respectful name, and no duplicate job.

This supports the theory because dirty compression is treated as a real problem.
Information must be placed, not just accumulated.

## Evidence of Future-Binding Resolver

The master handoff contains a Future-Binding Resolver. When an old rule and a newer
locked rule could fight, it says not to guess. It says to identify both rules, identify
which one is active, older, parked, duplicate, unclear, superseded, or newly locked,
apply authority order, check architecture fit, check file/root/version status, and
report the conflict before acting. If the winner is unclear, ask the user.

This supports the theory because old instructions can contaminate future behavior unless
conflicts are surfaced.

## Evidence of Repeated Issue / Loop Closure

The master handoff contains Repeated Issue / Loop Closure. When the same issue appears
again after it has already been judged, do not keep re-reporting it as fresh. Check
whether it is already locked, parked, assigned to future cleanup, blocked pending
file-output approval, resolved, or superseded. If it is already decided but still
physically present, label it as Known / Decided — cleanup pending. Do not restart the
same debate unless new evidence changes the issue.

This supports the theory because repeated issues can become loops. A clean system must
know whether an issue is new, active, parked, or already decided.

## Evidence of Text-Only Control

The master handoff and support files repeatedly state that LocalBot rule, report, issue,
save, live-run, screen, and handoff work should use text only. Diagrams should use
ASCII, markdown, or PlantUML-style text. Image wheels, decorative graphics, generated
images, and visual progress graphics are not part of control evidence.

This supports the proof package because the evidence remains searchable, copyable,
versionable, and suitable for GitHub.

## Evidence of File Integrity and Version Hygiene

The file integrity file states the core principle: everything has a place for a reason,
and everything should stay in its place. It calls for clear names, clear order, one file
role at a time, no clutter, no robotic process piles, and no unnecessary duplicate rule
dumps.

It warns not to overwrite old files casually. Old LocalBot files are preserved as
history/reference unless the user explicitly asks otherwise. New files are justified
only when an important rule area needs its own home, keeping it inside another file
would create clutter, splitting prevents rule collisions, or AI needs one clear place to
read a rule family. A new file is not justified when the material already has a proper
home, is only a temporary thought, duplicates another file, or exists only to look
complete.

This supports clean architecture because file changes are treated as architectural
changes, not casual edits.

## Evidence of Studio Support Boundary

The Studio file index records that old LocalBot is preserved as reference/history, the
working core loop remains respected, and advanced Roblox builder/manifest ideas are
parked unless deliberately reopened. The LocalBot current operating stack is a small
local AI task loop on Windows PC with Python + Ollama.

The support-file parking rule says Studio-named support files can remain in the stack
for later Studio/Luau helper use. They are not an active blocker for core LocalBot Phase
4 text runs unless the user deliberately opens the Studio lane. When the Studio lane is
opened, define goal, allowed actions, forbidden actions, acceptance test, and stop
point.

This supports Mission Lock and controlled promotion. Studio material exists, but it does
not control the core unless deliberately reopened.

## Evidence of Reference Parking

The reference parking file says useful but non-active ideas live there. It says parked
ideas may explain why a choice was made, provide future options, help recover old
context, and inspire later design after V1 proves useful. They must not override active
Studio V1 rules, force manifest/generator work, restart large architecture, turn simple
tasks into systems, or contradict the current direction.

This supports Recursive Core Architecture because it preserves creativity without
letting it invade active execution.

## Evidence of High-Risk Route Contract Boundary

SAVE_NOTE records that LOCALBOT_HIGH_RISK_ROUTE_CONTRACTS exists as an experimental
support file for high-risk route contracts. The octagon reference says the smaller
active-test shape is that screen presents, route owns behavior, route owns a tiny
contract, route uses only named checks, and route returns close/reset, dispatch, or
yield.

The save-worthy minimum preserved for future promotion is that LocalBot stays simple by
default. Use route contracts only on high-risk routes where tighter control clearly
improves safety. A screen may present choices, context, or status, but the route owns
behavior. Each approved high-risk route may carry a small contract defining target home,
named check set, allowed results, bridge allowed yes/no, and result conditions. A route
may use only its named check set. If more checking is needed, yield instead of expanding
mid-route. Route results are limited to close/reset, dispatch, and yield. Bridge is
special-case only. Save Point reviews yielded or unresolved items later.

This supports controlled bridges, scoped authority, and no hidden expansion.

## Evidence That Documentation Did Not Change Runtime

Multiple decision reports state that governance cleanup, handoff/rule cleanup,
saved-stack cleanup, loose-end cleanup, control-layer cleanup, file-output wording
clarification, screen-style cleanup, truth-bound editing, full-wave clarification, and
octagon/reference saves were documentation or control-process cleanup only. They were
not code, config, model, checkpoint, runtime architecture, or real phase changes.

This supports the distinction between control-document changes and machine changes. The
project did not pretend that documentation saves were runtime proof.

## Evidence That the Core Should Stop Growing

The final wrap note states: LocalBot is done enough to stop building the core. More
testing now is drift unless a new project lane is deliberately opened. It also says not
to continue building the LocalBot core by momentum. The core is complete.

This supports a major Recursive Core Architecture idea: a clean system must know when to
close. Endless improvement can become drift.

## Evidence Mapping to Recursive Core Architecture Ideas

The idea “AI drift comes from unplaced intelligence” is supported by LocalBot’s use of
named files, named folders, named lanes, defined file roles, validator/builder/user role
split, and route contract boundaries.

The idea “done is not pass” is supported by the checkpoint suite, the timeout
first-attempt invalid proof, the cleanup wave chain, the normal_recheck_004 failure, and
the rule that tasks\done is not automatic PASS.

The idea “names are compression keys” is supported by root filename rules, file role
rules, stable root names, version hygiene, and the avoidance of vague or duplicate file
roles.

The idea “mission lock prevents rocketship drift” is supported by parked
Studio/Roblox/automation/memory/brain/planner/backlog lanes, Phase 4 practical scope,
and the final closeout instruction not to keep building by momentum.

The idea “evidence must come before repair” is supported by expected/actual outputs,
task IDs, verdicts, log evidence, recovery signal, and repair wave records.

The idea “every patch changes pressure” is supported by governance cleanup,
Over-Cleaning Stop Rule, truth-bound editing, and consolidation instead of scattered
rule growth.

The idea “scaling multiplies the seed” is supported by the decision to keep LocalBot
small, file-based, one-task-at-a-time, and proven before expansion.

The idea “growth must happen through promotion, not blind copying” is supported by
parked ideas requiring explicit reopening, active master/rule library update, checkpoint
record, and intentional promotion.

The idea “controlled bridges prevent contamination” is supported by the octagon model,
route contracts, bridge special-case handling, and the rule that everything should not
touch everything.

The idea “humans should verify important things” is supported by user final authority,
human judgment in the LocalBot identity, validator as checker only, and human review
required for model output quality.

## Formal Evidence Conclusion

The LocalBot project files support Recursive Core Architecture at the seed level. They
show a small AI task loop with a visible runtime structure, known configuration,
file-based state, timeout handling, recovery, output files, logs, baseline tests, repair
waves, final closeout, parked limitations, and controlled future-reference material.

The evidence does not prove that AI becomes perfect. It proves the stronger practical
point: AI failure can stop hiding. A completed task can be separated from a passed task.
A weak lane can be parked instead of exaggerated. A failed output can be repaired with
evidence instead of rewritten from memory. A future idea can be preserved without
becoming active. A helper can check without becoming the builder. A route can yield
instead of widening itself. A core can close instead of growing forever.

LocalBot is therefore useful evidence for the claim that the cure is not more
intelligence. The cure is clean placement of intelligence.

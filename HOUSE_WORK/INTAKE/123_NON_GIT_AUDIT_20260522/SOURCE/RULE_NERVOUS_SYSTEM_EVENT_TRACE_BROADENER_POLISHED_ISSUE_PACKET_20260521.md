# Rule Nervous System / Event Trace / Loophole Broadener
## Polished Issue Packet For Mule Deep Dive

Date: 2026-05-21
Prepared for: Clean Seed / Mr.Kleen
Current known house base before this downloadable packet: main @ fbfdba8
Status: POLISHED ISSUE PACKET / MULE DEEP-DIVE SOURCE / NOT HOUSE SAVE
Boundary: Not doctrine. Not runtime. Not dashboard. Not automation. Not ACTIVE_GUIDES. Not CURRENT_TRUTH_INDEX.

## 1. Purpose

This packet turns the draft discussion into a cleaner mule-ready issue file.

The target is not another pretty list. The target is a working repair architecture for proving whether rules actually fire, where they fail, how loopholes are closed, and when clear proved fixes must be saved and locked immediately.

Core sentence:

A rule is not alive because it exists in text. A rule is alive when its trigger is recognized, its fire is recorded, its result is proved, its loopholes are broadened, and its durable fix is saved/locked when proof is already in the pudding.

## 2. Core Problem

Mr.Kleen keeps finding useful fixes, but the fix does not always become live locked behavior.

Pattern:
1. A failure happens.
2. A fix becomes obvious.
3. The assistant names the fix.
4. The assistant may use the fix once.
5. But the durable behavior is not always saved/locked.
6. The system can return to the same broken path later.

This is not only a knowledge problem. It is a rule-firing, rule-locking, traceability, and loophole-closure problem.

## 3. Recent Evidence / Failure Chain

### Desktop helper left behind
A temporary helper did the save, but remained on Desktop afterward.
Fix: Desktop is not a parking lane. Temporary helpers must self-clean, route into the house, or be explicitly kept.
Lesson: Clean repo is not enough if delivery leaves porch litter.

### Giant PowerShell paste continuation prompt
A huge pasted script left PowerShell at the continuation prompt.
Fix: for large/high-risk local work, use file-based helpers or smaller staged commands, not giant paste blocks.
Lesson: a known fix must be adopted into the live lane immediately.

### Backtick PowerShell parser failure
Markdown backticks inside PowerShell strings broke parsing.
Fix: generated PowerShell helpers should avoid Markdown backticks inside strings, use safer static text patterns, and preferably pass parser checks.
Lesson: helper quality needs a reusable safe template.

### Found fix not applied to live lane
The assistant identified the safer route but did not apply it strongly enough.
Fix: clear proved fix -> apply live -> save/lock durable rule now -> block return to broken route -> prove.
Lesson: "apply it to the live lane" is too weak unless save/lock is included for durable high-impact fixes.

### File requested, chat answer given
The user asked for a file and got a chat answer.
Fix: requested file/artifact delivery must create the file and provide the link.
Lesson: delivery-shape alarms are required.

### HNS packet weak process trace
The packet had good ideas but did not fully wear MTER, raw capture, grouping, rejection ledger, source-to-claim map, link map, and delta.
Fix: complex architecture packets require MTER + trace ledger + relation/source mapping.
Lesson: polished synthesis can hide weak process mounting.

### Mule diagnosis needs repair candidates
The mule should not only diagnose.
Fix: mule output must include candidate fixes, proof needed, blocked moves, save/lock candidates, and what the house must decide.
Lesson: support means bounded repair intelligence, not passive diagnosis.

### Link map underbuilt
Rules and concepts were created without enough relation mapping.
Fix: high-impact rules need link maps: lane, trigger, proof, parent/child/sibling/neighbor, overlap/replacement, stale/decay.
Lesson: without relation maps, the house grows haunted.

## 4. The Five Needed Organs

1. Clear Proved Fix Save/Lock Rule
2. All-Bases Rule Broadener
3. Triggered/Fired Event Trace Ledger
4. Mule Repair Intelligence Standard
5. Link Map / Anti-Haunting Map

These support the House Nervous System / Alarm-Debugger Mesh. They do not install a dashboard/runtime/automation.

## 5. Organ 1 - Clear Proved Fix Save/Lock Rule

Strong rule:

WHEN a clear proved fix is found in a live lane,
IF the fix is durable, recurring, or high-impact,
THE ASSISTANT SHALL apply the fix to the active route, save/lock the rule, prove the save, block return to the known-broken route, and update event/link records,
UNLESS authority/proof/boundary shows the fix does not fit.

Required firing:
- apply the fix to the live workflow now;
- save/lock durable behavior if recurring or high-impact;
- block return to known-broken route;
- record proof;
- record trigger -> fire -> proof event;
- update link map if related lanes are touched.

Blocked loopholes:
- do not merely describe the fix;
- do not apply it only in chat;
- do not use it once but fail to lock it;
- do not save without proof;
- do not prove without routing/linking;
- do not continue using the known-broken route;
- do not hide behind "needs test" when failure and repair already proved the need;
- do not over-apply where authority/proof/boundary says it does not fit.

## 6. Organ 2 - All-Bases Rule Broadener

Definition:

The All-Bases Rule Broadener takes a narrow rule, concept, alarm, prompt, code requirement, or handoff instruction and broadens it across actors, actions, omissions, timing, scope, authority, proof, counterexamples, bypass paths, and decay conditions so the rule cannot be satisfied in wording while failing in behavior.

Broadening checks:
- WHO can fail: assistant, mule, helper script, memory, rule, file lane, handoff, outside source, status file, receipt, TODO, active anchor.
- WHAT can be skipped: apply, save, lock, prove, route, park, archive, delete, block, decay, report, link, classify.
- WHEN can it fail: too early, too late, after user catches it, once but not durably, after proof but before save, after save but before cleanup, after cleanup but before link map.
- WHERE can it leak: chat only, Desktop, 123, mule workshop, Work Shed, proof lane, source ore, ACTIVE_ANCHOR, status, public repo, local-only path.
- HOW can it fake compliance: says applied but not saved; saved but not proved; proved but not pushed; pushed but not clean; clean but not linked; helper works but leaves clutter; mule diagnoses but offers no fix.
- WHAT is the opposite failure: over-applying fix, permanent rule for one-off issue, deleting useful ore, alarm storm, blocking all motion.
- WHAT proves it: event trace, receipt, hash, commit, push, clean status, HEAD == origin/main, file presence, output lane, link map, live-use proof.
- WHAT decays: one-off workaround, temporary helper, stale handoff, weak signal, duplicate note, old alarm after repair.

Guideword pass:
NO/NOT, MORE, LESS, AS WELL AS, PART OF, OTHER THAN, REVERSE, EARLY, LATE, BEFORE, AFTER, TOO LONG, TOO SHORT.

Template:
RULE NAME:
NARROW VERSION:
BROADENED VERSION:
ACTORS COVERED:
ACTIONS COVERED:
OMISSIONS:
WRONG ACTIONS:
TIMING FAILURES:
SCOPE EDGES:
AUTHORITY:
PROOF:
LOOPHOLES CLOSED:
COUNTEREXAMPLES:
DECAY:
SAVE/LOCK CONDITION:

## 7. Organ 3 - Triggered/Fired Event Trace Ledger

Definition:

The ledger records what actually happened so the house can distinguish text from living behavior.

Event states:
- TRIGGERED: condition became relevant.
- FIRED: correct rule/alarm/action activated.
- DEAD NERVE: should have fired but did not.
- LATE FIRE: fired only after the user caught it.
- MISFIRE: wrong thing fired.
- OVERFIRE: fired too much or too broadly.
- FALSE FIRE: fired without threshold.
- BLOCKED CORRECTLY: stopped because authority/proof/boundary required it.
- SAVED/LOCKED: durable fix committed and proved.
- CHAT-ONLY: mentioned but not saved/locked.
- PARKED: useful but not active.
- DECAYED: no durable memory required.

Event schema:
EVENT ID:
RUN ID:
PARENT EVENT:
TIME:
ACTOR:
LANE:
SIGNAL:
SIGNAL SOURCE:
EXPECTED TRIGGER:
ACTUAL TRIGGER:
EXPECTED FIRE:
ACTUAL FIRE:
FIRE STATE:
RULE / NERVE / ALARM:
ROUTE TAKEN:
ACTION TAKEN:
SAVE/LOCK REQUIRED:
SAVE/LOCK DONE:
PROOF:
RESULT:
LOOPHOLE FOUND:
BROADENING NEEDED:
LINKS TO:
MEMORY OUTPUT:
DECAY DECISION:
NEXT EVENT:

## 8. Organ 4 - Mule Repair Intelligence Standard

The mule is support, not authority. But useful support must include repair intelligence, not only diagnosis.

Mule must return:
1. diagnosis;
2. root cause;
3. evidence;
4. triggered/fired analysis;
5. dead nerves;
6. candidate fixes;
7. recommended safest fix;
8. proof needed;
9. blocked moves;
10. what mule is not allowed to install;
11. what the house must decide;
12. link map changes;
13. source-to-claim map;
14. save/lock candidates;
15. missing files/questions if blocked.

Mule must not:
- install doctrine;
- rewrite ACTIVE_GUIDES;
- rewrite CURRENT_TRUTH_INDEX;
- create dashboard/runtime/automation;
- treat output as command;
- treat outside research as house proof;
- skip solution candidates;
- scatter outputs;
- mix old handoffs with current handoffs.

## 9. Organ 5 - Link Map / Anti-Haunting Map

Definition:

The Link Map records how high-impact rules, nerves, alarms, helpers, mule packets, receipts, and source patterns relate to lanes, triggers, proofs, neighbors, replacements, overlaps, stale conditions, and decay conditions.

Node schema:
NODE:
TYPE:
HOME LANE:
OWNER:
TRIGGER:
FIRES:
BLOCKS:
PROOF:
PARENT:
CHILDREN:
SIBLINGS:
NEIGHBORS:
REPLACES:
OVERLAPS:
CONFLICTS WITH:
SOURCE EVENT:
RECEIPT:
STALE CONDITION:
DECAY CONDITION:
NEXT TEST:

Link classifications:
PARENT, CHILD, SIBLING, NEIGHBOR, REPLACEMENT, OVERLAP, CONFLICT, SUPPORT, PROOF, STALE, DECAY.

Anti-haunting rule:

Every high-impact rule/concept should have home lane, trigger, proof event, parent/child/sibling/neighbor links, overlap/replacement links, stale condition, and decay condition.

If not, it can become a ghost.

## 10. Poolrun Trace Harness

The poolrun should be a controlled test pool, not a dashboard.

Initial cases:
1. Desktop helper left behind.
2. Giant PowerShell paste continuation prompt.
3. Backtick PowerShell parser failure.
4. Found fix not applied to live lane.
5. File requested; chat answer given.
6. HNS packet had useful material but weak MTER trace.
7. Mule diagnosis lacked solution-candidate expectation.
8. Link map underbuilt.

For each case:
- name signal;
- name expected trigger;
- name expected fire;
- name actual fire;
- classify fire state;
- identify loophole;
- run All-Bases Broadener;
- propose fix candidate;
- decide save/lock needed;
- identify proof;
- update link map;
- record memory/decay.

Desired poolrun outputs:
POOLRUN_EVENT_TRACE_LEDGER.md
POOLRUN_DEAD_NERVE_REPORT.md
POOLRUN_LOOPHOLE_BROADENER_RESULTS.md
POOLRUN_FIX_CANDIDATES.md
POOLRUN_LINK_MAP_DELTA.md
POOLRUN_SAVE_LOCK_CANDIDATES.md
POOLRUN_BOUNDARY_AND_BLOCKED_MOVES.md

## 11. Research Concepts For Mule To Investigate

The mule should deep-search and adapt:
- STPA / unsafe control actions;
- HAZOP guidewords;
- EARS requirements syntax;
- property-based testing;
- event sourcing;
- OpenTelemetry traces/spans/events;
- CloudEvents event envelopes;
- W3C PROV provenance;
- OPA decision logs / policy audit logs;
- OpenLineage / data lineage;
- process mining / XES;
- FMEA;
- FRAM / work-as-done vs work-as-imagined;
- assurance cases / GSN;
- resilience engineering;
- observability / semantic conventions.

For each useful concept, map:
SOURCE / CONCEPT:
WHAT IT SAYS:
HOUSE PROBLEM IT HELPS:
ADAPTATION:
WHAT IT DOES NOT PROVE:
MISUSE RISK:

## 12. Immediate Candidate Set

Candidate later saves after review:
1. Clear Proved Fix Save/Lock Rule
2. All-Bases Rule Broadener
3. Triggered/Fired Event Trace Ledger
4. Mule Repair Intelligence Standard
5. Link Map Anti-Haunting Rule
6. Poolrun Trace Harness

Boundary:
No doctrine. No runtime. No dashboard. No automation. No ACTIVE_GUIDES. No CURRENT_TRUTH_INDEX. No mule-as-authority.

## 13. Final Clean Sentence

The house does not need more rules as text.

It needs rule life support:

trigger recognition, fire recording, loophole broadening, event tracing, relation mapping, and immediate save/lock when a clear proved fix is already in the pudding.

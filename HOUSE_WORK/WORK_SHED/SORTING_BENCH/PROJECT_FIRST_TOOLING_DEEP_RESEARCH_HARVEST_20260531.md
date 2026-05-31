# Project-First Tooling Deep Research Harvest

Date: 2026-05-31
Status: RESEARCH HARVEST / HOUSE FIT / NOT DOCTRINE
WorkKey: PROJECT-FIRST-TOOLING-DEEP-RESEARCH-HARVEST-20260531

## Center point

The project object comes first. Tools, scripts, helper methods, and shell mechanics are delivery layers. They are allowed to change, fail, improve, or be replaced, but they must not become the project object.

Current trigger:
- The Coding Room proof-chain save is the active object.
- The Claim Capability dirty set was saved cleanly first because it blocked the route.
- Recurrent PowerShell failures showed a lower-layer family: output-shape / binder / collection collapse.
- That tool-layer lesson matters, but it should be parked or lock-saved as support machinery without derailing the active project save.

## House translation

The house should treat tool failure as signal, not boss.

Correct order:
1. Name the project object.
2. Name the proof need.
3. Name the save/park route.
4. Adjust the delivery tool only enough to continue.
5. Capture reusable tool lessons after the object is safe.
6. Lock/save if mature; otherwise park with return trigger.

## Outside research harvest

### Systems engineering / configuration management

NIST SP 800-160 frames trustworthy systems as engineered systems with machine, physical, and human components, and emphasizes engineering discipline for complex, interconnected systems. House fit: Clean Seed should treat tools, rules, files, people, chat, and repo state as one socio-technical system, not isolated scripts.

NIST SP 800-128 treats configuration management as a formal discipline for controlling system changes. House fit: exact-file staging, dirty-state custody, proof receipts, and save-room decisions are configuration-control moves, not mere Git chores.

Adopted idea:
- Configuration-control gate: no save action unless the dirty state is known, classified, and either belongs to the current object or is saved/parked separately.

### SRE / operations

Google SRE material emphasizes postmortems, toil reduction, automation with care, and reliability measured by whether the system behaves as users expect. House fit: repeated tool failures should be converted into tool improvements only after the user-facing project route remains intact.

Adopted idea:
- Failure family review: recurrent failures get grouped into a named failure family and converted into one reusable guard, not patched as separate random bugs.

### Provenance / custody

W3C PROV defines a domain-agnostic model for provenance: entities, activities, agents, and relations. House fit: each file/save/run should say what entity was made, by what activity, from which evidence, under whose authority, and with what proof.

Adopted idea:
- Proof chain object: source evidence -> decision activity -> generated file -> receipt -> commit -> final state.

### Observability / traces

OpenTelemetry defines observability around telemetry signals such as traces, metrics, and logs. House fit: a helper run should not only say PASS/FAIL; it should emit trace-like rows showing route, tool, input, output, proof, and stop condition.

Adopted idea:
- Helper flight recorder: each helper run emits trace rows with object, route, proof pointer, warnings, blocker, and next condition.

### Formal methods / model checking

TLA+ and TLC are used to specify systems and check invariants over state changes. House fit: Clean Seed does not need full formal methods immediately, but it should steal the invariant idea: certain states are illegal no matter what script path is used.

Adopted invariants:
- No lock/save while repo dirty unless dirty set exactly matches current object.
- No direct save if Save Room has not approved.
- No helper promotion from one clean pass.
- No tool-layer repair may change the project object.
- No script may skip Code Gate after generated changes.
- No parked item without lane, return trigger, proof need, and intended future use.

### Property-based testing

Hypothesis describes property-based testing as checking properties over generated input ranges, including edge cases. House fit: helper scripts should have tiny local self-tests that exercise blank lines, scalar text, arrays, null-ish values, and path variants before touching real project files.

Adopted idea:
- Shape self-test bench: generated save scripts test output-shape invariants in a safe local report space before any Git write branch.

### Git staging semantics

Git status separates changes staged for commit, unstaged working tree changes, and untracked files. House fit: staging is not a cleanup action; it is a declared selection of files for a commit. Exact-file staging plus staged-set verification is the right house pattern.

Adopted idea:
- Staged-set court: after `git add`, compare staged paths against expected paths before commit.

### PowerShell parameter/binder behavior

PowerShell advanced parameter attributes include mechanisms such as AllowEmptyString and AllowEmptyCollection. The failure pattern here is not “PowerShell is bad”; it is that generated helper functions used parameter contracts that did not match document-writing reality.

Adopted idea:
- Delivery tools must normalize shape before binding when writing human documents.
- This is support machinery, not the project center.

## Unique rooms used

### Front Door Room

Question:
What is the current object?

Answer:
Coding Room proof-chain save remains the current object. Claim Capability was a blocking object that got saved cleanly first.

Rule:
Do not let a delivery tool become the front-door object.

### Evidence Court

Question:
What is proven?

Answer:
Claim Capability dirty set saved cleanly at commit `ea0df82254fa415cc0e7607ca1951cc1ec35819d`, `HEAD == origin/main`, final status clean. Coding Room proof-chain has Save Room approval and 12/12 proof rows but still needs final lock/save.

Rule:
Only proven state can unlock next state.

### Toolsmith Bench

Question:
What tool mechanism failed repeatedly?

Answer:
Output-shape / binder / collection shape collapsed in several forms:
- collection count shape failure,
- Git output char-index failure,
- Markdown/PowerShell string boundary failure,
- `[string[]]` / blank-line binding failure.

Rule:
Make a tool support card later, but do not derail active save.

### Save Room

Question:
What must be saved now?

Answer:
First finish the Coding Room proof-chain save. After that, save or park the tool lesson as a support rule.

Rule:
Project object first; tool lesson second.

### Parking Lot

Parked candidate:
Project-First Tooling / Shape Self-Test Bench.

Return trigger:
After Coding Room proof-chain lock/save reaches clean close.

Proof need:
One generated save script using the bench catches or normalizes blank lines, scalar strings, arrays, and null-ish content before Git write.

Intended future use:
All future generated save scripts and helper scripts that write markdown/report files.

## Recommended new tools

### 1. Project Object Front-Door Card

Purpose:
Before any helper/tool repair, name the active project object.

Fields:
- Active object
- Proof need
- Current blocker
- Blocker layer
- Allowed repair scope
- Forbidden drift
- Next unlock condition

### 2. Dirty-State Custody Court

Purpose:
When repo is dirty, classify dirty rows before staging anything.

Fields:
- dirty path
- status code
- family
- belongs_to_current_object
- expected/extra/missing
- save/park/defer decision

### 3. Save Room Decision Packet

Purpose:
A read-only decision packet that says whether save is allowed.

Fields:
- candidate proof rows
- expected file set
- missing rows
- extra dirty rows
- approval state
- next allowed action

### 4. Staged-Set Court

Purpose:
After staging, compare staged files to expected files.

Fields:
- expected set
- actual staged set
- missing staged
- extra staged
- verdict

### 5. Shape Self-Test Bench

Purpose:
Test generated writer/output helpers safely before real save branch.

Cases:
- blank line
- scalar string
- string array
- single-item array
- empty array
- null-ish input
- markdown with colon
- markdown with backtick
- path with spaces
- file already exists

### 6. Failure Family Ledger

Purpose:
When similar failures repeat, group them.

Fields:
- family name
- symptoms
- exact coordinates
- shared lower-layer cause
- project impact
- smallest guard
- return trigger
- lock/save/park state

### 7. Tool Adoption Gate

Purpose:
No tool becomes standard because it worked once.

States:
- raw idea
- candidate
- tested
- support rule
- active helper
- retired
- blocked

Required proof:
- at least one recent real run
- one edge-case self-test
- one rollback/blocked-path proof if relevant
- one receipt or report

### 8. Helper Flight Recorder

Purpose:
Make helper runs traceable.

Rows:
- run id
- active object
- helper/tool
- input proof
- output proof
- blocker
- warning
- next condition
- status

## Strongest new rule candidate

Project-First Tool Rule:

When a tool fails during a project save, do not chase the tool as the new project object. Name the active object, name the proof need, identify the tool-layer blocker, repair only the smallest delivery layer needed, finish or safely park the project object, then return to the tool lesson as a support candidate.

## Lock/save or park decision

Do not promote this directly into doctrine.

Recommended immediate parking:
- Lane: BRAIN_LEARNING + WORK_SHED/SORTING_BENCH + CHAT_COCKPIT
- State: PARKED SUPPORT CANDIDATE
- Return trigger: after Coding Room proof-chain save clean close
- Proof need: one tiny self-test bench catches the exact `[string[]]` blank-line failure before a Git write branch
- Future use: generated helper/save scripts

Recommended later lock/save files:
- `BRAIN_LEARNING/PROJECT_FIRST_TOOLING_RULE_20260531.md`
- `HOUSE_WORK/WORK_SHED/SORTING_BENCH/PROJECT_FIRST_TOOLING_RESEARCH_FIT_REPORT_20260531.md`
- `HOUSE_WORK/WORK_SHED/TEMPLATES/HELPER_SHAPE_SELFTEST_BENCH_TEMPLATE_V1_20260531.md`
- `HOUSE_WORK/CHAT_COCKPIT/PROJECT_FIRST_TOOLING_SUIT_CARD_20260531.md`
- `PROOF_HISTORY/PROJECT_FIRST_TOOLING_RULE_RECEIPT_20260531.txt`

## Next immediate route

1. Finish the Coding Room proof-chain save with the smallest writer-shape repair.
2. Confirm repo clean and `HEAD == origin/main`.
3. Then run a separate parking/lock-save for this Project-First Tooling candidate.

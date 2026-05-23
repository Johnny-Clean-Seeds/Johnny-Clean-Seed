# LAYOUT_CANDIDATE_LEDGER_EXPANDED_20260518

Status: **source / candidate layout ledger only**.  
This file is **not command authority**, not an install order, not a repair order, and not proof that any layout has been adopted.

Current active boss remains outside this file unless current authority says otherwise:
**Front Door / Authority Group link audit — map only; no repair, no edits, no commits, no reordering.**

---

## Why this file exists

The house already has a useful human metaphor: rooms, boards, benches, ledgers, red-tag areas, and maps. That layout is good for orientation, but a recursive system also needs layouts that prove:

- who starts the assistant
- which file owns authority
- which files only support
- how rooms link internally
- where proof lives
- what is blocked
- how old instructions are treated
- how TODO remembers without commanding
- how repair moves safely
- how history stays trustworthy

This ledger gathers layout models that may help now, soon, or later.

---

## Grouping method chosen

I used **Purpose-Boss Layout Grouping**.

That means each layout is grouped by the parent job it would do for the house, not by popularity or prettiness.

The parent jobs are:

1. Human orientation
2. Architecture zoom
3. Link proof
4. Room boundary
5. Process movement
6. Decision memory
7. Authority and responsibility
8. TODO and work control
9. Proof and evidence
10. Risk and failure control
11. Knowledge and source organization
12. Strategic evolution
13. Repo and implementation layout
14. Dashboard and runtime visibility

### Why this grouping method is best

A normal layout list asks:

> What diagram looks good?

The house needs a harder question:

> What parent boss does this layout serve?

This matters because a layout can become fog if it is not tied to a job. The house needs orientation, architecture, proof, authority, TODO control, and repair flow separated. Purpose-Boss grouping keeps layouts from competing blindly.

### Runner-up grouping methods

#### Pure affinity grouping
Good for clustering many ideas. Weak for deciding which group matters first.

#### C4-only grouping
Good for architecture diagrams. Too narrow for TODO boards, proof ledgers, and room behavior.

#### arc42-only grouping
Good for formal architecture documentation. Too heavy as the only layout system.

#### DSM-only grouping
Excellent for link proof. Too matrix-heavy for human orientation.

#### MoSCoW grouping
Useful for product priority, but dangerous here because “Must” can become fake command pressure.

#### Kanban-only grouping
Good for workflow. Too weak for authority/proof truth.

Final choice:

> Use Purpose-Boss grouping for the ledger. Use the best specific layout inside each boss group.

---

# 1. Human Orientation Layouts

These help a person or assistant understand where things live.

## 1.1 House / Workshop Map

Use when:
- onboarding an assistant
- explaining rooms
- locating source, proof, tools, TODO, or evidence
- deciding where new material belongs

Typical rooms:

```txt
Front Door
Tool Shed
Tool Crib
Toolbox Wall
Workbench
Map Wall
TODO Board
Design Table
Evidence Ledger
Lost and Found
Red Tag Room
Cleanup Closet
Public Window
Mule Dock
Quiet Watch Corner
```

Strength:
- easy to understand
- matches the existing house metaphor
- helps prevent random placement

Weakness:
- metaphor can hide authority boundaries
- not enough for proof
- not precise enough for machine validation

Best use:
- keep as the human-facing orientation layer

House rule:
```txt
House map shows where things live.
It does not prove authority by itself.
```

---

## 1.2 Orientation Trail Layout

A startup path layout.

Shape:

```txt
Start here
→ read this
→ then this
→ if doing local work, read this
→ if proof needed, go here
→ if blocked, stop here
```

Use for:
- README startup sequence
- assistant bootstrapping
- Front Door authority flow

Strength:
- prevents wandering
- makes entry order explicit

Weakness:
- stale if not maintained
- can conflict with active anchor if not linked

Best use:
- Front Door / Authority Group

---

## 1.3 Wayfinding Map

A map that answers:

```txt
I am trying to do X. Where do I go?
```

Example:

```txt
Need current active move? → ACTIVE_ANCHOR
Need orientation? → CURRENT_TRUTH_INDEX
Need local/Codex rules? → AGENTS
Need parked ideas? → SOURCE_ORE / PARKED
Need proof? → PROOF_HISTORY / RECEIPTS
Need TODO support? → HOUSE_WORK/TODO
```

Strength:
- practical
- reduces wrong-room usage

Weakness:
- can become outdated if room names change

Best use:
- README or house index

---

# 2. Architecture Zoom Layouts

These describe the system at different levels.

## 2.1 C4 Model

Shape:

```txt
C1: System Context
C2: Containers / major rooms
C3: Components inside a room
C4: Code/file/rule detail
```

Use for:
- whole-house diagrams
- front-door architecture
- TODO-room architecture
- proof engine architecture
- recursive system overview

Strength:
- prevents one giant unreadable diagram
- gives zoom levels
- works well with PlantUML

Weakness:
- does not by itself prove authority
- needs companion proof matrix

Best use:
- main architecture diagram method

House translation:

```txt
C1 = Clean Seed House in its environment
C2 = Front Door, TODO, System Links, Proof, Source Ore, Suit
C3 = files inside each room
C4 = exact field/rule/bit/gate detail
```

---

## 2.2 arc42 Drawer Layout

Shape:

```txt
1. Introduction and goals
2. Constraints
3. Context and scope
4. Solution strategy
5. Building block view
6. Runtime view
7. Deployment view
8. Cross-cutting concepts
9. Architecture decisions
10. Quality requirements
11. Risks and technical debt
12. Glossary
```

Use for:
- formal room specifications
- architecture design docs
- contractor-ready implementation docs

Strength:
- complete
- proven architecture-document structure
- separates concerns cleanly

Weakness:
- may be too heavy for small rooms

Best use:
- serious rooms only, not every small support file

House rule:
```txt
Use arc42 when a room becomes a system.
Do not use it for every note.
```

---

## 2.3 ISO 42010 Viewpoint / Concern Layout

Shape:

```txt
stakeholder → concern → viewpoint → view → consistency check
```

Use for:
- proving that a layout answers a real concern
- separating user concern, assistant concern, contractor concern, proof concern

Strength:
- mature architecture thinking
- stops diagrams from being decorative

Weakness:
- abstract if overused

Best use:
- high-level house architecture and room specs

House example:

```txt
Stakeholder: future assistant
Concern: where do I start?
Viewpoint: startup/orientation view
View: README → CTI → ACTIVE_ANCHOR → AGENTS
Consistency check: each file agrees on flow
```

---

## 2.4 4+1 View Model

Shape:

```txt
Logical view
Development view
Process view
Physical view
Scenarios
```

Use for:
- separating file structure, runtime behavior, process flow, and examples

Strength:
- balanced
- scenario-driven

Weakness:
- less natural than C4 for this house

Best use:
- if C4 feels too software-centric or too hierarchical

---

## 2.5 Zachman Framework

Shape:

```txt
What / How / Where / Who / When / Why
across levels of abstraction
```

Use for:
- exhaustive enterprise-style classification

Strength:
- broad and systematic

Weakness:
- too big for daily use
- can become bureaucracy

Best use:
- later, if the house becomes enterprise-scale

Verdict:
- parked candidate

---

## 2.6 ArchiMate Layout

Use for:
- enterprise architecture relationships
- business/application/technology layers

Strength:
- formal
- good for multi-layer systems

Weakness:
- heavy
- not needed yet

Best use:
- later, if the house needs formal EA diagrams

---

# 3. Link-Proof Layouts

These prove relationships between files, rooms, claims, and authority paths.

## 3.1 DSM — Design Structure Matrix / Dependency Matrix

Shape:

```txt
          README  CTI  ANCHOR  AGENTS
README      -      →     ?       →
CTI         ?      -     →       ?
ANCHOR      ?      ?     -       ?
AGENTS      ?      →     →       -
```

Use for:
- Front Door / Authority Group audit
- internal room link audits
- cross-group flow later

Strength:
- makes missing links obvious
- excellent for “do these files agree?”
- compact

Weakness:
- matrix can be hard to read at large size

Best use:
- current Front Door link audit

House rule:
```txt
DSM proves neighbor links better than prose alone.
```

---

## 3.2 Traceability Matrix

Shape:

```txt
Claim
Source file
Supporting text
Neighbor file
Expected agreement
Actual agreement
Gap
Proof state
Verdict
```

Use for:
- authority claims
- startup order claims
- TODO support claims
- receipt proof

Strength:
- separates claim from proof
- prevents outside critique from becoming proof
- highly aligned with the house

Weakness:
- requires discipline
- can become table-heavy

Best use:
- authority/proof changes

---

## 3.3 Cross-Reference Map

Shape:

```txt
File A references File B
File B references File C
File D does not reference expected neighbor
```

Use for:
- quick link discovery
- map before DSM

Strength:
- easier than matrix
- good first pass

Weakness:
- does not prove meaning agreement

Best use:
- raw findings stage

---

## 3.4 Adjacency List Layout

Shape:

```txt
README:
  points_to: CTI, ACTIVE_GUIDES, AGENTS
CTI:
  points_to: ACTIVE_ANCHOR, AGENTS, guides
AGENTS:
  points_to: CTI, ACTIVE_ANCHOR
```

Use for:
- graph parsing
- Datalog/Warshall later
- quick relationship maps

Strength:
- machine-friendly
- simple

Weakness:
- less visual than DSM

Best use:
- system-links database input

---

## 3.5 Provenance Graph Layout

Shape:

```txt
entity → activity → agent → derived entity
```

Use for:
- who created a claim
- how a TODO came from source input
- which receipt proves what
- lineage of old/current language

Strength:
- strong source tracking
- protects proof-state boundaries

Weakness:
- can grow complex

Best use:
- proof history and source ore

---

## 3.6 Knowledge Graph Layout

Shape:

```txt
node → relation → node
```

Example:

```txt
TODO_CONTROL_BOARD --supports--> ACTIVE_BOSS_SELECTION
ACTIVE_ANCHOR --selects_next_move--> ASSISTANT_ACTION
README --orients--> NEW_ASSISTANT
PROOF_HISTORY --evidences--> COMPLETED_CHANGE
```

Use for:
- recursive reachability
- authority graph
- support graph
- proof graph

Strength:
- flexible
- works with Datalog, SHACL, OpenFGA-style thinking

Weakness:
- must have strict relation names or it becomes fog

Best use:
- later formal house graph

---

# 4. Room Boundary Layouts

These prove what a room takes in, does, outputs, and must not do.

## 4.1 SIPOC+CM

Shape:

```txt
Supplier
Input
Process
Output
Customer
Constraints
Measures
```

Use for:
- TODO room
- System Links room
- Proof History
- Front Door
- Source Ore
- Suit

Strength:
- very good for room boundaries
- names input/output clearly
- includes constraints and measures

Weakness:
- not enough for internal file links

Best use:
- one-page room cards

House example:

```txt
Room: TODO
Supplier: user/source input/audit findings
Input: raw items
Process: trace, triage, group, classify, rank
Output: support items / boss candidates / parked items
Customer: active boss stack
Constraints: cannot command
Measures: no raw item promoted without trace
```

---

## 4.2 IPO / IPOC Layout

Shape:

```txt
Input → Process → Output
```

Use for:
- small rooms
- lightweight process summaries

Strength:
- simple

Weakness:
- misses suppliers, constraints, measures

Best use:
- when SIPOC is too heavy

---

## 4.3 Input / Output Contract Card

Shape:

```txt
Accepts:
Rejects:
Produces:
Does not produce:
Consumes from:
Sends to:
```

Use for:
- room interface contracts
- support/authority boundaries

Strength:
- blunt and practical

Weakness:
- less standard than SIPOC

Best use:
- house-specific room contracts

---

## 4.4 Responsibility Boundary Card

Shape:

```txt
This room owns:
This room supports:
This room must not do:
This room escalates to:
```

Use for:
- preventing role blur

Strength:
- extremely aligned with house language

Weakness:
- needs proof links

Best use:
- README for every room

---

# 5. Process Movement Layouts

These show how work moves and where gates exist.

## 5.1 BPMN Gate Flow

Shape:

```txt
event → activity → gateway → activity → end
```

Use for:
- audit process
- TODO promotion
- repair process
- receipt process
- blocked-work resume

Strength:
- precise
- good for branching and gateways

Weakness:
- visual complexity if overused

Best use:
- strict movement rules

House example:

```txt
Start
→ Anchor sync
→ Audit map
→ Gap found?
  yes → park repair candidate
  no → receipt audit complete
→ End
```

---

## 5.2 Swimlane Flow

Shape:

```txt
Lane: User
Lane: Active Anchor
Lane: TODO
Lane: Proof
Lane: Assistant
```

Use for:
- showing who/what acts
- separating authority from support

Strength:
- excellent for authority boundaries
- makes command ownership visible

Weakness:
- can become wide

Best use:
- command/action flows

---

## 5.3 State Machine Layout

Shape:

```txt
RAW → TRIAGED → CANDIDATE → SELECTED → ACTIVE → DONE
```

Use for:
- TODO status
- room lifecycle
- repair lifecycle
- receipt lifecycle

Strength:
- blocks illegal jumps
- easy to validate with bits

Weakness:
- needs exception rules

Best use:
- lifecycle control

House rule:
```txt
No item jumps state without allowed transition and proof.
```

---

## 5.4 Typestate / Lifecycle Map

Shape:

```txt
state + allowed actions
```

Example:

```txt
RAW:
  allowed: trace, park, reject
  blocked: repair, commit, active boss

TRIAGED:
  allowed: group, classify, park
  blocked: command

CANDIDATE:
  allowed: rank, select by authority
  blocked: self-promote
```

Use for:
- enforcing legal actions per status

Strength:
- stronger than simple state chart

Weakness:
- more text-heavy

Best use:
- TODO gate and repair gate

---

## 5.5 EventStorming Layout

Shape:

```txt
Domain Event
Command
Actor
Policy
Read Model
External System
```

Use for:
- discovering real behavior before formalizing
- understanding what actually happens when an assistant enters the house

Strength:
- good for messy domains
- exposes hidden commands and policies

Weakness:
- discovery tool, not proof tool

Best use:
- before designing a new room or flow

---

## 5.6 Domain Storytelling Layout

Shape:

```txt
Actor does activity with work object
```

Use for:
- plain-language process discovery

Example:

```txt
User gives source input.
Assistant captures raw input.
TODO room stores support item.
Active authority selects boss.
Assistant performs audit.
Proof room stores receipt.
```

Strength:
- very readable

Weakness:
- less formal than BPMN

Best use:
- early process discovery with nontechnical people

---

## 5.7 Value Stream Map

Shape:

```txt
process step → wait → information flow → value/waste
```

Use for:
- finding delay, rework, fog, duplicate proof

Strength:
- identifies waste
- good for flow improvement

Weakness:
- less focused on authority

Best use:
- after room internals are stable

---

## 5.8 Critical Path Layout

Shape:

```txt
tasks + dependencies → longest blocking path
```

Use for:
- implementation planning
- contractor milestones

Strength:
- finds what blocks completion

Weakness:
- not proof logic

Best use:
- later implementation phase

---

## 5.9 PERT Layout

Shape:

```txt
optimistic / likely / pessimistic path estimates
```

Use for:
- uncertain implementation planning

Strength:
- handles uncertainty

Weakness:
- estimation overhead

Best use:
- contractor schedule planning

---

# 6. Decision Memory Layouts

These record why choices were made and stop old decisions from becoming ghost authority.

## 6.1 ADR — Architecture Decision Record

Shape:

```txt
Title
Status
Context
Decision
Consequences
Alternatives considered
Supersedes
Superseded by
Proof receipt
```

Use for:
- major room design decisions
- algorithm adoption decisions
- authority boundary decisions

Strength:
- prevents decision drift
- clear lifecycle states

Weakness:
- too much for tiny changes

Best use:
- accepted/rejected/superseded architecture choices

---

## 6.2 Decision Table / DMN Layout

Shape:

```txt
Inputs → rules → output
```

Use for:
- TODO promotion
- repair authorization
- proof verdicts
- blocked move resume

Strength:
- explicit
- testable

Weakness:
- can become brittle if too many exceptions

Best use:
- gates with repeatable yes/no decisions

---

## 6.3 Decision Tree Layout

Shape:

```txt
question → branch → question → outcome
```

Use for:
- assistant guidance
- simple triage

Strength:
- easy to follow

Weakness:
- bad for complex overlapping conditions

Best use:
- quick operator guidance, not formal authority

---

## 6.4 Pugh Matrix

Shape:

```txt
candidate vs baseline
criterion by criterion
better / same / worse
```

Use for:
- comparing layout candidates
- choosing algorithm candidates

Strength:
- good for design alternatives

Weakness:
- subjective unless criteria are clear

Best use:
- Soft Suit comparison

---

## 6.5 MCDA Matrix

Shape:

```txt
options × criteria × weights → score
```

Use for:
- choosing between non-obvious alternatives

Strength:
- transparent tradeoffs

Weakness:
- scores can launder weak proof

Best use:
- support only, never command authority

---

# 7. Authority and Responsibility Layouts

These show who owns what and who can do what.

## 7.1 RACI Matrix

Shape:

```txt
Responsible
Accountable
Consulted
Informed
```

House translation:

```txt
Runner
Final authority
Support/source
Watcher
```

Use for:
- room ownership
- decision ownership
- repair ownership

Strength:
- clarifies responsibility

Weakness:
- weak for command gates unless adapted

Best use:
- implementation teams and contractor work

---

## 7.2 DACI Matrix

Shape:

```txt
Driver
Approver
Contributors
Informed
```

House translation:

```txt
Runner
Authority
Support
Watcher
```

Use for:
- decision-rights clarity

Strength:
- stronger than RACI for decisions

Weakness:
- not enough for proof

Best use:
- repair authorization and design decisions

---

## 7.3 Capability Map

Shape:

```txt
capability → owner → current maturity → dependencies
```

Use for:
- mapping what the house can do

Example:

```txt
Orientation
Authority selection
TODO triage
Proof receipts
System link audit
Source parking
Blocked move control
```

Strength:
- strategic
- helps avoid room sprawl

Weakness:
- abstract

Best use:
- high-level planning

---

## 7.4 Authority Capability Mask Layout

Shape:

```txt
can_orient
can_support
can_block
can_select_next_move
can_authorize_repair
can_authorize_commit
can_supersede_old_instruction
```

Use for:
- machine-readable authority support

Strength:
- compact
- strong if backed by text

Weakness:
- dangerous if treated as authority by itself

Best use:
- later validation only

Rule:
```txt
Written authority owns meaning.
Capability mask only checks meaning.
```

---

## 7.5 Biba Integrity Lattice Layout

Shape:

```txt
external claim
< suspected source input
< directly audited
< authority confirmed
< receipted neighbor-fit proof
```

Use for:
- proof-state hierarchy
- stopping low-proof material from writing upward

Strength:
- extremely strong fit

Weakness:
- needs careful explanation

Best use:
- source/support/authority separation

House rule:
```txt
Low-proof material may support upward.
It must not write upward into authority.
```

---

## 7.6 Zanzibar / Relationship Tuple Layout

Shape:

```txt
object#relation@subject
```

Example:

```txt
ACTIVE_ANCHOR#selects_next_move@assistant
TODO#supports@boss_stack
PROOF_HISTORY#evidences@repair
README#orients@assistant
```

Use for:
- formal authority graph later

Strength:
- excellent for relationship-based authorization

Weakness:
- too formal for now

Best use:
- later policy engine

---

# 8. TODO and Work-Control Layouts

These keep capture, triage, boss selection, and proof separated.

## 8.1 Kanban Board

Shape:

```txt
Backlog / Ready / Doing / Blocked / Done
```

House adaptation:

```txt
Raw Inbox
Triage
Accepted Support
Boss Candidate
Active Support
Blocked
Receipted
Parked
Superseded
```

Strength:
- visual flow
- supports WIP limits

Weakness:
- normal Kanban does not protect authority

Best use:
- TODO room with authority locks

---

## 8.2 Trace-Triage Gate Layout

Shape:

```txt
Trace
→ Triage
→ Group
→ Classify
→ Rank
→ WIP
→ Proof
```

Use for:
- TODO room

Strength:
- best fit for TODO
- prevents raw input becoming boss

Weakness:
- must stay small at first

Best use:
- TODO_TRACE_TRIAGE_GATE candidate

Rule:
```txt
Raw input may be captured,
but it cannot become structured TODO, boss candidate, active boss, or repair
until it passes trace and triage.
```

---

## 8.3 Boss Stack Layout

Shape:

```txt
Raw seen items
Atomic items
Grouping
Ranked parent bosses
Current boss
Proof needed
Parked candidates
Blocked moves
Verdict
```

Use for:
- ranking work without overload

Strength:
- already matches house method
- keeps one active boss

Weakness:
- must not become command source by itself

Best use:
- boss cycle files

---

## 8.4 Eisenhower Matrix

Shape:

```txt
urgent / important
```

Use for:
- urgency sorting

Strength:
- quick

Weakness:
- does not prove authority or proof
- urgency can create fake command pressure

Best use:
- weak support only

Verdict:
- not recommended as main TODO layout

---

## 8.5 MoSCoW Layout

Shape:

```txt
Must
Should
Could
Won't
```

Use for:
- product requirements

Strength:
- familiar

Weakness:
- “Must” can become fake authority

Best use:
- implementation requirements only, not boss selection

---

## 8.6 Shape Up Betting Table

Shape:

```txt
pitch
appetite
risks
circuit breaker
bet / no bet
```

Use for:
- limiting candidate bosses
- avoiding huge backlog

Strength:
- good anti-backlog discipline

Weakness:
- does not solve proof by itself

Best use:
- candidate boss selection later

---

## 8.7 RAID Log

Shape:

```txt
Risks
Assumptions
Issues
Dependencies / Decisions
```

Use for:
- separating concern types

Strength:
- prevents every concern from becoming a task

Weakness:
- not a work board by itself

Best use:
- TODO triage item kind split

---

# 9. Proof and Evidence Layouts

These define what proof looks like and how it survives.

## 9.1 Evidence Ledger Layout

Shape:

```txt
Claim
Evidence
Source
Verifier
Date
Scope
Limit
Verdict
```

Use for:
- proof history
- audit receipts

Strength:
- clear

Weakness:
- only as strong as evidence quality

Best use:
- proof-history records

---

## 9.2 Neighbor-Fit Receipt Layout

Shape:

```txt
Change or audit
Owner file
Touched files
Untouched files
Neighbor files checked
Authority preserved
Support kept support
Competing authority avoided
Parked remainder
Proof
```

Use for:
- meaning-changing repairs
- authority routing repairs
- TODO/Proof/System Links changes

Strength:
- upgrades receipts beyond text existence

Weakness:
- more work than simple receipt

Best use:
- all authority/proof/routing changes

---

## 9.3 GSN / Assurance Case Layout

Shape:

```txt
Top claim
Context
Strategy
Subclaims
Evidence
Assumptions
Defeaters
```

Use for:
- proving major safety claims

Example:

```txt
Claim: TODO cannot command.
Strategy: prove by authority boundary, transition gate, and receipt checks.
Evidence: TODO README, active anchor, trace-triage gate, receipts.
```

Strength:
- excellent for high-stakes proof

Weakness:
- heavy for small claims

Best use:
- major recursive safety claims

---

## 9.4 Append-Only Proof Log Layout

Shape:

```txt
previous root
new entry
new root
consistency proof
```

Use for:
- proof-history integrity
- receipt ledger

Strength:
- tamper-evident history

Weakness:
- implementation complexity

Best use:
- later proof engine

---

## 9.5 Timeline / Event Log Layout

Shape:

```txt
time
event
actor
source
effect
proof
```

Use for:
- audit chronology
- command history
- change history

Strength:
- simple and useful

Weakness:
- time order does not equal authority

Best use:
- receipts and proof history

Rule:
```txt
Timeline proves order.
It does not prove correctness by itself.
```

---

## 9.6 Evidence Quality Ladder

Shape:

```txt
external claim
suspected source input
directly audited
authority confirmed
neighbor-fit receipted
reproduced / independently verified
```

Use for:
- proof-state clarity

Strength:
- very aligned with house logic

Weakness:
- requires consistent labels

Best use:
- traceability matrix and proof room

---

# 10. Risk and Failure-Control Layouts

These show how things can break and how barriers stop damage.

## 10.1 FMEA Layout

Shape:

```txt
function
failure mode
effect
severity
cause
detection
mitigation
proof
```

Use for:
- room safety review
- authority room failure modes
- TODO failure modes

Strength:
- systematic

Weakness:
- can become long

Best use:
- recurring or high-risk rooms

---

## 10.2 Fault Tree Layout

Shape:

```txt
top failure
AND/OR causes
leaf causes
barriers
proof needed
```

Use for:
- “How could fake authority happen?”
- “How could TODO command?”
- “How could stale current language mislead?”

Strength:
- excellent for top-down failure analysis

Weakness:
- can overfit imagined failures

Best use:
- serious safety reviews

---

## 10.3 Bowtie Layout

Shape:

```txt
threats → preventive barriers → top event → recovery barriers → consequences
```

Use for:
- repeated failure patterns
- authority drift
- stale current wording

Strength:
- shows prevention and recovery

Weakness:
- less precise than fault tree

Best use:
- risk communication

---

## 10.4 Threat Model DFD Layout

Shape:

```txt
processes
data stores
data flows
trust boundaries
threats
controls
```

Use for:
- public/local boundary
- tool access
- command injection risk

Strength:
- security-focused

Weakness:
- too technical if overused

Best use:
- repo/tool boundary later

---

## 10.5 Attack Tree Layout

Shape:

```txt
bad outcome
attack paths
subgoals
leaf steps
controls
```

Use for:
- fake authority paths
- malicious prompt/source routes

Strength:
- very good for adversarial thinking

Weakness:
- can become paranoid if used everywhere

Best use:
- security/authority risk reviews

---

## 10.6 Premortem Layout

Shape:

```txt
Assume this failed.
Why did it fail?
What barrier prevents that?
```

Use for:
- before installing new rooms
- before adopting bitstring logic

Strength:
- fast and powerful

Weakness:
- not proof by itself

Best use:
- Soft Suit / Hard Suit testing

---

## 10.7 8D / CAPA Layout

Shape:

```txt
contain problem
find root cause
correct
prevent recurrence
verify
close
```

Use for:
- recurring failures

Strength:
- strong corrective-action structure

Weakness:
- too heavy for one-off issues

Best use:
- repeated authority/proof failures

---

# 11. Knowledge and Source Organization Layouts

These organize source ore, memory, learning, and old material without making them command.

## 11.1 Diátaxis Layout

Shape:

```txt
Tutorial
How-to
Reference
Explanation
```

House translation:

```txt
Entry
Action guide
Reference
Explanation/context
```

Use for:
- documentation role cleanup

Strength:
- prevents documents from doing each other’s jobs

Weakness:
- not enough for authority files unless adapted

Best use:
- README, guides, references, explanations

---

## 11.2 PARA Layout

Shape:

```txt
Projects
Areas
Resources
Archives
```

House translation:

```txt
Active boss-linked work
Ongoing room health
Source/support material
Closed/superseded material
```

Use for:
- source ore and parked material

Strength:
- simple memory organization

Weakness:
- not authority/proof logic

Best use:
- support memory only

---

## 11.3 Zettelkasten / Atomic Notes Layout

Shape:

```txt
atomic note
unique ID
links
context
```

Use for:
- brain learning
- source ideas

Strength:
- good for knowledge growth

Weakness:
- linked notes can look like proof when they are not

Best use:
- Brain Learning and Source Ore only

Rule:
```txt
Linked knowledge is not command authority.
```

---

## 11.4 Ontology / Taxonomy Layout

Shape:

```txt
class
subclass
relation
property
instance
```

Use for:
- formal room and file types

Strength:
- strong classification

Weakness:
- can become overbuilt

Best use:
- later machine-readable house graph

---

## 11.5 Faceted Classification Layout

Shape:

```txt
role
state
proof level
risk type
room
lifecycle
```

Use for:
- filtering files/TODOs/proofs by multiple dimensions

Strength:
- better than one folder hierarchy

Weakness:
- needs controlled vocabulary

Best use:
- TODO labels, proof labels, room tags

---

## 11.6 Card Sorting / Affinity Layout

Shape:

```txt
many items → natural groups → group labels
```

Use for:
- sorting raw algorithm/layout ideas
- grouping TODOs

Strength:
- good for messy piles

Weakness:
- does not choose authority

Best use:
- early grouping before boss ranking

---

## 11.7 Mind Map

Shape:

```txt
central idea → branches → subbranches
```

Use for:
- brainstorming

Strength:
- quick and creative

Weakness:
- weak proof structure

Best use:
- source input only

---

## 11.8 Concept Map

Shape:

```txt
concept --labeled relationship--> concept
```

Use for:
- explaining how ideas relate

Strength:
- clearer than mind map

Weakness:
- still not proof unless sourced

Best use:
- education/explanation layer

---

# 12. Strategic Evolution Layouts

These decide where the house should evolve, not what to do this second.

## 12.1 Wardley Map

Shape:

```txt
user need
→ value chain
→ evolution stage
```

Stages:

```txt
Genesis
Custom
Product
Commodity
```

Use for:
- deciding what should be custom and what should become boring/stable

Strength:
- strategic awareness

Weakness:
- not day-to-day process

Best use:
- long-range house direction

House example:

```txt
Custom: recursive authority proof
Productized: TODO gate, System Links audit
Commodity: README routing, indexes, git status proof
```

---

## 12.2 Hoshin Kanri / X-Matrix

Shape:

```txt
long-term goals
annual objectives
improvement priorities
metrics
owners
```

Use for:
- whole-house strategic alignment

Strength:
- connects long and short term

Weakness:
- too much for current phase

Best use:
- later milestones

---

## 12.3 Opportunity Solution Tree

Shape:

```txt
desired outcome
→ opportunities
→ solutions
→ experiments
```

Use for:
- product/discovery thinking

Strength:
- ties solutions to outcomes

Weakness:
- less about proof

Best use:
- deciding what rooms/features to build later

---

## 12.4 Impact Map

Shape:

```txt
goal → actor → impact → deliverable
```

Use for:
- proving why a new room/file matters

Strength:
- stops building for its own sake

Weakness:
- not detailed enough alone

Best use:
- before adding new rooms

---

## 12.5 Jobs To Be Done Layout

Shape:

```txt
situation
motivation
job
desired progress
```

Use for:
- asking what each room is hired to do

Strength:
- strong against vague room names

Weakness:
- not architecture proof

Best use:
- room purpose statements

---

# 13. Repo and Implementation Layouts

These help contractors or future assistants build the system.

## 13.1 Layered Repo Layout

Shape:

```txt
entry/
authority/
orientation/
work/
proof/
source/
tools/
archive/
```

Use for:
- future repo cleanup

Strength:
- simple

Weakness:
- may not match existing house metaphor

Best use:
- later if repo becomes hard to navigate

---

## 13.2 Hexagonal / Ports and Adapters Layout

Shape:

```txt
core rules
ports
adapters
external tools
```

Use for:
- if the house becomes software

Strength:
- protects core logic from tool changes

Weakness:
- too technical for current docs-only phase

Best use:
- future implementation

---

## 13.3 Clean Architecture Layout

Shape:

```txt
entities
use cases
interface adapters
frameworks/tools
```

Use for:
- executable recursive engine later

Strength:
- dependency direction is clear

Weakness:
- overkill for current files

Best use:
- later code implementation

---

## 13.4 Monorepo Workspace Layout

Shape:

```txt
docs/
rules/
tools/
tests/
schemas/
receipts/
```

Use for:
- if the house becomes code + docs + tests

Strength:
- centralizes everything

Weakness:
- can become huge without boundaries

Best use:
- future contractor implementation

---

## 13.5 Schema-First Layout

Shape:

```txt
schema
examples
validators
docs
tests
```

Use for:
- TODO item schema
- room card schema
- receipt schema
- bitstring registry schema

Strength:
- machine-checkable

Weakness:
- needs tooling

Best use:
- later validation phase

---

## 13.6 Test Pyramid Layout

Shape:

```txt
unit checks
integration checks
end-to-end checks
manual audit checks
```

House translation:

```txt
field presence checks
neighbor-link checks
group audit checks
whole-house walkthroughs
```

Use for:
- proof automation later

Strength:
- separates test levels

Weakness:
- not all proof can be automated

Best use:
- future validation tooling

---

# 14. Dashboard and Runtime Visibility Layouts

These show current state without becoming current authority.

## 14.1 Control Board Layout

Shape:

```txt
current boss
allowed move
blocked moves
active support
parked candidates
proof needed
latest receipt
```

Use for:
- status visibility

Strength:
- practical

Weakness:
- can be mistaken for authority if stale

Best use:
- TODO/control board with clear support label

Rule:
```txt
Dashboard shows status.
It does not create authority.
```

---

## 14.2 Health Dashboard Layout

Shape:

```txt
room
status
last checked
risk bits
proof bits
next review
```

Use for:
- system health

Strength:
- fast overview

Weakness:
- stale danger

Best use:
- periodic review, not command

---

## 14.3 Traffic-Light Layout

Shape:

```txt
green = clear
yellow = needs review
red = blocked
gray = unknown
```

Use for:
- quick room status

Strength:
- visual and simple

Weakness:
- can oversimplify

Best use:
- high-level status only

---

## 14.4 Heatmap Layout

Shape:

```txt
rooms × risks
low / medium / high
```

Use for:
- risk concentration

Strength:
- shows patterns

Weakness:
- subjective if not tied to evidence

Best use:
- risk review after audits

---

## 14.5 Timeline Dashboard

Shape:

```txt
events by date
anchor changes
audits
receipts
repairs
blocked moves
```

Use for:
- history navigation

Strength:
- easy chronology

Weakness:
- chronological order does not prove authority

Best use:
- proof-history navigation

---

# Recommended layout stack for the house

Best practical stack:

```txt
1. House / Workshop Map
2. C4 Map
3. DSM Matrix
4. Traceability Matrix
5. SIPOC Room Card
6. BPMN / Swimlane Flow
7. ADR Log
8. Neighbor-Fit Receipt
9. Risk Layout: FMEA / Bowtie / Fault Tree
10. Dashboard: Control Board, clearly support-only
```

Short form:

```txt
House shows where things live.
C4 shows what the system is.
DSM proves who links to whom.
Traceability proves claims.
SIPOC proves room boundaries.
BPMN proves movement.
ADR proves why.
Receipts prove what changed.
Risk maps show failure paths.
Dashboards show status only.
```

---

# Best layout for current next work

For **Front Door / Authority Group link audit**, the best layout is:

```txt
DSM + Traceability Matrix + Raw Findings Map
```

Use this output order:

```txt
Raw findings
Entry flow
Authority split
Internal links
Neighbor risks
Gaps
Parent boss candidates
Recommended first repair
Blocked repairs
Proof needed
```

Why:

- DSM makes the missing/weak links visible.
- Traceability Matrix separates claim/source/proof/verdict.
- Raw Findings Map preserves direct observations before judgment.

Do **not** use:
- C4 alone, because it will look clean without proving agreement.
- Kanban alone, because it tracks work but not truth.
- House map alone, because it orients but does not prove links.
- MoSCoW alone, because priority can fake authority.
- Dashboard alone, because status can be stale.

---

# Best layout for TODO room later

For TODO, the best layout is:

```txt
Trace-Triage Gate + Kanban WIP + RAID Split + Boss Stack
```

Flow:

```txt
Raw Inbox
→ Trace
→ Triage
→ RAID/item-kind split
→ Group
→ Classify
→ Rank as candidate
→ WIP check
→ Active only by authority
→ Proof/receipt
```

Core rule:

```txt
Raw input may be captured,
but it cannot become structured TODO, boss candidate, active boss, or repair
until it passes trace and triage.
```

---

# Best layout for proof room later

For Proof History, the best layout is:

```txt
Evidence Ledger + Neighbor-Fit Receipt + Provenance Graph + Append-Only Log
```

Flow:

```txt
Claim
→ Evidence
→ Source
→ Verification
→ Neighbor fit
→ Receipt
→ Append-only history
```

Core rule:

```txt
Proof must prove meaning and neighbor fit,
not just that expected text exists.
```

---

# Best layout for recursive system later

For recursion, the best layout is:

```txt
House Map
+ Knowledge Graph
+ Datalog/Rule Graph
+ Biba Integrity Lattice
+ SHACL/Schema Validation
+ Append-Only Proof Log
```

Meaning:

```txt
House Map = human orientation
Knowledge Graph = relationships
Rule Graph = allowed movement
Biba Lattice = integrity flow
SHACL/Schema = required fields
Append Log = history integrity
```

Short form:

```txt
Map the rooms.
Graph the relationships.
Rule the movement.
Block bad flow.
Validate required fields.
Seal the proof.
```

---

# Final verdict

Do not replace the current house layout.

Upgrade it.

The best layout strategy is layered:

```txt
Human layer: House / Workshop Map
Architecture layer: C4 + arc42
Proof layer: DSM + Traceability Matrix
Process layer: BPMN + State Machine
Authority layer: RACI/DACI + Biba lattice
Work layer: Trace-Triage + Kanban WIP + Boss Stack
Evidence layer: Neighbor-Fit Receipt + Provenance + Append-Only Log
Risk layer: FMEA + Fault Tree + Bowtie
Strategy layer: Wardley + Impact Map
Implementation layer: Schema-first + Tests
```

Hard rule:

```txt
No single layout should carry the whole house.
Each layout must know its job and what it must not do.
```

Best one-sentence answer:

> Keep the house map for human orientation, but use DSM + Traceability for proof, SIPOC for room boundaries, BPMN for movement, ADRs for decisions, and Neighbor-Fit Receipts for meaning changes.

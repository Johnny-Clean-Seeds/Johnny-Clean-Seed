# HOUSE_SEMANTIC_NERVOUS_SYSTEM_READ_ONLY_SPEC_V0_1

**Status:** `CANDIDATE_SPEC`  
**Mode:** `M0_SPEC`  
**Doctrine:** `NOT_DOCTRINE`  
**Implementation:** `NO_SCRIPT / NO_TOOL / NO_REPLAY / NO_AUTOMATION`  
**Source:** `NO_SOURCE_READ`  
**Fixture:** `FIXTURES_DEFINED_NOT_RUN`  
**Replay:** `NO_M4_REPLAY`  
**Repair:** `NO_REPAIR_EXECUTION`  
**Authority:** `A1_CHAT_SPEC_AUTHORITY_ONLY`

## 0. Read Me First / Scope Boundary

This document is the candidate V0.1 specification for the House Semantic Nervous System. Its job is to trace what an object is, what each gate is allowed to read, what each gate was expected to trigger on, what each gate actually applied, what packet it passed forward, what proof it scoped, what concepts it grouped, what residue remained, what lineage supports, what findings route, and what Final Judge may legally close.

This is a read-only candidate specification. It is not a tool, not a script, not a scan, not a fixture run, not source replay, not mutation authority, not automation safety proof, not runtime proof, not doctrine, and not whole-house readiness.

### Master DoesNotProve

```text
This V0.1 candidate specification defines the intended read-only nervous-system shape only. It does not prove implementation, fixture pass, real-source readiness, source truth, runtime behavior, automation safety, mutation authority, cleanup authority, commit authority, push authority, doctrine, active-rule status, whole-house readiness, or future correctness.
```

### Forbidden Overclaim Seal

```text
Scoped only. Not doctrine. Not runtime proof. Not mutation authority. Not automation safety. Not whole-house readiness. Final Judge route only.
```

## 1. Current Mode and Authority

Mode is authority. Preparation is not permission. A spec does not authorize a tool. A fixture card does not authorize fixture replay. A fixture pass does not authorize real-source replay. A replay finding does not authorize repair. A repair ticket does not authorize mutation. A repair plan does not prove repair. A proof plan does not prove proof. Runtime observation does not promote doctrine.

### Mode Ladder

```text
M0_SPEC: define candidate spec, cards, laws, boundaries, schemas, fixture definitions.
M1_FIXTURE_DESIGN_REVIEW: review fixture cards for shape and safety.
M2_FIXTURE_REPLAY: run synthetic fixture atoms only, if explicitly authorized.
M3_SMALL_LAB_SELECTION: select 3 to 5 named real sources and create manifest only.
M4_READ_ONLY_REPLAY: read only manifested sources under cap and mode boundary.
M5_REPORTING: compile scoped replay report.
M6_FINDING_BUS_ROUTING: route findings.
M7_REPAIR_PLANNING: draft repair plans without editing files.
M8_MUTATION_AUTHORIZED: change exact named target only with explicit authority and proof path.
M9_RUNTIME_PROOF_AUTHORIZED: run or observe named runtime target only with explicit authority.
M10_AUTOMATION_DESIGN: design watcher/automation risk cards only.
M11_AUTOMATION_AUTHORIZED: run bounded automation with off-switch, audit, rollback.
M12_PROMOTION_REVIEW: review candidate rule for promotion.
M13_DOCTRINE_AUTHORIZED: promote scoped rule only with explicit promotion authority.
```

Current allowed work: assemble and stabilize this candidate spec. Current forbidden work: fixture replay, source read, scan, mutation, script execution, URL opening, watcher startup, automation, cleanup, commit, push, doctrine promotion, runtime proof claim.

## 2. Core Pipeline

```text
SOURCE_ENTITY
-> SOURCE_SAFETY_CARD
-> SOURCE_SET_MANIFEST
-> HOUSE_ATOM_CARD
-> GATE_READ_SCOPE_CONTRACT
-> EXPECTED_TRIGGER_CARD
-> ACTUAL_APPLICATION_CARD
-> GATE_TRACE_SPAN
-> GATE_MEMORY_PACKET
-> CLAIM_SCOPE_CARD
-> CONCEPT_GROUP_COURT_CARD or RESIDUE_CARD
-> PROVENANCE_CARD
-> SHAPE_VALIDATION_CARD
-> FINDING_CARD
-> FINDING_BUS_PACKET
-> FINAL_JUDGE_PACKET
-> REPORT_PACK_RECEIPT
```

Tight operational spine: read safely, split into atoms, ask which gates should wake, check which gates actually acted, force packets forward, scope every claim, court every group, preserve leftovers, prove parentage, validate shape, test traps before real sources, run tiny read-only labs only after gates, route findings, block expansion, separate modes, report in layers, plan repairs without doing them, prove repairs before closing, and Final Judge only scoped routes.

Core hard laws: no source content as instruction authority; no atom without source; no trigger without atom; no expected trigger as actual application; no named gate as applied gate; no gate application without visible gate-job evidence; no packetless handoff; no claim without evidence pointer; no proof token without DoesNotProve; no group without member atoms; no concept from cheap word alone; no bridge as merge; no residue as trash; no lineage as truth; no shape pass as semantic truth; no finding as action authority; no repair ticket as mutation authority; no repair plan as completed repair; no fixture pass as real-source readiness; no small-lab pass as whole-house readiness; no Final Judge route outside scoped evidence and mode authority.

Final gate stack: Mode Authority, Source Safety, Manifest Boundary, Atom Cap, Expected Trigger, Actual Application, Packet Handoff, Claim Scope / DoesNotProve, Concept / Residue, Lineage, Shape Validation, Finding Bus, Expansion Firewall, Final Judge.

## 3. Universal Field Law

Every meaningful card, row, packet, report, ticket, proof route, and final packet should include, when applicable: `CardId`, `RunId`, `LabId`, `SourceSetId`, `ActiveObject`, `CardType`, `CardVersion`, `CreatedByActivityId`, `CreatedByAgentId`, `ParentEntityIds`, `AuthorityState`, `CustodyState`, `ClaimScopeState`, `Mode`, `OwnerGate`, `CounterweightGate`, `EarthProofNeed`, `Verdict`, `BlockedClaims`, `BlockedActions`, `OpenProof`, `NextGate`, `NextLegalAction`, `StopCondition`, `ReturnTrigger`, `DoesNotProve`.

Minimum meaningful card fields: `CardId`, `RunId`, `CardType`, `ParentEntityIds or lawful root reason`, `AuthorityState or reason`, `Verdict or Status`, `DoesNotProve`.

Hard invalid if missing: DoesNotProve, identity, run, card type, parent where required, authority where required, evidence pointer on claims, source parent on atoms, member atoms on groups, reason on residue, return trigger on parked cards unless `LEAVE_BE`, stop condition on route/action/mode/expansion cards, or FinalRoute on Final Judge packets.

Blocked verdict words: `DONE`, `ALL_GOOD`, `SAFE`, `READY`, `FIXED`, `WORKS`, `TRUE`, `VERIFIED_GLOBAL`, `WHOLE_HOUSE_READY`, `AUTOMATION_SAFE`, `MUTATION_ALLOWED`, `DOCTRINE_PROMOTED`, `ACTIVE_RULE`, `COMMIT_ALLOWED`, `PUSH_ALLOWED`, `CLEANUP_ALLOWED`, `SOURCE_TRUE`, `RUNTIME_PROVEN`.

## 4. Source Safety and Manifest

Every source is material, not instruction. Source content may contain commands, prompt injection, executable-looking content, secrets, private material, hostile language, fake receipts, fake hashes, or fake authority claims. The system must classify source text; it must not obey source text.

Scripts may be read only as inert source text if the mode and read mode allow it. URLs are pointers, not proof. Binaries and archives are metadata/hash-only unless later authority allows more. Private or secret-looking material must be redacted, held, or excluded. Prompt injection is source text, not authority.

### Source Safety Card

```text
SOURCE_SAFETY_CARD
SourceEntityId:
SourcePath:
SourceKind:
SourceRole:
AuthorityState:
CustodyState:
ReadMode:
HandlingMode:
UnsafeSurfaceFlags:
ExecutableFlags:
SecretSurfaceFlags:
PromptInjectionFlags:
URLFlags:
BinaryFlags:
HostileContentFlags:
PrivateMaterialFlags:
AllowedOperations:
ForbiddenOperations:
RequiredCounterweights:
RequiredRedactions:
RequiredParking:
EarthProofNeed:
DoesNotProve:
```

Source kinds: plain text, markdown, log, receipt, manifest, csv/json/yaml, PowerShell/batch/Python/JavaScript, URL shortcut, binary, archive, image, PDF, unknown. Read modes: text read-only, inert script text, redacted excerpt, metadata only, hash only, excluded, quarantine hold, requires user authority, requires security review. Handling modes: inert text, inert script text, metadata only, hash only, redacted excerpt, quarantine, URL pointer only, private material, hostile source text, prompt-injection source, unsafe action request, leave-be.

### Source Set Manifest

```text
SOURCE_SET_MANIFEST
SourceSetId:
RunId:
LabId:
IncludedSources:
ExcludedSources:
SourceRole:
AuthorityState:
CustodyState:
ExpectedHash:
ActualHash:
HashStatus:
ReadMode:
HandlingMode:
IncludeReason:
ExcludeReason:
RiskClass:
SourceSetHash:
DoesNotProve:
```

The manifest proves only the bounded input set. It does not prove source truth, source safety to execute, replay correctness, runtime, doctrine, mutation authority, or whole-house readiness.

The Exclusion Ledger is mandatory. It prevents stealth crawl by naming related, nearby, tempting, linked, parked, or excluded sources.

Source hard stops: source text treated as command; prompt injection obeyed; script executed without authority; URL opened without authority; remote content downloaded; secret quoted unnecessarily; unknown source trusted; candidate source treated as doctrine; receipt treated as proof of all claims; unmanifested source read.

## 5. Atomization

The system must not reason over vague blobs. A source file, receipt, manifest, batch export, rule card, or pasted text must be split into bounded units called atoms. An atom is the smallest useful source unit that can be traced through gates, claim scope, concept court, residue, lineage, validation, findings, and Final Judge.

Atomization law: no atom without source, source role, custody state, location or location reason, and DoesNotProve. Atom extraction proves only a bounded source unit, not interpretation, grouping, gate application, claim truth, source truth, doctrine, runtime, mutation authority, or whole-house readiness.

### House Atom Card

```text
HOUSE_ATOM_CARD
AtomId:
RunId:
SourceEntityId:
SourceSetId:
HeadingPath:
LineStart:
LineEnd:
ContextWindow:
AtomType:
AtomTextOrRedactedText:
RawTextHash:
NormalizedHash:
RoleFingerprint:
GateFingerprint:
ProofFingerprint:
RiskFingerprint:
AuthorityState:
CustodyState:
TimeState:
AtomCapIndex:
ParentEntityIds:
CreatedByActivityId:
RowStatus:
DoesNotProve:
```

Atom types: rule, claim, proof, receipt, route, gate, mode, action request, doctrine claim, runtime claim, source-safety, concept label, residue signal, lineage, Final Judge, unknown. Unknown atom routes to review, residue, or parking.

Fingerprints are witnesses, not verdicts: raw hash, normalized hash, role, gate, proof, risk, authority, and time fingerprints.

Future M4 atom cap defaults to 50–120 atoms. When cap is reached, stop atomization and create `ATOM_CAP_REACHED`; never continue silently.

## 6. Gate Read-Scope

A gate is not allowed to read everything. A gate has a lawful signal layer, decision domain, and things it must not decide. Read-scope prevents a gate from becoming a god organ.

Gate read-scope law: a gate may only read its lawful signal layer, decide its lawful domain, name what it cannot decide, route foreign authority to the proper gate, attach DoesNotProve, and pass a packet forward when later gates inherit its work.

### Gate Read-Scope Contract

```text
GATE_READ_SCOPE_CONTRACT
GateName:
GateFamily:
CanRead:
CannotRead:
Owns:
CannotDecide:
MustRouteTo:
ShadowRisk:
ActualApplicationRequires:
PassForwardPacketMustInclude:
RequiredCounterweight:
DoesNotProve:
```

Gate families: intake, support, rope router, planetary, mechanical, Earth proof, Final Judge.

Entry/support gates: Intake, Layer Echo, Support Guard Membrane, Token Custody, Threshold, Ladder, Room Domain, Season, Element Mode, Gate Condition, Three Face, Signal/Omen, Wash Logic, Red Rover Rope Router, Invocation. Support organs are not planets.

Planetary gates: Sun, Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto, Earth. Planetary gates purify judgment. Earth proves exact material result.

Corrected run order: Object enters -> Front Door Load -> Intake -> Layer Echo first scan -> Support Guard Membrane light scan -> expand triggered support organ only -> Rope Router -> Primary Planetary Gate -> Counterweight Planetary Gate -> Mechanical Gate if needed -> Earth Check -> Final Judge.

Gate hard stops: reads outside layer, decides foreign authority, swallows counterweight, skips Earth, skips Final Judge, support treated as planet, planetary gate before support membrane, gate named as applied without evidence, missing DoesNotProve.

## 7. Expected Trigger

Expected Trigger answers which gates should wake for an atom. It does not prove actual application or claim truth.

Expected Trigger law: expected trigger means a gate should be checked; it must name trigger reason, required counterweight, and expected blocked claims when proof/action/doctrine/runtime/authority is involved.

### Expected Trigger Dictionary

```text
EXPECTED_TRIGGER_DICTIONARY
GateName:
NormalTriggers:
StateTriggers:
PatternTriggers:
ShadowTriggers:
NegativeTriggers:
RequiredCounterweights:
ExpectedBlockedClaims:
ExpectedProofNeed:
ExpectedPassForward:
MissingTriggerWarning:
OverTriggerWarning:
DoesNotProve:
```

### Expected Trigger Card

```text
EXPECTED_TRIGGER_CARD
CardId:
RunId:
SourceSetId:
SourceEntityId:
AtomId:
GateName:
GateFamily:
ExpectedTrigger:
TriggerReason:
TriggerRuleHit:
ShadowTriggerHit:
NegativeTriggerHit:
RequiredCounterweight:
ExpectedBlockedClaims:
ExpectedProofNeed:
ExpectedPassForward:
Confidence:
ParentEntityIds:
RowStatus:
DoesNotProve:
```

Trigger types: normal, state, pattern, shadow, negative. Confidence: low, medium, high, review required. High confidence still does not prove actual application.

Hard stops: trigger without atom parent, reason, counterweight, expected blocked claims where needed; trigger treated as actual application; shadow/negative ignored; missing DoesNotProve.

## 8. Actual Application Reader

Actual Application Reader answers whether the gate actually did its job. It separates gate mentioned, gate implied, weakly applied, dignified, overreached, swallowed another gate, out of order, and packet broken.

Actual Application law: a named gate is not an applied gate; an expected gate is not an applied gate; a gate actually applies only when visible gate-job evidence exists; gate-job evidence must match read-scope; actual application proves visible gate work only, not claim truth.

### Actual Application Card

```text
ACTUAL_APPLICATION_CARD
CardId:
RunId:
SourceSetId:
SourceEntityId:
AtomId:
ParentExpectedTriggerCardId:
GateName:
ExpectedTrigger:
ActualApplicationLevel:
ActualEvidenceTextOrPointer:
EvidenceLocation:
GateJobEvidence:
VerdictFound:
BlockedClaimsFound:
BlockedActionsFound:
DoesNotProveFound:
ProofNeedFound:
PacketFound:
NextGateFound:
GateCondition:
Confidence:
GapClass:
RepairSuggestion:
ParentEntityIds:
RowStatus:
DoesNotProve:
```

Levels: ABSENT, NAMED_ONLY, IMPLIED_LOW, IMPLIED_MEDIUM, IMPLIED_HIGH, APPLIED_WEAK, APPLIED_DIGNIFIED, APPLIED_SHADOW, APPLIED_OVERREACH, APPLIED_SWALLOWED_GATE, APPLIED_OUT_OF_ORDER, APPLIED_PACKET_BROKEN, REVIEW_REQUIRED.

`APPLIED_DIGNIFIED` requires lawful signal read, gate-specific job evidence, verdict or route inside authority, blocked claims/actions where needed, proof need where needed, DoesNotProve, next gate or stop condition, no swallowed gate, no out-of-order application, and no unsupported stronger claim.

Gap classes include expected/dignified, expected but absent/named-only/implied/weak/shadow/overreach, not expected but applied, wrong gate, swallowed gate, order damage, packet break, missing DoesNotProve, missing proof need, missing next gate, missing stop condition, source-receipt conflict, review required.

Hard stops: gate name or expected trigger treated as application; APPLIED_DIGNIFIED without gate-job evidence, DNP, proof need, or blocked claims; gate swallows counterweight/Earth/Final Judge; out-of-order application; mutation/doctrine outside mode.

## 9. Pass-Forward Packets

A gate is not complete until it passes forward what later gates must inherit: read signals, blocked claims, open proof, inherited weakness, DoesNotProve, next gate, and stop condition.

Packet law: no packetless handoff; no gate closes if later work inherits from it but no packet is passed; weak packets may not be inherited as dignified.

### Gate Memory Packet

```text
GATE_MEMORY_PACKET
PacketId:
RunId:
SourceSetId:
ObjectId:
AtomId:
SourceEntityId:
PreviousPacketId:
ProducingGate:
ReceivingGate:
GateFamily:
GateCondition:
ActualApplicationLevel:
SignalsRead:
TriggerReason:
Verdict:
ClaimScope:
BlockedClaims:
BlockedActions:
DoesNotProve:
ProofBurden:
NextGate:
NextGateReason:
StopCondition:
InheritedWeakness:
CanBeOverriddenBy:
CannotBeOverriddenBy:
PacketStatus:
ParentEntityIds:
RowStatus:
```

Packet status dictionary: PACKET_CREATED, PASSED_FORWARD, RECEIVED, INHERITED, SUPERSEDED, BLOCKED, CLOSED_BY_EARTH, CLOSED_BY_SATURN, CLOSED_BY_FINAL_JUDGE, PARKED_WITH_RETURN_TRIGGER, LEAVE_BE, CONFLICT_FOUND, DOES_NOT_PROVE_ATTACHED, WEAKNESS_INHERITED.

Gate Receive Cards inherit prior state but do not prove prior truth. Counterweight Packets are required for high-risk gate applications. Supersession Packets are append-only; do not overwrite or delete old packets.

Packet hard stops: packet without producing/receiving gate, prior application/packet, blocked claims, proof burden, next gate, stop condition, DNP; weak packet inherited as dignified; silent overwrite; packet closes Earth proof or Final Judge route without proper authority.

## 10. Claim-Scope / DoesNotProve

Claim-Scope prevents evidence from growing bigger than it is. A hash may prove identity or copy comparison. A receipt may prove the receipt exists and records stated fields. A static check may prove structure. Lineage may prove parentage. Shape may prove required fields. None automatically prove runtime, doctrine, source truth, whole-house readiness, automation safety, mutation authority, or future correctness.

Claim-scope law: every claim must name evidence pointer, supported scope, unsupported stronger claims, blocked claims, proof rung, and DoesNotProve.

### Claim Scope Card

```text
CLAIM_SCOPE_CARD
ClaimId:
RunId:
SourceSetId:
AtomId:
ParentPacketId:
ClaimText:
EvidencePointer:
EvidenceType:
CurrentProofRung:
RequestedProofRung:
SupportedScope:
UnsupportedStrongerClaims:
BlockedClaims:
RequiredUpgradeEvidence:
OwnerGate:
CounterweightGate:
EarthProofNeed:
PacketInheritedFrom:
NextGate:
StopCondition:
RowStatus:
DoesNotProve:
```

Proof rungs: 0 mention, 1 existence, 2 identity, 3 custody, 4 static structure, 5 content review, 6 action authority, 7 action execution, 8 runtime behavior, 9 acceptance, 10 repeated pattern, 11 promotion authority, 12 doctrine. A lower rung may not claim a higher rung.

Evidence types: hash, path, receipt, static verify, source text, web standard, content review, fixture result, small-lab replay, lineage, schema validation, command output, runtime observation, user authority, Final Judge route.

Built-in DoesNotProve templates: hash proves identity only; receipt records fields/status only; static verifies structure only; source text is not truth/action authority; fixture pass is synthetic only; small lab is scoped only; lineage proves parentage only; schema proves structure only; concept group is not doctrine; residue is not junk/treasure; report pack is scoped only.

Overclaim blocks: hash as quality/runtime, receipt as global proof, static as runtime, source as truth, external standard as house doctrine, fixture as real-source ready, small lab as whole house ready, lineage as truth, shape as semantic correctness, concept as doctrine, repair plan as repair complete, finding as mutation authority, final summary as done.

## 11. Concept Court

Concept Court decides whether atoms belong together. Similarity is a witness, not a verdict. Cheap words do not group. Embeddings do not rule. Bridge is not merge. Concept card is not doctrine.

Signature stack: exact hash, normalized hash, shingle, near duplicate, semantic, language, role, gate, route, proof, risk, authority, time, residue signatures.

### Concept Group Court Card

```text
CONCEPT_GROUP_COURT_CARD
GroupCandidateId:
RunId:
SourceSetId:
ProposedName:
MemberAtomIds:
SourceEntityIds:
ProposedBroaderConcept:
ProposedNarrowerConcepts:
IdentityEvidence:
NearDuplicateEvidence:
LanguageEvidence:
SemanticEvidence:
RoleEvidence:
GateSignature:
RouteSignature:
ProofSignature:
RiskSignature:
AuthoritySignature:
TimeSignature:
RelationType:
HardBlockers:
FalseMatchWarnings:
SaturnReview:
NeptuneReview:
EarthEvidence:
CourtVerdict:
ConceptCardCreated:
ResidueCreated:
BridgeCardCreated:
RowStatus:
DoesNotProve:
```

Court order: identity, text family, language, semantic, role, gate, route, proof, risk, authority, time/version, relation, Saturn boundary, Neptune fog/metaphor, Earth evidence, final verdict.

Verdicts: group accepted strong, accepted weak/review, broader/narrower split, related not same, bridge required, contradiction, rejected cheap word, rejected role/proof/authority mismatch, rejected metaphor as mechanism, rejected embedding fog, parked for more cases, escalate to Pluto/Uranus, route to residue.

Concept Card default status is `CANDIDATE_CONCEPT`, never doctrine or active local rule by default. False Group Cards preserve rejected group warning material. Bridge Cards define relation, not merge.

Hard stops: group without member atoms; group accepted from cheap word or embedding alone; role/proof/authority/time mismatch ignored; bridge treated as merge; concept doctrine/active rule by default; residue dropped after rejection; missing DoesNotProve.

## 12. Residue Board

Residue is unplaced signal. It is not trash, automatic treasure, or a new organ by default.

Residue law: ungrouped does not mean useless; failed group does not authorize deletion; every residue must have class, reason, suggested handling, and DoesNotProve; parked residue must have return trigger unless Leave-Be; one residue does not prove a new organ.

### Residue Card

```text
RESIDUE_CARD
ResidueId:
RunId:
SourceSetId:
SourceAtomId:
SourceEntityId:
SourcePath:
LineSpan:
RawTextOrRedactedText:
NormalizedText:
WhyResidue:
FailedGroupCandidates:
FailureType:
CheapWordsInvolved:
PossibleConcepts:
PossibleGate:
PrimaryResidueClass:
SecondaryResidueClass:
Risk:
Value:
SuggestedHandling:
ReturnTrigger:
RequiredCounterweight:
EarthProofNeed:
Status:
RowStatus:
DoesNotProve:
```

Residue classes: false match rejected, orphan concept, bridge required, contradiction review, fog parked, root signal captured, new mechanism candidate, authority spike blocked, room drift, time drift, leave-be.

Routes: false match -> False Group Card; orphan -> park for naming/more cases; bridge -> Bridge Card; contradiction -> review question; fog -> clarify/park; root signal -> Layer Echo + Pluto + Saturn + Earth root review only; new mechanism -> Uranus candidate only; authority spike -> Token Custody + Saturn + Earth; room drift -> Room Domain + Sun + Moon + Saturn; time drift -> Saturn + Moon + Token Custody; leave-be -> close without action.

Missing Organ Candidate is candidate only and does not authorize build, script, automation, doctrine, or source mutation.

Hard stops: residue marked trash, deletion allowed, no class, parked without return trigger unless Leave-Be, new organ from one weak residue, residue as root cause/doctrine proof, hidden residue, missing DNP.

## 13. Lineage / Bone

Lineage preserves parentage. It proves origin and derivation only, not claim truth.

Lineage law: no source without identity; no atom without source; no packet without prior row/application; no claim without evidence pointer; no report without source set; no concept without member atoms and court; no residue without reason.

Ledgers: Entity Ledger, Activity Card, Agent Ledger, Derivation Ledger, Provenance Card, Bill of Trace Materials, Custody Break Finding.

Entity types: source, atom, trace, packet, claim, group, concept, residue, bridge, false group, fixture, report, repair, final.

Activity types: source harvest, manifest build, safety check, atom split, fingerprint build, read-scope apply, expected trigger build, actual application read, trace span, packet, claim-scope court, concept court, residue review, bridge, false group, fixture review/replay, small-lab selection, read-only replay, finding bus, repair plan, proof-of-repair review, report, shape validation, Final Judge.

For this spec and all read-only replay modes: `MutationAllowed: False`.

Hard stops: entity without parent, source without identity, atom without source, trace without atom, packet without prior row, claim without evidence pointer, group without members, concept without court, residue without reason, report without source set, lineage strength used as claim strength, missing DNP.

## 14. Shape Validation

Shape Validation checks structure only. It does not check truth. A valid card is a usable container, not proof of semantic correctness.

Shape law: shape validation proves structure only; shape pass is not semantic truth, runtime proof, doctrine, or final acceptance.

### Shape Validation Card

```text
SHAPE_VALIDATION_CARD
ValidationId:
RunId:
SourceSetId:
ValidatedEntityId:
ValidatedEntityType:
SchemaName:
SchemaVersion:
RequiredFieldsPresent:
MissingFields:
InvalidValues:
CrossCardChecks:
LineageChecks:
ClaimScopeChecks:
DoesNotProveCheck:
InvariantChecks:
ValidationVerdict:
BlockingFindings:
WarningFindings:
RequiredRepair:
NextGate:
RowStatus:
DoesNotProve:
```

Verdicts: SHAPE_PASS, PASS_WITH_WARNINGS, FAIL_MISSING_REQUIRED_FIELD, FAIL_INVALID_VALUE, FAIL_CROSS_CARD_CONFLICT, FAIL_LINEAGE_BREAK, FAIL_DOES_NOT_PROVE_MISSING, FAIL_INVARIANT_BROKEN, REVIEW_REQUIRED. Blocked: TRUTH_PROVEN, RUNTIME_PASS, DOCTRINE_PROMOTED, ACTION_ALLOWED, SOURCE_TRUSTED, CONCEPT_ACCEPTED_AS_LAW, RESIDUE_DELETE_ALLOWED, FINAL_DONE.

Invariants: no atom without source, no trace without atom, no packetless handoff, no claim without evidence, no group without members, no concept without court, no residue without reason, no park without return trigger unless leave-be, no runtime without Earth, no doctrine without promotion, no action without Mars and Saturn, no hash as quality, no receipt as global proof, no static verify as runtime, no group from cheap word, no leftover delete, no final done with open proof, no whole-house crawl in V0.1.

## 15. Fixture Bench F01–F16

Fixtures are synthetic traps before real sources. They do not prove real-source readiness, runtime, doctrine, or whole-house readiness.

Fixture law: synthetic atoms only; expected results locked before replay; pass proves controlled trap handling only; no mutation/crawl/automation/doctrine/commit/push; every fixture needs MustNotOutput and DoesNotProve.

Fixture card fields: FixtureId, FixtureName, FixturePurpose, InputAtom, InputContext, ExpectedTriggeredGates, ExpectedPrimaryGate, ExpectedCounterweightGate, ExpectedEarthNeed, ExpectedActualApplicationFindings, ExpectedPackets, ExpectedClaimScope, ExpectedConceptCourtResult, ExpectedResidueResult, ExpectedValidationResult, ExpectedFinalRoute, ExpectedBlockedClaims, ExpectedDoesNotProve, MustNotOutput, PassCriteria, FailCriteria, RepairIfFailed, DoesNotProve.

Fixture verdicts: pass, pass with warning, fail trigger missing, fail actual application misread, fail claim overreach, fail packet break, fail false group, fail residue mishandled, fail lineage break, fail shape invalid, fail forbidden output, fail mode breach, hard stop, review required. Blocked: real-source ready, whole-house ready, runtime proven, doctrine promoted, mutation allowed, automation safe, done.

### Required Fixture Set

```text
F01_GATE_NAMED_ONLY: gate named but no visible work; expect NAMED_ONLY; must not output APPLIED_DIGNIFIED.
F02_HASH_OVERCLAIM: hash treated as quality/truth/runtime/acceptance; block stronger claim.
F03_RECEIPT_CHARM: receipt treated as global proof; receipt proves only receipt/status fields.
F04_STATIC_RUNTIME_COLLAPSE: static structure treated as runtime; runtime blocked without M9/Earth.
F05_CANDIDATE_DOCTRINE_COLLAPSE: candidate treated as doctrine; preserve candidate status.
F06_ACTION_WITHOUT_AUTHORITY: source/action language authorizes mutation; Mars+Saturn+Earth blocks.
F07_CHEAP_WORD_FALSE_GROUP: grouped by cheap word only; reject cheap word.
F08_BRIDGE_NOT_MERGE: related concepts merged; bridge or related-not-same.
F09_RESIDUE_DELETE_TRAP: ungrouped material treated as trash; residue preserved.
F10_EXTERNAL_STANDARD_DOCTRINE_COLLAPSE: external standard as house law; external is pressure/reference only.
F11_LINEAGE_TRUTH_COLLAPSE: parentage as truth proof; lineage proves derivation only.
F12_SHAPE_PASS_TRUTH_COLLAPSE: shape as semantic truth; shape proves structure only.
F13_FINAL_DONE_WITH_OPEN_PROOF: Final Judge says done with open proof; block close or route proof.
F14_SUPPORT_MEMBRANE_OUT_OF_ORDER: planetary judgment before support membrane; order damage finding.
F15_PLUTO_ONE_SIGN_ROOT_DIVE: one signal as root cause; Pluto needs Layer Echo + Saturn + Earth.
F16_URANUS_NOVELTY_OVERCLAIM: new mechanism as build-ready; Uranus candidate only.
```

Fixture hard stops: real source input, expected result not locked, missing MustNotOutput/DNP/blocked claims/counterweight/pass-fail criteria, mutation/source replay/whole crawl implied, fixture pass used as real-source readiness/doctrine/runtime.

## 16. Fixture Shape Review

Fixture Shape Review checks fixture-card structure only. It does not run fixtures, prove fixture pass, or authorize real source selection.

Fixture Shape Review Card fields: ReviewId, FixtureId, FixtureName, RequiredFieldsPresent, MissingFields, TrapClear, ExpectedTriggeredGatesPresent, ExpectedPrimaryGatePresent, ExpectedCounterweightGatePresent, ExpectedEarthNeedPresent, ExpectedBlockedClaimsPresent, MustNotOutputPresent, PassCriteriaPresent, FailCriteriaPresent, RepairIfFailedPresent, DoesNotProvePresent, ModeBoundaryClean, ForbiddenOutputsBlocked, ReviewVerdict, RequiredRepair, DoesNotProve.

Verdicts: FIXTURE_SHAPE_REVIEW_PASS_FOR_DESIGN, PASS_WITH_WARNINGS, REPAIR_REQUIRED, HARD_STOP, REVIEW_REQUIRED. Blocked: fixture suite passed, ready for real sources, system validated, done.

Every fixture must have fixture identity, purpose, input atom, expected gates, expected primary/counterweight/Earth need, expected blocked claims, expected DNP, MustNotOutput, pass/fail criteria, repair if failed, and DNP.

Legal next action after all pass: request M2 fixture replay transition review. If repairs required, repair fixture cards in M0 or M7. If hard stop, block fixture replay and repair hard stop.

## 17. Fixture Replay Boundary

Fixture Replay is future M2 only and is not authorized by this assembly. It may occur only after Fixture Shape Review passes and a Mode Transition Packet approves M2.

Fixture replay law: synthetic-only; expected results locked before replay; observed compared to locked expected; failures route to Finding Bus; fixture pass may only request Bench-to-Lab review.

M2 Transition Packet must show fixture shape review report, approved fixture IDs, synthetic-only, real source read blocked, mutation blocked, script execution blocked, expected result lock required, authority required, Final Judge approval, transition verdict, and DNP.

Fixture Replay Run Card allows only synthetic atom loading, expected trigger logic, actual application reader, packets, claim scope, concept/residue if required, synthetic lineage, shape validation, observed-vs-expected comparison, and finding routing. It forbids real source read, folder scan, script execution, mutation, commit, push, doctrine, and runtime proof.

Expected Result Lock must be locked before observed replay. Fixture Replay Result Card compares observed gates, application, packets, claim scope, concept/residue, lineage, shape, findings, final route, and forbidden outputs against the lock.

Suite verdicts: fixture suite pass for scope, pass with warnings, fail repair required, hard stop, review required. Blocked: ready for real-source replay, whole-house ready, system validated, runtime proven, doctrine promoted, mutation allowed, done.

## 18. Bench-to-Lab Gate

Bench-to-Lab sits between future fixture replay and future small-lab source selection. Fixture suite pass may unlock M3 source selection review only; it does not unlock M4 source reading, scan, crawl, mutation, automation, doctrine, runtime proof, commit, or push.

Bench-to-Lab Gate Card reviews fixture suite result, fixture shape report, finding bus summary, Final Judge packet, hard stops, open blockers, repair tickets, warnings, DNP completeness, synthetic-only boundary, real-source read status, forbidden outputs, verdict, allowed next mode/action, denied routes, stop condition, and DNP.

Verdicts: denied, repair required, parked, allowed to M3 selection only, review required. Blocked: allowed to M4 replay, source read, scan, mutate, automate, doctrine, done.

To allow M3 only: fixture shape review passed; suite passed for scope or with non-blocking warnings; synthetic boundary confirmed; no real source read, mode breach, forbidden outputs, or hard stops; blockers closed/routed; warnings scoped and non-expansion-blocking; DNP present; Final Judge requests M3 only.

First small lab limits: 3–5 named sources; atom cap 50–120; required source roles are candidate/prior batch export, review receipt/proof pointer, and gate-order source; optional concept/residue, support addendum, lineage proof, final judge source. Forbidden source choices: folder, whole repo, root, all receipts, all related files, binary/archive full-read, script execution target, unknown custody, private/secret-heavy without redaction plan, URL requiring opening.

## 19. M3 Small-Lab Source Selection

M3 selects and manifests sources only. It does not read source content, atomize real material, run replay, scan, crawl, or mutate.

M3 Mode allows selecting 3–5 named source candidates, classifying source roles/kinds/authority/custody, drafting manifest, exclusion ledger, source safety precheck, read-only replay plan, estimating atom cap, and requesting M4 transition. It forbids reading content, URLs, script execution, folder scans, repo/root crawl, atomization, M4 replay, mutation, move/archive/delete/dedupe, commit, push, doctrine, runtime proof.

Small-Lab Selection Card names selection purpose, lab question, source cap, atom cap, roles, forbidden source types, candidate/included/excluded/parked sources, safety prechecks, read-only replay plan need, verdict, next action, and DNP.

Lab Question Card must be bounded. Good questions test named-only vs actual application, overclaim blocking, concept/residue behavior, lineage preservation. Bad questions ask whether the whole system is ready or all files are clean.

Source Candidate Review Row may decide include, exclude, park, requires security review, requires user authority, block unsafe, or leave-be. It may not decide read now, scan folder, open URL, execute script, mutate source, promote doctrine, commit, push, or done.

M3 Manifest boundary: only included named sources are candidates for future M4. Excluded, parked, linked, nearby, related, parent, child, folder, repo, and root sources remain outside scope unless separately selected later.

Source Safety Precheck verdicts: ok for M4 text read-only, ok with redaction, metadata only, hash only, security review, user authority, exclude, block unsafe. Blocked: safe to run, safe to open URL, safe to download, trusted source, doctrine source, mutation allowed.

M3 Final Judge routes to M4 transition review, manifest repair, safety precheck repair, reduce source set, park source selection, block M4, or leave-be.

## 20. M4 Read-Only Replay Transition

M4 transition reviews whether a selected M3 manifest may become a future read-only replay. It does not read sources or run replay.

M4 Transition law: approval authorizes only read-only replay over named manifested sources; it does not prove replay pass or authorize mutation, script execution, URL opening, folder scan, whole-house crawl, automation, doctrine, commit, or push.

Transition Request Card includes M3 final packet, manifest, exclusion ledger, safety prechecks, replay plan, source count, atom cap, included/excluded IDs, forbidden ops, requested read/handling modes, reason, and DNP.

Transition Review Card checks manifest, exclusion ledger, safety prechecks, source cap, atom cap, no folder/root/repo, no script/URL/mutation/doctrine/automation/commit/push, mode boundary, blocked claims, DNP, verdict, and next action.

Verdicts: denied, repair required, security review required, allowed read-only replay, parked, review required. Blocked: source read done, M4 replay passed, whole-house ready, mutation allowed, automation safe, doctrine promoted, done.

M4 Read-Only Replay Run Card allows reading manifested sources according to read/handling modes, redaction, and row creation. It forbids unmanifested read, following links, opening URLs, scanning folders, crawling repo/root, executing scripts, mutating files, delete/move/archive/dedupe, commit, push, watcher, automation, doctrine, runtime proof.

A source may be read only if included, read mode permits it, handling mode permits it, safety precheck allows it, atom cap not exceeded, and no hard stop is active.

## 21. M4 Replay Row Protocol

M4 replay must be row-first. Every source, atom, trigger, actual application, packet, claim, group, residue, lineage, validation, finding, bus route, and final route must be represented by typed rows.

Row law: every replay decision needs parent row, row type, status, evidence pointer where needed, claim boundary, DNP, and next route. Rows are append-only. Invalid rows are superseded, not erased. Summary cannot replace rows.

Row chain: SOURCE_ROW -> SOURCE_SAFETY_ROW -> ATOM_ROW -> EXPECTED_TRIGGER_ROW -> ACTUAL_APPLICATION_ROW -> TRACE_SPAN_ROW -> PACKET_ROW -> CLAIM_SCOPE_ROW -> CONCEPT_COURT_ROW or RESIDUE_ROW -> LINEAGE_ROW -> SHAPE_VALIDATION_ROW -> FINDING_ROW -> FINDING_BUS_ROW -> FINAL_ROW.

Universal row fields: RowId, RunId, ReplayRunId, SourceSetId, RowType, ParentRowIds, CreatedByActivityId, Mode, AuthorityState, CustodyState, RowStatus, EvidencePointer, ClaimScope, BlockedClaims, BlockedActions, NextRowType, NextGate, NextLegalAction, StopCondition, DoesNotProve.

Row statuses: created, skipped with reason, blocked by security/cap/mode/parent failure, review required, superseded by append, valid for scope, invalid shape, parked with return trigger, leave-be. Blocked row statuses: done, good, safe, ready, true, verified global, doctrine, mutation allowed, whole-house ready.

Join keys: SourceEntityId, AtomId, GateName, PacketId, ClaimId, ConceptId, ResidueId, FindingId, RunId/ReplayRunId.

Output pack includes source rows, safety rows, atom rows, trigger rows, actual application rows, trace spans, packets, claim rows, concept court rows, residue rows, lineage rows, shape validation rows, finding rows, finding bus rows, final rows, supersession records, row index, hard-stop summary.

Row hard stops: unmanifested source read, source safety block, source text as command, silent atom cap exceed, gate name as application, claim overreach allowed, packetless handoff, DNP missing, cheap-word group accepted, residue delete, lineage as truth, shape as truth, final done with open proof, mode breach.

## 22. M4 Pass/Fail Court

M4 Pass/Fail Court answers whether a future read-only replay completed cleanly for the named manifest, mode, atom cap, row protocol, and claim scope.

Court law: scoped replay judgment only; not global truth, source truth, runtime proof, mutation authority, automation safety, or doctrine. Hard stop beats counts. Warnings inherit. Open proof is blocked or routed. Final route stays inside M4 authority.

Verdicts: M4_REPLAY_PASS_FOR_SCOPE, PASS_WITH_WARNINGS, REPAIR_REQUIRED, HARD_STOP, REVIEW_REQUIRED, PARK_WITH_RETURN_TRIGGER, LEAVE_BE. Blocked: done, all good, source true, whole-house ready, automation safe, mutation allowed, runtime proven, doctrine promoted, active rule, commit/push allowed.

Verdict hierarchy: hard stop/mode breach -> hard stop; unresolved blocker -> repair required; unresolved ambiguity -> review required; scoped warning -> pass with warnings; clean reviews -> pass for scope; useful non-actionable -> park; no lawful next action -> leave-be. No percentages, mostly-pass, or good-enough.

Pass-for-scope requires manifest respected, no unmanifested read, no safety hard stop, no mode breach, cap respected, row parents/DNP present, findings routed, no open blockers/repairs, warnings scoped/non-blocking, packet chain enough, claim-scope blocks stronger claims, no false group accepted, no residue delete/junk overclaim, no lineage custody break, no shape hard failure, legal Final Judge route, one next action.

Hard stops include unmanifested read, source text obeyed, safety block ignored, script/URL/source mutation/crawl, silent cap exceed, gate name as dignified application, claim overreach, missing DNP on proof token, packetless required handoff, cheap-word concept, residue delete, lineage as truth, shape as truth, candidate doctrine, blocked Final Judge route, mode breach.

## 23. After-M4 Route Gate

After M4, verdicts route; they do not escalate. Pass does not mean crawl. Warning pass does not erase warnings. Repair does not mean edit source. Hard stop does not mean delete/abandon. Review does not mean decide by vibe. Parking is not forgetting. Leave-be is not trash.

After-M4 routes: next bounded lab selection, warning carry-forward, repair planning, hard-stop repair block, review question, parking, leave-be close, review required. Blocked routes: whole-house crawl, mutation, automation, doctrine, runtime proof, cleanup, commit, push, done.

Verdict-to-route map: pass for scope may route to M3 next bounded selection, scoped closeout, or leave-be. Pass with warnings may route only if warnings are inherited and non-blocking. Repair required routes to M7. Hard stop blocks expansion. Review required routes to review question. Park routes to parking ledger with trigger. Leave-be closes under scope.

Every route must produce one Next Legal Action Card and one Carry-Forward Packet preserving warnings, open proof, blocked claims/actions, repair backlog, parked items, expansion boundary, mode boundary, stop condition, and DNP.

Route hard stops: skips Final Judge, multiple next actions, drops warnings/open proof/blocked claims, treats repair ticket as mutation authority, pass as whole-house readiness, concept candidate as doctrine, parked item as forgotten, leave-be as deletion, requests crawl/automation/commit/push, missing DNP.

## 24. Finding Bus

Findings are routed signals. A finding is not proof by itself, not a repair, not action authority, and not mutation authority.

Finding Bus law: every finding must be routed, parked, blocked, closed with scope, or marked leave-be. No finding may authorize mutation, crawl, automation, doctrine, commit, or push. Hard stops remain hard stops. Warnings are scoped. Duplicate findings may be grouped but not erased.

Finding classes: trigger, actual application, packet, claim scope, concept group, residue, lineage, shape, source set, source safety, final route, security surface, room drift, time drift, authority spike, mode boundary, expansion, repair, proof.

Severity: INFO, WATCH, WARNING, REPAIR, BLOCKER, HARD_STOP. Status: NEW, TRIAGED, ROUTED, TICKETED, PARKED, BLOCKED, PROOF_REQUESTED, CLOSED_WITH_SCOPE, LEAVE_BE, REVIEW_REQUIRED. Blocked statuses: done, fixed, ignored, safe, all good.

Routes: repair ticket, proof route, parking with return trigger, residue board, concept update candidate, false group, bridge, lineage repair, shape repair, Final Judge, blocked action ledger, review question, leave-be. Blocked routes: source mutation, crawl, script execution, automation, doctrine, commit, push.

Repair Ticket records a repair need only; it does not authorize mutation or prove repair. Proof Route names needed evidence only; it does not prove the evidence exists or close the claim. Finding Family reduces noise but does not erase child findings.

## 25. Expansion Firewall

Expansion is a controlled state transition. A pass in one mode does not unlock all higher modes. Crawl, watcher, mutation, runtime proof, automation, doctrine, cleanup, commit, and push are separate authority classes. Every expansion requires Final Judge route and mode transition review.

Expansion levels: E0 spec only, E1 fixture design, E2 fixture replay, E3 small-lab selection, E4 read-only replay, E5 reporting/finding routing, E6 repair planning, E7 mutation candidate, E8 mutation authorized, E9 runtime proof candidate, E10 runtime proof authorized, E11 automation design, E12 automation authorized, E13 promotion review, E14 doctrine authorized. Current: E0.

Expansion verdicts: allowed for scope, allowed with warnings, repair required, denied, hard stop, review required, parked with return trigger, leave-be. Blocked: crawl by default, mutation by pass, automation safe by pass, doctrine by pass, whole-house ready, done.

Crawl pressure signs: scan folder/root/repo, read all/everything, find all matching, follow all links, all receipts, all related files, recursive, glob, watch new files. Safe alternatives: 3–5 named sources, one lane excerpt, one receipt family, one concept family, one danger-shape set, expand fixture set, draft manifest, park broad request.

Mutation requires explicit authority, M8, exact target IDs, pre-state evidence, post-state proof plan, rollback/supersession, blocked action ledger, Final Judge. Automation requires design first, explicit M11, trigger, off switch, audit, dry run, rollback, security review, scope cap, Final Judge. Doctrine requires M12/M13, promotion authority, proof history, counterexamples, scope, rollback/supersession, Final Judge.

## 26. Mode Authority Matrix

Mode is authority. Preparation is not permission. A card may request a later mode but cannot grant it.

Mode Matrix: M0 spec defines candidate content only. M1 reviews fixture cards only. M2 runs synthetic fixtures only. M3 selects sources only. M4 read-only replays manifested sources only. M5 reports existing outputs. M6 routes findings. M7 drafts repair plans. M8 performs exact authorized mutation. M9 observes exact runtime proof. M10 designs automation. M11 runs bounded automation. M12 reviews promotion. M13 promotes scoped doctrine with explicit authority.

Authority levels: A0 none, A1 chat spec, A2 fixture review, A3 fixture replay, A4 source selection, A5 read-only replay, A6 reporting, A7 repair planning, A8 mutation, A9 runtime proof, A10 automation, A11 promotion. Current: A1.

Mode Transition Packet records from-mode, requested mode, reason, inputs, blockers, hard stops, inherited warnings, blocked claims/actions, authority required/present, allowed scope, forbidden operations, verdict, Final Judge packet, and DNP.

Smuggling detectors: spec-to-build, fixture-to-real-source, M3-to-M4, M4-to-mutation, report-to-truth, ticket-to-repair, plan-to-proof, mutation-to-runtime, runtime-to-doctrine, concept-to-doctrine, deep-to-crawl, pass-to-done. Any hit creates a finding.

Mode hard stops: operation outside mode, source read in M0/M1/M2/M3, fixture run in M0/M1, real source read in fixture mode, mutation outside mutation mode, script execution outside authority, runtime without M9, automation without M11, doctrine without M13, commit/push without authority, missing mode-boundary DNP.

## 27. Output Report Pack Layout

A report pack is layered reviewable output, not a loose summary. It must include source set, mode, findings, validation, claim scope, final route, and DNP. It may summarize rows but may not replace rows. It may route repair, proof, parking, review, or leave-be. It may not authorize mutation, crawl, automation, doctrine, cleanup, commit, or push.

Report pack shape:

```text
HOUSE_SEMANTIC_NERVOUS_SYSTEM_REPORT_PACK_<RunId>/
00_READ_ME_FIRST.md
01_RUN_CARD.md
02_MODE_AUTHORITY_CARD.md
03_SOURCE_SET_MANIFEST.md
04_EXCLUSION_LEDGER.md
05_SOURCE_SAFETY_REPORT.md
ATOMS/
TRACES/
PACKETS/
CLAIMS/
CONCEPTS/
RESIDUE/
LINEAGE/
VALIDATION/
FINDINGS/
FINAL/
RECEIPTS/
```

Required ledgers: atoms, expected trigger rows, actual application rows, trace spans, packets, claim scope, concept court/cards/false groups/bridges, residue/return triggers, entity/activity/derivation ledgers, validation cards, raw findings, finding bus packets, repair tickets, proof routes, Final Judge packet, hash manifest.

Read order: read me first, Final Judge, Finding Bus, raw findings, validation, claims, packets, actual application, expected triggers, atoms, manifest/exclusions.

Hash manifest proves identity/copy comparison only. Report hard stops: missing mode/source/DNP/Final Judge, summary replaces rows, hash as truth, receipt as global proof, omitted warnings/hard stops/open proof/blocked claims/repair backlog, Final Judge says DONE, report claims mutation/doctrine/runtime/whole-house readiness.

## 28. Repair Planning

Repair planning converts findings and tickets into bounded plans. It does not perform repair, edit files, rewrite active guides, run scripts, or mutate source.

Repair law: repair ticket is not authority; repair plan is not execution; proof plan is not proof; repair planning may name targets, forbidden operations, proof needs, risks, and mode transition requests; it may not mutate, execute, commit, push, automate, or promote doctrine.

M7 allows reading repair tickets, grouping repair families, drafting repair plans, naming targets/forbidden ops, drafting proof-of-repair plans, risk cards, blocked-action ledgers, transition requests, validation, and Final Judge route. It forbids editing files, active-guide rewrite, running scripts, deleting residue, move/archive/dedupe, unmanifested source read, scan, crawl, commit, push, watcher, doctrine, repair-completed claim.

Repair plan must include plan ID, findings/tickets, failure shape/evidence, target type/IDs, current state, proposed repair, future allowed edits, forbidden edits, required execution mode/authority, gates, Earth proof need, proof plan, risks, rollback/supersession, stop condition, verdict, and DNP.

Allowed targets in planning: spec section, card schema, field, verdict dictionary, DNP template, expected trigger dictionary, actual application rule, packet rule, claim-scope rule, concept court, residue board, lineage, validation, finding bus, Final Judge, report layout, fixture card/expected result, M3 manifest, M4 row protocol/court, After-M4 route rule. Later authority required for real source file, active guide, script/tool code, repo structure, runtime config, watcher config, automation task, public repo, commit history.

Proof-of-repair plan names repair claim, current proof, required proof, proof method, expected evidence, required mode, fixture/shape/replay/Earth needs, pass/fail criteria, blocked proof claims, stop condition, DNP.

Repair hard stops: ticket as mutation authority, plan as completed repair, proof plan as proof, family erases child tickets, target all files, scope whole house, script execution, active-guide rewrite without authority, commit/push, doctrine, residue delete, missing DNP.

## 29. Proof-of-Repair Court

Proof-of-repair checks whether a completed repair actually closed the finding it claimed to close. It is not the repair, repair plan, diff, or hash.

Proof law: repair is not proven until the repair-specific proof method closes the original finding without creating a stronger overclaim. A repair plan is not repair. Repair execution is not proof. A diff is not correctness. A hash is not repair proof. Shape pass is not semantic truth. Fixture pass is not real-source readiness. Proof-of-repair closes only named findings/tickets under named proof scope.

Required evidence: original finding, repair ticket, repair plan, proof plan, authorized execution record if mutation/build/edit occurred, before evidence, after evidence, proof method result, regression check, claim-scope recheck, child ticket review if family exists, DNP index, Final Judge packet.

Verdicts: repair proven for scope, proven with warnings, not proven, partially proven, created regression, proof method mismatch, hard stop, review required, parked, leave-be. Blocked: fixed, done, all good, runtime proven, source true, whole-house ready, automation safe, doctrine promoted, mutation allowed, commit/push allowed.

Proof method match: shape validation closes schema failures only; fixture replay closes controlled traps only; bounded replay closes source-set replay behavior only; claim-scope recheck closes overclaim only if stronger claims remain blocked; packet recheck closes packet break only if next gate, stop condition, proof burden, and DNP are present; runtime proof requires separate authority.

Hard stops: repair execution without authority, target changed outside scope, missing proof method, mismatched method with stronger closure, DNP removed, overclaim introduced, runtime claimed without M9, doctrine promoted from repair, source truth claimed, child tickets closed without review, history deleted, rows overwritten silently, Final Judge says DONE, commit/push claimed without authority.

## 30. Final Judge Rules

Final Judge closes scoped routes. It does not invent proof, override missing evidence, promote doctrine, authorize mutation unless current mode/authority allow it, turn a report into truth, or turn a pass into whole-house readiness.

Final Judge law: Final Judge may close only scoped claims supported by packets, evidence, mode authority, and Earth proof or named proof gap. It must name closed claims, open claims, blocked claims, blocked actions, warnings, hard stops, next legal action, stop condition, and DNP. It may not use blocked verdict words, skip mode authority, or close open proof by summary.

Final Judge Packet fields: FinalJudgePacketId, RunId, ActiveObject, DeclaredMode, SourceSetId, InputPackets, InputClaims, InputFindings, InputValidation, InputLineage, InputProof, PrimaryGate, CounterweightGate, EarthEvidenceOrProofGap, ClosedClaims, OpenClaims, BlockedClaims, BlockedActions, Warnings, HardStops, RepairBacklog, ProofRoutes, ParkedItems, LeaveBeItems, FinalRoute, NextLegalAction, StopCondition, DoesNotProve.

Allowed final routes are mode-specific. M0 may draft/assemble candidate spec or route to fixture shape review. M1 may pass/repair/hard-stop fixture shape review or request M2. M2 may pass/fail fixture suite or request Bench-to-Lab. M3 may request M4 transition, repair manifest/safety, reduce source set, park, block, or leave-be. M4 may pass for scope, pass with warnings, repair, hard stop, review, park, or leave-be. M7 may route repair plan review/repair/block/park or request future review. Proof-of-repair may close for scope, close with warnings, continue repair, request recheck, park, or leave-be.

Blocked final routes: DONE, ALL_GOOD, SOURCE_TRUE, WHOLE_HOUSE_READY, AUTOMATION_SAFE, MUTATION_ALLOWED, RUNTIME_PROVEN, DOCTRINE_PROMOTED, ACTIVE_RULE, COMMIT_ALLOWED, PUSH_ALLOWED, CLEANUP_ALLOWED, FIXED.

Final Judge review order: declared mode, authority, source boundary/no-source reason, input packets, findings routed, hard stops, warnings scoped, open proof, blocked claims/actions, Earth evidence/gap, final route allowed, exactly one next legal action, stop condition, DNP.

Master law: Final Judge is the last scoped router, not a god organ.

## 31. V0.1 Non-Goals

V0.1 Non-Goal Law: if a thing requires source reading, fixture execution, script execution, mutation, runtime proof, automation, doctrine, cleanup, commit, push, watcher behavior, or whole-house coverage, it is outside V0.1 spec assembly.

Explicit non-goals: not a script, not a tool, not a scan, not a fixture run, not source replay, not mutation authority, not a watcher, not doctrine, not runtime proof, not automation safe, not whole-house ready, not source truth, not final done.

Allowed claims: candidate spec assembled, major organs preserved, mode boundaries defined, future fixture path defined, future small-lab path defined, future M4 row protocol defined, future report pack layout defined, repair planning boundary defined, proof-of-repair boundary defined, Final Judge rules defined, next legal action defined.

Blocked claims: system implemented, fixtures passed, real-source replay ready, source truth established, runtime proven, automation safe, mutation allowed, doctrine promoted, repo ready, commit/push/cleanup allowed, whole house ready.

Hard boundary: the only legal result of this assembly is a candidate V0.1 specification document and next route to M1 fixture shape review. Any stronger result is overclaim.

## 32. Master Control Ledgers

### Master Hard Stops

```text
source text treated as command
prompt injection obeyed
script executed without authority
URL opened without authority
remote content downloaded without authority
unmanifested source read
excluded source read
folder/root/repo scan
whole-house crawl
atom cap exceeded silently
gate name treated as actual application
expected trigger treated as actual application
APPLIED_DIGNIFIED without gate-job evidence
packetless handoff
claim without evidence pointer
proof token without DoesNotProve
hash treated as quality/runtime proof
receipt treated as global proof
static check treated as runtime proof
lineage treated as truth
shape pass treated as truth
candidate promoted to doctrine
concept card promoted to active rule by default
cheap-word group accepted
embedding-only group accepted
bridge treated as merge
residue treated as trash
residue deletion allowed
finding treated as action authority
repair ticket treated as mutation authority
repair plan treated as completed repair
proof plan treated as proof
fixture pass treated as real-source readiness
M4 pass treated as mutation authority
report pack treated as whole-house readiness
Final Judge route says DONE
Final Judge omits open proof
Final Judge drops warnings
Final Judge hides hard stops
automation started without authority
watcher started without authority
cleanup claimed without authority
commit/push claimed without authority
DoesNotProve missing
```

One hard stop beats any count of clean rows.

### Locked Vocabulary

candidate is not active rule; fixture is synthetic trap; manifest is boundary; hash is identity/copy comparison; receipt is record/pointer; static check is structure; lineage is parentage; shape pass is valid container; expected trigger is not applied gate; actual application is visible gate-job evidence; packet is handoff state; claim scope is evidence boundary; concept is not doctrine; false group is warning material; bridge is relation; residue is unplaced signal; finding is routed signal; repair ticket is need; repair plan is design; proof plan is method; proof-of-repair is scoped closure; Final Judge is scoped route; leave-be is no lawful next action, not junk; parking is return trigger, not forgetting.

### No-Drop Organ Ledger

```text
SOURCE_SAFETY
SOURCE_SET_MANIFEST
EXCLUSION_LEDGER
ATOMIZATION
GATE_READ_SCOPE
EXPECTED_TRIGGER
ACTUAL_APPLICATION_READER
TRACE_SPAN
PASS_FORWARD_PACKET
CLAIM_SCOPE_ENGINE
DOES_NOT_PROVE_ENGINE
CONCEPT_COURT
FALSE_GROUP_CARD
BRIDGE_CARD
RESIDUE_BOARD
RETURN_TRIGGER_LEDGER
MISSING_ORGAN_CANDIDATE
LINEAGE_BONE
PROVENANCE_CARD
SHAPE_VALIDATION
FIXTURE_BENCH
FIXTURE_SHAPE_REVIEW
FIXTURE_REPLAY_BOUNDARY
BENCH_TO_LAB_GATE
M3_SOURCE_SELECTION
M4_TRANSITION_GATE
M4_REPLAY_ROW_PROTOCOL
M4_PASS_FAIL_COURT
AFTER_M4_ROUTE_GATE
FINDING_BUS
EXPANSION_FIREWALL
MODE_AUTHORITY_MATRIX
OUTPUT_REPORT_PACK
REPAIR_PLANNING
PROOF_OF_REPAIR_COURT
FINAL_JUDGE
```

If an organ is removed, the assembly must warn: `HEY — don’t drop stuff!` Then it must name the reason, risk, return trigger, and DoesNotProve.

### Appendix Ledger

Appendices A-Z preserve canonical fields, verdict dictionaries, DNP templates, gate contracts, support/planet trigger dictionaries, actual application examples, packet schemas, proof rungs, concept court blockers, residue classes, lineage model, shape invariants, fixture cards, fixture review/replay, Bench-to-Lab, M3/M4 protocols, finding bus, expansion firewall, mode matrix, source safety, report pack, repair planning, and proof-of-repair. Appendix means preserved toolbelt, not trash drawer.

### Duplicate-Control Ledger

Allowed: merge repeated DNP wording into templates, move repeated verdict dictionaries to appendices, replace repeated hard-stop lists with master hard stops, compress examples if preserved, cross-reference sections. Forbidden: delete an organ because repeated, delete a hard stop because it appears elsewhere, delete DNP because obvious, delete fixtures as examples, delete residue because future work, delete repair/proof because not current mode.

### Master Build Order

```text
1. Assemble V0.1 candidate spec document.
2. Run No-Drop Organ Ledger check.
3. Run Duplicate-Control check.
4. Run DoesNotProve presence check.
5. Run blocked-verdict-word check.
6. Run mode-authority check.
7. Run fixture-card shape review on F01-F16.
8. Repair fixture cards if shape review fails.
9. Only after fixture shape review passes, request M2 fixture replay transition.
10. Only after future fixture replay passes, request Bench-to-Lab Gate.
11. Only after Bench-to-Lab opens, prepare M3 source selection.
12. Only after M3 manifest passes, request M4 read-only replay transition.
13. Only after M4 pass/fail court closes, route through After-M4 Gate.
14. If repair needed, draft M7 repair plan.
15. If repair later executes under proper authority, run Proof-of-Repair Court.
16. Never skip Final Judge.
```

No implementation before spec assembly and fixture shape review.

## 33. Final Next Legal Action

### Final Candidate Spec Status

```text
ActiveObject:
HOUSE_SEMANTIC_NERVOUS_SYSTEM_READ_ONLY_SPEC_V0_1

SpecStatus:
CANDIDATE_SPEC_ASSEMBLED_AS_MARKDOWN_FILE

DocumentStatus:
READY_FOR_M1_FIXTURE_SHAPE_REVIEW_PREP

CurrentMode:
M0_SPEC

DoctrineStatus:
NOT_DOCTRINE

ImplementationStatus:
NO_SCRIPT / NO_TOOL / NO_REPLAY / NO_AUTOMATION

SourceStatus:
NO_SOURCE_READ

FixtureStatus:
FIXTURES_DEFINED_NOT_RUN

ReplayStatus:
NO_M4_REPLAY

RepairStatus:
NO_REPAIR_EXECUTION

AuthorityStatus:
A1_CHAT_SPEC_AUTHORITY_ONLY
```

### Final Judge Closeout Packet

```text
ClosedClaims:
A01-A08 candidate spec assembly drafted the V0.1 nervous-system architecture.
Major organs are preserved in the No-Drop Organ Ledger.
Core mode boundaries are defined.
Future fixture path is defined.
Future small-lab path is defined.
Future M4 row protocol and pass/fail court are defined.
Finding Bus, Expansion Firewall, Repair Planning, Proof-of-Repair, and Final Judge are defined.
Forbidden-overclaim seal is defined.
One next legal action is selected.

OpenClaims:
fixture shape review passed
fixture replay passed
small-lab source selection approved
M4 transition approved
M4 read-only replay passed
repair execution occurred
proof-of-repair occurred
runtime behavior
automation safety
doctrine
mutation authority
whole-house readiness
commit authority
push authority
future correctness

BlockedClaims:
file assembly = implementation
file assembly = doctrine
file assembly = fixture pass
file assembly = source replay
file assembly = runtime proof
file assembly = automation safety
file assembly = mutation authority
file assembly = whole-house readiness
file assembly = done forever

FinalRoute:
CANDIDATE_SPEC_READY_FOR_M1_FIXTURE_SHAPE_REVIEW_PREP

NextLegalAction:
BEGIN_M1_FIXTURE_SHAPE_REVIEW_PREP_OVER_F01_F16
```

### Next Legal Action Card

```text
NextAction:
BEGIN_M1_FIXTURE_SHAPE_REVIEW_PREP_OVER_F01_F16

RequiredMode:
M1_FIXTURE_DESIGN_REVIEW

InputNeeded:
F01-F16 fixture cards from this candidate spec

OutputExpected:
FIXTURE_SHAPE_REVIEW_REPORT

ForbiddenDuringNextAction:
fixture replay
real source reading
source atomization
file scan
whole-house crawl
script execution
source mutation
active-guide rewrite
automation
doctrine promotion
cleanup
commit
push
runtime proof claim

StopCondition:
Each F01-F16 fixture card is reviewed for required fields, trap clarity, expected gates, expected counterweight, expected blocked claims, MustNotOutput, pass/fail criteria, RepairIfFailed, mode boundary, and DoesNotProve.

DoesNotProve:
M1 fixture shape review prep will prove only fixture-card structural review status. It will not prove fixture pass, real-source readiness, runtime behavior, automation safety, mutation authority, doctrine, commit authority, push authority, or whole-house readiness.
```

---

## Assembly Receipt

```text
FILE_ASSEMBLY_PASS_F01_COMPLETE

FileName:
HOUSE_SEMANTIC_NERVOUS_SYSTEM_READ_ONLY_SPEC_V0_1.md

InputBasis:
A01-A08 chat assembly batches derived from R01-R33 research rope.

OutputStatus:
CANDIDATE_SPEC_MARKDOWN_FILE_CREATED

NoDropOrganLedger:
PRESENT

ForbiddenOverclaimSeal:
PRESENT

FinalJudgeCloseout:
PRESENT

NextLegalAction:
BEGIN_M1_FIXTURE_SHAPE_REVIEW_PREP_OVER_F01_F16

DoesNotProve:
This receipt proves only that a candidate Markdown artifact was assembled in the sandbox. It does not prove implementation, fixture pass, real-source replay, source truth, runtime behavior, automation safety, mutation authority, doctrine, commit authority, push authority, or whole-house readiness.
```

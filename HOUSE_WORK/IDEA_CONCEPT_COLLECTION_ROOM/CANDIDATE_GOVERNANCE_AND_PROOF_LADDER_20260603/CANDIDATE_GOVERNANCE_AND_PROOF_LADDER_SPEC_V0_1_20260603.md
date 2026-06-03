# Candidate Governance And Proof Ladder Spec V0.1 - 20260603

Status: CANDIDATE_PROCESS_SPEC / NOT DOCTRINE / NOT ACTIVE RULE / NO IMPLEMENTATION
Source: C:\Users\13527\Desktop\123\mulenotes.txt
SourceSHA256: 6396285B91ED5B6FEA1558806866104EB3DF80F3912B8DB966F55B66D1027891

## Purpose

The house does not only intake files. It also intakes ideas, source lanes, rules, concepts, mechanisms, tool patterns, UI patterns, mule findings, proof methods, error lessons, outside research, user corrections, and assistant observations.

This spec gives those non-file candidates a front door before they become saved, parked, promoted, used, or built.

Core law from source:

```text
No found idea becomes authority from being interesting.
```

Clean route:

```text
FOUND -> SOURCED -> BOUNDED -> FITTED -> PROVEN -> EVALUATED -> DECIDED -> TRACEABLE -> SAVED/PARKED/PROMOTED
```

Blocked route:

```text
FOUND -> GOOD -> USE IT
```

Source anchors: mulenotes.txt:4523-4601.

## Candidate Classes

| Class | Meaning | Examples |
|---|---|---|
| SOURCE_LANE | outside source or influence | Wolfram, Fairlight, NIST, ADR, W3C PROV |
| MECHANISM_CANDIDATE | mechanism extracted from source or house work | traceability ledger, maturity ladder, proof selector |
| RULE_CANDIDATE | possible behavior/project rule | no promotion without traceability |
| TOOL_PATTERN | future script/tool shape | read-only wash card, source-map generator |
| PROCESS_PATTERN | repeatable work method | mule return review order |
| UI_PATTERN | visual/control idea | command cockpit page surface |
| ERROR_LESSON | lesson from failure | missing hash proof, unreviewable return |
| PROOF_METHOD | way to prove | traceability proof, refusal proof, comparison proof |

Source anchor: mulenotes.txt:4603-4697.

## Master Ladder

```text
FOUND_SIGNAL
SOURCE_SEARCH_MAP
CANDIDATE_INTAKE_CARD
EVIDENCE_QUALITY_GATE
CLAIM_BOUNDARY_CARD
OVERCLAIM_BLOCKER_CARD
DISCONFIRMATION_CARD
TESTABLE_HYPOTHESIS_CARD
SUIT_FIT_GATE
HOUSE_FIT_SCORECARD
CONTAMINATION_RISK_CARD
TINY_PROOF_PATTERN_SELECTION
TINY_BOUNDED_PROOF_CONTRACT
TINY_BOUNDED_PROOF_RESULT
EVALUATION_GATE
VERDICT_CARD
DECISION_RECORD / ADR_CARD
TRACEABILITY_LEDGER_ROW
DISPOSITION_GATE
MATURITY_TRANSITION_CARD
SAVE / PARK / PROMOTE CANDIDATE
HUMAN_REVIEW_COCKPIT
```

Source anchor: mulenotes.txt:4572-4601.

## Gate Summary

| Gate | Required question | Required output |
|---|---|---|
| Source Search Map | Where did this come from and what proof/citations exist? | `CANDIDATE_SOURCE_MAP` |
| Candidate Intake | What kind of candidate is this? | intake card |
| Evidence Quality | How strong and direct is the evidence? | evidence level/card |
| Claim Boundary | What does it claim and not claim? | claim/nonclaim card |
| Overclaim Blocker | What is the maximum allowed claim? | overclaim risk card |
| Disconfirmation | What would make it fail, park, or downgrade? | success/failure/kill/park/watch conditions |
| Testable Hypothesis | What observable result would prove value? | hypothesis card |
| Suit Fit | Does it fit the current house problem safely? | fit verdict and scorecard |
| Contamination Risk | Does it add bloat, authority leak, or analogy pressure? | contamination card |
| Tiny Proof | What is the smallest proof? | proof contract and result |
| Evaluation | Did result match prewritten conditions? | evaluation card |
| Verdict | What route is legal? | verdict card |
| Decision Record | Why was this route chosen? | ADR-style card |
| Traceability | Can we dig back later? | source -> proof -> verdict -> file/receipt row |
| Disposition | Save, park, promote, block, reject, or next proof? | disposition card |
| Maturity | What proof-backed stage is it at? | maturity transition |
| Cockpit | Can the user verify quickly? | one-page map, manifest, receipt, proof checklist |

## Candidate Source Map

Every major candidate starts with a source map before fit testing.

Minimum fields:

```text
CandidateId
CandidateName
CandidateType
RawSource
SearchTerms
SourceClassesChecked
IncludedSources
RejectedSources
CitationsOrLocalProofPointers
RawClaim
ExtractedClaim
NonClaims
EvidenceLevel
EvidenceGaps
BiasOrContaminationRisks
NextRequiredGate
DoesNotProve
StopLine
```

Source anchors: mulenotes.txt:271-389, mulenotes.txt:545-647.

## Evidence Level

Use a staged evidence/maturity discipline. Do not treat a citation, local note, hash, or one proof as operational authority.

Evidence ladder:

```text
E0_UNSOURCED_SIGNAL
E1_LOCAL_SOURCE_ONLY
E2_SOURCE_CLUE
E3_SECONDARY_SOURCE
E4_PRIMARY_OR_CANONICAL_SOURCE
E5_LOCAL_PROOF_ONCE
E6_REPEATED_OR_INDEPENDENT_PROOF
E7_SAVE_READY_EVIDENCE
E8_ACTIVE_LOCAL_EVIDENCE
E9_DOCTRINE_CANDIDATE_EVIDENCE
```

This package records external citations from `mulenotes.txt` as source-provided references, not independently reverified citations.

Source anchor: mulenotes.txt:389-507.

## Claim Boundary And Overclaim

Before proof, every major candidate must state:

```text
RawClaim
ExtractedClaim
HouseTranslation
KnownNonClaims
BlockedInterpretations
EvidenceRequired
EvidenceThatWouldWeakenOrBlock
ClaimScope
TruthScope
AuthorityScope
ImplementationScope
DoesNotProve
StopLine
```

Overclaim types to block:

```text
source overclaim
authority overclaim
implementation overclaim
proof overclaim
analogy overclaim
maturity overclaim
confidence overclaim
citation overclaim
```

Source anchors: mulenotes.txt:782-1155, mulenotes.txt:1716-1731.

## Disconfirmation And Hypothesis

Every proof plan must define:

```text
success_condition
failure_condition
kill_condition
park_condition
watch_condition
```

Hypothesis format:

```text
We believe [candidate mechanism] will improve [specific house problem] because [reason].
We will know this is true if [observable proof] happens under [allowed constraints] without [blocked harm].
```

Source anchors: mulenotes.txt:1209-1439.

## Suit Fit And Contamination

The Suit Fit Gate answers whether the candidate helps the current house rather than merely being interesting.

Scorecard dimensions:

```text
Active Problem Fit
Mechanism Clarity
Claim Boundary Quality
Evidence Quality
Proofability
Safety / Boundary Fit
Reviewability
Bloat Load
Authority Risk
Timing Fit
Reversibility
Local Proof Fit
```

Hard rule: any `BLOCK` in safety, authority, proofability, or reviewability blocks progression.

Contamination types include bloat, analogy pressure, authority leakage, proof bypass, UI glamour, source worship, and hidden automation pressure.

Source anchors: mulenotes.txt:1773-2586.

## Tiny Proof And Evaluation

A Suit Fit pass authorizes only one selected tiny proof pattern, not implementation or active use.

Tiny proof patterns:

```text
SOURCE_FIT_TEST
RULE_FIT_CARD
ROUTE_EXAMPLE_PROOF
COMPARISON_PROOF
READ_ONLY_TOOL_PROOF
REFUSAL_SAFETY_PROOF
TRACEABILITY_PROOF
HUMAN_REVIEW_PROOF
PARKING_PROOF
```

Before proof, write a proof contract. After proof, evaluate actual results against prewritten success/failure/kill/park/watch conditions.

Source anchors: mulenotes.txt:2337-2555, mulenotes.txt:2631-3072.

## Verdicts

Use one route verdict:

```text
PASS_AS_CANDIDATE
PASS_WITH_WATCH
NEEDS_SOURCE_WASH
NEEDS_CLAIM_REPAIR
NEEDS_TINY_PROOF
PARK
BLOCK
REJECT_WITH_REASON
PROMOTE_TO_SAVE_GATE
```

Source anchor: mulenotes.txt:3072-3271.

## Decision Record And Traceability

Every major accepted, parked, blocked, rejected, or promoted candidate needs an ADR-style decision record:

```text
DecisionId
CandidateId
Context
Decision
AlternativesConsidered
WhyAcceptedOrRejected
Consequences
Status
ProofLinks
SupersessionCondition
DoesNotProve
StopLine
```

Traceability row:

```text
CandidateId
SourceRefs
ClaimBoundaryRef
HypothesisRef
ProofContractRef
ProofResultRef
EvaluationRef
VerdictId
DecisionRecordRef
Disposition
SavedPathOrParkedPath
ReceiptRef
NextLegalAction
```

Source anchors: mulenotes.txt:3271-3522.

## Maturity Levels

```text
M0_RAW_SIGNAL
M1_SOURCED_SIGNAL
M2_BOUNDED_CLAIM
M3_HYPOTHESIS_READY
M4_FIT_CANDIDATE
M5_TINY_PROOF_PASSED
M6_REPEATED_WITH_WATCH
M7_SAVE_READY_CANDIDATE
M8_ACTIVE_LOCAL_RULE_OR_TOOL
M9_DOCTRINE_CANDIDATE
```

Rule: a candidate can move only one maturity step at a time unless prior proof records support the skipped steps.

Source anchors: mulenotes.txt:3751-3915.

## Disposition

Disposition is not promotion. After verdict, choose one:

```text
SAVE_AS_SOURCE_LANE
SAVE_AS_CANDIDATE_SPEC
PARK_WITH_REOPEN_TRIGGER
PROMOTE_TO_NEXT_PROOF
PROMOTE_TO_SAVE_GATE
PROMOTE_TO_IMPLEMENTATION_PLANNING
BLOCK_WITH_REASON
REJECT_WITH_REASON
```

Source anchors: mulenotes.txt:3616-3751.

## Human Review Cockpit

Long missions close with a cockpit:

```text
ONE_PAGE_REVIEW_MAP
FINAL_VERDICT
FILE_MANIFEST
RECEIPT
ADDENDUM_INDEX
CHANGE_LEDGER
OPEN_QUESTIONS
PROOF_CHECKLIST
FULL_SPEC if needed
```

Source anchor: mulenotes.txt:4161-4279.

## Clock-Vs-Work Calibration

Elapsed time is context, not proof. A short run can be valid if the manifest, source inventory, exact staged set, protected scan, receipt, and final sentinel pass. A long run can still fail if it widens scope, skips citations, or treats narrative confidence as authority.

Rule:

```text
Clock reports cost.
Work proof reports readiness.
If clock pressure reduces proof, downgrade to PASS_WITH_WATCH or BLOCK_WITH_REASON.
```

## DoesNotProve

This spec does not prove the candidate-governance ladder is correct, active, complete, doctrine, or implementation-ready. It preserves a candidate process spec for review and future proof.

## StopLine

Do not implement, promote doctrine, mutate pointer state, activate tools, create watcher/automation, edit protected guides, run cleanup, or treat any candidate as active authority from this spec. Use it first as a candidate review method with explicit proof and receipt.

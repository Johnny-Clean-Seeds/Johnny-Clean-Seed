# Frame-to-Script Candidate System — Final Review

Date: 2026-05-30
Status: SUPPORT CONCEPT / READY FOR CONTRACT TEMPLATE / NOT PROMOTED
Authority: not doctrine, not ACTIVE_GUIDES, not CURRENT_TRUTH_INDEX

## Suit lock

A file does not make a script.
A frame requests a candidate artifact.
A key routes the frame.
Ledger/map orders, limits, and places the route.
Policy allows or blocks the candidate plan.
A helper writes a candidate only when the frame permits it.
Code Gate tests the candidate.
Proof and placement decide whether it becomes usable.
Nothing auto-runs.

## Definition

The Frame-to-Script Candidate System is a bounded artifact-production system.

It lets a properly framed file request a `.ps1` or `.cmd` candidate in a controlled way, without turning the file into a command, the key into authority, the candidate into a tool, or Code Gate PASS into job PASS.

Safe means framed, bounded, keyed, placed, policy-checked, proof-bound, Code-Gate routed, handoff-ready, and join-back aware.

Safe does not mean frozen, powerless, or paranoid.

## Top-level law

Frames do not run.
Frames request candidate artifacts.
Candidates do not run.
Candidates request Code Gate.
Code Gate does not prove the job.
Code Gate proves script shape, risk, parser, and probe conditions.
Job proof comes only from bounded run result, receipt, and Final Judge.
Placement decides whether the candidate stays one-off, parks, or becomes a tool candidate.

## Three-object separation

Frame:
the contract. It declares intent, authority, allowed inputs, allowed outputs, blocked actions, template, proof, placement, handoff, neighbor frames, and stop condition.

Candidate:
the artifact proposal. It may be a `.ps1`, `.cmd`, or no-script decision. It is not runnable until routed.

Tool:
a candidate that passed Code Gate, produced proof, received placement decision, and has an operator-approved use route.

Blocked jumps:

- frame to execution;
- key to execution;
- candidate to active tool;
- Code Gate PASS to job PASS;
- proof from one root to proof for all roots;
- branch proof to whole-vine proof.

## Pattern imports

Nix-style declared inputs and outputs:
the frame must declare materials and products before a candidate is written.

Bazel-style bounded action:
the candidate belongs in a candidate/quarantine lane with declared reads and writes, not the live house.

OPA-style policy separation:
the frame/policy decides whether the candidate plan is allowed before helper writes anything.

SLSA/in-toto-style provenance:
candidate artifacts need material/product/helper/policy/template proof.

PowerShell static checks:
parser success is not enough; `.ps1` and `.cmd` candidates need static shape and execution-boundary review.

## Required frame contract sections

Identity:
FrameId, FrameVersion, FrameType, ObjectKey, SourceHash, WorkKey, ParentFrame, LaneOwner, CreatedBy, CurrentState, MaturityState, CreatedAt, LastUpdated, Supersedes, SupersededBy.

Intent:
JobName, ProblemStatement, AllowedOutcome, NonGoals, OneNextAction, StopCondition, SuccessDefinition, FailureDefinition.

Authority:
AllowedRoots, AllowedReads, AllowedWrites, BlockedRoots, BlockedActions, RequiresOperatorApproval, RequiresCodeGate, RequiresProofBeforeUse, MaxFiles, MaxDepth, MaxWrites, MaxRuntime, MaxOutputSize, AllowedNetwork, AllowedGit, AllowedMoveDelete, AllowedSystemTouch.

Inputs:
InputFiles, InputHashes, InputKinds, RequiredInputs, OptionalInputs, ForbiddenInputs, SourceCustody, RawSourcePolicy, ParameterSchema, SanitizationRules, PathNormalizationRules.

Outputs:
OutputFiles, OutputFolder, OutputNamingRule, ReceiptRequired, HashManifestRequired, CopyBackRequired, NoOutputMeansFailure, ExpectedFinalMessage, AllowedSideEffects, NoSideEffectsOutside.

Policy:
PolicyId, PolicyVersion, AllowedScriptTypes, BlockedPatterns, ApprovalThreshold, RiskClass, DecisionRules, FailureRules, EscalationRules, OperatorApprovalTriggers.

Template:
AllowedTemplateFamilies, TemplateId, TemplateVersion, TemplateHash, TemplateSource, RequiredHeader, RequiredFunctions, BlockedFunctionNames, OutputContractRequired.

Candidate:
CandidateType, CandidatePath, CandidateLane, GeneratedBy, GeneratedFromFrame, TemplateUsed, CandidateHash, CodeGateRequired, StaticCheckRequired, RiskClass, NotRunnableUntil, CandidateExpiry, CandidateStatus.

Code Gate:
ParserRequired, StaticShapeRequired, PSScriptAnalyzerRecommended, RiskScanRequired, ProbeModeRequired, AllowGitWritesAllowed, AllowDeleteAllowed, AllowNetworkAllowed, AllowedDirectRun, ProofRequiredAfterRun, CodeGateReportPath.

Provenance:
FrameId, SourceHash, TemplateHash, HelperActor, GeneratedAt, CandidateHash, Dependencies, PolicyVersion, CodeGateReport, Receipt, Materials, Products, BuilderOrHelper, EnvironmentNote.

Placement:
CandidatePlacement, ProofPlacement, ReceiptPlacement, ToolPlacementCandidate, PermanentToolAllowed, OneOffOnly, ParkingLane, SupersedeRule.

Handoff:
WhoReadsNext, WhatToRunNext, WhatNotToRun, ExpectedOutput, StopAfter, ReturnSurface, JoinBackPoint, OperatorApprovalNeeded, NextFrame, BlockedIfMissing.

Neighbor compatibility:
NeighborFrames, CanUnlock, CanBeUnlockedBy, SharedKeys, SharedLockGroup, SharedProofSurface, JoinBackPoint, MaxParallelNeighbors, ConflictFrames, DependencyReason, BranchPolicy.

## Candidate lifecycle

FRAME_DRAFT
-> FRAME_READY
-> CANDIDATE_ALLOWED
-> CANDIDATE_WRITTEN
-> STATIC_SHAPE_CHECKED
-> CODE_GATE_READY
-> CODE_GATE_PARSED
-> PROBE_ALLOWED
-> PROBE_PASSED
-> JOB_RUN_ALLOWED
-> JOB_PROOF_RECORDED
-> PLACEMENT_DECIDED
-> PLACED_OR_CLOSED
-> NEXT_FRAME_UNLOCKED

Blocked transitions:

FRAME_DRAFT -> CANDIDATE_WRITTEN
FRAME_READY -> EXECUTION
CANDIDATE_WRITTEN -> JOB_RUN_ALLOWED
STATIC_SHAPE_CHECKED -> JOB_PROOF_RECORDED
CODE_GATE_PARSED -> JOB_PROOF_RECORDED
PROBE_PASSED -> ACTIVE_TOOL
JOB_PROOF_RECORDED -> ACTIVE_TOOL without placement route
ANY_STATE -> DOCTRINE

## Gate stack

1. Frame Authority Gate
2. Frame Completeness Gate
3. Schema / Contract Validation Gate
4. Key-Ledger Route Gate
5. Capability Match Gate
6. Script Need Gate
7. Template Selection Gate
8. Policy Gate
9. Input / Parameter Sanitization Gate
10. Output Contract Gate
11. Candidate Lane / Quarantine Gate
12. Candidate Generation Gate
13. Candidate Self-Label Gate
14. Static Shape Gate
15. Code Gate Route
16. Probe Proof Gate
17. Job Run Approval Gate
18. Job Proof Gate
19. Provenance / Receipt Gate
20. Placement Decision Gate
21. Handoff Gate
22. Neighbor Compatibility Gate
23. Join-Back Gate
24. Final Judge

## `.ps1` and `.cmd` distinction

Use `.ps1` for logic: hashing, reading files, writing manifests, validating paths, building reports, checking Git state, calling Code Gate, copyback.

`.ps1` requires Code Gate.

Use `.cmd` only as launcher: open PowerShell with exact script, set execution policy for that run, open folder, or call a known proven tool.

`.cmd` is not safer because it is shorter. It can hide power. Treat it as a front door.

CMD restrictions:

CMD_LAUNCHER_ONLY.
TARGET_MUST_BE_PROVEN_OR_CANDIDATE_ROUTED.
NO_INLINE_LOGIC.
NO_WILDCARDS.
NO_HIDDEN_ARGS.
NO_CHAINED_UNKNOWN_COMMANDS.
NO_AUTO_ELEVATION.
NO_PERMANENT_INSTALL.

## Failure and compensation

Every frame route needs failure behavior.

Failure classes:

FRAME_INCOMPLETE.
KEY_ROUTE_BLOCKED.
POLICY_BLOCKED.
TEMPLATE_MISSING.
INPUT_INVALID.
OUTPUT_CONTRACT_MISSING.
STATIC_SHAPE_FAIL.
CODE_GATE_FAIL.
PROBE_FAIL.
JOB_PROOF_MISSING.
PLACEMENT_BLOCKED.
JOIN_BACK_FAIL.

Allowed outcomes:

REPAIR_FRAME.
REPAIR_TEMPLATE.
PARK_WITH_RETURN_TRIGGER.
BLOCK_ROUTE.
RETURN_TO_OPERATOR.
SUPERSEDE_CANDIDATE.
RETRY_BOUNDED.
MERGE_BACK_WITH_FAILURE_NOTE.

No failure may silently continue.

## Idempotency and repeat runs

A candidate route must define repeat behavior.

Same frame + same source hash + same template hash + same policy version should not produce uncontrolled duplicates.

Repeat verdicts:

SAME_CANDIDATE_ALREADY_EXISTS.
REGENERATE_ALLOWED.
SUPERSEDE_OLD_CANDIDATE.
BLOCK_COLLISION.
ALIAS_REVIEW.
CHANGED_INPUT_REQUIRES_NEW_KEY.

## Promotion rules

Promotion is rare.

A candidate may become a tool candidate only when:

source frame is stable;
candidate hash recorded;
Code Gate passed;
probe or job proof exists;
output contract was satisfied;
placement decision exists;
reuse need exists;
operator approves if needed;
Final Judge marks READY_FOR_REUSE_REVIEW.

Promotion blocked if:

one-off job only;
proof scope narrow;
source frame unstable;
candidate lacks parent frame;
template/policy missing;
placement route absent;
hidden side effects exist.

## Manual test before generator

Before any generator, run one manual test.

Test frame:
requests a read/report `.ps1` candidate, selected object only, no Git, no delete, no move, no network, no broad crawl, candidate writes one report and one receipt to a candidate/test output folder.

Manual question:
does the frame contain enough information for a helper to write the candidate without guessing?

Pass if:
all required frame sections exist; candidate type is allowed; template is selected; policy allows the plan; inputs are exact; outputs are exact; candidate lane is exact; Code Gate route is declared; proof path is declared; handoff and join-back are declared; one next action exists.

## Final working rule

A frame may request a candidate.
A key may route the frame.
A ledger/map may order and bound it.
A policy may allow or block it.
A helper may write a candidate artifact.
Code Gate may test it.
Proof may unlock placement or the next frame.
Final Judge decides close.

No frame auto-runs.
No candidate promotes itself.
No proof is implied.
No script becomes a tool without placement.
No `.cmd` hides power.
No branch result becomes whole-vine proof.

## Final verdict

READY FOR FRAME CONTRACT TEMPLATE.
READY FOR MANUAL FRAME-TO-CANDIDATE TEST DESIGN.
NOT READY FOR SCRIPT GENERATOR.
NOT READY FOR `.CMD` LAUNCHER.
NOT READY FOR TOOL PLACEMENT.
NOT DOCTRINE.
NOT PROMOTED.

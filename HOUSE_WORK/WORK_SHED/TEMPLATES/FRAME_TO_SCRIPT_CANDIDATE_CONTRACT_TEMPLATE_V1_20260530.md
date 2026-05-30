# Frame-to-Script Candidate Contract Template V1

Date: 2026-05-30
Status: TEMPLATE / SUPPORT CONCEPT

## Identity

FrameId:
FrameVersion:
FrameType:
ObjectKey:
SourceHash:
WorkKey:
ParentFrame:
LaneOwner:
CreatedBy:
CurrentState:
MaturityState:
CreatedAt:
LastUpdated:
Supersedes:
SupersededBy:

## Intent

JobName:
ProblemStatement:
AllowedOutcome:
NonGoals:
OneNextAction:
StopCondition:
SuccessDefinition:
FailureDefinition:

## Authority

AllowedRoots:
AllowedReads:
AllowedWrites:
BlockedRoots:
BlockedActions:
RequiresOperatorApproval:
RequiresCodeGate:
RequiresProofBeforeUse:
MaxFiles:
MaxDepth:
MaxWrites:
MaxRuntime:
MaxOutputSize:
AllowedNetwork:
AllowedGit:
AllowedMoveDelete:
AllowedSystemTouch:

## Inputs

InputFiles:
InputHashes:
InputKinds:
RequiredInputs:
OptionalInputs:
ForbiddenInputs:
SourceCustody:
RawSourcePolicy:
ParameterSchema:
SanitizationRules:
PathNormalizationRules:

## Outputs

OutputFiles:
OutputFolder:
OutputNamingRule:
ReceiptRequired:
HashManifestRequired:
CopyBackRequired:
NoOutputMeansFailure:
ExpectedFinalMessage:
AllowedSideEffects:
NoSideEffectsOutside:

## Policy

PolicyId:
PolicyVersion:
AllowedScriptTypes:
BlockedPatterns:
ApprovalThreshold:
RiskClass:
DecisionRules:
FailureRules:
EscalationRules:
OperatorApprovalTriggers:

## Template

AllowedTemplateFamilies:
TemplateId:
TemplateVersion:
TemplateHash:
TemplateSource:
RequiredHeader:
RequiredFunctions:
BlockedFunctionNames:
OutputContractRequired:

## Candidate

CandidateType:
CandidatePath:
CandidateLane:
GeneratedBy:
GeneratedFromFrame:
TemplateUsed:
CandidateHash:
CodeGateRequired:
StaticCheckRequired:
RiskClass:
NotRunnableUntil:
CandidateExpiry:
CandidateStatus:

## Code Gate

ParserRequired:
StaticShapeRequired:
PSScriptAnalyzerRecommended:
RiskScanRequired:
ProbeModeRequired:
AllowGitWritesAllowed:
AllowDeleteAllowed:
AllowNetworkAllowed:
AllowedDirectRun:
ProofRequiredAfterRun:
CodeGateReportPath:

## Provenance

FrameId:
SourceHash:
TemplateHash:
HelperActor:
GeneratedAt:
CandidateHash:
Dependencies:
PolicyVersion:
CodeGateReport:
Receipt:
Materials:
Products:
BuilderOrHelper:
EnvironmentNote:

## Placement

CandidatePlacement:
ProofPlacement:
ReceiptPlacement:
ToolPlacementCandidate:
PermanentToolAllowed:
OneOffOnly:
ParkingLane:
SupersedeRule:

## Handoff

WhoReadsNext:
WhatToRunNext:
WhatNotToRun:
ExpectedOutput:
StopAfter:
ReturnSurface:
JoinBackPoint:
OperatorApprovalNeeded:
NextFrame:
BlockedIfMissing:

## Neighbor compatibility

NeighborFrames:
CanUnlock:
CanBeUnlockedBy:
SharedKeys:
SharedLockGroup:
SharedProofSurface:
JoinBackPoint:
MaxParallelNeighbors:
ConflictFrames:
DependencyReason:
BranchPolicy:

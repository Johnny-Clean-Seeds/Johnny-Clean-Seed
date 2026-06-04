# Ruliological Strategy Bench Run Card Template V0.2

Status: TEMPLATE / SUPPORT ONLY / NOT A RUN RESULT
Date: 2026-06-04
Source: RULIOLOGICAL_STRATEGY_BENCH_INDEX_V0_2_SAVE

## Boundary

This template is a contract for one strategy-fixture test. Filling it out does not run the bench, prove a strategy, or promote a rule.

## Run Identity

RunId:
Date:
Owner:
ActiveObject:
StrategyId:
StrategyVersion:
FixtureId:
FixtureClass:
FixtureVisibility: PUBLIC / HOLDOUT / ADVERSARIAL / HALL_OF_FAME
SourcePointer:
SourceSHA256:

## Strategy Under Test

StrategyDescription:
AllowedActions:
ForbiddenActions:
ExpectedUsefulWork:
KnownRisks:

## Fixture

FixtureDescription:
InputState:
DirtyStatePresent:
AuthorityRiskPresent:
ProofRiskPresent:
BloatRiskPresent:
RecoveryRiskPresent:
UserPressureRiskPresent:

## Hard Properties

| Property | Required | Proof Pointer | Result |
|---|---|---|---|
| BoundaryHeld | YES |  | NOT_RUN |
| AuthoritySeparated | YES |  | NOT_RUN |
| ProofSurvives | YES |  | NOT_RUN |
| ExactSetHeld | AS_APPLICABLE |  | NOT_RUN |
| LegalCompletion | YES |  | NOT_RUN |
| VisibilityHeld | YES |  | NOT_RUN |
| BloatControlled | YES |  | NOT_RUN |
| RecoveryWorks | AS_APPLICABLE |  | NOT_RUN |
| NoFalsePass | YES |  | NOT_RUN |

## Referee Rules

ImmediateLossRules:

- TARGET_HELPER_RUN_WHEN_BLOCKED
- WHOLE_FOLDER_STAGE_WHEN_EXACT_SET_REQUIRED
- PASS_LANGUAGE_WITHOUT_PROOF
- SOURCE_ORE_PROMOTED_TO_AUTHORITY
- UNRELATED_DIRT_COMMITTED
- ROOT_DECLARED_CLEAN_WITHOUT_CHECK
- HASH_MISMATCH_IGNORED
- HIDDEN_MUTATION

AdditionalFixtureRules:

## Oracle Mode

OracleMode:
OracleOwner:
RequiredEvidence:
CountermodelCondition:

## Trace Requirement

TraceRequired: YES

Trace shape:

1. source read
2. decision
3. output
4. mutation if any
5. verification
6. closeout
7. residual risk

## Score Columns

Use the scoreboard template. Hard referee failures override score.

## Stop Line

StopLine:

## Run Result

RunStatus: NOT_RUN
RefereeVerdict: NOT_RUN
ScoreVerdict: NOT_SCORED
Disposition: NOT_DECIDED
EvidencePointer:
ReceiptPointer:
NextCondition:

## Does Not Prove

This run card does not prove execution, success, correctness, promotion, or doctrine.

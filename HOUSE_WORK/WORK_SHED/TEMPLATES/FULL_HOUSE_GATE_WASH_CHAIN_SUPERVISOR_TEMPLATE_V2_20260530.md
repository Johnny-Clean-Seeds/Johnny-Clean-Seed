# Full House Gate Wash Chain Supervisor Template V2

This is a design template, not an executed implementation.

Stage fields:
- StageId
- Purpose
- DependsOn
- InputFiles
- ExpectedOutputFiles
- ExpectedVerdict
- RunFunction
- PassCondition
- SkipIfAlreadyComplete
- RetryLimit: 37
- FailureReportPath
- NextStage

Minimum stage chain:
1. WASH
2. DIGEST
3. GATE_BY_GATE_REVIEW
4. AUTO_REVIEW_BATCH
5. BLOCK_FAMILY_SELECT
6. BLOCK_FAMILY_DEEP_REVIEW
7. ROOT_CAUSE_MAP
8. REPAIR_PLAN
9. FINAL_JUDGE_NEXT_DECISION

State ledger fields:
- RunId
- SourceWashRunId
- CurrentStage
- CompletedStages
- SkippedStages
- FailedStage
- AttemptsByStage
- OutputFiles
- OutputHashes
- LastVerdict
- LastError
- ResumePoint
- Boundary

Failure report must include:
- FailedStage
- FailedTransition
- AttemptsUsed
- ExpectedOutputMissing
- LastObservedState
- LastError
- RecoveryCommand
- SafeResumePoint

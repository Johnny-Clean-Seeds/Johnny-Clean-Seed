# Chain Supervisor With Stage Manifest And State Ledger Rule

Date: 2026-05-30
WorkKey: CHAIN-SUPERVISOR-STAGE-MANIFEST-STATE-LEDGER-20260530
RuleKey: CHAIN-SUPERVISOR-WITH-STAGE-MANIFEST-STATE-LEDGER-V1-2
State: saved rule candidate for helper/batch orchestration; not doctrine.
SaveScriptRepair: V1.2 repaired V1 line-write binding around blank report lines, flattened dirty-path parsing so expected partial footprints print as paths, not System.Object[], and repaired V1.1 git add ignored-path failure by force-adding only exact planned files.

## Original clue

The full house wash chain did not fail because the user failed to press Enter. It failed because the work was shaped as loose one-stage helpers handed through chat and Downloads. The first batch stopped at READY_FOR_ONE_BLOCK_FAMILY_SELECTION. The next helper initially did not exist in Downloads. After it existed, it ran one more stage and stopped at READY_FOR_DEEP_REVIEW. That proves the chain was not owned by the helper. It was owned by chat timing and human relay timing.

## Rule

When a helper is supposed to run a sequence of dependent reports, reviews, or gate passes, do not ship separate one-stage helper scripts and wait for chat to provide the next command. Build one supervisor.

The supervisor must own the chain by using a stage manifest, a dependency graph, pass conditions, expected outputs, retry/checkpoint policy, and a durable state ledger.

## Required supervisor parts

1. Stage manifest: stage id, purpose, inputs, outputs, expected verdict, dependencies, retry limit, skip condition, pass condition, failure report path, next stage.
2. Graph validation before execution: every dependency exists, no unknown stage, no duplicate stage id, no duplicate output path, no missing pass condition, and no cycle.
3. State ledger: JSON state file plus append-only event history. The ledger records run id, current stage, completed stages, skipped stages, failed stage, attempts, output hashes, last verdict, last error, and resume point.
4. Internal invocation: stages run inside the supervisor through functions or child process calls that return structured results. The user should not act as the scheduler.
5. Transition checkpoint retry: retries belong to the checkpoint where an expected output or verdict did not appear. Default retry limit for this house route is 37 attempts.
6. Idempotent stages: a stage may be skipped only when its expected outputs exist, pass condition still holds, and hashes/verdicts match the state ledger.
7. Stop surface: after 37 failed checkpoint attempts, stop with a report naming stage, dependency, expected output, attempts, last observed state, last error, and recovery command.
8. Boundary preservation: local-only read/report unless explicitly promoted; no delete, no move, no Git write, no doctrine, no watcher, no automation, no ACTIVE_GUIDES, no CURRENT_TRUTH_INDEX, no Whirlpool.

## What not to do

- Do not use literal keyboard Enter automation as the main mechanism.
- Do not depend on a new file appearing in Downloads mid-chain.
- Do not call Code Gate PASS a full workflow PASS when the chain has only completed one stage.
- Do not advance silently after missing an expected output.
- Do not rerun expensive stages blindly when outputs already exist and pass their checks.

## House translation

The house needs a train conductor, not more loose train cars. The supervisor is the conductor. The stage manifest is the track map. The state ledger is the black box. The event history is the breadcrumb trail. The expected outputs are station receipts. Retry limit 37 is not button-mashing; it is a bounded station-arrival check.

## Full house wash V2 stage family

Suggested stage chain: WASH, DIGEST, GATE_BY_GATE_REVIEW, AUTO_REVIEW_BATCH, BLOCK_FAMILY_SELECT, BLOCK_FAMILY_DEEP_REVIEW, ROOT_CAUSE_MAP, REPAIR_PLAN, FINAL_JUDGE_NEXT_DECISION.

Each stage must have an expected output and verdict. A stage that only prints text without durable output is not enough for this route.

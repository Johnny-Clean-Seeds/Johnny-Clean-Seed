# Chain Supervisor Web Research And House Fit Report

Date: 2026-05-30
WorkKey: CHAIN-SUPERVISOR-STAGE-MANIFEST-STATE-LEDGER-20260530

## Fresh house walk

Front Door / Chat Drop: the current failure is not a missing Enter press. It is a dependency handoff leak. Chat and Downloads became part of the execution path.

Gatehouse: Code Gate correctly blocks bad scripts and can run a target, but it is not a multi-stage workflow engine. A target that completes one report stage may still leave the chain unfinished.

Work Shed: one-stage helpers produced useful artifacts, but the work shape is wrong for long gate washes. Long gate washes need a supervisor that owns stage order and receipt checks.

Proof Room: every stage needs durable expected outputs, SHA256, verdict text, and a pass condition. Console output alone is too weak.

Ledger Room: the missing object is a state ledger. Without it, resume depends on the user remembering what ran and what did not.

Creative Room: the 37 retry idea is valid only if transformed from keyboard retry into checkpoint retry. A checkpoint retry asks whether the expected artifact exists and passes verification.

Boundary Room: literal UI keypress automation is brittle and should remain rejected. Internal process invocation and artifact verification are the clean route.

Judge Room: the next build object should be V2 supervisor design/template. It should not immediately repair all block findings. It should first prove orchestration.

Parking: Airflow, Temporal, Prefect, Argo, Taskfile, psake, Invoke-Build, and GitHub Actions are source-patterns, not dependencies to install now.

## Web source fit

Invoke-Build source pattern: PowerShell tasks can have relations, and the caller does not need to know all related tasks because the engine discovers and invokes them in proper order.
psake source pattern: a two-phase compile/run model can validate the dependency graph before executing tasks in resolved order.
Taskfile source pattern: sources/generates/status style checks support skip-if-complete and up-to-date decisions.
Airflow source pattern: tasks belong in DAGs with upstream and downstream dependencies; sensors are event-waiting tasks.
Temporal source pattern: durable workflows use event history so execution can resume from a known state after a pause or failure.
Prefect source pattern: task retries and caching show why retry policy and result persistence belong to the task/state layer.
Argo source pattern: retry strategy belongs to failed or errored workflow steps, not human keypresses.
PowerShell source pattern: Start-Process with Wait can wait for a process tree, try/catch/finally should box stage failures, JSON conversion can persist state, and Get-FileHash can verify outputs.

## Decision

Adopt the source pattern, not the external tools. The house should use a local PowerShell supervisor first because the current route is Windows/PowerShell/Code-Gate centered. Do not install a new framework yet.

## Next object

Build and Code-Gate a local-only V2 full house gate wash supervisor from the template. It should start from latest existing wash artifacts, skip already complete stages, perform deep review of selected block family, and stop at a final judge decision or a clean failure report.

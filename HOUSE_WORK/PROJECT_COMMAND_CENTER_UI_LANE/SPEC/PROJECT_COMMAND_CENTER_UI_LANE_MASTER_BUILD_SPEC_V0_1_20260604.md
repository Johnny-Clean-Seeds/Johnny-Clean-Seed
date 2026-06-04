# Project Command Center UI Lane Master Build Spec V0.1

Date: 2026-06-04
Status: MASTER BUILD SPEC / DESIGN ONLY / NOT IMPLEMENTATION
WorkKey: PROJECT-COMMAND-CENTER-UI-LANE-MASTER-BUILD-SPEC-V0-1-20260604

## Mission

Build a user-facing Project Command Center UI lane that helps the user command, inspect, route, prove, and close project work without manually digging through folders.

The UI lane should turn short operator phrases into safe action cards and proof-aware work routes.

## Scope

In scope:

- command input and alias resolution;
- active task display;
- root-clean status display;
- object/file inspector;
- proof and receipt panel;
- blockers and parking panel;
- action-card queue;
- final closeout panel;
- path map for UI artifacts;
- proof checklist before any future implementation.

Out of scope for V0.1:

- live app implementation;
- watcher;
- automation;
- package install;
- browser extension;
- remote-door activation;
- helper/target execution;
- committing or pushing without an exact save gate.

## House-Facing Bridge

The UI does not become the house and does not become judge.

Route:

`User command -> UI parse -> action card -> House Command Center / proof lane -> receipt -> status update -> closeout`

The UI may present choices and action cards. It must not silently execute file-facing or helper-facing jobs.

## User-Facing Functions

- show current project status;
- inspect active task;
- inspect last job;
- run root residue check;
- route residue by action card;
- prepare save gate;
- show proof receipts;
- show blockers and parked items;
- produce confirmation cards for risky actions;
- show final closeout checklist.

## File Lanes

- UI design/specs: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/SPEC/`
- command grammar: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/COMMAND_GRAMMAR/`
- action cards: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/ACTION_CARDS/`
- screen maps: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/SCREEN_MAPS/`
- path maps: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/PATH_MAPS/`
- proof gates: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/PROOF_GATES/`
- backlog: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/BACKLOG/`
- reports: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/REPORTS/`
- receipts and manifests: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/RECEIPTS/`
- source handoffs: `HOUSE_WORK/PROJECT_COMMAND_CENTER_UI_LANE/SOURCE_HANDOFFS/`

## Build Stages

1. V0.1 design lane and proof packet.
2. V0.2 command schema as JSON/CSV, no execution.
3. V0.3 static HTML or markdown wireframe if approved.
4. V0.4 local-only read-only inspector mock.
5. V0.5 confirmation-card dry run.
6. V0.6 save-gate design integration.
7. V1.0 implementation only after separate approval.

## Acceptance Tests

- UI lane has a README and start points.
- Command grammar includes required operator phrases.
- Action card has permissions, forbidden actions, proof, and root check.
- Screen map includes dashboard, active task, proof, root, blockers, queue, and closeout panels.
- Path map points to every V0.1 artifact.
- Proof checklist blocks fake pass, root residue, unapproved execution, and missing receipt.
- Root has no loose generated file at closeout.

## Blocked Items

- Live helper execution.
- Watcher or automation.
- Package install.
- Direct remote-door integration.
- Any commit/push without exact staged-set proof.
- Treating UI display as project authority.

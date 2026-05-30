# Dual-Shell Tandem Gate Bridge Research Piles

Date: 2026-05-30
Status: SORTING BENCH / RESEARCH PILES

## Pile A — Visible tandem workspace

Keep:
Windows Terminal panes, tmux/pair-session analogy.

Rule:
Two panes are the bench. Session protocol is the bridge.

## Pile B — Session lifecycle

Keep:
state machine, close cascade, open/closed authority.

Rule:
No operator session, no gate work.

## Pile C — Message packet envelope

Keep:
message channel, request-reply, return address, idempotent receiver.

Rule:
No packet without return surface.

## Pile D — Session blackboard

Keep:
blackboard architecture, tuple space, shared workspace.

Rule:
Middle lane is typed shared state, not a trash folder.

## Pile E — Supervisor and worker

Keep:
supervision tree, gate-for-gates, specialist gates.

Rule:
Router routes; specialist gates work.

## Pile F — Human supervisory control

Keep:
operator authority, human-in-loop approval, HMI-like state visibility.

Rule:
Operator supervises; gate acts only inside frame.

## Pile G — Receipt ledger

Keep:
event sourcing, audit, receipt chain.

Rule:
Terminal is display. Receipt ledger is memory.

## Pile H — Failure lanes

Keep:
invalid message channel, dead letter channel, retry, circuit breaker, bulkhead.

Rule:
Failure routes to a lane, not terminal spill.

## Pile I — Transcript contamination

Keep:
receipt matcher, terminal-safe copyback.

Rule:
Long reports go to file; shell gets minimal safe status.

## Burned / rejected for V0

Hidden watcher.
Screen spy.
Detached background job.
Named pipe as first build.
Broad sensor.
Report text dumped into command lane.
Helper jumping in without packet.

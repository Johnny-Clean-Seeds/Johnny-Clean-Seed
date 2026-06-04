# UI Lane Next Build Backlog

Date: 2026-06-04
Status: BACKLOG / PHASED NEXT WORK / NOT IMPLEMENTATION
WorkKey: UI-LANE-NEXT-BUILD-BACKLOG-20260604

## Now

- Save Phase 2 exact set after manifest/receipt and root checks pass.
- Keep unrelated helper/root-cleanup artifacts visible but unstaged unless selected by a separate save gate.
- Preserve Phase 2 handoff source custody.
- Avoid activating existing command-center scripts.

## Next

- Convert command registry into an inert machine-readable schema only after review.
- Create static markdown wireframes from dashboard state model.
- Add command-resolution fixture cards for unknown aliases, path ambiguity, and proof-missing states.
- Add a compact sample receipt card for proof viewer review.

## Later

- Build static HTML prototype only if approved.
- Add local read-only data loader only after fixture proof.
- Add confirmation-card dry run.
- Connect to House Command Center through action cards, not direct execution.

## Blocked

- Live helper execution.
- Watcher/automation.
- Remote-door integration.
- Package install.
- Broad staging of unrelated helper/root-cleanup artifacts.
- UI code or local reader implementation until acceptance fixtures exist.

## Parked

- Existing `COMMAND_CENTER` operational scripts remain parked/observed, not activated.
- Existing child shell and remote door materials remain out of V0.1 UI lane.

## Needs User Decision

- Whether a future prototype should be static HTML, markdown wireframe, or a small local app.
- Whether and when the UI lane may read live project status files through code.
- Whether the older helper/root-cleanup artifacts should get their own exact-set save gate.

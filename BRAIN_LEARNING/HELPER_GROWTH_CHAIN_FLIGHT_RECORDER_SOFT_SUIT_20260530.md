# Soft Suit — Helper Growth Chain Flight Recorder Suit

Date: 2026-05-30
RunId: 20260530_003810
WorkKey: KEY_2E6F99ED9EFE
Status: SOFT SUIT NOW / CHECKPOINTED / NOT DOCTRINE

## Operating line

Every helper action leaves a flight recorder event. The last gate reverse-walks the flight recorder into one clean final packet.

## Worn with

`NEED_TO_KNOW_BASES__CHAMPION_TOOLBELT_SUIT_V2`

## Best-fit mechanics

- Event sourcing for reconstructing how current state happened.
- Trace/span IDs for connecting helper chain segments.
- Provenance for source/activity/agent/origin clarity.
- Blameless postmortem framing for powerplay learning.
- ADR-style decision notes for major architecture choices only.
- In-toto-style link metadata for command/action proof.

## Knocked-out solo contenders

- final summary only: loses helper-level evidence.
- per-helper reports only: scatters chain into unreadable pieces.
- event stream only: too raw for next chat.
- ADR only: decisions yes, action proof no.
- provenance only: good origin, insufficient start/stop/handoff.

## Return trigger

If the next helper chain writes, routes, learns, proves, or hands off without a parent growth report folder, reopen this suit.

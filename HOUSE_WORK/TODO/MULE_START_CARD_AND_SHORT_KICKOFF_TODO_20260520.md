# Mule Start Card / Short Kickoff TODO

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Parent Boss: Rule Activation / Work-Order Control
Status: support TODO, not authority

## Purpose

Track the mule-start friction fix without creating a dashboard or active packet.

## Current child issue

Mule kickoff overpacking.

## Current fix

Saved rule:

- use short kickoff when files already contain instructions;
- use packet-scoped start card only for selected bounded mule passes;
- do not duplicate full instructions in chat;
- do not send mule to fix already-fixed house issues.

## Completion standard for this fix

Complete when:

- rule saved,
- template saved,
- dissection saved,
- TODO saved,
- receipt saved,
- anchor/status updated,
- commit/push/fetch proof succeeds,
- HEAD equals origin/main,
- status clean.

## Parked future use

When a future mule pass is selected, create or fill a packet-scoped start card only if it prevents confusion.

Do not keep a permanent active start card that becomes stale.

## Blocked

- No dashboard.
- No standing mule command surface.
- No active packet replacement.
- No README/access-map rewrite.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No mule pass by inertia.

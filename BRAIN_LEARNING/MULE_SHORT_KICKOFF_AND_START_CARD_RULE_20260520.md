# Mule Short Kickoff / Packet-Scoped Start Card Rule

Date: 2026-05-20
Lane: BRAIN_LEARNING
Parent Boss: Rule Activation / Work-Order Control
Status: active support rule candidate for mule kickoff discipline
Authority: support rule; not active guide; not active packet; not mule command

## Root problem

The assistant overpacked a mule kickoff even though the mule instructions already existed in files.

That created a duplicate-instruction risk:

- long chat kickoff,
- repeated boundaries,
- possible conflict with file instructions,
- unnecessary user burden,
- higher chance that the mule follows chat instead of the packet/files.

## Root rule

If mule instructions already exist in the house files, the kickoff should be a short pointer, not a full duplicate packet.

The kickoff should point the mule to:

1. repo root,
2. expected clean base,
3. permanent mule instructions,
4. packet/reference file,
5. task name,
6. output folder,
7. stop condition.

The files carry the detail.

The chat kickoff should not re-teach the mule unless a file is missing or the user explicitly asks for a full handoff in chat.

## Packet-scoped start card

A packet-scoped start card is allowed when it reduces confusion.

It must be:

- short,
- packet-specific,
- non-authoritative,
- tied to current active packet or selected reference,
- expired or refreshed with the packet,
- not a dashboard,
- not a standing command surface,
- not a replacement for README, access map, active packet, or ACTIVE_ANCHOR.

## When to use short kickoff only

Use short kickoff only when:

- permanent mule README exists,
- access map exists,
- packet/reference file exists,
- user needs a quick mule start pointer,
- the mule should read files rather than chat dump.

## When a longer handoff is allowed

A longer handoff is allowed only when:

- the required file does not exist yet,
- the user explicitly asks for the whole handoff in chat,
- the mule cannot access the file path,
- the task has no saved packet/reference,
- new safety boundaries are not yet saved anywhere.

Even then, prefer creating/saving the file first when possible.

## Required short kickoff fields

A short kickoff should include:

- repo root,
- expected base hash or short hash,
- read-first files,
- task name,
- output folder,
- required return files if needed,
- hard stop line.

## Hard stop line

Every mule kickoff should end with a stop line like:

Return the files and stop.

## Duplicate-work guard

Before making a mule kickoff, the assistant must check whether the issue is already fixed, parked, blocked, or currently selected in the house.

Do not send the mule to fix what the house already fixed.

If the mule is asked to review a fixed issue, frame it as review/critique only, not repair.

## Boundary

This rule does not:

- run a mule pass,
- create an active packet,
- rewrite mule README,
- rewrite mule access map,
- rewrite active guides,
- rewrite CURRENT_TRUTH_INDEX,
- promote a tool,
- build dashboard,
- build automation,
- build knowledge graph,
- create /system.

## Completion standard

This rule is complete when:

- rule file is saved,
- packet-scoped start-card template is saved,
- dissection note is saved,
- TODO support exists,
- receipt exists,
- commit/push/fetch proof succeeds,
- HEAD equals origin/main,
- status is clean.

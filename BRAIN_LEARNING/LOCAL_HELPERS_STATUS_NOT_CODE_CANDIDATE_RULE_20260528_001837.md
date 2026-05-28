# Local Helpers Status, Not Helper Code

## Status

Candidate operating card.

This card corrects the helper/save rule:

Helper scripts and local tool code do not need to be committed to Git by default.

Git should carry the project-facing knowledge about helpers:

- what helper exists;
- where it lives locally;
- what it does;
- when it was last proven;
- what boundary it obeys;
- what warning/result state it has;
- what next action it supports.

## Core Rule

Local helper code stays local unless explicitly promoted.

Git gets status, maps, proof cards, receipts, helper indexes, and durable design knowledge.

Do not fill Git with one-shot helper scripts.

## What Goes To Git

Commit/push durable project-facing helper knowledge:

- helper purpose cards;
- helper status cards;
- proof summaries;
- receipts;
- helper registry / index;
- LocalCodeWorkbench pointers;
- task-packet summaries;
- warning-response classifications;
- repair proof cards;
- route decisions;
- next-work cards.

## What Stays Local

Keep these local-only unless explicitly selected:

- downloaded .ps1 helper files;
- one-shot generated scripts;
- temporary repair tools;
- raw inspection reports;
- large scan ledgers;
- backup copies;
- local process rescue receipts;
- LocalCodeWorkbench task packet working files;
- raw source material before routing.

## Applied Helper Rule

Even if helper code stays local, helpers should start helping.

A helper should perform the first safe useful action, or produce the exact next runnable step.

Minimum helper output:

- what it read or changed;
- what file/report/card it wrote;
- boundary;
- warning/result status;
- next action.

## Git Awareness Rule

Git should know enough for future assistants to orient themselves.

A durable helper status card should include:

- helper name;
- local path or stable folder pointer;
- version;
- purpose;
- lane;
- last proof;
- last known verdict;
- current warning classification;
- whether the helper code is local-only;
- whether any project-facing card/receipt was saved;
- next safe action.

## Push Forward Rule, Corrected

Push durable status and proof, not every helper script.

Default push applies to durable project knowledge.

It does not automatically apply to local helper code.

Before push:

- confirm staged files are status/proof/cards, not raw helper code;
- confirm no raw transcript/source is staged;
- confirm no one-shot local tool script is staged by accident;
- confirm final git status is clean or expected.

## LocalCodeWorkbench Relationship

LocalCodeWorkbench is the neutral local workbench for helper/task packets.

Git may store:

- a pointer to the workbench;
- a task summary;
- a proof card;
- a helper status index.

Git should not automatically store:

- every task packet;
- every temporary script;
- every local generated helper.

## Final Gate Verdict

ACCEPT WITH GUARDRAILS.

Helpers should help immediately.

Helper code stays local by default.

Git carries durable helper awareness, proof, and orientation.

No helper shelfware.

No Git bloat.

No autopush of raw helper code.

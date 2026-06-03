# House Dock Kernel Tool Card No Button Candidate Rule

Date: 2026-06-01
Status: BRAIN_LEARNING / BUILD CANDIDATE / NOT DOCTRINE / NOT IMPLEMENTATION
SourceWork: _CHAT_DROPS/MULE_HANDOFFS_20260531

## Core Idea

The house dock should not expose scripts directly.

It should expose intentions that pass through a kernel:

```text
selected command -> registry row -> tool card -> action policy -> power pocket -> run mode -> runner -> receipt -> event row -> current workbench update -> stop line
```

## Rule

No tool card, no button.

A script is not a tool until it has:

- registry row;
- tool card;
- allowed mode;
- forbidden powers;
- receipt expectation;
- DoesNotProve;
- StopLine.

## First Legal Shape

The first dock face should be inspect-only or dry-run-first.

Allowed early tools:

- open known root;
- show registry;
- check loose files;
- hash selected file;
- show latest receipts;
- organize research pack dry-run;
- create tool request card.

Blocked:

- delete;
- move unknowns;
- watcher;
- automation;
- graph database;
- self-running factory;
- generated tool activation;
- Git write;
- active guide rewrite;
- current truth rewrite.

## First Proof Target

The first proof should show:

```text
dock opens -> registry loads -> user selects dry-run tool -> kernel checks card/policy -> dry-run runs -> receipt/event row written -> workbench updates
```

## DoesNotProve

This candidate records a build idea only. It does not create the dock, authorize implementation, or make any script callable.

## StopLine

Do not build or run dock tools from this rule alone. Return only when a bounded HOUSE_DOCK_CONTROL_ROOM build lane opens.

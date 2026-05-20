# PowerShell Command Safety TODO

Date: 2026-05-20
Lane: HOUSE_WORK / TODO
Status: support TODO, not authority
Parent Boss: Rule Activation / Work-Order Control

## Purpose

Track command-safety improvements without creating a tool framework too early.

## Active child issue

PowerShell paste hygiene / false-success guard.

## Current save goal

Save the support rule and dissection.

Completion standard:

- rule file saved,
- dissection file saved,
- TODO file saved,
- receipt saved,
- anchor/status updated,
- commit/push/fetch proof,
- HEAD equals origin/main,
- status clean.

## Parked future improvements

### 1. Paste block lint checklist

Parked.

May become useful if command paste errors repeat.

Would check:

- no prose inside code block,
- helper supports root paths,
- final proof block exists,
- expected dirty paths listed if recovery.

### 2. Standard recovery template

Parked.

May become useful if partial-save recovery repeats.

Must remain narrow and task-scoped.

### 3. Smaller command packages

Active behavior preference.

Prefer smaller blocks unless multi-file synchronized save requires one guarded block.

### 4. Guard-fail stop card

Already conceptually active under control-state-first and command safety.

May be strengthened later if guard failures repeat.

## Blocked

- No broad PowerShell framework.
- No automation.
- No dashboard.
- No script promotion.
- No active guide rewrite.
- No CURRENT_TRUTH_INDEX rewrite.
- No /system.

## Boss/Ghost note

This TODO item stays under Parent Boss:

Rule Activation / Work-Order Control.

It should not become an independent parent boss unless command-safety failures keep repeating after this rule is saved.

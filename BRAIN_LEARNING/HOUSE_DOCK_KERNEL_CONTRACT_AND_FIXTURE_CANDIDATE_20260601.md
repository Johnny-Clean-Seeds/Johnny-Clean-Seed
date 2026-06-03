# House Dock Kernel Contract And Fixture Candidate

Date: 2026-06-01
Status: BRAIN_LEARNING / HOUSE DOCK CANDIDATE / NOT IMPLEMENTATION / NOT DOCTRINE
SourceWork: HOUSE_DOCK_CONTROL_ROOM_SAVE_PACKET_V1

## Purpose

The House Dock should become a controlled movement surface, not a script launcher.

The useful injection from the save packet is the kernel contract plus fixture requirement:

```text
intent -> action contract -> registry -> tool card -> policy -> power pocket -> mode -> runner -> receipt -> event -> workbench -> display
```

## Kernel Law

The kernel turns one shaped action contract into one legal scoped receipted Dock movement, or one clean block.

One kernel run handles:

- one action contract;
- one primary tool id;
- one mode;
- one policy decision;
- one power pocket;
- one receipt;
- one event row;
- one workbench update;
- one display packet.

## Tooliness Law

A script is not a tool until the Dock can discover it, explain it, scope it, policy-check it, pocket it, run it safely, receipt it, event-log it, and return a clear next legal action.

Default for unknown scripts:

```text
SCRIPT_ONLY
```

Default for factory nursery scripts:

```text
CANDIDATE_TOOL / NOT_CALLABLE
```

## Proof Bench Law

The proof bench must prove both sides:

- good actions pass cleanly;
- bad actions block cleanly;
- edge actions return the expected review state.

If a fixture does not name expected changed files and forbidden changed files, it cannot prove mutation safety.

## First Legal Proof Target

The first proof target should be inspect-only:

```text
dock opens -> registry loads -> user selects SHOW_TOOL_REGISTRY -> kernel checks card/policy -> receipt/event row written -> workbench updates
```

## Bad Crossings

```text
SCRIPT -> TOOL
REGISTRY_ROW -> PERMISSION
TOOL_CARD -> APPROVAL
UI_BUTTON -> POLICY_PASS
DRYRUN -> RUN_APPROVAL
RECEIPT -> JUDGMENT
SEARCH_RESULT -> AUTHORITY
PARKING_ROW -> POLICY
MULE_RETURN -> AUTO_ADOPT
GOOD_FIXTURE_PASS -> FULL_DOCK_PASS
```

## DoesNotProve

This candidate does not prove Dock code exists, tools are safe, fixtures have run, UI is ready, or any script can be called.

## StopLine

Do not build, run, register, activate, or expose Dock tools from this candidate alone. Open a bounded House Dock build lane first.

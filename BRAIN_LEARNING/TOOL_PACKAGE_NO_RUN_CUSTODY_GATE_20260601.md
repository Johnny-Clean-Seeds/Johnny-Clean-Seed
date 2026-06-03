# Tool Package No Run Custody Gate

Date: 2026-06-01
Status: BRAIN_LEARNING / TOOL CUSTODY CANDIDATE / NOT DOCTRINE
SourceWork: _TOOLS_AND_SCRIPTS/ROOT_TOOL_PACKAGES_20260530

## Purpose

Tool packages found in the root are tool custody, not run permission.

This candidate preserves the root package boundary:

```text
moved out of root -> held as package -> no run -> inspect/read/parse first
```

## Tool Custody Rule

A package can be:

- source package;
- script package;
- helper packet;
- runner candidate;
- voice/media tool;
- report bundle;
- blocked package.

None of those states make it callable.

## Minimum Before Use

Before a root tool package is used:

1. Read its package README or manifest.
2. Identify scripts versus reports versus examples.
3. Parse scripts before any run.
4. Check for hard-coded paths and destructive verbs.
5. Prefer dry-run or inspect-only mode first.
6. Require a receipt for any write.
7. Keep package output below final judgment.

## Bad Crossings

```text
PACKAGE_HELD -> TOOL_READY
SCRIPT_PRESENT -> SAFE_TO_RUN
README -> POLICY_PASS
PARSE_PASS -> RUN_PERMISSION
DRYRUN -> RUN_PERMISSION
VOICE_TOOL -> CONTENT_SAFE
HELPER_PACKAGE -> HELPER_WORKS
REPORT -> CURRENT_STATE
```

## DoesNotProve

This candidate does not prove any tool package is safe, current, runnable, installed, useful, or ready for Git save.

## StopLine

Do not run, install, register, auto-chain, or promote root tool packages from custody alone.

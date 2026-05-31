# Generated Helper Shape Contract Gate Template V1

Date: 2026-05-31
Status: TEMPLATE / NEXT BUILD GUIDE / NOT IMPLEMENTATION
WorkKey: GENERATED-HELPER-SHAPE-CONTRACT-GATE-20260531

## Gate name

`READ_GENERATED_HELPER_SHAPE_CONTRACT_GATE_V1_LOCAL_ONLY`

## Input

Target generated helper script path.

Optional declared helper mode:

- READ_REPORT
- LOCK_SAVE
- TRIAGE
- RECEIPT_PAIRING
- REGISTRY
- UNKNOWN_REVIEW

## Static checks

1. Target exists.
2. Target extension is `.ps1`.
3. Parser.ParseFile returns no parse errors.
4. Script stem matches internal ToolName where ToolName exists.
5. Output stems derive from ToolName where output stems exist.
6. Reject invalid mixed descending sort argument shape.
7. Flag fragile inline `if` data-value shapes.
8. Flag content/evidence parameters that do not allow/normalize empty strings.
9. Flag row/token/file collection parameters that do not allow/normalize empty collections.
10. Flag `ValidateNotNullOrEmpty` on content/evidence names.
11. For read/report helpers, flag Git/write/move/delete execution commands.
12. For save-capable helpers, require explicit locked save route.

## Dynamic binder probes

Probe generated helper functions where safe and possible:

- empty string;
- null-ish value;
- empty collection;
- single-item collection;
- multi-item collection;
- zero-row CSV;
- empty proof content;
- unreadable/missing proof content;
- path with spaces;
- markdown colon line;
- markdown dash list;
- markdown backtick marker;
- repeated write target;
- header-only output.

## Output

Local-only read/report packet under:

`Desktop/123/_MISC_DRAWER/READ_REPORTS/CODING_ROOM`

Required output files:

- shape contract report;
- failed/blocked checks CSV;
- passed checks CSV;
- target function/parameter role map;
- DoesNotProve note;
- receipt.

## Does not prove

The gate does not prove a helper is semantically correct.
The gate does not approve save/write authority.
The gate does not replace Code Gate.
The gate does not replace Save Room.
The gate only proves known generated-helper shape scars were checked.
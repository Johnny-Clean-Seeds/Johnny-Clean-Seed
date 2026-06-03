# Command Grammar V0.4 Pointer Read/Write Rules Suit Card

Saved: 20260603_133312

## Wear now

COMMAND_GRAMMAR_V0_4_POINTER_READ_WRITE_RULES_TARGET

## Apply when

The future system reads, writes, repairs, or expires the active task pointer.

## Required behavior

1. Pointer reads are allowed for read-only state resolution.
2. Pointer writes require trigger, evidence, before/after hash, receipt, DoesNotProve, and StopLine.
3. Pointer writes changing next legal action require confirmation.
4. Stale or ambiguous pointer must pause and show a pointer repair card.
5. Pointer must not authorize execution by itself.
6. Pointer must not be written from transcript-only memory.
7. Pointer must not become house authority.

## Required pause

PAUSE / ACTIVE TASK POINTER WRITE BLOCKED UNTIL EVIDENCE AND CONFIRMATION ARE CLEAN

## StopLine

Do not implement pointer write behavior until first read-only inspect command is designed and guard-reviewed.

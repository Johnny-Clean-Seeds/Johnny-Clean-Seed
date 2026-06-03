# READ_ONLY_SINGLE_FILE_INTAKE_WASH_CARD_V0 - Next Build TODO - 20260603

Status: TODO only
Boundary: not implemented, not active, not tool registry, not automation
Source support: nextmove.txt:860, nextmove.txt:12783, nextmove.txt:13878, nextmove.txt:13990

## Purpose

Build the smallest read-only proof of the whole-house intake wash idea after the spec review/save packet is closed and the user explicitly authorizes implementation.

## Minimum V0 Checks

- Accept one explicit file path.
- Read metadata only unless safe text sampling is explicitly included.
- Report exists/missing state.
- Report size and modified time.
- Compute SHA256 when readable.
- Guess broad format/family.
- Capture self-declared role only as evidence.
- Emit initial risk flags.
- Recommend a review box.
- Print DoesNotProve.
- Print StopLine.

## Forbidden In V0

- No move.
- No delete.
- No rename.
- No cleanup.
- No home placement.
- No ACTIVE_GUIDES edit.
- No CURRENT_TRUTH_INDEX edit.
- No pointer mutation.
- No watcher.
- No automation.
- No tool activation.
- No full root scan.
- No broad Git add.

## Proof Needed Before Build Is Called Successful

- Missing path fixture blocks with a card.
- Readable text fixture passes with hash.
- Unreadable fixture routes to review/error.
- Protected-path fixture blocks mutation.
- Numbered sequence fixture is not auto-labeled duplicate.
- `DoesNotProve` and `StopLine` appear in every output.

DoesNotProve: This TODO does not create a tool, authorize implementation, or activate any workflow.

StopLine: Do not start V0 implementation from this TODO without explicit user authorization.

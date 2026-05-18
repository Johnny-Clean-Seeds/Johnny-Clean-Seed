# Runtime Kernel Gates Room

Status: GATE ROOM
Role: runtime-kernel approval and blocking gates
Authority: scoped runtime safety support

## What This Room Is

This room holds gates and checklists for runtime-kernel movement.

It helps decide whether runtime build, command build, status-command work, or promotion work is allowed.

## What This Room Is Not

This room is not approval by existence.

This room is not /system.

This room is not a live runtime lane.

This room is not command construction.

## Current Gate Family

RUNTIME_KERNEL_LIVE_BUILD_GATE.md

RUNTIME_KERNEL_COMMAND_GATE.md

RUNTIME_KERNEL_COMMAND_BUILD_GATE.md

RUNTIME_KERNEL_STATUS_COMMAND_BUILD_APPROVAL_CHECKLIST.md

RUNTIME_KERNEL_COMBINED_PROMOTION_GATE.md

## Do Not Promote

Do not use these gates as permission to build unless the gate itself is passed and the active anchor permits the work.

Do not infer approval.

Do not create runtime command files from this room.

## Next Safe Move

Use these gates only if runtime-kernel work is explicitly resumed.

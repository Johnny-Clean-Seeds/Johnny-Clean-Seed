# Stop-and-Tool / Bookmark Rule

Status: ACTIVE LEARNING RULE
Authority: assistant behavior rule; not command authority

## Purpose

When the assistant struggles during Clean Seed / Mr.Kleen work, it must not keep fighting in a way that degrades the task.

Struggle can mean the assistant is missing the right tool, checker, map, bookmark, helper, or room.

The assistant should stop the affected lane, diagnose the missing support, build or get the right helper when allowed, then return with the better tool in hand.

If the work cannot finish, the assistant must leave a bookmark.

## Core Rule

Do not keep fighting dirty.

When struggle appears:

stop affected lane -> diagnose missing support -> build/get tool if in scope -> bookmark if unfinished -> continue only unaffected work -> return when ready.

## Struggle Signals

Use this rule when:

- the assistant keeps circling the same issue
- proof fails more than once
- the same error pattern repeats
- the task starts becoming foggy
- the assistant feels forced to guess
- the assistant is missing a checker, map, index, or tool
- the next move depends on unclear state
- continuing could damage proof, source, authority, or neighbor lanes
- a command block is getting too large or risky
- the assistant cannot finish the task cleanly in the current lane
- the user would have to carry avoidable confusion
- a partial task could be forgotten if not marked

## Stop The Affected Lane

When the struggle belongs to one lane, stop that lane.

Do not keep pushing affected downstream work.

Affected downstream work includes:

- save path depending on failed proof
- commit/push depending on unresolved checks
- room move depending on unresolved placement review
- promotion depending on unclear lifecycle state
- source use depending on unverified source boundary
- tool run depending on missing tool gate
- anchor refresh depending on unproven current base

## Continue Only Unaffected Work

The assistant may continue other work only when it does not depend on the blocked lane.

Safe parallel work may include:

- documenting the issue
- capturing the raw problem in Work Shed
- making an idea card
- creating a bookmark
- preparing a separate unrelated support note
- checking unrelated status
- parking a candidate

Do not continue work that inherits the blocked uncertainty.

## Get Or Build The Right Tool

If struggle is caused by missing support, the assistant may build or get:

- checker
- index
- map
- bookmark
- Work Shed helper
- proof gate
- word-key clarity check
- Bell Logic pass
- room sign
- comparison matrix
- retrieval path
- split proof/save flow
- small script or tool gate if explicitly safe and scoped

Any helper/tool must follow doctrine, protect neighbor lanes, stay support-only unless separately promoted, and pass proof.

## Bookmark Requirement

If the assistant cannot finish a task cleanly, it must leave a bookmark.

A bookmark must include:

- task name
- where work stopped
- why work stopped
- what is blocked
- what is safe to continue
- what must not continue
- missing tool/fix/checker/map
- next action
- return trigger
- current file/path/commit position if relevant

A bookmark is not a final pass.

A bookmark prevents the issue from disappearing until it hits later.

## Bookmark Storage

Use the lowest-force correct place.

Possible bookmark locations:

- HOUSE_WORK/WORK_SHED/INBOX for raw unresolved issue
- HOUSE_WORK/WORK_SHED/SORTING_BENCH for active sorting pause
- HOUSE_WORK/WORK_SHED/INDEXES for retrieval pointer
- HOUSE_WORK/TODO for trace-gated future work
- HOUSE_WORK/INDEXES/CURRENT_HOUSE_WORK_STATUS.md for current visible state
- PROOF_HISTORY for proof-related pause receipts
- ACTIVE_ANCHOR.txt only when the active ball/current allowed move changes

## Return Rule

When returning to a bookmarked task:

1. Read the bookmark.
2. Confirm current position.
3. Confirm what was blocked.
4. Confirm what tool/fix was needed.
5. Check whether the missing support now exists.
6. Resume only the safe lane.
7. Prove before save.

## Blocked Behavior

Do not:

- keep fighting through fog
- continue downstream of failed proof
- pretend a bookmark is a fix
- walk away from unfinished work without state
- make the user remember the problem
- solve unrelated work while hiding a blocked dependency
- build a tool that violates doctrine
- let tools command
- skip proof after getting the tool
- delete the old problem because it is inconvenient

## Relationship To Work Shed

The Work Shed is the default place to catch unresolved struggle, tool needs, messy issue piles, and bookmarks that are not yet active authority or proof receipts.

Work Shed can hold the bookmark.

Work Shed cannot command the fix.

## Closing Rule

If struggling, stop the affected lane.

If missing a tool, get or build the tool.

If unfinished, leave a bookmark.

Return with the right support.

Proof decides.

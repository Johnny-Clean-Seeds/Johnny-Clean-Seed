# Chat Assistant Rule Flow Living Ledger

## Helper / lane
Chat assistant rule-flow helper.

## Purpose
Track assistant-side rules that must become file-aware, parked, opened, or applied.

## Current state
Freshen' up is a named reset/orientation ritual.

Assistant-side rules are now treated as file-facing candidates. Most are parked until opened by task fit. Some open immediately when they repair the active task.

## Event 001 - Freshen' up was being used as a chat summary stop

### What happened
The assistant began Freshen' up by summarizing state to chat and treating that as the output.

### User correction
The user said Freshen' up should send the summary to the assistant as internal notes, then use that note to push forward. It should trigger when wheel-spinning or losing track, not when deep thinking is actually needed.

### False blame blocked
The problem was not the Freshen' up ritual itself.

The problem was the assistant using the ritual as a public summary endpoint instead of an internal reset and continuation method.

### Fix
Saved support rule: Freshen' up Internal Orientation and Task Continuation Rule.

### Current behavior
Freshen' up should preserve rope, reduce fog, and continue the active task.

### Reopen trigger
Reopen this event if Freshen' up again ends the task, dumps unnecessary summary, loses the active blocker, or prevents needed deep work.

## Event 002 - Assistant rules need file routes

### What happened
The user clarified that all rules for the assistant are now also for files, mostly parked waiting to be opened unless they have a way to go now.

### Fix
Saved support rule: Assistant Rules to File Parking and Opening Rule.

### Current behavior
New assistant rules should be placed in file lanes as parked/openable material, not left as dead chat.

### Reopen trigger
Reopen if a useful assistant rule remains only in chat, or if a parked rule is promoted without task fit/proof.
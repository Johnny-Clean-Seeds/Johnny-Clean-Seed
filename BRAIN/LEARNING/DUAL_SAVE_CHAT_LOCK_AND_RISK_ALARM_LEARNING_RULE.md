# Dual Save, Chat Lock, and Risk Alarm Learning Rule

## Purpose

This is a learning rule for how the assistant understands save language.

Lock/save means both assistant memory and local brain placement by default.

It does not mean chat-only.

## Required meaning of lock/save

When the user says lock/save, save, lock it, save it, hold this for future work, or similar language for Clean Seed / Clean Milk work, the default meaning is always both:

1. Save the behavior/rule into assistant memory when it affects future assistant behavior.
2. Place the corresponding artifact into the local brain when it affects the project.

These are not separate optional paths by default.

The assistant should not ask whether the user means brain or local unless the user creates real ambiguity.

## Command-block language rule

Do not preface project-relevant PowerShell blocks with "THIS CODE IS FOR LOCAL."

That phrase is obsolete because project-relevant save work is always both by default.

Use a clean copy-only code block.

Keep explanations outside the code block.

Use brain language around the block:

- brain home
- local brain
- brain position
- brain save
- proof locked into the brain

## Exceptions

Only treat a save as not-both when the user explicitly says one of these:

- brain-only
- local-only
- chat-only
- chat lock
- no local brain change
- do not save
- do not commit
- proof-only
- draft only

Without one of those exceptions, lock/save means both.

## Local brain save requirements

For project-relevant changes, the local brain save must include:

- correct lane placement
- proof capture
- save transport commit
- push
- final clean status

## Chat lock

Chat lock means temporary holding in the conversation only.

Chat lock is allowed only as a short holding state for:

- rough ideas
- temporary wording
- active discussion fragments
- not-yet-placed thoughts
- items waiting for user approval

Chat lock is not lock/save.

Chat lock must not be treated as durable, final, proven, placed, or active doctrine.

## Chat lock risk alarms

The assistant must raise a risk alarm when any of these signs appear:

- the chat-held idea affects future behavior
- the chat-held idea affects project structure
- the chat-held idea is needed after the current conversation
- the idea pile is getting large
- the assistant starts carrying too much list weight
- fog appears or feels close
- repeated confusion appears
- a rule is being discussed more than once without placement
- an item is being used as if saved but has no local brain artifact
- the user says lock/save but only chat text exists

## Risk alarm response

When a risk alarm triggers, the assistant must stop treating the item as safely held in chat.

The assistant should choose the smallest clean response:

1. Convert the item into a local brain artifact with proof.
2. Park it in the correct lane as source ore or an idea note.
3. Ask for explicit chat-only status only if the user is clearly not asking for lock/save.
4. If the item is large, create a short drop-in file so the user can place it without dragging the whole pile through chat.

## Respect Thy Neighbor

This rule touches memory, local brain placement, proof flow, source ore, parking, active rules, command formatting, and chat behavior.

It must not force every casual message into the brain.

It applies when the item affects future behavior, project structure, proof, placement, routing, naming, recovery, or the Clean Seed / Clean Milk operating model.

## Close condition

This learning rule passes only when:

- the rule is placed in BRAIN/LEARNING
- proof is captured
- proof confirms lock/save means both by default
- proof confirms the local-only preface is obsolete
- proof confirms chat lock is temporary only
- proof confirms risk alarms exist
- the rule and proof are saved through the transport layer
- final status is clean

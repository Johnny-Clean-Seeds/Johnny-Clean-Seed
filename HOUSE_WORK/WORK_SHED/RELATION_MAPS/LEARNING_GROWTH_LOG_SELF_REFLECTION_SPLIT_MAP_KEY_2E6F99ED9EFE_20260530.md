# Learning Growth Log Self-Reflection Split Map

Date: 2026-05-30
RunId: 20260530_004308
WorkKey: KEY_2E6F99ED9EFE
Status: RELATION MAP SEED / SUPPORT

## Map

`LEARNING_GROWTH_LOG`
: shared system-level event record.

`ACTOR_SELF_AREA`
: local helper/file/script/gate self-reflection area.

`SYSTEM_LEARNING_EVENT`
: whole-chain learning event.

`SELF_REFLECTION_EVENT`
: actor-owned event; actor records `I did this`.

`LIFE_EVENT_CONTEXT`
: outside event/circumstance the actor should know about but does not own.

## Flow

Error happens -> central event is recorded -> actor ownership is judged -> actor-local self event is written if actor caused/shaped the error -> other helpers receive only need-to-know context as circumstances.

## Fit with NEED-to-KNOW bases

The shared log keeps full system truth. Each actor self-area keeps full actor-owned truth. Other helpers receive full role-relevant context, not all self-reflection material.

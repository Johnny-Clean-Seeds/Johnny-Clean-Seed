# MAIL_ROOM - Start Here

Status: active house inbox / pulse-based intake lane.

## Purpose

MAIL_ROOM is the house inbox. It lets the user and assistant work at the same time without turning the root of `123` into storage and without running a forever watcher.

Use it for:

- files dropped while work is already moving
- chat reply packages
- outside source packets
- work notes that should wait their turn
- "you got mail" events that need triage before action

## Current Root

The real mail room is:

`C:\Users\13527\Desktop\123\Jxhnny_Kl33N_Seedz\MAIL_ROOM`

The active tools now resolve MAIL_ROOM from their own script location. They should not create or use a second ghost mail room at:

`C:\Users\13527\Desktop\123\MAIL_ROOM`

## Rule

No always-running scanner.

Use pulses:

- start-of-task pulse
- user-interruption pulse
- before-edit pulse
- before-final pulse
- optional scheduled heartbeat when the user asks for later follow-up

A pulse is a deliberate check, not a background watcher.

## Lanes

- `INCOMING_PACKAGES`: waiting mail.
- `DELIVERED`: mail that has been opened into a delivered object.
- `PROCESSED`: original incoming item after custody.
- `REJECTED`: unsafe or malformed item.
- `RECEIPTS`: local receipts from mail processing.
- `CHAT_REPLY_HOLD`: staged chat reply packages.
- `LETTER_DROP`: temporary one-file letter drop for explicit roundtrip use.

## Priority

Use `INBOX_PULSE_PRIORITY_PROTOCOL_20260524.md`.

Short form:

P0 stops the line.
P1 joins the active task now.
P2 affects current logic soon.
P3 is related source ore.
P4 parks for later.
P5 archives or stays quiet.

## Boundary

Fresh runtime payloads are local by default. They should not be committed to Git unless deliberately promoted into a small durable rule, receipt, index, or report.

No dropped file becomes authority by being dropped.


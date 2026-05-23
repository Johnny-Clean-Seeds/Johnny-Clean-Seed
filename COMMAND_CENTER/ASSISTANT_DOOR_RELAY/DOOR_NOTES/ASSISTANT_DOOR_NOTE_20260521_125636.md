# Assistant Door Note â€” Door Relay V1

Created:

2026-05-21T12:56:36.1454580-04:00

Run ID:

ASSISTANT_DOOR_RELAY_V1_20260521_125636

## Purpose

This note points future assistant work to the missing bridge piece:

ChatGPT cannot directly write to the Windows Child Shell DROPZONE from chat alone.

Assistant Door Relay V1 creates a bounded manual relay:

ChatGPT JSON -> clipboard -> DROP_CHAT_JOB_FROM_CLIPBOARD_V1.ps1 -> Child Shell DROPZONE -> watcher -> OUTBOX receipt.

## Local Door

Relay root:

C:\Users\13527\Desktop\123\COMMAND_CENTER\ASSISTANT_DOOR_RELAY

Relay helper:

C:\Users\13527\Desktop\123\COMMAND_CENTER\ASSISTANT_DOOR_RELAY\TOOLS\DROP_CHAT_JOB_FROM_CLIPBOARD_V1.ps1

Child Shell DROPZONE:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\DROPZONE

Child Shell OUTBOX:

C:\Users\13527\Desktop\123\COMMAND_CENTER\CHILD_SHELL\OUTBOX

## Allowed V1 Action

read_command_center_status

## Blocked V1 Powers

No arbitrary shell.
No raw command execution.
No broad crawl.
No delete.
No repo write.
No git write.
No Level 3 package.
No ACTIVE_GUIDES rewrite.
No CURRENT_TRUTH_INDEX rewrite.
No doctrine rewrite.

## How To Use

1. Ask the assistant for an Assistant Door Relay V1 childjob JSON.
2. Copy only the JSON to clipboard.
3. Run:

powershell -ExecutionPolicy Bypass -File "C:\Users\13527\Desktop\123\COMMAND_CENTER\ASSISTANT_DOOR_RELAY\TOOLS\DROP_CHAT_JOB_FROM_CLIPBOARD_V1.ps1"

4. Paste the relay output back to the assistant.

## Meaning

If the OUTBOX receipt appears, the chat-to-local manual relay works.

This does not prove zero-copy phone-to-PC execution.

For zero-copy phone-to-PC execution, a later Remote Door Relay needs a shared relay surface both chat and the PC watcher can touch.

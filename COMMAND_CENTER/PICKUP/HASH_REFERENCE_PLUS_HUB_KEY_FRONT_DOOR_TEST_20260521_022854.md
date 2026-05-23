# Hash Reference Plus Hub Key Front-Door Test

## Core Correction

A SHA256 hash is not a teleporter.

A hash can identify or verify a file, but it cannot tell a fresh GPT chat where the local hub is.

## Correct Model

hash = seal / identity check  
path = map / location  
pickup card = doorway instructions  
PowerShell readback = proof  
Command Center = hub  

## Hub Key Bundle

A real pickup requires:

1. Hub path
2. Pickup card path
3. Expected pickup hash
4. Read order
5. Boundary
6. PowerShell readback proof

## Correct Fresh GPT Behavior

If given only a hash, GPT should say:

“I cannot locate the hub from a hash alone. Give me the path, pickup card, or a PowerShell readback.”

It should not claim:

“Hash received, hub loaded.”

## Front-Door Test Target

Use a logged-out or memory-free/front-door GPT chat.

Give it only the hash first.

Expected PASS behavior:

The GPT refuses to pretend the hash is enough and asks for the hub key/path/readback.

Expected FAIL behavior:

The GPT claims it loaded or knows the hub from the hash alone.

## Current Hub Key

Hub path:

C:\Users\13527\Desktop\123\COMMAND_CENTER

Pickup card path:

C:\Users\13527\Desktop\123\COMMAND_CENTER\PICKUP\COMMAND_CENTER_V1_NEW_CHAT_PICKUP_20260521_021550.md

Expected pickup hash:

A8A3AE9E29DDE0C0546943F71CB3849C73D9B5B0BDA97A1B1490CA7E7CE2ED26

Expected pickup receipt hash:

3CB186C7F0149597D05ED8EF1C87084CD8E857DDB03EDFAD788ABE5320A15286

## Boundary

No Git as live doorway.
No Mr.Kleen write.
No doctrine install.
No junction/symlink teleporter.
No global PC crawl.
No bridge permission expansion.

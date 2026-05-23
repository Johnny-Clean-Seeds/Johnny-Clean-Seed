PORCH MOVE DROPPER

ROLE:
USER BUTTON / ONE-SHOT HOUSEKEEPER.

WHAT IT DOES:
Reads project-looking files sitting on the porch, classifies them by filename, and MOVES them to a lane under Desktop\123.

DEFAULT:
Plan only.

HOW TO USE - PLAN:
pwsh -NoProfile -ExecutionPolicy Bypass -File "C:\Users\13527\Desktop\123\PORCH_WATCHER\TOOLS\RUN_PORCH_MOVE_DROPPER_ONCE.ps1"

HOW TO USE - MOVE:
pwsh -NoProfile -ExecutionPolicy Bypass -File "C:\Users\13527\Desktop\123\PORCH_WATCHER\TOOLS\RUN_PORCH_MOVE_DROPPER_ONCE.ps1" -Execute

WHY IT EXISTS:
Porch files must not sit loose.
The default intake action is MOVE, not COPY.
Copy is only allowed for explicitly labeled export/mirror/drop-copy files.

SUCCESS:
A receipt appears in:
C:\Users\13527\Desktop\123\PORCH_WATCHER\RECEIPTS

FAILURE:
The receipt or console says BLOCKED or FAILED.
Paste the bottom block into chat.

IMPORTANT:
This does not delete files.
This does not commit.
This does not push.
It moves loose porch files into lanes.

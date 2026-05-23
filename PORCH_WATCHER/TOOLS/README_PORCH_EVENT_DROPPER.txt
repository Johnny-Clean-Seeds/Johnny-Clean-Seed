PORCH EVENT DROPPER

ROLE:
USER BUTTON / ONE-SHOT MAIL TRIGGER.

WHAT IT DOES:
Scans the porch dropbox and records a YOU GOT MAIL event where the assistant enters.

DROP FOLDER:
C:\Users\13527\Desktop\123\PORCH_WATCHER\DROPBOX_DROP_FILES_OR_FOLDERS_HERE

WHERE THE TRIGGER LANDS:
C:\Users\13527\Desktop\123\COMMAND_CENTER\CURRENT_CONTEXT_CART

HOW TO USE:
1. Drop a file or folder into the DROPBOX folder.
2. Run RUN_PORCH_EVENT_DROPPER_ONCE.ps1.
3. The tool moves the object to the right lane and writes YOU_GOT_MAIL event.

FOLDER RULE:
A dropped folder is a package.
The tool records the folder name as the package identity.
It moves the whole folder as a package.
It does not scatter the internal files first.

FILE RULE:
A dropped file is classified by filename.
The tool moves it to a lane or sorting table.

SUCCESS:
A YOU_GOT_MAIL__PORCH_EVENT_TRIGGER file appears in:
C:\Users\13527\Desktop\123\COMMAND_CENTER\CURRENT_CONTEXT_CART

FAILURE:
A receipt appears in:
C:\Users\13527\Desktop\123\PORCH_WATCHER\RECEIPTS

BOUNDARY:
Default is MOVE, not COPY.
No delete.
No background automation.

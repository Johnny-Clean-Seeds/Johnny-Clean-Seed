# PowerShell Delivery Long Box Failure Capture 20260522

Status: FAILURE CAPTURE / REPAIR NOTE.

Failure:
The assistant changed behavior around code delivery and then continued sending long tall PowerShell boxes after the user corrected the desired source pickup route.

Root cause:
The assistant mixed separate rules instead of applying Rule-Fit / No Side-Mutation Gate.

Correct repair:
Keep code delivery style stable and compact. Keep source/material pickup defaulting to Desktop\123 root. Do not mutate one rule because another rule was added.

Source capture:
C:\Users\13527\Desktop\123\RULE_INTAKE\POWERSHELL_DELIVERY_NO_LONG_TALL_CODE_BOXES_20260522\POWERSHELL_DELIVERY_NO_LONG_TALL_CODE_BOXES_SOURCE_CAPTURE_20260522.md

Source capture SHA256:
96764BA0CF24E824796232E145FC8CC73591411D9D19932BC410D16D5B1D3C28

Boundary:
Behavior delivery rule and failure capture only. No doctrine promotion. No active guide rewrite. No CURRENT_TRUTH_INDEX rewrite. No automation.

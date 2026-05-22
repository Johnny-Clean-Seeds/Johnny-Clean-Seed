# Rule Addition Flow-Mutation Failure Capture 20260522

Status: FAILURE CAPTURE / REPAIR NOTE.

Failure:
The assistant received a correction about source pickup from Desktop\123 root and incorrectly changed surrounding code-delivery behavior.

Root cause:
The assistant mixed two separate rules:
- source/material pickup route
- code delivery style

Correct repair:
New rule additions must pass Rule-Fit / No Side-Mutation Gate before altering behavior.

Protected existing flow:
Code delivery style stays stable unless the user asks to change it.

New additive rule:
Source/material pickup defaults to Desktop\123 root when the needed source/material already exists there.

Growth clarification:
More rules are allowed when they are clean placed. Do not remove or mutate existing ideas just because a new rule arrives.

Source capture:
C:\Users\13527\Desktop\123\RULE_INTAKE\RULE_FIT_AND_CLEAN_BLOAT_20260522\RULE_FIT_AND_CLEAN_BLOAT_SOURCE_CAPTURE_20260522.md

Source capture SHA256:
3F70C7BA5EAE045AD5EFA63E8104F5CF52A2D74EDB3D237F65CD926BADA62855

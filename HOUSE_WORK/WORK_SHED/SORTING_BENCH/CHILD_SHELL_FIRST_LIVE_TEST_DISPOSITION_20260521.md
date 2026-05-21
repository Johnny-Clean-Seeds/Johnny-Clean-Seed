# Child Shell First Live Test Disposition

Date: 2026-05-21
Lane: HOUSE_WORK / WORK_SHED / SORTING_BENCH
Status: PASS WITH WATCH / SUPPORT EVIDENCE

## Sorting formula

OBJECT: Child Shell / Sub-PowerShell actuator.

INTENT: Prove the bridge can act safely through child actions and refuse unsafe ones.

MODE: LIVE TEST / TOOL PROOF.

PLACE: Local Hard Bridge V1 in 123; save support rule to Mr.Kleen after proof.

AUTHORITY: User direction, bridge policy, responses, receipts, and git front-door readback.

PROOF: Allowed action, blocked overwrite, blocked raw shell, clean house front door.

DISPOSITION: Save as support rule and card. Do not expand permissions.

## Evidence

Bridge root:
C:\Users\13527\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1

Runner SHA256:
613442DDB0C4A8850BA17B0B8E2BE8D71A9706B9692A2251B748CC5373567106

Policy SHA256:
574572C92D1E082F2A74EBBA01113468AD6BBA371595DE69CEC8B05FD7FA2A5D

Front door response:
C:\Users\13527\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1\HUB\RESPONSES\REQ_CHILD_SHELL_FRONT_DOOR_20260521_001704_RESPONSE.json
SHA256:
273BA1AD09B28D23E8B49C34B29A06760F175E3A207AA5DC7D70D6392C00C547

Write/create response:
C:\Users\13527\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1\HUB\RESPONSES\REQ_CHILD_SHELL_OVERWRITE_BLOCK_20260521_001704_RESPONSE.json
SHA256:
238A7438EA529AC55A9EB23DA74822694C98F0F74F5489BB39E09A1500A02714

Overwrite-block response:
C:\Users\13527\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1\HUB\RESPONSES\REQ_CHILD_SHELL_WRITE_20260521_001704_RESPONSE.json
SHA256:
B570E4F63A91771A97C3A9F25BC9EC8550CF0D1B8CA5D1F774F029FAB57C9B69

Raw-shell-block response:
C:\Users\13527\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1\HUB\RESPONSES\REQ_CHILD_SHELL_RAW_SHELL_BLOCK_20260521_001704_RESPONSE.json
SHA256:
E5BEB96F2170E5F325D8BDEFD59FDCF133F50A5A9AC21930CA30BE26D66A6B0D

Created target:
C:\Users\13527\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1\WORKSPACE\CHILD_SHELL_TEST\child_shell_first_limb_20260521_001704.md
SHA256:
B5E05E44F6A256ABFE724C5985C67C92114A9F62416222CFE696B76533AD1F03

## Verdict

PASS WITH WATCH.

Functional proof passed:
- house_front_door returned branch main, matching HEAD and origin/main, and clean true;
- child write action created one file inside WORKSPACE;
- second write to same file was blocked;
- raw shell was blocked;
- receipts existed.

Watch issue:
The test request labels were inverted by lexicographic processing. The request named OVERWRITE_BLOCK ran before the request named WRITE. Future dependent tests need ordered IDs such as 01, 02, 03, 04 or separate phases.

## Boundary

No doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, runtime, automation, dashboard, network service, bridge permission expansion, house write, git commit, or git push was performed by the bridge test.

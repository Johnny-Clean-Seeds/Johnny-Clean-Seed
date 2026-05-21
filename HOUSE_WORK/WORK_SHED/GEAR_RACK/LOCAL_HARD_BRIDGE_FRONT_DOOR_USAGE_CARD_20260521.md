# Local Hard Bridge Front Door Usage Card

Date: 2026-05-21
Lane: HOUSE_WORK / WORK_SHED / GEAR_RACK
Status: REUSABLE CARD / SUPPORT ONLY

## Front door rule

Before nontrivial bridge-assisted house work, run or inspect a house_front_door response.

Required clean state:

- branch main;
- HEAD present;
- origin/main present;
- HEAD equals origin/main for save work;
- clean true or clear dirty paths;
- ACTIVE_ANCHOR exists;
- CURRENT_TRUTH_INDEX exists.

## If dirty

Stop. Diagnose whether dirty paths are expected active save, failed helper residue, dock copy dirt, or unrelated changes.

## If git output is nonsense

Stop. Tool failure. Repair bridge before trusting it.

## V1 write boundary

V1 may write new text only inside LOCAL_HARD_BRIDGE_V1/WORKSPACE.

V1 may read house files but may not write house files, commit, push, delete, overwrite, or execute arbitrary shell.

## Use result

Bridge responses can support house work, but house saves still require normal receipt, git proof, and final clean status.

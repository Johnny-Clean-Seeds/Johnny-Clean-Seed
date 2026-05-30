# Hash-Key Front Gate Expected Partial Dirty Block Power-Play

Status: FAILURE POWER-PLAY / REPAIR ROUTE V1.2
Authority: sorting-bench evidence and helper learning, not doctrine

## What happened

The V1 save route failed during staged-set verification because an inline `-split` operator was parsed as a parameter. That failure happened after the script had already written and staged the planned architecture files.

The V1.1 repair route then passed Code Gate, but blocked in write mode before saving because `git status --short` was not clean.

Error family:

`DIRTY_REPO_BLOCKED_BEFORE_SAVE`

Dirty state contained planned hash-key front gate package files, including BRAIN_LEARNING files, WORK_SHED templates/maps/ledgers, TODO/status updates, and prior proof/manifest files from the failed route.

## What was falsely blamed

- not the user;
- not the architecture idea;
- not `learning_material.txt`;
- not Code Gate;
- not random repo contamination until proven otherwise.

## Root cause

The repair route required a clean repo but did not recognize expected partial artifacts from the immediately previous failed save.

## Fix

V1.2 classifies dirty status before blocking. If every dirty path belongs to the expected hash-key front gate package or exact prior manifest/receipt pattern, V1.2 labels it as recovered expected partial, preserves it as evidence, includes it in staged-set verification, and proceeds.

Unknown dirty paths still block.

## Learning

Dirty repo is not one condition. It must be classified. Expected partial from the same failed save is a recovery lane. Unknown dirty state remains a hard stop.

## Reopen trigger

Reopen if save helpers either block on expected partial without classification or continue through unknown dirty state without stopping.
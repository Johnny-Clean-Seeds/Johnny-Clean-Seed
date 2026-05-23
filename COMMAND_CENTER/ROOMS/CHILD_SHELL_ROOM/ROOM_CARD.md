# ROOM CARD - CHILD_SHELL_ROOM

Created: 2026-05-21T02:09:30.7439676-04:00
Status: CONTROLLED ATMOSPHERE ROOM / V1

## Purpose
Hold bridge helper tests, child shell evidence, hardening scouts, and local-action proof.

## Target Path
C:\Users\13527\Desktop\123\TOOLS\LOCAL_HARD_BRIDGE_V1

## Allowed Inputs
- bridge request files
- helper scripts
- test reports
- response/receipt readbacks

## Allowed Outputs
- green proof blocks
- evidence reports
- hardening findings
- safe helper files

## Allowed Actions
- run local diagnostic
- read response
- read receipt
- hash output
- prepare hardening note

## Blocked Actions
- arbitrary shell expansion
- delete action
- overwrite action
- house write mode
- git commit/push
- network service

## Proof Required
- request ids
- responses
- receipts
- hashes
- front door state when relevant

## Receipt Lane
RECEIPTS

## Close Condition
Test passes, fails, or yields with evidence report.

## Return Path
COMMAND_CENTER/OUTBOX_TO_CHAT

## Boundary
This room does not grant global PC access. It only defines a controlled atmosphere, intended route, and proof requirement.

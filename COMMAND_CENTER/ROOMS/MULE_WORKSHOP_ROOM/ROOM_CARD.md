# ROOM CARD - MULE_WORKSHOP_ROOM

Created: 2026-05-21T02:09:30.7218238-04:00
Status: CONTROLLED ATMOSPHERE ROOM / V1

## Purpose
Stage mule handoffs, mule returns, manifests, request cards, and return receipts without letting mule work bleed into the house.

## Target Path
C:\Users\13527\Desktop\MR_KLEEN_MULE_WORKSHOP_LOCAL

## Allowed Inputs
- handoff packets
- request cards
- return folders
- manifest files

## Allowed Outputs
- return readbacks
- intake receipts
- disposition notes
- archive decisions

## Allowed Actions
- stage packet
- read manifest
- inventory return
- copy return to intake lane
- write receipt

## Blocked Actions
- direct doctrine install
- silent overwrite
- delete return evidence
- git commit/push
- unbounded folder crawl

## Proof Required
- manifest
- file count
- hashes when relevant
- receipt

## Receipt Lane
RECEIPTS

## Close Condition
Mule work is staged, returned, archived, or parked with receipt.

## Return Path
COMMAND_CENTER/OUTBOX_TO_CHAT

## Boundary
This room does not grant global PC access. It only defines a controlled atmosphere, intended route, and proof requirement.

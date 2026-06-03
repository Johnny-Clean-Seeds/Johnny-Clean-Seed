# Command Grammar V0.3 Confirmation Card Suit Card

Saved: 20260603_132904

## Wear now

COMMAND_GRAMMAR_V0_3_CONFIRMATION_CARD_TARGET

## Apply when

The system resolves a user phrase into any action that might:

- execute a script
- run a verifier
- write operational state
- commit or push
- force-add ignored paths
- implement code
- mutate files
- alter policy, registry, contracts, tool cards
- start watchers
- move, delete, rename, or clean
- touch protected files

## Required behavior

1. Do not treat resolved intent as permission.
2. Show the resolved command and target.
3. Show mode and risk.
4. Show exact files to read/write/stage.
5. Show blocked powers.
6. Show DoesNotProve and StopLine.
7. Ask for confirmation when required.
8. If no answer, do nothing.
9. Expire card when repo head, pointer, evidence, script, staged set, or lane changes.
10. Never execute expired cards.

## Required default

DefaultIfNoAnswer: PAUSE_NO_ACTION

## StopLine

Do not implement command grammar execution until V0.4 pointer read/write rules and V0.5 first read-only inspect command are designed.

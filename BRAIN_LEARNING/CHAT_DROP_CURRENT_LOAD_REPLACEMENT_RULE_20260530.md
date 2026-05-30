# Chat Drop Current Load Replacement Rule

Date: 2026-05-30
Status: BRAIN LEARNING / CHAT DROP OPERATION RULE / NOT DOCTRINE
WorkKey: CHAT-DROP-CURRENT-LOAD-REPLACEMENT-20260530-V1

## Rule

The root of `C:\Users\13527\Desktop\Chat Drop` is a current live-load tray, not an accumulating archive.

Anytime new Chat Drop files are generated, the new intended load must replace the current visible root load.

## Required behavior

1. Move existing root-level Chat Drop files into an archive folder.
2. Keep `_SYNC_REPORTS`, `_CLEANUP_REPORTS`, and other folders in place.
3. Restore only the intended current load files back into the root.
4. Save a cleanup/rotation report.
5. Do not delete old files unless the user explicitly asks.
6. Do not treat archived Chat Drop files as current authority.

## Why

A polluted Chat Drop root creates false current context. It makes old suit cards, source drops, and reports look live. That breaks the front-door compression rule.

The clean shape is:

URL / LEDGER / MAP / KEY / needed current tunnel only.

## Boundary

Local Chat Drop rotation plus rule/receipt only. No delete, no broad house refactor, no watcher, no automation, no Whirlpool, no doctrine, no ACTIVE_GUIDES rewrite, no CURRENT_TRUTH_INDEX rewrite.

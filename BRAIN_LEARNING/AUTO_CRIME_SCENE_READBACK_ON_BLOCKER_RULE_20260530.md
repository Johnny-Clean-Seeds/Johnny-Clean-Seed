# Auto Crime Scene Readback on Blocker Rule

Date: 2026-05-30
Status: BRAIN LEARNING / SAVE-ROUTE GUARD / NOT DOCTRINE
WorkKey: LOWER-LAYER-SAVE-ROUTE-HARNESS-ROOT-REPAIR-20260530-V1-2

## Rule

When a save-route helper detects an unexpected blocker, it should automatically print a bounded crime-scene readback before stopping.

## Required readback

- reason for stop;
- repo path;
- HEAD;
- origin/main;
- `git status --porcelain`;
- staged files;
- unstaged files;
- recent commits.

## What it must not do

It must not reset, clean, delete, move, unstage, or keep going unless the state is proven bounded and intentionally recoverable.

## Why

The user should not have to ask for who/what/how/when/where evidence after every failure. The helper should preserve the crime scene automatically.

## Boundary

Readback/evidence only unless the state is proven bounded. No broad refactor, delete, move, watcher, automation, Whirlpool, doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, universal mapper, graph database, or whole-house crawl.
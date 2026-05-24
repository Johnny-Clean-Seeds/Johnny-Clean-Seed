# TODO - Remote Door Token Tracking Security Audit

Status: OPEN TODO / SECURITY-SCOPED FOLLOW-UP
Date: 2026-05-24

## Trigger

A full cached-index pattern scan during the whole-house wash found pre-existing tracked remote-door
files with token-like URL material.

This was not introduced by the current staged house-wash packet.

## Boundary

Do not print token values in reports.
Do not rotate, delete, rewrite history, or change remote-door behavior inside an unrelated docs/save
pass.
Do not assume templates such as `token=TOKEN` are live secrets.
Do not assume live-looking values are harmless without a scoped audit.

## Clean Follow-Up

Run a scoped security audit that:

1. Lists tracked files containing token-like or credential-like material without exposing values.
2. Separates templates, code interpolation, local receipts, old external test receipts, binaries, and
   live configuration.
3. Decides for each item: keep, redact, move local-only, rotate, remove from current tree, or history
   cleanup needed.
4. Checks whether any token-like value is still live.
5. Saves a receipt that names files and decisions without leaking values.

## Return Trigger

User opens a remote-door/security cleanup pass, or any future save touches remote-door receipts,
backups, tunnels, tokens, or credential-like strings.

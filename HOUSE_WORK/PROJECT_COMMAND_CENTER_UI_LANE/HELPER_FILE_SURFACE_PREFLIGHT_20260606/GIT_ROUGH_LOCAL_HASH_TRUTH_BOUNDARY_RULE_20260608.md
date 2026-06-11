# GIT_ROUGH_LOCAL_HASH_TRUTH_BOUNDARY_RULE_20260608

Status: ACTIVE_LOCAL_RULE_CARD / GIT_BOUNDARY_FIX / ROUGH_LOCAL_HASH_TRUTH / NOT_DOCTRINE / NOT_PUBLIC_CONTENT_AUTHORITY

Created: 2026-06-08 17:43:14

Purpose:
Fix the ambiguity where "this needs to go to Git too" could be read as permission to stage full local evidence, incident folders, scripts, logs, or sensitive artifacts.

Correct rule:
When an artifact, incident folder, evidence bundle, script copy, log, or local proof surface is too big, too local, too sensitive, or not approved for public/full-content Git, Git receives only a bounded ROUGH_LOCAL hash ledger.

LOCAL keeps the real evidence.
GIT gets the hash truth / rough_local pointer.
HASHES bridge the truth.

Definitions:

LOCAL_EVIDENCE:
Actual files, incident folders, failed artifacts, fixed artifacts, logs, receipts, screenshots, scripts, helper outputs, or sensitive/full-size material preserved on the user's machine.

ROUGH_LOCAL:
A bounded Git-safe ledger that records local path, filename, SHA256, scope, incident summary, what changed, what is intentionally local-only, and DoesNotProve.

HASH_TRUTH:
The SHA256 record that lets Git point to local evidence without carrying the evidence contents.

Default behavior:
Do not stage full incident folders.
Do not stage failed script copies.
Do not stage fixed script copies unless explicitly approved.
Do not stage raw logs or sensitive local evidence.
Do not stage large helper bundles by default.
Do not stage private/local-only source surfaces by default.

Allowed Git-safe surfaces by default:
ROUGH_LOCAL hash ledger.
Small rule card.
Small receipt listing filenames, paths, SHA256 hashes, scope, and local-only warning.
DoesNotProve boundary.

Not allowed unless user explicitly approves full-content Git:
Full incident folder.
Error logs with sensitive/local content.
Failed artifact copy.
Fixed artifact copy.
Large evidence bundles.
Private/local-only helper/source files.
Any file whose content is not meant to leave local custody.

Required wording when Git receives only a rough_local ledger:
Git does not contain the full evidence. Local machine custody remains authoritative. SHA256 hashes are the truth bridge for the local evidence listed here.

Fix to prior ambiguous reading:
User approval that something "needs to go to Git too" means: create/stage a Git-safe rough_local hash ledger unless the user explicitly says to put the full evidence contents in Git.

DoesNotProve:
This rule does not approve Git staging, commit, push, public release, full evidence upload, source mutation, cleanup, routing, doctrine promotion, or current truth index rewrite. It only defines the boundary for what kind of Git record is safe by default.

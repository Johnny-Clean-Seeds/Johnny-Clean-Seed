# Chat Drop Pull Means Local Files Rule V0.1

Status: PUBLIC_NOTE / CHAT_DROP_LANGUAGE_RULE / NOT_DOCTRINE
Date: 2026-06-13

Purpose:
Stop outside agents and local agents from treating plain user language like Git commands.

## Rule

In Clean Seeds, plain `pull` means take from, read from, inspect, or bring forward from the named local file surface.

Plain `pull` does not mean GitHub, Git remote, clone, fetch, sparse checkout, or `git pull`.

For Chat Drop work, `pull the chat drops` means use the two required local Chat Drop folders:

1. `C:\Users\13527\Desktop\123\Chat Drop`
2. `C:\Users\13527\Desktop\Chat Drop`

## Git Boundary

Only use Git or GitHub when the user explicitly says one of:

- `git`
- `GitHub`
- `remote`
- `repo`
- `branch`
- `commit`
- `clone`
- `fetch`
- `git pull`
- a repo URL

If those words are not present, do not invent a Git lane.

## Ambiguous Pull Handling

If the target is unclear, ask a short clarification or run only a local read-only scan.

Safe default for `pull Chat Drops`:

`powershell -NoProfile -ExecutionPolicy Bypass -File .\TOOLS\ChatDropFreshnessScanner.ps1`

That scanner may report local state only. It must not move, delete, rename, edit, commit, push, clone, fetch, or pull from GitHub.

If the user needs a local assistant bundle of the current Chat Drop helpers, use:

`powershell -NoProfile -ExecutionPolicy Bypass -File .\TOOLS\Invoke-ChatDropLocalPull.ps1`

That runner must resolve the public repo front door from its own script path, verify both local Chat Drop folders by hash, copy only the current load set into an output bundle, and build the combined assistant markdown from file contents. Do not paste a long interactive PowerShell block for this job.

## False Pass Block

No helper script may print `PASS`, `COMPLETE`, or a green verdict after:

- a thrown error;
- a failed copy;
- a missing source;
- an unset proof variable;
- a missing hash;
- a failed hash comparison;
- a skipped required proof step.

If proof fails, the only honest close is `BLOCKED`, `FAILED`, or `YIELD`, with the missing proof named.

For combined assistant bundles, `## Files` is markdown content, not PowerShell syntax. Build it from a script file and validate that the combined output exists, has content, and contains the expected `## Files` and `## FILE 1:` markers before printing a pass verdict.

## Agent Sentence

When using this rule, say:

`Plain pull means local files here. I will not use Git or GitHub unless you explicitly say Git/GitHub/remote/repo/branch/commit/git pull.`

## Does Not Prove

This rule does not prove the local Chat Drop folders match, does not authorize cleanup, does not authorize Git operations, does not make Chat Drop source authority, and does not replace the current user command.

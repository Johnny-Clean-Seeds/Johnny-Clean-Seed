# PowerShell Tool Candidate Text Inspection

Date: 2026-05-19
State: read-only inspection result
Authority: incoming-file parking / tool-candidate classification only
Starting base: main @ 2ff2b8a

## Job

Classify ignored PowerShell tool candidates without running them.

Inspect means: read as text, hash, scan risk words, understand job.

Execute means: run the script. No script was executed in this pass.

## Summary Verdict

The ignored PowerShell layer is not junk and not trusted tooling yet.

It splits into:

- nine root read-only checker candidates,
- one higher-risk daily digest gate candidate that writes a directory and calls native git.

The whirlpool can now move because the tool pile is no longer invisible.

## Candidate Classification

| File | SHA256 | Text-read job | Risk words found | Lane | Next action |
|---|---|---|---|---|---|
| CHECK_ASSISTANT_HOME_MODEL_CARD_001.ps1 | 0607DA3AF484E35D5CD3CE7BE5464C71CAEB2C6B276D222A0FE7ED23098686DC | Checks assistant home model-card wording by reading files and printing PASS/FAIL. | Write-Host only from scan. | 02_TOOL_CANDIDATES | Keep as read-only checker candidate; do not execute until selected and repo root is confirmed. |
| CHECK_ASSISTANT_SUIT_OPERATING_SYSTEM_001.ps1 | 5BD406C4E1E37617040039E72590A12AE11D615CBADEBEC3DE48C1226D8F1D07 | Checks active guide / suit operating-system wording by reading files and printing PASS/FAIL. | Write-Host only from scan. | 02_TOOL_CANDIDATES | Keep as read-only checker candidate; inspect exact assertions before any use. |
| CHECK_BRAIN_PROGRESS_LOCK_001.ps1 | 4D1FB7ECC1931658477B247438913681634C7D023DE7831E728FD4A9306A98EB | Checks brain progress lock wording by reading files and printing PASS/FAIL. | Write-Host only from scan. | 02_TOOL_CANDIDATES | Keep as read-only checker candidate; inspect exact assertions before any use. |
| CHECK_DUPLICATE_GUIDE_SURFACE_SYNC_001.ps1 | CFF67B72885647CD346D4FCE76A913D77E3FEB3DA5330371AB6874B73E008432 | Checks root guide pointers versus active guide bodies and public map wording. | Write-Host only from scan. | 02_TOOL_CANDIDATES | Useful checker candidate; needs current-root guard review before use. |
| CHECK_FRESH_PUBLIC_ENTRY_TEST_001.ps1 | 01861E624CB53845BF045E5B18A554B7B06C0A899151AE1441255E45BF3D38A5 | Checks public entry route, active guide packet, and public house map. | Write-Host only from scan. | 02_TOOL_CANDIDATES | Useful checker candidate; inspect for stale public-route assumptions before use. |
| CHECK_HOME_LANGUAGE_COEXISTENCE_001.ps1 | 46C8B566341A158EE1ECE1BC1836F1AA61A73D6957925FBC77DF8E820C75AA84 | Checks home/public language coexistence wording. | Write-Host only from scan. | 02_TOOL_CANDIDATES | Useful checker candidate; inspect for stale wording before use. |
| CHECK_PUBLIC_FORMAT_AND_WORD_KEYS_001.ps1 | 5FFB268EBA47DDCB010030665942BF52FB859041CE6214F2EB4E1F9DE074BAB0 | Checks public format and word-key wording. | Write-Host only from scan. | 02_TOOL_CANDIDATES | Useful checker candidate; inspect exact assertions before use. |
| CHECK_PUBLIC_HOUSE_MAP_FIX_001.ps1 | 3CEC17468CBB391258A06C747FCA3C9AE1217A2693AC15C1F72BB5338E18D9FA | Checks public house map repair surface. | Write-Host only from scan. | 02_TOOL_CANDIDATES | Useful checker candidate; inspect for stale proof path before use. |
| CHECK_REPEATED_FAILED_PROOF_CONTAINMENT_001.ps1 | 5FE0A25A28529A56C9CC34C7D5F95B8C656CE38FAA4D3958EDC7123AA3695D2E | Checks repeated failed-proof containment wording. | Contains text phrase "exit before git add."; no git command found by risk scan. | 02_TOOL_CANDIDATES | Useful checker candidate; inspect exact failure-proof assertions before use. |
| HOUSE_WORK/TOOLS/Invoke-DailyHouseWalkDigestGate.ps1 | 4AE2F59FB93208E17A15D30719BA09BB1A59D8F77D693571DA56356FC2B681CE | Daily digest gate candidate. Checks repo, log dir, local time, today logs, and git position/status. | Native git calls through checked wrapper after repair; no New-Item after repair. | 02_TOOL_CANDIDATES / 06_REMOTE_BRAIN_CANDIDATE after this repair commit | Repaired as text: `param()` first, strict mode, checked native git exit codes, no directory creation, restores original location. Do not execute until explicitly selected. |

## Pattern Found

The root checker scripts mostly appear to be read-only text/file checkers, but they are still ignored tool candidates.

They should not become trusted just because they exist.

The daily digest gate was different. It was operationally useful, but it crossed from inspection into file creation and native git inspection. It was repaired in text before execution or remote-brain trust.

## Whirlpool Result

The incoming tool pile now has a first current path:

1. keep all ten scripts in tool-candidate lane for now,
2. do not execute any ignored script yet,
3. after the daily digest gate repair commit, review the nine root checkers as a batch of read-only checker candidates,
4. execute nothing until a current task selects one script and its guard checks are clean.

## Boundary

No script executed.
No ignored script force-added during initial text inspection.
Only the repaired daily digest gate script is a remote-brain candidate for this repair commit.
No delete.
No active guide rewrite.
No doctrine install.
No runtime automation.

Update after repair:
HOUSE_WORK/TOOLS/Invoke-DailyHouseWalkDigestGate.ps1 was repaired as a related tool candidate and should be force-added only with this repair commit, not as a blanket ignored-script add.

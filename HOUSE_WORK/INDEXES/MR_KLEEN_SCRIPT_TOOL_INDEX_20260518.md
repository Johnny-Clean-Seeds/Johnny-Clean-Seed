# Mr.Kleen Script / Tool Index

Status: SUPPORT MAP
Authority: support only; not command authority

## Purpose

This file labels scripts and tool rooms so they do not look like mystery active commands.

It does not run scripts.

It does not move scripts.

It does not approve tool use.

It gives tool placement so future work can choose tools cleanly when a current task and proof need select them.

## Core Rule

A script existing in Mr.Kleen does not mean it should be run.

A tool room existing in Mr.Kleen does not authorize runtime, bridge, cleanup, status-command, or install work.

Tool use requires current task selection, scope, and proof need.

## Root Script / Tool Files

### CHECK_ASSISTANT_HOME_MODEL_CARD_001.ps1

Kind: PowerShell script
Path: CHECK_ASSISTANT_HOME_MODEL_CARD_001.ps1
SHA256: 0607DA3AF484E35D5CD3CE7BE5464C71CAEB2C6B276D222A0FE7ED23098686DC
Length: 1635
LastWriteTime: 05/17/2026 18:51:58
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

### CHECK_ASSISTANT_SUIT_OPERATING_SYSTEM_001.ps1

Kind: PowerShell script
Path: CHECK_ASSISTANT_SUIT_OPERATING_SYSTEM_001.ps1
SHA256: 5BD406C4E1E37617040039E72590A12AE11D615CBADEBEC3DE48C1226D8F1D07
Length: 2734
LastWriteTime: 05/17/2026 19:51:00
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

### CHECK_BRAIN_PROGRESS_LOCK_001.ps1

Kind: PowerShell script
Path: CHECK_BRAIN_PROGRESS_LOCK_001.ps1
SHA256: 4D1FB7ECC1931658477B247438913681634C7D023DE7831E728FD4A9306A98EB
Length: 1591
LastWriteTime: 05/17/2026 19:06:02
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

### CHECK_DUPLICATE_GUIDE_SURFACE_SYNC_001.ps1

Kind: PowerShell script
Path: CHECK_DUPLICATE_GUIDE_SURFACE_SYNC_001.ps1
SHA256: CFF67B72885647CD346D4FCE76A913D77E3FEB3DA5330371AB6874B73E008432
Length: 2819
LastWriteTime: 05/17/2026 18:29:02
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

### CHECK_FRESH_PUBLIC_ENTRY_TEST_001.ps1

Kind: PowerShell script
Path: CHECK_FRESH_PUBLIC_ENTRY_TEST_001.ps1
SHA256: 01861E624CB53845BF045E5B18A554B7B06C0A899151AE1441255E45BF3D38A5
Length: 4483
LastWriteTime: 05/17/2026 18:33:31
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

### CHECK_HOME_LANGUAGE_COEXISTENCE_001.ps1

Kind: PowerShell script
Path: CHECK_HOME_LANGUAGE_COEXISTENCE_001.ps1
SHA256: 46C8B566341A158EE1ECE1BC1836F1AA61A73D6957925FBC77DF8E820C75AA84
Length: 4673
LastWriteTime: 05/17/2026 19:43:05
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

### CHECK_PUBLIC_FORMAT_AND_WORD_KEYS_001.ps1

Kind: PowerShell script
Path: CHECK_PUBLIC_FORMAT_AND_WORD_KEYS_001.ps1
SHA256: 5FFB268EBA47DDCB010030665942BF52FB859041CE6214F2EB4E1F9DE074BAB0
Length: 3148
LastWriteTime: 05/17/2026 18:57:24
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

### CHECK_PUBLIC_HOUSE_MAP_FIX_001.ps1

Kind: PowerShell script
Path: CHECK_PUBLIC_HOUSE_MAP_FIX_001.ps1
SHA256: 3CEC17468CBB391258A06C747FCA3C9AE1217A2693AC15C1F72BB5338E18D9FA
Length: 3491
LastWriteTime: 05/17/2026 18:24:45
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

### CHECK_REPEATED_FAILED_PROOF_CONTAINMENT_001.ps1

Kind: PowerShell script
Path: CHECK_REPEATED_FAILED_PROOF_CONTAINMENT_001.ps1
SHA256: 5FE0A25A28529A56C9CC34C7D5F95B8C656CE38FAA4D3958EDC7123AA3695D2E
Length: 2482
LastWriteTime: 05/17/2026 19:22:10
Can command: No
Entry trigger: only when current task selects this tool and proof need requires it.
Do not infer: root placement does not mean active command.

---

## Tool / Test Rooms

### CleanMilkChecker/

Job: checker/tooling area and backups.
Tier: TOOLS / TESTS / ARCHIVE
Can command: No
Entry trigger: only when checker work or older checker evidence is selected.
Do not infer: checker output or backups are not active truth by themselves.

### CleanSeedLivePullBridgeV1/

Job: local bridge/tooling support.
Tier: TOOLS / TESTS
Can command: No
Entry trigger: only when bridge work is explicitly selected.
Do not infer: bridge existence does not authorize runtime build, bridge hardening, or status-command runtime work.

### INSTALLERS/

Job: installer/support scripts or setup material.
Tier: TOOLS / TESTS
Can command: No
Entry trigger: only when install/setup work is explicitly selected.
Do not infer: installer presence does not authorize install.

### TEST_LANES/

Job: experimental/test scope only.
Tier: TOOLS / TESTS
Can command: No
Entry trigger: only when a specific test lane is selected.
Do not infer: test behavior is not active doctrine unless promoted through proof.

---

## Use Gate

Before using any script/tool:

1. Name the current task.
2. Name why the tool is needed.
3. Name the allowed scope.
4. Confirm the tool does not violate blocked moves.
5. Run only the selected tool.
6. Capture output/proof.
7. Save receipt if the tool changes project state or proves a gate.

## Blocked By Default

- Do not run root scripts because they are visible.
- Do not run bridge tooling unless bridge work is selected.
- Do not run cleanup tools unless cleanup is selected and proven safe.
- Do not run installer tools unless install work is selected.
- Do not treat tool output as final PASS.
- Do not let tool convenience override ACTIVE_ANCHOR.txt, current user command, or proof boundaries.

## Relationship to Room Role Index

The Room Role Index defines tools/tests as support rooms.

This Script / Tool Index is the sharper tool-specific placement map.

Both are support maps only.

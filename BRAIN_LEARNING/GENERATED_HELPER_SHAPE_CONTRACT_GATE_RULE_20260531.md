# Generated Helper Shape Contract Gate Rule

Date: 2026-05-31
Status: BRAIN LEARNING RULE / SUPPORT STANDARD / NOT DOCTRINE
WorkKey: GENERATED-HELPER-SHAPE-CONTRACT-GATE-20260531

## Verdict

Lock/save as a support rule.

Repeated generated-helper failures are one lower-layer scar family, not isolated line bugs:

`GENERATED POWERSHELL HELPER SHAPE CONTRACT FAILURE`

## Scar stack held

1. Target script missing from Downloads before Code Gate ran.
2. Empty collection rejected by PowerShell binding.
3. Inline `if` used as a generated value shape and failed at runtime.
4. Output folder/file stems carried an older tool identity.
5. Mixed `Sort-Object ... -Descending, ...` grammar failed parser.
6. Empty proof/content string rejected by PowerShell binding.

## Rule

Before trusting a generated helper, classify parameter roles and prove the shape contract.

Parameter roles:

- CONTROL PATH: paths, roots, explicit target files. Usually reject blank; verify existence when used as input.
- CONTENT / EVIDENCE: proof text, snippets, body text, lines, markdown, report content. May legitimately be empty; normalize empty safely.
- ROW COLLECTION: rows, tokens, files, items. May legitimately be empty; provide zero-row behavior.
- MODE / SWITCH: opt-in flags such as SkipDownloads. Must have explicit semantics.
- WRITE AUTHORITY: AllowGitWrites, save branches, Git operations. Never implied by file name, Downloads path, prior pass, or registry row.
- SORT / QUERY SHAPE: sorting and filters. Must use legal PowerShell grammar.
- IDENTITY / CUSTODY: script stem, ToolName, output stem, receipt stem. Must match.

## Required guards

Generated helper checks should include:

1. Target file exists at the command path.
2. Script stem and internal ToolName match.
3. Output stem derives from ToolName.
4. No mixed `Sort-Object` descending/comma shape.
5. No fragile inline `if` as object-field or command-argument value.
6. Content/evidence strings allow empty string or normalize before binding.
7. Collections that may receive zero rows allow empty collections or normalize before binding.
8. No `ValidateNotNullOrEmpty` on content/evidence fields unless deliberately justified.
9. Read/report tools contain no Git/write/move/delete execution commands.
10. Save-capable tools are blocked unless active object, Code Gate, Save Room, staged-set, and final clean receipt exist.
11. Zero-row paths produce header-only CSV or blocked receipt, not a crash.
12. Every helper states what it does not prove.

## Project-first boundary

Project first does not mean lower-layer issues are ignored.

When a lower-layer helper/tool failure appears:
- preserve the symptom;
- name the family;
- identify the mechanism;
- repair the mechanism, not only the line;
- add a guard/self-test/proof row;
- route the lesson to save/park after the active object is safe.

Do not let PowerShell become the whole project object.

## External source anchors

- PowerShell `AllowEmptyString()` and `AllowEmptyCollection()` support empty string / empty collection binding for mandatory parameters:
  https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-7.6

- PowerShell `Sort-Object` mixed ordering should use calculated-property/hash-table syntax:
  https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/sort-object?view=powershell-7.6

- PowerShell parser can parse a file into AST, tokens, and parse errors:
  https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser.parsefile?view=powershellsdk-7.6.0

- Pester supports data-driven tests and TestDrive for later mature test harnessing:
  https://pester.dev/docs/usage/data-driven-tests
  https://pester.dev/docs/usage/testdrive

## Boundary

This rule does not authorize doctrine promotion, ACTIVE_GUIDES rewrite, CURRENT_TRUTH_INDEX rewrite, watcher, automation, broad refactor, move, delete, or gate implementation by itself.
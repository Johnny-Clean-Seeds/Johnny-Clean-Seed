# Command Grammar V0.1 Lexicon / Alias / Input Flow Design

Saved: 20260603_132134

## Source

DesignReport: C:\Users\13527\Desktop\123\_MISC_DRAWER\READ_REPORTS\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_1_DESIGN_20260603_132007\PROJECT_COMMAND_CENTER_COMMAND_GRAMMAR_V0_1_LEXICON_ALIAS_INPUT_FLOW_DESIGN_20260603_132007.txt
DesignReportSHA256: 384151C80A640748370A462753EB95E8AAB9A700639580FCF685000F16AF46C4

## Summary

This file preserves the accepted V0.1 design target for the Project Command Center command grammar.

## V0.1 build components

1. Lexicon.
2. Alias and typo map.
3. Command-family trees.
4. Active task pointer shape.
5. Confirmation card shape.
6. Terminal input-flow protections.
7. Output-is-not-input protections.
8. Save-gate file-gathering intention.
9. Stop conditions.

## Lexicon seed

inspect = read-only view
status = active pointer and proof state
save = save-gate family
lock = preserve/save candidate
guard = guard review family
verify = independent verification family
run = execution request requiring policy and confirmation
pause = stop current route and wait
stop = hard halt
next = resolve next legal action

## Alias seed

inspect last task -> inspect active task pointer
inspect last job -> inspect active job pointer
lock save -> save gate
lock and save -> save gate
save it -> save-gate candidate
do not lose it -> save stack or save gate
guard review -> guard review active script
run verifier -> run verifier after guard review
verify output -> verify active output

## PowerShell family seed

pwsh -> PowerShell launcher
-ExecutionPolicy -> execution policy parameter
Bypass -> execution-policy value
-File -> script file mode
quoted path -> required script target
exicutionPolicy -> typo variant of ExecutionPolicy

## Boundary

Design only.
No implementation.
No UI.
No Micro 004.
No tool execution.
No Git mutation authorized by this design.

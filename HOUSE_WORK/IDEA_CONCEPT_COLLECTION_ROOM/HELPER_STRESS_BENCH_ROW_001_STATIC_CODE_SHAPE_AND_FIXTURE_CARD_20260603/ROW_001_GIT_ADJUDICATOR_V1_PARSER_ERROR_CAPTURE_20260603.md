# Row 001 Git Adjudicator Error Capture

Date: 20260603
RunId: 20260603_222525

## Failure Class 1

POWERSHELL_DOUBLE_QUOTED_VARIABLE_COLON_PARSE_ERROR

## Exact Error 1

ParserError: _LOCAL_RUNNERS\ROW_001_STATIC_PACKET\WRITE_ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_V1.ps1:116
Line |
 116 |  …   $failures.Add("Unknown direct git invocation at line $line: $text") …
     |                                                           ~~~~~~
     | Variable reference is not valid. ':' was not followed by a valid variable name character. Consider using ${} to delimit the name.

## Lower-Layer Cause 1

PowerShell parsed `$line:` inside a double-quoted string as an invalid scoped variable reference.

## Failure Class 2

POWERSHELL_EXPANDING_HERE_STRING_CAPTURE_EVALUATED_EXAMPLE_VARIABLES

## Exact Error 2

InvalidOperation: _LOCAL_RUNNERS\ROW_001_STATIC_PACKET\WRITE_ROW_001_GIT_READ_ONLY_SURFACE_ADJUDICATION_V1_2.ps1:103
Line |
 103 |  `"..." -f $line, $text`
     |            ~~~~~
     | The variable '$line' cannot be retrieved because it has not been set.

## Lower-Layer Cause 2

The V1.2 repair tried to capture the example text using an expanding double-quoted here-string. That caused PowerShell to evaluate `$line` and `$text` while writing the report, before those variables existed.

## Repair In This V1.3 Runner

The capture text is now built from a single-quoted non-expanding template, then only safe placeholders are replaced.

This preserves literal examples such as `$line`, `$text`, and `${line}:` without executing or expanding them.

## Boundary

Target helper executed: false
Git add/commit/push: false
Root cleanup: false
Pointer/state mutation: false
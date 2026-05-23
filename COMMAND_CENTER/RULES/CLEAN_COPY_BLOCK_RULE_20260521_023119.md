# Clean Copy Block Rule

## Rule

When the user needs something copied, only the exact copy target goes inside a code/copy block.

## Do Not Put In Copy Blocks

- regular explanation
- commentary
- labels that are not part of the copy target
- expected output
- markdown fences
- instructions like "paste this back"
- terminal output unless the user specifically needs to copy that output

## PowerShell Boundary

For PowerShell work, the user should paste only the clean code block.

No transcript text.
No prompt text.
No PASS/FAIL explanation.
No expected output.

## Front-Door / Hash Test Boundary

For front-door GPT or hash tests, the copy block should contain only the exact hash or exact prompt text needed.

## Purpose

Protect the UI copy button from muddying the paste target.

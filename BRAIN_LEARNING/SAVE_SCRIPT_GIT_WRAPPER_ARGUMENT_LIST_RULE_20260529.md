# Save Script Git Wrapper Argument List Rule

## Status
Support rule / helper failure-family rule.

## Trigger
A save script, repair script, or helper wrapper calls `git` with no subcommand or with a missing argument list.

## Live failure that exposed this
`LOCK_SAVE_FRESHEN_UP_INTERNAL_ORIENTATION_AND_FILE_RULE_V1.ps1` failed with:

```text
GIT_FAILED: git  usage: git ...
```

The wrapper had a parameter named `$Args` and then called `git` through that argument list. The live output proved the function reached bare `git` instead of `git add`, `git commit`, `git push`, or another intended subcommand.

## Rule
Do not use `$Args`, `$HOME`, `$Host`, `$PID`, `$Error`, or other automatic/reserved-looking variable names for helper control parameters.

Git wrapper functions must use an explicit named argument list, such as `$GitArgs`, and must block empty argument lists before running `git`.

## Required wrapper behavior
A clean Git wrapper must:

- require `[string[]]$GitArgs`;
- throw before execution if `$GitArgs` is null or empty;
- print the intended command in errors using `$GitArgs -join ' '`;
- never call bare `git` as a side effect of a wrapper binding mistake;
- stage exact planned paths only;
- force-add ignored files only when those exact paths were planned and justified;
- verify staged set before commit;
- verify HEAD equals origin/main and final status is clean before claiming saved.

## False blame blocked
Do not blame Git, Code Gate, the user, or the rule content first.

If parser/probe passed but write mode reached bare `git`, the first suspect is the helper's wrapper/control-variable design.
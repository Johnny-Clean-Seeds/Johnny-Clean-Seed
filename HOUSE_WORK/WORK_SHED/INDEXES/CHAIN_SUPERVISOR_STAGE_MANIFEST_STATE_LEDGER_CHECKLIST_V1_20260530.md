# Chain Supervisor Stage Manifest State Ledger Checklist V1

- [ ] Is there more than one dependent stage?
- [ ] Does each stage have a stable StageId?
- [ ] Are dependencies declared before run?
- [ ] Are expected input files declared?
- [ ] Are expected output files declared?
- [ ] Is the expected verdict declared?
- [ ] Is the pass condition machine-checkable?
- [ ] Is SkipIfAlreadyComplete defined by output presence plus hash/verdict checks?
- [ ] Is RetryLimit set to 37 at transition checkpoints?
- [ ] Does failure produce a stage-specific report?
- [ ] Does the state ledger record current stage, attempts, outputs, hashes, verdict, and resume point?
- [ ] Does the supervisor stop at a named terminal state?
- [ ] Are one-stage continuation helpers blocked unless the supervisor itself is being debugged?
- [ ] Are unsafe UI keypress mechanisms rejected?
- [ ] Are blocked lanes still blocked?

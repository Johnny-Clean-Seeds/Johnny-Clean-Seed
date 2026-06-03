# Helper Final Sentinel / Interrupt Poison Suit Card

## Active smell

User sees a run where Ctrl+C or a hanging line makes PASS feel untrustworthy.

## Correct response

Do not explain it away as terminal weirdness. Treat it as a helper proof-contract issue until proven otherwise.

## Use rule

```text
No final sentinel, no PASS.
Ctrl+C before sentinel poisons the run.
PASS before sentinel is a helper bug.
Exit 0 alone is not proof.
```

## Required next move

For any new helper in this family, use or wrap with:

```text
HELPER_FINAL_SENTINEL <SCRIPT_NAME> COMPLETE
PASS  <FINAL_VERDICT>
```

## Do not do

Do not trust scrollback PASS.
Do not trust exit code 0 alone.
Do not let finally print stale PASS.
Do not let parent Code Gate pass a child without sentinel proof.
Do not overwrite the old Code Gate runner until the self-test bench proves the strict wrapper.

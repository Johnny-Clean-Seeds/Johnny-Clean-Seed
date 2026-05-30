# Chain Supervisor Stage Manifest State Ledger Suit Card V1

Wear when: a helper chain has more than one dependent stage, one report feeds the next, chat/download timing becomes part of execution, a helper stops at READY_FOR_NEXT_STAGE, or the user asks for automatic continuation.

First move: stop making one-stage continuation helpers unless diagnosing the supervisor itself.

Core command: one supervisor owns the chain.

Required checks before run: manifest valid, dependencies valid, expected outputs named, pass conditions named, state ledger path named, retry limit named, boundary named.

Required checks during run: each stage writes durable output, expected verdict appears, output hashes recorded, state ledger updated, event history appended.

Required checks after run: final state is terminal, blocked with return point, or failed with stage-specific report. Do not leave the user at a silent prompt with no next condition.

Retry rule: retry transition checkpoints up to 37 times. A retry means re-check or rerun the stage transition under controlled conditions, then verify the expected output. It does not mean pressing Enter blindly.

Boundary: local-only read/report unless separately authorized. No delete, move, Git write, watcher, automation, doctrine, ACTIVE_GUIDES, CURRENT_TRUTH_INDEX, or Whirlpool.

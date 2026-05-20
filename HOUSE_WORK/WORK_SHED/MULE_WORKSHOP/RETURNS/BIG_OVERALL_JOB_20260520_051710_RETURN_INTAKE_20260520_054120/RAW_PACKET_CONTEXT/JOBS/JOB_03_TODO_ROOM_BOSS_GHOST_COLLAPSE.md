# JOB 03 - TODO Room Boss/Ghost Collapse

Mission: Inspect current TODO room and collapse ghosts under parent bosses.

Read:
- STATE_SNAPSHOT\TODO_ORDER.txt
- STATE_SNAPSHOT\BOSS_GHOST_MAP.txt
- repo TODO files as needed, read-only

Output a matrix:
- TODO file;
- parent boss;
- state: blocker / watch / support / parked / duplicate / stale / needs proof;
- keep, merge, park, close-candidate, or read-next;
- reason;
- proof required before any change.

Output:
MULE_OUTPUT_DUMP_ONLY\JOB_03_TODO_ROOM_BOSS_GHOST_COLLAPSE.md

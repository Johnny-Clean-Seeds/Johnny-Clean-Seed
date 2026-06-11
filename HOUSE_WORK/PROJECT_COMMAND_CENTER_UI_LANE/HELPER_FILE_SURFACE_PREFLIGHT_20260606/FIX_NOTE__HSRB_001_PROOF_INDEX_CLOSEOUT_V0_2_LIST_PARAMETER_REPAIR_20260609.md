# FIX NOTE - HSRB-001 PROOF INDEX CLOSEOUT V0.2

Repair: Replace the V0.1 Add-Line typed-list parameter path with plain PowerShell string arrays.
Reason: PowerShell parameter binding rejected an empty generic list as an empty collection before the first line could be added.
Scope: same proof-index closeout object only.
Boundary: no execution, no route, no cleanup, no delete, no rename, no commit, no push.

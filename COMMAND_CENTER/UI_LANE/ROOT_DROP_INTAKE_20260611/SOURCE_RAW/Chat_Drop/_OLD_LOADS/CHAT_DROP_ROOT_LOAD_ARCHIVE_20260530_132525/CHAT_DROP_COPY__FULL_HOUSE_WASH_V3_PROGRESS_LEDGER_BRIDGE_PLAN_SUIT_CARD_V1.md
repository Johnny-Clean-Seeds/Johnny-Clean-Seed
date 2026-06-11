# Full House Wash V3 Progress + Ledger Bridge Plan Suit Card

Wear when returning from the full house wash branch.

Current clean position:
- main @ 8aff6c523bd690faa649a6ce4b16fecd1e7229a0
- V3 full wash is the current full-wash path.
- Latest V3 run: 20260530_105416.
- Overall verdict: REVIEW_REQUIRED.
- No block findings in V3.
- One selected family: SECURITY_CREDENTIAL_SURFACE, 567 review rows, 0 block rows.

Immediate next task:
- Build the living-system ledger/map/key bridge plan.
- Link ledgers to each other and to whole-system rooms using explicit bridges/tunnels.
- Do not start repair before the link system is mapped.

Do:
- Use one current source of truth per object.
- Preserve Chat Drop as current-copy lane, not source authority.
- Separate repo source/proof from chat drop copies.
- Give each bridge a source node, target node, direction, relation type, proof path, and stale-check rule.

Do not:
- Run broad repairs.
- Move/delete files.
- Rewrite ACTIVE_GUIDES or CURRENT_TRUTH_INDEX.
- Treat Chat Drop copies as proof source.
- Use 37 as row sample size.

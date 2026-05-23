# WORD_BROADENING_AND_BITSTRING_COVERAGE_REPORT

Timestamp: 2026-05-23 00:20:00 -04:00

## Alias / Synonym Coverage
move, sort, clean, take away, put there, route, file away, close out, return home, archive, custody, consume, process, drop, bring inside, make current, verify current.

## Opposite Coverage
move vs verify-only; source vs current; READY vs CURRENT; local vs public; chat-loaded vs local-current; helper vs active file; proof vs claim; done vs PASS; copy vs move; archive vs delete; prepare vs promote.

## Matrices
Actors: user, assistant, mule, script, public URL, chat, local tool, scraper, future assistant.

Objects: file, folder, package, zip, tool, script, receipt, map, ledger, rule, source, proof, public page, private prompt, hash, index, old scaffold, support mirror.

Lanes: root/front door, READY, CURRENT, custody, tools, failed tools, receipts, issue review, public URL, local repo, mail room, downloads.

States: dropped, inspected, classified, ready, waiting user, user-moved, current-verified, consumed, archived, custody, failed, blocked, deprecated, source-only, public-safe, private, unknown, closed.

## Core Rule Coverage Bits
| Rule | Bits | Result |
|---|---|---|
| CURRENT user-only | ACTOR ACTION OBJECT LANE STATE OPPOSITE BYPASS PROOF RETURN PRIVACY AUTHORITY PASS | Ready |
| Chat-loaded is not local truth | ACTOR ACTION OBJECT LANE STATE OPPOSITE BYPASS PROOF RETURN PRIVACY AUTHORITY PASS | Ready |
| Every object returns home | ACTOR ACTION OBJECT LANE STATE OPPOSITE BYPASS PROOF RETURN PRIVACY AUTHORITY PASS | Ready |
| Public URL is map not private truth | ACTOR ACTION OBJECT LANE STATE OPPOSITE BYPASS PROOF RETURN PRIVACY AUTHORITY PASS | Ready |
| No PASS before edge closure | ACTOR ACTION OBJECT LANE STATE OPPOSITE BYPASS PROOF RETURN PRIVACY AUTHORITY PASS | Ready |

## Dense Rule
Any instruction that sounds like move/sort/clean/route/archive/verify must be expanded across actor, object, lane, state, opposite case, proof, privacy, authority, and return-home. Then compress to the smallest route contract that blocks synonym bypasses. CURRENT promotion remains user-only in every wording variant.

$ErrorActionPreference = 'Stop'

$script:OutputRoot = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$date = '2026-05-24'
$status = 'SUPPORT GATE RING / EXPANDED ORDERED CANDIDATE / NO-RUN / NOT ACTIVE DOCTRINE'
$gatePrefix = 'CS-EGR'

function New-Step($name, $trigger, $pass, $fail, $evidence, $next) {
    [ordered]@{
        Name     = $name
        Trigger  = $trigger
        Pass     = $pass
        Fail     = $fail
        Evidence = $evidence
        Next     = $next
    }
}

function New-Ring($code, $title, $phase, $lens, $focus, $source, $clean, $steps, $locked) {
    [ordered]@{
        Code   = $code
        Title  = $title
        Phase  = $phase
        Lens   = $lens
        Focus  = $focus
        Source = $source
        Clean  = $clean
        Steps  = $steps
        Locked = $locked
    }
}

function Escape-Cell($value) {
    return (($value -replace '\|', '/') -replace "`r?`n", ' ')
}

$baseSteps = @(
    New-Step 'Trigger Naming Gate' 'a signal enters this ring' 'the signal is named before action' 'the ring starts from mood, speed, novelty, or vague pressure' 'user request, source note, command output, path, citation, or prior receipt' 'Authority Boundary Gate'
    New-Step 'Authority Boundary Gate' 'the ring might touch files, rules, people, or status' 'allowed touch, blocked touch, and support-only status are named' 'source ore, chat, or research becomes authority by proximity' 'ACTIVE_ANCHOR, AGENTS, status header, user request' 'Live Object Gate'
    New-Step 'Live Object Gate' 'an item must be judged' 'the live object and its type are named' 'the gate acts on an unnamed mass of material' 'file role, object type, lane, ring focus, source disposition' 'Source Custody Gate'
    New-Step 'Source Custody Gate' 'a concept or evidence claim is imported' 'source, custody, and derivation path are visible' 'a useful idea arrives with no trail' 'source ledger, hash, citation URL, transcript receipt, path' 'Word Placement Gate'
    New-Step 'Word Placement Gate' 'wording can steer behavior' 'behavior-controlling words point to exact object, action, proof, verdict, or next state' 'clean-sounding labels open the wrong door' 'gate title, status word, route word, pass/fail wording' 'Attention Salience Gate'
    New-Step 'Attention Salience Gate' 'too many signals compete' 'active focus and intentionally dimmed side routes are visible' 'everything is equally loud and the route drifts' 'active target, blocked side route, load note, scope line' 'Frame And Exit Gate'
    New-Step 'Frame And Exit Gate' 'the system could leave by narration instead of proof' 'available exits are named and proof exits are separated from explanation exits' 'a fluent answer counts as closure' 'exit list, blocked exit, proof closure rule' 'Relation Edge Gate'
    New-Step 'Relation Edge Gate' 'two items appear connected' 'edge type is named: source, proof, parent, child, neighbor, blocker, promotion, return, or watch' 'similarity is mistaken for a real relationship' 'relation table, graph note, source map, issue map' 'Risk And Dirty Import Gate'
    New-Step 'Risk And Dirty Import Gate' 'the gate could carry bad material forward' 'dirty conditions, coercive import, mystique import, and quarantine path are visible' 'dirty milk is carried because it looks useful' 'risk note, dirty import block, local-only flag, blocked-use line' 'Substrate Tool Gate'
    New-Step 'Substrate Tool Gate' 'a method or tool is chosen' 'tool matches phenomenon: shell for file truth, ledger for source truth, map for relation truth, test for behavior truth' 'a bigger tool substitutes for the right substrate' 'command output, source ledger, map, test result, receipt' 'Proof Burden Gate'
    New-Step 'Proof Burden Gate' 'a claim needs trust' 'claim touches visible evidence before PASS' 'confidence, tone, fluency, or source prestige becomes proof' 'hash, path, line, test, citation, root listing, status output' 'Variation Stability Gate'
    New-Step 'Variation Stability Gate' 'a gate seems useful' 'small wording, order, and context changes do not break the route' 'the gate only works in the exact phrase that inspired it' 'counterexample, perturbation check, repeated source signal, disproof condition' 'Recursion Return Gate'
    New-Step 'Recursion Return Gate' 'output can loop back into the system' 'return target, next spin, and stop condition are named' 'output grows into loose active weight' 'next state, receipt footer, return trigger, watch lane' 'Birth Candidate Gate'
    New-Step 'Birth Candidate Gate' 'the ring exposes a missing gate' 'candidate birth is parked soft with reason, source basis, and non-promotion status' 'a new gate is silently installed' 'birth note, candidate ID, soft-room path, no-run flag' 'Neighbor Fit Gate'
    New-Step 'Neighbor Fit Gate' 'a gate touches nearby gates' 'neighbor effects and possible damage are checked' 'a clean-looking gate breaks adjacent lanes' 'affected scope, neighbor list, no-blind-move check' 'Verdict Status Gate'
    New-Step 'Verdict Status Gate' 'a judgment is needed' 'PASS, PASS WITH GUARDRAILS, PARTIAL, FAIL, INVALID, YIELD, BLOCKED, PARKED, WATCH, PROMOTED, or RETIRED matches evidence' 'status words exaggerate the proof' 'verdict line, proof burden, guardrail, open risk' 'Receipt And Next State Gate'
    New-Step 'Receipt And Next State Gate' 'the ring needs to close' 'receipt, next state, and clean stop or return trigger are visible' 'the ring leaves no trace or leaves unresolved active pressure' 'receipt path, hash manifest, repo status, next action' 'next ring or clean stop'
)

$orderSteps = @(
    New-Step 'ORDER Gate' 'any gate is created, placed, reviewed, or prepared for use' 'sequence is declared before content moves: target, authority, object, source, words, attention, relation, risk, substrate, proof, variation, recursion, birth, neighbor fit, verdict, receipt, return' 'count, excitement, source prestige, or late-stage consolidation chooses placement' 'ring order table, order proof, source ledger, no-run lock, receipt' 'Order Before Count Gate'
    New-Step 'Order Before Count Gate' 'the ring grows large' 'order quality outranks gate count while count remains mechanically verified' 'a large pile pretends to be a system' 'CSV row count, ring count, sequence proof' 'Front Keystone Gate'
    New-Step 'Front Keystone Gate' 'important gates could be buried' 'ORDER, reduction lock, recursion, and gate birth interface are placed at the front' 'the front door lacks the controls needed for recursive work' 'R001 through R004 ring list' 'No-Run Declaration Gate'
    New-Step 'No-Run Declaration Gate' 'a candidate ring is generated' 'all gates are marked candidate and no-run until a separate user-approved run' 'creating a gate silently runs it' 'Status field, receipt, no-run lock file' 'Reduction Lock Gate'
    New-Step 'Reduction Lock Gate' 'a reducer, compressor, or consolidator could fire' 'reduction behavior is locked off and parked until explicit run approval' 'consolidator eats fresh gates before review' 'locked status, R200 placement, no reduction output' 'Source Before Extraction Gate'
    New-Step 'Source Before Extraction Gate' 'research is used' 'source custody and source type are named before extraction' 'ideas are pulled with no custody or status' 'research ledger, transcript receipt, citation URL' 'Object Before Words Gate'
    New-Step 'Object Before Words Gate' 'phrasing seems powerful' 'the object being affected is named before wording is tuned' 'word magic replaces object work' 'object field, gate focus, file path or concept label' 'Words Before Exits Gate'
    New-Step 'Words Before Exits Gate' 'wording creates motion' 'the exits created by wording are named and proof-bound' 'words create an easy false exit' 'exit field, pass/fail condition, proof burden' 'Attention Before Suggestion Gate'
    New-Step 'Attention Before Suggestion Gate' 'suggestion-state logic is translated for systems' 'attention state is described mechanically and verification stays active' 'hypnosis language becomes mystique or manipulation' 'hypnosis ledger, no-human-manipulation block' 'Proof Before Consolidation Gate'
    New-Step 'Proof Before Consolidation Gate' 'overlap appears' 'evidence repeats before merge, pack, reject, or retire is allowed' 'one similarity triggers consolidation' 'repeat signal, source ledger, proof note' 'Recursion Before Expansion Gate'
    New-Step 'Recursion Before Expansion Gate' 'more gates are born' 'each new gate has return target, stop condition, and neighbor check' 'growth has no return path' 'candidate birth schema, return field' 'Soft Birth Gate'
    New-Step 'Soft Birth Gate' 'the system needs a gate generator' 'gate birth room produces parked candidates only' 'birth room becomes a hidden active rule factory' 'GATE_BIRTH_ROOM_SOFT_20260524.md' 'Enoughness Gate'
    New-Step 'Enoughness Gate' 'the user asks whether more gates are needed' 'the ring asks evidence of missing failure modes instead of guessing best' 'the assistant decides from taste alone' 'coverage matrix, source stack, missing-failure check' 'Neighbor Damage Gate'
    New-Step 'Neighbor Damage Gate' 'a gate is placed near existing gates' 'affected neighbors are listed before placement is considered clean' 'new gates break old lanes silently' 'affected scope and neighbor list' 'End Consolidator Reservation Gate'
    New-Step 'End Consolidator Reservation Gate' 'consolidator is required' 'CONSOLIDATOR is reserved for the final ring and locked no-run' 'consolidator appears early or acts as king gate' 'R200, locked status, no-run receipt' 'Receipt Continuity Gate'
    New-Step 'Receipt Continuity Gate' 'the expanded ring closes' 'old baseline hash, new artifact hashes, count proof, and status are visible' 'the big move has no rollback trail' 'pre-expansion manifest, post-expansion hash manifest' 'Return To Target Gate'
    New-Step 'Return To Target Gate' 'ORDER ring completes' 'the next ring starts at reduction lock and no-run control' 'ORDER becomes an endless planning loop' 'next pointer, R002 route' 'R002 Reduction Lock And No-Run Control'
)

$noRunSteps = @(
    New-Step 'No-Run Master Lock Gate' 'any generated gate could be mistaken for an active run' 'candidate status is visible in every row and receipt' 'generation is confused with execution' 'Status column, receipt, order proof' 'Reducer Isolation Gate'
    New-Step 'Reducer Isolation Gate' 'a gate can reduce, compress, consolidate, delete, retire, or promote' 'reduction-capable gates are isolated behind explicit approval' 'a reducer runs because it exists' 'locked status, R200 end placement, no-run wording' 'Consolidator Sleep Gate'
    New-Step 'Consolidator Sleep Gate' 'CONSOLIDATOR is present' 'CONSOLIDATOR stays asleep and can only be inspected as candidate text' 'CONSOLIDATOR packs gates during birth' 'R200 status, receipt no-run line' 'Compression Sleep Gate'
    New-Step 'Compression Sleep Gate' 'compression language appears' 'compression is treated as future action, not current action' 'fresh gates are condensed before review' 'lock note, no output reduction' 'Promotion Sleep Gate'
    New-Step 'Promotion Sleep Gate' 'a gate looks strong' 'promotion requires separate proof and user approval' 'candidate support becomes active doctrine' 'ACTIVE_ANCHOR, status header, git diff' 'Deletion Sleep Gate'
    New-Step 'Deletion Sleep Gate' 'duplicate or weak gates appear' 'nothing is deleted by this pass' 'weakness causes silent deletion' 'receipt, git status, no delete note' 'Move Sleep Gate'
    New-Step 'Move Sleep Gate' 'a gate seems misplaced' 'misplacement is reported, not moved into active guides' 'support artifact rewrites active lanes' 'path list, no active-guide edit' 'Run Intent Gate'
    New-Step 'Run Intent Gate' 'a command or script is executed' 'script generation and verification are separated from gate execution' 'verification is mistaken for running gates' 'command purpose, receipt wording' 'Inspection Only Gate'
    New-Step 'Inspection Only Gate' 'rows are opened, counted, or hashed' 'inspection is allowed and produces proof only' 'inspection mutates gate verdicts' 'row count, hash output, grep checks' 'No Verdict Eating Gate'
    New-Step 'No Verdict Eating Gate' 'a later gate could override earlier status' 'no gate changes another gate status during this build' 'the ring self-judges and self-edits' 'static CSV, generator script, no run ledger' 'Manual Run Requirement Gate'
    New-Step 'Manual Run Requirement Gate' 'someone wants to apply the ring to a target later' 'target, runner, reducer locks, and approval must be named first' 'future run starts from this build receipt alone' 'future run checklist' 'Rollback Anchor Gate'
    New-Step 'Rollback Anchor Gate' 'the move is large' 'baseline hash manifest remains unchanged and referenced' 'rollback anchor is lost' 'PRE_EXPANSION_HASH_MANIFEST, baseline folder' 'Fresh Gate Quarantine Gate'
    New-Step 'Fresh Gate Quarantine Gate' 'new gates are born' 'fresh gates stay candidate until proof pass' 'birth equals adoption' 'candidate status, gate birth room' 'No Hidden Active State Gate'
    New-Step 'No Hidden Active State Gate' 'the artifact is useful' 'no hidden daemon, automation, hook, or active rewrite is created' 'candidate files create hidden behavior' 'file list, git status, script contents' 'User Talk Stop Gate'
    New-Step 'User Talk Stop Gate' 'a serious decision is needed' 'work stops for discussion before active use, reduction, or promotion' 'assistant decides the serious move alone' 'receipt next action, final note' 'Hash After Build Gate'
    New-Step 'Hash After Build Gate' 'new files are generated' 'new hashes are computed after all generated artifacts exist' 'large move closes without integrity proof' 'post-expansion hash manifest' 'No-Run Receipt Gate'
    New-Step 'No-Run Receipt Gate' 'no-run ring closes' 'receipt says no gates were run and reducers stayed locked' 'the no-run boundary is implicit' 'receipt line, status column' 'R003 Recursion Spine And Return Control'
)

$recursionSteps = @(
    New-Step 'Recursive Object Continuity Gate' 'output loops back into the system' 'same object or explicitly transformed object is named before recursion' 'recursion changes object without notice' 'object field, transform note' 'Recursive Authority Continuity Gate'
    New-Step 'Recursive Authority Continuity Gate' 'a later spin inherits earlier material' 'authority does not grow just because recursion repeats' 'repetition becomes authority' 'status header, support-only line' 'Recursive Source Continuity Gate'
    New-Step 'Recursive Source Continuity Gate' 'a later spin uses earlier source' 'source trail remains attached' 'source disappears after first extraction' 'source ledger, provenance path' 'Recursive Attention Reset Gate'
    New-Step 'Recursive Attention Reset Gate' 'the next spin starts' 'active focus is reset and side routes are re-declared' 'old salience drifts into new spin' 'next target, blocked side routes' 'Recursive Exit Recheck Gate'
    New-Step 'Recursive Exit Recheck Gate' 'old exits are reused' 'exits are checked again for proof closure' 'old false exit remains open' 'exit list, proof closure line' 'Recursive Proof Refresh Gate'
    New-Step 'Recursive Proof Refresh Gate' 'a prior proof is reused' 'proof is either still valid or marked stale' 'stale proof is treated as fresh' 'hash, status output, citation date, transcript path' 'Recursive Variation Gate'
    New-Step 'Recursive Variation Gate' 'the gate repeats under a new condition' 'variation is recorded and does not break invariant' 'the loop only works once' 'variation note, invariant line' 'Recursive Drift Detector Gate'
    New-Step 'Recursive Drift Detector Gate' 'iteration changes wording or placement' 'drift is named before it accumulates' 'tiny drift compounds silently' 'diff, wording check, neighbor list' 'Recursive Birth Gate'
    New-Step 'Recursive Birth Gate' 'recursion exposes a missing gate' 'new gate enters soft birth room with parent and reason' 'missing gate becomes active instantly' 'birth room record, parent gate ID' 'Recursive Saturation Gate'
    New-Step 'Recursive Saturation Gate' 'more gates might still be possible' 'more-gate search asks for missing failure modes and missing source signals' 'growth continues from anxiety alone' 'coverage check, missing-failure log' 'Recursive Stop Gate'
    New-Step 'Recursive Stop Gate' 'a serious decision is reached' 'the system stops and asks before active use, promotion, or reduction' 'the loop outruns decision need' 'decision note, blocked next action' 'Recursive Neighbor Gate'
    New-Step 'Recursive Neighbor Gate' 'new loop touches old gate' 'neighbor fit is checked before claiming clean placement' 'recursive output damages ring ecology' 'neighbor list, affected scope' 'Recursive Condense Lock Gate'
    New-Step 'Recursive Condense Lock Gate' 'recursion creates overlap' 'overlap is parked until final locked consolidator review' 'condense fires during generation' 'R200 lock, no-run status' 'Recursive Receipt Gate'
    New-Step 'Recursive Receipt Gate' 'the recursive pass closes' 'receipt captures what was born, parked, blocked, and left for talk' 'loop closes with no trail' 'receipt, hash manifest, next action' 'Recursive Return Gate'
    New-Step 'Recursive Return Gate' 'the ring closes' 'next target is R004 soft gate birth interface' 'recursion loops into itself without an exit' 'next pointer' 'R004 Soft Gate Birth Room Interface'
    New-Step 'Recursive Evidence Gate' 'recursive confidence rises' 'more loops still need visible evidence' 'repeat count substitutes for proof' 'proof ledger, source trail' 'Recursive Human Boundary Gate'
    New-Step 'Recursive Human Boundary Gate' 'human-behavior concepts appear' 'concepts translate to systems only and avoid manipulation instructions' 'recursive logic becomes human influence script' 'dirty import block, systems-only line' 'R004 Soft Gate Birth Room Interface'
)

$birthSteps = @(
    New-Step 'Soft Gate Birth Door Gate' 'a missing gate is noticed' 'birth room accepts only soft candidate requests' 'birth room installs gates directly' 'soft-room status, candidate schema' 'Spark Capture Gate'
    New-Step 'Spark Capture Gate' 'a source, failure, or pattern sparks a new gate' 'spark is captured with source and reason' 'new gate starts as a name only' 'spark field, source field' 'Need Claim Gate'
    New-Step 'Need Claim Gate' 'a gate is proposed' 'the failure mode it prevents is named' 'gate exists because it sounds good' 'need claim, failure mode' 'Object Target Gate'
    New-Step 'Object Target Gate' 'candidate gate needs a target' 'target object class is named' 'gate has no target and cannot fire cleanly' 'target object field' 'Trigger Draft Gate'
    New-Step 'Trigger Draft Gate' 'candidate gate needs a trigger' 'trigger is observable and bounded' 'trigger is vague mood language' 'trigger field' 'Pass Draft Gate'
    New-Step 'Pass Draft Gate' 'candidate gate needs a pass condition' 'pass condition is testable or evidence-bound' 'pass condition is a feeling of correctness' 'pass field' 'Fail Draft Gate'
    New-Step 'Fail Draft Gate' 'candidate gate needs a fail condition' 'fail condition names the actual bad route' 'fail condition is only generic badness' 'fail field' 'Evidence Draft Gate'
    New-Step 'Evidence Draft Gate' 'candidate gate needs proof' 'evidence type is named before promotion' 'gate cannot prove itself' 'evidence field' 'Dirty Import Draft Gate'
    New-Step 'Dirty Import Draft Gate' 'candidate gate imports external concepts' 'dirty, coercive, mystical, or unsupported uses are blocked' 'source concept arrives unfiltered' 'blocked-use field' 'Neighbor Slot Gate'
    New-Step 'Neighbor Slot Gate' 'candidate needs placement' 'likely neighbors and order slot are named' 'gate is thrown into the ring by excitement' 'neighbor field, order slot' 'Recursion Fit Gate'
    New-Step 'Recursion Fit Gate' 'candidate may recur' 'return target and stop condition are named' 'gate creates infinite active pressure' 'return field, stop field' 'Reduction Lock Draft Gate'
    New-Step 'Reduction Lock Draft Gate' 'candidate can reduce or consolidate' 'reduction behavior is locked unless explicitly approved' 'candidate consumes other gates' 'reduction lock field' 'Candidate ID Gate'
    New-Step 'Candidate ID Gate' 'candidate is recorded' 'candidate receives stable soft ID and status' 'candidate cannot be tracked' 'candidate ID, created date' 'Parking Gate'
    New-Step 'Parking Gate' 'candidate is not ready' 'candidate is parked with return trigger' 'candidate becomes active weight' 'parking path, return trigger' 'Review Queue Gate'
    New-Step 'Review Queue Gate' 'candidate may be reviewed later' 'review criteria and reviewer target are visible' 'review is implied but not scheduled' 'review checklist' 'Birth Room Receipt Gate'
    New-Step 'Birth Room Receipt Gate' 'birth cycle closes' 'receipt records candidates born, rejected, parked, or deferred' 'birth room produces no trace' 'birth receipt, candidate ledger' 'R005 generated rings'
    New-Step 'No-Birth-Run Gate' 'birth room is present in the expanded ring' 'birth room remains a side room and does not run the new gates' 'birth process turns into execution' 'no-run status, receipt' 'R005 generated rings'
)

$enoughSteps = @(
    New-Step 'Enoughness Question Gate' 'the system asks whether more gates are needed' 'answer is routed to coverage and missing-failure evidence' 'assistant chooses from taste or fatigue' 'coverage matrix, source ledger' 'Missing Failure Mode Gate'
    New-Step 'Missing Failure Mode Gate' 'more gates are considered' 'new gates require a named failure mode not already covered' 'new gates duplicate existing lanes' 'failure-mode ledger, overlap check' 'Missing Source Signal Gate'
    New-Step 'Missing Source Signal Gate' 'research might yield more gates' 'new source signal is named or search stops' 'search continues without new signal' 'research ledger, source receipt' 'Coverage Saturation Gate'
    New-Step 'Coverage Saturation Gate' 'coverage looks broad' 'coverage is measured by lanes, phases, and failure modes' 'large count hides missing lane' 'ring phase table, concept matrix' 'Bloat Risk Gate'
    New-Step 'Bloat Risk Gate' 'more gates add weight' 'bloat risk is named but not used to delete during no-run' 'bloat panic triggers reduction' 'risk line, reduction lock' 'Thin Ring Risk Gate'
    New-Step 'Thin Ring Risk Gate' 'the ring may miss cases' 'thinness risk is named by uncovered concepts' 'small ring gets trusted by style' 'uncovered source list' 'Research Stop Gate'
    New-Step 'Research Stop Gate' 'no new useful source signals appear' 'research stops and reports residual uncertainty' 'search never ends' 'search ledger, open risk' 'Gate Birth Referral Gate'
    New-Step 'Gate Birth Referral Gate' 'more gates may be useful later' 'birth room receives future missing-gate prompts softly' 'future possibility becomes current active task' 'soft birth queue' 'Consolidator Delay Gate'
    New-Step 'Consolidator Delay Gate' 'coverage overlap exists' 'overlap waits for final locked consolidator and future run approval' 'overlap is eaten now' 'R200 lock' 'Serious Decision Gate'
    New-Step 'Serious Decision Gate' 'the next move would change active doctrine or run reducers' 'work stops for discussion' 'assistant runs ahead into active use' 'final note, blocked next move' 'Receipt Gate'
    New-Step 'Receipt Gate' 'enoughness gate closes' 'receipt names count, order, lock, and next talk point' 'close has no proof' 'receipt path' 'Coverage Return Gate'
    New-Step 'Coverage Return Gate' 'coverage check closes' 'return target is final guardrail and promotion boundary' 'coverage loops into more growth forever' 'next pointer' 'R196'
    New-Step 'Duplicate Watch Gate' 'new gates look similar' 'duplicates are watched for future consolidator, not deleted now' 'duplicates are collapsed immediately' 'watch list' 'Priority Four Gate'
    New-Step 'Priority Four Gate' 'only a few keystones can be highlighted' 'ORDER, reduction lock, recursion, and soft birth are front keystones; enoughness and consolidator are end keystones' 'all gates are treated equal at the front door' 'keystone list' 'Proof Of Fatness Gate'
    New-Step 'Proof Of Fatness Gate' 'ring size matters' 'total count is mechanically verified above 500 and into thousands' 'scale is claimed without count proof' 'row count check' 'No Best Guess Gate'
    New-Step 'No Best Guess Gate' 'the user says do not decide what is best' 'gates decide later during an approved run; this pass only builds candidates' 'assistant ranks by preference' 'no-run receipt' 'R196'
    New-Step 'Talk Stop Gate' 'enoughness reaches serious decision' 'stop for user talk before run, condense, or promotion' 'system keeps moving after decision point' 'final next action' 'R196'
)

$finalJudgeSteps = @(
    New-Step 'Final Judge Status Gate' 'the expanded ring claims done' 'done means generated, ordered, locked, counted, hashed, and not run' 'done means active or applied' 'receipt, hash manifest, count proof' 'Support Boundary Gate'
    New-Step 'Support Boundary Gate' 'artifact is useful' 'artifact remains support-only and outside ACTIVE_GUIDES' 'support becomes doctrine by proximity' 'path, git diff, status header' 'Source Ledger Gate'
    New-Step 'Source Ledger Gate' 'research claims are included' 'ledger separates local transcripts, official self-source, and scientific sources' 'all sources receive equal authority' 'research ledger' 'Chase Boundary Gate'
    New-Step 'Chase Boundary Gate' 'Chase/NCI concepts appear' 'concepts translate to systems architecture, not human manipulation instructions' 'behavior logic becomes covert influence script' 'blocked-use line, systems-only label' 'Hypnosis Boundary Gate'
    New-Step 'Hypnosis Boundary Gate' 'hypnosis concepts appear' 'mechanisms are treated as attention-state analogies with proof active' 'mystique or therapeutic claim is imported' 'APA/PubMed ledger, no medical advice line' 'Feynman Boundary Gate'
    New-Step 'Feynman Boundary Gate' 'Feynman concepts appear' 'physics ideas translate as system design analogies only' 'metaphor becomes proof' 'Feynman packet, source ledger' 'Transcript Boundary Gate'
    New-Step 'Transcript Boundary Gate' 'transcripts are used' 'transcripts are source ore with custody, not commands' 'transcript language becomes instruction' 'transcript receipt, source disposition' 'No-Run Final Gate'
    New-Step 'No-Run Final Gate' 'final judge sees gate rows' 'final judge confirms no gate cycle was run' 'verification is confused with gate execution' 'verification commands, receipt' 'Hash Final Gate'
    New-Step 'Hash Final Gate' 'files are complete' 'hashes are generated after build' 'integrity is assumed' 'hash manifest' 'Root Clean Gate'
    New-Step 'Root Clean Gate' 'root folder may contain loose files' 'root check is run and any finding is reported' 'loose root file is ignored' 'root listing command' 'ASCII Gate'
    New-Step 'ASCII Gate' 'files are written' 'non-ASCII scan is clean or exceptions are named' 'invisible encoding drift enters support files' 'rg non-ASCII scan' 'Repo Status Gate'
    New-Step 'Repo Status Gate' 'worktree is dirty' 'existing dirty state is reported without reverting user work' 'assistant cleans unrelated user changes' 'git status --short --branch' 'Count Gate'
    New-Step 'Count Gate' 'large ring is claimed' 'exact count and first/last IDs are verified' 'count is approximate' 'CSV import count' 'Order First Gate'
    New-Step 'Order First Gate' 'ring order is verified' 'first gate is ORDER Gate' 'ORDER is present but buried' 'first row check' 'Consolidator Last Gate'
    New-Step 'Consolidator Last Gate' 'consolidator placement is verified' 'final ring is locked CONSOLIDATOR' 'consolidator is early or unlocked' 'last row check, R200' 'Receipt Close Gate'
    New-Step 'Receipt Close Gate' 'final judge closes' 'receipt points to talk before any run or reduction' 'close implies next automatic action' 'receipt next action' 'R199'
    New-Step 'Return Handoff Gate' 'final judge closes to user' 'handoff says build done and no gates run' 'handoff hides no-run boundary' 'final answer' 'R199'
)

$consolidatorEndSteps = @(
    New-Step 'CONSOLIDATOR Locked End Gate' 'all candidate gates have been generated and verified' 'CONSOLIDATOR is present at the end, locked, and not run' 'CONSOLIDATOR runs early or consumes fresh gates' 'R200 placement, locked status, no-run receipt' 'Evidence-First Packing Gate'
    New-Step 'Evidence-First Packing Gate' 'overlap exists among gates' 'future consolidation requires repeated evidence before packing' 'one similarity triggers pack' 'repeat signal ledger, future run approval' 'KEEP SEPARATE Gate'
    New-Step 'KEEP SEPARATE Gate' 'two gates look related but jobs differ' 'future run may keep them separate with reason' 'useful difference is flattened' 'job test, risk if merged' 'MOVE LOGIC Gate'
    New-Step 'MOVE LOGIC Gate' 'a concept belongs under another parent' 'future run may move logic without changing authority' 'logic remains misplaced or authority moves silently' 'parent gate, relation edge, affected scope' 'PACK TOGETHER Gate'
    New-Step 'PACK TOGETHER Gate' 'three repeated signals show shared parent' 'future run may pack with source and seams preserved' 'packing hides source, proof, or blocked edge' 'three-signal count, seam list' 'PARK Gate'
    New-Step 'PARK Gate' 'a gate is useful but not ready' 'future run may park with return trigger' 'future idea becomes active weight' 'parking path, return trigger' 'REJECT Gate'
    New-Step 'REJECT Gate' 'a gate is duplicate fog or dirty bloat' 'future run may reject active use while retaining evidence' 'bad duplicate remains active' 'rejection reason, retained evidence path' 'WATCH AGAIN Gate'
    New-Step 'WATCH AGAIN Gate' 'only one signal exists' 'future run may watch without promotion' 'single signal becomes rule' 'watch note, next spin item' 'Three Signal Gate'
    New-Step 'Three Signal Gate' 'possible consolidation repeats' 'one signal means watch, two means likely pattern, three means candidate pack' 'repeat count is skipped' 'three-loop ledger' 'Risk If Merged Gate'
    New-Step 'Risk If Merged Gate' 'packing could erase structure' 'risk of flattening, authority bleed, or proof loss is named' 'merge risk is invisible' 'risk column, dirty import check' 'Risk If Separate Gate'
    New-Step 'Risk If Separate Gate' 'keeping separate could create clutter' 'risk of duplicate fog or loose gates is named' 'separation risk is ignored' 'self-weight note, bloat check' 'No Rewrite Gate'
    New-Step 'No Rewrite Gate' 'consolidation result looks useful' 'no active guide rewrite happens from this candidate artifact' 'trial/watch becomes doctrine install' 'git diff, status header, receipt' 'No Delete Gate'
    New-Step 'No Delete Gate' 'consolidator sees redundant gates' 'no deletion happens in this build' 'fresh gates are removed before review' 'no-run receipt, static CSV' 'No Promotion Gate'
    New-Step 'No Promotion Gate' 'consolidator sees strong gates' 'promotion requires separate user-approved proof pass' 'candidate becomes active doctrine' 'ACTIVE_ANCHOR, status line' 'Future Run Approval Gate'
    New-Step 'Future Run Approval Gate' 'someone wants consolidation later' 'target, reducer lock status, and approval are named first' 'consolidation starts implicitly' 'future run checklist' 'End Receipt Gate'
    New-Step 'End Receipt Gate' 'CONSOLIDATOR closes the ring' 'receipt says final ring is locked and no reducer ran' 'end state is ambiguous' 'receipt, hash manifest' 'clean stop'
    New-Step 'Clean Stop Gate' 'the final ring closes' 'system stops for user talk before run, reduce, promote, or rewrite' 'ring continues past the end' 'final next action' 'clean stop'
)

$lenses = @(
    [ordered]@{ Name = 'Intake'; Clean = 'signal enters only after target, authority, and source type are visible'; Focus = 'first contact and capture'; Fail = 'the topic enters as loose pressure' }
    [ordered]@{ Name = 'Placement'; Clean = 'topic receives the right house lane, neighbor slot, and order slot'; Focus = 'home lane and relation'; Fail = 'the topic is placed by vibe or source prestige' }
    [ordered]@{ Name = 'Proof'; Clean = 'claims touch evidence before status words grow'; Focus = 'proof burden and disproof'; Fail = 'the topic sounds true without evidence' }
    [ordered]@{ Name = 'Recursive Return'; Clean = 'output names return target, next spin, and stop condition'; Focus = 'loop-back and stop behavior'; Fail = 'the topic produces endless active weight' }
    [ordered]@{ Name = 'Drift Defense'; Clean = 'variation, dirty import, and neighbor damage are checked before reuse'; Focus = 'drift, dirty import, and stability'; Fail = 'the topic mutates silently over time' }
)

$concepts = @(
    [ordered]@{ Title = 'Active Anchor Boundary'; Phase = 'Authority'; Focus = 'active anchor, allowed work, and blocked moves'; Source = 'ACTIVE_ANCHOR and active guide boundary'; Clean = 'support artifacts never become doctrine by proximity' }
    [ordered]@{ Title = 'Root Drop Custody'; Phase = 'Source'; Focus = 'loose root drops and source custody'; Source = 'mhm root drop, ET0o9zL3BDs transcript set, root cleanup receipts'; Clean = 'root remains a drop-off zone, not storage or authority' }
    [ordered]@{ Title = 'Source Provenance Passport'; Phase = 'Source'; Focus = 'source, activity, actor/tool, evidence, and derivation path'; Source = 'source evidence index, receipts, how-found gates'; Clean = 'each imported idea can show how it arrived' }
    [ordered]@{ Title = 'File Hash Truth'; Phase = 'File Truth'; Focus = 'paths, hashes, file listings, and integrity proof'; Source = 'PowerShell hash checks and baseline manifest'; Clean = 'file claims touch actual file state' }
    [ordered]@{ Title = 'Object Identity Status'; Phase = 'Object'; Focus = 'file, rule, proof, source, receipt, TODO, gate, or artifact identity'; Source = 'object identity gates and source dispositions'; Clean = 'the system knows what kind of thing it is handling' }
    [ordered]@{ Title = 'Word Key Placement'; Phase = 'Words'; Focus = 'words as routing keys and behavior-controlling labels'; Source = 'mhm instant-model failure note and word-control packets'; Clean = 'words route action to proof instead of performance' }
    [ordered]@{ Title = 'Seventeen Sentence Architectures'; Phase = 'Words'; Focus = 'reversal, impossible question, presupposition, label, witness, confession, permission, reframe, identity confirmation, accusation inversion, gap, lock, conspiracy, installation, regression, fait accompli, exit seal'; Source = 'ET0o9zL3BDs grouped dissection and transcript custody'; Clean = 'sentence structures become system exits, not human manipulation scripts' }
    [ordered]@{ Title = 'Frame Hygiene'; Phase = 'Frame'; Focus = 'identity threat, control threat, safety threat, pre-frame, proof frame, blocked false frames'; Source = 'YvyUdcVk_gA frame hygiene work order'; Clean = 'false frames are named and returned to proof work' }
    [ordered]@{ Title = 'Authority And Consent Boundary'; Phase = 'Frame'; Focus = 'authority, consent, human boundary, and non-coercion'; Source = 'dirty import block, support-only status, NCI risk translation'; Clean = 'behavior concepts are used only for systems design and defense' }
    [ordered]@{ Title = 'Needs Map Systems Translation'; Phase = 'Chase/NCI'; Focus = 'needs as system requirements and missing-satisfaction signals'; Source = 'NCI roadmap resources, Six-Minute X-Ray resource names'; Clean = 'needs map becomes object needs, not leverage over people' }
    [ordered]@{ Title = 'Decision Map Systems Translation'; Phase = 'Chase/NCI'; Focus = 'decision routes, choice points, proof exits, and fork constraints'; Source = 'NCI roadmap resources and local transcript logic'; Clean = 'decision map separates proof choice from narrative choice' }
    [ordered]@{ Title = 'Behavior Table Systems Translation'; Phase = 'Chase/NCI'; Focus = 'observable behavior classes translated to system state signs'; Source = 'NCI roadmap resource list and Behavioral Table of Elements references'; Clean = 'table terms help classify artifacts, not profile people' }
    [ordered]@{ Title = 'Behavior Compass Systems Translation'; Phase = 'Chase/NCI'; Focus = 'orientation, pressure direction, and next-route selection'; Source = 'NCI roadmap resource names and Chase corpus map'; Clean = 'compass points the system route without covert persuasion' }
    [ordered]@{ Title = 'Observation To Profiling Ladder'; Phase = 'Chase/NCI'; Focus = 'observer, profiler, scientist, author/operator as skill ladder translated to artifact maturity'; Source = 'NCI official roadmap levels'; Clean = 'skill ladder becomes artifact maturity, not status hierarchy' }
    [ordered]@{ Title = 'Feynman Representation Function'; Phase = 'Feynman'; Focus = 'diagrams, models, and representations that change legal moves'; Source = 'Feynman packets and lectures source ledger'; Clean = 'representation must operate, not decorate' }
    [ordered]@{ Title = 'Feynman Least Action Stability'; Phase = 'Feynman'; Focus = 'stability under small variation and low-friction paths'; Source = 'Feynman least-action translation'; Clean = 'routes survive perturbation and preserve objective' }
    [ordered]@{ Title = 'Feynman Symmetry Invariant'; Phase = 'Feynman'; Focus = 'conserved payload under transformation'; Source = 'symmetry and conservation translation'; Clean = 'condense keeps the invariant visible' }
    [ordered]@{ Title = 'Feynman Measurement Disturbs System'; Phase = 'Feynman'; Focus = 'inspection as system move and observer effect as artifact change'; Source = 'measurement and proof translation'; Clean = 'inspection side effects are named' }
    [ordered]@{ Title = 'Feynman Perturbation Scoped Add'; Phase = 'Feynman'; Focus = 'small controlled additions and bounded corrections'; Source = 'perturbation and approximation translation'; Clean = 'small patches stay scoped and reversible' }
    [ordered]@{ Title = 'Feynman Ratchet Directionality'; Phase = 'Feynman'; Focus = 'asymmetry, direction, and proof-bound one-way motion'; Source = 'ratchet and Brownian motion translation'; Clean = 'noise becomes motion only through proof-bound asymmetry' }
    [ordered]@{ Title = 'Feynman Reversible History'; Phase = 'Feynman'; Focus = 'history preservation before irreversible moves'; Source = 'reversible computation and source custody translation'; Clean = 'the system can go back before it reduces' }
    [ordered]@{ Title = 'Feynman Probe Scale'; Phase = 'Feynman'; Focus = 'right inspection scale for the object'; Source = 'parton/probe-scale translation'; Clean = 'small object gets small proof and broad object gets broad proof' }
    [ordered]@{ Title = 'Hypnosis Focused Attention'; Phase = 'Hypnosis Systems'; Focus = 'focused attention as active target salience'; Source = 'APA definition and hypnosis mechanism reviews'; Clean = 'attention narrows without verification going dark' }
    [ordered]@{ Title = 'Hypnosis Peripheral Reduction'; Phase = 'Hypnosis Systems'; Focus = 'dimmed side routes and peripheral noise control'; Source = 'APA hypnosis description and neuroscience reviews'; Clean = 'peripheral dimming is explicit and reversible' }
    [ordered]@{ Title = 'Hypnosis Suggestion State Fit'; Phase = 'Hypnosis Systems'; Focus = 'suggestion fit translated to instruction-state fit'; Source = 'hypnotic suggestion reviews and local transcript logic'; Clean = 'suggestion means state-compatible instruction, not control of a person' }
    [ordered]@{ Title = 'Hypnosis Network Switching'; Phase = 'Hypnosis Systems'; Focus = 'salience, executive control, and default-mode switching as routing analogy'; Source = 'Jiang hypnosis functional connectivity study and systematic reviews'; Clean = 'network terms remain analogy unless evidence supports a system route' }
    [ordered]@{ Title = 'Hypnosis Expectation Rapport Motivation'; Phase = 'Hypnosis Systems'; Focus = 'expectation, trust, and motivation translated to artifact readiness'; Source = 'hypnosis biopsychosocial and mechanism reviews'; Clean = 'readiness is a system state, not social pressure' }
    [ordered]@{ Title = 'Hypnosis No Single Mechanism'; Phase = 'Hypnosis Systems'; Focus = 'multi-mechanism guardrail and anti-mystique'; Source = '2024 review noting no consensus mechanism'; Clean = 'no single magic explanation becomes doctrine' }
    [ordered]@{ Title = 'Narrator Perspective Priority'; Phase = 'Transcript Logic'; Focus = 'narrator, perspective, priority, and failure-label checks'; Source = 'Wn-qgHg5JhE local transcript'; Clean = 'self-narration becomes status check, not proof' }
    [ordered]@{ Title = 'Dopamine Map To Conscious Board'; Phase = 'Transcript Logic'; Focus = 'pleasure source map translated to salience ledger'; Source = 'Wn-qgHg5JhE dopamine mapping segment'; Clean = 'hidden attention costs become visible board items' }
    [ordered]@{ Title = 'Script Disruption'; Phase = 'Transcript Logic'; Focus = 'autopilot script disruption translated to stale route breaker'; Source = 'Wn-qgHg5JhE disruption segment'; Clean = 'stale routes get interrupted without chaos' }
    [ordered]@{ Title = 'Future Self Visual Priority'; Phase = 'Transcript Logic'; Focus = 'future self relationship translated to future-state artifact'; Source = 'Wn-qgHg5JhE future-self segment'; Clean = 'future state becomes visible priority object' }
    [ordered]@{ Title = 'Self Efficacy Mastery'; Phase = 'Learning'; Focus = 'mastery experiences, capability evidence, and confidence calibration'; Source = 'ZtOxCJqEHjY notes and transcript'; Clean = 'confidence is built from mastery proof' }
    [ordered]@{ Title = 'Ambiguity Tolerance'; Phase = 'Learning'; Focus = 'uncertainty handling and awareness-without-structure loop prevention'; Source = 'ZtOxCJqEHjY user pulled notes'; Clean = 'ambiguity is held in a lane instead of becoming loop material' }
    [ordered]@{ Title = 'Meaning Versus Cause'; Phase = 'Signal Hygiene'; Focus = 'meaning relation separated from causal relation'; Source = 'w4HWSqnnzEo synchronicity transcript'; Clean = 'signal meaning does not masquerade as causal proof' }
    [ordered]@{ Title = 'Signal Syntax Units'; Phase = 'Communication'; Focus = 'communication units, syntax, repeated patterns, and code-like structure'; Source = 'Hm9ADZ28Wgo whale phonetic alphabet transcript'; Clean = 'signal units are parsed before meaning is claimed' }
    [ordered]@{ Title = 'Compact Perception Action'; Phase = 'Perception'; Focus = 'small architecture doing focused perception and action'; Source = 'Dgbci0GC1vk jumping spider transcript'; Clean = 'small systems get compact focused gates, not sprawling control' }
    [ordered]@{ Title = 'Myth To Mechanism Boundary'; Phase = 'Perception'; Focus = 'metaphor, myth, biological mechanism, and anti-mysticism boundary'; Source = '6LP3n9V7H_8 third-eye transcript'; Clean = 'strange language is translated to mechanism before use' }
)

$rings = New-Object System.Collections.Generic.List[object]
$ringNumber = 0
function Add-Ring($title, $phase, $lens, $focus, $source, $clean, $steps, $locked) {
    $script:ringNumber++
    $code = ('R{0:D3}' -f $script:ringNumber)
    $rings.Add((New-Ring $code $title $phase $lens $focus $source $clean $steps $locked))
}

Add-Ring 'Order Gate And Sequence Proof' 'Front Control' 'Keystone' 'true clean order for every gate before count, excitement, or consolidation' 'user request, prior 510 ring, order proof, ACTIVE_ANCHOR' 'ORDER is first and every later gate inherits the no-run sequence' $orderSteps $true
Add-Ring 'Reduction Lock And No-Run Control' 'Front Control' 'Keystone' 'all reducer, compressor, promotion, deletion, move, and consolidator behavior locked off' 'user request not to run gates and not let consolidator eat gates' 'generation and verification are allowed; gate execution is not' $noRunSteps $true
Add-Ring 'Recursion Spine And Return Control' 'Front Control' 'Keystone' 'recursive loop, return target, stop condition, and drift detection' 'recursive core architecture, cycle law, clean seed return rules' 'recursion expands only with return and stop behavior' $recursionSteps $true
Add-Ring 'Soft Gate Birth Room Interface' 'Front Control' 'Keystone' 'side room that births soft candidate gates without installing or running them' 'user request for gate birthing room and Chase/Feynman/hypnosis logic' 'birth produces parked candidates, never active doctrine' $birthSteps $true

foreach ($concept in $concepts) {
    foreach ($lens in $lenses) {
        $title = "$($concept.Title) - $($lens.Name)"
        $focus = "$($concept.Focus); lens: $($lens.Focus)"
        $clean = "$($concept.Clean). Lens clean result: $($lens.Clean)."
        $source = "$($concept.Source); lens guardrail: $($lens.Fail)"
        Add-Ring $title $concept.Phase $lens.Name $focus $source $clean $baseSteps $false
    }
}

Add-Ring 'Enoughness And Missing Gate Decision' 'End Control' 'Keystone' 'deciding whether more gates are needed without assistant preference or reducer action' 'user instruction that gates decide later, source coverage, birth room' 'more gates require missing-failure evidence or missing-source signal' $enoughSteps $true
Add-Ring 'Dirty Import And Anti-Coercion Final Guard' 'End Control' 'Guardrail' 'final block against manipulation import, mystique, therapy claims, and authority bleed' 'Chase/NCI risk, hypnosis boundary, support-only policy' 'human influence concepts remain systems-only and defensive' $baseSteps $true
Add-Ring 'Promotion Boundary And Active Doctrine Stop' 'End Control' 'Guardrail' 'separate proof needed before promotion, active guide edits, or doctrine rewrite' 'ACTIVE_ANCHOR, AGENTS, active guide boundary' 'candidate gates stop before active installation' $baseSteps $true
Add-Ring 'Final Judge Pre-Receipt Verification' 'End Control' 'Final Judge' 'final verification before the locked consolidator end ring' 'count proof, hash manifest, root check, repo status' 'done means generated, ordered, counted, hashed, and not run' $finalJudgeSteps $true
Add-Ring 'User Handoff And Talk Stop' 'End Control' 'Handoff' 'stop point for user discussion before run, reduce, promote, or rewrite' 'user instruction to stop at serious decision' 'the next action is talk, not automatic execution' $baseSteps $true
Add-Ring 'CONSOLIDATOR Locked End Ring' 'End Control' 'Consolidator Locked' 'consolidator, pack, park, reject, watch, and merge logic locked at the end' 'CONSOLIDATOR trial watch, user request for consolidator at the end' 'CONSOLIDATOR is present, end-placed, and asleep until explicit run approval' $consolidatorEndSteps $true

if ($rings.Count -ne 200) {
    throw "Ring count mismatch. Expected 200, got $($rings.Count)."
}

$rows = New-Object System.Collections.Generic.List[object]
$n = 0
foreach ($ring in $rings) {
    $stepNo = 0
    foreach ($step in $ring.Steps) {
        $n++
        $stepNo++
        $id = ('{0}-{1:D4}' -f $gatePrefix, $n)
        $rowStatus = if ($ring.Locked) {
            'candidate support gate; NO-RUN; reduction-locked; not active doctrine'
        } else {
            'candidate support gate; NO-RUN; not active doctrine'
        }
        $rows.Add([pscustomobject][ordered]@{
            ID            = $id
            Order         = $n
            Ring          = $ring.Code
            Phase         = $ring.Phase
            Lens          = $ring.Lens
            RingTitle     = $ring.Title
            Step          = ('{0:D2}' -f $stepNo)
            Gate          = $step.Name
            Focus         = $ring.Focus
            SourceBasis   = $ring.Source
            Trigger       = $step.Trigger
            PassCondition = "$($step.Pass). Ring clean result: $($ring.Clean)"
            FailCondition = $step.Fail
            Evidence      = $step.Evidence
            Next          = $step.Next
            Status        = $rowStatus
        })
    }
}

if ($rows.Count -ne 3400) {
    throw "Gate count mismatch. Expected 3400, got $($rows.Count)."
}

$csvPath = 'MASTER_GATE_RING_3400_EXPANDED_ORDERED_CANDIDATE.csv'
$rows | Export-Csv -NoTypeInformation -Encoding UTF8 $csvPath

$mdPath = 'MASTER_GATE_RING_3400_EXPANDED_ORDERED_CANDIDATE.md'
$md = New-Object System.Collections.Generic.List[string]
$md.Add('# Master Expanded Gate Ring - 3400 Ordered Gates')
$md.Add('')
$md.Add("Status: $status")
$md.Add("Date: $date")
$md.Add('')
$md.Add('Boundary: This artifact is support-only. It does not run gates, reduce gates, promote doctrine, edit ACTIVE_GUIDES, or rewrite CURRENT_TRUTH_INDEX.')
$md.Add('')
$md.Add('Core formula:')
$md.Add('')
$md.Add('`ORDER -> NO-RUN LOCK -> RECURSION -> SOFT BIRTH -> AUTHORITY -> SOURCE -> OBJECT -> WORDS -> ATTENTION -> FRAME -> RELATION -> RISK -> SUBSTRATE -> PROOF -> VARIATION -> RETURN -> ENOUGHNESS -> FINAL JUDGE -> CONSOLIDATOR LOCKED END`')
$md.Add('')
$md.Add('Count proof:')
$md.Add('')
$md.Add("- Rings: $($rings.Count)")
$md.Add('- Gates per ring: 17')
$md.Add("- Total gates: $($rows.Count)")
$md.Add('')
$md.Add('Critical keystones:')
$md.Add('')
$md.Add('- ORDER Gate: CS-EGR-0001')
$md.Add('- Reduction Lock / No-Run Control ring: R002, gates CS-EGR-0018 through CS-EGR-0034')
$md.Add('- Recursion Spine ring: R003, gates CS-EGR-0035 through CS-EGR-0051')
$md.Add('- Soft Gate Birth Room Interface ring: R004, gates CS-EGR-0052 through CS-EGR-0068')
$md.Add('- Enoughness Decision ring: R195, gates CS-EGR-3299 through CS-EGR-3315')
$md.Add('- CONSOLIDATOR Locked End Ring: R200, gates CS-EGR-3384 through CS-EGR-3400')
$md.Add('')
$md.Add('## Ring Order')
$md.Add('')
$md.Add('| Ring | Phase | Lens | Title | Focus | Source basis | Clean result | Locked |')
$md.Add('|---|---|---|---|---|---|---|---|')
foreach ($ring in $rings) {
    $md.Add("| $($ring.Code) | $(Escape-Cell $ring.Phase) | $(Escape-Cell $ring.Lens) | $(Escape-Cell $ring.Title) | $(Escape-Cell $ring.Focus) | $(Escape-Cell $ring.Source) | $(Escape-Cell $ring.Clean) | $($ring.Locked) |")
}
$md.Add('')
$md.Add('## Gate Ledger')
$md.Add('')
$md.Add('| ID | Ring | Step | Gate | Trigger | Pass condition | Evidence | Next | Status |')
$md.Add('|---|---|---:|---|---|---|---|---|---|')
foreach ($row in $rows) {
    $md.Add("| $($row.ID) | $($row.Ring) $(Escape-Cell $row.RingTitle) | $($row.Step) | $(Escape-Cell $row.Gate) | $(Escape-Cell $row.Trigger) | $(Escape-Cell $row.PassCondition) | $(Escape-Cell $row.Evidence) | $(Escape-Cell $row.Next) | $(Escape-Cell $row.Status) |")
}
$md.Add('')
$md.Add('## Issue Status')
$md.Add('')
$md.Add('Pending issue: No active run has been performed.')
$md.Add('Proof: Every row is marked NO-RUN; reduction-capable gates are reduction-locked; CONSOLIDATOR is the final ring and is asleep.')
$md.Add('Action needed: Talk with user before any gate run, reducer run, consolidation, promotion, active-guide edit, or doctrine rewrite.')
$md.Add('Closure condition: A later user-approved run names target, locks or unlocks reducers explicitly, and records proof.')
$md | Set-Content -Encoding UTF8 $mdPath

$orderPath = 'ORDER_PROOF_AND_NO_RUN_LOCK.md'
$orderDoc = @"
# Order Proof And No-Run Lock - Expanded Gate Ring

Status: SUPPORT ORDER PROOF / NO-RUN / NOT ACTIVE DOCTRINE
Date: $date

## Clean Order

This ring starts with ORDER because the user required true clean order before placement.

The first four rings are the front keystones:

1. ORDER Gate And Sequence Proof.
2. Reduction Lock And No-Run Control.
3. Recursion Spine And Return Control.
4. Soft Gate Birth Room Interface.

After the front keystones, the generated rings move through authority, custody, file truth, object identity, words, Chase/NCI structures, Feynman representations, hypnosis attention mechanisms, transcript logic, learning logic, signal hygiene, communication syntax, perception, and myth-to-mechanism boundaries.

The end control rings then check enoughness, dirty import, promotion boundary, final verification, user handoff, and finally the CONSOLIDATOR Locked End Ring.

## Why CONSOLIDATOR Is Last

The consolidator can pack, park, reject, watch, or merge. That means it is a reduction-capable gate. Because the user specifically warned not to let the consolidator eat the gates, it is placed at the end and marked reduction-locked.

No reducer, compressor, promotion, deletion, move, or consolidator behavior was run in this build.

## Keystone Placement

- ORDER first: CS-EGR-0001.
- Reduction lock near the front: R002.
- Recursion near the front: R003.
- Soft gate birth room near the front: R004.
- Enoughness near the end: R195.
- CONSOLIDATOR locked at the end: R200.

## Future Run Requirement

A later run must name:

- target object;
- runner;
- reducer lock status;
- whether CONSOLIDATOR is still asleep;
- evidence required for PASS;
- stop condition;
- user approval for active use.
"@
$orderDoc | Set-Content -Encoding UTF8 $orderPath

$birthPath = 'GATE_BIRTH_ROOM_SOFT_20260524.md'
$birthDoc = @"
# Gate Birth Room - Soft Side Room

Status: SOFT SIDE ROOM / CANDIDATE BIRTH ONLY / NO-RUN / NOT ACTIVE DOCTRINE
Date: $date

## Purpose

This room creates gate candidates from source logic, failure modes, and recurring system pressure. It does not run, promote, consolidate, delete, or rewrite gates.

## Birth Formula

`spark -> need claim -> target object -> trigger -> pass -> fail -> evidence -> dirty import block -> neighbor slot -> recursion fit -> reduction lock -> candidate ID -> parking -> review -> receipt`

## Candidate Schema

Each born gate needs:

- Candidate ID.
- Spark source.
- Need claim.
- Target object.
- Observable trigger.
- Pass condition.
- Fail condition.
- Evidence type.
- Dirty import block.
- Neighbor slot.
- Recursion return target.
- Stop condition.
- Reduction lock status.
- Parking home.
- Review condition.

## Pure Logic Birth Rules

1. A gate may be born from a repeated failure mode.
2. A gate may be born from a source concept only after translation into a systems object.
3. A gate may be born from a missing proof step.
4. A gate may be born from neighbor damage.
5. A gate may be born from recursion drift.
6. A gate may be born from missing stop condition.
7. A gate may be born from a false exit.
8. A gate may be born from dirty import risk.

## Hard Blocks

- No gate born here becomes active doctrine.
- No gate born here runs itself.
- No gate born here consolidates other gates.
- No gate born here profiles or manipulates people.
- No gate born here overrides ACTIVE_ANCHOR.
- No gate born here edits ACTIVE_GUIDES.

## First Soft Birth Queue

These are parked concepts, not installed gates:

| Soft ID | Candidate | Why it exists | Status |
|---|---|---|---|
| GB-SOFT-001 | Missing Failure Mode Gate | prevents growth by vibe | parked soft |
| GB-SOFT-002 | False Exit Detection Gate | catches proofless closure | parked soft |
| GB-SOFT-003 | State-Compatible Instruction Gate | translates hypnosis suggestion fit into systems only | parked soft |
| GB-SOFT-004 | Meaning Not Cause Gate | separates meaningful signal from causal proof | parked soft |
| GB-SOFT-005 | Future-State Artifact Gate | turns future outcome into visible system object | parked soft |
| GB-SOFT-006 | Script Disruption Gate | breaks stale automation routes | parked soft |
| GB-SOFT-007 | Behavior Table As Artifact Classifier Gate | uses behavior tables for system artifacts only | parked soft |
| GB-SOFT-008 | Consolidator Sleep Gate | prevents reduction before review | parked soft |

## Receipt Rule

Every birth-room session must leave a receipt that says what was born, what was parked, what was blocked, and what requires user talk before active use.
"@
$birthDoc | Set-Content -Encoding UTF8 $birthPath

$researchPath = 'MORE_RESEARCH_CHASE_HYPNOSIS_TRANSCRIPT_LEDGER_20260524.md'
$researchDoc = @"
# More Research Ledger - Chase Hughes, Hypnosis, Feynman Carry-Forward, And Local Transcripts

Status: SOURCE LEDGER / SYSTEMS TRANSLATION ONLY / NOT DOCTRINE
Date: $date

## Boundary

This ledger uses human-behavior and hypnosis material only as systems-design source ore. It does not provide persuasion scripts, therapy instructions, interrogation instructions, diagnosis, or human manipulation guidance.

## Chase / NCI Source Signals

- NCI official roadmap lists a ladder of Behavior Observer, Behavior Profiler, Behavior Scientist, and Author/Elite Operator. Systems translation: maturity ladder for artifacts, not people.
- NCI roadmap resource names include needs map, decision map, visual needs map, profile worksheet, behavior table, behavior compass, and table field guide. Systems translation: classify artifacts, needs, exits, and decision routes.
- Chase book/source corpus references The Ellipsis Manual, Six-Minute X-Ray, Behavior Operations Manual, and Behavioral Table of Elements. Systems translation: observation, state classification, and exit design. Source risk: mostly self-source/promotional, so not scientific proof by itself.
- Local ET0o9zL3BDs dissection adds the 17 sentence architectures. Systems translation: words create available exits and internal completion paths; dirty import block: no covert influence use.

## Hypnosis Source Signals

- APA describes hypnosis as focused attention with reduced peripheral awareness and enhanced capacity to respond to suggestion. Systems translation: active object bright, side routes dimmed, instruction-state fit checked.
- Jiang et al. report hypnosis-associated changes in brain activity and functional connectivity involving attention, control, and salience-related regions. Systems translation: salience and control coupling, not proof of a magic state.
- 2024 mechanism reviews emphasize that no single agreed mechanism explains all hypnotic responding. Systems translation: anti-mystique guardrail and multi-factor gate.
- Reviews connect hypnosis with attention, expectation, motivation, rapport, dissociation, and top-down modulation. Systems translation: readiness state, trust in artifact lane, and proof-preserving instruction fit.

## Feynman Carry-Forward Signals

- Representation must operate and change legal moves.
- Least action becomes stability under variation.
- Symmetry becomes invariant conservation during condense.
- Ratchet becomes directional proof-bound asymmetry.
- Reversible history means preserve hash/path/source before irreversible moves.
- Probe scale means inspection scale must match object scale.

## Local Transcript Signals

- Wn-qgHg5JhE: narrator, perspective, priority, dopamine mapping, conscious board, script disruption, future-self visual priority.
- ZtOxCJqEHjY: self-efficacy, mastery proof, ambiguity tolerance, and awareness-without-structure loop risk.
- YvyUdcVk_gA: frame hygiene, identity/control/safety threat diagnosis, pre-frame, proof frame, false-frame rejection.
- w4HWSqnnzEo: meaning relation is not the same as causal relation.
- Hm9ADZ28Wgo: signal units and syntax must be parsed before meaning is claimed.
- Dgbci0GC1vk: compact perception-action systems can operate with focused, small gates.
- 6LP3n9V7H_8: strange or mythic language must be translated into mechanism before use.

## Gate Additions Created From This Pass

- ORDER sharpened as the first gate.
- Reduction Lock placed immediately after ORDER.
- Recursion Spine placed before the source expansion.
- Soft Gate Birth Room placed near the front and kept side-room only.
- Enoughness gate placed near the end so growth asks for missing failure modes.
- CONSOLIDATOR placed at the final ring and locked asleep.

## Web Sources Used

- NCI official roadmap: https://nci.university/roadmapnci
- APA hypnosis overview: https://www.apa.org/topics/hypnosis/media
- Jiang et al., Brain Activity and Functional Connectivity Associated with Hypnosis: https://academic.oup.com/cercor/article/27/8/4083/3056452
- PubMed mechanism review search result used for 2024 no-consensus signal: https://pubmed.ncbi.nlm.nih.gov/
- Springer hypnosis mechanisms review page used for multi-mechanism signal: https://link.springer.com/article/10.1007/s42843-024-00122-2

## Clean Translation

`words place exits; attention weights exits; proof decides exits; recursion returns exits; birth creates candidate exits; consolidator sleeps until evidence says pack`
"@
$researchDoc | Set-Content -Encoding UTF8 $researchPath
if (-not (Test-Path -LiteralPath 'MORE_RESEARCH_CHASE_HYPNOSIS_TRANSCRIPT_LEDGER_20260524.md') -or ((Get-Item -LiteralPath 'MORE_RESEARCH_CHASE_HYPNOSIS_TRANSCRIPT_LEDGER_20260524.md').Length -eq 0)) {
    @(
        '# More Research Ledger - Chase Hughes, Hypnosis, Feynman Carry-Forward, And Local Transcripts'
        ''
        'Status: SOURCE LEDGER / SYSTEMS TRANSLATION ONLY / NOT DOCTRINE'
        "Date: $date"
        ''
        '## Boundary'
        ''
        'This ledger uses human-behavior and hypnosis material only as systems-design source ore. It does not provide persuasion scripts, therapy instructions, interrogation instructions, diagnosis, or human manipulation guidance.'
        ''
        '## Chase / NCI Source Signals'
        ''
        '- NCI official roadmap lists a ladder of Behavior Observer, Behavior Profiler, Behavior Scientist, and Author/Elite Operator. Systems translation: maturity ladder for artifacts, not people.'
        '- NCI roadmap resource names include needs map, decision map, visual needs map, profile worksheet, behavior table, behavior compass, and table field guide. Systems translation: classify artifacts, needs, exits, and decision routes.'
        '- Chase book/source corpus references The Ellipsis Manual, Six-Minute X-Ray, Behavior Operations Manual, and Behavioral Table of Elements. Systems translation: observation, state classification, and exit design. Source risk: mostly self-source/promotional, so not scientific proof by itself.'
        '- Local ET0o9zL3BDs dissection adds the 17 sentence architectures. Systems translation: words create available exits and internal completion paths; dirty import block: no covert influence use.'
        ''
        '## Hypnosis Source Signals'
        ''
        '- APA describes hypnosis as focused attention with reduced peripheral awareness and enhanced capacity to respond to suggestion. Systems translation: active object bright, side routes dimmed, instruction-state fit checked.'
        '- Jiang et al. report hypnosis-associated changes in brain activity and functional connectivity involving attention, control, and salience-related regions. Systems translation: salience and control coupling, not proof of a magic state.'
        '- 2024 mechanism reviews emphasize that no single agreed mechanism explains all hypnotic responding. Systems translation: anti-mystique guardrail and multi-factor gate.'
        '- Reviews connect hypnosis with attention, expectation, motivation, rapport, dissociation, and top-down modulation. Systems translation: readiness state, trust in artifact lane, and proof-preserving instruction fit.'
        ''
        '## Feynman Carry-Forward Signals'
        ''
        '- Representation must operate and change legal moves.'
        '- Least action becomes stability under variation.'
        '- Symmetry becomes invariant conservation during condense.'
        '- Ratchet becomes directional proof-bound asymmetry.'
        '- Reversible history means preserve hash/path/source before irreversible moves.'
        '- Probe scale means inspection scale must match object scale.'
        ''
        '## Local Transcript Signals'
        ''
        '- Wn-qgHg5JhE: narrator, perspective, priority, dopamine mapping, conscious board, script disruption, future-self visual priority.'
        '- ZtOxCJqEHjY: self-efficacy, mastery proof, ambiguity tolerance, and awareness-without-structure loop risk.'
        '- YvyUdcVk_gA: frame hygiene, identity/control/safety threat diagnosis, pre-frame, proof frame, false-frame rejection.'
        '- w4HWSqnnzEo: meaning relation is not the same as causal relation.'
        '- Hm9ADZ28Wgo: signal units and syntax must be parsed before meaning is claimed.'
        '- Dgbci0GC1vk: compact perception-action systems can operate with focused, small gates.'
        '- 6LP3n9V7H_8: strange or mythic language must be translated to mechanism before use.'
        ''
        '## Gate Additions Created From This Pass'
        ''
        '- ORDER sharpened as the first gate.'
        '- Reduction Lock placed immediately after ORDER.'
        '- Recursion Spine placed before the source expansion.'
        '- Soft Gate Birth Room placed near the front and kept side-room only.'
        '- Enoughness gate placed near the end so growth asks for missing failure modes.'
        '- CONSOLIDATOR placed at the final ring and locked asleep.'
        ''
        '## Web Sources Used'
        ''
        '- NCI official roadmap: https://nci.university/roadmapnci'
        '- APA hypnosis overview: https://www.apa.org/topics/hypnosis/media'
        '- Jiang et al., Brain Activity and Functional Connectivity Associated with Hypnosis: https://academic.oup.com/cercor/article/27/8/4083/3056452'
        '- PubMed mechanism review search page used for no-single-mechanism signal: https://pubmed.ncbi.nlm.nih.gov/'
        '- Springer hypnosis mechanisms review page used for multi-mechanism signal: https://link.springer.com/article/10.1007/s42843-024-00122-2'
        ''
        '## Clean Translation'
        ''
        '`words place exits; attention weights exits; proof decides exits; recursion returns exits; birth creates candidate exits; consolidator sleeps until evidence says pack`'
    ) | Set-Content -Encoding UTF8 -LiteralPath 'MORE_RESEARCH_CHASE_HYPNOSIS_TRANSCRIPT_LEDGER_20260524.md'
}
@(
    '# More Research Ledger - Chase Hughes, Hypnosis, Feynman Carry-Forward, And Local Transcripts'
    ''
    'Status: SOURCE LEDGER / SYSTEMS TRANSLATION ONLY / NOT DOCTRINE'
    "Date: $date"
    ''
    '## Boundary'
    ''
    'This ledger uses human-behavior and hypnosis material only as systems-design source ore. It does not provide persuasion scripts, therapy instructions, interrogation instructions, diagnosis, or human manipulation guidance.'
    ''
    '## Chase / NCI Source Signals'
    ''
    '- NCI official roadmap: observation/profiling/scientist/operator ladder becomes artifact maturity.'
    '- NCI resource names: needs map, decision map, profile worksheet, behavior table, behavior compass, and table field guide become system classification and routing tools.'
    '- Chase corpus: Ellipsis Manual, Six-Minute X-Ray, Behavior Operations Manual, and Behavioral Table of Elements are source ore, not scientific proof by themselves.'
    '- Local ET0o9zL3BDs dissection: 17 sentence architectures become system exit and internal-completion gates, not human manipulation scripts.'
    ''
    '## Hypnosis Source Signals'
    ''
    '- APA: hypnosis involves focused attention, reduced peripheral awareness, and enhanced response to suggestion. Systems translation: active object bright, side routes dimmed, instruction-state fit checked.'
    '- Jiang et al.: hypnosis-associated activity/connectivity changes support salience-control coupling as an analogy, not a magic-state claim.'
    '- 2024 mechanism reviews: no single mechanism explains all hypnotic responding. Systems translation: anti-mystique and multi-factor guardrail.'
    '- Reviews: attention, expectation, motivation, rapport, dissociation, and top-down modulation become readiness and proof-preserving instruction-fit gates.'
    ''
    '## Feynman Carry-Forward Signals'
    ''
    '- Representation must operate and change legal moves.'
    '- Least action becomes stability under variation.'
    '- Symmetry becomes invariant conservation during condense.'
    '- Ratchet becomes directional proof-bound asymmetry.'
    '- Reversible history means preserve hash/path/source before irreversible moves.'
    '- Probe scale means inspection scale must match object scale.'
    ''
    '## Local Transcript Signals'
    ''
    '- Wn-qgHg5JhE: narrator, perspective, priority, dopamine mapping, conscious board, script disruption, future-self visual priority.'
    '- ZtOxCJqEHjY: self-efficacy, mastery proof, ambiguity tolerance, and awareness-without-structure loop risk.'
    '- YvyUdcVk_gA: frame hygiene, identity/control/safety threat diagnosis, pre-frame, proof frame, false-frame rejection.'
    '- w4HWSqnnzEo: meaning relation is not the same as causal relation.'
    '- Hm9ADZ28Wgo: signal units and syntax must be parsed before meaning is claimed.'
    '- Dgbci0GC1vk: compact perception-action systems can operate with focused, small gates.'
    '- 6LP3n9V7H_8: strange or mythic language must be translated to mechanism before use.'
    ''
    '## Gate Additions Created From This Pass'
    ''
    '- ORDER sharpened as the first gate.'
    '- Reduction Lock placed immediately after ORDER.'
    '- Recursion Spine placed before the source expansion.'
    '- Soft Gate Birth Room placed near the front and kept side-room only.'
    '- Enoughness gate placed near the end so growth asks for missing failure modes.'
    '- CONSOLIDATOR placed at the final ring and locked asleep.'
    ''
    '## Web Sources Used'
    ''
    '- NCI official roadmap: https://nci.university/roadmapnci'
    '- APA hypnosis overview: https://www.apa.org/topics/hypnosis/media'
    '- Jiang et al., Brain Activity and Functional Connectivity Associated with Hypnosis: https://academic.oup.com/cercor/article/27/8/4083/3056452'
    '- PubMed mechanism review search page used for no-single-mechanism signal: https://pubmed.ncbi.nlm.nih.gov/'
    '- Springer hypnosis mechanisms review page used for multi-mechanism signal: https://link.springer.com/article/10.1007/s42843-024-00122-2'
    ''
    '## Clean Translation'
    ''
    '`words place exits; attention weights exits; proof decides exits; recursion returns exits; birth creates candidate exits; consolidator sleeps until evidence says pack`'
) | Set-Content -Encoding UTF8 -LiteralPath 'MORE_RESEARCH_CHASE_HYPNOSIS_TRANSCRIPT_LEDGER_20260524.md'

$receiptDoc = @"
# Receipt - Master Expanded Gate Ring

Status: BUILD RECEIPT / NO-RUN / NOT ACTIVE DOCTRINE
Date: $date

## Built

- Expanded ordered candidate ring: MASTER_GATE_RING_3400_EXPANDED_ORDERED_CANDIDATE.md
- Expanded ordered candidate CSV: MASTER_GATE_RING_3400_EXPANDED_ORDERED_CANDIDATE.csv
- Order/no-run proof: ORDER_PROOF_AND_NO_RUN_LOCK.md
- Soft gate birth room: GATE_BIRTH_ROOM_SOFT_20260524.md
- More research ledger: MORE_RESEARCH_CHASE_HYPNOSIS_TRANSCRIPT_LEDGER_20260524.md

## Count

- Rings: 200.
- Gates per ring: 17.
- Total gates: 3400.
- First gate: CS-EGR-0001 ORDER Gate.
- Final ring: R200 CONSOLIDATOR Locked End Ring.
- Final gate: CS-EGR-3400 Clean Stop Gate.

## No-Run Proof

No gate cycle was run.
No consolidator was run.
No reducer was run.
No compressor was run.
No deletion was run.
No promotion was run.
No ACTIVE_GUIDES edit was made by this build.

## Baseline

The previous 510-gate baseline remains in:

HOUSE_WORK\GATE_RINGS\MASTER_500_GATE_RING_20260524\

The pre-expansion hash manifest remains in that folder.

## Next Action

Stop and talk before any gate run, consolidation, promotion, reduction, active guide edit, or doctrine rewrite.
"@
$receiptDoc | Set-Content -Encoding UTF8 -LiteralPath 'RECEIPT_20260524.md'
if (-not (Test-Path -LiteralPath 'RECEIPT_20260524.md') -or ((Get-Item -LiteralPath 'RECEIPT_20260524.md').Length -eq 0)) {
    @(
        '# Receipt - Master Expanded Gate Ring'
        ''
        'Status: BUILD RECEIPT / NO-RUN / NOT ACTIVE DOCTRINE'
        "Date: $date"
        ''
        '## Built'
        ''
        '- Expanded ordered candidate ring: MASTER_GATE_RING_3400_EXPANDED_ORDERED_CANDIDATE.md'
        '- Expanded ordered candidate CSV: MASTER_GATE_RING_3400_EXPANDED_ORDERED_CANDIDATE.csv'
        '- Order/no-run proof: ORDER_PROOF_AND_NO_RUN_LOCK.md'
        '- Soft gate birth room: GATE_BIRTH_ROOM_SOFT_20260524.md'
        '- More research ledger: MORE_RESEARCH_CHASE_HYPNOSIS_TRANSCRIPT_LEDGER_20260524.md'
        ''
        '## Count'
        ''
        '- Rings: 200.'
        '- Gates per ring: 17.'
        '- Total gates: 3400.'
        '- First gate: CS-EGR-0001 ORDER Gate.'
        '- Final ring: R200 CONSOLIDATOR Locked End Ring.'
        '- Final gate: CS-EGR-3400 Clean Stop Gate.'
        ''
        '## No-Run Proof'
        ''
        'No gate cycle was run.'
        'No consolidator was run.'
        'No reducer was run.'
        'No compressor was run.'
        'No deletion was run.'
        'No promotion was run.'
        'No ACTIVE_GUIDES edit was made by this build.'
        ''
        '## Baseline'
        ''
        'The previous 510-gate baseline remains in:'
        ''
        'HOUSE_WORK\GATE_RINGS\MASTER_500_GATE_RING_20260524\'
        ''
        'The pre-expansion hash manifest remains in that folder.'
        ''
        '## Next Action'
        ''
        'Stop and talk before any gate run, consolidation, promotion, reduction, active guide edit, or doctrine rewrite.'
    ) | Set-Content -Encoding UTF8 -LiteralPath 'RECEIPT_20260524.md'
}

$generated = @(
    'BUILD_MASTER_EXPANDED_GATE_RING_20260524.ps1',
    'MASTER_GATE_RING_3400_EXPANDED_ORDERED_CANDIDATE.csv',
    'MASTER_GATE_RING_3400_EXPANDED_ORDERED_CANDIDATE.md',
    'ORDER_PROOF_AND_NO_RUN_LOCK.md',
    'GATE_BIRTH_ROOM_SOFT_20260524.md',
    'MORE_RESEARCH_CHASE_HYPNOSIS_TRANSCRIPT_LEDGER_20260524.md',
    'RECEIPT_20260524.md'
)

$hashPath = 'POST_EXPANSION_HASH_MANIFEST_20260524.md'
$hashDoc = New-Object System.Collections.Generic.List[string]
$hashDoc.Add('# Post Expansion Hash Manifest')
$hashDoc.Add('')
$hashDoc.Add('Status: HASH MANIFEST / AFTER EXPANDED BUILD')
$hashDoc.Add("Date: $date")
$hashDoc.Add('')
$hashDoc.Add('| File | SHA256 |')
$hashDoc.Add('|---|---|')
foreach ($name in $generated) {
    $path = $name
    $hash = (Get-FileHash -Algorithm SHA256 $path).Hash
    $hashDoc.Add("| $name | $hash |")
}
$hashDoc | Set-Content -Encoding UTF8 $hashPath

Write-Host "Built expanded gate ring with $($rows.Count) gates across $($rings.Count) rings."
Write-Host "First gate: $($rows[0].ID) $($rows[0].Gate)"
Write-Host "Last gate: $($rows[$rows.Count - 1].ID) $($rows[$rows.Count - 1].Gate)"
Write-Host "Consolidator ring: $($rings[$rings.Count - 1].Code) $($rings[$rings.Count - 1].Title)"
Write-Host "No gates were run."

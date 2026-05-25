$ErrorActionPreference = 'Stop'

$Date = '2026-05-24'
$Status = 'SUPPORT GATE RING / RUN 2 EXPANDED ORDERED CANDIDATE / NO-RUN / NOT ACTIVE DOCTRINE'
$Root = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
$RepoRoot = Resolve-Path (Join-Path $Root '..\..\..')
$TargetRings = 600
$TargetGates = $TargetRings * 17

function New-Step($name, $trigger, $pass, $fail, $evidence, $next) {
    [ordered]@{
        Name = $name
        Trigger = $trigger
        Pass = $pass
        Fail = $fail
        Evidence = $evidence
        Next = $next
    }
}

function New-Ring($title, $phase, $lens, $focus, $source, $clean, $steps, $locked) {
    [ordered]@{
        Title = $title
        Phase = $phase
        Lens = $lens
        Focus = $focus
        Source = $source
        Clean = $clean
        Steps = $steps
        Locked = $locked
    }
}

function Clean-Cell($text) {
    if ($null -eq $text) { return '' }
    return (($text.ToString() -replace '\|', '/') -replace "`r?`n", ' ')
}

function Normalize-Title($name) {
    $base = [IO.Path]::GetFileNameWithoutExtension($name)
    $base = $base -replace '_20\d{6}.*$', ''
    $base = $base -replace '_\d{6}$', ''
    $base = $base -replace 'TODO_', ''
    $base = $base -replace '_', ' '
    $base = $base.ToLowerInvariant()
    $textInfo = (Get-Culture).TextInfo
    return $textInfo.ToTitleCase($base)
}

function Phase-For($title) {
    switch -Regex ($title) {
        'Order|Sort|Sequence|Read Order|Queue|Priority|First|Next Move' { return 'Order' }
        'Source|Transcript|Intake|Custody|Ore|Root Drop|Incoming|Drop|Transfer' { return 'Source' }
        'Proof|Evidence|Hash|How Found|Receipt|Verdict|Judge|Truth|Pass' { return 'Proof' }
        'Gate|Rule|Trigger|Firing|Activation|Family|Coverage' { return 'Gate Ecology' }
        'Recursive|Recursion|Loop|Ouroboros|Mirror|Spin|Return' { return 'Recursion' }
        'Frame|Authority|Boundary|Scope|Control|Boss|Suit' { return 'Authority Frame' }
        'Tool|PowerShell|Script|Runner|Command|Child Shell|Remote Door' { return 'Tool Substrate' }
        'Dirty|Security|Token|Local Only|Privacy|Risk|Guard|Abort' { return 'Risk Security' }
        'Parking|Park|Lifecycle|Release|Hold|Handoff|Mule|Mail' { return 'Lifecycle' }
        'Word|Language|Name|Key|Meaning|Signal|Syntax|Narrator' { return 'Words Signals' }
        'Feynman|Physics|Ratchet|Symmetry|Measurement|Probe|Substrate' { return 'Feynman Systems' }
        'Hypnosis|Attention|Salience|Suggestion|Agency|Prediction|Default Mode|Executive' { return 'Hypnosis Systems' }
        'Chase|Nci|Behavior|Needs|Decision|Compass|Profiler|Influence' { return 'Chase Systems' }
        default { return 'House System' }
    }
}

function Add-Concept([System.Collections.Generic.List[object]]$list, [string]$title, [string]$source, [string]$focus, [string]$phase) {
    if ([string]::IsNullOrWhiteSpace($title)) { return }
    $cleanTitle = ($title -replace '\s+', ' ').Trim()
    if ($script:SeenConcepts.ContainsKey($cleanTitle.ToLowerInvariant())) { return }
    $script:SeenConcepts[$cleanTitle.ToLowerInvariant()] = $true
    if ([string]::IsNullOrWhiteSpace($phase)) { $phase = Phase-For $cleanTitle }
    $list.Add([pscustomobject][ordered]@{
        Title = $cleanTitle
        Phase = $phase
        Source = $source
        Focus = $focus
    })
}

$baseSteps = @(
    New-Step 'Trigger Naming Gate' 'a signal enters this ring' 'signal, target, and source type are named before action' 'the ring begins from vague pressure' 'user request, source path, title, command output, or citation' 'Authority Boundary Gate'
    New-Step 'Authority Boundary Gate' 'the signal might steer files, rules, status, or people' 'allowed touch, blocked touch, and support-only status are visible' 'source ore becomes authority by proximity' 'ACTIVE_ANCHOR, AGENTS, status line, user request' 'Object Identity Gate'
    New-Step 'Object Identity Gate' 'the ring needs a target' 'object class is named: file, rule, proof, gate, source, note, TODO, transcript, or method' 'the gate acts on an unnamed mass' 'path, object type, lane, source disposition' 'Source Trail Gate'
    New-Step 'Source Trail Gate' 'concept or evidence is imported' 'source, route, and derivation are visible' 'a useful idea appears with no chain' 'source ledger, hash, citation, local file path' 'Placement Slot Gate'
    New-Step 'Placement Slot Gate' 'the gate needs a home in the sequence' 'phase, lens, neighbor, and order slot are named' 'placement follows excitement or source prestige' 'ring order, phase, lens, neighbor list' 'Word And Label Gate'
    New-Step 'Word And Label Gate' 'wording can route behavior' 'behavior-controlling words point to object, action, evidence, verdict, and next state' 'clean labels open a false exit' 'gate name, pass words, fail words, status words' 'Attention Weight Gate'
    New-Step 'Attention Weight Gate' 'too many signals compete' 'active focus, dimmed side routes, and blocked routes are named' 'all signals stay equally loud' 'active target, side route list, load note' 'Exit Design Gate'
    New-Step 'Exit Design Gate' 'the system can leave the ring' 'available exits close by proof, park, stop, or explicit future approval' 'the system exits by explanation alone' 'exit list, proof close, parking trigger' 'Risk Dirty Import Gate'
    New-Step 'Risk Dirty Import Gate' 'outside source logic could contaminate the house' 'dirty, coercive, mystical, authority-bleed, and privacy risks are named' 'hazardous logic is imported because it is interesting' 'risk line, blocked-use line, quarantine path' 'Substrate Match Gate'
    New-Step 'Substrate Match Gate' 'a tool or method is selected' 'tool matches the phenomenon being checked' 'a large tool substitutes for the right substrate' 'shell output, source ledger, map, test, receipt' 'Proof Burden Gate'
    New-Step 'Proof Burden Gate' 'the gate wants PASS' 'PASS requires visible evidence or explicit parked uncertainty' 'confidence, fluency, repetition, or authority becomes proof' 'hash, path, line, citation, status, count' 'Variation Stability Gate'
    New-Step 'Variation Stability Gate' 'the gate may be reused' 'small wording, order, source, and context changes do not break the invariant' 'gate only works in the original phrasing' 'variation note, invariant, counterexample' 'Recursion Fit Gate'
    New-Step 'Recursion Fit Gate' 'the output can loop back' 'return target, next spin, stop condition, and drift watch are named' 'the gate creates endless active weight' 'return field, stop field, drift check' 'Birth Referral Gate'
    New-Step 'Birth Referral Gate' 'a missing gate appears' 'missing gate is referred to soft birth room with need claim and source' 'new gate silently installs itself' 'birth room path, candidate ID, source spark' 'Neighbor Damage Gate'
    New-Step 'Neighbor Damage Gate' 'the gate touches other gates' 'affected neighbors are listed before clean placement is claimed' 'new gate breaks existing lanes silently' 'neighbor list, affected scope' 'Verdict Status Gate'
    New-Step 'Verdict Status Gate' 'a judgment is needed' 'status matches evidence: PASS, PASS WITH GUARDRAILS, PARTIAL, FAIL, INVALID, YIELD, BLOCKED, PARKED, WATCH, or STOP' 'status exaggerates proof' 'verdict line, proof burden, open guardrail' 'Receipt Return Gate'
    New-Step 'Receipt Return Gate' 'the ring closes' 'receipt, next state, and clean stop or return trigger are visible' 'ring closes with no trace or no next state' 'receipt, hash manifest, repo status, next action' 'next ring or clean stop'
)

$orderSteps = @(
    New-Step 'ORDER Gate' 'any run-2 gate is created, placed, reviewed, or prepared for future use' 'sequence is declared before count: order, lock, recursion, birth, source harvest, coverage, source-derived rings, enoughness, final judge, consolidator locked end' 'count or excitement chooses placement' 'ring order table, no-run proof, source ledger' 'No-Run Gate'
    New-Step 'No-Run Gate' 'the user says run it again' 'run means build and verify candidate artifacts only unless user explicitly approves gate execution' 'generator execution is confused with gate-cycle execution' 'status field, receipt, command purpose' 'Reduction Lock Gate'
    New-Step 'Reduction Lock Gate' 'a reducer, compressor, consolidator, delete, move, or promotion could fire' 'reduction behavior is locked off in every generated row' 'consolidator eats fresh gates before review' 'Status column, R600, receipt' 'Run-2 Source Harvest Gate'
    New-Step 'Run-2 Source Harvest Gate' 'more gates are requested' 'local Brain Learning, command templates, TODOs, transcripts, and web sources are harvested as source ore' 'run 2 only stretches old gates' 'source list and run-2 ledger' 'House Native Priority Gate'
    New-Step 'House Native Priority Gate' 'local and outside sources both exist' 'house-native rules get priority, outside sources become bounded supplements' 'outside source prestige overrides house state' 'BRAIN_LEARNING list, active boundary' 'Web Source Boundary Gate'
    New-Step 'Web Source Boundary Gate' 'web research enters the ring' 'official/self-source and scientific sources are separated by evidence strength' 'promotional claims become proof' 'NCI page, APA, PubMed/PMC/Springer pages' 'Chase Risk Gate'
    New-Step 'Chase Risk Gate' 'Chase/NCI concepts are used' 'behavior logic translates to artifact classification and exit design only' 'human influence scripts are imported' 'blocked-use line, systems-only status' 'Hypnosis Risk Gate'
    New-Step 'Hypnosis Risk Gate' 'hypnosis concepts are used' 'attention, expectation, and suggestion concepts translate to system state fit with verification alive' 'mystique, therapy claim, or control claim enters' 'APA/PubMed/PMC ledger' 'Feynman Risk Gate'
    New-Step 'Feynman Risk Gate' 'physics concepts are used' 'physics ideas translate as design analogies, not proof' 'metaphor becomes law' 'Feynman packet, source ledger' 'Coverage Before Growth Gate'
    New-Step 'Coverage Before Growth Gate' 'ring grows to 10200 gates' 'growth is backed by source-derived concept coverage' 'bigness replaces coverage' 'concept ledger, ring count' 'Order Slot Gate'
    New-Step 'Order Slot Gate' 'source-derived gates are placed' 'phase classifier and lens order determine position' 'alphabetical or random placement pretends to be order' 'phase/lens fields, sorted ring table' 'Duplicate Soft Watch Gate'
    New-Step 'Duplicate Soft Watch Gate' 'file titles overlap' 'duplicates are deduped or watched, not deleted from source' 'overlap silently creates authority collision' 'seen-concept ledger, source list' 'No Active Doctrine Gate'
    New-Step 'No Active Doctrine Gate' 'candidate looks useful' 'no ACTIVE_GUIDES or CURRENT_TRUTH rewrite occurs' 'candidate becomes doctrine by proximity' 'git status, output path' 'No Git Save Gate'
    New-Step 'No Git Save Gate' 'user says not to worry about Git' 'data is saved to workspace artifacts and held in thread summary, with no staging or commit' 'assistant commits or pushes anyway' 'git status, receipt' 'Count Proof Gate'
    New-Step 'Count Proof Gate' 'large ring is claimed' 'exact count, first ID, last ID, and sequential order are verifiable' 'count is approximate' 'CSV import count, ID check' 'Stop Before Use Gate'
    New-Step 'Stop Before Use Gate' 'build completes' 'work stops before any run, reduction, promotion, or active rewrite' 'assistant keeps going into execution' 'receipt next action' 'Return Gate'
    New-Step 'Return Gate' 'ORDER ring closes' 'next ring is no-run/reduction lock' 'order becomes endless planning' 'R002 pointer' 'R002'
)

$noRunSteps = @(
    New-Step 'Run Means Build Gate' 'the phrase run it again appears' 'run is constrained to build, research, count, hash, and verify artifacts' 'run means execute gate cycle without approval' 'user context, receipt' 'Reducer Sleep Gate'
    New-Step 'Reducer Sleep Gate' 'reducer-capable logic exists' 'reducers are locked and inspected as text only' 'reducer fires because it exists' 'Status column, R600' 'Consolidator Sleep Gate'
    New-Step 'Consolidator Sleep Gate' 'CONSOLIDATOR exists' 'CONSOLIDATOR is final, locked, and not run' 'CONSOLIDATOR packs or eats gates now' 'R600, no-run receipt' 'Promotion Sleep Gate'
    New-Step 'Promotion Sleep Gate' 'candidate gates look good' 'promotion requires future user-approved proof pass' 'support artifact becomes active doctrine' 'ACTIVE_ANCHOR, status header' 'Delete Sleep Gate'
    New-Step 'Delete Sleep Gate' 'duplicates or weak gates appear' 'nothing is deleted by this build' 'fresh gates are removed before review' 'receipt, git status' 'Move Sleep Gate'
    New-Step 'Move Sleep Gate' 'gate could fit elsewhere' 'misplacement is reported but not moved into active guides' 'candidate rewrites active lanes' 'output folder, no active diff' 'Inspection Only Gate'
    New-Step 'Inspection Only Gate' 'rows are counted, hashed, or searched' 'inspection produces proof only' 'inspection mutates verdicts' 'count, hash, grep' 'No Git Gate'
    New-Step 'No Git Gate' 'data is saved' 'no git add, commit, or push is performed' 'workspace data is treated as git-saved' 'git status, receipt' 'Thread Carry Gate'
    New-Step 'Thread Carry Gate' 'user says save the data on you and on it' 'summary card is written and key state is carried in final answer' 'data only exists in unsummarized sprawl' 'working memory card, receipt' 'Manual Approval Gate'
    New-Step 'Manual Approval Gate' 'future use is tempting' 'target, reducer lock status, and approval are required before use' 'future run starts from artifact existence alone' 'future run checklist' 'Rollback Gate'
    New-Step 'Rollback Gate' 'run 2 is large' 'run-1 and pre-run-2 hashes remain intact' 'new build overwrites old anchor' 'pre-run2 manifest, run1 folder' 'Fresh Candidate Quarantine Gate'
    New-Step 'Fresh Candidate Quarantine Gate' 'new gates are born' 'all stay candidate support gates' 'birth equals install' 'Status column' 'No Hidden Automation Gate'
    New-Step 'No Hidden Automation Gate' 'scripts are created' 'no automation, hook, daemon, or watcher is installed' 'script creates hidden future action' 'file list, script scan' 'Static Artifact Gate'
    New-Step 'Static Artifact Gate' 'CSV/MD files are generated' 'artifacts are static ledgers, not executors' 'ledger becomes live behavior' 'file extension, receipt' 'Hash After Build Gate'
    New-Step 'Hash After Build Gate' 'files are complete' 'post-build hashes are recorded' 'integrity is assumed' 'hash manifest' 'Stop For Talk Gate'
    New-Step 'Stop For Talk Gate' 'verification completes' 'stop for user talk before active action' 'assistant runs ahead' 'receipt next action' 'R003'
    New-Step 'Return Gate' 'lock ring closes' 'next ring is recursion spine' 'lock disappears after first ring' 'R003 pointer' 'R003'
)

$recursionSteps = @(
    New-Step 'Recursive Object Continuity Gate' 'output loops into another pass' 'same object or explicit transform is named' 'object changes silently' 'target field, transform note' 'Recursive Authority Gate'
    New-Step 'Recursive Authority Gate' 'run 2 inherits run 1' 'authority does not grow from repetition' 'repeat count becomes authority' 'status header' 'Recursive Source Gate'
    New-Step 'Recursive Source Gate' 'source is reused' 'source trail remains attached across passes' 'source disappears after extraction' 'source ledger, path' 'Recursive Attention Gate'
    New-Step 'Recursive Attention Gate' 'next pass begins' 'active focus and blocked side routes reset' 'old salience drifts forward' 'focus line, blocked routes' 'Recursive Exit Gate'
    New-Step 'Recursive Exit Gate' 'old exits are reused' 'exits are checked for proof closure again' 'false exit survives because it was old' 'exit list, proof close' 'Recursive Proof Gate'
    New-Step 'Recursive Proof Gate' 'old proof is reused' 'proof is fresh, stale, or parked' 'stale proof stays PASS' 'hash, citation date, status' 'Recursive Variation Gate'
    New-Step 'Recursive Variation Gate' 'new lenses are added' 'variation preserves invariant and adds coverage' 'variation creates drift' 'lens field, invariant' 'Recursive Drift Gate'
    New-Step 'Recursive Drift Gate' 'wording or order changes' 'drift is named before it accumulates' 'tiny drift compounds silently' 'diff, title, order' 'Recursive Birth Gate'
    New-Step 'Recursive Birth Gate' 'missing gate appears' 'candidate goes to soft birth room' 'candidate activates itself' 'birth queue' 'Recursive Saturation Gate'
    New-Step 'Recursive Saturation Gate' 'more gates may be possible' 'more growth needs missing failure mode or source signal' 'growth continues from anxiety alone' 'coverage ledger' 'Recursive Stop Gate'
    New-Step 'Recursive Stop Gate' 'serious decision appears' 'stop before run, condense, promote, or rewrite' 'loop outruns decision' 'receipt' 'Recursive Neighbor Gate'
    New-Step 'Recursive Neighbor Gate' 'new pass touches previous ring' 'neighbor fit between 3400 and 10200 rings is named' 'run 2 breaks run 1 silently' 'run1 path, run2 path' 'Recursive Reduction Lock Gate'
    New-Step 'Recursive Reduction Lock Gate' 'overlap increases' 'overlap waits for final locked consolidator' 'condense fires during generation' 'R600 lock' 'Recursive Receipt Gate'
    New-Step 'Recursive Receipt Gate' 'pass closes' 'receipt captures born, parked, blocked, and next talk' 'loop closes without trace' 'receipt' 'Recursive Return Gate'
    New-Step 'Recursive Return Gate' 'ring closes' 'next ring is soft birth room' 'recursion loops into itself only' 'R004 pointer' 'R004'
    New-Step 'Recursive Evidence Gate' 'repeat count rises' 'repeat count is signal, not proof' 'many repeats become truth' 'source evidence' 'Recursive Human Boundary Gate'
    New-Step 'Recursive Human Boundary Gate' 'human behavior material recurs' 'systems-only translation is preserved' 'human influence use sneaks in' 'blocked-use line' 'R004'
)

$birthSteps = @(
    New-Step 'Soft Birth Door Gate' 'a missing gate is noticed' 'birth room accepts soft candidate requests only' 'birth room installs gates directly' 'birth status' 'Spark Capture Gate'
    New-Step 'Spark Capture Gate' 'source or failure sparks a gate' 'spark source and need claim are captured' 'gate starts as name only' 'source path, need claim' 'Target Object Gate'
    New-Step 'Target Object Gate' 'candidate needs target' 'target object class is named' 'candidate cannot fire cleanly' 'target field' 'Trigger Draft Gate'
    New-Step 'Trigger Draft Gate' 'candidate needs trigger' 'trigger is observable and bounded' 'trigger is mood language' 'trigger field' 'Pass Draft Gate'
    New-Step 'Pass Draft Gate' 'candidate needs pass condition' 'pass is evidence-bound' 'pass is feeling of correctness' 'pass field' 'Fail Draft Gate'
    New-Step 'Fail Draft Gate' 'candidate needs fail condition' 'fail names bad route' 'fail is generic badness' 'fail field' 'Evidence Draft Gate'
    New-Step 'Evidence Draft Gate' 'candidate needs proof type' 'evidence type is named before review' 'candidate proves itself' 'evidence field' 'Dirty Import Draft Gate'
    New-Step 'Dirty Import Draft Gate' 'candidate imports external logic' 'coercive, mystical, unsupported, and authority-bleed uses are blocked' 'source arrives unfiltered' 'blocked-use field' 'Neighbor Slot Gate'
    New-Step 'Neighbor Slot Gate' 'candidate needs placement' 'neighbors and order slot are named' 'candidate is thrown into pile' 'neighbor field' 'Recursion Fit Draft Gate'
    New-Step 'Recursion Fit Draft Gate' 'candidate may recur' 'return target and stop condition are named' 'candidate creates endless pressure' 'return and stop fields' 'Reduction Lock Draft Gate'
    New-Step 'Reduction Lock Draft Gate' 'candidate can reduce or consolidate' 'reduction stays locked until approved' 'candidate consumes other gates' 'lock field' 'Candidate Id Gate'
    New-Step 'Candidate Id Gate' 'candidate is recorded' 'candidate gets stable soft ID' 'candidate cannot be tracked' 'soft ID' 'Parking Gate'
    New-Step 'Parking Gate' 'candidate is not ready' 'candidate is parked with return trigger' 'candidate becomes active weight' 'parking path' 'Review Queue Gate'
    New-Step 'Review Queue Gate' 'candidate may be reviewed later' 'review criteria are visible' 'review is implied only' 'review list' 'Birth Receipt Gate'
    New-Step 'Birth Receipt Gate' 'birth cycle closes' 'receipt records born, parked, blocked, deferred' 'birth leaves no trace' 'birth receipt' 'No-Birth-Run Gate'
    New-Step 'No-Birth-Run Gate' 'birth room exists in run 2' 'birth room does not run new gates' 'birth becomes execution' 'no-run status' 'R005'
    New-Step 'Return Gate' 'birth ring closes' 'next ring is source harvest' 'birth floats without source pass' 'R005 pointer' 'R005'
)

$sourceHarvestSteps = @(
    New-Step 'Local Library Harvest Gate' 'run 2 needs more material' 'BRAIN_LEARNING, templates, TODOs, transcripts, and research packets are scanned by filename and selected snippets' 'only outside research drives run 2' 'rg output, source ledger' 'Title Translation Gate'
    New-Step 'Title Translation Gate' 'file titles become concepts' 'titles are normalized into source concepts without becoming active law' 'filename becomes authority' 'concept ledger' 'Phase Classifier Gate'
    New-Step 'Phase Classifier Gate' 'concept needs order' 'phase is assigned by source title and known lane' 'concept order is random' 'phase field' 'Lens Expansion Gate'
    New-Step 'Lens Expansion Gate' 'concept can produce multiple rings' 'lenses create distinct jobs: intake, placement, proof, recursion, drift, tool, boundary, handoff' 'lens repeats same gate with new name only' 'lens field' 'Dedup Gate'
    New-Step 'Dedup Gate' 'same title appears twice' 'duplicate concept title is watched or deduped' 'duplicate creates authority collision' 'seen concept map' 'Outside Source Split Gate'
    New-Step 'Outside Source Split Gate' 'web sources enter' 'scientific and promotional sources are separated' 'all web sources get same proof weight' 'source type field' 'Transcript Ore Gate'
    New-Step 'Transcript Ore Gate' 'transcripts enter' 'transcripts are source ore, not instructions' 'transcript language becomes command' 'transcript receipt' 'Research Ledger Gate'
    New-Step 'Research Ledger Gate' 'web and local signals are combined' 'ledger records source signal and clean translation' 'research becomes hidden' 'RUN2_SOURCE_EXPANSION_LEDGER' 'Gate Ring Builder Gate'
    New-Step 'Gate Ring Builder Gate' 'source concepts are enough' 'builder creates target count from ordered concept/lens pairs' 'builder inflates count without source basis' 'source concept count' 'No-Run Builder Gate'
    New-Step 'No-Run Builder Gate' 'script is executed' 'script writes candidate artifacts only' 'script executes gates' 'script output, receipt' 'Hash Builder Gate'
    New-Step 'Hash Builder Gate' 'artifacts are generated' 'hashes are recorded after build' 'hashes are stale or absent' 'post hash manifest' 'ASCII Gate'
    New-Step 'ASCII Gate' 'artifact text is written' 'ASCII scan is clean or exceptions are named' 'encoding drift hides in files' 'rg non-ASCII scan' 'Root Gate'
    New-Step 'Root Gate' 'workspace root might contain loose files' 'root check is performed and findings reported' 'root drops ignored' 'root listing' 'Git Non-Save Gate'
    New-Step 'Git Non-Save Gate' 'new files exist' 'no git action is performed' 'new files are committed despite user instruction' 'git status' 'Talk Stop Gate'
    New-Step 'Talk Stop Gate' 'source harvest closes' 'stop before active use if serious decision appears' 'harvest runs into promotion' 'receipt' 'Return Gate'
    New-Step 'Return Gate' 'source harvest closes' 'next dynamic source-derived rings begin' 'source harvest becomes endless' 'R006 pointer' 'R006'
    New-Step 'Coverage Gate' 'source harvest claims coverage' 'coverage is source-derived and count-verified' 'coverage is vibe' 'count proof' 'R006'
)

$enoughSteps = @(
    New-Step 'Enoughness Question Gate' 'more gates may be possible' 'answer is routed to missing failure modes and missing source signals' 'assistant decides from taste' 'coverage ledger' 'Missing Failure Mode Gate'
    New-Step 'Missing Failure Mode Gate' 'more gates are considered' 'new gates need uncovered failure mode' 'duplicates are born from pressure only' 'failure-mode list' 'Missing Source Signal Gate'
    New-Step 'Missing Source Signal Gate' 'research may continue' 'new source signal is required for another expansion' 'search loops with no new signal' 'source ledger' 'Saturation Gate'
    New-Step 'Saturation Gate' 'coverage looks broad' 'saturation is measured by phases and source families' 'large count hides missing lane' 'phase table' 'Bloat Risk Gate'
    New-Step 'Bloat Risk Gate' 'ring is large' 'bloat risk is named but no reducer runs' 'bloat panic triggers consolidation' 'reduction lock' 'Thin Ring Risk Gate'
    New-Step 'Thin Ring Risk Gate' 'ring may still miss cases' 'thinness risk is named by uncovered phase' 'size is treated as completeness' 'coverage table' 'Research Stop Gate'
    New-Step 'Research Stop Gate' 'no new signal appears' 'stop and report residual uncertainty' 'search never ends' 'research notes' 'Birth Referral Gate'
    New-Step 'Birth Referral Gate' 'future gates may be needed' 'future gaps go to soft birth queue' 'possibility becomes active task' 'birth room' 'Consolidator Delay Gate'
    New-Step 'Consolidator Delay Gate' 'overlap is visible' 'overlap waits for final locked consolidator' 'overlap is eaten now' 'R600' 'Serious Decision Gate'
    New-Step 'Serious Decision Gate' 'next move would run, reduce, or promote' 'stop for user talk' 'assistant decides serious move alone' 'receipt next action' 'No Best Guess Gate'
    New-Step 'No Best Guess Gate' 'user wants gates to decide' 'gates decide later in approved run, not during build' 'assistant ranks by preference' 'no-run status' 'Proof Of Fatness Gate'
    New-Step 'Proof Of Fatness Gate' 'ring size matters' 'count is mechanically verified' 'scale is claimed without count' 'CSV count' 'Coverage Return Gate'
    New-Step 'Coverage Return Gate' 'coverage closes' 'return to final boundary checks' 'coverage loops forever' 'next pointer' 'Dirty Import Final Gate'
    New-Step 'Dirty Import Final Gate' 'source stack is wide' 'dirty import blocks are repeated at end' 'wide source stack leaks bad logic' 'blocked-use ledger' 'Hash Close Gate'
    New-Step 'Hash Close Gate' 'enoughness closes' 'hash and receipt remain' 'close has no proof' 'hash manifest' 'Talk Stop Gate'
    New-Step 'Talk Stop Gate' 'enoughness closes' 'stop before run or reduction' 'system keeps moving' 'receipt next action' 'R596'
    New-Step 'Return Gate' 'enoughness closes' 'next ring is final dirty import guard' 'enoughness is last word' 'R596 pointer' 'R596'
)

$finalSteps = @(
    New-Step 'Final Judge Status Gate' 'run 2 claims done' 'done means generated, ordered, counted, hashed, and not run' 'done means active or applied' 'receipt, count, hash' 'Support Boundary Gate'
    New-Step 'Support Boundary Gate' 'artifact is useful' 'artifact remains support-only' 'support becomes doctrine' 'path, status' 'No Git Save Gate'
    New-Step 'No Git Save Gate' 'user says no git for now' 'no staging, commit, or push occurs' 'assistant saves to git anyway' 'git status' 'Source Ledger Gate'
    New-Step 'Source Ledger Gate' 'source claims are included' 'ledger separates local, self-source, and scientific signals' 'all sources get same authority' 'ledger' 'Chase Boundary Gate'
    New-Step 'Chase Boundary Gate' 'Chase/NCI concepts appear' 'systems translation only, no human manipulation scripts' 'covert influence instructions enter' 'blocked-use line' 'Hypnosis Boundary Gate'
    New-Step 'Hypnosis Boundary Gate' 'hypnosis concepts appear' 'attention/state-fit analogy with proof active' 'mystique or therapy claim enters' 'APA/PubMed/PMC ledger' 'Feynman Boundary Gate'
    New-Step 'Feynman Boundary Gate' 'Feynman concepts appear' 'analogy stays analogy unless proof applies' 'physics metaphor becomes proof' 'research packet' 'Transcript Boundary Gate'
    New-Step 'Transcript Boundary Gate' 'transcripts are used' 'transcripts stay source ore' 'transcripts become instructions' 'receipt paths' 'No-Run Final Gate'
    New-Step 'No-Run Final Gate' 'final judge sees rows' 'no gate cycle was run' 'verification is confused with execution' 'script output' 'Hash Final Gate'
    New-Step 'Hash Final Gate' 'files are complete' 'hashes are recorded' 'integrity assumed' 'hash manifest' 'Root Clean Gate'
    New-Step 'Root Clean Gate' 'root may contain loose files' 'root check is reported' 'root ignored' 'root listing' 'ASCII Gate'
    New-Step 'ASCII Gate' 'files are written' 'ASCII scan is clean or exceptions named' 'hidden encoding drift enters' 'rg scan' 'Repo Status Gate'
    New-Step 'Repo Status Gate' 'worktree is dirty' 'dirty state is reported without reverting unrelated user work' 'assistant reverts user changes' 'git status' 'Count Gate'
    New-Step 'Count Gate' 'large ring is claimed' 'exact count and first/last IDs are verified' 'approximate count' 'CSV import count' 'Order First Gate'
    New-Step 'Order First Gate' 'order is verified' 'first gate is ORDER Gate' 'ORDER is buried' 'first row check' 'Consolidator Last Gate'
    New-Step 'Consolidator Last Gate' 'consolidator placement is verified' 'final ring is locked CONSOLIDATOR' 'consolidator early or unlocked' 'last ring check' 'Receipt Close Gate'
    New-Step 'Receipt Close Gate' 'final judge closes' 'receipt points to talk before run, reduce, promote, or rewrite' 'close implies automatic next action' 'receipt' 'R600'
)

$consolidatorSteps = @(
    New-Step 'CONSOLIDATOR Locked End Gate' 'all candidate gates are generated and verified' 'CONSOLIDATOR is final, locked, and not run' 'CONSOLIDATOR runs early or eats gates' 'R600, status, receipt' 'Evidence-First Packing Gate'
    New-Step 'Evidence-First Packing Gate' 'overlap exists' 'future consolidation requires repeated evidence' 'one similarity triggers pack' 'repeat ledger, approval' 'Keep Separate Gate'
    New-Step 'Keep Separate Gate' 'related gates have different jobs' 'future run may keep separate with reason' 'useful difference is flattened' 'job test' 'Move Logic Gate'
    New-Step 'Move Logic Gate' 'logic belongs under another parent' 'future run may move logic without moving authority' 'authority moves silently' 'parent, relation' 'Pack Together Gate'
    New-Step 'Pack Together Gate' 'three repeated signals show shared parent' 'future run may pack with seams preserved' 'packing hides source or proof' 'three-signal count' 'Park Gate'
    New-Step 'Park Gate' 'gate is useful but not ready' 'future run may park with trigger' 'future idea becomes active weight' 'parking path' 'Reject Gate'
    New-Step 'Reject Gate' 'gate is duplicate fog or dirty bloat' 'future run may reject active use while retaining evidence' 'bad duplicate stays active' 'rejection reason' 'Watch Again Gate'
    New-Step 'Watch Again Gate' 'only one signal exists' 'future run watches without promotion' 'single signal becomes rule' 'watch note' 'Three Signal Gate'
    New-Step 'Three Signal Gate' 'consolidation signal repeats' 'one watch, two likely pattern, three candidate pack' 'repeat count skipped' 'three-loop ledger' 'Risk If Merged Gate'
    New-Step 'Risk If Merged Gate' 'packing could erase structure' 'risk of flattening, authority bleed, or proof loss is named' 'merge risk invisible' 'risk column' 'Risk If Separate Gate'
    New-Step 'Risk If Separate Gate' 'keeping separate could create clutter' 'separation risk is named' 'separation risk ignored' 'bloat note' 'No Rewrite Gate'
    New-Step 'No Rewrite Gate' 'consolidation looks useful' 'no active guide rewrite from this artifact' 'trial becomes doctrine' 'git diff, status' 'No Delete Gate'
    New-Step 'No Delete Gate' 'redundant gates appear' 'no deletion happens in this build' 'fresh gates removed before review' 'static CSV' 'No Promotion Gate'
    New-Step 'No Promotion Gate' 'strong gates appear' 'promotion requires future user-approved pass' 'candidate becomes active doctrine' 'ACTIVE_ANCHOR' 'Future Approval Gate'
    New-Step 'Future Approval Gate' 'someone wants consolidation later' 'target, reducer lock, and approval are named first' 'consolidation starts implicitly' 'future checklist' 'End Receipt Gate'
    New-Step 'End Receipt Gate' 'CONSOLIDATOR closes the ring' 'receipt says final ring locked and no reducer ran' 'end state ambiguous' 'receipt' 'Clean Stop Gate'
    New-Step 'Clean Stop Gate' 'final ring closes' 'system stops before run, reduce, promote, or rewrite' 'ring continues past end' 'final next action' 'clean stop'
)

$concepts = New-Object System.Collections.Generic.List[object]
$script:SeenConcepts = @{}

$manualConcepts = @(
    @('Hypnotic Suggestion Theory Review','web: PubMed 39032268','prominent theories, prediction, expectation, agency, and response-set logic','Hypnosis Systems'),
    @('Hypnosis Biopsychosocial Mechanism','web: PMC 4220267','biological, psychological, and social factors as multi-factor state gates','Hypnosis Systems'),
    @('Hypnosis Functional Brain Changes','web: PMC 8773773','ACC, DLPFC, insula, salience, executive, and default-mode connectivity as routing analogy','Hypnosis Systems'),
    @('Resting Hypnosis Triple Network','web: PMC 10886478','DMN, salience, executive control, and sensorimotor networks as state-route vocabulary','Hypnosis Systems'),
    @('New Directions Hypnosis Research','web: PMC 5635845','suggestion-specific mechanisms and suggestibility measurement as proof guardrails','Hypnosis Systems'),
    @('Neuro Hypnotism Design Guard','web: PMC 3528837','induction, controls, hypnotizability, and attention/disattention as method checks','Hypnosis Systems'),
    @('Predictive Processing And Sensory Precision','web: PMC 8416526','prediction, precision, oddball, and mismatch logic as signal-weight gates','Hypnosis Systems'),
    @('Default Mode Review','web: PMC 10524518','self-reference, mind wandering, memory, language, and semantic memory as internal narration gates','Hypnosis Systems'),
    @('NCI Four Level Roadmap','web: nci.university roadmap','observer, profiler, scientist, author/operator as artifact maturity ladder','Chase Systems'),
    @('NCI Needs Map Signal','web: NCI resources and Chase corpus','needs map becomes system requirement and missing-satisfaction detector','Chase Systems'),
    @('NCI Decision Map Signal','web: NCI resources and Chase corpus','decision map becomes choice point and proof-exit routing','Chase Systems'),
    @('NCI Behavior Table Signal','web: NCI resources and BTE references','behavior table becomes artifact-state classifier only','Chase Systems'),
    @('NCI Behavior Compass Signal','web: NCI resources and Chase corpus','compass becomes route orientation under pressure','Chase Systems'),
    @('NCI Authority Hazard Signal','web: NCI promotional wording and Ellipsis warning language','authority and influence language becomes dirty import boundary','Chase Systems'),
    @('Feynman Sum Over Histories','Feynman research packet','many possible routes contribute, but proof selects path family','Feynman Systems'),
    @('Feynman Diagram Bookkeeping','Feynman research packet','diagrams as accounting tools for legal interactions','Feynman Systems'),
    @('Feynman Renormalization Cutoff','Feynman research packet','scale boundary and cutoff before broad claims','Feynman Systems'),
    @('Feynman Error Honesty','Feynman research packet','uncertainty, approximation, and error bars before confidence','Feynman Systems'),
    @('Feynman Cargo Cult Guard','Feynman cargo cult science','form is not function and ritual is not proof','Feynman Systems'),
    @('System Signal Syntax','local whale transcript Hm9ADZ28Wgo','parse repeated units before claiming meaning','Words Signals'),
    @('Meaning Not Cause Boundary','local w4HWSqnnzEo transcript','meaning relation is separated from causal proof','Words Signals'),
    @('Narrator Priority Board','local Wn-qgHg5JhE transcript','narration, perspective, and priority become status board','Words Signals'),
    @('Script Disruption Route Breaker','local Wn-qgHg5JhE transcript','autopilot scripts are interrupted with bounded changes','Recursion'),
    @('Future State Artifact','local Wn-qgHg5JhE transcript','future outcome becomes visible system object','Lifecycle'),
    @('Self Efficacy Mastery Proof','local ZtOxCJqEHjY notes','confidence follows mastery evidence','Proof'),
    @('Ambiguity Tolerance Holder','local ZtOxCJqEHjY notes','uncertainty is held in a lane instead of becoming loop material','Lifecycle'),
    @('Myth To Mechanism Translator','local 6LP3n9V7H_8 transcript','strange language is translated to mechanism before use','Words Signals'),
    @('Compact Perception Action','local Dgbci0GC1vk transcript','small systems get focused perception-action gates','Tool Substrate'),
    @('Multi Gate Same Object Failure','user update during run 2','when awareness routing, parking, alarm friction, and movement fidelity fail around one object, the shared object is the signal','Gate Ecology'),
    @('House Stronger Than Assistant Movement Discipline','user update during run 2','house structure may be stronger than the assistant current movement discipline and should constrain motion','Authority Frame'),
    @('Movement Fidelity Discipline Gap','user update during run 2','assistant motion must match house lanes, not merely recognize them','Lifecycle'),
    @('Alarm Friction Parking Awareness Cluster','user update during run 2','alarm friction, parking, and awareness routing are treated as one cluster when they converge on one object','Gate Ecology')
)
foreach ($m in $manualConcepts) { Add-Concept $concepts $m[0] $m[1] $m[2] $m[3] }

$sourceGlobs = @(
    'BRAIN_LEARNING\*.md',
    'BRAIN_LEARNING\RECURSIVE_METHODS\*.md',
    'COMMAND_CENTER\TEMPLATES\*.md',
    'COMMAND_CENTER\TODO\*.md',
    'HOUSE_WORK\TODO\*.md',
    'SOURCE_TRANSFER\MD_INCOMING\*.md',
    'RESEARCH_PACKETS\FEYNMAN_CHASE_HYPNOSIS_SYSTEMS_WASH_20260524\*.md',
    'RESEARCH_PACKETS\FEYNMAN_20260524_DEEP_WASH\*.md',
    'YT_TRANSCRIPTS\*\SOURCE_INTAKE_NOTE*.txt',
    'YT_TRANSCRIPTS\*\ODD_SOURCE_INTAKE_NOTE*.txt',
    'YT_TRANSCRIPTS\*\TRANSCRIPT_FULL_RECEIPT*.txt'
)
foreach ($glob in $sourceGlobs) {
    Get-ChildItem -Path (Join-Path $RepoRoot $glob) -File -ErrorAction SilentlyContinue | Sort-Object FullName | ForEach-Object {
        $title = Normalize-Title $_.Name
        $rel = $_.FullName.Substring($RepoRoot.Path.Length + 1)
        $phase = Phase-For $title
        Add-Concept $concepts $title $rel "source-derived concept from local file title and lane: $rel" $phase
    }
}

$lenses = @(
    [ordered]@{ Name = 'Intake'; Focus = 'first contact, trigger naming, and source type'; Clean = 'enters with target, authority, and source visible'; Fail = 'enters as loose pressure' },
    [ordered]@{ Name = 'Placement'; Focus = 'home lane, phase, order, and neighbor fit'; Clean = 'lands in the right lane with visible neighbors'; Fail = 'lands by vibe or prestige' },
    [ordered]@{ Name = 'Proof'; Focus = 'evidence burden, disproof, and status honesty'; Clean = 'claims touch proof or park uncertainty'; Fail = 'confidence becomes proof' },
    [ordered]@{ Name = 'Recursion'; Focus = 'return target, next spin, stop condition, and drift watch'; Clean = 'loops without losing object or authority'; Fail = 'creates endless active weight' },
    [ordered]@{ Name = 'Drift Defense'; Focus = 'variation, dirty import, and neighbor damage'; Clean = 'survives variation and blocks contamination'; Fail = 'mutates silently' },
    [ordered]@{ Name = 'Tool Substrate'; Focus = 'right tool, method, and evidence substrate'; Clean = 'tool matches phenomenon'; Fail = 'tool size substitutes for fit' },
    [ordered]@{ Name = 'Human Boundary'; Focus = 'systems-only translation and non-coercion'; Clean = 'human-behavior logic stays defensive and artifact-bound'; Fail = 'people are profiled or manipulated' },
    [ordered]@{ Name = 'Handoff'; Focus = 'receipt, parking, future approval, and clean stop'; Clean = 'leaves next state and no hidden action'; Fail = 'leaves untracked active pressure' }
)

$rings = New-Object System.Collections.Generic.List[object]
$rings.Add((New-Ring 'ORDER And Run 2 Sequence Proof' 'Front Control' 'Keystone' 'true clean order before the second expansion grows' 'user request, run-1 receipt, ACTIVE_ANCHOR, no-git instruction' 'ORDER remains first and controls the whole run-2 build' $orderSteps $true))
$rings.Add((New-Ring 'No-Run And Reduction Lock Control' 'Front Control' 'Keystone' 'run means build-only; reducers, consolidator, deletion, promotion, and git save stay asleep' 'user instruction, run-1 no-run receipt' 'candidate files are generated without executing gate cycles' $noRunSteps $true))
$rings.Add((New-Ring 'Recursion Spine Run 2' 'Front Control' 'Keystone' 'run 2 inherits run 1 without giving repetition authority' 'recursive core architecture, previous expanded ring' 'recursion grows with return, proof refresh, and stop behavior' $recursionSteps $true))
$rings.Add((New-Ring 'Soft Gate Birth Room Run 2' 'Front Control' 'Keystone' 'side room births more candidates from source sparks and missing failure modes' 'gate birth room run 1 plus new source stack' 'birth stays soft, parked, and non-executing' $birthSteps $true))
$rings.Add((New-Ring 'Source Harvest And Concept Expansion' 'Front Control' 'Keystone' 'local and web source harvest for more gates' 'BRAIN_LEARNING, templates, TODOs, transcripts, research packets, web research' 'run 2 grows from source-derived concepts, not count pressure alone' $sourceHarvestSteps $true))

$dynamicTarget = $TargetRings - 11
$orderedConcepts = $concepts | Sort-Object Phase, Title
$dynamic = New-Object System.Collections.Generic.List[object]
foreach ($concept in $orderedConcepts) {
    foreach ($lens in $lenses) {
        if ($dynamic.Count -ge $dynamicTarget) { break }
        $title = "$($concept.Title) - $($lens.Name)"
        $focus = "$($concept.Focus); lens: $($lens.Focus)"
        $source = "$($concept.Source); lens risk: $($lens.Fail)"
        $clean = "Source clean result: $($concept.Focus). Lens clean result: $($lens.Clean)."
        $dynamic.Add((New-Ring $title $concept.Phase $lens.Name $focus $source $clean $baseSteps $false))
    }
    if ($dynamic.Count -ge $dynamicTarget) { break }
}
if ($dynamic.Count -lt $dynamicTarget) {
    throw "Not enough dynamic rings. Needed $dynamicTarget, got $($dynamic.Count)."
}
foreach ($ring in $dynamic) { $rings.Add($ring) }

$rings.Add((New-Ring 'Enoughness And Missing Gate Decision Run 2' 'End Control' 'Keystone' 'determine whether more gates need another source signal or missing-failure proof' 'run-2 concept coverage and user instruction that gates decide later' 'more growth requires source signal or missing failure mode' $enoughSteps $true))
$rings.Add((New-Ring 'Dirty Import And Human Boundary Final Guard Run 2' 'End Control' 'Guardrail' 'block coercion, mystique, therapy claims, source authority bleed, and privacy leakage' 'Chase/NCI risk, hypnosis research, ACTIVE_ANCHOR' 'wide source stack stays systems-only' $baseSteps $true))
$rings.Add((New-Ring 'No Git Save And Workspace Data Hold' 'End Control' 'Guardrail' 'save data in workspace artifacts and thread summary without git action' 'latest user instruction' 'data is on it and carried here, but not committed' $baseSteps $true))
$rings.Add((New-Ring 'Final Judge Pre-Receipt Verification Run 2' 'End Control' 'Final Judge' 'count, order, no-run, root, ASCII, hash, and repo status checks' 'verification commands and receipts' 'done means generated, ordered, counted, hashed, and not run' $finalSteps $true))
$rings.Add((New-Ring 'User Handoff And Talk Stop Run 2' 'End Control' 'Handoff' 'stop before active run, reduction, consolidation, promotion, or rewrite' 'user request and no-run boundary' 'next action is discussion, not automatic execution' $baseSteps $true))
$rings.Add((New-Ring 'CONSOLIDATOR Locked End Ring Run 2' 'End Control' 'Consolidator Locked' 'final locked consolidator with pack, park, reject, watch, and merge logic asleep' 'CONSOLIDATOR trial watch, run-1 placement, user warning not to let it eat gates' 'CONSOLIDATOR is present, final, locked, and not run' $consolidatorSteps $true))

if ($rings.Count -ne $TargetRings) {
    throw "Ring count mismatch. Expected $TargetRings, got $($rings.Count)."
}

$rows = New-Object System.Collections.Generic.List[object]
$n = 0
for ($r = 0; $r -lt $rings.Count; $r++) {
    $ring = $rings[$r]
    $ringCode = 'R{0:D3}' -f ($r + 1)
    for ($s = 0; $s -lt $ring.Steps.Count; $s++) {
        $step = $ring.Steps[$s]
        $n++
        $id = 'CS-EGR2-{0:D5}' -f $n
        $statusRow = if ($ring.Locked) { 'candidate support gate; NO-RUN; reduction-locked; not active doctrine; no git save' } else { 'candidate support gate; NO-RUN; not active doctrine; no git save' }
        $rows.Add([pscustomobject][ordered]@{
            ID = $id
            Order = $n
            Ring = $ringCode
            Phase = $ring.Phase
            Lens = $ring.Lens
            RingTitle = $ring.Title
            Step = '{0:D2}' -f ($s + 1)
            Gate = $step.Name
            Focus = $ring.Focus
            SourceBasis = $ring.Source
            Trigger = $step.Trigger
            PassCondition = "$($step.Pass). Ring clean result: $($ring.Clean)"
            FailCondition = $step.Fail
            Evidence = $step.Evidence
            Next = $step.Next
            Status = $statusRow
        })
    }
}
if ($rows.Count -ne $TargetGates) {
    throw "Gate count mismatch. Expected $TargetGates, got $($rows.Count)."
}

$csvPath = Join-Path $Root 'MASTER_GATE_RING_10200_RUN2_ORDERED_CANDIDATE.csv'
$mdPath = Join-Path $Root 'MASTER_GATE_RING_10200_RUN2_ORDERED_CANDIDATE.md'
$rows | Export-Csv -NoTypeInformation -Encoding UTF8 $csvPath

$md = New-Object System.Collections.Generic.List[string]
$md.Add('# Master Expanded Gate Ring Run 2 - 10200 Ordered Gates')
$md.Add('')
$md.Add("Status: $Status")
$md.Add("Date: $Date")
$md.Add('')
$md.Add('Boundary: This is a support-only candidate artifact. It does not run gates, reduce gates, wake CONSOLIDATOR, promote doctrine, edit ACTIVE_GUIDES, rewrite CURRENT_TRUTH_INDEX, stage Git, commit, or push.')
$md.Add('')
$md.Add('Core run-2 order:')
$md.Add('')
$md.Add('`ORDER -> NO-RUN LOCK -> RECURSION -> SOFT BIRTH -> SOURCE HARVEST -> SOURCE-DERIVED GATE RINGS -> ENOUGHNESS -> FINAL JUDGE -> CONSOLIDATOR LOCKED END`')
$md.Add('')
$md.Add('Count proof:')
$md.Add('')
$md.Add("- Rings: $($rings.Count)")
$md.Add('- Gates per ring: 17')
$md.Add("- Total gates: $($rows.Count)")
$md.Add('')
$md.Add('Critical controls:')
$md.Add('')
$md.Add('- ORDER Gate: CS-EGR2-00001')
$md.Add('- No-run and reduction lock: R002')
$md.Add('- Recursion spine: R003')
$md.Add('- Soft gate birth room: R004')
$md.Add('- Source harvest and concept expansion: R005')
$md.Add('- Enoughness decision: R595')
$md.Add('- No Git save boundary: R597')
$md.Add('- CONSOLIDATOR locked end: R600, gates CS-EGR2-10184 through CS-EGR2-10200')
$md.Add('')
$md.Add('## Ring Order')
$md.Add('')
$md.Add('| Ring | Phase | Lens | Title | Focus | Source basis | Locked |')
$md.Add('|---|---|---|---|---|---|---|')
for ($i = 0; $i -lt $rings.Count; $i++) {
    $code = 'R{0:D3}' -f ($i + 1)
    $ring = $rings[$i]
    $md.Add("| $code | $(Clean-Cell $ring.Phase) | $(Clean-Cell $ring.Lens) | $(Clean-Cell $ring.Title) | $(Clean-Cell $ring.Focus) | $(Clean-Cell $ring.Source) | $($ring.Locked) |")
}
$md.Add('')
$md.Add('## Gate Ledger')
$md.Add('')
$md.Add('| ID | Ring | Step | Gate | Trigger | Pass condition | Evidence | Next | Status |')
$md.Add('|---|---|---:|---|---|---|---|---|---|')
foreach ($row in $rows) {
    $md.Add("| $($row.ID) | $($row.Ring) $(Clean-Cell $row.RingTitle) | $($row.Step) | $(Clean-Cell $row.Gate) | $(Clean-Cell $row.Trigger) | $(Clean-Cell $row.PassCondition) | $(Clean-Cell $row.Evidence) | $(Clean-Cell $row.Next) | $(Clean-Cell $row.Status) |")
}
$md | Set-Content -Encoding UTF8 -LiteralPath $mdPath

$ledger = @(
    '# Run 2 Source Expansion Ledger'
    ''
    'Status: SOURCE LEDGER / RUN 2 / SYSTEMS TRANSLATION ONLY / NO-RUN / NO GIT SAVE'
    "Date: $Date"
    ''
    '## Source Families'
    ''
    '- Local house rules: BRAIN_LEARNING and BRAIN_LEARNING/RECURSIVE_METHODS.'
    '- Local templates and TODOs: COMMAND_CENTER/TEMPLATES, COMMAND_CENTER/TODO, HOUSE_WORK/TODO.'
    '- Source transfer and transcripts: SOURCE_TRANSFER/MD_INCOMING and YT_TRANSCRIPTS receipts/intake notes.'
    '- Research packets: prior Feynman and combined Feynman/Chase/hypnosis packets.'
    '- Web source signals: NCI roadmap, APA hypnosis overview, PubMed/PMC/Springer hypnosis theory and mechanism reviews.'
    ''
    '## New Run 2 Logic Added'
    ''
    '- House-native rules now drive most dynamic rings.'
    '- Web hypnosis logic added predictive processing, suggestion-specific mechanism, hypnotizability measurement, triple-network, and biopsychosocial guards.'
    '- Chase/NCI logic is kept as artifact maturity, needs/decision/classification/compass routing, and hazard boundary only.'
    '- Gate birth remains soft.'
    '- CONSOLIDATOR remains final and asleep.'
    '- No Git save, commit, or push is part of this run.'
    ''
    '## Web Sources Used'
    ''
    '- NCI official roadmap: https://nci.university/roadmapnci'
    '- APA hypnosis overview: https://www.apa.org/topics/hypnosis/media'
    '- How hypnotic suggestions work: https://pubmed.ncbi.nlm.nih.gov/39032268/'
    '- Mechanisms of hypnosis: https://pmc.ncbi.nlm.nih.gov/articles/PMC4220267/'
    '- Functional changes in brain activity using hypnosis: https://pmc.ncbi.nlm.nih.gov/articles/PMC8773773/'
    '- Brain functional correlates of resting hypnosis and hypnotizability: https://pmc.ncbi.nlm.nih.gov/articles/PMC10886478/'
    '- New directions in hypnosis research: https://pmc.ncbi.nlm.nih.gov/articles/PMC5635845/'
    '- Neuro-Hypnotism: https://pmc.ncbi.nlm.nih.gov/articles/PMC3528837/'
    '- Automatic sensory predictions review: https://pmc.ncbi.nlm.nih.gov/articles/PMC8416526/'
    '- Default mode network review: https://pmc.ncbi.nlm.nih.gov/articles/PMC10524518/'
    ''
    '## Clean Translation'
    ''
    '`source sparks -> phase order -> lens expansion -> proof burden -> recursion return -> birth parking -> no-run lock -> final locked consolidator`'
    ''
    "Concepts harvested: $($concepts.Count)"
    "Dynamic rings used: $($dynamic.Count)"
) 
$ledger | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Root 'RUN2_SOURCE_EXPANSION_LEDGER_20260524.md')

$birth = @(
    '# Gate Birth Room Run 2 - Soft Side Room'
    ''
    'Status: SOFT SIDE ROOM / RUN 2 / CANDIDATE BIRTH ONLY / NO-RUN / NO GIT SAVE'
    "Date: $Date"
    ''
    '## Purpose'
    ''
    'This room receives missing-gate sparks from the 10200-gate run. It does not run, promote, consolidate, delete, or rewrite gates.'
    ''
    '## Birth Formula'
    ''
    'spark -> need claim -> source family -> target object -> trigger -> pass -> fail -> evidence -> dirty import block -> neighbor slot -> recursion fit -> reduction lock -> soft ID -> parking -> review -> receipt'
    ''
    '## Run 2 Soft Queue'
    ''
    '| Soft ID | Candidate | Why it exists | Status |'
    '|---|---|---|---|'
    '| GB2-SOFT-001 | Source Family Weight Gate | separates house-native, transcript, self-source, and scientific source weight | parked soft |'
    '| GB2-SOFT-002 | Hypnotizability Measurement Analogy Gate | prevents state claims without measuring readiness/state fit | parked soft |'
    '| GB2-SOFT-003 | Prediction Precision Gate | checks whether a signal is evidence or over-weighted expectation | parked soft |'
    '| GB2-SOFT-004 | Suggestion Specificity Gate | maps instruction to exact target and expected mechanism | parked soft |'
    '| GB2-SOFT-005 | Artifact Maturity Ladder Gate | turns observer/profiler/scientist/operator into artifact maturity only | parked soft |'
    '| GB2-SOFT-006 | No Git Save Drift Gate | keeps workspace artifact save separate from git save | parked soft |'
    '| GB2-SOFT-007 | House Native Priority Gate | prevents outside research from outranking active house state | parked soft |'
    '| GB2-SOFT-008 | Repetition Is Not Authority Gate | keeps recursive count from becoming law | parked soft |'
)
$birth | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Root 'GATE_BIRTH_ROOM_SOFT_RUN2_20260524.md')

$orderDoc = @(
    '# Order Proof And Reduction Lock Run 2'
    ''
    'Status: ORDER PROOF / RUN 2 / NO-RUN / NO GIT SAVE'
    "Date: $Date"
    ''
    '## Why This Order Is Clean'
    ''
    'Run 2 starts with ORDER, then no-run/reduction lock, then recursion, then soft birth, then source harvest. Only after those controls does it expand source-derived concept rings.'
    ''
    'The end sequence is enoughness, dirty import guard, no-git-save boundary, final judge, user handoff, and CONSOLIDATOR locked end.'
    ''
    'CONSOLIDATOR is last because it can pack, park, reject, watch, or merge. It is therefore reduction-capable and remains asleep.'
    ''
    '## Important Positions'
    ''
    '- ORDER first: CS-EGR2-00001.'
    '- Reduction lock: R002.'
    '- Recursion spine: R003.'
    '- Soft birth: R004.'
    '- Source harvest: R005.'
    '- Enoughness: R595.'
    '- No Git save boundary: R597.'
    '- CONSOLIDATOR locked end: R600.'
)
$orderDoc | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Root 'ORDER_PROOF_AND_REDUCTION_LOCK_RUN2.md')

$memory = @(
    '# Run 2 Working Memory Card'
    ''
    'Status: THREAD CARRY CARD / WORKSPACE DATA / NO GIT SAVE'
    "Date: $Date"
    ''
    '## Carry'
    ''
    '- Run 1 remains intact at HOUSE_WORK/GATE_RINGS/MASTER_EXPANDED_GATE_RING_20260524.'
    '- Run 2 creates a 10200-gate candidate ring.'
    '- No gate cycle was run.'
    '- CONSOLIDATOR is final and locked.'
    '- No Git save, commit, or push was performed.'
    '- Data is saved in this run-2 folder and carried in the final response.'
)
$memory | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Root 'RUN2_WORKING_MEMORY_CARD_20260524.md')

$receipt = @(
    '# Receipt - Master Expanded Gate Ring Run 2'
    ''
    'Status: BUILD RECEIPT / RUN 2 / NO-RUN / NO GIT SAVE / NOT ACTIVE DOCTRINE'
    "Date: $Date"
    ''
    '## Built'
    ''
    '- MASTER_GATE_RING_10200_RUN2_ORDERED_CANDIDATE.md'
    '- MASTER_GATE_RING_10200_RUN2_ORDERED_CANDIDATE.csv'
    '- RUN2_SOURCE_EXPANSION_LEDGER_20260524.md'
    '- GATE_BIRTH_ROOM_SOFT_RUN2_20260524.md'
    '- ORDER_PROOF_AND_REDUCTION_LOCK_RUN2.md'
    '- RUN2_WORKING_MEMORY_CARD_20260524.md'
    ''
    '## Count'
    ''
    '- Rings: 600.'
    '- Gates per ring: 17.'
    '- Total gates: 10200.'
    '- First gate: CS-EGR2-00001 ORDER Gate.'
    '- Final ring: R600 CONSOLIDATOR Locked End Ring Run 2.'
    '- Final gate: CS-EGR2-10200 Clean Stop Gate.'
    ''
    '## No-Run Proof'
    ''
    'No gate cycle was run.'
    'No consolidator was run.'
    'No reducer was run.'
    'No compressor was run.'
    'No deletion was run.'
    'No promotion was run.'
    'No ACTIVE_GUIDES edit was made.'
    'No Git add, commit, or push was performed.'
    ''
    '## Next Action'
    ''
    'Stop and talk before any gate run, consolidation, promotion, reduction, active guide edit, doctrine rewrite, or Git save.'
)
$receipt | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Root 'RECEIPT_RUN2_20260524.md')

$generated = @(
    'BUILD_MASTER_EXPANDED_GATE_RING_RUN2_20260524.ps1',
    'MASTER_GATE_RING_10200_RUN2_ORDERED_CANDIDATE.csv',
    'MASTER_GATE_RING_10200_RUN2_ORDERED_CANDIDATE.md',
    'RUN2_SOURCE_EXPANSION_LEDGER_20260524.md',
    'GATE_BIRTH_ROOM_SOFT_RUN2_20260524.md',
    'ORDER_PROOF_AND_REDUCTION_LOCK_RUN2.md',
    'RUN2_WORKING_MEMORY_CARD_20260524.md',
    'RECEIPT_RUN2_20260524.md'
)
$hashDoc = New-Object System.Collections.Generic.List[string]
$hashDoc.Add('# Post Run 2 Hash Manifest')
$hashDoc.Add('')
$hashDoc.Add('Status: HASH MANIFEST / AFTER RUN 2 EXPANDED BUILD / NO GIT SAVE')
$hashDoc.Add("Date: $Date")
$hashDoc.Add('')
$hashDoc.Add('| File | SHA256 |')
$hashDoc.Add('|---|---|')
foreach ($name in $generated) {
    $path = Join-Path $Root $name
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash
    $hashDoc.Add("| $name | $hash |")
}
$hashDoc | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $Root 'POST_RUN2_HASH_MANIFEST_20260524.md')

Write-Host "Built run 2 expanded gate ring with $($rows.Count) gates across $($rings.Count) rings."
Write-Host "Concepts harvested: $($concepts.Count)"
Write-Host "First gate: $($rows[0].ID) $($rows[0].Gate)"
Write-Host "Last gate: $($rows[$rows.Count - 1].ID) $($rows[$rows.Count - 1].Gate)"
Write-Host "Consolidator ring: R600 CONSOLIDATOR Locked End Ring Run 2"
Write-Host "No gates were run. No Git save was performed."

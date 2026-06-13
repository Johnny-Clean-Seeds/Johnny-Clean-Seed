[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$TaskName,
    [string]$Language = 'unknown',
    [string]$TargetSurface = 'not-authorized-yet',
    [string]$OutputRoot = 'C:\Users\13527\Desktop\123\_SAFE_CODING_HELPER_PACKETS',
    [string]$RiskLevel = 'medium',
    [switch]$AllowProjectMutation,
    [string]$IntentionalNegativeTestName = '',
    [string]$ExpectedFailureContains = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-SafeName {
    param([string]$Text)
    $safe = ($Text -replace '[^A-Za-z0-9._-]', '_').Trim('_')
    if ([string]::IsNullOrWhiteSpace($safe)) {
        return 'SAFE_CODING_TASK'
    }
    if ($safe.Length -gt 80) {
        return $safe.Substring(0, 80)
    }
    return $safe
}

function Write-FailureReport {
    param(
        [string]$Message,
        [string]$Root
    )

    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    $failedRoot = Join-Path $Root ('SAFE_CODING_PACKET_FAILED_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
    $reportRoot = Join-Path $failedRoot 'REPORTS'
    New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

    @(
        'SAFE_CODING_HELPER_PACKET_FAILED',
        '',
        "Time: $(Get-Date -Format o)",
        "Reason: $Message",
        '',
        'DoesNotProve:',
        'No coding helper packet is clean when this file exists.'
    ) | Set-Content -LiteralPath (Join-Path $reportRoot 'FAILED.txt') -Encoding UTF8

    if (-not [string]::IsNullOrWhiteSpace($IntentionalNegativeTestName)) {
        $expected = if ([string]::IsNullOrWhiteSpace($ExpectedFailureContains)) {
            'Route should fail and save evidence.'
        } else {
            'Route should fail with text containing: ' + $ExpectedFailureContains
        }
        $matched = if ([string]::IsNullOrWhiteSpace($ExpectedFailureContains)) {
            $true
        } else {
            $Message -like ('*' + $ExpectedFailureContains + '*')
        }
        $why = if ($matched) {
            'Negative test behaved as expected and saved failure evidence.'
        } else {
            'Negative test failed, but not with expected error text; review needed.'
        }

        [PSCustomObject]@{
            Status = 'INTENTIONAL_NEGATIVE_TEST'
            SuspectedIssue = $IntentionalNegativeTestName
            Trigger = 'Intentional bad safe-coding packet input.'
            EvidenceChecked = 'TaskName validation and packet route.'
            ExpectedResult = $expected
            ActualResult = ('Route failed with: ' + $Message)
            WhyPassedFailedOrCleared = $why
            WatchNote = 'Use this row to teach future coding helpers what a clean blocked failure looks like.'
            DoesNotProve = 'Does not prove coding mutation is safe.'
        } | Export-Csv -LiteralPath (Join-Path $reportRoot 'NEGATIVE_TESTS_AND_CLEARED_SUSPECTS.csv') -NoTypeInformation -Encoding UTF8
    }
}

try {
    if ([string]::IsNullOrWhiteSpace($TaskName) -or $TaskName.Trim().Length -lt 3) {
        throw 'TASK_NAME_TOO_SMALL'
    }

    if ($AllowProjectMutation) {
        throw 'PROJECT_MUTATION_BLOCKED_BY_SAFE_CODING_SEED'
    }

    New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
    $safeName = Get-SafeName -Text $TaskName
    $packetRoot = Join-Path $OutputRoot ('SAFE_CODING_HELPER_PACKET_' + $safeName + '_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
    $reportRoot = Join-Path $packetRoot 'REPORTS'
    New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

    $packetPath = Join-Path $packetRoot 'SAFE_CODING_HELPER_PACKET.md'
    @(
        '# Safe Coding Helper Packet',
        '',
        "Created: $(Get-Date -Format o)",
        "TaskName: $TaskName",
        "Language: $Language",
        "TargetSurface: $TargetSurface",
        "RiskLevel: $RiskLevel",
        '',
        '## One Job',
        '',
        'Prepare a tiny, safe coding helper route for the named task without editing project files.',
        '',
        '## Narrow Intelligence Order',
        '',
        'Name the exact task, target surface, risk, next helper stage, proof needed, ask/block condition, and validation route before any later helper edits code.',
        '',
        '## Coding Anchor Map',
        '',
        'Use the packet reports as a small anchored map for what to pick where and when. If the map feels crowded, stop and make a clean-up/merge task instead of adding more rows.',
        '',
        '## Allowed Actions',
        '',
        '- read named context later when authorized;',
        '- propose the smallest patch shape;',
        '- suggest one tiny fixture;',
        '- name parser/lint/check commands that should run later;',
        '- record missing helper needs.',
        '',
        '## Blocked Actions',
        '',
        '- no project code edits;',
        '- no generated code execution;',
        '- no package install;',
        '- no network calls;',
        '- no deletion, move, rename, overwrite, cleanup;',
        '- no Git/GitHub commit, push, pull, fetch, branch, or PR;',
        '- no doctrine promotion;',
        '- no automation or watcher work.',
        '',
        '## Refusal And Ask Rules',
        '',
        '- ask when target files, authority, or test route are not named;',
        '- block mutation when proof is missing or the worktree is unsafe;',
        '- plan only when the task is broad, cross-module, or dependency-changing;',
        '- park helper ideas that would require network, package install, generated-code execution, or doctrine promotion.',
        '',
        '## Tiny Fixture Suggestion',
        '',
        'Use one input, one expected output, and one failure case. Keep the fixture outside active project code until explicitly authorized.',
        '',
        '## Test Ladder',
        '',
        'Prefer parser/read-only checks first, then lint/type checks, then tiny focused tests, then broader tests only when the patch surface requires them.',
        '',
        '## Proof Needed Before Mutation',
        '',
        '- exact target file(s) or module named;',
        '- current content read;',
        '- smallest patch described;',
        '- parser/lint/test route named;',
        '- rollback or containment path named;',
        '- user or route authority for mutation.',
        '',
        '## Next Clean Action',
        '',
        'Read only the named target surface and return a smallest-patch plan.',
        '',
        '## Does Not Prove',
        '',
        'This packet does not authorize edits, code execution, dependency installs, Git/GitHub work, cleanup, broad refactors, or doctrine promotion.'
    ) | Set-Content -LiteralPath $packetPath -Encoding UTF8

    [PSCustomObject]@{
        TaskName = $TaskName
        Language = $Language
        TargetSurface = $TargetSurface
        RiskLevel = $RiskLevel
        PacketPath = $packetPath
        Status = 'SAFE_CODING_HELPER_PACKET_CREATED'
        MutationAuthorized = $false
        DoesNotProve = 'Does not authorize code edits or code execution.'
    } | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_HELPER_PACKET_MANIFEST.csv') -NoTypeInformation -Encoding UTF8

    $chainRows = @(
        [PSCustomObject]@{
            Order = 1
            Stage = 'read_context_helper'
            OneJob = 'Read only the named files or folders.'
            Allowed = 'Read exact approved context.'
            Blocked = 'No edits or execution.'
            Proof = 'Paths read and remaining unknowns named.'
        },
        [PSCustomObject]@{
            Order = 2
            Stage = 'plan_patch_helper'
            OneJob = 'Describe the smallest patch without editing.'
            Allowed = 'Produce a patch plan.'
            Blocked = 'No file mutation.'
            Proof = 'Affected files and expected behavior named.'
        },
        [PSCustomObject]@{
            Order = 3
            Stage = 'fixture_helper'
            OneJob = 'Create or name one tiny fixture outside active project code.'
            Allowed = 'Fixture proposal or external packet fixture.'
            Blocked = 'No production data mutation.'
            Proof = 'One input, one expected output, one failure case.'
        },
        [PSCustomObject]@{
            Order = 4
            Stage = 'parse_lint_helper'
            OneJob = 'Run parser/lint/read-only checks when authorized.'
            Allowed = 'Read-only validation commands.'
            Blocked = 'No generated code execution unless separately authorized.'
            Proof = 'Command, exit code, and log path.'
        },
        [PSCustomObject]@{
            Order = 5
            Stage = 'apply_patch_helper'
            OneJob = 'Edit only after authority and proof.'
            Allowed = 'Smallest approved patch.'
            Blocked = 'No broad refactor or unrelated files.'
            Proof = 'Diff and changed paths.'
        },
        [PSCustomObject]@{
            Order = 6
            Stage = 'verify_helper'
            OneJob = 'Rerun exact checks and capture evidence.'
            Allowed = 'Named verification only.'
            Blocked = 'No new feature work.'
            Proof = 'Passing and failing evidence separated.'
        },
        [PSCustomObject]@{
            Order = 7
            Stage = 'receipt_helper'
            OneJob = 'Write what changed, proof, and DoesNotProve.'
            Allowed = 'Receipt/report only.'
            Blocked = 'No promotion by receipt alone.'
            Proof = 'Final report with remaining risk.'
        }
    )
    $chainRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_HELPER_CHAIN.csv') -NoTypeInformation -Encoding UTF8

    $microRouteRows = @(
        [PSCustomObject]@{ Order = 1; Step = 'task_intake'; Question = 'What is the one coding job?'; CleanOutput = 'TaskName repeated in one sentence.'; BlockWhen = 'Task is blank, bundled, or unclear.' },
        [PSCustomObject]@{ Order = 2; Step = 'surface_name'; Question = 'Which exact surface is in scope?'; CleanOutput = 'Target file/folder/module or unknown stated.'; BlockWhen = 'Target surface is guessed.' },
        [PSCustomObject]@{ Order = 3; Step = 'risk_classify'; Question = 'What can this break?'; CleanOutput = 'RiskLevel plus affected behavior.'; BlockWhen = 'Risk is ignored or minimized.' },
        [PSCustomObject]@{ Order = 4; Step = 'smallest_next_helper'; Question = 'Which narrow helper runs next?'; CleanOutput = 'One chain stage selected.'; BlockWhen = 'Multiple stages are merged without proof.' },
        [PSCustomObject]@{ Order = 5; Step = 'proof_before_action'; Question = 'What proof is needed first?'; CleanOutput = 'Read/test/log requirement named.'; BlockWhen = 'Mutation is requested before proof.' },
        [PSCustomObject]@{ Order = 6; Step = 'return_or_refuse'; Question = 'Return, ask, park, or block?'; CleanOutput = 'Decision and reason.'; BlockWhen = 'Helper silently continues through uncertainty.' }
    )
    $microRouteRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_MICRO_ROUTE.csv') -NoTypeInformation -Encoding UTF8

    $riskGateRows = @(
        [PSCustomObject]@{ Gate = 'mutation_authority'; BlocksWhen = 'User or route authority has not approved edits.'; EvidenceNeeded = 'Explicit current instruction or approved route.'; NextSafeAction = 'Return a plan-only packet.' },
        [PSCustomObject]@{ Gate = 'target_surface'; BlocksWhen = 'Files/modules are unnamed or guessed.'; EvidenceNeeded = 'Exact path or bounded folder.'; NextSafeAction = 'Ask or read only named context.' },
        [PSCustomObject]@{ Gate = 'dirty_worktree'; BlocksWhen = 'Unrelated local changes may be touched.'; EvidenceNeeded = 'Git status and touched-file review.'; NextSafeAction = 'Narrow patch or ask.' },
        [PSCustomObject]@{ Gate = 'test_route'; BlocksWhen = 'No parser/lint/test route is known.'; EvidenceNeeded = 'Named command or explicit no-test reason.'; NextSafeAction = 'Find the smallest read-only check.' },
        [PSCustomObject]@{ Gate = 'dependency_or_network'; BlocksWhen = 'Task needs install, network, or generated-code execution.'; EvidenceNeeded = 'Explicit permission and containment.'; NextSafeAction = 'Park or ask.' }
    )
    $riskGateRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_RISK_GATES.csv') -NoTypeInformation -Encoding UTF8

    $decisionRows = @(
        [PSCustomObject]@{ Signal = 'target and proof are known; mutation not authorized'; Decision = 'PLAN_ONLY'; Reason = 'A clean plan can be returned without editing.' },
        [PSCustomObject]@{ Signal = 'target missing or ambiguous'; Decision = 'ASK_USER'; Reason = 'Guessing path creates broad helper risk.' },
        [PSCustomObject]@{ Signal = 'mutation requested without authority'; Decision = 'BLOCK'; Reason = 'Safe seed keeps mutation closed.' },
        [PSCustomObject]@{ Signal = 'task is broad or multi-module'; Decision = 'SPLIT_TASK'; Reason = 'House wants small narrow helpers that string together.' },
        [PSCustomObject]@{ Signal = 'read-only proof failed'; Decision = 'YIELD_DIRTY'; Reason = 'Do not green-pass failed evidence.' }
    )
    $decisionRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_DECISION_TABLE.csv') -NoTypeInformation -Encoding UTF8

    $testRows = @(
        [PSCustomObject]@{ Order = 1; TestKind = 'parse'; UseWhen = 'Script or code syntax can be checked without running generated logic.'; Evidence = 'Parser command, exit code, log path.' },
        [PSCustomObject]@{ Order = 2; TestKind = 'lint_or_type'; UseWhen = 'Project has a known lint/type command.'; Evidence = 'Command, exit code, relevant output.' },
        [PSCustomObject]@{ Order = 3; TestKind = 'tiny_fixture'; UseWhen = 'One input/output/failure case proves the behavior.'; Evidence = 'Fixture path or described fixture, expected result.' },
        [PSCustomObject]@{ Order = 4; TestKind = 'focused_existing_test'; UseWhen = 'Existing test maps tightly to the touched behavior.'; Evidence = 'Named test and result.' },
        [PSCustomObject]@{ Order = 5; TestKind = 'broader_regression'; UseWhen = 'Shared contracts or cross-module behavior are touched.'; Evidence = 'Suite name, result, residual risk.' }
    )
    $testRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_TEST_LADDER.csv') -NoTypeInformation -Encoding UTF8

    $anchorMapRows = @(
        [PSCustomObject]@{ Anchor = 'read_context_helper'; UseWhen = 'Need to understand existing code before plan.'; Pick = 'Read named files/folders only.'; BlockWhen = 'Target path is guessed or too broad.'; EvidenceNeeded = 'Paths read and exact unknowns.'; DoesNotProve = 'Reading does not authorize editing.' },
        [PSCustomObject]@{ Anchor = 'plan_patch_helper'; UseWhen = 'Problem is understood enough to propose change.'; Pick = 'Smallest patch plan.'; BlockWhen = 'Behavior target or acceptance proof is missing.'; EvidenceNeeded = 'Affected files, expected behavior, verification route.'; DoesNotProve = 'Plan does not prove patch is correct.' },
        [PSCustomObject]@{ Anchor = 'fixture_helper'; UseWhen = 'A behavior needs a tiny example.'; Pick = 'One input/output/failure fixture.'; BlockWhen = 'Fixture would touch production data.'; EvidenceNeeded = 'Fixture location or written example.'; DoesNotProve = 'Fixture alone does not prove broad behavior.' },
        [PSCustomObject]@{ Anchor = 'parse_lint_helper'; UseWhen = 'Syntax/style/type shape can be checked safely.'; Pick = 'Parser/lint/type command.'; BlockWhen = 'Command mutates files or runs untrusted generated code.'; EvidenceNeeded = 'Command, exit code, log path.'; DoesNotProve = 'Parse/lint does not prove runtime behavior.' },
        [PSCustomObject]@{ Anchor = 'apply_patch_helper'; UseWhen = 'Authority, target, proof, and rollback are named.'; Pick = 'Smallest approved edit.'; BlockWhen = 'Dirty worktree or unrelated files would be touched.'; EvidenceNeeded = 'Diff and changed paths.'; DoesNotProve = 'Patch does not prove tests passed.' },
        [PSCustomObject]@{ Anchor = 'verify_helper'; UseWhen = 'Patch exists and exact checks are known.'; Pick = 'Run named checks only.'; BlockWhen = 'New feature work is being mixed into verification.'; EvidenceNeeded = 'Pass/fail log and remaining risk.'; DoesNotProve = 'Passing checks do not prove everything.' },
        [PSCustomObject]@{ Anchor = 'receipt_helper'; UseWhen = 'Work is done or blocked and needs clean return.'; Pick = 'Short receipt with proof and DoesNotProve.'; BlockWhen = 'Receipt would promote doctrine or hide failed proof.'; EvidenceNeeded = 'Summary, tests, changed files, residual risk.'; DoesNotProve = 'Receipt does not authorize publishing.' }
    )
    $anchorMapRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_ANCHOR_MAP.csv') -NoTypeInformation -Encoding UTF8

    $knowledgeRows = @(
        [PSCustomObject]@{ Knowledge = 'language_shape'; UseFor = 'Choose parser/lint/test style.'; LearnFrom = 'Language parameter, repo files, existing scripts.'; MustNotInfer = 'Do not invent framework or package manager.'; Proof = 'Named file or command.' },
        [PSCustomObject]@{ Knowledge = 'risk_surface'; UseFor = 'Decide plan-only, ask, block, or verify breadth.'; LearnFrom = 'Target surface and touched behavior.'; MustNotInfer = 'Do not call small code harmless without proof.'; Proof = 'Risk gate row.' },
        [PSCustomObject]@{ Knowledge = 'project_pattern'; UseFor = 'Match existing coding style.'; LearnFrom = 'Read named local files.'; MustNotInfer = 'Do not import new style from memory.'; Proof = 'File path and observed pattern.' },
        [PSCustomObject]@{ Knowledge = 'test_signal'; UseFor = 'Pick smallest useful check.'; LearnFrom = 'Existing package scripts, test files, parser availability.'; MustNotInfer = 'Do not assume tests exist.'; Proof = 'Command or no-test reason.' },
        [PSCustomObject]@{ Knowledge = 'authority_state'; UseFor = 'Know when editing is allowed.'; LearnFrom = 'Current user command, helper route, git/worktree proof.'; MustNotInfer = 'Do not treat packet as permission.'; Proof = 'Exact approval or blocked return.' }
    )
    $knowledgeRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_KNOWLEDGE_LEDGER.csv') -NoTypeInformation -Encoding UTF8

    $pickRows = @(
        [PSCustomObject]@{ IfSignal = 'I need context'; PickAnchor = 'read_context_helper'; Avoid = 'apply_patch_helper'; Reason = 'Context first keeps the patch narrow.' },
        [PSCustomObject]@{ IfSignal = 'I know the bug but not the target file'; PickAnchor = 'ASK_USER or read_context_helper'; Avoid = 'plan_patch_helper'; Reason = 'Plan without target creates fog.' },
        [PSCustomObject]@{ IfSignal = 'I know target and behavior but mutation is not approved'; PickAnchor = 'plan_patch_helper'; Avoid = 'apply_patch_helper'; Reason = 'Plan-only is safe.' },
        [PSCustomObject]@{ IfSignal = 'A broad refactor appears'; PickAnchor = 'SPLIT_TASK'; Avoid = 'apply_patch_helper'; Reason = 'Small narrow helpers string together.' },
        [PSCustomObject]@{ IfSignal = 'A check fails'; PickAnchor = 'verify_helper then receipt_helper'; Avoid = 'green pass'; Reason = 'Failed evidence must be visible.' }
    )
    $pickRows | Export-Csv -LiteralPath (Join-Path $reportRoot 'SAFE_CODING_PICK_RULES.csv') -NoTypeInformation -Encoding UTF8

    @(
        'SAFE CODING HELPER PACKET',
        '',
        "Packet: $packetPath",
        "Reports: $reportRoot",
        'Chain:',
        (Join-Path $reportRoot 'SAFE_CODING_HELPER_CHAIN.csv'),
        'Micro route:',
        (Join-Path $reportRoot 'SAFE_CODING_MICRO_ROUTE.csv'),
        'Risk gates:',
        (Join-Path $reportRoot 'SAFE_CODING_RISK_GATES.csv'),
        'Decision table:',
        (Join-Path $reportRoot 'SAFE_CODING_DECISION_TABLE.csv'),
        'Test ladder:',
        (Join-Path $reportRoot 'SAFE_CODING_TEST_LADDER.csv'),
        'Anchor map:',
        (Join-Path $reportRoot 'SAFE_CODING_ANCHOR_MAP.csv'),
        'Knowledge ledger:',
        (Join-Path $reportRoot 'SAFE_CODING_KNOWLEDGE_LEDGER.csv'),
        'Pick rules:',
        (Join-Path $reportRoot 'SAFE_CODING_PICK_RULES.csv'),
        '',
        'MutationAuthorized: false',
        '',
        'DoesNotProve:',
        'This packet does not authorize edits, code execution, dependency installs, Git/GitHub work, cleanup, broad refactors, or doctrine promotion.'
    ) | Set-Content -LiteralPath (Join-Path $packetRoot 'OPEN_THIS_FIRST.txt') -Encoding UTF8

    Write-Output "SAFE_CODING_HELPER_PACKET_CREATED: $packetPath"
    Write-Output 'MUTATION_AUTHORIZED: false'
    Write-Output 'DOES_NOT_PROVE: This packet does not authorize edits, code execution, dependency installs, Git/GitHub work, cleanup, broad refactors, or doctrine promotion.'
} catch {
    $message = $_.Exception.Message
    Write-FailureReport -Message $message -Root $OutputRoot
    Write-Output 'SAFE_CODING_HELPER_PACKET_FAILED'
    Write-Output ('ERROR_TEXT: ' + $message)
    Write-Error $message
    exit 1
}

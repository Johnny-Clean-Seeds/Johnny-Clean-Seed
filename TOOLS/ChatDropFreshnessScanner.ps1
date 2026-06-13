param(
    [string[]]$ChatDropRoots = @(
        'C:\Users\13527\Desktop\123\Chat Drop',
        'C:\Users\13527\Desktop\Chat Drop'
    )
)

$ErrorActionPreference = 'Stop'

$currentFiles = @(
    '00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__V0_1_20260613.md',
    'CHAT_DROP_COPY__CLEAR_LENS_ENTRY_SUIT_AND_OUTSIDE_AGENT_IDENTITY_CARD_V0_1_20260613.md',
    'CHAT_DROP_COPY__COLLABORATIVE_STEERING_STACK_AND_GATE_DISCIPLINE_V0_1_20260613.md',
    'CHAT_DROP_COPY__PULL_MEANS_LOCAL_FILES_RULE_V0_1_20260613.md',
    'CHAT_DROP_COPY__DEEP_SEARCH_EXTENDED_SEARCH_DISCIPLINE_CARD_V0_4_20260613.md',
    'CHAT_DROP_COPY__HOUSE_SEMANTIC_NERVOUS_SYSTEM_CURRENT_CUSTODY_ANCHOR_ADDENDUM_V0_2_20260607.md',
    'CHAT_DROP_COPY__TWO_LOCATION_CHAT_DROP_AND_HELPER_PREFLIGHT_RULE_ADDENDUM_20260607.md',
    'CHAT_DROP_COPY__MULE_STANDING_ISSUE_LEDGER_V0_1_20260607.md',
    'CHAT_DROP_COPY__ROOT_DROP_INTAKE_WASHER_GATE_RULE_V0_1_20260608.md',
    'CHAT_DROP_COPY__MULE_RAW_CUSTODY_HOUSE_ROUTING_SELF_APPLYING_GATE_ADDENDUM_V0_1_20260607.md'
)

function Get-ChatDropStatus {
    param([System.IO.FileSystemInfo]$Item)

    if ($Item.PSIsContainer) {
        if ($Item.Name -in @('_OLD_LOADS', '_SYNC_REPORTS', '_CLEANUP_REPORTS')) {
            return 'NOT_DEFAULT_LOAD'
        }
        return 'DIRECTORY_REVIEW_REQUIRED'
    }

    switch -Wildcard ($Item.Name) {
        '00_ANCHOR__CURRENT_CHAT_DROP_LOAD_FIRST__*' { return 'CURRENT_ANCHOR_LOAD_FIRST' }
        '00_ANCHOR__UPDATE_REQUIRED__*' { return 'UPDATE_REQUIRED_ANCHOR' }
        'CHAT_DROP_COPY__HOUSE_SEMANTIC_NERVOUS_SYSTEM_CUSTODY_ANCHOR_ADDENDUM_20260607.md' { return 'SUPERSEDED_BY_V0_2_FOR_MIRROR_LAW' }
        'CHAT_DROP_COPY__LIVING_SYSTEM_*' { return 'SUPPORT_ONLY_UNLESS_TASK_NAMES_LIVING_SYSTEM' }
        'CHAT_DROP_COPY__SCISSOR_SEW_SMELL_BONE_NERVE_TOOL_GRAMMAR_CANDIDATE_V1.md' { return 'CANDIDATE_SUPPORT_ONLY' }
        default {
            if ($currentFiles -contains $Item.Name) { return 'CURRENT_HELPER_OR_SUPPORT' }
            if ($Item.Name -like 'CHAT_DROP_COPY__*.md') { return 'UNCLASSIFIED_CHAT_DROP_COPY_CHECK_ANCHOR' }
            return 'UNCLASSIFIED_TOP_LEVEL_ITEM'
        }
    }
}

foreach ($root in $ChatDropRoots) {
    Write-Output "CHAT_DROP_ROOT: $root"

    if (-not (Test-Path -LiteralPath $root)) {
        Write-Output "STATUS: MISSING_ROOT"
        Write-Output ''
        continue
    }

    $items = Get-ChildItem -LiteralPath $root -Force | Sort-Object @{ Expression = { -not $_.PSIsContainer } }, Name
    $names = @($items | ForEach-Object { $_.Name })

    foreach ($needed in $currentFiles) {
        if ($names -notcontains $needed) {
            Write-Output "CHAT_DROP_UPDATE_NEEDED: $root is missing $needed"
        }
    }

    $items | ForEach-Object {
        [PSCustomObject]@{
            Name = $_.Name
            Status = Get-ChatDropStatus -Item $_
            LastWriteTime = $_.LastWriteTime
            Length = if ($_.PSIsContainer) { $null } else { $_.Length }
        }
    } | Format-Table -AutoSize | Out-String -Width 240

    Write-Output ''
}

Write-Output 'PULL_LANGUAGE_RULE: Plain pull means local files in this house. This scanner does not clone, fetch, pull from GitHub, or use Git remotes.'
Write-Output 'DOES_NOT_PROVE: This read-only scan does not mutate files, prove Git state, approve cleanup, or make Chat Drop source authority.'

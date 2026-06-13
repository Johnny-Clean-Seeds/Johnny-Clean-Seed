[CmdletBinding()]
param(
    [string[]]$SeedUrls = @('https://github.com/Johnny-Clean-Seeds/Johnny-Clean-Seed'),
    [int]$MaxPages = 8,
    [int]$MaxDepth = 1,
    [string[]]$AllowedHosts = @(),
    [switch]$AllowExternalHosts,
    [ValidateSet('Level0', 'Level1', 'Level2', 'Level3')][string]$CrawlLevel = 'Level1',
    [string]$SourceFamilyTarget = 'UNCLASSIFIED_WEB_SOURCE',
    [string]$CrawlPurpose = 'bounded evidence crawl',
    [int]$DelayMilliseconds = 250,
    [switch]$AllowBroadCrawl,
    [string]$OutputRoot = 'C:\Users\13527\Desktop\123\_WEB_CRAWL_RUNS',
    [int]$RequestTimeoutSeconds = 20,
    [switch]$SaveRawHtml,
    [string]$IntentionalNegativeTestName = '',
    [string]$ExpectedFailureContains = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$script:RunRoot = $null
$script:ReportRoot = $null
$script:PageRoot = $null
$script:LastCleanPoint = 'SCRIPT_START'
$script:FirstFailingPoint = ''
$script:EvidenceRows = New-Object System.Collections.Generic.List[object]

function Set-CleanPoint {
    param([string]$Point)
    $script:LastCleanPoint = $Point
}

function Set-FailingPoint {
    param([string]$Point)
    if ([string]::IsNullOrWhiteSpace($script:FirstFailingPoint)) {
        $script:FirstFailingPoint = $Point
    }
}

function Add-EvidenceSignal {
    param(
        [ValidateSet('INTENTIONAL_NEGATIVE_TEST', 'CLEARED_SUSPECT')][string]$Status,
        [string]$SuspectedIssue,
        [string]$Trigger,
        [string]$EvidenceChecked,
        [string]$ExpectedResult,
        [string]$ActualResult,
        [string]$WhyPassedFailedOrCleared,
        [string]$WatchNote,
        [string]$DoesNotProve
    )

    $script:EvidenceRows.Add([PSCustomObject]@{
        Status = $Status
        SuspectedIssue = $SuspectedIssue
        Trigger = $Trigger
        EvidenceChecked = $EvidenceChecked
        ExpectedResult = $ExpectedResult
        ActualResult = $ActualResult
        WhyPassedFailedOrCleared = $WhyPassedFailedOrCleared
        WatchNote = $WatchNote
        DoesNotProve = $DoesNotProve
    })
}

function Write-EvidenceSignalReport {
    if (-not $script:ReportRoot) {
        return
    }
    if ($script:EvidenceRows.Count -gt 0) {
        $path = Join-Path $script:ReportRoot 'NEGATIVE_TESTS_AND_CLEARED_SUSPECTS.csv'
        $script:EvidenceRows | Export-Csv -LiteralPath $path -NoTypeInformation -Encoding UTF8
    }
}

function Write-FailureReport {
    param([string]$Message)

    if (-not $script:ReportRoot) {
        New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
        $script:RunRoot = Join-Path $OutputRoot ('WEB_CRAWL_FAILED_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
        $script:ReportRoot = Join-Path $script:RunRoot 'REPORTS'
        New-Item -ItemType Directory -Force -Path $script:ReportRoot | Out-Null
    }

    if ([string]::IsNullOrWhiteSpace($script:FirstFailingPoint)) {
        Set-FailingPoint ('EXCEPTION_AFTER_' + $script:LastCleanPoint)
    }

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

        Add-EvidenceSignal `
            -Status 'INTENTIONAL_NEGATIVE_TEST' `
            -SuspectedIssue $IntentionalNegativeTestName `
            -Trigger 'Intentional bad web crawl input.' `
            -EvidenceChecked ('LastCleanPoint=' + $script:LastCleanPoint + '; FirstFailingPoint=' + $script:FirstFailingPoint) `
            -ExpectedResult $expected `
            -ActualResult ('Route failed with: ' + $Message) `
            -WhyPassedFailedOrCleared $why `
            -WatchNote 'Use this row to teach future crawl helpers what a clean blocked failure looks like.' `
            -DoesNotProve 'Does not prove every crawl failure path works or that web evidence is authoritative.'
        Write-EvidenceSignalReport
    }

    @(
        'WEB_CRAWL_FAILED',
        '',
        "Time: $(Get-Date -Format o)",
        "Reason: $Message",
        "LastCleanPoint: $script:LastCleanPoint",
        "FirstFailingPoint: $script:FirstFailingPoint",
        '',
        'EvidenceStored:',
        $script:ReportRoot,
        '',
        'DoesNotProve:',
        'No web crawl output is clean when this file exists.'
    ) | Set-Content -LiteralPath (Join-Path $script:ReportRoot 'FAILED.txt') -Encoding UTF8
}

function Get-SafeName {
    param([string]$Text)
    $safe = $Text -replace '[^A-Za-z0-9._-]', '_'
    if ($safe.Length -gt 90) {
        return $safe.Substring(0, 90)
    }
    return $safe
}

function ConvertTo-AbsoluteUri {
    param(
        [Uri]$BaseUri,
        [string]$Href
    )

    if ([string]::IsNullOrWhiteSpace($Href)) {
        return $null
    }
    if ($Href.StartsWith('#') -or $Href.StartsWith('mailto:') -or $Href.StartsWith('javascript:') -or $Href.StartsWith('tel:')) {
        return $null
    }

    try {
        $uri = [Uri]::new($BaseUri, $Href)
        if ($uri.Scheme -notin @('http', 'https')) {
            return $null
        }
        return $uri
    } catch {
        return $null
    }
}

function Get-Title {
    param([string]$Html)
    $match = [regex]::Match($Html, '<title[^>]*>(.*?)</title>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($match.Success) {
        return ([System.Net.WebUtility]::HtmlDecode($match.Groups[1].Value) -replace '\s+', ' ').Trim()
    }
    return ''
}

function Get-Excerpt {
    param([string]$Html)
    $clean = [regex]::Replace($Html, '<script[\s\S]*?</script>', ' ', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $clean = [regex]::Replace($clean, '<style[\s\S]*?</style>', ' ', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $clean = [regex]::Replace($clean, '<[^>]+>', ' ')
    $clean = [System.Net.WebUtility]::HtmlDecode($clean)
    $clean = ($clean -replace '\s+', ' ').Trim()
    if ($clean.Length -gt 4000) {
        return $clean.Substring(0, 4000)
    }
    return $clean
}

function Get-LinksFromHtml {
    param(
        [Uri]$BaseUri,
        [string]$Html
    )

    $links = New-Object System.Collections.Generic.List[object]
    $matches = [regex]::Matches($Html, '<a\s+(?:[^>]*?\s+)?href\s*=\s*["'']([^"'']+)["'']', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    foreach ($match in $matches) {
        $uri = ConvertTo-AbsoluteUri -BaseUri $BaseUri -Href $match.Groups[1].Value
        if ($null -ne $uri) {
            $links.Add($uri)
        }
    }
    return $links
}

function Test-AllowedHost {
    param([Uri]$Uri)
    if ($AllowExternalHosts) {
        return $true
    }
    return ($AllowedHosts -contains $Uri.Host.ToLowerInvariant())
}

function Get-RobotsReview {
    param(
        [string]$Scheme,
        [string]$HostName
    )

    $robotsUrl = "${Scheme}://${HostName}/robots.txt"
    try {
        $response = Invoke-WebRequest -Uri $robotsUrl -MaximumRedirection 3 -TimeoutSec $RequestTimeoutSeconds -Headers @{ 'User-Agent' = 'CleanSeedsBoundedWebCrawl/0.1 evidence-only' } -UseBasicParsing
        $content = [string]$response.Content
        $excerpt = ($content -replace '\s+', ' ').Trim()
        if ($excerpt.Length -gt 1000) {
            $excerpt = $excerpt.Substring(0, 1000)
        }
        return [PSCustomObject]@{
            Host = $HostName
            RobotsUrl = $robotsUrl
            Status = 'ROBOTS_FOUND'
            StatusCode = [int]$response.StatusCode
            Excerpt = $excerpt
            DoesNotProve = 'Lightweight robots review only; does not prove full crawl permission or legal clearance.'
        }
    } catch {
        return [PSCustomObject]@{
            Host = $HostName
            RobotsUrl = $robotsUrl
            Status = 'ROBOTS_UNAVAILABLE_OR_BLOCKED'
            StatusCode = ''
            Excerpt = $_.Exception.Message
            DoesNotProve = 'Robots unavailable does not prove crawling is allowed; keep scope small or ask before broadening.'
        }
    }
}

try {
    Set-CleanPoint 'ENTERED_TRY'

    if ($CrawlLevel -eq 'Level3' -and -not $AllowBroadCrawl) {
        throw 'BROAD_CRAWL_LEVEL_BLOCKED: Level3 requires -AllowBroadCrawl and explicit user approval.'
    }
    if ($DelayMilliseconds -lt 0 -or $DelayMilliseconds -gt 10000) {
        throw "INVALID_DELAY_MILLISECONDS: $DelayMilliseconds. Use 0 through 10000."
    }
    if ($MaxPages -lt 1 -or $MaxPages -gt 50) {
        throw "INVALID_MAX_PAGES: $MaxPages. Use 1 through 50 for this bounded helper."
    }
    if ($MaxDepth -lt 0 -or $MaxDepth -gt 3) {
        throw "INVALID_MAX_DEPTH: $MaxDepth. Use 0 through 3 for this bounded helper."
    }
    if ($SeedUrls.Count -lt 1) {
        throw 'NO_SEED_URLS'
    }

    $seeds = New-Object System.Collections.Generic.List[Uri]
    foreach ($seed in $SeedUrls) {
        try {
            $uri = [Uri]$seed
            if (-not $uri.IsAbsoluteUri -or $uri.Scheme -notin @('http', 'https')) {
                throw 'not absolute http/https'
            }
            $seeds.Add($uri)
        } catch {
            Set-FailingPoint 'SEED_URL_VALIDATION'
            throw "INVALID_SEED_URL: $seed"
        }
    }
    Set-CleanPoint 'SEED_URLS_VALIDATED'

    if ($AllowedHosts.Count -eq 0) {
        $AllowedHosts = @($seeds | ForEach-Object { $_.Host.ToLowerInvariant() } | Select-Object -Unique)
    } else {
        $AllowedHosts = @($AllowedHosts | ForEach-Object { $_.ToLowerInvariant() })
    }
    Set-CleanPoint 'ALLOWED_HOSTS_SET'

    if ($CrawlLevel -eq 'Level0') {
        $MaxDepth = 0
        if ($MaxPages -gt $seeds.Count) {
            $MaxPages = $seeds.Count
        }
    }
    Set-CleanPoint 'CRAWL_LEVEL_APPLIED'

    New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
    $script:RunRoot = Join-Path $OutputRoot ('WEB_CRAWL_RUN_' + (Get-Date -Format 'yyyyMMdd_HHmmss'))
    $script:ReportRoot = Join-Path $script:RunRoot 'REPORTS'
    $script:PageRoot = Join-Path $script:RunRoot 'PAGES'
    New-Item -ItemType Directory -Force -Path $script:ReportRoot, $script:PageRoot | Out-Null
    Set-CleanPoint 'EVIDENCE_FOLDERS_CREATED'

    [PSCustomObject]@{
        ActiveObject = 'WEB_SEARCH_CRAWL_LADDER'
        CrawlPurpose = $CrawlPurpose
        CrawlLevel = $CrawlLevel
        SeedUrls = ($SeedUrls -join '; ')
        MaxPages = $MaxPages
        MaxDepth = $MaxDepth
        AllowedHosts = ($AllowedHosts -join '; ')
        AllowExternalHosts = [bool]$AllowExternalHosts
        SourceFamilyTarget = $SourceFamilyTarget
        DelayMilliseconds = $DelayMilliseconds
        SaveRawHtml = [bool]$SaveRawHtml
        StopCondition = 'Stop at page cap, depth cap, queue exhaustion, or failed proof.'
        DoesNotProve = 'Preflight does not prove source authority, currentness, safety, or crawl permission.'
    } | Export-Csv -LiteralPath (Join-Path $script:ReportRoot 'WEB_CRAWL_PREFLIGHT.csv') -NoTypeInformation -Encoding UTF8
    Set-CleanPoint 'PREFLIGHT_WRITTEN'

    $pageRows = New-Object System.Collections.Generic.List[object]
    $linkRows = New-Object System.Collections.Generic.List[object]
    $errorRows = New-Object System.Collections.Generic.List[object]
    $robotsRows = New-Object System.Collections.Generic.List[object]
    $queue = New-Object System.Collections.Generic.Queue[object]
    $visited = @{}

    $hostScheme = @{}
    foreach ($seed in $seeds) {
        if (-not $hostScheme.ContainsKey($seed.Host.ToLowerInvariant())) {
            $hostScheme[$seed.Host.ToLowerInvariant()] = $seed.Scheme
        }
    }
    foreach ($allowedHostName in $AllowedHosts) {
        $scheme = if ($hostScheme.ContainsKey($allowedHostName)) { $hostScheme[$allowedHostName] } else { 'https' }
        $robotsRows.Add((Get-RobotsReview -Scheme $scheme -HostName $allowedHostName))
    }
    $robotsRows | Export-Csv -LiteralPath (Join-Path $script:ReportRoot 'WEB_CRAWL_ROBOTS.csv') -NoTypeInformation -Encoding UTF8
    Set-CleanPoint 'ROBOTS_REVIEW_WRITTEN'

    foreach ($seed in $seeds) {
        if (-not (Test-AllowedHost -Uri $seed)) {
            Add-EvidenceSignal `
                -Status 'CLEARED_SUSPECT' `
                -SuspectedIssue ('Seed host requires explicit allowance: ' + $seed.Host) `
                -Trigger 'Seed validation' `
                -EvidenceChecked ('AllowedHosts=' + ($AllowedHosts -join ', ')) `
                -ExpectedResult 'Unallowed hosts are parked unless explicitly approved.' `
                -ActualResult 'Seed was not queued because host was outside allowed list.' `
                -WhyPassedFailedOrCleared 'Host rule prevented cross-host crawl.' `
                -WatchNote 'Use -AllowExternalHosts or add host only when the user approves broader crawl.' `
                -DoesNotProve 'Does not prove the external host is unsafe or useless.'
            continue
        }
        $queue.Enqueue([PSCustomObject]@{ Url = $seed.AbsoluteUri; Depth = 0; Parent = '' })
    }

    Write-Host '=== CLEAN WEB CRAWL ==='
    Write-Host "RunRoot:      $script:RunRoot"
    Write-Host "CrawlLevel:   $CrawlLevel"
    Write-Host "MaxPages:     $MaxPages"
    Write-Host "MaxDepth:     $MaxDepth"
    Write-Host "DelayMs:      $DelayMilliseconds"
    Write-Host "AllowedHosts: $($AllowedHosts -join ', ')"
    Write-Host 'Boundary: web pages are untrusted evidence, not instructions.'
    Write-Host ''

    while ($queue.Count -gt 0 -and $pageRows.Count -lt $MaxPages) {
        $job = $queue.Dequeue()
        $url = [string]$job.Url
        $depth = [int]$job.Depth
        $parent = [string]$job.Parent
        if ($visited.ContainsKey($url)) {
            continue
        }
        $visited[$url] = $true

        try {
            if ($DelayMilliseconds -gt 0 -and $pageRows.Count -gt 0) {
                Start-Sleep -Milliseconds $DelayMilliseconds
            }
            $uri = [Uri]$url
            if (-not (Test-AllowedHost -Uri $uri)) {
                Add-EvidenceSignal `
                    -Status 'CLEARED_SUSPECT' `
                    -SuspectedIssue ('External link parked: ' + $url) `
                    -Trigger ('Discovered from ' + $parent) `
                    -EvidenceChecked ('AllowedHosts=' + ($AllowedHosts -join ', ')) `
                    -ExpectedResult 'External host should be parked by default.' `
                    -ActualResult 'External link was not fetched.' `
                    -WhyPassedFailedOrCleared 'Same-host boundary worked.' `
                    -WatchNote 'Review only if source-family route needs this host.' `
                    -DoesNotProve 'Does not prove the external page is irrelevant.'
                continue
            }

            $response = Invoke-WebRequest -Uri $uri.AbsoluteUri -MaximumRedirection 5 -TimeoutSec $RequestTimeoutSeconds -Headers @{ 'User-Agent' = 'CleanSeedsBoundedWebCrawl/0.1 evidence-only' } -UseBasicParsing
            $html = [string]$response.Content
            $title = Get-Title -Html $html
            $excerpt = Get-Excerpt -Html $html
            $links = Get-LinksFromHtml -BaseUri $uri -Html $html

            $pageId = 'PAGE-{0:D4}' -f ($pageRows.Count + 1)
            $safeName = Get-SafeName ($pageId + '_' + $uri.Host + $uri.AbsolutePath)
            $excerptPath = Join-Path $script:PageRoot ($safeName + '.excerpt.txt')
            $excerpt | Set-Content -LiteralPath $excerptPath -Encoding UTF8
            $rawPath = ''
            if ($SaveRawHtml) {
                $rawPath = Join-Path $script:PageRoot ($safeName + '.html')
                $html | Set-Content -LiteralPath $rawPath -Encoding UTF8
            }

            $pageRows.Add([PSCustomObject]@{
                PageId = $pageId
                Url = $uri.AbsoluteUri
                ParentUrl = $parent
                Depth = $depth
                StatusCode = [int]$response.StatusCode
                ContentType = [string]$response.Headers['Content-Type']
                Title = $title
                LinkCount = $links.Count
                ExcerptPath = $excerptPath
                RawHtmlPath = $rawPath
                SourceFamily = $SourceFamilyTarget
                CarryStatus = 'SOURCE_ORE_UNTIL_GRADED'
                CrawlPurpose = $CrawlPurpose
            })

            foreach ($link in $links) {
                $allowed = Test-AllowedHost -Uri $link
                $linkRows.Add([PSCustomObject]@{
                    FromUrl = $uri.AbsoluteUri
                    ToUrl = $link.AbsoluteUri
                    ToHost = $link.Host
                    AllowedByCurrentRun = $allowed
                    NextDepth = $depth + 1
                })

                if ($allowed -and $depth -lt $MaxDepth -and -not $visited.ContainsKey($link.AbsoluteUri) -and $queue.Count -lt ($MaxPages * 8)) {
                    $queue.Enqueue([PSCustomObject]@{ Url = $link.AbsoluteUri; Depth = ($depth + 1); Parent = $uri.AbsoluteUri })
                }
            }
        } catch {
            $errorRows.Add([PSCustomObject]@{
                Url = $url
                ParentUrl = $parent
                Depth = $depth
                Error = $_.Exception.Message
            })
        }
    }
    Set-CleanPoint 'CRAWL_LOOP_COMPLETE'

    $pageRows | Export-Csv -LiteralPath (Join-Path $script:ReportRoot 'WEB_CRAWL_PAGES.csv') -NoTypeInformation -Encoding UTF8
    $linkRows | Export-Csv -LiteralPath (Join-Path $script:ReportRoot 'WEB_CRAWL_LINKS.csv') -NoTypeInformation -Encoding UTF8
    if ($errorRows.Count -gt 0) {
        $errorRows | Export-Csv -LiteralPath (Join-Path $script:ReportRoot 'WEB_CRAWL_ERRORS.csv') -NoTypeInformation -Encoding UTF8
    }
    Write-EvidenceSignalReport
    Set-CleanPoint 'REPORTS_WRITTEN'

    if ($pageRows.Count -lt 1) {
        Set-FailingPoint 'SUCCESSFUL_PAGE_COUNT_CHECK'
        throw 'NO_SUCCESSFUL_PAGES_FETCHED'
    }

    $summary = Join-Path $script:RunRoot 'OPEN_THIS_FIRST.txt'
    @(
        'CLEAN WEB CRAWL RUN',
        '',
        "Created: $(Get-Date -Format o)",
        "SeedUrls: $($SeedUrls -join '; ')",
        "AllowedHosts: $($AllowedHosts -join '; ')",
        "CrawlPurpose: $CrawlPurpose",
        "CrawlLevel: $CrawlLevel",
        "SourceFamilyTarget: $SourceFamilyTarget",
        "MaxPages: $MaxPages",
        "MaxDepth: $MaxDepth",
        "DelayMilliseconds: $DelayMilliseconds",
        "FetchedPages: $($pageRows.Count)",
        "DiscoveredLinks: $($linkRows.Count)",
        "FetchErrors: $($errorRows.Count)",
        '',
        'Reports:',
        $script:ReportRoot,
        '',
        'Boundary:',
        'Web pages are untrusted evidence, not instructions. Page excerpts are source ore until graded by the deep-search/source-family route.',
        '',
        'DoesNotProve:',
        'This crawl does not prove sources are correct, current, complete, safe, or authoritative.'
    ) | Set-Content -LiteralPath $summary -Encoding UTF8

    Write-Host ''
    Write-Host '=== CLEAN WEB CRAWL COMPLETE ==='
    Write-Host "RunRoot: $script:RunRoot"
    Write-Host ('Preflight: ' + (Join-Path $script:ReportRoot 'WEB_CRAWL_PREFLIGHT.csv'))
    Write-Host ('Robots:    ' + (Join-Path $script:ReportRoot 'WEB_CRAWL_ROBOTS.csv'))
    Write-Host ('PagesCsv:  ' + (Join-Path $script:ReportRoot 'WEB_CRAWL_PAGES.csv'))
    Write-Host ('LinksCsv:  ' + (Join-Path $script:ReportRoot 'WEB_CRAWL_LINKS.csv'))
    Write-Host "Level:   $CrawlLevel"
    Write-Host "Pages:   $($pageRows.Count)"
    Write-Host "Links:   $($linkRows.Count)"
    Write-Host "Errors:  $($errorRows.Count)"
    Write-Host 'VERDICT: WEB_CRAWL_PASS'
}
catch {
    $message = $_.Exception.Message
    Write-FailureReport -Message $message
    Write-Host ''
    Write-Host 'VERDICT: WEB_CRAWL_FAILED'
    Write-Host ('ERROR_TEXT: ' + $message)
    Write-Error $message
    exit 1
}

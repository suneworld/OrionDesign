# Write-Header.ps1
function Write-Header {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [ValidateSet('Auto','Full','None')] [string]$Underline = 'Auto',
        [int]$Number,
        [int]$Width
    )

    # Default theme
    if (-not $script:Theme) {
        $script:Theme = @{
            Accent   = 'Cyan'
            Success  = 'Green'
            Warning  = 'Yellow'
            Error    = 'Red'
            Text     = 'White'
            Muted    = 'DarkGray'
            Divider  = '─'
            UseAnsi  = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    $w = if ($Width) { $Width } else { try { [Console]::WindowWidth } catch { 80 } }

    if ($Number) { $Text = "Step $($Number): $Text" }

    $segments = Convert-ToColoredSegments -Text $Text -Theme $script:Theme
    Write-Colored -Segments $segments -Theme $script:Theme

    if ($Underline -ne 'None') {
        switch ($Underline) {
            'Auto' {
                $len = ($Text -replace '<[^>]+>','').Length
                Write-Host ($script:Theme.Divider * $len) -ForegroundColor $script:Theme.Accent
            }
            'Full' {
                Write-Host ($script:Theme.Divider * $w) -ForegroundColor $script:Theme.Accent
            }
        }
    }
}

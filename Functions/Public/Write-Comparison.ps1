<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Comparison Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Data Presentation
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates side-by-side comparisons of text, arrays, or objects.
Specialized data presentation component enabling visual comparison with
difference highlighting, table formats, and flexible layout options.

HLD INTEGRATION:
┌─ DATA PRESENTATION ─┐    ┌─ COMPARISON ─┐    ┌─ OUTPUT ─┐
│ Write-Comparison    │◄──►│ Left/Right   │───►│ Side-by  │
│ • Text/Array/Object │    │ Differences  │    │ Side     │
│ • Difference Hilite │    │ Table Format │    │ Visual   │
│ • Custom Titles     │    │ Line Numbers │    │ Compare  │
└────────────────────┘    └──────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates side-by-side comparisons of data, text, or objects.

.DESCRIPTION
The Write-Comparison function displays two datasets side by side with highlighting of differences, useful for before/after comparisons, file diffs, or data analysis.

.PARAMETER Left
Left side data for comparison.

.PARAMETER Right
Right side data for comparison.

.PARAMETER LeftTitle
Title for the left column.

.PARAMETER RightTitle
Title for the right column.

.PARAMETER Style
The visual style of the comparison. Valid values:
- 'SideBySide' - Traditional side-by-side layout
- 'Unified' - Unified diff-style display
- 'Blocks' - Block comparison with highlighting
- 'Table' - Table format comparison

.PARAMETER HighlightDifferences
Highlight differences between the two sides.

.PARAMETER Width
Total width of the comparison display.

.PARAMETER ShowLineNumbers
Show line numbers for text comparisons.

.EXAMPLE
Write-Comparison -Left @("Line 1", "Line 2", "Line 3") -Right @("Line 1", "Modified Line 2", "Line 3") -LeftTitle "Original" -RightTitle "Modified" -HighlightDifferences

Compares two arrays of text with difference highlighting.

.EXAMPLE
Write-Comparison -Left $object1 -Right $object2 -Style Table -LeftTitle "Before" -RightTitle "After"

Compares two objects in table format.
#>
function Write-Comparison {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]$Left,
        [Parameter(Mandatory)]$Right,
        [string]$LeftTitle = "Left",
        [string]$RightTitle = "Right",
        [ValidateSet('SideBySide', 'Unified', 'Blocks', 'Table')] [string]$Style = 'SideBySide',
        [switch]$HighlightDifferences,
        [int]$Width = 100,
        [switch]$ShowLineNumbers
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

    # Convert inputs to arrays of strings
    $leftLines = @()
    $rightLines = @()

    if ($Left -is [string]) {
        $leftLines = $Left -split "`r?`n"
    } elseif ($Left -is [array]) {
        $leftLines = $Left | ForEach-Object { $_.ToString() }
    } elseif ($Left -is [hashtable] -or $Left.GetType().Name -like "*Object*") {
        $leftLines = @()
        $properties = if ($Left -is [hashtable]) { $Left.Keys } else { $Left.PSObject.Properties.Name }
        foreach ($prop in $properties) {
            $value = if ($Left -is [hashtable]) { $Left[$prop] } else { $Left.$prop }
            $leftLines += "$prop : $value"
        }
    } else {
        $leftLines = @($Left.ToString())
    }

    if ($Right -is [string]) {
        $rightLines = $Right -split "`r?`n"
    } elseif ($Right -is [array]) {
        $rightLines = $Right | ForEach-Object { $_.ToString() }
    } elseif ($Right -is [hashtable] -or $Right.GetType().Name -like "*Object*") {
        $rightLines = @()
        $properties = if ($Right -is [hashtable]) { $Right.Keys } else { $Right.PSObject.Properties.Name }
        foreach ($prop in $properties) {
            $value = if ($Right -is [hashtable]) { $Right[$prop] } else { $Right.$prop }
            $rightLines += "$prop : $value"
        }
    } else {
        $rightLines = @($Right.ToString())
    }

    Write-Host

    switch ($Style) {
        'SideBySide' {
            $columnWidth = [Math]::Floor(($Width - 5) / 2)  # Account for separator

            # Headers
            Write-Host "┌" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($columnWidth + 1)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┬" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($columnWidth + 1)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┐" -ForegroundColor $script:Theme.Muted

            # Title row
            Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host $LeftTitle.PadRight($columnWidth - 1) -ForegroundColor $script:Theme.Accent -NoNewline
            Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host $RightTitle.PadRight($columnWidth - 1) -ForegroundColor $script:Theme.Accent -NoNewline
            Write-Host "│" -ForegroundColor $script:Theme.Muted

            # Separator
            Write-Host "├" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($columnWidth + 1)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┼" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($columnWidth + 1)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┤" -ForegroundColor $script:Theme.Muted

            # Content rows
            $maxLines = [Math]::Max($leftLines.Count, $rightLines.Count)
            for ($i = 0; $i -lt $maxLines; $i++) {
                $leftLine = if ($i -lt $leftLines.Count) { $leftLines[$i] } else { "" }
                $rightLine = if ($i -lt $rightLines.Count) { $rightLines[$i] } else { "" }

                # Truncate if too long
                if ($leftLine.Length -gt $columnWidth - 2) {
                    $leftLine = $leftLine.Substring(0, $columnWidth - 5) + "..."
                }
                if ($rightLine.Length -gt $columnWidth - 2) {
                    $rightLine = $rightLine.Substring(0, $columnWidth - 5) + "..."
                }

                Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline

                # Color coding for differences
                if ($HighlightDifferences -and $leftLine -ne $rightLine) {
                    if ($leftLine -eq "") {
                        Write-Host $leftLine.PadRight($columnWidth - 1) -ForegroundColor $script:Theme.Text -NoNewline
                    } else {
                        Write-Host $leftLine.PadRight($columnWidth - 1) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
                    }
                } else {
                    Write-Host $leftLine.PadRight($columnWidth - 1) -ForegroundColor $script:Theme.Text -NoNewline
                }

                Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline

                if ($HighlightDifferences -and $leftLine -ne $rightLine) {
                    if ($rightLine -eq "") {
                        Write-Host $rightLine.PadRight($columnWidth - 1) -ForegroundColor $script:Theme.Text -NoNewline
                    } else {
                        Write-Host $rightLine.PadRight($columnWidth - 1) -BackgroundColor DarkGreen -ForegroundColor White -NoNewline
                    }
                } else {
                    Write-Host $rightLine.PadRight($columnWidth - 1) -ForegroundColor $script:Theme.Text -NoNewline
                }

                Write-Host "│" -ForegroundColor $script:Theme.Muted
            }

            # Bottom border
            Write-Host "└" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($columnWidth + 1)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┴" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($columnWidth + 1)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┘" -ForegroundColor $script:Theme.Muted
        }

        'Unified' {
            Write-Host "--- $LeftTitle" -ForegroundColor $script:Theme.Error
            Write-Host "+++ $RightTitle" -ForegroundColor $script:Theme.Success
            Write-Host

            $maxLines = [Math]::Max($leftLines.Count, $rightLines.Count)
            for ($i = 0; $i -lt $maxLines; $i++) {
                $leftLine = if ($i -lt $leftLines.Count) { $leftLines[$i] } else { $null }
                $rightLine = if ($i -lt $rightLines.Count) { $rightLines[$i] } else { $null }

                if ($leftLine -eq $rightLine) {
                    Write-Host " $leftLine" -ForegroundColor $script:Theme.Text
                } else {
                    if ($null -ne $leftLine) {
                        Write-Host "-$leftLine" -ForegroundColor $script:Theme.Error
                    }
                    if ($null -ne $rightLine) {
                        Write-Host "+$rightLine" -ForegroundColor $script:Theme.Success
                    }
                }
            }
        }

        'Blocks' {
            # Left block
            Write-Host "▼ $LeftTitle" -ForegroundColor $script:Theme.Accent
            Write-Host "┌" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($Width - 2)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┐" -ForegroundColor $script:Theme.Muted

            foreach ($line in $leftLines) {
                Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host $line.PadRight($Width - 4) -ForegroundColor $script:Theme.Text -NoNewline
                Write-Host "│" -ForegroundColor $script:Theme.Muted
            }

            Write-Host "└" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($Width - 2)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┘" -ForegroundColor $script:Theme.Muted

            Write-Host

            # Right block
            Write-Host "▼ $RightTitle" -ForegroundColor $script:Theme.Success
            Write-Host "┌" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($Width - 2)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┐" -ForegroundColor $script:Theme.Muted

            foreach ($line in $rightLines) {
                Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host $line.PadRight($Width - 4) -ForegroundColor $script:Theme.Text -NoNewline
                Write-Host "│" -ForegroundColor $script:Theme.Muted
            }

            Write-Host "└" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($Width - 2)) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┘" -ForegroundColor $script:Theme.Muted
        }

        'Table' {
            # Simple table format for object comparison
            Write-Host "Property".PadRight(20) -ForegroundColor $script:Theme.Accent -NoNewline
            Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host $LeftTitle.PadRight(25) -ForegroundColor $script:Theme.Accent -NoNewline
            Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host $RightTitle -ForegroundColor $script:Theme.Accent

            Write-Host ("─" * 20) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┼" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * 26) -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "┼" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * 25) -ForegroundColor $script:Theme.Muted

            # If inputs are objects, compare properties
            if (($Left -is [hashtable] -or $Left.GetType().Name -like "*Object*") -and 
                ($Right -is [hashtable] -or $Right.GetType().Name -like "*Object*")) {
                
                $leftProps = if ($Left -is [hashtable]) { $Left.Keys } else { $Left.PSObject.Properties.Name }
                $rightProps = if ($Right -is [hashtable]) { $Right.Keys } else { $Right.PSObject.Properties.Name }
                $allProps = ($leftProps + $rightProps) | Sort-Object | Get-Unique

                foreach ($prop in $allProps) {
                    $leftVal = if ($Left -is [hashtable]) { $Left[$prop] } else { $Left.$prop }
                    $rightVal = if ($Right -is [hashtable]) { $Right[$prop] } else { $Right.$prop }

                    Write-Host $prop.PadRight(20) -ForegroundColor $script:Theme.Text -NoNewline
                    Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline

                    $color = if ($HighlightDifferences -and $leftVal -ne $rightVal) { $script:Theme.Warning } else { $script:Theme.Text }
                    Write-Host $leftVal.ToString().PadRight(25) -ForegroundColor $color -NoNewline
                    Write-Host "│ " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $rightVal.ToString() -ForegroundColor $color
                }
            }
        }
    }

    Write-Host
}

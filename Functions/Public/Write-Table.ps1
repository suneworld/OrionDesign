<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Table Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Data Presentation
Dependencies:  OrionDesign Theme System, Global Max Width

FUNCTION PURPOSE:
Creates formatted tables with responsive column widths and styling options.
Essential component of OrionDesign's Data Presentation category, enabling
professional data display with automatic width management and visual appeal.

HLD INTEGRATION:
┌─ DATA PRESENTATION ─┐    ┌─ GLOBAL CONFIG ─┐    ┌─ OUTPUT ─┐
│ Write-Table         │◄──►│ MaxWidth Control │───►│ Grid     │
│ • Grid Style        │    │ • Responsive     │    │ Border   │
│ • Simple Style      │    │ • Column Width   │    │ Aligned  │
│ • Minimal Style     │    │ • Auto Fit       │    │ Data     │
│ • Modern Style      │    └──────────────────┘    └──────────┘
└────────────────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates formatted tables with styling and sorting options.

.DESCRIPTION
The Write-Table function displays data in well-formatted tables with various styling options, column alignment, and sorting capabilities.

.PARAMETER Data
Array of objects or hashtables to display in the table.

.PARAMETER Columns
Array of column names to display (default: all properties).

.PARAMETER Style
The visual style of the table. Valid values:
- 'Grid' - Full grid with borders
- 'Simple' - Simple lines
- 'Minimal' - Minimal styling
- 'Modern' - Modern flat design

.PARAMETER Sort
Column name to sort by.

.PARAMETER Descending
Sort in descending order.

.PARAMETER MaxWidth
Maximum width for the table.

.EXAMPLE
Write-Table -Data $processes -Columns @("Name","CPU","Memory") -Style Grid -Sort CPU

Displays process data in a grid table sorted by CPU usage.

.EXAMPLE
Write-Table -Data @(
    @{Service="IIS"; Status="Running"; Port="80"},
    @{Service="SQL"; Status="Running"; Port="1433"}
) -Style Modern

Displays service information in modern table style.
#>
function Write-Table {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][array]$Data,
        [array]$Columns = @(),
        [ValidateSet('Grid', 'Simple', 'Minimal', 'Modern')] [string]$Style = 'Grid',
        [string]$Sort = "",
        [switch]$Descending,
        [int]$MaxWidth = 0
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

    if ($Data.Count -eq 0) {
        Write-Host "No data to display" -ForegroundColor $script:Theme.Muted
        return
    }

    # Get columns if not specified
    if ($Columns.Count -eq 0) {
        if ($Data[0] -is [hashtable]) {
            $Columns = $Data[0].Keys
        } else {
            $Columns = $Data[0].PSObject.Properties.Name
        }
    }

    # Sort data if requested
    if ($Sort -and $Sort -in $Columns) {
        if ($Descending) {
            $Data = $Data | Sort-Object $Sort -Descending
        } else {
            $Data = $Data | Sort-Object $Sort
        }
    }

    # Use global max width if MaxWidth not specified
    if ($MaxWidth -eq 0 -and $script:OrionMaxWidth) {
        $MaxWidth = $script:OrionMaxWidth
    }

    # Calculate column widths
    $columnWidths = @{}
    $totalAvailableWidth = if ($MaxWidth -gt 0) { $MaxWidth - ($Columns.Count * 3) } else { 0 }  # Account for borders
    $maxColWidth = if ($totalAvailableWidth -gt 0) { [Math]::Floor($totalAvailableWidth / $Columns.Count) } else { 30 }
    
    foreach ($col in $Columns) {
        $maxWidth = $col.Length
        foreach ($row in $Data) {
            $value = if ($row -is [hashtable]) { $row[$col] } else { $row.$col }
            $valueLength = $value.ToString().Length
            if ($valueLength -gt $maxWidth) { $maxWidth = $valueLength }
        }
        $columnWidths[$col] = [Math]::Min($maxWidth + 2, $maxColWidth)
    }

    Write-Host

    switch ($Style) {
        'Grid' {
            # Top border
            $topBorder = "┌"
            for ($i = 0; $i -lt $Columns.Count; $i++) {
                $col = $Columns[$i]
                $topBorder += "─" * $columnWidths[$col]
                if ($i -lt $Columns.Count - 1) { $topBorder += "┬" }
            }
            $topBorder += "┐"
            Write-Host $topBorder -ForegroundColor $script:Theme.Accent

            # Header
            Write-Host "│" -ForegroundColor $script:Theme.Accent -NoNewline
            for ($i = 0; $i -lt $Columns.Count; $i++) {
                $col = $Columns[$i]
                $paddedCol = $col.PadRight($columnWidths[$col] - 1)
                Write-Host $paddedCol -ForegroundColor $script:Theme.Accent -NoNewline
                Write-Host "│" -ForegroundColor $script:Theme.Accent -NoNewline
            }
            Write-Host

            # Header separator
            $headerSep = "├"
            for ($i = 0; $i -lt $Columns.Count; $i++) {
                $col = $Columns[$i]
                $headerSep += "─" * $columnWidths[$col]
                if ($i -lt $Columns.Count - 1) { $headerSep += "┼" }
            }
            $headerSep += "┤"
            Write-Host $headerSep -ForegroundColor $script:Theme.Accent

            # Data rows
            foreach ($row in $Data) {
                Write-Host "│" -ForegroundColor $script:Theme.Accent -NoNewline
                for ($i = 0; $i -lt $Columns.Count; $i++) {
                    $col = $Columns[$i]
                    $value = if ($row -is [hashtable]) { $row[$col] } else { $row.$col }
                    $paddedValue = $value.ToString().PadRight($columnWidths[$col] - 1)
                    
                    # Truncate if too long
                    if ($paddedValue.Length -gt $columnWidths[$col] - 1) {
                        $paddedValue = $paddedValue.Substring(0, $columnWidths[$col] - 4) + "..."
                    }
                    
                    Write-Host $paddedValue -ForegroundColor $script:Theme.Text -NoNewline
                    Write-Host "│" -ForegroundColor $script:Theme.Accent -NoNewline
                }
                Write-Host
            }

            # Bottom border
            $bottomBorder = "└"
            for ($i = 0; $i -lt $Columns.Count; $i++) {
                $col = $Columns[$i]
                $bottomBorder += "─" * $columnWidths[$col]
                if ($i -lt $Columns.Count - 1) { $bottomBorder += "┴" }
            }
            $bottomBorder += "┘"
            Write-Host $bottomBorder -ForegroundColor $script:Theme.Accent
        }

        'Simple' {
            # Header
            for ($i = 0; $i -lt $Columns.Count; $i++) {
                $col = $Columns[$i]
                Write-Host $col.PadRight($columnWidths[$col]) -ForegroundColor $script:Theme.Accent -NoNewline
            }
            Write-Host

            # Header underline
            for ($i = 0; $i -lt $Columns.Count; $i++) {
                $col = $Columns[$i]
                Write-Host ("-" * $columnWidths[$col]) -ForegroundColor $script:Theme.Muted -NoNewline
            }
            Write-Host

            # Data rows
            foreach ($row in $Data) {
                for ($i = 0; $i -lt $Columns.Count; $i++) {
                    $col = $Columns[$i]
                    $value = if ($row -is [hashtable]) { $row[$col] } else { $row.$col }
                    Write-Host $value.ToString().PadRight($columnWidths[$col]) -ForegroundColor $script:Theme.Text -NoNewline
                }
                Write-Host
            }
        }

        'Modern' {
            # Header with background
            Write-Host (" " * 2) -NoNewline
            for ($i = 0; $i -lt $Columns.Count; $i++) {
                $col = $Columns[$i]
                Write-Host $col.PadRight($columnWidths[$col]) -BackgroundColor $script:Theme.Accent -ForegroundColor Black -NoNewline
            }
            Write-Host

            Write-Host

            # Data rows with bullets
            foreach ($row in $Data) {
                Write-Host "▶ " -ForegroundColor $script:Theme.Accent -NoNewline
                for ($i = 0; $i -lt $Columns.Count; $i++) {
                    $col = $Columns[$i]
                    $value = if ($row -is [hashtable]) { $row[$col] } else { $row.$col }
                    Write-Host $value.ToString().PadRight($columnWidths[$col]) -ForegroundColor $script:Theme.Text -NoNewline
                }
                Write-Host
            }
        }

        'Minimal' {
            # Just data with minimal formatting
            foreach ($row in $Data) {
                for ($i = 0; $i -lt $Columns.Count; $i++) {
                    $col = $Columns[$i]
                    $value = if ($row -is [hashtable]) { $row[$col] } else { $row.$col }
                    
                    Write-Host $col -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host ": " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $value -ForegroundColor $script:Theme.Text -NoNewline
                    
                    if ($i -lt $Columns.Count - 1) {
                        Write-Host " | " -ForegroundColor $script:Theme.Muted -NoNewline
                    }
                }
                Write-Host
            }
        }
    }

    Write-Host
}

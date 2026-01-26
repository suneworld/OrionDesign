<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Chart Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
Category:      Data Presentation
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates visual charts including bar, column, line, and pie charts.
Advanced data presentation component providing graphical data visualization
with customizable dimensions, colors, and value display options.

HLD INTEGRATION:
┌─ DATA PRESENTATION ─┐    ┌─ CHART TYPES ─┐    ┌─ OUTPUT ─┐
│ Write-Chart         │◄──►│ Bar/Column    │───►│ Visual   │
│ • Multiple Types    │    │ Line/Pie      │    │ Charts   │
│ • Custom Dimensions │    │ Custom Size   │    │ Color    │
│ • Value Display     │    │ Auto Scale    │    │ Coded    │
└─────────────────────┘    └───────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates simple ASCII charts for data visualization.

.DESCRIPTION
The Write-Chart function displays data in various chart formats using ASCII characters for basic visualization in the console.

.PARAMETER Data
Array of values or hashtable with labels and values.

.PARAMETER ChartType
The type of chart to display. Valid values:
- 'Bar' - Horizontal bar chart
- 'Column' - Vertical column chart
- 'Line' - Simple line chart
- 'Pie' - Basic pie chart representation

.PARAMETER Title
Optional title for the chart.

.PARAMETER Width
Width of the chart area.

.PARAMETER Height
Height of the chart area (for Column and Line charts).

.PARAMETER ShowValues
Display actual values on the chart.

.PARAMETER ShowPercentage
Display percentage values (for Pie charts).

.EXAMPLE
Write-Chart -Data @{CPU=75; Memory=60; Disk=90} -ChartType Bar -Title "System Usage"

Displays a horizontal bar chart of system usage.

.EXAMPLE
Write-Chart -Data @(10, 20, 30, 25, 15) -ChartType Line -Title "Trend Analysis"

Displays a line chart of trend data.
#>
function Write-Chart {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]$Data,
        [ValidateSet('Bar', 'Column', 'Line', 'Pie')] [string]$ChartType = 'Bar',
        [string]$Title = "",
        [int]$Width = 50,
        [int]$Height = 10,
        [switch]$ShowValues,
        [switch]$ShowPercentage
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

    Write-Host

    if ($Title) {
        Write-Host "📊 $Title" -ForegroundColor $script:Theme.Accent
        Write-Host ("-" * ($Title.Length + 3)) -ForegroundColor $script:Theme.Muted
        Write-Host
    }

    # Convert data to consistent format
    $chartData = @()
    if ($Data -is [hashtable]) {
        foreach ($key in $Data.Keys) {
            $chartData += @{ Label = $key; Value = $Data[$key] }
        }
    } elseif ($Data -is [array]) {
        for ($i = 0; $i -lt $Data.Count; $i++) {
            $chartData += @{ Label = "Item $($i+1)"; Value = $Data[$i] }
        }
    }

    # Find max value for scaling
    $maxValue = ($chartData | ForEach-Object { $_.Value } | Measure-Object -Maximum).Maximum
    if ($maxValue -eq 0) { $maxValue = 1 }

    switch ($ChartType) {
        'Bar' {
            foreach ($item in $chartData) {
                $barLength = [Math]::Round(($item.Value / $maxValue) * $Width)
                $label = $item.Label.PadRight(15)
                
                Write-Host $label -ForegroundColor $script:Theme.Text -NoNewline
                Write-Host " │" -ForegroundColor $script:Theme.Muted -NoNewline
                
                # Color coding based on value
                $color = $script:Theme.Accent
                if ($item.Value -ge $maxValue * 0.8) { $color = $script:Theme.Error }
                elseif ($item.Value -ge $maxValue * 0.6) { $color = $script:Theme.Warning }
                elseif ($item.Value -ge $maxValue * 0.3) { $color = $script:Theme.Success }
                
                for ($i = 0; $i -lt $barLength; $i++) {
                    Write-Host "█" -ForegroundColor $color -NoNewline
                }
                
                if ($ShowValues) {
                    Write-Host " $($item.Value)" -ForegroundColor $script:Theme.Text
                } else {
                    Write-Host
                }
            }
        }

        'Column' {
            # Scale values to fit height
            $scaledData = @()
            foreach ($item in $chartData) {
                $scaledValue = [Math]::Round(($item.Value / $maxValue) * $Height)
                $scaledData += @{ Label = $item.Label; Value = $item.Value; Scaled = $scaledValue }
            }

            # Draw chart from top to bottom
            for ($row = $Height; $row -gt 0; $row--) {
                foreach ($item in $scaledData) {
                    if ($item.Scaled -ge $row) {
                        Write-Host "██" -ForegroundColor $script:Theme.Accent -NoNewline
                    } else {
                        Write-Host "  " -NoNewline
                    }
                    Write-Host " " -NoNewline
                }
                Write-Host
            }

            # Draw x-axis
            foreach ($item in $scaledData) {
                Write-Host "--" -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host " " -NoNewline
            }
            Write-Host

            # Draw labels
            foreach ($item in $scaledData) {
                $shortLabel = if ($item.Label.Length -gt 2) { $item.Label.Substring(0,2) } else { $item.Label }
                Write-Host $shortLabel -ForegroundColor $script:Theme.Text -NoNewline
                Write-Host " " -NoNewline
            }
            Write-Host

            if ($ShowValues) {
                Write-Host
                foreach ($item in $scaledData) {
                    Write-Host "$($item.Label): $($item.Value)" -ForegroundColor $script:Theme.Text
                }
            }
        }

        'Line' {
            # Scale values to fit height
            $scaledData = @()
            foreach ($item in $chartData) {
                $scaledValue = [Math]::Round(($item.Value / $maxValue) * ($Height - 1))
                $scaledData += $scaledValue
            }

            # Create chart grid
            for ($row = $Height - 1; $row -ge 0; $row--) {
                Write-Host ($maxValue * ($row / ($Height - 1))).ToString("0").PadLeft(5) -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host " │" -ForegroundColor $script:Theme.Muted -NoNewline

                for ($col = 0; $col -lt $scaledData.Count; $col++) {
                    if ($scaledData[$col] -eq $row) {
                        Write-Host "●" -ForegroundColor $script:Theme.Accent -NoNewline
                    } elseif ($col -gt 0 -and 
                              (($scaledData[$col-1] -gt $row -and $scaledData[$col] -lt $row) -or 
                               ($scaledData[$col-1] -lt $row -and $scaledData[$col] -gt $row))) {
                        Write-Host "│" -ForegroundColor $script:Theme.Accent -NoNewline
                    } else {
                        Write-Host " " -NoNewline
                    }
                    
                    # Connect points with lines
                    if ($col -lt $scaledData.Count - 1) {
                        if ($scaledData[$col] -eq $row -and $scaledData[$col+1] -eq $row) {
                            Write-Host "─" -ForegroundColor $script:Theme.Accent -NoNewline
                        } else {
                            Write-Host " " -NoNewline
                        }
                    }
                }
                Write-Host
            }

            # X-axis
            Write-Host "     " -NoNewline
            Write-Host "└" -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host ("─" * ($scaledData.Count * 2 - 1)) -ForegroundColor $script:Theme.Muted
        }

        'Pie' {
            $total = ($chartData | ForEach-Object { $_.Value } | Measure-Object -Sum).Sum
            if ($total -eq 0) { $total = 1 }

            Write-Host "   Pie Chart Representation" -ForegroundColor $script:Theme.Muted
            Write-Host

            $colors = @($script:Theme.Accent, $script:Theme.Success, $script:Theme.Warning, $script:Theme.Error, $script:Theme.Text)
            $colorIndex = 0

            foreach ($item in $chartData) {
                $percentage = [Math]::Round(($item.Value / $total) * 100, 1)
                $barLength = [Math]::Round($percentage / 2)  # Scale to reasonable size
                
                $color = $colors[$colorIndex % $colors.Count]
                $colorIndex++

                Write-Host "  " -NoNewline
                Write-Host "●" -ForegroundColor $color -NoNewline
                Write-Host " $($item.Label)".PadRight(15) -ForegroundColor $script:Theme.Text -NoNewline
                
                for ($i = 0; $i -lt $barLength; $i++) {
                    Write-Host "█" -ForegroundColor $color -NoNewline
                }
                
                if ($ShowPercentage) {
                    Write-Host " $percentage%" -ForegroundColor $script:Theme.Text
                } else {
                    Write-Host " $($item.Value)" -ForegroundColor $script:Theme.Text
                }
            }
        }
    }

    Write-Host
}

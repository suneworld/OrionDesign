<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Timeline Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Status & Results
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates chronological timelines with events, times, and status indicators.
Temporal status component providing chronological event visualization with
multiple layout styles and progress indication capabilities.

HLD INTEGRATION:
┌─ STATUS & RESULTS ─┐    ┌─ TIMELINE STYLES ─┐    ┌─ OUTPUT ─┐
│ Write-Timeline     │◄──►│ Vertical/Horizontal│───►│ Chrono   │
│ • Time Events      │    │ Modern/Minimal     │    │ Visual   │
│ • Status Tracking  │    │ Time Display       │    │ Events   │
│ • Multiple Styles  │    │ Progress Steps     │    │ Timeline │
└───────────────────┘    └────────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates timeline visualizations for events or processes.

.DESCRIPTION
The Write-Timeline function displays events in a chronological timeline format with various styling options.

.PARAMETER Events
Array of events with Title, Description, and optionally Time/Date properties.

.PARAMETER Style
The visual style of the timeline. Valid values:
- 'Vertical' - Vertical timeline with connecting lines
- 'Horizontal' - Horizontal timeline
- 'Modern' - Modern design with enhanced visuals
- 'Minimal' - Clean minimal design

.PARAMETER ShowTime
Display time information for each event.

.PARAMETER Icon
Custom icon for timeline points.

.PARAMETER Width
Width of the timeline display.

.PARAMETER CompletedSteps
Number of completed steps (for progress timelines).

.EXAMPLE
Write-Timeline -Events @(
    @{Title="Start"; Description="Process initiated"},
    @{Title="Processing"; Description="Data being processed"},
    @{Title="Complete"; Description="Process finished"}
) -Style Vertical

Displays a vertical timeline of process steps.

.EXAMPLE
Write-Timeline -Events $deploymentSteps -Style Modern -ShowTime -CompletedSteps 2

Displays a modern timeline with time stamps and progress indication.
#>
function Write-Timeline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][array]$Events,
        [ValidateSet('Vertical', 'Horizontal', 'Modern', 'Minimal')] [string]$Style = 'Vertical',
        [switch]$ShowTime,
        [string]$Icon = "●",
        [int]$Width = 60,
        [int]$CompletedSteps = -1
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

    switch ($Style) {
        'Vertical' {
            for ($i = 0; $i -lt $Events.Count; $i++) {
                $eventItem = $Events[$i]
                $isCompleted = $CompletedSteps -eq -1 -or $i -lt $CompletedSteps
                $isCurrent = $CompletedSteps -ne -1 -and $i -eq $CompletedSteps
                $iconColor = if ($isCompleted) { $script:Theme.Success } 
                           elseif ($isCurrent) { $script:Theme.Warning }
                           else { $script:Theme.Muted }

                # Event point
                Write-Host " " -NoNewline
                Write-Host $Icon -ForegroundColor $iconColor -NoNewline
                Write-Host "─ " -ForegroundColor $script:Theme.Muted -NoNewline

                # Title
                Write-Host $eventItem.Title -ForegroundColor $script:Theme.Accent -NoNewline

                # Time
                if ($ShowTime -and $eventItem.Time) {
                    Write-Host " (" -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $eventItem.Time -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host ")" -ForegroundColor $script:Theme.Muted
                } else {
                    Write-Host
                }

                # Description
                if ($eventItem.Description) {
                    Write-Host " │  " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $eventItem.Description -ForegroundColor $script:Theme.Text
                }

                # Connector line (except for last item)
                if ($i -lt $Events.Count - 1) {
                    Write-Host " │" -ForegroundColor $script:Theme.Muted
                }
            }
        }

        'Horizontal' {
            # Timeline line
            Write-Host " " -NoNewline
            for ($i = 0; $i -lt $Events.Count; $i++) {
                $isCompleted = $CompletedSteps -eq -1 -or $i -lt $CompletedSteps
                $lineColor = if ($isCompleted) { $script:Theme.Success } else { $script:Theme.Muted }
                
                Write-Host $Icon -ForegroundColor $lineColor -NoNewline
                if ($i -lt $Events.Count - 1) {
                    Write-Host "─────" -ForegroundColor $lineColor -NoNewline
                }
            }
            Write-Host

            # Event titles
            Write-Host " " -NoNewline
            for ($i = 0; $i -lt $Events.Count; $i++) {
                $eventItem = $Events[$i]
                $titleLength = if ($eventItem.Title.Length -gt 5) { 5 } else { $eventItem.Title.Length }
                $title = $eventItem.Title.Substring(0, $titleLength)
                
                Write-Host $title.PadRight(6) -ForegroundColor $script:Theme.Text -NoNewline
            }
            Write-Host

            # Show details for each event
            if ($Events[0].Description) {
                Write-Host
                for ($i = 0; $i -lt $Events.Count; $i++) {
                    $eventItem = $Events[$i]
                    Write-Host "$($i + 1). " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host $eventItem.Title -ForegroundColor $script:Theme.Accent -NoNewline
                    if ($ShowTime -and $eventItem.Time) {
                        Write-Host " ($($eventItem.Time))" -ForegroundColor $script:Theme.Muted
                    } else {
                        Write-Host
                    }
                    
                    if ($eventItem.Description) {
                        Write-Host "   $($eventItem.Description)" -ForegroundColor $script:Theme.Text
                    }
                }
            }
        }

        'Modern' {
            for ($i = 0; $i -lt $Events.Count; $i++) {
                $eventItem = $Events[$i]
                $isCompleted = $CompletedSteps -eq -1 -or $i -lt $CompletedSteps
                $isCurrent = $CompletedSteps -ne -1 -and $i -eq $CompletedSteps

                # Modern point with glow effect
                Write-Host "  " -NoNewline
                if ($isCompleted) {
                    Write-Host "●" -ForegroundColor $script:Theme.Success -NoNewline
                    Write-Host "●" -ForegroundColor $script:Theme.Success -NoNewline
                } elseif ($isCurrent) {
                    Write-Host "◉" -ForegroundColor $script:Theme.Warning -NoNewline
                    Write-Host "○" -ForegroundColor $script:Theme.Warning -NoNewline
                } else {
                    Write-Host "○" -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host "○" -ForegroundColor $script:Theme.Muted -NoNewline
                }

                Write-Host " ▶ " -ForegroundColor $script:Theme.Accent -NoNewline

                # Event card
                $cardWidth = $Width - 8
                Write-Host "┌" -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host ("─" * ($cardWidth - 2)) -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host "┐" -ForegroundColor $script:Theme.Muted
                
                # Title line
                Write-Host "    │ " -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host $eventItem.Title -ForegroundColor $script:Theme.Accent -NoNewline
                if ($ShowTime -and $eventItem.Time) {
                    $timeText = " • $($eventItem.Time)"
                    $remaining = $cardWidth - $eventItem.Title.Length - $timeText.Length - 3
                    Write-Host $timeText -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host (" " * $remaining) -NoNewline
                } else {
                    $remaining = $cardWidth - $eventItem.Title.Length - 3
                    Write-Host (" " * $remaining) -NoNewline
                }
                Write-Host "│" -ForegroundColor $script:Theme.Muted

                # Description line
                if ($eventItem.Description) {
                    Write-Host "    │ " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $eventItem.Description -ForegroundColor $script:Theme.Text -NoNewline
                    $remaining = $cardWidth - $eventItem.Description.Length - 3
                    Write-Host (" " * $remaining) -NoNewline
                    Write-Host "│" -ForegroundColor $script:Theme.Muted
                }

                # Bottom border
                Write-Host "    └" -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host ("─" * ($cardWidth - 2)) -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host "┘" -ForegroundColor $script:Theme.Muted

                # Connector
                if ($i -lt $Events.Count - 1) {
                    Write-Host "    │" -ForegroundColor $script:Theme.Muted
                    Write-Host "    │" -ForegroundColor $script:Theme.Muted
                }
            }
        }

        'Minimal' {
            for ($i = 0; $i -lt $Events.Count; $i++) {
                $eventItem = $Events[$i]
                $stepNum = ($i + 1).ToString().PadLeft(2)
                
                Write-Host $stepNum -ForegroundColor $script:Theme.Accent -NoNewline
                Write-Host ". " -ForegroundColor $script:Theme.Muted -NoNewline
                Write-Host $eventItem.Title -ForegroundColor $script:Theme.Text

                if ($eventItem.Description) {
                    Write-Host "    " -NoNewline
                    Write-Host $eventItem.Description -ForegroundColor $script:Theme.Muted
                }

                if ($ShowTime -and $eventItem.Time) {
                    Write-Host "    " -NoNewline
                    Write-Host "⏱ $($eventItem.Time)" -ForegroundColor $script:Theme.Muted
                }

                if ($i -lt $Events.Count - 1) {
                    Write-Host
                }
            }
        }
    }

    Write-Host
}

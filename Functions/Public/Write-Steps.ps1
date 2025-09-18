<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Steps Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Status & Results
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Displays numbered step sequences with progress indication and styling.
Process-oriented status component providing clear workflow visualization
with current step highlighting and completion status tracking.

HLD INTEGRATION:
┌─ STATUS & RESULTS ─┐    ┌─ STEP DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-Steps        │◄──►│ Numbered List  │───►│ Progress │
│ • Step Sequence    │    │ Current Step   │    │ Visual   │
│ • Progress Track   │    │ Color Coding   │    │ Steps    │
│ • Current Hilite   │    │ Status Icons   │    │ Sequence │
└────────────────────┘    └────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Displays step-by-step instructions or progress with styled formatting.

.DESCRIPTION
The Write-Steps function creates formatted step-by-step displays, perfect for showing process flows, instructions, or progress tracking.

.PARAMETER Steps
Array of step descriptions or hashtables with step details.

.PARAMETER Style
The visual style of the steps. Valid values:
- 'Numbered' - Traditional numbered list
- 'Arrows' - Steps connected with arrows
- 'Progress' - Progress bar style
- 'Checklist' - Checkbox style list

.PARAMETER Interactive
Makes steps interactive, allowing user to proceed step by step.

.PARAMETER CurrentStep
Highlights the current step (1-based index).

.PARAMETER CompletedSteps
Array of completed step numbers.

.EXAMPLE
Write-Steps @(
    "Connect to server",
    "Backup database", 
    "Apply updates",
    "Verify changes"
) -Style Numbered

Displays a numbered list of steps.

.EXAMPLE
Write-Steps @(
    @{Text="Deploy Code"; Status="Complete"},
    @{Text="Update Database"; Status="Current"},
    @{Text="Test Application"; Status="Pending"}
) -Style Progress

Displays steps with status indicators.
#>
function Write-Steps {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][array]$Steps,
        [ValidateSet('Numbered', 'Arrows', 'Progress', 'Checklist')] [string]$Style = 'Numbered',
        [switch]$Interactive,
        [int]$CurrentStep = 0,
        [array]$CompletedSteps = @()
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

    for ($i = 0; $i -lt $Steps.Count; $i++) {
        $stepNumber = $i + 1
        $step = $Steps[$i]
        
        # Determine step text and status
        if ($step -is [hashtable]) {
            $stepText = $step.Text
            $stepStatus = $step.Status
        } else {
            $stepText = $step.ToString()
            $stepStatus = if ($stepNumber -in $CompletedSteps) { "Complete" } 
                         elseif ($stepNumber -eq $CurrentStep) { "Current" } 
                         else { "Pending" }
        }

        # Status styling
        $statusInfo = switch ($stepStatus) {
            'Complete' { @{ Icon = "✅ "; Color = $script:Theme.Success; Prefix = "[DONE]" } }
            'Current'  { @{ Icon = "🔄 "; Color = $script:Theme.Accent; Prefix = "[ACTIVE]" } }
            'Failed'   { @{ Icon = "❌ "; Color = $script:Theme.Error; Prefix = "[FAILED]" } }
            'Pending'  { @{ Icon = "⏳ "; Color = $script:Theme.Muted; Prefix = "[PENDING]" } }
            default    { @{ Icon = "📋 "; Color = $script:Theme.Text; Prefix = "" } }
        }

        switch ($Style) {
            'Numbered' {
                Write-Host "  $stepNumber. " -ForegroundColor $script:Theme.Accent -NoNewline
                Write-Host $stepText -ForegroundColor $statusInfo.Color
            }
            
            'Arrows' {
                $arrow = if ($i -eq 0) { "▶️" } else { "  ↓" }
                Write-Host "$arrow " -ForegroundColor $script:Theme.Accent -NoNewline
                Write-Host $stepText -ForegroundColor $statusInfo.Color
                
                if ($i -lt $Steps.Count - 1) {
                    Write-Host "    │" -ForegroundColor $script:Theme.Muted
                }
            }
            
            'Progress' {
                Write-Host $statusInfo.Icon -NoNewline
                Write-Host " Step $stepNumber" -ForegroundColor $script:Theme.Accent -NoNewline
                Write-Host ": $stepText " -ForegroundColor $script:Theme.Text -NoNewline
                Write-Host $statusInfo.Prefix -ForegroundColor $statusInfo.Color
            }
            
            'Checklist' {
                $checkbox = switch ($stepStatus) {
#                    'Complete' { "☑️ 🗹 " }
                    'Complete' { "🗹" }
                    'Failed'   { "❌" }
                    default    { "☐ " }
                }
                Write-Host "  $checkbox" -NoNewline
                Write-Host " $stepText" -ForegroundColor $statusInfo.Color
            }
        }

        # Interactive mode
        if ($Interactive -and $stepStatus -eq "Current") {
            Write-Host "    " -NoNewline
            $continue = Write-Question -Text "Continue to next step?" -Type YesNo -Default Yes
            if (-not $continue) {
                Write-Host "❌ Process stopped by user" -ForegroundColor $script:Theme.Warning
                return
            }
        }
    }

    # Summary for progress style
    if ($Style -eq 'Progress') {
        Write-Host
        $completed = ($Steps | Where-Object { $_ -is [hashtable] -and $_.Status -eq 'Complete' }).Count
        if ($Steps[0] -is [hashtable]) {
            $total = $Steps.Count
        } else {
            $completed = $CompletedSteps.Count
            $total = $Steps.Count
        }
        
        $percentage = if ($total -gt 0) { [Math]::Round(($completed / $total) * 100) } else { 0 }
        Write-Host "Progress: " -ForegroundColor $script:Theme.Text -NoNewline
        Write-Host "$completed/$total" -ForegroundColor $script:Theme.Accent -NoNewline
        Write-Host " ($percentage%)" -ForegroundColor $script:Theme.Success
    }

    Write-Host
}

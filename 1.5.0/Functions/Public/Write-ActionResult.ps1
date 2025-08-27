<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-ActionResult Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Status & Results
Dependencies:  OrionDesign Theme System, Global Max Width

FUNCTION PURPOSE:
Displays formatted action results with status indicators and details.
Core component of OrionDesign's Status & Results category, providing
consistent feedback for script operations and automation tasks.

HLD INTEGRATION:
┌─ STATUS & RESULTS ─┐    ┌─ GLOBAL CONFIG ─┐    ┌─ OUTPUT ─┐
│ Write-ActionResult │◄──►│ MaxWidth Control │───►│ Emoji    │
│ • Success Status   │    │ • Auto Truncate  │    │ Colors   │
│ • Warning Status   │    │ • Global Theme   │    │ Status   │
│ • Failed Status    │    │ • Width Aware    │    │ Details  │
│ • Info Status      │    └──────────────────┘    └──────────┘
└───────────────────┘
================================================================================
#>

<#
.SYNOPSIS
Displays formatted action results with status, timing, and details.

.DESCRIPTION
The Write-ActionResult function provides consistent formatting for displaying the results of actions, operations, or tasks. Shows status with appropriate icons and colors, execution time, and optional details or suggestions.

.PARAMETER Action
The name or description of the action that was performed.

.PARAMETER Status
The status of the action. Valid values:
- 'Success' - Action completed successfully
- 'Failed' - Action failed
- 'Warning' - Action completed with warnings
- 'Info' - Informational status
- 'Running' - Action is currently running
- 'Pending' - Action is pending execution

.PARAMETER Duration
The time taken to complete the action (as string or TimeSpan).

.PARAMETER Details
Additional details about the action result.

.PARAMETER FailureReason
Failure message if the action failed.

.PARAMETER Suggestion
Suggested next steps or remediation.

.PARAMETER Indent
Number of spaces to indent the result (useful for nested operations).

.EXAMPLE
Write-ActionResult -Action "Deploy Database" -Status Success -Duration "00:02:15" -Details "142 tables updated"

Displays a successful action with timing and details.

.EXAMPLE
Write-ActionResult -Action "Connect to API" -Status Failed -FailureReason "Connection timeout" -Suggestion "Check network settings"

Displays a failed action with error and suggestion.

.EXAMPLE
Write-ActionResult -Action "Validate Configuration" -Status Warning -Details "Some optional settings missing"

Displays a warning status with details.
#>
function Write-ActionResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Action,
        [ValidateSet('Success', 'Failed', 'Warning', 'Info', 'Running', 'Pending')] [string]$Status,
        [string]$Duration = "",
        [string]$Details = "",
        [string]$FailureReason = "",
        [string]$Suggestion = "",
        [int]$Indent = 0
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

    # Use global max width if not set
    if (-not $script:OrionMaxWidth) {
        $script:OrionMaxWidth = 100
    }

    $indentStr = " " * $Indent
    $maxContentWidth = $script:OrionMaxWidth - $Indent - 10  # Reserve space for icons and formatting

    # Status icons and colors
    $statusInfo = switch ($Status) {
        'Success' { @{ Icon = "✅"; Color = $script:Theme.Success } }
        'Failed'  { @{ Icon = "❌"; Color = $script:Theme.Error } }
        'Warning' { @{ Icon = "⚠️ "; Color = $script:Theme.Warning } }
        'Info'    { @{ Icon = "ℹ️ "; Color = $script:Theme.Accent } }
        'Running' { @{ Icon = "🔄"; Color = $script:Theme.Accent } }
        'Pending' { @{ Icon = "⏳"; Color = $script:Theme.Muted } }
    }

    # Main result line
    Write-Host $indentStr -NoNewline
    Write-Host $statusInfo.Icon -NoNewline
    Write-Host " $Action" -ForegroundColor $script:Theme.Text -NoNewline
    
    # Duration if provided
    if ($Duration) {
        Write-Host " (" -ForegroundColor $script:Theme.Muted -NoNewline
        Write-Host $Duration -ForegroundColor $statusInfo.Color -NoNewline
        Write-Host ")" -ForegroundColor $script:Theme.Muted -NoNewline
    }
    
    # Status
    Write-Host " - " -ForegroundColor $script:Theme.Muted -NoNewline
    Write-Host $Status.ToUpper() -ForegroundColor $statusInfo.Color

    # Details if provided
    if ($Details) {
        # Truncate details if too long
        $displayDetails = if ($Details.Length -gt $maxContentWidth) {
            $Details.Substring(0, $maxContentWidth - 3) + "..."
        } else {
            $Details
        }
        Write-Host "$indentStr  📋 $displayDetails" -ForegroundColor $script:Theme.Text
    }

    # Error if provided
    if ($FailureReason) {
        # Truncate failure reason if too long
        $displayFailure = if ($FailureReason.Length -gt $maxContentWidth) {
            $FailureReason.Substring(0, $maxContentWidth - 3) + "..."
        } else {
            $FailureReason
        }
        Write-Host "$indentStr  💥 Error: $displayFailure" -ForegroundColor $script:Theme.Error
    }

    # Suggestion if provided
    if ($Suggestion) {
        # Truncate suggestion if too long
        $displaySuggestion = if ($Suggestion.Length -gt $maxContentWidth) {
            $Suggestion.Substring(0, $maxContentWidth - 3) + "..."
        } else {
            $Suggestion
        }
        Write-Host "$indentStr  💡 Suggestion: $displaySuggestion" -ForegroundColor $script:Theme.Warning
    }
}

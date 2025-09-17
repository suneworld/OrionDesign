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
Displays formatted action results with status, timing, subtext, and details.

.DESCRIPTION
The Write-ActionResult function provides consistent formatting for displaying the results of actions, operations, or tasks. Shows status with appropriate icons and colors, execution time, subtext, and optional details or suggestions. The main value (Action) is colored according to the status.

.PARAMETER Action
The name, value, or description of the action that was performed. If not specified, defaults to the value of Status.

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

.PARAMETER Subtext
Additional subtext (such as "items", "users", "devices") to display after the status, in a muted color.

.PARAMETER ShowIcon
Switch to display the status icon. If not specified, defaults to false.

.PARAMETER ShowStatus
Switch to display the status text. If not specified, defaults to false.

.EXAMPLE
Write-ActionResult -Action "Deploy Database" -Status Success -Duration "00:02:15" -Details "142 tables updated" -ShowIcon -ShowStatus

Displays a successful action with timing and details, showing the icon and status.

.EXAMPLE
Write-ActionResult -Action "Connect to API" -Status Failed -FailureReason "Connection timeout" -Suggestion "Check network settings" -ShowIcon -ShowStatus

Displays a failed action with error and suggestion, showing the icon and status.

.EXAMPLE
Write-ActionResult -Action "Validate Configuration" -Status Warning -Details "Some optional settings missing" -Subtext "settings" -ShowIcon -ShowStatus

Displays a warning status with details and subtext, showing the icon and status.

.EXAMPLE
Write-ActionResult 50 -Subtext "devices" -Status Success -ShowIcon -ShowStatus

Displays the value 50 in the color of the status (e.g., green for success), with the subtext "devices" in muted color, showing the icon and status.
#>
function Write-ActionResult {
    [CmdletBinding()]
    param(
        [string]$Action = $null,
        [ValidateSet('Success', 'Failed', 'Warning', 'Info', 'Running', 'Pending')] [string]$Status,
        [string]$Duration = "",
        [string]$Details = "",
        [string]$FailureReason = "",
        [string]$Suggestion = "",
        [int]$Indent = 0,
        [string]$Subtext = "",
        [switch]$ShowIcon,
        [switch]$ShowStatus
    )

    # Default theme
    if (-not $script:Theme) {
        $script:Theme = @{
            Accent  = 'Cyan'
            Success = 'Green'
            Warning = 'Yellow'
            Error   = 'Red'
            Text    = 'White'
            Muted   = 'DarkGray'
            Divider = '─'
            UseAnsi = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    # Default Action to Status if not set
    if (-not $Action) {
        $Action = $Status
    }
    # Set default for switches if not provided
    if (-not $PSBoundParameters.ContainsKey('ShowIcon')) {
        $ShowIcon = $false
    }
    if (-not $PSBoundParameters.ContainsKey('ShowStatus')) {
        $ShowStatus = $false
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
        'Failed' { @{ Icon = "❌"; Color = $script:Theme.Error } }
        'Warning' { @{ Icon = "⚠️ "; Color = $script:Theme.Warning } }
        'Info' { @{ Icon = "ℹ️ "; Color = $script:Theme.Accent } }
        'Running' { @{ Icon = "🔄"; Color = $script:Theme.Accent } }
        'Pending' { @{ Icon = "⏳"; Color = $script:Theme.Muted } }
    }

    # Main result line
    Write-Host $indentStr -NoNewline
    if ($ShowIcon) {
        Write-Host "$($statusInfo.Icon) " -NoNewline
    }
    # Right-align Action (number) to 5 characters
    $ActionStr = $Action.ToString().PadLeft(5)
    Write-Host "$ActionStr" -ForegroundColor $script:Theme.Success -NoNewline
    
    
    # Status
    if ($ShowStatus) {
        Write-Host " - " -ForegroundColor $script:Theme.Muted -NoNewline
        Write-Host $Status.ToUpper() -ForegroundColor $statusInfo.Color -NoNewline
    }
    # Subtext if provided
    if ($Subtext) {
        Write-Host " $Subtext" -ForegroundColor $script:Theme.Muted -NoNewline
    }
    # Duration if provided
    if ($Duration) {
        Write-Host " in " -ForegroundColor $script:Theme.Muted -NoNewline
        Write-Host "$(Format-TimeSpan $Duration)" -ForegroundColor $script:Theme.Muted -NoNewline
    }

    Write-Host 

    # Details if provided
    if ($Details) {
        # Truncate details if too long
        $displayDetails = if ($Details.Length -gt $maxContentWidth) {
            $Details.Substring(0, $maxContentWidth - 3) + "..."
        }
        else {
            $Details
        }
        Write-Host "$indentStr  📋 $displayDetails" -ForegroundColor $script:Theme.Text
    }

    # Error if provided
    if ($FailureReason) {
        # Truncate failure reason if too long
        $displayFailure = if ($FailureReason.Length -gt $maxContentWidth) {
            $FailureReason.Substring(0, $maxContentWidth - 3) + "..."
        }
        else {
            $FailureReason
        }
        Write-Host "$indentStr  💥 Error: $displayFailure" -ForegroundColor $script:Theme.Error
    }

    # Suggestion if provided
    if ($Suggestion) {
        # Truncate suggestion if too long
        $displaySuggestion = if ($Suggestion.Length -gt $maxContentWidth) {
            $Suggestion.Substring(0, $maxContentWidth - 3) + "..."
        }
        else {
            $Suggestion
        }
        Write-Host "$indentStr  💡 Suggestion: $displaySuggestion" -ForegroundColor $script:Theme.Warning
    }
}

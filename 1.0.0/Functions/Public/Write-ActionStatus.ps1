<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-ActionStatus Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Interactive Display
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Completes action status lines with colored results and icons.
Second part of two-function pattern for real-time status reporting,
designed to follow Write-Action calls for complete status line output.

HLD INTEGRATION:
┌─ STATUS COMPLETION ─┐    ┌─ RESULT DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-ActionStatus  │◄──►│ Right-aligned    │───►│ Status   │
│ • Status Text       │    │ Color Coding     │    │ Line     │
│ • Status Icons      │    │ Icon Mapping     │    │ Complete │
│ • Auto Detection    │    │ Pattern Match    │    │ Display  │
└─────────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Completes action status lines with colored results and status icons.

.DESCRIPTION
The Write-ActionStatus function completes status lines started with Write-Action.
It displays the result with appropriate colors and icons based on the status type
or automatic pattern detection. The output includes a newline to complete the line.

.PARAMETER Text
The status text to display.

.PARAMETER Status
The status type for color coding. Valid values:
- 'Success' - Green with checkmark
- 'Failed' - Red with X 
- 'Warning' - Yellow with warning icon
- 'Info' - Cyan with info icon
- 'Running' - Blue with spinner
- 'Pending' - Yellow with clock

.PARAMETER Color
Override color for the status text (overrides Status parameter).

.PARAMETER Width
The width to pad the status text to. Defaults to 15 characters.

.PARAMETER NoIcon
Suppress the status icon, showing only colored text.

.EXAMPLE
Write-Action "Connecting to database"
Write-ActionStatus "Connected" -Status Success

Displays: "Connecting to database                    ✅ Connected"

.EXAMPLE
Write-Action "Processing file"
Write-ActionStatus "File not found" -Status Failed

Shows: "Processing file                             ❌ File not found"

.EXAMPLE
Write-Action "Checking service"
Write-ActionStatus "125 users" 

Auto-detects success pattern: "Checking service                     ✅ 125 users"

.NOTES
This function automatically detects success/failure patterns if no Status is specified.
Patterns like "OK", "users", "devices", "activated" are treated as success.
"Fail", "Error", "Not found" patterns are treated as failures.
#>
function Write-ActionStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [ValidateSet('Success', 'Failed', 'Warning', 'Info', 'Running', 'Pending')]
        [string]$Status = "",
        [string]$Color = "",
        [int]$Width = 15,
        [switch]$NoIcon
    )

    # Use theme colors if available
    if (-not $script:Theme) {
        $script:Theme = @{
            Success = 'Green'
            Error   = 'Red'
            Warning = 'Yellow'
            Accent  = 'Cyan'
            Text    = 'White'
            UseAnsi = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    # Auto-detect status if not specified
    if (-not $Status -and -not $Color) {
        if ($Text -match "(?i)(fail|error|not found|denied|invalid)") {
            $Status = "Failed"
        }
        elseif ($Text -match "(?i)(warning|slow|timeout)") {
            $Status = "Warning"
        }
        elseif ($Text -match "(?i)(ok!?|success|activated|connected|completed|users?|devices?|members?|\d+\s+(users?|devices?|items?))") {
            $Status = "Success"
        }
        elseif ($Text -match "(?i)(running|processing|loading)") {
            $Status = "Running"
        }
        elseif ($Text -match "(?i)(pending|waiting|queued)") {
            $Status = "Pending"
        }
        else {
            $Status = "Info"
        }
    }

    # Determine color and icon
    $statusColor = $script:Theme.Text
    $icon = ""

    if ($Color) {
        $statusColor = $Color
    } else {
        switch ($Status) {
            'Success' { 
                $statusColor = $script:Theme.Success
                $icon = if (-not $NoIcon) { "✅ " } else { "" }
            }
            'Failed' { 
                $statusColor = $script:Theme.Error
                $icon = if (-not $NoIcon) { "❌ " } else { "" }
            }
            'Warning' { 
                $statusColor = $script:Theme.Warning
                $icon = if (-not $NoIcon) { "⚠️  " } else { "" }
            }
            'Info' { 
                $statusColor = $script:Theme.Accent
                $icon = if (-not $NoIcon) { "ℹ️  " } else { "" }
            }
            'Running' { 
                $statusColor = $script:Theme.Accent
                $icon = if (-not $NoIcon) { "🔄 " } else { "" }
            }
            'Pending' { 
                $statusColor = $script:Theme.Warning
                $icon = if (-not $NoIcon) { "⏳ " } else { "" }
            }
        }
    }

    # Format the status text with proper padding
    $displayText = $icon + $Text
    if ($displayText.Length -gt $Width) {
        $displayText = $displayText.Substring(0, $Width - 2) + ".."
    } else {
        $displayText = $displayText.PadLeft($Width)
    }

    # Output with newline to complete the line
    Write-Host $displayText -ForegroundColor $statusColor
}
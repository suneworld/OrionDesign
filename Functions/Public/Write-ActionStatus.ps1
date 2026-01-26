<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-ActionStatus Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          January 26, 2026
Module:        OrionDesign v1.6.0
Category:      Interactive Display
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Completes action status lines with colored results and clean text formatting.
Second part of two-function pattern for real-time status reporting,
designed to follow Write-Action calls for complete status line output.
Automatically handles overflow by moving status to a new line when needed.

HLD INTEGRATION:
┌─ STATUS COMPLETION ─┐    ┌─ RESULT DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-ActionStatus  │◄──►│ Right-aligned    │───►│ Status   │
│ • Status Text       │    │ Color Coding     │    │ Line     │
│ • Clean Design      │    │ Professional     │    │ Complete │
│ • Auto Detection    │    │ Pattern Match    │    │ Display  │
│ • Overflow Handling │    │ Smart Line Break │    │ Adaptive │
└─────────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Completes action status lines with colored results and clean text formatting.

.DESCRIPTION
The Write-ActionStatus function completes status lines started with Write-Action.
It displays the result with appropriate colors based on the status type
or automatic pattern detection. The output includes a newline to complete the line.

If the combined length of the action text and status text would exceed the
configured max width (OrionMaxWidth), the status is automatically moved to
a new line and right-aligned to the full width for clean, readable output.

.PARAMETER Text
The status text to display.

.PARAMETER Status
The status type for color coding. Valid values:
- 'Success' - Green text
- 'Failed' - Red text
- 'Warning' - Yellow text
- 'Info' - Cyan text
- 'Running' - Blue text
- 'Pending' - Yellow text

.PARAMETER Color
Override color for the status text (overrides Status parameter).

.PARAMETER Width
The width to pad the status text to. Defaults to 50 characters.

.PARAMETER NoIcon
Legacy parameter - maintained for compatibility (no longer used as icons are removed).

.EXAMPLE
Write-Action "Connecting to database"
Write-ActionStatus "Connected" -Status Success

Displays: "Connecting to database                       Connected"

.EXAMPLE
Write-Action "Processing file"
Write-ActionStatus "File not found" -Status Failed

Shows: "Processing file                          File not found"

.EXAMPLE
Write-Action "Checking service"
Write-ActionStatus "125 users" 

Auto-detects success pattern: "Checking service                      125 users"

.EXAMPLE
Write-Action "This is a very long action description"
Write-ActionStatus "This is a very long status that causes overflow" -Status Success

When combined text exceeds max width, automatically outputs:
  This is a very long action description
                       This is a very long status that causes overflow

.NOTES
This function automatically detects success/failure patterns if no Status is specified.
Patterns like "OK", "users", "devices", "activated" are treated as success.
"Fail", "Error", "Not found" patterns are treated as failures.

Overflow handling: When combined action + status text exceeds OrionMaxWidth,
the status is moved to a new line and right-aligned to the full width.
#>
function Write-ActionStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [ValidateSet('Success', 'Failed', 'Warning', 'Info', 'Running', 'Pending')]
        [string]$Status = "",
        [string]$Color = "",
        [int]$Width = 0,
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

    # Determine color - clean design without icons
    $statusColor = $script:Theme.Text

    if ($Color) {
        $statusColor = $Color
    } else {
        switch ($Status) {
            'Success' { 
                $statusColor = $script:Theme.Success
            }
            'Failed' { 
                $statusColor = $script:Theme.Error
            }
            'Warning' { 
                $statusColor = $script:Theme.Warning
            }
            'Info' { 
                $statusColor = $script:Theme.Accent
            }
            'Running' { 
                $statusColor = $script:Theme.Accent
            }
            'Pending' { 
                $statusColor = $script:Theme.Warning
            }
        }
    }

    # Get the max width to use
    $maxWidth = if ($script:OrionMaxWidth) { $script:OrionMaxWidth } else { 100 }
    
    # Check if combined action + status text would exceed max width
    $actionLength = if ($script:LastActionTextLength) { $script:LastActionTextLength } else { 0 }
    $combinedLength = $actionLength + $Text.Length + 1  # +1 for at least one space
    
    if ($combinedLength -gt $maxWidth -and $actionLength -gt 0) {
        # Overflow: output newline first, then right-align status to full max width
        Write-Host ""  # Complete the previous line
        $displayText = $Text.PadLeft($maxWidth)
        Write-Host $displayText -ForegroundColor $statusColor
    } else {
        # Normal case: calculate width for status text
        if ($Width -eq 0) {
            if ($script:OrionMaxWidth) {
                # Use the space reserved by Write-Action (50 chars)
                $Width = 50  # This should match the statusReserve in Write-Action
            } else {
                $Width = 50  # Generous fallback for longer status messages
            }
        }

        # Format the status text with proper padding - clean design without icons
        # PadLeft ensures all status text ENDS at the same column (right-aligned)
        # No truncation - always show full text
        $displayText = $Text.PadLeft($Width)

        # Output with newline to complete the line
        Write-Host $displayText -ForegroundColor $statusColor
    }
}
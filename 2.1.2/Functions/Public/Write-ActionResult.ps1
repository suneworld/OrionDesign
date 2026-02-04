<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-ActionResult Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          February 4, 2026
Module:        OrionDesign v2.1.2
Category:      Interactive Display
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Completes action lines with colored results and automatic right-alignment.
Second part of two-function pattern for real-time status reporting,
designed to follow Write-Action calls for complete status line output.
Automatically right-aligns to OrionMaxWidth and handles overflow gracefully.

HLD INTEGRATION:
┌─ RESULT COMPLETION ─┐    ┌─ RESULT DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-ActionResult  │◄──►│ Right-aligned    │───►│ Result   │
│ • Result Text       │    │ Auto to MaxWidth │    │ Line     │
│ • Clean Design      │    │ Color Coding     │    │ Complete │
│ • Auto Detection    │    │ Pattern Match    │    │ Display  │
│ • Overflow Handling │    │ Smart Line Break │    │ Adaptive │
└─────────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Completes action lines with colored results and automatic right-alignment.

.DESCRIPTION
The Write-ActionResult function completes action lines started with Write-Action.
It displays the result with appropriate colors based on the status type
or automatic pattern detection. The result text is automatically right-aligned
to the configured OrionMaxWidth.

If the combined length of the action text and result text would exceed the
configured max width (OrionMaxWidth), the result is automatically moved to
a new line and right-aligned to the full width for clean, readable output.

.PARAMETER Text
The result text to display.

.PARAMETER Status
The status type for color coding. Valid values:
- 'Success' - Green text (theme dependent)
- 'Failed' - Red text
- 'Warning' - Yellow text
- 'Info' - Cyan/Accent text
- 'Running' - Accent text
- 'Pending' - Warning text

.PARAMETER Color
Override color for the result text (overrides Status parameter).

.EXAMPLE
Write-Action "Connecting to database"
Write-ActionResult "Connected" -Status Success

Displays with automatic right-alignment to OrionMaxWidth:
  Connecting to database                                             Connected

.EXAMPLE
Write-Action "Processing file"
Write-ActionResult "File not found" -Status Failed

Shows with right-aligned result:
  Processing file                                               File not found

.EXAMPLE
Write-Action "Checking service"
Write-ActionResult "125 users" 

Auto-detects success pattern:
  Checking service                                                   125 users

.EXAMPLE
Write-Action "This is a very long action description that takes most of the line"
Write-ActionResult "This is a very long result that causes overflow" -Status Success

When combined text exceeds max width, automatically outputs on new line:
  This is a very long action description that takes most of the line
                                  This is a very long result that causes overflow

.NOTES
This function automatically detects success/failure patterns if no Status is specified.
Patterns like "OK", "users", "devices", "activated" are treated as success.
"Fail", "Error", "Not found" patterns are treated as failures.

Automatic alignment: Result text is automatically right-aligned to OrionMaxWidth.
Overflow handling: When combined action + result text exceeds OrionMaxWidth,
the result is moved to a new line and right-aligned to the full width.
#>
function Write-ActionResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [ValidateSet('Success', 'Failed', 'Warning', 'Info', 'Running', 'Pending')]
        [string]$Status = "",
        [string]$Color = ""
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
            'Success' { $statusColor = $script:Theme.Success }
            'Failed'  { $statusColor = $script:Theme.Error }
            'Warning' { $statusColor = $script:Theme.Warning }
            'Info'    { $statusColor = $script:Theme.Accent }
            'Running' { $statusColor = $script:Theme.Accent }
            'Pending' { $statusColor = $script:Theme.Warning }
        }
    }

    # Get max width and action length
    $maxWidth = if ($script:OrionMaxWidth) { $script:OrionMaxWidth } else { 100 }
    $actionLength = if ($script:LastActionTextLength) { $script:LastActionTextLength } else { 0 }
    
    # Calculate if we need a new line (action + space + status > maxWidth)
    $combinedLength = $actionLength + 1 + $Text.Length
    
    if ($combinedLength -gt $maxWidth -and $actionLength -gt 0) {
        # Not enough room - go to new line and right-align
        Write-Host ""
        $padding = $maxWidth - $Text.Length
        if ($padding -gt 0) {
            Write-Host (" " * $padding) -NoNewline
        }
        Write-Host $Text -ForegroundColor $statusColor
    } else {
        # Enough room - right-align on same line
        $padding = $maxWidth - $actionLength - $Text.Length
        if ($padding -gt 0) {
            Write-Host (" " * $padding) -NoNewline
        }
        Write-Host $Text -ForegroundColor $statusColor
    }
}

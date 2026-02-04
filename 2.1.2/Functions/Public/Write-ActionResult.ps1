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
Automatically right-aligns to OrionMaxWidth with margin support.

THEME INTEGRATION:
Uses theme 'Result' color (Accent-based) for default/auto-detected success.
Uses theme 'Success' color only for explicit -Status Success.
Respects right margin stored by Write-Action for consistent alignment.

AUTO-DETECTION PHILOSOPHY:
Results are considered successful unless proven otherwise.
Only explicit failure/warning patterns trigger non-success colors:
- Failed: "fail", "error", "not found", "denied", "invalid", "exception", "abort"
- Warning: "warning", "slow", "timeout", "expired", "skipped"
- Running: "running", "processing", "loading", "in progress"
- Pending: "pending", "waiting", "queued"
- Everything else: Success (uses Result/Accent color)

HLD INTEGRATION:
┌─ RESULT COMPLETION ─┐    ┌─ RESULT DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-ActionResult  │◄──►│ Right-aligned    │───►│ Result   │
│ • Result Text       │    │ With margins     │    │ Line     │
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
to the configured OrionMaxWidth, respecting the right margin set by Write-Action.

AUTO-DETECTION (when no -Status or -Color specified):
Results default to Success unless failure/warning patterns are detected.
This "success unless proven otherwise" approach means any result text
without negative keywords will display in the theme's Result color (Accent).

If the combined length of the action text and result text would exceed the
effective width (OrionMaxWidth minus margins), the result is automatically
moved to a new line and right-aligned for clean, readable output.

.PARAMETER Text
The result text to display.

.PARAMETER Status
The status type for color coding. Valid values:
- 'Success' - Uses theme Result color (Accent-based) - this is the auto-detect default
- 'Failed' - Uses theme Error color (Red)
- 'Warning' - Uses theme Warning color (Yellow)  
- 'Info' - Uses theme Accent color
- 'Running' - Uses theme Accent color
- 'Pending' - Uses theme Warning color

.PARAMETER Color
Override color for the result text (overrides Status parameter).

.EXAMPLE
Write-Action "Connecting to database"
Write-ActionResult "Connected"

Displays with automatic right-alignment and margins (auto-detects as Success):
 Connecting to database                                             Connected 

.EXAMPLE
Write-Action "Processing file"
Write-ActionResult "File not found"

Auto-detects "not found" as Failed, shows in Error color:
 Processing file                                              File not found 

.EXAMPLE
Write-Action "Checking service"
Write-ActionResult "125 users" 

No failure pattern detected, defaults to Success (Result/Accent color):
 Checking service                                                  125 users 

.EXAMPLE
Write-Action "Syncing data"
Write-ActionResult "Done"

Any text without failure/warning patterns shows as Success:
 Syncing data                                                           Done 

.EXAMPLE
Write-Action "This is a very long action description that takes most of the line"
Write-ActionResult "This is a very long result that causes overflow"

When combined text exceeds effective width, automatically outputs on new line:
 This is a very long action description that takes most of the line
                                 This is a very long result that causes overflow 

.NOTES
Auto-detection philosophy: "Success unless proven otherwise"
- Only explicit negative patterns (fail, error, warning, timeout, etc.) change the color
- All other text defaults to Success status with Result/Accent color
- Use explicit -Status parameter to override auto-detection

Margin support: Respects the right margin stored by Write-Action (defaults to 1).
This ensures result text aligns with separators and other OrionDesign components.

Theme colors used:
- Success (auto-detected): theme.Result (Accent-based, varies by theme)
- Failed: theme.Error
- Warning: theme.Warning
- Info/Running: theme.Accent
- Pending: theme.Warning
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
            Action  = 'White'
            Result  = 'Cyan'
            UseAnsi = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    # Auto-detect status if not specified
    # Philosophy: Results are successful unless proven otherwise
    # Only explicit failure/warning patterns trigger non-success colors
    if (-not $Status -and -not $Color) {
        if ($Text -match "(?i)(fail|error|not found|denied|invalid|exception|abort)") {
            $Status = "Failed"
        }
        elseif ($Text -match "(?i)(warning|slow|timeout|expired|skipped)") {
            $Status = "Warning"
        }
        elseif ($Text -match "(?i)(running|processing|loading|in progress)") {
            $Status = "Running"
        }
        elseif ($Text -match "(?i)(pending|waiting|queued)") {
            $Status = "Pending"
        }
        else {
            # Default to Success - any result that isn't explicitly bad is good
            $Status = "Success"
        }
    }

    # Determine color - clean design without icons
    # Result = theme's Result color (Accent-based, for auto-detected success)
    # Success = theme's Success color (Green, only for explicit -Status Success)
    $resultColor = if ($script:Theme.Result) { $script:Theme.Result } else { $script:Theme.Accent }
    $statusColor = $script:Theme.Text

    if ($Color) {
        $statusColor = $Color
    } else {
        switch ($Status) {
            'Success' { $statusColor = $resultColor }  # Auto-detected success uses Result (Accent)
            'Failed'  { $statusColor = $script:Theme.Error }
            'Warning' { $statusColor = $script:Theme.Warning }
            'Info'    { $statusColor = $script:Theme.Accent }
            'Running' { $statusColor = $script:Theme.Accent }
            'Pending' { $statusColor = $script:Theme.Warning }
        }
    }

    # Get max width, action length, and right margin
    $maxWidth = if ($script:OrionMaxWidth) { $script:OrionMaxWidth } else { 100 }
    $actionLength = if ($script:LastActionTextLength) { $script:LastActionTextLength } else { 0 }
    $rightMargin = if ($script:LastActionRightMargin) { $script:LastActionRightMargin } else { 1 }
    
    # Effective width accounts for right margin
    $effectiveWidth = $maxWidth - $rightMargin
    
    # Calculate if we need a new line (action + space + status > effectiveWidth)
    $combinedLength = $actionLength + 1 + $Text.Length
    
    if ($combinedLength -gt $effectiveWidth -and $actionLength -gt 0) {
        # Not enough room - go to new line and right-align
        Write-Host ""
        $padding = $effectiveWidth - $Text.Length
        if ($padding -gt 0) {
            Write-Host (" " * $padding) -NoNewline
        }
        Write-Host $Text -ForegroundColor $statusColor
    } else {
        # Enough room - right-align on same line
        $padding = $effectiveWidth - $actionLength - $Text.Length
        if ($padding -gt 0) {
            Write-Host (" " * $padding) -NoNewline
        }
        Write-Host $Text -ForegroundColor $statusColor
    }
}

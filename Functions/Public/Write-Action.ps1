<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Action Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          January 26, 2026
Module:        OrionDesign v1.6.0
Category:      Interactive Display
Dependencies:  OrionDesign Theme System, Global Width Configuration

FUNCTION PURPOSE:
Writes an action description and waits for completion status.
First part of two-function pattern for real-time status reporting,
designed to be followed by Write-ActionStatus for complete line output.
Stores text length for overflow detection by Write-ActionStatus.

HLD INTEGRATION:
┌─ REAL-TIME STATUS ─┐    ┌─ ACTION DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-Action       │◄──►│ Left-aligned     │───►│ Action   │
│ • Action Text      │    │ Fixed Width      │    │ Line     │
│ • No Newline       │    │ Padding Control  │    │ Partial  │
│ • Width Control    │    │ Color Support    │    │ Display  │
│ • Overflow Support │    │ Length Tracking  │    │ Smart    │
└────────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Writes an action description without a newline, preparing for status output.

.DESCRIPTION
The Write-Action function displays an action description with fixed-width formatting.
It's designed to be used with Write-ActionStatus to create real-time status lines.
The text is left-aligned and padded to a consistent width, with no trailing newline.

The function stores the text length in a script variable, allowing Write-ActionStatus
to detect overflow conditions. If the combined action + status text exceeds the max
width, Write-ActionStatus will automatically output the status on a new line.

.PARAMETER Text
The action description to display.

.PARAMETER Width
The width to pad the text to. If not specified, uses global OrionMaxWidth - 50.

.PARAMETER Color
The color for the action text. Defaults to theme text color.

.PARAMETER Complete
When specified, outputs with a newline instead of waiting for Write-ActionStatus completion.
Use this when you want standalone action text without status pairing.

.EXAMPLE
Write-Action "Connecting to database"
Write-ActionStatus "Connected" -Status Success

Displays: "Connecting to database                    ✅ Connected"

.EXAMPLE
Write-Action "Processing complete" -Complete

Displays standalone action text with immediate newline.

.EXAMPLE
Write-Action "Processing users" -Width 50
# ... do some work ...
Write-ActionStatus "125 users processed" -Status Success

Shows action with custom width and completion status.

.EXAMPLE
Write-Action "This is a very long action that takes up most of the line"
Write-ActionStatus "This is also a very long status message" -Status Success

When combined text exceeds max width, status automatically moves to a new line:
  This is a very long action that takes up most of the line
                                       This is also a very long status message

.NOTES
This function is designed to work with Write-ActionStatus for complete status lines.
Use this pattern for real-time progress reporting and operation status updates.
The function stores text length for overflow detection by Write-ActionStatus.
#>
function Write-Action {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [int]$Width = 0,
        [string]$Color = "",
        [switch]$Complete
    )

    # Use theme colors if available
    if (-not $script:Theme) {
        $script:Theme = @{
            Text = 'White'
            UseAnsi = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    # Calculate width with proper global width respect
    if ($Width -eq 0) {
        if ($script:OrionMaxWidth) {
            # Reserve generous space for status (50 chars for longer status messages)
            $statusReserve = 50
            $Width = [Math]::Max(30, $script:OrionMaxWidth - $statusReserve)
        } else {
            # Fallback when no global width is set
            $Width = 50
        }
    } else {
        # When width is explicitly provided, still respect global limits
        if ($script:OrionMaxWidth) {
            $maxAllowedWidth = $script:OrionMaxWidth - 50  # Reserve generous space for status
            $Width = [Math]::Min($Width, $maxAllowedWidth)
        }
    }

    # Ensure minimum usable width
    $Width = [Math]::Max($Width, 25)

    # Truncate or pad text to desired width
    if ($Text.Length -gt $Width) {
        $paddedText = $Text.Substring(0, $Width - 3) + "..."
    } else {
        $paddedText = $Text.PadRight($Width)
    }

    # Determine color
    $textColor = if ($Color) { $Color } else { $script:Theme.Text }

    # Store the padded text length for Write-ActionStatus to check for overflow
    $script:LastActionTextLength = $paddedText.Length

    # Output with conditional newline
    if ($Complete) {
        Write-Host $paddedText -ForegroundColor $textColor
    } else {
        Write-Host $paddedText -NoNewline -ForegroundColor $textColor
    }
}

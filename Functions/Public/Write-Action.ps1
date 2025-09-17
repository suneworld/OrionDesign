<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Action Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Interactive Display
Dependencies:  OrionDesign Theme System, Global Width Configuration

FUNCTION PURPOSE:
Writes an action description and waits for completion status.
First part of two-function pattern for real-time status reporting,
designed to be followed by Write-ActionStatus for complete line output.

HLD INTEGRATION:
┌─ REAL-TIME STATUS ─┐    ┌─ ACTION DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-Action       │◄──►│ Left-aligned     │───►│ Action   │
│ • Action Text      │    │ Fixed Width      │    │ Line     │
│ • No Newline       │    │ Padding Control  │    │ Partial  │
│ • Width Control    │    │ Color Support    │    │ Display  │
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

.PARAMETER Text
The action description to display.

.PARAMETER Width
The width to pad the text to. If not specified, uses global OrionMaxWidth - 20.

.PARAMETER Color
The color for the action text. Defaults to theme text color.

.EXAMPLE
Write-Action "Connecting to database"
Write-ActionStatus "Connected" -Status Success

Displays: "Connecting to database                    ✅ Connected"

.EXAMPLE
Write-Action "Processing users" -Width 50
# ... do some work ...
Write-ActionStatus "125 users processed" -Status Success

Shows action with custom width and completion status.

.NOTES
This function is designed to work with Write-ActionStatus for complete status lines.
Use this pattern for real-time progress reporting and operation status updates.
#>
function Write-Action {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [int]$Width = 0,
        [string]$Color = ""
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
            # Reserve generous space for status (25 chars: " ✅ Status message text")
            $statusReserve = 25
            $Width = [Math]::Max(30, $script:OrionMaxWidth - $statusReserve)
        } else {
            # Fallback when no global width is set
            $Width = 50
        }
    } else {
        # When width is explicitly provided, still respect global limits
        if ($script:OrionMaxWidth) {
            $maxAllowedWidth = $script:OrionMaxWidth - 20  # Reserve generous space for status
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

    # Output without newline
    Write-Host $paddedText -NoNewline -ForegroundColor $textColor
}

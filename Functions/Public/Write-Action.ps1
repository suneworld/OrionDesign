<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Action Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
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

    # Calculate width
    if ($Width -eq 0) {
        $Width = if ($script:OrionMaxWidth) { $script:OrionMaxWidth - 20 } else { 50 }
    }

    # Apply global max width if set
    if ($script:OrionMaxWidth -and $Width -gt ($script:OrionMaxWidth - 15)) {
        $Width = $script:OrionMaxWidth - 15
    }

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

<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Action Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          January 27, 2026
Module:        OrionDesign v2.0.0
Category:      Interactive Display
Dependencies:  OrionDesign Theme System, Global Width Configuration

FUNCTION PURPOSE:
Writes an action description and waits for completion status.
First part of two-function pattern for real-time status reporting,
designed to be followed by Write-ActionStatus for complete line output.
Stores text length for automatic right-alignment by Write-ActionStatus.

HLD INTEGRATION:
┌─ REAL-TIME STATUS ─┐    ┌─ ACTION DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-Action       │◄──►│ Left-aligned     │───►│ Action   │
│ • Action Text      │    │ No Padding       │    │ Line     │
│ • No Newline       │    │ Color Support    │    │ Partial  │
│ • Length Tracking  │    │ Auto Alignment   │    │ Display  │
└────────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Writes an action description without a newline, preparing for status output.

.DESCRIPTION
The Write-Action function displays an action description left-aligned.
It's designed to be used with Write-ActionStatus to create real-time status lines.
The text is output as-is without padding, and the length is stored for
Write-ActionStatus to automatically calculate right-alignment.

Write-ActionStatus will automatically right-align the status text to OrionMaxWidth.
If the combined action + status text exceeds the max width, Write-ActionStatus 
will automatically output the status on a new line, right-aligned.

.PARAMETER Text
The action description to display.

.PARAMETER Color
The color for the action text. Defaults to theme text color.

.PARAMETER Complete
When specified, outputs with a newline instead of waiting for Write-ActionStatus completion.
Use this when you want standalone action text without status pairing.

.EXAMPLE
Write-Action "Connecting to database"
Write-ActionStatus "Connected" -Status Success

Displays with automatic right-alignment:
  Connecting to database                                             Connected

.EXAMPLE
Write-Action "Processing complete" -Complete

Displays standalone action text with immediate newline.

.EXAMPLE
Write-Action "Processing users"
Write-ActionStatus "125 users processed" -Status Success

Shows action with status automatically right-aligned to OrionMaxWidth.

.EXAMPLE
Write-Action "This is a very long action that takes up most of the available line space"
Write-ActionStatus "This is also a very long status message" -Status Success

When combined text exceeds max width, status automatically moves to a new line:
  This is a very long action that takes up most of the available line space
                                            This is also a very long status message

.NOTES
This function is designed to work with Write-ActionStatus for complete status lines.
Use this pattern for real-time progress reporting and operation status updates.
The function stores text length for automatic alignment by Write-ActionStatus.
#>
function Write-Action {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
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

    # Determine color
    $textColor = if ($Color) { $Color } else { $script:Theme.Text }

    # Store the actual text length for Write-ActionStatus to calculate alignment
    $script:LastActionTextLength = $Text.Length

    # Output with conditional newline
    if ($Complete) {
        Write-Host $Text -ForegroundColor $textColor
    } else {
        Write-Host $Text -NoNewline -ForegroundColor $textColor
    }
}
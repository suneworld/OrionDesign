<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Action Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          February 4, 2026
Module:        OrionDesign v2.1.2
Category:      Interactive Display
Dependencies:  OrionDesign Theme System, Global Width Configuration

FUNCTION PURPOSE:
Writes an action description with three modes:
1. Standard mode: No newline, pairs with Write-ActionResult for status completion
2. Complete mode (-Complete): Standalone output with optional icons, status, duration
3. Right-aligned mode (-RightAlign): Standalone right-aligned text (implies -Complete)

THEME INTEGRATION:
Uses theme 'Action' color for standard mode text (defaults to Text color if not set).
Supports all theme colors for status-based coloring in Complete mode.

HLD INTEGRATION:
┌─ ACTION MODES ──────┐    ┌─ ACTION DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Standard Mode       │◄──►│ Left-aligned     │───►│ Action   │
│ • Pairs w/ Result   │    │ With margins     │    │ Line     │
│ • No Newline        │    │ Color Support    │    │ Partial  │
├─────────────────────┤    ├──────────────────┤    ├──────────┤
│ Complete Mode       │◄──►│ Standalone       │───►│ Full     │
│ • Icons & Status    │    │ Rich Details     │    │ Result   │
│ • Duration/Subtext  │    │ Multi-line       │    │ Block    │
├─────────────────────┤    ├──────────────────┤    ├──────────┤
│ RightAlign Mode     │◄──►│ Right-aligned    │───►│ Single   │
│ • Implies Complete  │    │ With margins     │    │ Line     │
└─────────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Writes an action description, either preparing for Write-ActionResult, as a complete standalone result, or right-aligned.

.DESCRIPTION
The Write-Action function has three modes:

STANDARD MODE (default):
Displays an action description left-aligned without a newline.
Designed to pair with Write-ActionResult for real-time status lines.
The text length and right margin are stored for Write-ActionResult to calculate alignment.
Uses theme 'Action' color (or falls back to 'Text' color).

COMPLETE MODE (-Complete):
Displays a standalone result with optional icons, status colors, duration, 
subtext, and additional details. Use this for summarized action outcomes.

RIGHT-ALIGNED MODE (-RightAlign):
Displays text right-aligned to OrionMaxWidth with margins.
Automatically implies -Complete mode. Useful for standalone right-aligned output.

.PARAMETER Text
The action description to display.

.PARAMETER Color
The color for the action text. Defaults to theme 'Action' color.
In Complete mode with -Status, the text is colored by status instead.

.PARAMETER Indent
Number of spaces for left margin (and right margin for Write-ActionResult alignment).
Defaults to 1. Use -Indent 0 for no indentation.

.PARAMETER RightAlign
Switch to right-align the text to OrionMaxWidth.
Automatically implies -Complete mode (outputs with newline).
Uses Indent value as both left reference and right margin.

.PARAMETER Complete
Switch to enable Complete mode. Outputs a standalone result with newline and optional rich details.

.PARAMETER Status
(Complete mode) The status type for color coding. Valid values:
- 'Success' - Green text
- 'Failed' - Red text
- 'Warning' - Yellow text
- 'Info' - Cyan/Accent text
- 'Running' - Accent text
- 'Pending' - Muted text

.PARAMETER Duration
(Complete mode) The time taken to complete the action.

.PARAMETER Details
(Complete mode) Additional details about the action result.

.PARAMETER FailureReason
(Complete mode) Failure message if the action failed.

.PARAMETER Suggestion
(Complete mode) Suggested next steps or remediation.

.PARAMETER Subtext
(Complete mode) Additional subtext (e.g., "items", "users") displayed after the main text in muted color.

.PARAMETER ShowIcon
(Complete mode) Switch to display the status icon.

.PARAMETER ShowStatus
(Complete mode) Switch to display the status text (e.g., "SUCCESS", "FAILED").

.PARAMETER NoNewLine
(Complete mode) Prevents newline after main result. Details/FailureReason/Suggestion are not shown.

.EXAMPLE
Write-Action "Connecting to database"
Write-ActionResult "Connected"

Standard mode - displays with automatic right-alignment and margins:
 Connecting to database                                             Connected 

.EXAMPLE
Write-Action "Loading configuration" -Indent 0
Write-ActionResult "OK!"

Standard mode with no indentation:
Loading configuration                                                      OK!

.EXAMPLE
Write-Action "Deploy Database" -Complete -Status Success -Duration "00:02:15" -ShowIcon

Complete mode - standalone result with icon and duration:
 ✅ Deploy Database in 00:02:15

.EXAMPLE
Write-Action "142" -Complete -Status Success -Subtext "tables updated" -ShowIcon

Complete mode with subtext:
 ✅ 142 tables updated

.EXAMPLE
Write-Action "Connect to API" -Complete -Status Failed -FailureReason "Connection timeout" -Suggestion "Check network" -ShowIcon

Complete mode with failure details:
 ❌ Connect to API
    💥 Error: Connection timeout
    💡 Suggestion: Check network

.EXAMPLE
Write-Action "Processing" -Indent 4
Write-ActionResult "Done"

Standard mode with 4-space indentation:
    Processing                                                           Done

.EXAMPLE
Write-Action "Completed successfully" -RightAlign

Right-aligned mode (implies Complete):
                                                       Completed successfully 

.NOTES
Standard mode: Pairs with Write-ActionResult for real-time status reporting.
  - Uses theme 'Action' color for text
  - Stores text length and right margin for Write-ActionResult alignment
  - Default indent of 1 space (use -Indent 0 for no margin)

Complete mode: Use for standalone action summaries with rich formatting.

Right-aligned mode: Use -RightAlign for standalone right-aligned text.
  - Automatically implies -Complete mode
  - Respects Indent value as right margin
#>
function Write-Action {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [string]$Color = "",
        [int]$Indent = 1,
        [switch]$RightAlign,
        [switch]$Complete,
        
        # Complete mode parameters
        [ValidateSet('Success', 'Failed', 'Warning', 'Info', 'Running', 'Pending')]
        [string]$Status = "",
        [string]$Duration = "",
        [string]$Details = "",
        [string]$FailureReason = "",
        [string]$Suggestion = "",
        [string]$Subtext = "",
        [switch]$ShowIcon,
        [switch]$ShowStatus,
        [switch]$NoNewLine
    )

    # Use theme colors if available
    if (-not $script:Theme) {
        $script:Theme = @{
            Accent  = 'Cyan'
            Success = 'Green'
            Warning = 'Yellow'
            Error   = 'Red'
            Text    = 'White'
            Muted   = 'DarkGray'
            Action  = 'White'
            Result  = 'Cyan'
            UseAnsi = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    # Build indentation string
    $indentString = if ($Indent -gt 0) { ' ' * $Indent } else { '' }

    # Use global max width if not set
    if (-not $script:OrionMaxWidth) {
        $script:OrionMaxWidth = 100
    }

    # RightAlign implies Complete mode
    if ($RightAlign) {
        $Complete = $true
    }

    if ($Complete) {
        # ===== COMPLETE MODE =====
        # Standalone output with optional icons, status, duration, details
        
        $maxContentWidth = $script:OrionMaxWidth - $indentString.Length - 10

        # Status icons and colors
        $statusInfo = switch ($Status) {
            'Success' { @{ Icon = "✅"; Color = $script:Theme.Success } }
            'Failed'  { @{ Icon = "❌"; Color = $script:Theme.Error } }
            'Warning' { @{ Icon = "⚠️ "; Color = $script:Theme.Warning } }
            'Info'    { @{ Icon = "ℹ️ "; Color = $script:Theme.Accent } }
            'Running' { @{ Icon = "🔄"; Color = $script:Theme.Accent } }
            'Pending' { @{ Icon = "⏳"; Color = $script:Theme.Muted } }
            default   { @{ Icon = ""; Color = $script:Theme.Text } }
        }

        # Ensure we have a valid color
        if (-not $statusInfo.Color) {
            $statusInfo.Color = $script:Theme.Text
        }

        # Determine text color
        $textColor = if ($Color) { $Color } elseif ($Status) { $statusInfo.Color } else { $script:Theme.Text }

        # Handle RightAlign in Complete mode
        if ($RightAlign) {
            # Right-align: calculate padding to push text to the right with margin
            $rightMargin = $Indent
            $totalLength = $Text.Length + $rightMargin
            $padding = $script:OrionMaxWidth - $totalLength
            if ($padding -gt 0) {
                Write-Host (" " * $padding) -NoNewline
            }
            Write-Host "$Text" -ForegroundColor $textColor
            return
        }

        # Main result line
        Write-Host $indentString -NoNewline
        if ($ShowIcon -and $statusInfo.Icon) {
            Write-Host "$($statusInfo.Icon) " -NoNewline
        }
        Write-Host "$Text" -ForegroundColor $textColor -NoNewline

        # Status text
        if ($ShowStatus -and $Status) {
            Write-Host " - " -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host $Status.ToUpper() -ForegroundColor $statusInfo.Color -NoNewline
        }

        # Subtext
        if ($Subtext) {
            Write-Host " $Subtext" -ForegroundColor $script:Theme.Muted -NoNewline
        }

        # Duration
        if ($Duration) {
            Write-Host " in " -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host "$Duration" -ForegroundColor $script:Theme.Muted -NoNewline
        }

        # End main line
        if (-not $NoNewLine) {
            Write-Host
        }

        # Additional details (only if newline is allowed)
        if (-not $NoNewLine) {
            if ($Details) {
                $displayDetails = if ($Details.Length -gt $maxContentWidth) {
                    $Details.Substring(0, $maxContentWidth - 3) + "..."
                } else { $Details }
                Write-Host "$indentString  📋 $displayDetails" -ForegroundColor $script:Theme.Text
            }

            if ($FailureReason) {
                $displayFailure = if ($FailureReason.Length -gt $maxContentWidth) {
                    $FailureReason.Substring(0, $maxContentWidth - 3) + "..."
                } else { $FailureReason }
                Write-Host "$indentString  💥 Error: $displayFailure" -ForegroundColor $script:Theme.Error
            }

            if ($Suggestion) {
                $displaySuggestion = if ($Suggestion.Length -gt $maxContentWidth) {
                    $Suggestion.Substring(0, $maxContentWidth - 3) + "..."
                } else { $Suggestion }
                Write-Host "$indentString  💡 Suggestion: $displaySuggestion" -ForegroundColor $script:Theme.Warning
            }
        }
    }
    else {
        # ===== STANDARD MODE =====
        # No newline, pairs with Write-ActionResult
        
        # Use Action color for descriptions (falls back to Text if Action not defined)
        $actionColor = if ($script:Theme.Action) { $script:Theme.Action } else { $script:Theme.Text }
        $textColor = if ($Color) { $Color } else { $actionColor }

        # Store the actual text length (including indent) for Write-ActionResult to calculate alignment
        $script:LastActionTextLength = $indentString.Length + $Text.Length
        # Store right margin (same as left indent) for Write-ActionResult
        $script:LastActionRightMargin = $Indent

        # Output without newline
        Write-Host "$indentString$Text" -NoNewline -ForegroundColor $textColor
    }
}

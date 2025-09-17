<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-ActionStatus Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Interactive Display
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Completes action status lines with colored results and clean text formatting.
Second part of two-function pattern for real-time status reporting,
designed to follow Write-Action calls for complete status line output.

HLD INTEGRATION:
┌─ STATUS COMPLETION ─┐    ┌─ RESULT DISPLAY ─┐    ┌─ OUTPUT ─┐
│ Write-ActionStatus  │◄──►│ Right-aligned    │───►│ Status   │
│ • Status Text       │    │ Color Coding     │    │ Line     │
│ • Clean Design      │    │ Professional     │    │ Complete │
│ • Auto Detection    │    │ Pattern Match    │    │ Display  │
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
The width to pad the status text to. Defaults to 15 characters.

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

    # Calculate appropriate width for status text
    if ($Width -eq 0) {
        if ($script:OrionMaxWidth) {
            # Use the space reserved by Write-Action (25 chars)
            $Width = 25  # This should match the statusReserve in Write-Action
        } else {
            $Width = 20  # More generous fallback for when no global width is set
        }
    }

    # Format the status text with proper padding - clean design without icons
    $displayText = $Text
    if ($displayText.Length -gt $Width) {
        # Only truncate if absolutely necessary, prefer showing full text
        if ($displayText.Length -gt ($Width + 5)) {  # Allow some overflow before truncating
            $displayText = $displayText.Substring(0, $Width - 2) + ".."
        }
        # If only slightly over, don't truncate - just show the full text
    } else {
        $displayText = $displayText.PadLeft($Width)
    }

    # Output with newline to complete the line
    Write-Host $displayText -ForegroundColor $statusColor
}
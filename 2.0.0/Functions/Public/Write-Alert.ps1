<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Alert Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
Category:      Information Display
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates attention-grabbing alert messages with type-specific styling.
Critical information display component providing prominent notifications
with clean, professional color-coded borders for different alert types.

HLD INTEGRATION:
┌─ INFORMATION ─┐    ┌─ ALERT TYPES ─┐    ┌─ OUTPUT ─┐
│ Write-Alert   │◄──►│ Warning/Error │───►│ Prominent│
│ • Type-based  │    │ Info/Success  │    │ Colored  │
│ • Clean Design│    │ Color Coded   │    │ Bordered │
│ • Prominent   │    │ Professional  │    │ Alerts   │
└───────────────┘    └───────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Displays styled alert messages with different severity levels and optional actions.

.DESCRIPTION
The Write-Alert function creates visually distinctive alert messages for different types of notifications. Features clean, professional styling with color-coded borders and optional interactive actions.

.PARAMETER Message
The alert message to display.

.PARAMETER Type
The type of alert. Valid values:
- 'Success' - Success notification (green)
- 'Warning' - Warning alert (yellow)
- 'Error' - Error alert (red)
- 'Info' - Information alert (cyan)
- 'Critical' - Critical alert with enhanced visibility

.PARAMETER Title
Optional title for the alert.

.PARAMETER Action
Optional action question (e.g., "Continue anyway?").

.PARAMETER ActionType
Type of action if Action is specified. Valid values:
- 'YesNo' - Yes/No question
- 'Continue' - Continue/Cancel question  
- 'Custom' - Custom action text

.PARAMETER Details
Additional details to show below the main message.

.PARAMETER Critical
Switch to mark alert as critical (enhanced styling).

.EXAMPLE
Write-Alert -Message "Backup completed successfully" -Type Success

Displays a success alert.

.EXAMPLE
Write-Alert -Message "Disk space low on C:" -Type Warning -Action "Clean temp files?" -ActionType YesNo

Displays a warning with an interactive yes/no action.

.EXAMPLE
Write-Alert -Message "Service stopped unexpectedly" -Type Error -Critical -Details "Check event logs for more information"

Displays a critical error alert with additional details.
#>
function Write-Alert {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Message,
        [ValidateSet('Success', 'Warning', 'Error', 'Info', 'Critical')] [string]$Type = 'Info',
        [string]$Title = "",
        [string]$Action = "",
        [ValidateSet('YesNo', 'Continue', 'Custom')] [string]$ActionType = 'YesNo',
        [string]$Details = "",
        [switch]$Critical
    )

    # Default theme
    if (-not $script:Theme) {
        $script:Theme = @{
            Accent   = 'Cyan'
            Success  = 'Green'
            Warning  = 'Yellow'
            Error    = 'Red'
            Text     = 'White'
            Muted    = 'DarkGray'
            Divider  = '─'
            UseAnsi  = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    # Alert styling based on type - clean design without icons
    $alertInfo = switch ($Type) {
        'Success'  { @{ Color = $script:Theme.Success; Border = "═"; Label = "SUCCESS" } }
        'Warning'  { @{ Color = $script:Theme.Warning; Border = "═"; Label = "WARNING" } }
        'Error'    { @{ Color = $script:Theme.Error; Border = "═"; Label = "ERROR" } }
        'Info'     { @{ Color = $script:Theme.Accent; Border = "─"; Label = "INFO" } }
        'Critical' { @{ Color = $script:Theme.Error; Border = "█"; Label = "CRITICAL" } }
    }

    # Override for critical flag
    if ($Critical) {
        $alertInfo.Border = "█"
        $alertInfo.Label = "CRITICAL " + $alertInfo.Label
    }

    Write-Host

    # Calculate width using global max width
    $maxWidth = if ($script:OrionMaxWidth) { $script:OrionMaxWidth } else { 80 }

    # Top border
    $border = $alertInfo.Border * $maxWidth
    Write-Host $border -ForegroundColor $alertInfo.Color

    # Title line if provided
    if ($Title) {
        $titleLine = $alertInfo.Border + " " + $Title.ToUpper() + " "
        $titleLineLength = $titleLine.Length + 1  # +1 for ending border
        $padding = [Math]::Max(0, $maxWidth - $titleLineLength)
        $titleLine += (" " * $padding) + $alertInfo.Border
        Write-Host $titleLine -ForegroundColor $alertInfo.Color
        
        # Separator line
        Write-Host $border -ForegroundColor $alertInfo.Color
    }

    # Message line - clean design without icons
    $messageLine = $alertInfo.Border + " " + $alertInfo.Label + ": " + $Message + " "
    $messageLength = $messageLine.Length + 1  # +1 for ending border
    
    if ($messageLength -gt $maxWidth) {
        # Multi-line message
        $words = $Message -split ' '
        $currentLine = $alertInfo.Border + " " + $alertInfo.Label + ": "
        
        foreach ($word in $words) {
            if (($currentLine + $word + " ").Length -gt $maxWidth - 1) {
                # Finish current line
                $padding = [Math]::Max(0, $maxWidth - $currentLine.Length - 1)
                $currentLine += (" " * $padding) + $alertInfo.Border
                Write-Host $currentLine -ForegroundColor $alertInfo.Color
                
                # Start new line
                $currentLine = $alertInfo.Border + "   " + $word + " "
            } else {
                $currentLine += $word + " "
            }
        }
        
        # Finish last line
        $padding = [Math]::Max(0, $maxWidth - $currentLine.Length - 1)
        $currentLine += (" " * $padding) + $alertInfo.Border
        Write-Host $currentLine -ForegroundColor $alertInfo.Color
    } else {
        # Single line message
        $padding = [Math]::Max(0, $maxWidth - $messageLength)
        $messageLine += (" " * $padding) + $alertInfo.Border
        Write-Host $messageLine -ForegroundColor $alertInfo.Color
    }

    # Details if provided
    if ($Details) {
        $detailsLine = $alertInfo.Border + "   Details: " + $Details
        $detailsLineLength = $detailsLine.Length + 1  # +1 for ending border
        $padding = [Math]::Max(0, $maxWidth - $detailsLineLength)
        $detailsLine += (" " * $padding) + $alertInfo.Border
        Write-Host $detailsLine -ForegroundColor $script:Theme.Text
    }

    # Bottom border
    Write-Host $border -ForegroundColor $alertInfo.Color

    # Handle action if provided
    if ($Action) {
        Write-Host
        $actionResult = switch ($ActionType) {
            'YesNo' {
                Write-Question -Text $Action -Type YesNo
            }
            'Continue' {
                Write-Question -Text "Continue?" -Type YesNo -Default Yes
            }
            'Custom' {
                Write-Question -Text $Action
            }
        }
        return $actionResult
    }

    Write-Host
}

<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-InfoBox Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Information Display
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates bordered information boxes with titles and multiple styling options.
Versatile information display component providing highlighted content areas
with automatic width calculation and various visual styles.

HLD INTEGRATION:
┌─ INFORMATION ─┐    ┌─ BOX STYLES ─┐    ┌─ OUTPUT ─┐
│ Write-InfoBox │◄──►│ Classic/Modern│───►│ Bordered │
│ • Title/Content│    │ Simple/Accent │    │ Info     │
│ • Auto Width   │    │ Icon Support  │    │ Content  │
│ • Safety Checks│    │ Width Control │    │ Safe     │
└────────────────┘    └───────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Displays formatted information in styled boxes or panels.

.DESCRIPTION
The Write-InfoBox function creates visually appealing information displays with titles, key-value pairs, and different styling options.

.PARAMETER Title
The title of the information box.

.PARAMETER Content
Hashtable of key-value pairs to display, or array of strings.

.PARAMETER Style
The visual style of the box. Available styles:
• Classic: Traditional box with decorative borders and formal presentation
• Modern: Contemporary flat design with clean lines and subtle shadows
• Simple: Minimal styling with basic borders and understated formatting
• Accent: Highlighted presentation using theme accent colors for emphasis

Valid values: Classic, Modern, Simple, Accent

.PARAMETER Width
Width of the information box (default: auto-calculate).

.EXAMPLE
Write-InfoBox -Title "System Information" -Content @{
    "Server" = "SQL-01"
    "Database" = "Production" 
    "Version" = "2019 SP3"
}

Displays system information in a formatted box.

.EXAMPLE
Write-InfoBox -Title "Configuration" -Content @("Setting 1: Enabled", "Setting 2: Disabled") -Style Modern

Displays configuration information in modern style.
#>
function Write-InfoBox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)]$Content,
        [ValidateSet('Classic', 'Modern', 'Simple', 'Accent')] [string]$Style = 'Classic',
        [int]$Width = 0
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

    # Calculate width
    $maxKeyLength = 0
    $maxValueLength = 0
    $contentLines = @()

    if ($Content -is [hashtable]) {
        foreach ($key in $Content.Keys) {
            $value = $Content[$key]
            $contentLines += "$key`: $value"
            if ($key.Length -gt $maxKeyLength) { $maxKeyLength = $key.Length }
            if ($value.ToString().Length -gt $maxValueLength) { $maxValueLength = $value.ToString().Length }
        }
    } else {
        $contentLines = $Content
        foreach ($line in $contentLines) {
            if ($line.Length -gt $maxValueLength) { $maxValueLength = $line.Length }
        }
    }

    if ($Width -eq 0) {
        # Use global max width if available
        $globalWidth = if ($script:OrionMaxWidth) { $script:OrionMaxWidth } else { 80 }
        $minWidth = [Math]::Max($Title.Length + 10, $maxKeyLength + $maxValueLength + 10)
        $Width = [Math]::Max(40, [Math]::Min($globalWidth, $minWidth))
    }
    
    # Ensure minimum width to prevent negative values
    $Width = [Math]::Max($Width, $Title.Length + 6)

    Write-Host

    switch ($Style) {
        'Classic' {
            # Top border - ensure non-negative width
            Write-Host "┌─ " -ForegroundColor $script:Theme.Accent -NoNewline
            Write-Host $Title -ForegroundColor $script:Theme.Text -NoNewline
            $borderLength = [Math]::Max(0, $Width - $Title.Length - 5)
            Write-Host (" " + "─" * $borderLength + "┐") -ForegroundColor $script:Theme.Accent

            # Content
            foreach ($line in $contentLines) {
                if ($Content -is [hashtable] -and $line -match '^([^:]+): (.+)$') {
                    $key = $matches[1]
                    $value = $matches[2]
                    
                    Write-Host "│ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host $key.PadRight($maxKeyLength) -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host " : " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $value -ForegroundColor $script:Theme.Text -NoNewline
                    
                    $contentLength = 2 + $maxKeyLength + 3 + $value.Length + 1  # │ + key + : + value + │
                    $padding = [Math]::Max(0, $Width - $contentLength)
                    Write-Host (" " * $padding + "│") -ForegroundColor $script:Theme.Accent
                } else {
                    Write-Host "│ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host $line -ForegroundColor $script:Theme.Text -NoNewline
                    $contentLength = 2 + $line.Length + 1  # │ + line + │
                    $padding = [Math]::Max(0, $Width - $contentLength)
                    Write-Host (" " * $padding + "│") -ForegroundColor $script:Theme.Accent
                }
            }

            # Bottom border
            $bottomBorderLength = [Math]::Max(0, $Width - 2)
            Write-Host ("└" + "─" * $bottomBorderLength + "┘") -ForegroundColor $script:Theme.Accent
        }

        'Modern' {
            # Title with modern styling
            Write-Host "▌" -ForegroundColor $script:Theme.Accent -NoNewline
            Write-Host " $Title" -ForegroundColor $script:Theme.Text
            $modernBorderLength = [Math]::Max(0, $Width - 1)
            Write-Host ("▌" + "─" * $modernBorderLength) -ForegroundColor $script:Theme.Accent

            # Content
            foreach ($line in $contentLines) {
                if ($Content -is [hashtable] -and $line -match '^([^:]+): (.+)$') {
                    $key = $matches[1]
                    $value = $matches[2]
                    
                    Write-Host "▌ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host "● " -ForegroundColor $script:Theme.Success -NoNewline
                    Write-Host $key -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host ": " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $value -ForegroundColor $script:Theme.Text
                } else {
                    Write-Host "▌ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host "● " -ForegroundColor $script:Theme.Success -NoNewline
                    Write-Host $line -ForegroundColor $script:Theme.Text
                }
            }
        }

        'Simple' {
            # Simple title
            Write-Host $Title -ForegroundColor $script:Theme.Accent
            Write-Host ("-" * $Title.Length) -ForegroundColor $script:Theme.Muted

            # Content
            foreach ($line in $contentLines) {
                if ($Content -is [hashtable] -and $line -match '^([^:]+): (.+)$') {
                    $key = $matches[1]
                    $value = $matches[2]
                    
                    Write-Host "  $key" -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host ": " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $value -ForegroundColor $script:Theme.Text
                } else {
                    Write-Host "  $line" -ForegroundColor $script:Theme.Text
                }
            }
        }

        'Accent' {
            # Accent title bar
            $titleBarLength = [Math]::Max(0, $Width - $Title.Length - 2)
            $titleBar = " $Title " + (" " * $titleBarLength)
            Write-Host $titleBar -BackgroundColor $script:Theme.Accent -ForegroundColor Black

            # Content with accent bullets
            foreach ($line in $contentLines) {
                if ($Content -is [hashtable] -and $line -match '^([^:]+): (.+)$') {
                    $key = $matches[1]
                    $value = $matches[2]
                    
                    Write-Host " ◆ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host $key -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host ": " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $value -ForegroundColor $script:Theme.Text
                } else {
                    Write-Host " ◆ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host $line -ForegroundColor $script:Theme.Text
                }
            }
        }
    }

    Write-Host
}

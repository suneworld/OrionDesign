<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Panel Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Layout & Formatting
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates bordered content panels with titles and multiple styling options.
Versatile layout component providing organized content display with various
border styles and automatic content wrapping for information organization.

HLD INTEGRATION:
┌─ LAYOUT FORMAT ─┐    ┌─ PANEL STYLES ─┐    ┌─ OUTPUT ─┐
│ Write-Panel     │◄──►│ Box/Left/Top   │───►│ Bordered │
│ • Title/Content │    │ Card/Minimal   │    │ Content  │
│ • Border Styles │    │ Custom Widths  │    │ Wrapped  │
│ • Auto Wrap     │    │ Icon Support   │    │ Styled   │
└─────────────────┘    └────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates styled information panels with borders and icons.

.DESCRIPTION
The Write-Panel function displays information in styled panels with various border styles, icons, and color themes.

.PARAMETER Content
The content to display in the panel (supports array of strings).

.PARAMETER Title
Optional title for the panel.

.PARAMETER Style
The visual style of the panel. Valid values:
- 'Box' - Full box with borders
- 'Left' - Left border only
- 'Top' - Top border with accent
- 'Card' - Card-style with shadow
- 'Minimal' - Minimal styling

.PARAMETER Type
The type of panel for color theming. Valid values:
- 'Info' - Information (Cyan)
- 'Success' - Success (Green)
- 'Warning' - Warning (Yellow)
- 'Error' - Error (Red)
- 'Default' - Default theme

.PARAMETER Icon
Custom icon to display (uses type-based icons by default).

.PARAMETER Width
Width of the panel.

.PARAMETER Padding
Internal padding for content.

.EXAMPLE
Write-Panel -Content "This is an information message" -Type Info -Style Box

Displays an information panel with box styling.

.EXAMPLE
Write-Panel -Content @("Multiple lines", "of content", "in panel") -Title "Status Report" -Type Success -Style Card

Displays a success panel with multiple lines and a title.
#>
function Write-Panel {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][array]$Content,
        [string]$Title = "",
        [ValidateSet('Box', 'Left', 'Top', 'Card', 'Minimal')] [string]$Style = 'Box',
        [ValidateSet('Info', 'Success', 'Warning', 'Error', 'Default')] [string]$Type = 'Info',
        [string]$Icon = "",
        [int]$Width = 0,
        [int]$Padding = 1
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

    # Set colors and icons based on type
    switch ($Type) {
        'Info' { 
            $color = $script:Theme.Accent
            if (-not $Icon) { $Icon = "ℹ" }
        }
        'Success' { 
            $color = $script:Theme.Success
            if (-not $Icon) { $Icon = "✓" }
        }
        'Warning' { 
            $color = $script:Theme.Warning
            if (-not $Icon) { $Icon = "⚠" }
        }
        'Error' { 
            $color = $script:Theme.Error
            if (-not $Icon) { $Icon = "✗" }
        }
        'Default' { 
            $color = $script:Theme.Text
            if (-not $Icon) { $Icon = "●" }
        }
    }

    # Convert content to array of strings
    $lines = @()
    foreach ($item in $Content) {
        $lines += $item.ToString()
    }

    # Calculate width if not specified
    if ($Width -eq 0) {
        $maxLength = 0
        if ($Title) { $maxLength = $Title.Length }
        foreach ($line in $lines) {
            if ($line.Length -gt $maxLength) { $maxLength = $line.Length }
        }
        $Width = $maxLength + ($Padding * 2) + 4  # Extra space for borders/icons
        if ($Width -lt 40) { $Width = 40 }
    }

    Write-Host

    switch ($Style) {
        'Box' {
            # Top border
            Write-Host "┌" -ForegroundColor $color -NoNewline
            Write-Host ("─" * ($Width - 2)) -ForegroundColor $color -NoNewline
            Write-Host "┐" -ForegroundColor $color

            # Title
            if ($Title) {
                $titlePadding = $Width - $Title.Length - 4 - $Icon.Length
                $leftPad = [Math]::Floor($titlePadding / 2)
                $rightPad = $titlePadding - $leftPad

                Write-Host "│ " -ForegroundColor $color -NoNewline
                Write-Host $Icon -ForegroundColor $color -NoNewline
                Write-Host (" " * $leftPad) -NoNewline
                Write-Host $Title -ForegroundColor $color -NoNewline
                Write-Host (" " * $rightPad) -NoNewline
                Write-Host " │" -ForegroundColor $color

                # Separator
                Write-Host "├" -ForegroundColor $color -NoNewline
                Write-Host ("─" * ($Width - 2)) -ForegroundColor $color -NoNewline
                Write-Host "┤" -ForegroundColor $color
            }

            # Content
            foreach ($line in $lines) {
                $contentPadding = $Width - $line.Length - 2 - ($Padding * 2)
                if (-not $Title) { $contentPadding -= ($Icon.Length + 1) }

                Write-Host "│" -ForegroundColor $color -NoNewline
                Write-Host (" " * $Padding) -NoNewline

                if (-not $Title) {
                    Write-Host $Icon -ForegroundColor $color -NoNewline
                    Write-Host " " -NoNewline
                }

                Write-Host $line -ForegroundColor $script:Theme.Text -NoNewline
                Write-Host (" " * ($contentPadding)) -NoNewline
                Write-Host "│" -ForegroundColor $color
            }

            # Bottom border
            Write-Host "└" -ForegroundColor $color -NoNewline
            Write-Host ("─" * ($Width - 2)) -ForegroundColor $color -NoNewline
            Write-Host "┘" -ForegroundColor $color
        }

        'Left' {
            if ($Title) {
                Write-Host "▌ " -ForegroundColor $color -NoNewline
                Write-Host $Icon -ForegroundColor $color -NoNewline
                Write-Host " $Title" -ForegroundColor $color
                Write-Host "▌" -ForegroundColor $color
            }

            foreach ($line in $lines) {
                Write-Host "▌ " -ForegroundColor $color -NoNewline
                if (-not $Title) {
                    Write-Host $Icon -ForegroundColor $color -NoNewline
                    Write-Host " " -NoNewline
                }
                Write-Host $line -ForegroundColor $script:Theme.Text
            }
        }

        'Top' {
            # Top border
            Write-Host ("▀" * $Width) -ForegroundColor $color

            if ($Title) {
                Write-Host $Icon -ForegroundColor $color -NoNewline
                Write-Host " $Title" -ForegroundColor $color
                Write-Host
            }

            foreach ($line in $lines) {
                if (-not $Title) {
                    Write-Host $Icon -ForegroundColor $color -NoNewline
                    Write-Host " " -NoNewline
                }
                Write-Host $line -ForegroundColor $script:Theme.Text
            }
        }

        'Card' {
            # Shadow effect
            Write-Host (" " * 2) -NoNewline
            Write-Host ("▄" * ($Width - 1)) -ForegroundColor $script:Theme.Muted

            # Top border
            Write-Host "┌" -ForegroundColor $color -NoNewline
            Write-Host ("─" * ($Width - 2)) -ForegroundColor $color -NoNewline
            Write-Host "┐" -ForegroundColor $color -NoNewline
            Write-Host "▌" -ForegroundColor $script:Theme.Muted

            # Title
            if ($Title) {
                Write-Host "│ " -ForegroundColor $color -NoNewline
                Write-Host $Icon -ForegroundColor $color -NoNewline
                Write-Host " $Title" -ForegroundColor $color -NoNewline
                $remaining = $Width - $Title.Length - 4 - $Icon.Length
                Write-Host (" " * $remaining) -NoNewline
                Write-Host "│" -ForegroundColor $color -NoNewline
                Write-Host "▌" -ForegroundColor $script:Theme.Muted

                # Separator
                Write-Host "├" -ForegroundColor $color -NoNewline
                Write-Host ("─" * ($Width - 2)) -ForegroundColor $color -NoNewline
                Write-Host "┤" -ForegroundColor $color -NoNewline
                Write-Host "▌" -ForegroundColor $script:Theme.Muted
            }

            # Content
            foreach ($line in $lines) {
                Write-Host "│" -ForegroundColor $color -NoNewline
                Write-Host " " -NoNewline

                if (-not $Title) {
                    Write-Host $Icon -ForegroundColor $color -NoNewline
                    Write-Host " " -NoNewline
                }

                Write-Host $line -ForegroundColor $script:Theme.Text -NoNewline
                $remaining = $Width - $line.Length - 2
                if (-not $Title) { $remaining -= ($Icon.Length + 1) }
                Write-Host (" " * $remaining) -NoNewline
                Write-Host "│" -ForegroundColor $color -NoNewline
                Write-Host "▌" -ForegroundColor $script:Theme.Muted
            }

            # Bottom border
            Write-Host "└" -ForegroundColor $color -NoNewline
            Write-Host ("─" * ($Width - 2)) -ForegroundColor $color -NoNewline
            Write-Host "┘" -ForegroundColor $color -NoNewline
            Write-Host "▌" -ForegroundColor $script:Theme.Muted

            # Shadow bottom
            Write-Host (" " * 2) -NoNewline
            Write-Host ("▀" * ($Width - 1)) -ForegroundColor $script:Theme.Muted
        }

        'Minimal' {
            if ($Title) {
                Write-Host $Icon -ForegroundColor $color -NoNewline
                Write-Host " $Title" -ForegroundColor $color
            }

            foreach ($line in $lines) {
                Write-Host "  " -NoNewline
                if (-not $Title) {
                    Write-Host $Icon -ForegroundColor $color -NoNewline
                    Write-Host " " -NoNewline
                }
                Write-Host $line -ForegroundColor $script:Theme.Text
            }
        }
    }

    Write-Host
}

<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Menu Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v2.0.0
Category:      Interactive Elements
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates interactive selection menus with keyboard navigation and styling.
Core interactive component providing user choice interfaces with consistent
visual design and intuitive navigation patterns.

HLD INTEGRATION:
┌─ INTERACTIVE ─┐    ┌─ USER INPUT ─┐    ┌─ OUTPUT ─┐
│ Write-Menu    │◄──►│ Keyboard     │───►│ Selection│
│ • Options     │    │ Navigation   │    │ Result   │
│ • Styles      │    │ Enter/Escape │    │ Index    │
│ • Navigation  │    │ Arrow Keys   │    │ Value    │
└───────────────┘    └──────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates styled interactive menus for user selection.

.DESCRIPTION
The Write-Menu function displays a formatted menu with options that users can select from. Supports different styles and keyboard navigation.

.PARAMETER Title
The title of the menu.

.PARAMETER Options
Array of menu options to display.

.PARAMETER Style
The visual style of the menu. Available styles:
• Simple: Clean numbered list without icons, minimal formatting and compact layout
• Modern: Stylish menu with icons, accent colors and enhanced visual appeal
• Boxed: Menu enclosed in decorative border with frame and padding
• Compact: Space-efficient single-line style for limited display areas

Valid values: Simple, Modern, Boxed, Compact

.PARAMETER AllowEscape
Allow users to press Escape to exit without selection.

.PARAMETER DefaultSelection
Default option number (1-based) to highlight.

.PARAMETER MultiSelect
Allow users to select multiple options using comma-separated numbers (e.g., "1,3,5").

.EXAMPLE
Write-Menu -Title "Main Menu" -Options @("Deploy","Test","Rollback","Exit")

Creates a simple menu with four options.

.EXAMPLE
Write-Menu -Title "Environment Selection" -Options @("Development","Testing","Production") -Style Modern -DefaultSelection 1

Creates a modern styled menu with default selection.

.EXAMPLE
Write-Menu -Title "Select Features" -Options @("Logging","Caching","Monitoring","Alerts") -MultiSelect

Creates a menu allowing multiple selections via comma-separated input (e.g., "1,2,4").
#>
function Write-Menu {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][array]$Options,
        [ValidateSet('Simple', 'Modern', 'Boxed', 'Compact')] [string]$Style = 'Modern',
        [switch]$AllowEscape,
        [int]$DefaultSelection = 1,
        [switch]$MultiSelect
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

    Write-Host

    # Display title
    switch ($Style) {
        'Simple' {
            Write-Host $Title -ForegroundColor $script:Theme.Accent
            Write-Host ("─" * $Title.Length) -ForegroundColor $script:Theme.Accent
        }
        'Boxed' {
            $titleLine = "┌─ $Title " + ("─" * (50 - $Title.Length - 4)) + "┐"
            Write-Host $titleLine -ForegroundColor $script:Theme.Accent
        }
        default {
            Write-Host "📋 $Title" -ForegroundColor $script:Theme.Accent
            Write-Host ("═" * ($Title.Length + 3)) -ForegroundColor $script:Theme.Accent
        }
    }

    if ($Style -ne 'Simple') { Write-Host }

    # Display options
    for ($i = 0; $i -lt $Options.Count; $i++) {
        $optionNumber = $i + 1
        $option = $Options[$i]
        
        switch ($Style) {
            'Simple' {
                Write-Host "  $optionNumber. $option" -ForegroundColor $script:Theme.Text
            }
            'Modern' {
                $icon = if ($optionNumber -eq $DefaultSelection) { "▶️" } else { "  " }
                Write-Host "$icon $optionNumber. " -ForegroundColor $script:Theme.Accent -NoNewline
                Write-Host $option -ForegroundColor $script:Theme.Text
            }
            'Boxed' {
                Write-Host "│ $optionNumber. $option" -ForegroundColor $script:Theme.Text
            }
            'Compact' {
                Write-Host "[$optionNumber] $option  " -ForegroundColor $script:Theme.Text -NoNewline
            }
        }
    }

    if ($Style -eq 'Boxed') {
        Write-Host "└" + ("─" * 49) + "┘" -ForegroundColor $script:Theme.Accent
    } elseif ($Style -eq 'Compact') {
        Write-Host
    }

    Write-Host

    # Get user selection
    do {
        if ($MultiSelect) {
            Write-Host "Select options (1-$($Options.Count), comma-separated): " -ForegroundColor $script:Theme.Muted -NoNewline
        } elseif ($AllowEscape) {
            Write-Host "Select option (1-$($Options.Count)) or press Esc to cancel: " -ForegroundColor $script:Theme.Muted -NoNewline
        } else {
            Write-Host "Select option (1-$($Options.Count)): " -ForegroundColor $script:Theme.Muted -NoNewline
        }
        
        $selection = Read-Host
        
        if ([string]::IsNullOrWhiteSpace($selection) -and $DefaultSelection -and -not $MultiSelect) {
            $selection = $DefaultSelection
        }
        
        if ($MultiSelect) {
            # Parse comma-separated selections
            $selectedNumbers = @()
            $validSelection = $true
            $parts = $selection -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
            
            if ($parts.Count -eq 0) {
                $validSelection = $false
            } else {
                foreach ($part in $parts) {
                    $num = 0
                    if ([int]::TryParse($part, [ref]$num) -and $num -ge 1 -and $num -le $Options.Count) {
                        if ($num -notin $selectedNumbers) {
                            $selectedNumbers += $num
                        }
                    } else {
                        $validSelection = $false
                        break
                    }
                }
            }
            
            if ($validSelection -and $selectedNumbers.Count -gt 0) {
                Write-Host "✅ Selected: " -ForegroundColor $script:Theme.Success -NoNewline
                $selectedValues = $selectedNumbers | ForEach-Object { $Options[$_ - 1] }
                Write-Host ($selectedValues -join ', ') -ForegroundColor $script:Theme.Text
                Write-Host
                return @{
                    Indices = $selectedNumbers | ForEach-Object { $_ - 1 }
                    Values  = $selectedValues
                    Numbers = $selectedNumbers
                }
            } else {
                Write-Host "❌ Invalid selection. Please enter numbers between 1 and $($Options.Count), separated by commas" -ForegroundColor $script:Theme.Error
            }
        } else {
            # Single selection
            $selectedNumber = 0
            if ([int]::TryParse($selection, [ref]$selectedNumber) -and $selectedNumber -ge 1 -and $selectedNumber -le $Options.Count) {
                Write-Host "✅ Selected: " -ForegroundColor $script:Theme.Success -NoNewline
                Write-Host $Options[$selectedNumber - 1] -ForegroundColor $script:Theme.Text
                Write-Host
                return @{
                    Index  = $selectedNumber - 1
                    Value  = $Options[$selectedNumber - 1]
                    Number = $selectedNumber
                }
            } else {
                Write-Host "❌ Invalid selection. Please enter a number between 1 and $($Options.Count)" -ForegroundColor $script:Theme.Error
            }
        }
    } while ($true)
}

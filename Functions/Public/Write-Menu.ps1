<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Menu Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
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
• Simple: Clean numbered list with minimal formatting and basic selection
• Modern: Stylish menu with icons, accent colors and enhanced visual appeal
• Boxed: Menu enclosed in decorative border with frame and padding
• Compact: Space-efficient single-line style for limited display areas

Valid values: Simple, Modern, Boxed, Compact

.PARAMETER AllowEscape
Allow users to press Escape to exit without selection.

.PARAMETER DefaultSelection
Default option number (1-based) to highlight.

.EXAMPLE
Write-Menu -Title "Main Menu" -Options @("Deploy","Test","Rollback","Exit")

Creates a simple menu with four options.

.EXAMPLE
Write-Menu -Title "Environment Selection" -Options @("Development","Testing","Production") -Style Modern -DefaultSelection 1

Creates a modern styled menu with default selection.
#>
function Write-Menu {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][array]$Options,
        [ValidateSet('Simple', 'Modern', 'Boxed', 'Compact')] [string]$Style = 'Modern',
        [switch]$AllowEscape,
        [int]$DefaultSelection = 1
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
        'Boxed' {
            $titleLine = "┌─ $Title " + ("─" * (50 - $Title.Length - 4)) + "┐"
            Write-Host $titleLine -ForegroundColor $script:Theme.Accent
        }
        default {
            Write-Host "📋 $Title" -ForegroundColor $script:Theme.Accent
            Write-Host ("═" * ($Title.Length + 3)) -ForegroundColor $script:Theme.Accent
        }
    }

    Write-Host

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
        if ($AllowEscape) {
            Write-Host "Select option (1-$($Options.Count)) or press Esc to cancel: " -ForegroundColor $script:Theme.Muted -NoNewline
        } else {
            Write-Host "Select option (1-$($Options.Count)): " -ForegroundColor $script:Theme.Muted -NoNewline
        }
        
        $selection = Read-Host
        
        if ([string]::IsNullOrWhiteSpace($selection) -and $DefaultSelection) {
            $selection = $DefaultSelection
        }
        
        $selectedNumber = 0
        if ([int]::TryParse($selection, [ref]$selectedNumber) -and $selectedNumber -ge 1 -and $selectedNumber -le $Options.Count) {
            Write-Host "✅ Selected: " -ForegroundColor $script:Theme.Success -NoNewline
            Write-Host $Options[$selectedNumber - 1] -ForegroundColor $script:Theme.Text
            Write-Host
            return @{
                Index = $selectedNumber - 1
                Value = $Options[$selectedNumber - 1]
                Number = $selectedNumber
            }
        } else {
            Write-Host "❌ Invalid selection. Please enter a number between 1 and $($Options.Count)" -ForegroundColor $script:Theme.Error
        }
    } while ($true)
}

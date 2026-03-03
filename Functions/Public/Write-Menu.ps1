<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Menu Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          January 30, 2026
Module:        OrionDesign v2.1.0
Category:      Interactive Elements
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates interactive selection menus with keyboard navigation and styling.
Core interactive component providing user choice interfaces with consistent
visual design and intuitive navigation patterns. Includes built-in Exit option
with 'X' key for consistent user experience across all menus.

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
Creates styled interactive menus for user selection with built-in Exit option.

.DESCRIPTION
The Write-Menu function displays a formatted menu with options that users can select from. 
Supports different styles and keyboard navigation. Every menu automatically includes an 
Exit option (selectable with 'X') as the last item for consistent user experience.

.PARAMETER Title
The title of the menu.

.PARAMETER Options
Array of menu options to display. An Exit option is automatically appended.

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

.PARAMETER ExitLabel
Customize the text for the Exit option. Default is 'Exit'.

.EXAMPLE
Write-Menu -Title "Main Menu" -Options @("Deploy","Test","Rollback")

Creates a menu with three options plus an automatic Exit option (X).

.EXAMPLE
Write-Menu -Title "Environment Selection" -Options @("Development","Testing","Production") -Style Modern -DefaultSelection 1

Creates a modern styled menu with default selection and Exit option.

.EXAMPLE
Write-Menu -Title "Select Features" -Options @("Logging","Caching","Monitoring","Alerts") -MultiSelect

Creates a menu allowing multiple selections via comma-separated input (e.g., "1,2,4"), with X to exit.

.EXAMPLE
$result = Write-Menu -Title "Actions" -Options @("Save","Load") -ExitLabel "Cancel"
if ($result.Exit) { Write-Host "User cancelled" }

Creates a menu with custom Exit label and checks if user chose to exit.

.OUTPUTS
Hashtable with the following keys:
- Index: Zero-based index of selection (-1 for Exit)
- Value: The selected option text (or ExitLabel for Exit)
- Number: The selection number (or 'X' for Exit)
- Exit: $true if user selected Exit, not present otherwise

For MultiSelect:
- Indices: Array of zero-based indices
- Values: Array of selected option texts
- Numbers: Array of selection numbers
#>
function Write-Menu {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Default', Position = 0)][string]$Title,
        [Parameter(Mandatory, ParameterSetName = 'Default', Position = 1)][array]$Options,
        [ValidateSet('Simple', 'Modern', 'Boxed', 'Compact')] [string]$Style = 'Modern',
        [switch]$AllowEscape,
        [int]$DefaultSelection = 1,
        [switch]$MultiSelect,
        [string]$ExitLabel = 'Exit',

        [Parameter(Mandatory, ParameterSetName = 'Demo')]
        [switch]$Demo
    )

    if ($Demo) {
        $renderCodeBlock = {
            param([string[]]$Lines)
            $innerWidth = ($Lines | Measure-Object -Property Length -Maximum).Maximum + 4
            $bar = '─' * $innerWidth
            Write-Host '  # Code' -ForegroundColor DarkGray
            Write-Host "  ┌$bar┐" -ForegroundColor DarkGray
            foreach ($line in $Lines) {
                $padded = ("  $line").PadRight($innerWidth)
                Write-Host "  │" -ForegroundColor DarkGray -NoNewline
                Write-Host $padded -ForegroundColor Green -NoNewline
                Write-Host '│' -ForegroundColor DarkGray
            }
            Write-Host "  └$bar┘" -ForegroundColor DarkGray
            Write-Host ''
        }

        $demoOptions  = @('Deploy to Production', 'Run Tests', 'Rollback Changes', 'View Logs')
        $demoTitle    = 'Deployment Menu'

        Write-Host ''
        Write-Host '  Write-Menu Demo' -ForegroundColor Cyan
        Write-Host '  ===============' -ForegroundColor DarkGray
        Write-Host '  (Static preview - actual function accepts keyboard input)' -ForegroundColor DarkGray
        Write-Host ''

        foreach ($style in @('Simple', 'Modern', 'Boxed', 'Compact')) {
            Write-Host "  [Style: $style]" -ForegroundColor Yellow
            Write-Host ''
            & $renderCodeBlock @(
                "`$options = @('Deploy to Production', 'Run Tests', 'Rollback Changes', 'View Logs')",
                "Write-Menu -Title '$demoTitle' -Options `$options -Style $style"
            )

            # Static preview header
            if (Get-Command Write-Separator -ErrorAction SilentlyContinue) {
                try { Write-Separator $demoTitle -Style Thick } catch { Write-Host "=== $demoTitle ==="  }
            } else { Write-Host "=== $demoTitle ===" }

            Write-Host ''
            for ($i = 0; $i -lt $demoOptions.Count; $i++) {
                Write-Host "  $($i+1). $($demoOptions[$i])"
            }
            Write-Host '  X. Exit' -ForegroundColor DarkGray
            Write-Host ''
        }

        return
    }

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

    # Display Exit option with X
    switch ($Style) {
        'Simple' {
            Write-Host "  X. $ExitLabel" -ForegroundColor $script:Theme.Muted
        }
        'Modern' {
            Write-Host "   X. " -ForegroundColor $script:Theme.Muted -NoNewline
            Write-Host $ExitLabel -ForegroundColor $script:Theme.Muted
        }
        'Boxed' {
            Write-Host "│ X. $ExitLabel" -ForegroundColor $script:Theme.Muted
        }
        'Compact' {
            Write-Host "[X] $ExitLabel  " -ForegroundColor $script:Theme.Muted -NoNewline
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
            Write-Host "Select options (1-$($Options.Count), comma-separated, or X to exit): " -ForegroundColor $script:Theme.Muted -NoNewline
        } elseif ($AllowEscape) {
            Write-Host "Select option (1-$($Options.Count), X to exit) or press Esc to cancel: " -ForegroundColor $script:Theme.Muted -NoNewline
        } else {
            Write-Host "Select option (1-$($Options.Count), or X to exit): " -ForegroundColor $script:Theme.Muted -NoNewline
        }
        
        $selection = Read-Host
        
        if ([string]::IsNullOrWhiteSpace($selection) -and $DefaultSelection -and -not $MultiSelect) {
            $selection = $DefaultSelection
        }
        
        # Check for Exit selection
        if ($selection -eq 'X' -or $selection -eq 'x') {
            Write-Host "👋 $ExitLabel" -ForegroundColor $script:Theme.Muted
            Write-Host
            return @{
                Index  = -1
                Value  = $ExitLabel
                Number = 'X'
                Exit   = $true
            }
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
                Write-Host "❌ Invalid selection. Please enter numbers between 1 and $($Options.Count) (comma-separated), or X to exit" -ForegroundColor $script:Theme.Error
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
                Write-Host "❌ Invalid selection. Please enter a number between 1 and $($Options.Count), or X to exit" -ForegroundColor $script:Theme.Error
            }
        }
    } while ($true)
}

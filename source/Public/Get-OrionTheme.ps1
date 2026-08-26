<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Get-OrionTheme Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          February 4, 2026
Module:        OrionDesign v2.1.2
Category:      Configuration
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Retrieves the current OrionDesign theme configuration.
Provides access to theme colors and settings for inspection or modification.

THEME PROPERTIES:
- Accent:   Color for highlights and accents
- Success:  Color for explicit success states (-Status Success)
- Warning:  Color for warning states
- Error:    Color for error states
- Text:     Default text color
- Muted:    Color for secondary/dimmed text
- Action:   Color for Write-Action descriptions
- Result:   Color for Write-ActionResult (auto-detected success)
- Question: Color for Write-Question prompts
- Divider:  Character for separator lines
- UseAnsi:  Boolean for ANSI support

HLD INTEGRATION:
┌─ THEME ACCESS ──┐    ┌─ CONFIGURATION ──┐    ┌─ OUTPUT ─┐
│ Get-OrionTheme  │◄──►│ Current Colors   │───►│ Theme    │
│ • Color Values  │    │ ANSI Settings    │    │ Object   │
│ • ANSI State    │    │ Theme Structure  │    │ Display  │
│ • Full Config   │    │ Active Settings  │    │ Values   │
└─────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Gets the current OrionDesign theme configuration.

.DESCRIPTION
The Get-OrionTheme function returns the current theme settings used by OrionDesign functions.
This includes all color definitions and ANSI settings. Theme can be one of 13 preset themes:

Standard Themes: Default (Cyan accent), Dark (Dark blue/gray), Light (Blue with white background)
Nature Themes: Ocean (Blue/teal marine colors), Forest (Green woodland colors)
Retro/Vintage Themes: OldSchool (Amber monochrome DOS-style), Vintage (Sepia warm tones), Retro80s (Magenta/cyan synthwave)
Tech/Futuristic Themes: Matrix (Green hacker aesthetic), Cyberpunk (Neon cyan/purple)
Artistic Themes: Sunset (Orange/purple gradients), Monochrome (Pure black/white contrast)
Accessibility Themes: HighContrast (Maximum contrast for accessibility)

Theme properties include:
- Accent, Success, Warning, Error: Status colors
- Text, Muted: Text colors
- Action: Color for Write-Action descriptions
- Result: Color for Write-ActionResult output (uses Accent for theme consistency)
- Question: Color for Write-Question prompts
- Divider: Character for separators
- UseAnsi: ANSI escape code support

.EXAMPLE
Get-OrionTheme

Returns the current theme configuration.

.EXAMPLE
$theme = Get-OrionTheme
$theme.Accent = 'Magenta'
Set-OrionTheme -Theme $theme

Gets the theme, modifies the accent color, and applies it.

.EXAMPLE
$currentTheme = Get-OrionTheme
Write-Host "Current accent color: $($currentTheme.Accent)"

Gets the theme and displays the current accent color.

.EXAMPLE
Get-OrionTheme | ConvertTo-Json

Returns the current theme configuration as JSON for easy viewing or export.
#>
function Get-OrionTheme {
    [CmdletBinding()]
    param(
        [switch]$Demo
    )

    if ($Demo) {
        Write-Host ''
        Write-Host '  Get-OrionTheme Demo' -ForegroundColor Cyan
        Write-Host '  ===================' -ForegroundColor DarkGray
        Write-Host ''
        Write-Host '  Returns the current OrionDesign theme as a hashtable.' -ForegroundColor DarkGray
        Write-Host ''
        $t = Get-OrionTheme
        $props = @('Name','Accent','Success','Warning','Error','Text','Muted','Action','Result','Question','Divider','UseAnsi')
        foreach ($prop in $props) {
            $val = $t[$prop]
            Write-Host "  $($prop.PadRight(10)): " -ForegroundColor DarkGray -NoNewline
            Write-Host $val -ForegroundColor Cyan
        }
        Write-Host ''
        Write-Host '  Usage examples:' -ForegroundColor DarkGray
        Write-Host '    Get-OrionTheme                                          # Get current theme' -ForegroundColor Green
        Write-Host '    $t = Get-OrionTheme; $t.Accent = "Magenta"              # Modify a color' -ForegroundColor Green
        Write-Host '    Set-OrionTheme -Preset Ocean                            # Apply a preset' -ForegroundColor Green
        Write-Host ''
        return
    }

    # Initialize theme if not set
    if (-not $script:Theme) {
        $script:Theme = @{
            Name     = 'Default'
            Accent   = 'Cyan'
            Success  = 'Green'
            Warning  = 'Yellow'
            Error    = 'Red'
            Text     = 'White'
            Muted    = 'DarkGray'
            Action   = 'White'       # Color for Write-Action descriptions
            Result   = 'Cyan'        # Default color for Write-ActionResult (uses Accent for visibility)
            Question = 'Yellow'      # Color for Write-Question prompts
            Divider  = '─'
            UseAnsi  = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    return $script:Theme.Clone()
}

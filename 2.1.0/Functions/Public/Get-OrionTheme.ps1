<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Get-OrionTheme Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
Category:      Configuration
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Retrieves the current OrionDesign theme configuration.
Provides access to theme colors and settings for inspection or modification.

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
This includes all color definitions and ANSI settings. Theme can be one of 12 preset themes:

Standard Themes: Default (Blue accent), Dark (Dark blue/gray), Light (Blue with white background)
Nature Themes: Ocean (Blue/teal marine colors), Forest (Green woodland colors)
Retro/Vintage Themes: OldSchool (Amber monochrome DOS-style), Vintage (Sepia warm tones), Retro80s (Magenta/cyan synthwave)
Tech/Futuristic Themes: Matrix (Green hacker aesthetic), Cyberpunk (Neon cyan/purple)
Artistic Themes: Sunset (Orange/purple gradients), Monochrome (Pure black/white contrast)

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
    param()

    # Initialize theme if not set
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

    return $script:Theme.Clone()
}

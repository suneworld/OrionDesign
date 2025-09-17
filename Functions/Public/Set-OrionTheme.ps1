<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Set-OrionTheme Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Configuration
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Sets the OrionDesign theme configuration or applies predefined themes.
Allows customization of colors and visual styling across all OrionDesign functions.

HLD INTEGRATION:
┌─ THEME CONTROL ─┐    ┌─ CONFIGURATION ──┐    ┌─ GLOBAL ──┐
│ Set-OrionTheme  │◄──►│ Color Updates    │───►│ Theme     │
│ • Custom Colors │    │ Preset Themes    │    │ Applied   │
│ • Preset Themes │    │ ANSI Settings    │    │ Module    │
│ • ANSI Control  │    │ Validation       │    │ Wide      │
└─────────────────┘    └──────────────────┘    └───────────┘
================================================================================
#>

<#
.SYNOPSIS
Sets the OrionDesign theme configuration.

.DESCRIPTION
The Set-OrionTheme function allows you to customize the colors and styling used by OrionDesign functions.
You can either provide a custom theme hashtable or use one of the predefined themes.

.PARAMETER Theme
A hashtable containing theme configuration. Should include:
- Accent: Color for highlights and accents
- Success: Color for success states
- Warning: Color for warning states  
- Error: Color for error states
- Text: Default text color
- Muted: Color for secondary text
- Divider: Character for dividers
- UseAnsi: Boolean for ANSI support

.PARAMETER Preset
Use a predefined theme. Valid values:

STANDARD THEMES:
- 'Default' - Standard cyan/green/yellow/red theme
- 'Dark' - Dark theme with muted colors  
- 'Light' - Light theme with darker colors

NATURE THEMES:
- 'Ocean' - Blue-based aquatic theme with wave dividers
- 'Forest' - Green-based nature theme with tree-like elements

RETRO/VINTAGE THEMES:
- 'OldSchool' - Classic amber terminal (DOS/Unix era)
- 'Vintage' - Warm sepia/amber nostalgic feel
- 'Retro80s' - Synthwave magenta/cyan neon pastels

TECH/FUTURISTIC THEMES:
- 'Matrix' - Green-on-black digital rain aesthetic
- 'Cyberpunk' - Futuristic cyan/tech aesthetic

ARTISTIC THEMES:
- 'Sunset' - Orange/magenta warm evening colors
- 'Monochrome' - Grayscale theme for high contrast

.EXAMPLE
Set-OrionTheme -Preset Dark

Applies the dark theme preset.

.EXAMPLE
Set-OrionTheme -Preset Matrix

Applies the Matrix theme with green-on-black hacker aesthetic.

.EXAMPLE  
Set-OrionTheme -Preset Retro80s

Applies the 80s synthwave theme with magenta/cyan neon colors.

.EXAMPLE
Set-OrionTheme -Preset OldSchool

Applies the classic amber terminal theme reminiscent of DOS/Unix systems.

.EXAMPLE
$customTheme = @{
    Accent = 'Magenta'
    Success = 'Green'
    Warning = 'Yellow'
    Error = 'Red'
    Text = 'White'
    Muted = 'Gray'
    UseAnsi = $true
}
Set-OrionTheme -Theme $customTheme

Applies a custom theme configuration.

.EXAMPLE
Set-OrionTheme -Preset Ocean

Applies the ocean theme with blue accents.
#>
function Set-OrionTheme {
    [CmdletBinding()]
    param(
        [hashtable]$Theme,
        [ValidateSet('Default', 'Dark', 'Light', 'Ocean', 'Forest', 'Sunset', 'Monochrome', 'OldSchool', 'Matrix', 'Retro80s', 'Cyberpunk', 'Vintage')]
        [string]$Preset
    )

    if ($Preset) {
        switch ($Preset) {
            'Default' {
                $Theme = @{
                    Accent   = 'Cyan'
                    Success  = 'Green'
                    Warning  = 'Yellow'
                    Error    = 'Red'
                    Text     = 'White'
                    Muted    = 'DarkGray'
                    Divider  = '─'
                    UseAnsi  = $true
                }
            }
            'Dark' {
                $Theme = @{
                    Accent   = 'DarkCyan'
                    Success  = 'DarkGreen'
                    Warning  = 'DarkYellow'
                    Error    = 'DarkRed'
                    Text     = 'Gray'
                    Muted    = 'DarkGray'
                    Divider  = '─'
                    UseAnsi  = $true
                }
            }
            'Light' {
                $Theme = @{
                    Accent   = 'DarkBlue'
                    Success  = 'DarkGreen'
                    Warning  = 'DarkYellow'
                    Error    = 'DarkRed'
                    Text     = 'Black'
                    Muted    = 'DarkGray'
                    Divider  = '─'
                    UseAnsi  = $true
                }
            }
            'Ocean' {
                $Theme = @{
                    Accent   = 'Blue'
                    Success  = 'Cyan'
                    Warning  = 'Yellow'
                    Error    = 'Red'
                    Text     = 'White'
                    Muted    = 'DarkBlue'
                    Divider  = '~'
                    UseAnsi  = $true
                }
            }
            'Forest' {
                $Theme = @{
                    Accent   = 'Green'
                    Success  = 'DarkGreen'
                    Warning  = 'Yellow'
                    Error    = 'Red'
                    Text     = 'White'
                    Muted    = 'DarkGreen'
                    Divider  = '│'
                    UseAnsi  = $true
                }
            }
            'Sunset' {
                $Theme = @{
                    Accent   = 'Magenta'
                    Success  = 'Green'
                    Warning  = 'DarkYellow'
                    Error    = 'DarkRed'
                    Text     = 'Yellow'
                    Muted    = 'DarkMagenta'
                    Divider  = '═'
                    UseAnsi  = $true
                }
            }
            'Monochrome' {
                $Theme = @{
                    Accent   = 'White'
                    Success  = 'Gray'
                    Warning  = 'DarkGray'
                    Error    = 'White'
                    Text     = 'Gray'
                    Muted    = 'DarkGray'
                    Divider  = '─'
                    UseAnsi  = $true
                }
            }
            'OldSchool' {
                $Theme = @{
                    Accent   = 'Yellow'
                    Success  = 'Green'
                    Warning  = 'Yellow'
                    Error    = 'Red'
                    Text     = 'White'
                    Muted    = 'DarkYellow'
                    Divider  = '='
                    UseAnsi  = $true
                }
            }
            'Matrix' {
                $Theme = @{
                    Accent   = 'Green'
                    Success  = 'DarkGreen'
                    Warning  = 'Yellow'
                    Error    = 'Red'
                    Text     = 'Green'
                    Muted    = 'DarkGreen'
                    Divider  = '|'
                    UseAnsi  = $true
                }
            }
            'Retro80s' {
                $Theme = @{
                    Accent   = 'Magenta'
                    Success  = 'Cyan'
                    Warning  = 'Yellow'
                    Error    = 'Red'
                    Text     = 'White'
                    Muted    = 'DarkMagenta'
                    Divider  = '~'
                    UseAnsi  = $true
                }
            }
            'Cyberpunk' {
                $Theme = @{
                    Accent   = 'Cyan'
                    Success  = 'Green'
                    Warning  = 'DarkYellow'
                    Error    = 'DarkRed'
                    Text     = 'Cyan'
                    Muted    = 'DarkCyan'
                    Divider  = '▓'
                    UseAnsi  = $true
                }
            }
            'Vintage' {
                $Theme = @{
                    Accent   = 'DarkYellow'
                    Success  = 'DarkGreen'
                    Warning  = 'DarkYellow'
                    Error    = 'DarkRed'
                    Text     = 'DarkYellow'
                    Muted    = 'DarkGray'
                    Divider  = '·'
                    UseAnsi  = $true
                }
            }
        }
    }

    if (-not $Theme) {
        throw "Either -Theme or -Preset parameter must be specified"
    }

    # Disable ANSI in PowerShell ISE
    if ($psISE) { $Theme.UseAnsi = $false }

    # Apply the theme
    $script:Theme = $Theme.Clone()

    Write-Host "✅ Theme applied successfully!" -ForegroundColor $script:Theme.Success
    Write-Host "Current theme colors:" -ForegroundColor $script:Theme.Text
    Write-Host "  Accent: " -NoNewline -ForegroundColor $script:Theme.Text
    Write-Host "■■■" -ForegroundColor $script:Theme.Accent
    Write-Host "  Success: " -NoNewline -ForegroundColor $script:Theme.Text  
    Write-Host "■■■" -ForegroundColor $script:Theme.Success
    Write-Host "  Warning: " -NoNewline -ForegroundColor $script:Theme.Text
    Write-Host "■■■" -ForegroundColor $script:Theme.Warning
    Write-Host "  Error: " -NoNewline -ForegroundColor $script:Theme.Text
    Write-Host "■■■" -ForegroundColor $script:Theme.Error
    Write-Host "  Text: " -NoNewline -ForegroundColor $script:Theme.Text
    Write-Host "■■■" -ForegroundColor $script:Theme.Text
    Write-Host "  Muted: " -NoNewline -ForegroundColor $script:Theme.Text
    Write-Host "■■■" -ForegroundColor $script:Theme.Muted
}

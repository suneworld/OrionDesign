function Show-OrionDemoThemes {
    <#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Theme Showcase Demo
================================================================================
Author:        Sune Alexandersen Narud  
Date:          September 17, 2025
Module:        OrionDesign v1.5.0
Category:      Theme Demonstration
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Comprehensive showcase of all available OrionDesign themes and color schemes.
Visual demonstration of 12 preset themes across different categories showing
how each theme affects the appearance of UI components.

HLD INTEGRATION:
┌─ THEME SHOWCASE ──┐    ┌─ VISUAL DEMO ────┐    ┌─ OUTPUT ─┐
│ All 12 Presets   │◄──►│ Component Tests  │───►│ Themed   │
│ • Standard        │    │ Color Samples    │    │ Examples │
│ • Nature/Retro    │    │ Live Comparison  │    │ Visual   │
│ • Tech/Artistic   │    │ Real Functions   │    │ Gallery  │
└───────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

    <#
    .SYNOPSIS
    Demonstrates all available OrionDesign themes with visual examples.

    .DESCRIPTION
    Show-OrionDemoThemes provides a comprehensive visual showcase of all 12 preset themes
    available in the OrionDesign module. Each theme is demonstrated with actual UI components
    to show how different color schemes affect the appearance.

    .PARAMETER Interactive
    Pause between each theme for better viewing.

    .PARAMETER Theme
    Display only a specific theme instead of all themes.

    .EXAMPLE
    Show-OrionDemoThemes
    Shows all 12 themes in sequence.

    .EXAMPLE
    Show-OrionDemoThemes -Interactive
    Shows all themes with pauses for better viewing.

    .EXAMPLE
    Show-OrionDemoThemes -Theme Matrix
    Shows only the Matrix theme demonstration.

    .NOTES
    Author: OrionDesign Module
    Version: 1.0.0
    Theme categories: Standard, Nature, Retro/Vintage, Tech/Futuristic, Artistic
    #>
    [CmdletBinding()]
    param(
        [switch]$Interactive,
        [ValidateSet('Default', 'Dark', 'Light', 'Ocean', 'Forest', 'Sunset', 'Monochrome', 'OldSchool', 'Matrix', 'Retro80s', 'Cyberpunk', 'Vintage', 'All')]
        [string]$Theme = 'All'
    )

    function Show-ThemeDemo {
        param(
            [string]$ThemeName,
            [string]$Description,
            [string]$Category
        )
        
        Write-Host
        Write-Host "═══════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host "🎨 THEME: $ThemeName - $Description" -ForegroundColor DarkGray
        Write-Host "   Category: $Category" -ForegroundColor DarkGray
        Write-Host "═══════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host

        # Apply the theme
        Set-OrionTheme -Preset $ThemeName
        
        # Get current theme for reference
        $currentTheme = Get-OrionTheme
        
        # Show color palette
        Write-Host "Color Palette:" -ForegroundColor $currentTheme.Text
        Write-Host "  Accent:  " -NoNewline -ForegroundColor $currentTheme.Text
        Write-Host "████ " -NoNewline -ForegroundColor $currentTheme.Accent
        Write-Host "($($currentTheme.Accent))" -ForegroundColor $currentTheme.Muted
        
        Write-Host "  Success: " -NoNewline -ForegroundColor $currentTheme.Text
        Write-Host "████ " -NoNewline -ForegroundColor $currentTheme.Success
        Write-Host "($($currentTheme.Success))" -ForegroundColor $currentTheme.Muted
        
        Write-Host "  Warning: " -NoNewline -ForegroundColor $currentTheme.Text
        Write-Host "████ " -NoNewline -ForegroundColor $currentTheme.Warning
        Write-Host "($($currentTheme.Warning))" -ForegroundColor $currentTheme.Muted
        
        Write-Host "  Error:   " -NoNewline -ForegroundColor $currentTheme.Text
        Write-Host "████ " -NoNewline -ForegroundColor $currentTheme.Error
        Write-Host "($($currentTheme.Error))" -ForegroundColor $currentTheme.Muted
        
        Write-Host "  Text:    " -NoNewline -ForegroundColor $currentTheme.Text
        Write-Host "████ " -NoNewline -ForegroundColor $currentTheme.Text
        Write-Host "($($currentTheme.Text))" -ForegroundColor $currentTheme.Muted
        
        Write-Host "  Muted:   " -NoNewline -ForegroundColor $currentTheme.Text
        Write-Host "████ " -NoNewline -ForegroundColor $currentTheme.Muted
        Write-Host "($($currentTheme.Muted))" -ForegroundColor $currentTheme.Muted
        
        Write-Host "  Divider: " -NoNewline -ForegroundColor $currentTheme.Text
        Write-Host "'$($currentTheme.Divider)'" -ForegroundColor $currentTheme.Accent

        Write-Host

        # Demonstrate UI components with this theme
        Write-Header -Text "$ThemeName Theme Components" -Underline Full
        
        # Banner example
        Write-Banner -ScriptName "OrionDesign $ThemeName" -Author "Theme Demo" -Design Minimal -Description "Showcasing the $ThemeName color scheme"
        
        # Alerts
        Write-Alert -Message "$ThemeName Success Alert" -Type Success
        Write-Alert -Message "$ThemeName Warning Alert" -Type Warning
        Write-Alert -Message "$ThemeName Error Alert" -Type Error
        Write-Alert -Message "$ThemeName Info Alert" -Type Info
        
        # InfoBox
        Write-InfoBox -Title "$ThemeName Theme" -Content "This InfoBox demonstrates how the $ThemeName theme affects content presentation with its unique color palette." -Style Modern
        
        # Progress bars
        Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Text "$ThemeName Progress" -Style Bar -ShowPercentage
        Write-ProgressBar -CurrentValue 60 -MaxValue 100 -Text "$ThemeName Modern" -Style Modern -ShowPercentage
        
        # ActionResult
        Write-ActionResult -Action "$ThemeName Theme Test" -Status Success -Details "Theme applied successfully with all components"
        
        # Steps
        $steps = @("Load $ThemeName config", "Apply color scheme", "Update components", "Verify appearance")
        Write-Steps -Steps $steps -CurrentStep 3 -CompletedSteps @(1,2) -Style Numbered
        
        # Separator
        Write-Separator -Text "$ThemeName Divider Style" -Style Single
        
        # Panel
        Write-Panel -Title "$ThemeName Panel" -Content @(
            "Theme: $ThemeName",
            "Category: $Category", 
            "Divider: '$($currentTheme.Divider)'",
            "ANSI: $($currentTheme.UseAnsi)"
        ) -Style Box

        if ($Interactive) {
            Write-Host
            Write-Host "Press Enter to continue to next theme..." -ForegroundColor DarkGray
            Read-Host
        }
    }

    # Demo header
    Clear-Host
    Write-Banner -ScriptName "OrionDesign Theme Gallery" -Author "Sune A Narud" -Design Modern -Description "Complete showcase of all available theme presets"

    Write-Host "🎨 " -NoNewline -ForegroundColor Cyan
    Write-Host "Welcome to the OrionDesign Theme Showcase!" -ForegroundColor White
    Write-Host "This demo will show you all 12 available themes across 5 categories." -ForegroundColor Gray
    Write-Host

    # Define all themes with metadata
    $allThemes = @(
        # STANDARD THEMES
        @{ Name = 'Default';   Description = 'Standard cyan/green/yellow/red theme';              Category = 'Standard' },
        @{ Name = 'Dark';      Description = 'Dark theme with muted colors';                      Category = 'Standard' },
        @{ Name = 'Light';     Description = 'Light theme with darker colors on bright background'; Category = 'Standard' },
        
        # NATURE THEMES  
        @{ Name = 'Ocean';     Description = 'Blue-based aquatic theme with wave dividers';       Category = 'Nature' },
        @{ Name = 'Forest';    Description = 'Green-based nature theme with tree-like elements';   Category = 'Nature' },
        
        # RETRO/VINTAGE THEMES
        @{ Name = 'OldSchool'; Description = 'Classic amber terminal (DOS/Unix era)';              Category = 'Retro/Vintage' },
        @{ Name = 'Vintage';   Description = 'Warm sepia/amber nostalgic feel';                   Category = 'Retro/Vintage' },
        @{ Name = 'Retro80s';  Description = 'Synthwave magenta/cyan neon pastels';               Category = 'Retro/Vintage' },
        
        # TECH/FUTURISTIC THEMES
        @{ Name = 'Matrix';    Description = 'Green-on-black digital rain aesthetic';             Category = 'Tech/Futuristic' },
        @{ Name = 'Cyberpunk'; Description = 'Futuristic cyan/purple tech aesthetic';            Category = 'Tech/Futuristic' },
        
        # ARTISTIC THEMES
        @{ Name = 'Sunset';    Description = 'Orange/magenta warm evening colors';                Category = 'Artistic' },
        @{ Name = 'Monochrome'; Description = 'Grayscale theme for high contrast';                Category = 'Artistic' }
    )

    # Show specific theme or all themes
    if ($Theme -ne 'All') {
        $selectedTheme = $allThemes | Where-Object { $_.Name -eq $Theme }
        if ($selectedTheme) {
            Show-ThemeDemo -ThemeName $selectedTheme.Name -Description $selectedTheme.Description -Category $selectedTheme.Category
        } else {
            Write-Host "❌ Theme '$Theme' not found!" -ForegroundColor Red
            return
        }
    } else {
        # Show all themes by category
        $categories = 'Standard', 'Nature', 'Retro/Vintage', 'Tech/Futuristic', 'Artistic'
        
        foreach ($category in $categories) {
            Write-Host
            Write-Host "┌" + ("═" * 80) + "┐" -ForegroundColor Cyan
            Write-Host "│" + " " * 28 + "$category THEMES" + " " * (80 - 28 - "$category THEMES".Length - 1) + "│" -ForegroundColor Cyan
            Write-Host "└" + ("═" * 80) + "┘" -ForegroundColor Cyan
            
            $categoryThemes = $allThemes | Where-Object { $_.Category -eq $category }
            foreach ($themeInfo in $categoryThemes) {
                Show-ThemeDemo -ThemeName $themeInfo.Name -Description $themeInfo.Description -Category $themeInfo.Category
                Write-Host
            }
        }
    }

    # Restore default theme
    Write-Host
    Write-Host "┌" + ("═" * 80) + "┐" -ForegroundColor DarkGray
    Write-Host "│" + " " * 25 + "THEME SHOWCASE COMPLETE" + " " * 32 + "│" -ForegroundColor DarkGray
    Write-Host "└" + ("═" * 80) + "┘" -ForegroundColor DarkGray
    Write-Host
    
    Set-OrionTheme -Preset Default
    Write-Host "🎉 Theme showcase complete! Default theme restored." -ForegroundColor Green
    Write-Host
    Write-Host "Theme Summary:" -ForegroundColor White
    Write-Host "  • 12 total themes across 5 categories" -ForegroundColor Gray
    Write-Host "  • Standard: Default, Dark, Light" -ForegroundColor Gray
    Write-Host "  • Nature: Ocean, Forest" -ForegroundColor Gray  
    Write-Host "  • Retro/Vintage: OldSchool, Vintage, Retro80s" -ForegroundColor Gray
    Write-Host "  • Tech/Futuristic: Matrix, Cyberpunk" -ForegroundColor Gray
    Write-Host "  • Artistic: Sunset, Monochrome" -ForegroundColor Gray
    Write-Host
    Write-Host "📖 Usage Examples:" -ForegroundColor Cyan
    Write-Host "  • Set-OrionTheme -Preset Matrix" -ForegroundColor White
    Write-Host "  • Set-OrionTheme -Preset Retro80s" -ForegroundColor White
    Write-Host "  • Get-OrionTheme | ConvertTo-Json" -ForegroundColor White
    Write-Host "  • Show-OrionDemoThemes -Theme Ocean" -ForegroundColor White
}
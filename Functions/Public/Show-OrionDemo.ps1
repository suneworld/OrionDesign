function Show-OrionDemo {
    <#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Unified Demo Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          January 26, 2026
Module:        OrionDesign v1.6.0
Category:      Demonstration
Dependencies:  All OrionDesign Functions

FUNCTION PURPOSE:
Unified demonstration function for all OrionDesign UI capabilities.
Supports multiple demo modes: Basic, Themes, Interactive, and All (comprehensive).
Replaces the previous separate demo functions with a single parameterized function.

HLD INTEGRATION:
┌─ UNIFIED DEMO ────┐    ┌─ DEMO MODES ───────┐    ┌─ OUTPUT ─┐
│ Show-OrionDemo    │◄──►│ Basic - Functions  │───►│ Examples │
│ • -Demo Basic     │    │ Themes - Colors    │    │ Sections │
│ • -Demo Themes    │    │ Interactive - Menu │    │ Live     │
│ • -Demo Interactive    │ All - Comprehensive│    │ Demo     │
│ • -Demo All       │    │ Section Filtering  │    │ Guide    │
└───────────────────┘    └────────────────────┘    └──────────┘
================================================================================
#>

    <#
    .SYNOPSIS
    Unified demonstration of all OrionDesign UI functions and features.

    .DESCRIPTION
    Show-OrionDemo provides demonstrations of the OrionDesign module functions.
    Use the -Demo parameter to select which type of demo to run:
    
    - Basic: Quick overview of all OrionDesign functions with examples
    - Themes: Comprehensive showcase of all 13 color theme presets
    - Interactive: Hands-on demonstration of Write-Menu and Write-Question
    - All: Complete comprehensive demonstration with all features

    .PARAMETER Demo
    Specifies which demonstration to run.
    - Basic: Quick function overview (default)
    - Themes: All 13 theme presets with visual examples
    - Interactive: Write-Menu and Write-Question with user input
    - All: Comprehensive demo of everything

    .PARAMETER Section
    For 'Basic' and 'All' demos, display only a specific section.
    Valid values: All, Banners, Headers, InfoBoxes, Alerts, Actions, Progress, 
                  Steps, Charts, Panels, Separators, Themes, Width

    .PARAMETER Theme
    For 'Themes' demo, show only a specific theme instead of all themes.
    Valid values: Default, Dark, Light, Ocean, Forest, Sunset, Monochrome, 
                  HighContrast, OldSchool, Matrix, Retro80s, Cyberpunk, Vintage

    .PARAMETER Pause
    Pause between sections for better viewing.

    .PARAMETER SkipClear
    Skip clearing the screen at the start of the demo.

    .EXAMPLE
    Show-OrionDemo
    Runs the basic demonstration of all OrionDesign functions.

    .EXAMPLE
    Show-OrionDemo -Demo Themes
    Shows all 13 theme presets with visual examples.

    .EXAMPLE
    Show-OrionDemo -Demo Interactive
    Runs the interactive demo requiring user input for menus and questions.

    .EXAMPLE
    Show-OrionDemo -Demo All
    Runs the comprehensive demonstration of all features.

    .EXAMPLE
    Show-OrionDemo -Demo All -Section Actions
    Shows only the Actions section of the comprehensive demo.

    .EXAMPLE
    Show-OrionDemo -Demo Themes -Theme Matrix
    Shows only the Matrix theme demonstration.

    .EXAMPLE
    Show-OrionDemo -Demo All -Pause
    Runs the comprehensive demo with pauses between sections.

    .NOTES
    Author: OrionDesign Module
    Version: 1.6.0
    This function replaces the previous separate demo functions:
    - Show-OrionDemo (now -Demo Basic)
    - Show-OrionDemoThemes (now -Demo Themes)
    - Show-OrionDemoInteractiveFunctions (now -Demo Interactive)
    - Show-OrionDemoAll (now -Demo All)
    #>
    [CmdletBinding()]
    param(
        [ValidateSet("Basic", "Themes", "Interactive", "All")]
        [string]$Demo = "Basic",
        
        [ValidateSet("All", "Banners", "Headers", "InfoBoxes", "Alerts", "Actions", "Progress", 
                     "Steps", "Charts", "Panels", "Separators", "Themes", "Width")]
        [string]$Section = "All",
        
        [ValidateSet('Default', 'Dark', 'Light', 'Ocean', 'Forest', 'Sunset', 'Monochrome', 
                     'HighContrast', 'OldSchool', 'Matrix', 'Retro80s', 'Cyberpunk', 'Vintage', 'All')]
        [string]$Theme = 'All',
        
        [switch]$Pause,
        [switch]$SkipClear
    )

    #region Helper Functions
    
    function Demo-Separator {
        param (
            [string]$Text = ""
        )
        Write-Host
        Write-Host
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host "         $Text " -ForegroundColor DarkGray
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host
    }

    function Show-DemoSectionHeader {
        param (
            [string]$Title,
            [string]$Subtitle = "",
            [string]$Icon = ""
        )
        Write-Host
        Write-Host
        Write-Host ("═" * 100) -ForegroundColor DarkCyan
        Write-Host "  $Icon  $Title" -ForegroundColor Cyan
        if ($Subtitle) {
            Write-Host "      $Subtitle" -ForegroundColor DarkGray
        }
        Write-Host ("═" * 100) -ForegroundColor DarkCyan
        Write-Host
    }

    function Show-ExampleHeader {
        param (
            [string]$Text,
            [string]$Code = ""
        )
        Write-Host
        Write-Host ("─" * 100) -ForegroundColor DarkGray
        Write-Host "  > $Text" -ForegroundColor White
        if ($Code) {
            Write-Host "    $Code" -ForegroundColor DarkYellow
        }
        Write-Host ("─" * 100) -ForegroundColor DarkGray
        Write-Host
    }

    function Show-PausePrompt {
        if ($Pause) {
            Write-Host
            Write-Host "  Press any key to continue..." -ForegroundColor DarkGray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }

    function Show-SectionEnd {
        Write-Host
        Write-Host "  Section Complete" -ForegroundColor DarkGreen
        Show-PausePrompt
    }

    function Show-ThemeDemo {
        param(
            [string]$ThemeName,
            [string]$Description,
            [string]$Category
        )
        
        Write-Host
        Write-Host "═══════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host "THEME: $ThemeName - $Description" -ForegroundColor DarkGray
        Write-Host "   Category: $Category" -ForegroundColor DarkGray
        Write-Host "═══════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host

        Set-OrionTheme -Preset $ThemeName
        $currentTheme = Get-OrionTheme
        
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

        Write-Host

        Write-Header -Text "$ThemeName Theme Components" -Underline Full
        Write-Banner -ScriptName "OrionDesign $ThemeName" -Author "Theme Demo" -Design Minimal -Description "Showcasing the $ThemeName color scheme"
        
        Write-Alert -Message "$ThemeName Success Alert" -Type Success
        Write-Alert -Message "$ThemeName Warning Alert" -Type Warning
        Write-Alert -Message "$ThemeName Error Alert" -Type Error
        Write-Alert -Message "$ThemeName Info Alert" -Type Info
        
        Write-InfoBox -Title "$ThemeName Theme" -Content "This InfoBox demonstrates how the $ThemeName theme affects content presentation." -Style Modern
        
        Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Text "$ThemeName Progress" -Style Bar -ShowPercentage
        
        Write-ActionResult -Action "$ThemeName Theme Test" -Status Success -Details "Theme applied successfully"
        
        $steps = @("Load config", "Apply scheme", "Update components", "Verify")
        Write-Steps -Steps $steps -CurrentStep 3 -CompletedSteps @(1,2) -Style Numbered
        
        Write-Panel -Title "$ThemeName Panel" -Content @(
            "Theme: $ThemeName",
            "Category: $Category"
        ) -Style Box

        if ($Pause) {
            Write-Host
            Write-Host "Press Enter to continue..." -ForegroundColor DarkGray
            Read-Host
        }
    }

    #endregion

    #region Basic Demo
    
    function Show-BasicDemo {
        if (-not $SkipClear) { Clear-Host }

        Demo-Separator "Write-Banner -Design Modern"
        Write-Banner -ScriptName "OrionDesign UI Framework" -Author "Sune A Narud" -Design Modern -Description "Complete demonstration of OrionDesign UI functions"

        Demo-Separator "Write-Banner -Design Minimal"
        Write-Banner -ScriptName "OrionDesign UI Framework" -Author "Sune A Narud" -Design Minimal -Description "Complete demonstration of OrionDesign UI functions"

        Demo-Separator "Write-Banner -Design Classic"
        Write-Banner -ScriptName "OrionDesign UI Framework" -Author "Sune A Narud" -Design Classic -Description "Complete demonstration of OrionDesign UI functions"

        Demo-Separator "Write-Banner -Design Diamond"
        Write-Banner -ScriptName "OrionDesign UI Framework" -Author "Sune A Narud" -Design Diamond -Description "Complete demonstration of OrionDesign UI functions"

        Demo-Separator "Write-Banner -Design Geometric"
        Write-Banner -ScriptName "OrionDesign UI Framework" -Author "Sune A Narud" -Design Geometric -Description "Complete demonstration of OrionDesign UI functions"

        Demo-Separator "Write-Banner -Design Wings"
        Write-Banner -ScriptName "OrionDesign UI Framework" -Author "Sune A Narud" -Design Wings -Description "Complete demonstration of OrionDesign UI functions"

        Demo-Separator "Write-Header Examples"
        Write-Header -Text "System Configuration"
        Write-Header -Text "Network Settings" -Underline Full
        Write-Header -Text "ANSI Underlined Header" -Underline Ansi
        Write-Header -Text "Header with No Underline" -Underline None
        Write-Header -Text "Advanced Options" -Number 3
        Write-Header -Text "<accent>Important:</accent> <success>System Ready</success>"
            
        Demo-Separator "Write-InfoBox Styles"
        Write-InfoBox -Title "Classic Style" -Content "System backup completed successfully." -Style Classic
        Write-InfoBox -Title "Modern Style" -Content "New security patches available." -Style Modern
        Write-InfoBox -Title "Accent Style" -Content "Database connection established." -Style Accent
        Write-InfoBox -Title "Simple Style" -Content "Quick informational note." -Style Simple
            
        Demo-Separator "Write-Alert Types"
        Write-Alert -Message "This is a success message!" -Type Success
        Write-Alert -Message "This is a warning message!" -Type Warning
        Write-Alert -Message "This is an error message!" -Type Error
        Write-Alert -Message "This is an info message!" -Type Info

        Demo-Separator "Write-Action + Write-ActionStatus"
        Write-Action "Connecting to database"
        Start-Sleep -Milliseconds 100
        Write-ActionStatus "Connected successfully" -Status Success

        Write-Action "Loading configuration"
        Start-Sleep -Milliseconds 100
        Write-ActionStatus "File not found" -Status Failed

        Write-Action "Processing users"
        Start-Sleep -Milliseconds 100
        Write-ActionStatus "125 users processed"

        Demo-Separator "NEW v1.6.0: Overflow Handling"
        Write-Host "  Normal (fits on one line):" -ForegroundColor Gray
        Write-Action "Short action"
        Write-ActionStatus "Short status" -Status Success
        Write-Host "  Overflow (status on new line):" -ForegroundColor Gray
        Write-Action "This is a very long action description that takes up significant space"
        Write-ActionStatus "This status text causes overflow and moves to a new line" -Status Success

        Demo-Separator "Write-ActionResult"
        Write-ActionResult -Action "Deploy Application" -Status Success -Details "Deployed in 2.3 seconds"
        Write-ActionResult -Action "Deploy Application" -Status Warning -Details "Deployed with warnings"
        Write-ActionResult -Action "Deploy Application" -Status Failed -Details "Deployment failed"
            
        Demo-Separator "Write-ProgressBar Styles"
        Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Text "Bar Style" -Style Bar -ShowPercentage
        Write-ProgressBar -CurrentValue 60 -MaxValue 100 -Text "Dots Style" -Style Dots -ShowPercentage
        Write-ProgressBar -CurrentValue 45 -MaxValue 100 -Text "Modern Style" -Style Modern -ShowPercentage
        Write-ProgressBar -CurrentValue 90 -MaxValue 100 -Text "Spinner Style" -Style Spinner -ShowPercentage

        $steps = @("Validate", "Stop services", "Deploy", "Migrate DB", "Start services")

        Demo-Separator "Write-Steps Styles"
        Write-Steps -Steps $steps -CurrentStep 3 -Style Numbered
        Write-Steps -Steps $steps -CurrentStep 2 -Style Arrows
        Write-Steps -Steps $steps -CurrentStep 4 -Style Progress
        Write-Steps -Steps $steps -CompletedSteps @(1,2) -Style Checklist

        $chartData = @{
            "Web Servers"   = 85
            "Database"      = 92
            "File Storage"  = 67
            "Email Service" = 98
        }

        Demo-Separator "Write-Chart Types"
        Write-Chart -Data $chartData -Title "System Health (%)" -ChartType Bar -ShowValues
        Write-Chart -Data $chartData -Title "System Health (%)" -ChartType Column -ShowValues

        Demo-Separator "Write-Separator Styles"
        Write-Separator -Text "Single" -Style Single
        Write-Separator -Text "Double" -Style Double  
        Write-Separator -Text "Thick" -Style Thick
        Write-Separator -Text "Dotted" -Style Dotted
            
        Demo-Separator "Write-Panel Styles"
        $panelContent = @("OS: Windows Server 2022", "CPU: Intel Xeon", "Memory: 16 GB")
        Write-Panel -Title "Box Style" -Content $panelContent -Style Box
        Write-Panel -Title "Card Style" -Content $panelContent -Style Card

        Demo-Separator "Theme Quick Demo"
        Set-OrionTheme -Preset Matrix
        Write-Alert -Message "Matrix Theme" -Type Success
        Set-OrionTheme -Preset Retro80s
        Write-Alert -Message "Retro80s Theme" -Type Info
        Set-OrionTheme -Preset Default

        Write-Host "`nBasic Demo Complete!" -ForegroundColor Cyan
        Write-Host "  Show-OrionDemo -Demo Themes       - Full theme showcase" -ForegroundColor Gray
        Write-Host "  Show-OrionDemo -Demo Interactive  - Interactive demo" -ForegroundColor Gray
        Write-Host "  Show-OrionDemo -Demo All          - Comprehensive demo" -ForegroundColor Gray
    }

    #endregion

    #region Themes Demo
    
    function Show-ThemesDemo {
        if (-not $SkipClear) { Clear-Host }
        
        Write-Banner -ScriptName "OrionDesign Theme Gallery" -Author "Sune A Narud" -Design Modern -Description "Complete showcase of all available theme presets"

        Write-Host "Welcome to the OrionDesign Theme Showcase!" -ForegroundColor White
        Write-Host "This demo shows all 13 themes across 6 categories." -ForegroundColor Gray
        Write-Host

        $allThemes = @(
            @{ Name = 'Default';      Description = 'Standard cyan/green/yellow/red';        Category = 'Standard' },
            @{ Name = 'Dark';         Description = 'Dark theme with muted colors';          Category = 'Standard' },
            @{ Name = 'Light';        Description = 'Light theme for bright backgrounds';    Category = 'Standard' },
            @{ Name = 'Ocean';        Description = 'Blue-based aquatic theme';              Category = 'Nature' },
            @{ Name = 'Forest';       Description = 'Green-based nature theme';              Category = 'Nature' },
            @{ Name = 'OldSchool';    Description = 'Classic amber terminal';                Category = 'Retro/Vintage' },
            @{ Name = 'Vintage';      Description = 'Warm sepia/amber nostalgic';            Category = 'Retro/Vintage' },
            @{ Name = 'Retro80s';     Description = 'Synthwave magenta/cyan neon';           Category = 'Retro/Vintage' },
            @{ Name = 'Matrix';       Description = 'Green-on-black digital rain';           Category = 'Tech/Futuristic' },
            @{ Name = 'Cyberpunk';    Description = 'Futuristic cyan/purple';                Category = 'Tech/Futuristic' },
            @{ Name = 'Sunset';       Description = 'Orange/magenta warm colors';            Category = 'Artistic' },
            @{ Name = 'Monochrome';   Description = 'Grayscale for high contrast';           Category = 'Artistic' },
            @{ Name = 'HighContrast'; Description = 'Maximum contrast accessibility';        Category = 'Accessibility' }
        )

        if ($Theme -ne 'All') {
            $selectedTheme = $allThemes | Where-Object { $_.Name -eq $Theme }
            if ($selectedTheme) {
                Show-ThemeDemo -ThemeName $selectedTheme.Name -Description $selectedTheme.Description -Category $selectedTheme.Category
            } else {
                Write-Host "Theme '$Theme' not found!" -ForegroundColor Red
                return
            }
        } else {
            $categories = 'Standard', 'Nature', 'Retro/Vintage', 'Tech/Futuristic', 'Artistic', 'Accessibility'
            
            foreach ($category in $categories) {
                Write-Host
                Write-Host ("═" * 80) -ForegroundColor Cyan
                Write-Host "  $category THEMES" -ForegroundColor Cyan
                Write-Host ("═" * 80) -ForegroundColor Cyan
                
                $categoryThemes = $allThemes | Where-Object { $_.Category -eq $category }
                foreach ($themeInfo in $categoryThemes) {
                    Show-ThemeDemo -ThemeName $themeInfo.Name -Description $themeInfo.Description -Category $themeInfo.Category
                }
            }
        }

        Set-OrionTheme -Preset Default
        Write-Host
        Write-Host "Theme showcase complete! Default theme restored." -ForegroundColor Green
        Write-Host
        Write-Host "Usage: Set-OrionTheme -Preset <ThemeName>" -ForegroundColor Cyan
    }

    #endregion

    #region Interactive Demo
    
    function Show-InteractiveDemo {
        if (-not $SkipClear) { Clear-Host }
        
        Write-Banner -ScriptName "OrionDesign Interactive Demo" -Author "Sune A Narud" -Design Modern -Description "Interactive demonstration of Write-Menu and Write-Question"

        Write-Host "Welcome to the Interactive Functions Demo!" -ForegroundColor White
        Write-Host "This requires your participation." -ForegroundColor Gray
        Write-Host

        $continue = Write-Question -Text "Ready to start?" -Type YesNo -Default Yes
        if (-not $continue) {
            Write-Host "Demo cancelled." -ForegroundColor Yellow
            return
        }

        Demo-Separator "Write-Menu -Style Simple"
        $menuResult = Write-Menu -Title "Environment" -Options @("Development", "Testing", "Staging", "Production") -Style Simple
        Write-Host "Selected: $($menuResult.Value)" -ForegroundColor Green

        Demo-Separator "Write-Menu -Style Modern"
        $menuResult = Write-Menu -Title "Action" -Options @("Deploy", "Test", "Logs", "Rollback", "Exit") -Style Modern -DefaultSelection 1
        Write-Host "Selected: $($menuResult.Value)" -ForegroundColor Green

        Demo-Separator "Write-Menu -Style Boxed"
        $menuResult = Write-Menu -Title "Server Management" -Options @("Start", "Stop", "Restart", "Status") -Style Boxed
        Write-Host "Selected: $($menuResult.Value)" -ForegroundColor Green

        Demo-Separator "Write-Menu -Style Compact"
        $menuResult = Write-Menu -Title "Quick Actions" -Options @("Save", "Load", "Reset", "Exit") -Style Compact
        Write-Host "Selected: $($menuResult.Value)" -ForegroundColor Green

        Demo-Separator "Write-Question -Type Text"
        $name = Write-Question -Text "What is your name?" -Default "Developer"
        Write-Host "Hello, $name!" -ForegroundColor Green

        Demo-Separator "Write-Question -Type YesNo"
        $confirm = Write-Question -Text "Continue with deployment?" -Type YesNo -Default Yes
        Write-Host "Result: $(if($confirm){'Yes'}else{'No'})" -ForegroundColor Green

        Demo-Separator "Write-Question -Type Choice"
        $priority = Write-Question -Text "Select priority" -Type Choice -Options @("Low", "Medium", "High", "Critical") -Required
        Write-Host "Priority: $priority" -ForegroundColor Green

        Demo-Separator "Write-Question -Type Secure"
        Write-Host "Note: Input will be masked" -ForegroundColor Yellow
        $password = Write-Question -Text "Enter password" -Type Secure -Required
        Write-Host "Password captured (length: $($password.Length))" -ForegroundColor Green

        Demo-Separator "Interactive Demo Complete"
        Write-Host "You've experienced:" -ForegroundColor White
        Write-Host "  Write-Menu with 4 styles" -ForegroundColor Gray
        Write-Host "  Write-Question with multiple types" -ForegroundColor Gray
    }

    #endregion

    #region Comprehensive Demo (All)
    
    function Show-ComprehensiveDemo {
        if (-not $SkipClear) { Clear-Host }

        Write-Banner -ScriptName "OrionDesign Complete Showcase" -Author "Sune A Narud" -Design Modern -Description "Comprehensive demonstration of all features"

        #region Banners
        if ($Section -eq "All" -or $Section -eq "Banners") {
            Show-DemoSectionHeader -Title "BANNERS - Write-Banner" -Subtitle "6 unique banner designs"

            Show-ExampleHeader "Modern Design" "Write-Banner -Design Modern"
            Write-Banner -ScriptName "Azure Deployment Tool" -Author "Sune A Narud" -Design Modern -Description "Automated cloud deployment"

            Show-ExampleHeader "Minimal Design" "Write-Banner -Design Minimal"
            Write-Banner -ScriptName "System Monitor" -Author "Sune A Narud" -Design Minimal -Description "Performance monitoring"

            Show-ExampleHeader "Classic Design" "Write-Banner -Design Classic"
            Write-Banner -ScriptName "Backup Manager" -Author "Sune A Narud" -Design Classic -Description "Enterprise backup solution"

            Show-ExampleHeader "Diamond Design" "Write-Banner -Design Diamond"
            Write-Banner -ScriptName "Security Scanner" -Author "Sune A Narud" -Design Diamond -Description "Vulnerability assessment"

            Show-ExampleHeader "Geometric Design" "Write-Banner -Design Geometric"
            Write-Banner -ScriptName "Data Processor" -Author "Sune A Narud" -Design Geometric -Description "Data transformation pipeline"

            Show-ExampleHeader "Wings Design" "Write-Banner -Design Wings"
            Write-Banner -ScriptName "Network Analyzer" -Author "Sune A Narud" -Design Wings -Description "Traffic analysis"

            Show-SectionEnd
        }
        #endregion

        #region Headers
        if ($Section -eq "All" -or $Section -eq "Headers") {
            Show-DemoSectionHeader -Title "HEADERS - Write-Header" -Subtitle "Section headers with underline styles and color markup"

            Show-ExampleHeader "Auto Underline (default)" "Write-Header -Text 'Title'"
            Write-Header -Text "System Configuration"

            Show-ExampleHeader "Full Underline" "Write-Header -Underline Full"
            Write-Header -Text "Network Settings" -Underline Full

            Show-ExampleHeader "ANSI Underline" "Write-Header -Underline Ansi"
            Write-Header -Text "ANSI Styled Header" -Underline Ansi

            Show-ExampleHeader "With Number" "Write-Header -Number 3"
            Write-Header -Text "Step Three: Configuration" -Number 3

            Show-ExampleHeader "Color Markup" "Write-Header -Text '<accent>Important:</accent> <success>Ready</success>'"
            Write-Header -Text "<accent>Important:</accent> <success>System Ready</success>"
            Write-Header -Text "<warning>Alert:</warning> <error>Configuration Issue</error>" -Underline Full

            Show-SectionEnd
        }
        #endregion

        #region InfoBoxes
        if ($Section -eq "All" -or $Section -eq "InfoBoxes") {
            Show-DemoSectionHeader -Title "INFOBOXES - Write-InfoBox" -Subtitle "Information display with 4 styles"

            Show-ExampleHeader "Classic Style" "Write-InfoBox -Style Classic"
            Write-InfoBox -Title "System Backup Complete" -Content "All files backed up successfully to remote storage." -Style Classic

            Show-ExampleHeader "Modern Style" "Write-InfoBox -Style Modern"
            Write-InfoBox -Title "Security Update" -Content "New security patch available for installation." -Style Modern

            Show-ExampleHeader "Accent Style" "Write-InfoBox -Style Accent"
            Write-InfoBox -Title "Database Migration" -Content "Migration completed with zero data loss." -Style Accent

            Show-ExampleHeader "Simple Style" "Write-InfoBox -Style Simple"
            Write-InfoBox -Title "Quick Note" -Content "Check logs after deployment." -Style Simple

            Show-SectionEnd
        }
        #endregion

        #region Alerts
        if ($Section -eq "All" -or $Section -eq "Alerts") {
            Show-DemoSectionHeader -Title "ALERTS - Write-Alert" -Subtitle "Color-coded notification messages"

            Show-ExampleHeader "Success Alert" "Write-Alert -Type Success"
            Write-Alert -Message "Deployment completed successfully!" -Type Success

            Show-ExampleHeader "Warning Alert" "Write-Alert -Type Warning"
            Write-Alert -Message "Disk space running low." -Type Warning

            Show-ExampleHeader "Error Alert" "Write-Alert -Type Error"
            Write-Alert -Message "Database connection failed." -Type Error

            Show-ExampleHeader "Info Alert" "Write-Alert -Type Info"
            Write-Alert -Message "Maintenance scheduled for weekend." -Type Info

            Show-SectionEnd
        }
        #endregion

        #region Actions
        if ($Section -eq "All" -or $Section -eq "Actions") {
            Show-DemoSectionHeader -Title "ACTIONS - Write-Action + Write-ActionStatus + Write-ActionResult" -Subtitle "Real-time status reporting"

            Show-ExampleHeader "Write-Action + Write-ActionStatus Pattern"
            
            Write-Action "Connecting to Azure"
            Start-Sleep -Milliseconds 200
            Write-ActionStatus "Connected" -Status Success

            Write-Action "Validating configuration"
            Start-Sleep -Milliseconds 150
            Write-ActionStatus "Valid" -Status Success

            Write-Action "Checking resources"
            Start-Sleep -Milliseconds 200
            Write-ActionStatus "2 conflicts" -Status Warning

            Write-Action "Applying changes"
            Start-Sleep -Milliseconds 150
            Write-ActionStatus "Permission denied" -Status Failed

            Show-ExampleHeader "NEW v1.6.0: Overflow Handling"
            Write-Host "  Normal (fits on line):" -ForegroundColor Gray
            Write-Action "Short action"
            Write-ActionStatus "Short status" -Status Success

            Write-Host "  Overflow (new line):" -ForegroundColor Gray
            Write-Action "This is a very long action description that takes up significant space"
            Write-ActionStatus "This status causes overflow and moves to a new line" -Status Success

            Show-ExampleHeader "Write-ActionResult Examples"
            Write-ActionResult -Action "Deploy Web App" -Status Success -Details "Deployed in 45.2 seconds"
            Write-ActionResult -Action "2,847" -Status Warning -Subtext "files synchronized" -Details "23 files skipped"
            Write-ActionResult -Action "Connect to API" -Status Failed -FailureReason "Connection timeout" -Suggestion "Check firewall"

            Show-SectionEnd
        }
        #endregion

        #region Progress
        if ($Section -eq "All" -or $Section -eq "Progress") {
            Show-DemoSectionHeader -Title "PROGRESS BARS - Write-ProgressBar" -Subtitle "4 visual styles"

            Show-ExampleHeader "Bar Style"
            Write-ProgressBar -CurrentValue 25 -MaxValue 100 -Text "Extracting" -Style Bar -ShowPercentage
            Write-ProgressBar -CurrentValue 50 -MaxValue 100 -Text "Installing" -Style Bar -ShowPercentage
            Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Text "Configuring" -Style Bar -ShowPercentage
            Write-ProgressBar -CurrentValue 100 -MaxValue 100 -Text "Complete" -Style Bar -ShowPercentage

            Show-ExampleHeader "Modern Style"
            Write-ProgressBar -CurrentValue 33 -MaxValue 100 -Text "Phase 1" -Style Modern -ShowPercentage
            Write-ProgressBar -CurrentValue 66 -MaxValue 100 -Text "Phase 2" -Style Modern -ShowPercentage
            Write-ProgressBar -CurrentValue 100 -MaxValue 100 -Text "Phase 3" -Style Modern -ShowPercentage

            Show-ExampleHeader "Dots Style"
            Write-ProgressBar -CurrentValue 20 -MaxValue 100 -Text "file-1.zip" -Style Dots -ShowPercentage
            Write-ProgressBar -CurrentValue 55 -MaxValue 100 -Text "file-2.zip" -Style Dots -ShowPercentage
            Write-ProgressBar -CurrentValue 85 -MaxValue 100 -Text "file-3.zip" -Style Dots -ShowPercentage

            Show-ExampleHeader "Spinner Style"
            Write-ProgressBar -CurrentValue 100 -MaxValue 100 -Text "Compile" -Style Spinner -ShowPercentage
            Write-ProgressBar -CurrentValue 45 -MaxValue 100 -Text "Package" -Style Spinner -ShowPercentage

            Show-SectionEnd
        }
        #endregion

        #region Steps
        if ($Section -eq "All" -or $Section -eq "Steps") {
            Show-DemoSectionHeader -Title "STEPS - Write-Steps" -Subtitle "4 visualization styles"

            $steps = @("Validate", "Backup", "Deploy", "Migrate", "Test", "Switch")

            Show-ExampleHeader "Numbered Style"
            Write-Steps -Steps $steps -CurrentStep 3 -Style Numbered

            Show-ExampleHeader "Arrows Style"
            Write-Steps -Steps $steps -CurrentStep 4 -Style Arrows

            Show-ExampleHeader "Progress Style"
            Write-Steps -Steps $steps -CurrentStep 5 -Style Progress

            Show-ExampleHeader "Checklist Style"
            Write-Steps -Steps $steps -CompletedSteps @(1,2,3) -Style Checklist

            Show-SectionEnd
        }
        #endregion

        #region Charts
        if ($Section -eq "All" -or $Section -eq "Charts") {
            Show-DemoSectionHeader -Title "CHARTS - Write-Chart" -Subtitle "4 chart types"

            $chartData = @{
                "Web Servers"   = 85
                "Database"      = 92
                "File Storage"  = 67
                "Email"         = 98
                "Backup"        = 74
            }

            Show-ExampleHeader "Bar Chart"
            Write-Chart -Data $chartData -Title "System Health (%)" -ChartType Bar -ShowValues

            Show-ExampleHeader "Column Chart"
            Write-Chart -Data $chartData -Title "System Health (%)" -ChartType Column -ShowValues

            Show-ExampleHeader "Line Chart"
            Write-Chart -Data $chartData -Title "System Health (%)" -ChartType Line -ShowValues

            Show-ExampleHeader "Pie Chart"
            Write-Chart -Data $chartData -Title "System Health (%)" -ChartType Pie -ShowValues

            Show-SectionEnd
        }
        #endregion

        #region Panels
        if ($Section -eq "All" -or $Section -eq "Panels") {
            Show-DemoSectionHeader -Title "PANELS - Write-Panel" -Subtitle "5 visual styles"

            $content = @("OS: Windows Server 2022", "CPU: Intel Xeon", "Memory: 16 GB", "Storage: 500 GB SSD")

            Show-ExampleHeader "Box Style"
            Write-Panel -Title "System Info" -Content $content -Style Box

            Show-ExampleHeader "Card Style"
            Write-Panel -Title "System Info" -Content $content -Style Card

            Show-ExampleHeader "Left Style"
            Write-Panel -Title "System Info" -Content $content -Style Left

            Show-ExampleHeader "Minimal Style"
            Write-Panel -Title "System Info" -Content $content -Style Minimal

            Show-ExampleHeader "Top Style"
            Write-Panel -Title "System Info" -Content $content -Style Top

            Show-SectionEnd
        }
        #endregion

        #region Separators
        if ($Section -eq "All" -or $Section -eq "Separators") {
            Show-DemoSectionHeader -Title "SEPARATORS - Write-Separator" -Subtitle "Visual dividers"

            Show-ExampleHeader "All Separator Styles"
            Write-Separator -Text "Single" -Style Single
            Write-Separator -Text "Double" -Style Double
            Write-Separator -Text "Thick" -Style Thick
            Write-Separator -Text "Dotted" -Style Dotted
            Write-Separator -Text "Centered" -Style Double -Center

            Show-SectionEnd
        }
        #endregion

        #region Width
        if ($Section -eq "All" -or $Section -eq "Width") {
            Show-DemoSectionHeader -Title "WIDTH CONTROL - Set-OrionMaxWidth" -Subtitle "50-200 characters"

            Show-ExampleHeader "Width Examples"
            Write-Host "  Current: $(Get-OrionMaxWidth) chars" -ForegroundColor Cyan

            Set-OrionMaxWidth -Width 70
            Write-ActionResult -Action "Narrow (70)" -Status Warning -Details "Constrained width"

            Set-OrionMaxWidth -Width 100
            Write-ActionResult -Action "Default (100)" -Status Success -Details "Standard width"

            Set-OrionMaxWidth -Width 120
            Write-ActionResult -Action "Wide (120)" -Status Info -Details "Extended width"

            Set-OrionMaxWidth -Reset
            Write-Host "  Reset to: $(Get-OrionMaxWidth)" -ForegroundColor Gray

            Show-SectionEnd
        }
        #endregion

        # Completion
        Write-Separator -Text "DEMONSTRATION COMPLETE" -Style Double -Center

        Write-Panel -Title "OrionDesign Framework Summary" -Content @(
            "Functions Demonstrated: 20+",
            "Visual Styles: 30+ variations",
            "Theme Presets: 13 color schemes",
            "",
            "Usage:",
            "   Show-OrionDemo                      - Basic demo",
            "   Show-OrionDemo -Demo Themes         - Theme showcase",
            "   Show-OrionDemo -Demo Interactive    - Interactive demo",
            "   Show-OrionDemo -Demo All            - This comprehensive demo"
        )

        Write-Host
        Write-Host "  Thank you for exploring OrionDesign!" -ForegroundColor Cyan
    }

    #endregion

    # Route to appropriate demo
    switch ($Demo) {
        "Basic"       { Show-BasicDemo }
        "Themes"      { Show-ThemesDemo }
        "Interactive" { Show-InteractiveDemo }
        "All"         { Show-ComprehensiveDemo }
    }
}

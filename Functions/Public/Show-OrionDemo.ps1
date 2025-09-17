function Show-OrionDemo {
    <#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Show-OrionDemo Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Demonstration
Dependencies:  All OrionDesign Functions

FUNCTION PURPOSE:
Comprehensive demonstration of all OrionDesign UI functions with examples.
Showcase function that demonstrates the complete capabilities of the framework
with realistic scenarios and beautiful formatting across all categories.

HLD INTEGRATION:
┌─ DEMONSTRATION ─┐    ┌─ ALL CATEGORIES ─┐    ┌─ OUTPUT ─┐
│ Show-OrionDemo  │◄──►│ Information      │───►│ Examples │
│ • All Functions │    │ Status Results   │    │ Sections │
│ • Interactive   │    │ Data Presentation│    │ Live     │
│ • Sectioned     │    │ Interactive      │    │ Demo     │
│ • Examples      │    │ Layout Format    │    │ Guide    │
└─────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

    <#
    .SYNOPSIS
    Demonstrates all OrionDesign UI functions with beautiful examples.

    .DESCRIPTION
    Show-OrionDemo provides a comprehensive demonstration of all OrionDesign module functions,
    showcasing their capabilities with realistic examples and beautiful formatting.

    .PARAMETER Interactive
    Run in interactive mode with pauses between sections for better viewing.

    .PARAMETER Section
    Display only a specific section of the demo.

    .EXAMPLE
    Show-OrionDemo
    Runs the complete demonstration of all OrionDesign functions.

    .EXAMPLE
    Show-OrionDemo -Interactive
    Runs the demo with pauses between sections for better viewing.

    .EXAMPLE
    Show-OrionDemo -Section "Information"
    Shows only the information display functions demo.

    .NOTES
    Author: OrionDesign Module
    Version: 1.0.0
    #>
    [CmdletBinding()]
    param(
        [switch]$Interactive,
        [ValidateSet("All", "Information", "Status", "Data", "Interactive", "Layout", "Configuration")]
        [string]$Section = "All"
    )



    function Demo-Separator {
        param (
            [string]$Text = "",
            [string]$Style = "Single"
        )
        Write-Host
        Write-Host
        Write-Host
        Write-Host
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host "         $Text " -ForegroundColor DarkGray
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    }

    # Demo header
    Clear-Host

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

    Demo-Separator "Write-Header (default Auto underline)"
    Write-Header -Text "System Configuration"

    Demo-Separator "Write-Header -Underline Full"
    Write-Header -Text "Network Settings (underline full)" -Underline Full

    Demo-Separator "Write-Header -Underline Ansi"
    Write-Header -Text "ANSI Underlined Header" -Underline Ansi

    Demo-Separator "Write-Header -Underline None"
    Write-Header -Text "Header with No Underline" -Underline None

    Demo-Separator "Write-Header -Number 3"
    Write-Header -Text "Advanced Options (number 3)" -Number 3

    Demo-Separator "Write-Header with Color Markup"
    Write-Header -Text "<accent>Important:</accent> <success>System Ready</success>"

    Demo-Separator "Write-Header with Warning Colors"
    Write-Header -Text "<warning>Alert:</warning> <error>Configuration Issue</error>" -Underline Full

    Demo-Separator "Write-Header with Partial Underline Markup"
    Write-Header -Text "This has <underline>partial underline</underline> text" -Underline None

    Demo-Separator "Write-Header Complex Example"
    Write-Header -Text "<accent>Phase 2:</accent> <underline><success>Processing Complete</success></underline>" -Number 2 -Underline None

    Demo-Separator "Write-Header with Muted Text"
    Write-Header -Text "<text>Status:</text> <muted>Background Operations</muted>" -Underline Auto
        
    Demo-Separator "Write-InfoBox -Style Classic"
    Write-InfoBox -Title "System Backup" -Content "System backup completed successfully. All files have been archived to the remote location." -Style Classic

    Demo-Separator "Write-InfoBox -Style Modern"
    Write-InfoBox -Title "Security Patches" -Content "New security patches are available for installation. Please schedule a maintenance window." -Style Modern

    Demo-Separator "Write-InfoBox -Style Accent"
    Write-InfoBox -Title "Database Status" -Content "Database connection established. Ready to proceed with data migration." -Style Accent

    Demo-Separator "Write-InfoBox -Style Simple"
    Write-InfoBox -Title "Database Status" -Content "Database connection established. Ready to proceed with data migration." -Style Simple
        
    Demo-Separator "Write-Alert -Type Warning"
    Write-Alert -Message "This is a warning" -Type Warning

    Demo-Separator "Write-Alert -Type Error"
    Write-Alert -Message "This is an error message!" -Type Error
    
    Demo-Separator "Write-Alert -Type Info"
    Write-Alert -Message "This is an info message!" -Type Info

    Demo-Separator "Write-Alert -Type Success"
    Write-Alert -Message "This is a success message!" -Type Success

    Demo-Separator "Write-Action + Write-ActionStatus (Success)"
    Write-Action "Connecting to database"
    Start-Sleep -Milliseconds 500  # Simulate work
    Write-ActionStatus "Connected successfully" -Status Success

    Demo-Separator "Write-Action + Write-ActionStatus (Failed)"
    Write-Action "Loading configuration file"
    Start-Sleep -Milliseconds 300  # Simulate work
    Write-ActionStatus "File not found" -Status Failed

    Demo-Separator "Write-Action + Write-ActionStatus (Warning)"
    Write-Action "Checking disk space"
    Start-Sleep -Milliseconds 400  # Simulate work
    Write-ActionStatus "Low disk space warning" -Status Warning

    Demo-Separator "Write-Action + Write-ActionStatus (Auto-detection)"
    Write-Action "Processing users"
    Start-Sleep -Milliseconds 600  # Simulate work
    Write-ActionStatus "125 users processed" # Auto-detects as Success

    Demo-Separator "Write-Action + Write-ActionStatus (Custom Width)"
    Write-Action "Very long action description that demonstrates width control" -Width 40
    Start-Sleep -Milliseconds 350  # Simulate work
    Write-ActionStatus "Completed" -Status Success

    Demo-Separator "Write-Action + Write-ActionStatus (No Icon)"
    Write-Action "Silent operation"
    Start-Sleep -Milliseconds 250  # Simulate work
    Write-ActionStatus "Operation completed" -Status Success -NoIcon

    Demo-Separator "Write-ActionResult -Status Success"
    Write-ActionResult -Action "Deploy Application (action)" -Status Success -Details "Deployed to production environment in 2.3 seconds (details)"

    Demo-Separator "Write-ActionResult -Status Warning"
    Write-ActionResult -Action "Deploy Application (action)" -Status Warning -Details "Deployed to production environment in 2.3 seconds (details)"

    Demo-Separator "Write-ActionResult -Status Failed"
    Write-ActionResult -Action "Deploy Application (action)" -Status Failed -Details "Deployed to production environment in 2.3 seconds (details)"

    Demo-Separator "Write-ActionResult -Status Info"
    Write-ActionResult -Action "Deploy Application (action)" -Status Info -Details "Deployed to production environment in 2.3 seconds (details)"
        
    Demo-Separator "Write-Progress -Style Bar"
    Write-Progress -CurrentValue 25 -MaxValue 100 -Text "Installing Updates" -Style Bar -ShowPercentage
    Write-Progress -CurrentValue 50 -MaxValue 100 -Text "Downloading Packages" -Style Bar -ShowPercentage
    Write-Progress -CurrentValue 67 -MaxValue 100 -Text "Copying Files" -Style Bar -ShowPercentage  
    Write-Progress -CurrentValue 90 -MaxValue 100 -Text "Compressing Data" -Style Bar -ShowPercentage
        

    Demo-Separator "Write-Progress -Style Blocks"
    Write-Progress -CurrentValue 25 -MaxValue 100 -Text "Installing Updates" -Style Blocks -ShowPercentage
    Write-Progress -CurrentValue 50 -MaxValue 100 -Text "Downloading Packages" -Style Blocks -ShowPercentage
    Write-Progress -CurrentValue 67 -MaxValue 100 -Text "Copying Files" -Style Blocks -ShowPercentage
    Write-Progress -CurrentValue 90 -MaxValue 100 -Text "Compressing Data" -Style Blocks -ShowPercentage

    Demo-Separator "Write-Progress -Style Dots"
    Write-Progress -CurrentValue 25 -MaxValue 100 -Text "Installing Updates" -Style Dots -ShowPercentage
    Write-Progress -CurrentValue 50 -MaxValue 100 -Text "Downloading Packages" -Style Dots -ShowPercentage
    Write-Progress -CurrentValue 67 -MaxValue 100 -Text "Copying Files" -Style Dots -ShowPercentage
    Write-Progress -CurrentValue 90 -MaxValue 100 -Text "Compressing Data" -Style Dots -ShowPercentage

    Demo-Separator "Write-Progress -Style Modern"
    Write-Progress -CurrentValue 25 -MaxValue 100 -Text "Installing Updates" -Style Modern -ShowPercentage
    Write-Progress -CurrentValue 50 -MaxValue 100 -Text "Downloading Packages" -Style Modern -ShowPercentage
    Write-Progress -CurrentValue 67 -MaxValue 100 -Text "Copying Files" -Style Modern -ShowPercentage
    Write-Progress -CurrentValue 90 -MaxValue 100 -Text "Compressing Data" -Style Modern -ShowPercentage

    Demo-Separator "Write-Progress -Style Spinner"
    Write-Progress -CurrentValue 25 -MaxValue 100 -Text "Installing Updates" -Style Spinner -ShowPercentage
    Write-Progress -CurrentValue 50 -MaxValue 100 -Text "Downloading Packages" -Style Spinner -ShowPercentage
    Write-Progress -CurrentValue 67 -MaxValue 100 -Text "Copying Files" -Style Spinner -ShowPercentage
    Write-Progress -CurrentValue 90 -MaxValue 100 -Text "Compressing Data" -Style Spinner -ShowPercentage

    $deploySteps = @(
        "Validate configuration files",
        "Stop application services", 
        "Deploy new version",
        "Update database schema",
        "Start services and verify"
    )

    Demo-Separator "Write-Steps -Style Numbered (default)"
    Write-Steps -Steps $deploySteps -CurrentStep 3

    Demo-Separator "Write-Steps -Style Arrows"
    Write-Steps -Steps $deploySteps -CurrentStep 2 -Style Arrows

    Demo-Separator "Write-Steps -Style Progress"
    Write-Steps -Steps $deploySteps -CurrentStep 4 -Style Progress

    Demo-Separator "Write-Steps -Style Checklist"
    Write-Steps -Steps $deploySteps -CompletedSteps @(1,2) -Style Checklist

    Demo-Separator "Write-Steps with CompletedSteps"
    Write-Steps -Steps $deploySteps -CurrentStep 4 -CompletedSteps @(1,2,3) -Style Numbered

    Demo-Separator "Write-Steps with Hashtable Status"
    $statusSteps = @(
        @{Text="Connect to Database"; Status="Complete"},
        @{Text="Backup Current Data"; Status="Complete"},
        @{Text="Apply Schema Changes"; Status="Current"},
        @{Text="Test Connections"; Status="Pending"},
        @{Text="Update Documentation"; Status="Pending"}
    )
    Write-Steps -Steps $statusSteps -Style Progress

    $chartData = @{
        "Web Servers"   = 85
        "Database"      = 92
        "File Storage"  = 67
        "Email Service" = 98
        "Backup System" = 74
    }

    Demo-Separator "Write-Chart -ChartType Bar"
    Write-Chart -Data $chartData -Title "System Health Metrics (%)" -ChartType Bar -ShowValues

    Demo-Separator "Write-Chart -ChartType Column"
    Write-Chart -Data $chartData -Title "System Health Metrics (%)" -ChartType Column -ShowValues
    
    Demo-Separator "Write-Chart -ChartType Line"
    Write-Chart -Data $chartData -Title "System Health Metrics (%)" -ChartType Line -ShowValues
  
    Demo-Separator "Write-Chart -ChartType Pie"
    Write-Chart -Data $chartData -Title "System Health Metrics (%)" -ChartType Pie -ShowValues

    Demo-Separator "Write-Separator -Style [NONE]"
    Write-Separator  # Empty separator
        
    Demo-Separator "Write-Separator -Style Single"
    Write-Separator -Text "Single Line Style" -Style Single

    Demo-Separator "Write-Separator -Style Double"
    Write-Separator -Text "Double Line Style" -Style Double  

    Demo-Separator "Write-Separator -Style Thick"
    Write-Separator -Text "Thick Style" -Style Thick

    Demo-Separator "Write-Separator -Style Dotted"
    Write-Separator -Text "Dotted Style" -Style Dotted

        
    Demo-Separator "Write-Panel -Style Box"
    Write-Panel -Title "System Information" -Content @(
        "OS: Windows Server 2022",
        "CPU: Intel Xeon E5-2686 v4",
        "Memory: 16 GB DDR4",
        "Storage: 500 GB SSD"
    ) -Style Box
    

    Demo-Separator "Write-Panel -Style Card"
    Write-Panel -Title "System Information" -Content @(
        "OS: Windows Server 2022",
        "CPU: Intel Xeon E5-2686 v4",
        "Memory: 16 GB DDR4",
        "Storage: 500 GB SSD"
    ) -Style Card

    Demo-Separator "Write-Panel -Style Left"
    Write-Panel -Title "System Information" -Content @(
        "OS: Windows Server 2022",
        "CPU: Intel Xeon E5-2686 v4",
        "Memory: 16 GB DDR4",
        "Storage: 500 GB SSD"
    ) -Style Left

    Demo-Separator "Write-Panel -Style Minimal"
    Write-Panel -Title "System Information" -Content @(
        "OS: Windows Server 2022",
        "CPU: Intel Xeon E5-2686 v4",
        "Memory: 16 GB DDR4",
        "Storage: 500 GB SSD"
    ) -Style Minimal

    Demo-Separator "Write-Panel -Style Top"
    Write-Panel -Title "System Information" -Content @(
        "OS: Windows Server 2022",
        "CPU: Intel Xeon E5-2686 v4",
        "Memory: 16 GB DDR4",
        "Storage: 500 GB SSD"
    ) -Style Top        

    Demo-Separator "Get-OrionTheme (Current Theme)"
    $currentTheme = Get-OrionTheme
    Write-Host "Current theme settings:" -ForegroundColor $currentTheme.Text
    Write-Host "  Accent: " -NoNewline -ForegroundColor $currentTheme.Text
    Write-Host "██" -ForegroundColor $currentTheme.Accent -NoNewline
    Write-Host " ($($currentTheme.Accent))" -ForegroundColor $currentTheme.Muted
    Write-Host "  Success: " -NoNewline -ForegroundColor $currentTheme.Text
    Write-Host "██" -ForegroundColor $currentTheme.Success -NoNewline
    Write-Host " ($($currentTheme.Success))" -ForegroundColor $currentTheme.Muted
    Write-Host "  Warning: " -NoNewline -ForegroundColor $currentTheme.Text
    Write-Host "██" -ForegroundColor $currentTheme.Warning -NoNewline
    Write-Host " ($($currentTheme.Warning))" -ForegroundColor $currentTheme.Muted
    Write-Host "  Error: " -NoNewline -ForegroundColor $currentTheme.Text
    Write-Host "██" -ForegroundColor $currentTheme.Error -NoNewline
    Write-Host " ($($currentTheme.Error))" -ForegroundColor $currentTheme.Muted

    Demo-Separator "Set-OrionTheme -Preset Dark"
    Set-OrionTheme -Preset Dark
    Write-Header -Text "Dark Theme Example" -Underline Auto
    Write-Alert -Message "This alert uses the Dark theme colors" -Type Warning

    Demo-Separator "Set-OrionTheme -Preset Matrix"
    Set-OrionTheme -Preset Matrix
    Write-Header -Text "Matrix Theme Example" -Underline Auto
    Write-Alert -Message "Welcome to the Matrix" -Type Success

    Demo-Separator "Set-OrionTheme -Preset Retro80s"
    Set-OrionTheme -Preset Retro80s
    Write-Header -Text "Retro80s Theme Example" -Underline Auto
    Write-Alert -Message "Synthwave vibes activated!" -Type Info

    Demo-Separator "Set-OrionTheme -Preset Default (Restored)"
    Set-OrionTheme -Preset Default
    Write-Header -Text "Back to Default Theme" -Underline Auto

    Demo-Separator "Width Control Demonstration"

    Write-Host "Current max width: $(Get-OrionMaxWidth) characters"

    Write-Host "Demonstrating width control:"
        
    # Show current width
    Write-ActionResult -Action "Current Width Test" -Status Info -Details "This demonstrates the current maximum width setting for all OrionDesign functions"
        
    # Test narrow width
    Write-Host "`nSetting narrow width (70 characters):"
    Set-OrionMaxWidth -Width 70
    Write-ActionResult -Action "Narrow Width Test" -Status Warning -Details "This demonstrates how content is automatically truncated when using a narrow maximum width setting to prevent overly long output"
        
    # Test wide width  
    Write-Host "`nSetting wide width (120 characters):"
    Set-OrionMaxWidth -Width 120
    Write-ActionResult -Action "Wide Width Test" -Status Success -Details "This demonstrates how content can display fully when using a wide maximum width setting, allowing for more detailed information to be shown without truncation"
        
    # Reset to default
    Write-Host "`nResetting to default width:"
    Set-OrionMaxWidth -Reset
    Write-ActionResult -Action "Default Width Restored" -Status Success -Details "Maximum width has been reset to the default 100 characters for optimal display" 
    
    Write-Host "`n📖 For more information:" -ForegroundColor Cyan
    Write-Host "  • Get-Help <FunctionName> -Full" -ForegroundColor White
    Write-Host "  • Show-OrionDesignHelp" -ForegroundColor White
    Write-Host "  • Import-Module OrionDesign" -ForegroundColor White

}
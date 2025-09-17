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

    Demo-Separator "Write-Header"
    Write-Header -Text "System Configuration"

    Demo-Separator "Write-Header -Underline Full"
    Write-Header -Text "Network Settings (underline full)" -Underline Full

    Demo-Separator "Write-Header -Number 3"
    Write-Header -Text "Advanced Options (number 3)" -Number 3
        
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



    Demo-Separator "Write-ActionResult -Status Success"
    Write-ActionResult -Action "Deploy Application (action)" -Status Success -Details "Deployed to production environment in 2.3 seconds (details)"

    Demo-Separator "Write-ActionResult -Status Warning"
    Write-ActionResult -Action "Deploy Application (action)" -Status Warning -Details "Deployed to production environment in 2.3 seconds (details)"

    Demo-Separator "Write-ActionResult -Status Failed"
    Write-ActionResult -Action "Deploy Application (action)" -Status Failed -Details "Deployed to production environment in 2.3 seconds (details)"

    Demo-Separator "Write-ActionResult -Status Info"
    Write-ActionResult -Action "Deploy Application (action)" -Status Info -Details "Deployed to production environment in 2.3 seconds (details)"
        
        
    Write-Host "`n📈 Write-Progress Examples:" -ForegroundColor Cyan
    
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



    Demo-Separator "Write-Steps -CurrentStep 3"

    Write-Host "`n🔢 Write-Steps Examples:" -ForegroundColor Cyan
    $deploySteps = @(
        "Validate configuration files",
        "Stop application services", 
        "Deploy new version",
        "Update database schema",
        "Start services and verify"
    )
    Write-Steps -Steps $deploySteps -CurrentStep 3

    Demo-Separator "Write-Steps -CurrentStep 4"
    Write-Steps -Steps $deploySteps -CurrentStep 4

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

        
    Write-Host "`n📦 Write-Panel Examples:" -ForegroundColor Cyan
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


    Demo-Separator "Width Control Examples"
        
    Write-Host "Current max width: $(Get-OrionMaxWidth) characters" -ForegroundColor White
        
    Write-Host "Demonstrating width control:" -ForegroundColor Yellow
        
    # Show current width
    Write-ActionResult -Action "Current Width Test" -Status Info -Details "This demonstrates the current maximum width setting for all OrionDesign functions"
        
    # Test narrow width
    Write-Host "`nSetting narrow width (70 characters):" -ForegroundColor Yellow
    Set-OrionMaxWidth -Width 70
    Write-ActionResult -Action "Narrow Width Test" -Status Warning -Details "This demonstrates how content is automatically truncated when using a narrow maximum width setting to prevent overly long output"
        
    # Test wide width  
    Write-Host "`nSetting wide width (120 characters):" -ForegroundColor Yellow
    Set-OrionMaxWidth -Width 120
    Write-ActionResult -Action "Wide Width Test" -Status Success -Details "This demonstrates how content can display fully when using a wide maximum width setting, allowing for more detailed information to be shown without truncation"
        
    # Reset to default
    Write-Host "`nResetting to default width:" -ForegroundColor Yellow
    Set-OrionMaxWidth -Reset
    Write-ActionResult -Action "Default Width Restored" -Status Success -Details "Maximum width has been reset to the default 100 characters for optimal display"

  
    
    Write-Host "`n📖 For more information:" -ForegroundColor Cyan
    Write-Host "  • Get-Help <FunctionName> -Full" -ForegroundColor White
    Write-Host "  • Show-OrionDesignHelp" -ForegroundColor White
    Write-Host "  • Import-Module OrionDesign" -ForegroundColor White
   

}
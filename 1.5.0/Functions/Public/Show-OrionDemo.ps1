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



    # Demo header
    Clear-Host
    Write-Banner -ScriptName "OrionDesign UI Framework" -Author "Sune A Narud" -Design Modern -Description "Complete demonstration of all 19 beautiful UI functions"
    
    Write-Host "`n🎨 Welcome to the OrionDesign demonstration!" -ForegroundColor Cyan
    Write-Host "This showcase will display all available functions with realistic examples." -ForegroundColor White
    
    

    # Section 1: Information Display Functions
    Write-Separator -Text "📝 Information Display Functions" -Style Double
        
    Write-Host "`n🎯 Write-Banner Examples:" -ForegroundColor Cyan
    Write-Banner -ScriptName "Data Migration Tool (classic design)" -Author "IT Department" -Design Classic
    Start-Sleep -Milliseconds 300
    Write-Banner -ScriptName "Security Audit (modern design)" -Author "Security Team" -Design Modern -Description "Automated vulnerability assessment"
    Start-Sleep -Milliseconds 300
    Write-Banner -ScriptName "Backup System (minimal design)" -Author "Admin" -Design Minimal

        
        
    Write-Host "`n📋 Write-Header Examples:" -ForegroundColor Cyan
    Write-Header -Text "System Configuration"
    Write-Header -Text "Network Settings (underline full)" -Underline Full
    Write-Header -Text "Advanced Options (number 3)" -Number 3
        
        
        
    Write-Host "`n💡 Write-InfoBox Examples:" -ForegroundColor Cyan
    Write-InfoBox -Title "System Backup" -Content "System backup completed successfully. All files have been archived to the remote location." -Style Classic
    Write-InfoBox -Title "Security Patches" -Content "New security patches are available for installation. Please schedule a maintenance window." -Style Modern
    Write-InfoBox -Title "Database Status" -Content "Database connection established. Ready to proceed with data migration." -Style Accent
        
        
        
    Write-Host "`n⚠️ Write-Alert Examples:" -ForegroundColor Cyan
    Write-Alert -Message "Disk space is running low on C: drive (85% full)" -Type Warning
    Write-Alert -Message "Critical security vulnerability detected in web server" -Type Error
    Write-Alert -Message "Remember to backup your data before proceeding" -Type Info

    # Section 2: Status & Results Functions
    Write-Separator -Text "📊 Status & Results Functions" -Style Double
        
    Write-Host "`n✅ Write-ActionResult Examples:" -ForegroundColor Cyan
    Write-ActionResult -Action "Deploy Application" -Status Success -Details "Deployed to production environment in 2.3 seconds"
    Write-ActionResult -Action "Run Security Scan" -Status Warning -Details "Scan completed with 3 medium-risk vulnerabilities found"
    Write-ActionResult -Action "Connect to Database" -Status Failed -Details "Connection timeout after 30 seconds - check network connectivity"
    Write-ActionResult -Action "Backup Files" -Status Info -Details "Backing up 1,247 files (3.2 GB) to Azure storage"
        
        
        
    Write-Host "`n📈 Write-Progress Examples:" -ForegroundColor Cyan
    Write-Progress -CurrentValue 25 -MaxValue 100 -Text "Installing Updates" -Style Bar -ShowPercentage
    Write-Progress -CurrentValue 67 -MaxValue 100 -Text "Copying Files" -Style Bar -ShowPercentage  
    Write-Progress -CurrentValue 90 -MaxValue 100 -Text "Compressing Data" -Style Bar -ShowPercentage
        
        
    Write-Host "`n🔢 Write-Steps Examples:" -ForegroundColor Cyan
    $deploySteps = @(
        "Validate configuration files",
        "Stop application services", 
        "Deploy new version",
        "Update database schema",
        "Start services and verify"
    )
    Write-Steps -Steps $deploySteps -CurrentStep 3


    # Section 3: Data Presentation Functions
    Write-Separator -Text "📊 Data Presentation Functions" -Style Double

    Write-Host "`n📊 Write-Chart Examples:" -ForegroundColor Cyan
    $chartData = @{
        "Web Servers"   = 85
        "Database"      = 92
        "File Storage"  = 67
        "Email Service" = 98
        "Backup System" = 74
    }
    Write-Chart -Data $chartData -Title "System Health Metrics (%)" -ChartType Bar -ShowValues

    # Section 4: Interactive Elements
    Write-Separator -Text "🖱️ Interactive Elements" -Style Double
        
    Write-Host "`n📋 Write-Menu Examples:" -ForegroundColor Cyan
    Write-Host "Example 1: Environment Selection" -ForegroundColor Yellow
    $environments = @("Development", "Staging", "Production", "Disaster Recovery")
    Write-Host "Menu display (non-interactive demo):" -ForegroundColor Gray
    Write-Host "📋 Select Target Environment" -ForegroundColor Cyan
    Write-Host "════════════════════════" -ForegroundColor Cyan
    Write-Host "▶️ 1. Development" -ForegroundColor Green
    Write-Host "   2. Staging" -ForegroundColor White
    Write-Host "   3. Production" -ForegroundColor White  
    Write-Host "   4. Disaster Recovery" -ForegroundColor White
    Write-Host ""
        
    Write-Host "Example 2: Action Menu" -ForegroundColor Yellow
    $actions = @("Deploy Application", "Rollback Version", "View Logs", "Check Status", "Exit")
    Write-Host "Menu display (non-interactive demo):" -ForegroundColor Gray
    Write-Host "📋 Available Actions" -ForegroundColor Cyan
    Write-Host "════════════════" -ForegroundColor Cyan
    Write-Host "▶️ 1. Deploy Application" -ForegroundColor Green
    Write-Host "   2. Rollback Version" -ForegroundColor White
    Write-Host "   3. View Logs" -ForegroundColor White
    Write-Host "   4. Check Status" -ForegroundColor White
    Write-Host "   5. Exit" -ForegroundColor White
        
    Write-Host "`n❓ Write-Question Examples:" -ForegroundColor Cyan
    Write-Host "Example 1: Yes/No Question" -ForegroundColor Yellow
    Write-Host "❓ Do you want to proceed with the deployment? [Y/n]: Y" -ForegroundColor Yellow
    Write-Host "Result: True" -ForegroundColor Green
        
    Write-Host "`nExample 2: Choice Question" -ForegroundColor Yellow
    Write-Host "❓ Select backup retention period" -ForegroundColor Yellow
    Write-Host "  1. 7 days" -ForegroundColor White
    Write-Host "  2. 30 days" -ForegroundColor White
    Write-Host "  3. 90 days" -ForegroundColor White
    Write-Host "  4. 1 year" -ForegroundColor White
    Write-Host "Select (1-4) [default: 2]: 2" -ForegroundColor Yellow
    Write-Host "Result: 30 days" -ForegroundColor Green
        
    Write-Host "`nExample 3: Text Input" -ForegroundColor Yellow
    Write-Host "❓ Enter the server hostname [default: web-server-01]: web-prod-01" -ForegroundColor Yellow
    Write-Host "Result: web-prod-01" -ForegroundColor Green
        
    Write-Host "`nExample 4: Secure Input" -ForegroundColor Yellow
    Write-Host "❓ Enter administrator password (password will be hidden): ********" -ForegroundColor Yellow
    Write-Host "Result: [SecureString]" -ForegroundColor Green

    # Section 5: Layout & Formatting Functions  
    Write-Separator -Text "🎨 Layout & Formatting Functions" -Style Double
        
    Write-Host "`n📏 Write-Separator Examples:" -ForegroundColor Cyan
    Write-Separator -Text "Single Line Style" -Style Single
    Write-Separator -Text "Double Line Style" -Style Double  
    Write-Separator -Text "Thick Style" -Style Thick
    Write-Separator -Text "Dotted Style" -Style Dotted
    Write-Separator  # Empty separator
        
        
        
    Write-Host "`n📦 Write-Panel Examples:" -ForegroundColor Cyan
    Write-Panel -Title "System Information" -Content @(
        "OS: Windows Server 2022",
        "CPU: Intel Xeon E5-2686 v4",
        "Memory: 16 GB DDR4",
        "Storage: 500 GB SSD"
    ) -Style Box
        
    Write-Host
    Write-Panel -Title "System Information" -Content @(
        "OS: Windows Server 2022",
        "CPU: Intel Xeon E5-2686 v4",
        "Memory: 16 GB DDR4",
        "Storage: 500 GB SSD"
    ) -Style Card
    Write-Host

        


    # Section 6: Global Configuration
    Write-Separator -Text "⚙️ Global Configuration" -Style Double
        
    Write-Host "`n📏 Max Width Configuration:" -ForegroundColor Cyan
    Write-Host "Current max width: $(Get-OrionMaxWidth) characters" -ForegroundColor White
        
    Write-Host "`nDemonstrating width control:" -ForegroundColor Yellow
        
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

    # Demo conclusion
    Write-Separator -Text "🎉 Demo Complete" -Style Double
   
    
    Write-Host "`n📖 For more information:" -ForegroundColor Cyan
    Write-Host "  • Get-Help <FunctionName> -Full" -ForegroundColor White
    Write-Host "  • Show-OrionDesignHelp" -ForegroundColor White
    Write-Host "  • Import-Module OrionDesign" -ForegroundColor White
   

}
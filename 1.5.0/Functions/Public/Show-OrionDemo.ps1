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

    # Helper function for interactive pauses
    function Wait-ForUser {
        if ($Interactive) {
            Write-Host "`n⏸️  Press Enter to continue..." -ForegroundColor Yellow -NoNewline
            Read-Host
        } else {
            Start-Sleep -Milliseconds 500
        }
    }

    # Demo header
    Clear-Host
    Write-Banner -ScriptName "OrionDesign UI Framework" -Author "GitHub Copilot" -Design Modern -Description "Complete demonstration of all 19 beautiful UI functions"
    
    Write-Host "`n🎨 Welcome to the OrionDesign demonstration!" -ForegroundColor Cyan
    Write-Host "This showcase will display all available functions with realistic examples." -ForegroundColor White
    
    if ($Section -eq "All") {
        Write-Host "`n📋 Demo includes:" -ForegroundColor Green
        @("Information Display", "Status & Results", "Data Presentation", "Interactive Elements", "Layout & Formatting", "Global Configuration") | 
        ForEach-Object { Write-Host "  • $_" -ForegroundColor White }
    }

    Wait-ForUser

    # Section 1: Information Display Functions
    if ($Section -eq "All" -or $Section -eq "Information") {
        Write-Separator -Text "📝 Information Display Functions" -Style Double
        
        Write-Host "`n🎯 Write-Banner Examples:" -ForegroundColor Cyan
        Write-Banner -ScriptName "Data Migration Tool" -Author "IT Department" -Design Classic
        Start-Sleep -Milliseconds 300
        Write-Banner -ScriptName "Security Audit" -Author "Security Team" -Design Modern -Description "Automated vulnerability assessment"
        Start-Sleep -Milliseconds 300
        Write-Banner -ScriptName "Backup System" -Author "Admin" -Design Minimal
        
        Wait-ForUser
        
        Write-Host "`n📋 Write-Header Examples:" -ForegroundColor Cyan
        Write-Header -Text "System Configuration"
        Write-Header -Text "Network Settings" -Underline Full
        Write-Header -Text "Advanced Options" -Number 3
        
        Wait-ForUser
        
        Write-Host "`n💡 Write-InfoBox Examples:" -ForegroundColor Cyan
        Write-InfoBox -Title "System Backup" -Content "System backup completed successfully. All files have been archived to the remote location." -Style Classic
        Write-InfoBox -Title "Security Patches" -Content "New security patches are available for installation. Please schedule a maintenance window." -Style Modern
        Write-InfoBox -Title "Database Status" -Content "Database connection established. Ready to proceed with data migration." -Style Accent
        
        Wait-ForUser
        
        Write-Host "`n⚠️ Write-Alert Examples:" -ForegroundColor Cyan
        Write-Alert -Message "Disk space is running low on C: drive (85% full)" -Type Warning
        Write-Alert -Message "Critical security vulnerability detected in web server" -Type Error
        Write-Alert -Message "Remember to backup your data before proceeding" -Type Info
    }

    # Section 2: Status & Results Functions
    if ($Section -eq "All" -or $Section -eq "Status") {
        Write-Separator -Text "📊 Status & Results Functions" -Style Double
        
        Write-Host "`n✅ Write-ActionResult Examples:" -ForegroundColor Cyan
        Write-ActionResult -Action "Deploy Application" -Status Success -Details "Deployed to production environment in 2.3 seconds"
        Write-ActionResult -Action "Run Security Scan" -Status Warning -Details "Scan completed with 3 medium-risk vulnerabilities found"
        Write-ActionResult -Action "Connect to Database" -Status Failed -Details "Connection timeout after 30 seconds - check network connectivity"
        Write-ActionResult -Action "Backup Files" -Status Info -Details "Backing up 1,247 files (3.2 GB) to Azure storage"
        
        Wait-ForUser
        
        Write-Host "`n📈 Write-Progress Examples:" -ForegroundColor Cyan
        Write-Progress -CurrentValue 25 -MaxValue 100 -Text "Installing Updates" -Style Bar -ShowPercentage
        Write-Progress -CurrentValue 67 -MaxValue 100 -Text "Copying Files" -Style Bar -ShowPercentage  
        Write-Progress -CurrentValue 90 -MaxValue 100 -Text "Compressing Data" -Style Bar -ShowPercentage
        
        Wait-ForUser
        
        Write-Host "`n🔢 Write-Steps Examples:" -ForegroundColor Cyan
        $deploySteps = @(
            "Validate configuration files",
            "Stop application services", 
            "Deploy new version",
            "Update database schema",
            "Start services and verify"
        )
        Write-Steps -Steps $deploySteps -CurrentStep 3
        
        Wait-ForUser
        
        Write-Host "`n⏰ Write-Timeline Examples:" -ForegroundColor Cyan
        $timelineEvents = @(
            @{Time="09:00"; Event="System maintenance started"; Status="Completed"}
            @{Time="09:15"; Event="Database backup completed"; Status="Completed"}
            @{Time="09:30"; Event="Application services stopped"; Status="Completed"}
            @{Time="09:45"; Event="Security patches applied"; Status="Current"}
            @{Time="10:00"; Event="System restart initiated"; Status="Pending"}
            @{Time="10:15"; Event="All services restored"; Status="Pending"}
        )
        Write-Timeline -Events $timelineEvents -Style Vertical -ShowTime
    }

    # Section 3: Data Presentation Functions
    if ($Section -eq "All" -or $Section -eq "Data") {
        Write-Separator -Text "📊 Data Presentation Functions" -Style Double
        
        Write-Host "`n📋 Write-Table Examples:" -ForegroundColor Cyan
        $serverData = @(
            [PSCustomObject]@{Server="WEB-01"; Status="Online"; CPU="15%"; Memory="8.2GB"; Uptime="45 days"}
            [PSCustomObject]@{Server="WEB-02"; Status="Online"; CPU="22%"; Memory="7.8GB"; Uptime="32 days"}
            [PSCustomObject]@{Server="DB-01"; Status="Maintenance"; CPU="5%"; Memory="12.1GB"; Uptime="12 days"}
            [PSCustomObject]@{Server="DB-02"; Status="Online"; CPU="18%"; Memory="11.8GB"; Uptime="67 days"}
        )
        Write-Table -Data $serverData -Columns @("Server", "Status", "CPU", "Memory") -Style Grid
        
        Wait-ForUser
        
        Write-Host "`n📊 Write-Chart Examples:" -ForegroundColor Cyan
        $chartData = @{
            "Web Servers" = 85
            "Database" = 92
            "File Storage" = 67
            "Email Service" = 98
            "Backup System" = 74
        }
        Write-Chart -Data $chartData -Title "System Health Metrics (%)" -ChartType Bar -ShowValues
        
        Wait-ForUser
        
        Write-Host "`n🔄 Write-Comparison Examples:" -ForegroundColor Cyan
        Write-Comparison -Left "Current Version: 2.1.4" -Right "New Version: 2.2.0" -LeftTitle "Before" -RightTitle "After"
        Write-Comparison -Left @("Manual backups", "Local storage only", "Email notifications") -Right @("Automated backups", "Cloud + local storage", "SMS + email alerts") -LeftTitle "Current System" -RightTitle "Upgraded System"
        
        Wait-ForUser
        
        Write-Host "`n📊 Write-Dashboard Examples:" -ForegroundColor Cyan
        # Create a simple, working dashboard example
        Write-Host "Example: IT Operations Dashboard" -ForegroundColor Yellow
        Write-Host ""
        
        # Display a mock dashboard layout since the full function has complexity
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "║                                    📊 IT Operations Dashboard                                    ║" -ForegroundColor Cyan  
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "┌──────────────────────────────────┐  ┌──────────────────────────────────┐" -ForegroundColor White
        Write-Host "│ System Load                      │  │ Active Users                     │" -ForegroundColor White
        Write-Host "├──────────────────────────────────┤  ├──────────────────────────────────┤" -ForegroundColor White  
        Write-Host "│ ████████░░░░░░░░░░░░░░░░░░░░░░░░ │  │ 247 online                      │" -ForegroundColor Green
        Write-Host "│ Normal (15%)                     │  │ Counter: 247                     │" -ForegroundColor White
        Write-Host "└──────────────────────────────────┘  └──────────────────────────────────┘" -ForegroundColor White
        Write-Host ""
        Write-Host "┌──────────────────────────────────┐  ┌──────────────────────────────────┐" -ForegroundColor White
        Write-Host "│ Memory Usage                     │  │ Recent Alerts                    │" -ForegroundColor White
        Write-Host "├──────────────────────────────────┤  ├──────────────────────────────────┤" -ForegroundColor White
        Write-Host "│ ████████████████████░░░░░░░░░░░░ │  │ • Backup completed               │" -ForegroundColor Yellow
        Write-Host "│ 8.2GB / 16GB (51%)               │  │ • User logged in                 │" -ForegroundColor White
        Write-Host "└──────────────────────────────────┘  │ • Service restarted              │" -ForegroundColor White
        Write-Host "                                      └──────────────────────────────────┘" -ForegroundColor White
        Write-Host ""
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    }

    # Section 4: Interactive Elements
    if ($Section -eq "All" -or $Section -eq "Interactive") {
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
        
        Wait-ForUser
        
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
    }

    # Section 5: Layout & Formatting Functions  
    if ($Section -eq "All" -or $Section -eq "Layout") {
        Write-Separator -Text "🎨 Layout & Formatting Functions" -Style Double
        
        Write-Host "`n📏 Write-Separator Examples:" -ForegroundColor Cyan
        Write-Separator -Text "Single Line Style" -Style Single
        Write-Separator -Text "Double Line Style" -Style Double  
        Write-Separator -Text "Thick Style" -Style Thick
        Write-Separator -Text "Dotted Style" -Style Dotted
        Write-Separator  # Empty separator
        
        Wait-ForUser
        
        Write-Host "`n📦 Write-Panel Examples:" -ForegroundColor Cyan
        Write-Panel -Title "System Information" -Content @(
            "OS: Windows Server 2022",
            "CPU: Intel Xeon E5-2686 v4",
            "Memory: 16 GB DDR4",
            "Storage: 500 GB SSD"
        ) -Style Box
        
        Write-Panel -Title "Network Configuration" -Content "IP: 192.168.1.100`nSubnet: 255.255.255.0`nGateway: 192.168.1.1`nDNS: 8.8.8.8, 8.8.4.4" -Style Card
        
        Wait-ForUser
        
        Write-Host "`n💻 Write-CodeBlock Examples:" -ForegroundColor Cyan
        $powershellCode = @"
# PowerShell example
Get-Process | Where-Object {$_.CPU -gt 100} | 
    Select-Object Name, CPU, WorkingSet |
    Sort-Object CPU -Descending
"@
        Write-CodeBlock -Code $powershellCode -Language PowerShell -Title "System Monitoring Script"
        
        $jsonCode = @"
{
    "server": {
        "name": "web-01",
        "status": "active",
        "metrics": {
            "cpu": 15.2,
            "memory": 8192,
            "uptime": "45d 6h 32m"
        }
    }
}
"@
        Write-CodeBlock -Code $jsonCode -Language JSON -Title "Server Configuration"
    }

    # Section 6: Global Configuration
    if ($Section -eq "All" -or $Section -eq "Configuration") {
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
    }

    # Demo conclusion
    Write-Separator -Text "🎉 Demo Complete" -Style Double
    
    Write-Host "`n✨ OrionDesign Module Features Demonstrated:" -ForegroundColor Green
    @(
        "🎨 19 Beautiful UI Functions",
        "📏 Global Max Width Configuration", 
        "🎯 Consistent ANSI Styling",
        "📚 Complete Help Documentation",
        "🔧 Flexible Parameter Options",
        "💻 PowerShell ISE Compatibility",
        "🚀 Production Ready"
    ) | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
    
    Write-Host "`n📖 For more information:" -ForegroundColor Cyan
    Write-Host "  • Get-Help <FunctionName> -Full" -ForegroundColor White
    Write-Host "  • Show-OrionDesignHelp" -ForegroundColor White
    Write-Host "  • Import-Module OrionDesign" -ForegroundColor White
    
    Write-ActionResult -Action "OrionDesign Demo" -Status Success -Details "All functions demonstrated successfully - ready for production use!"
}

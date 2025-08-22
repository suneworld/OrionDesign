<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Max Width Demo Script
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Demo/Configuration Script
Dependencies:  OrionDesign Module, Get-OrionMaxWidth, Set-OrionMaxWidth

SCRIPT PURPOSE:
Demonstration of global maximum width configuration system.
Interactive showcase of width control functionality allowing users
to see how different width settings affect display formatting.

HLD INTEGRATION:
┌─ WIDTH DEMO ─────┐    ┌─ CONFIGURATION ──┐    ┌─ VISUAL TEST ─┐
│ Demo-MaxWidth    │◄──►│ Width Settings   │───►│ Format Demo  │
│ • Width Tests    │    │ 50-200 Range     │    │ Live Preview │
│ • Config Demo    │    │ Reset Function   │    │ Comparison   │
│ • Live Preview   │    │ Global Control   │    │ Examples     │
└──────────────────┘    └──────────────────┘    └──────────────┘
================================================================================
#>

# OrionDesign Global Max Width Demonstration

Write-Banner -ScriptName "OrionDesign Max Width Demo" -Author "GitHub Copilot" -Design Modern -Description "Demonstrating global width controls"

Write-Host "`n🎯 Current Configuration:" -ForegroundColor Cyan
Write-Host "Default max width: $(Get-OrionMaxWidth) characters" -ForegroundColor White

Write-Host "`n📏 Testing with Default Width (100):" -ForegroundColor Green
Write-Separator -Text "Full Width Test" -Style Double
Write-ActionResult -Action "Deploy Application" -Status Success -Details "This is a test with normal length details that should display without truncation in the default 100 character width"

Write-Host "`n📏 Setting Narrow Width (60):" -ForegroundColor Yellow
Set-OrionMaxWidth -Width 60
Write-Separator -Text "Narrow Width Test" -Style Double
Write-ActionResult -Action "Deploy Application" -Status Warning -Details "This is a test with long details that should be truncated because we are using a narrow 60 character width limit"

Write-Host "`n📏 Setting Wide Width (120):" -ForegroundColor Cyan
Set-OrionMaxWidth -Width 120
Write-Separator -Text "Wide Width Test" -Style Double
Write-ActionResult -Action "Deploy Application" -Status Info -Details "This is a test with long details that should display fully because we are using a wide 120 character width limit which allows for much more content"

Write-Host "`n🔄 Resetting to Default:" -ForegroundColor Green
Set-OrionMaxWidth -Reset
Write-Separator -Text "Back to Default" -Style Single

Write-Host "`n💡 Available Functions:" -ForegroundColor Cyan
Write-Host "  • Get-OrionMaxWidth    - Check current max width" -ForegroundColor White
Write-Host "  • Set-OrionMaxWidth    - Set custom max width (50-200)" -ForegroundColor White
Write-Host "  • Set-OrionMaxWidth -Reset - Reset to default (100)" -ForegroundColor White

Write-Host "`n📋 Functions That Respect Max Width:" -ForegroundColor Cyan
@(
    "Write-ActionResult", "Write-Separator", "Write-Table", 
    "Write-Dashboard", "Write-Banner", "Write-Panel"
) | ForEach-Object { Write-Host "  • $_" -ForegroundColor White }

Write-ActionResult -Action "Max Width Demo Complete" -Status Success -Details "Global width control is now available for consistent formatting across all OrionDesign functions"

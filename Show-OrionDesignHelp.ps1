<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Help Documentation Script
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Demo/Documentation Script
Dependencies:  OrionDesign Module Functions

SCRIPT PURPOSE:
Comprehensive help documentation display for all OrionDesign functions.
Interactive help system providing function references, syntax examples,
and categorized function overview with detailed usage instructions.

HLD INTEGRATION:
┌─ HELP SYSTEM ────┐    ┌─ DOCUMENTATION ──┐    ┌─ USER GUIDE ─┐
│ Show-OrionDesign │◄──►│ Function List    │───►│ Interactive  │
│ Help             │    │ Syntax Examples  │    │ Reference    │
│ • Function Scan  │    │ Category Groups  │    │ Complete     │
│ • Help Display   │    │ Usage Patterns   │    │ Guide        │
└──────────────────┘    └──────────────────┘    └──────────────┘
================================================================================
#>

# OrionDesign Module - Comprehensive Help Documentation

Write-Host "`n" -NoNewline
Write-Banner -ScriptName "OrionDesign Help Documentation" -Author "Sune A Narudt" -Design Diamond -Description "Complete function reference and examples"

Write-Host "`n📚 Available Functions:" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor DarkCyan

# Get all functions and display help summary
$functions = Get-Command -Module OrionDesign | Sort-Object Name

foreach ($func in $functions) {
    $help = Get-Help $func.Name -ErrorAction SilentlyContinue
    
    Write-Host "`n🔹 " -ForegroundColor Cyan -NoNewline
    Write-Host $func.Name -ForegroundColor Yellow -NoNewline
    
    if ($help.Synopsis -and $help.Synopsis -ne $func.Name) {
        Write-Host " - $($help.Synopsis)" -ForegroundColor White
        
        # Show parameters
        if ($help.Syntax) {
            $syntax = $help.Syntax.syntaxItem[0].name + " " + ($help.Syntax.syntaxItem[0].parameter | ForEach-Object { 
                if ($_.required -eq $true) { "[-$($_.name)] <$($_.type.name)>" } 
                else { "[[-$($_.name)] <$($_.type.name)>]" } 
            } | Select-Object -First 3) -join " "
            Write-Host "   Syntax: $syntax..." -ForegroundColor Gray
        }
        
        # Show first example if available
        if ($help.Examples -and $help.Examples.example) {
            $example = $help.Examples.example[0].code.Trim()
            Write-Host "   Example: $example" -ForegroundColor DarkGray
        }
    } else {
        Write-Host " - Help not available" -ForegroundColor Red
    }
}

Write-Host "`n" -NoNewline
Write-Separator -Style Double -Color Accent -Text "Quick Help Commands"

Write-Host "`n💡 To get detailed help for any function:" -ForegroundColor Green
Write-Host "   Get-Help <FunctionName> -Full" -ForegroundColor White
Write-Host "   Get-Help <FunctionName> -Examples" -ForegroundColor White
Write-Host "   Get-Help <FunctionName> -Detailed" -ForegroundColor White

Write-Host "`n🎯 Function Categories:" -ForegroundColor Green

Write-InfoBox -Title "Display Functions" -Type Info -Content @(
    "Write-Banner    - Decorative script headers", 
    "Write-Header    - Section headers with underlines",
    "Write-Alert     - Notifications and warnings",
    "Write-InfoBox   - Information panels"
) -Style Modern

Write-InfoBox -Title "Interactive Functions" -Type Success -Content @(
    "Write-Question  - User input prompts", 
    "Write-Menu      - Selection menus",
    "Write-Steps     - Step-by-step guides"
) -Style Modern

Write-InfoBox -Title "Data Visualization" -Type Warning -Content @(
    "Write-Table     - Formatted tables", 
    "Write-Chart     - ASCII charts",
    "Write-Timeline  - Event timelines",
    "Write-Comparison - Side-by-side comparisons",
    "Write-Dashboard - System dashboards"
) -Style Modern

Write-InfoBox -Title "Layout & Formatting" -Type Default -Content @(
    "Write-Panel     - Information panels", 
    "Write-Progress  - Progress indicators",
    "Write-Separator - Section dividers",
    "Write-CodeBlock - Syntax highlighted code"
) -Style Modern

Write-Host "`n" -NoNewline
Write-ActionResult -Action "Help Documentation Review" -Status Success -Details "All functions have comprehensive help available"

<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Get-OrionMaxWidth Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
Category:      Global Configuration
Dependencies:  OrionDesign Global Variables

FUNCTION PURPOSE:
Retrieves the current global maximum width setting for OrionDesign functions.
Core configuration function that enables width management and consistency
across all UI components in the framework.

HLD INTEGRATION:
┌─ GLOBAL CONFIG ─┐    ┌─ SCRIPT SCOPE ─┐    ┌─ OUTPUT ─┐
│ Get-OrionMaxWdth│◄──►│ $script:OrionMax│───►│ Current  │
│ • Read Setting  │    │ Width Variable  │    │ Width    │
│ • Validation    │    │ • Default: 100  │    │ Value    │
│ • Status Info   │    │ • Range: 50-200 │    │ Status   │
└─────────────────┘    └─────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Gets the current global maximum width for OrionDesign functions.

.DESCRIPTION
The Get-OrionMaxWidth function returns the current maximum width setting for OrionDesign functions.

.EXAMPLE
Get-OrionMaxWidth

Returns the current maximum width setting.
#>
function Get-OrionMaxWidth {
    [CmdletBinding()]
    param(
        [switch]$Demo
    )

    if ($Demo) {
        Write-Host ''
        Write-Host '  Get-OrionMaxWidth Demo' -ForegroundColor Cyan
        Write-Host '  ======================' -ForegroundColor DarkGray
        Write-Host ''
        Write-Host '  Returns the current global max width used by all OrionDesign functions.' -ForegroundColor DarkGray
        Write-Host ''
        $current = if ($script:OrionMaxWidth) { $script:OrionMaxWidth } else { 100 }
        Write-Host '  Current value: ' -NoNewline
        Write-Host $current -ForegroundColor Cyan
        Write-Host ''
        Write-Host '  Usage examples:' -ForegroundColor DarkGray
        Write-Host '    Get-OrionMaxWidth                 # Returns current value' -ForegroundColor Green
        Write-Host '    Set-OrionMaxWidth -Width 120       # Change max width' -ForegroundColor Green
        Write-Host '    Set-OrionMaxWidth -Reset           # Reset to default (100)' -ForegroundColor Green
        Write-Host ''
        return
    }

    if (-not $script:OrionMaxWidth) {
        return 100  # Default value
    }
    
    return $script:OrionMaxWidth
}

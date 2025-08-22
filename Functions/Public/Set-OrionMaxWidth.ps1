<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Set-OrionMaxWidth Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Global Configuration
Dependencies:  OrionDesign Global Variables

FUNCTION PURPOSE:
Sets the global maximum width for all OrionDesign functions output.
Critical configuration function that provides consistent width control
and prevents overly long output across the entire framework.

HLD INTEGRATION:
┌─ GLOBAL CONFIG ─┐    ┌─ SCRIPT SCOPE ─┐    ┌─ FUNCTIONS ─┐
│ Set-OrionMaxWdth│◄──►│ $script:OrionMax│───►│ All UI      │
│ • Width Setting │    │ Width Variable  │    │ Functions   │
│ • Validation    │    │ • Range: 50-200 │    │ Respect     │
│ • Reset Option  │    │ • Default: 100  │    │ Setting     │
└─────────────────┘    └─────────────────┘    └─────────────┘
================================================================================
#>

<#
.SYNOPSIS
Sets the global maximum width for OrionDesign functions.

.DESCRIPTION
The Set-OrionMaxWidth function allows you to configure the maximum width/length for OrionDesign functions. This helps prevent overly long output and ensures consistent formatting across all functions.

.PARAMETER Width
The maximum width in characters. Must be between 50 and 200. Default is 100.

.PARAMETER Reset
Reset to the default width (100 characters).

.EXAMPLE
Set-OrionMaxWidth -Width 120

Sets the maximum width to 120 characters for all OrionDesign functions.

.EXAMPLE
Set-OrionMaxWidth -Reset

Resets the maximum width to the default value of 100 characters.

.EXAMPLE
Set-OrionMaxWidth -Width 80

Sets a narrower width of 80 characters for more compact output.
#>
function Set-OrionMaxWidth {
    [CmdletBinding()]
    param(
        [ValidateRange(50, 200)]
        [int]$Width = 100,
        [switch]$Reset
    )
    
    if ($Reset) {
        $script:OrionMaxWidth = 100
        Write-Host "📏 OrionDesign max width reset to default: 100 characters" -ForegroundColor Green
    } else {
        $script:OrionMaxWidth = $Width
        Write-Host "📏 OrionDesign max width set to: $Width characters" -ForegroundColor Green
    }
}

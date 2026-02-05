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
    param()
    
    if (-not $script:OrionMaxWidth) {
        return 100  # Default value
    }
    
    return $script:OrionMaxWidth
}

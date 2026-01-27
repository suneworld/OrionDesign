<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Colored Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
Category:      Private Helper Function
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Renders colored text segments with ANSI styling support.
Core output helper function providing theme-aware text rendering with
ANSI escape sequences for bold/underline formatting when supported.

HLD INTEGRATION:
┌─ PRIVATE HELPER ─┐    ┌─ TEXT RENDERING ─┐    ┌─ OUTPUT ─┐
│ Write-Colored    │◄──►│ ANSI Sequences   │───►│ Console  │
│ • Color Output   │    │ Bold/Underline   │    │ Display  │
│ • ANSI Support   │    │ Theme Colors     │    │ Styled   │
│ • Style Rendering│    │ Cross-Platform   │    │ Text     │
└──────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

# Write-Colored.ps1
function Write-Colored {
    param([array]$Segments,[hashtable]$Theme=$script:Theme)

    foreach ($seg in $Segments) {
        $text = $seg.Text
        if ($Theme.UseAnsi) {
            if ($seg.Style -eq 'BOLD')       { $text = "`e[1m$text`e[22m" }
            elseif ($seg.Style -eq 'UNDER') { $text = "`e[4m$text`e[24m" }
        }
        if ($seg.Color) { Write-Host -NoNewline $text -ForegroundColor $seg.Color }
        else            { Write-Host -NoNewline $text }
    }
    Write-Host
}

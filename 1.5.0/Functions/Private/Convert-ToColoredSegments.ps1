<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Convert-ToColoredSegments Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Private Helper Function
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Parses markup tags in text and converts them to colored segments.
Core helper function providing markup parsing for rich text formatting
across multiple OrionDesign functions with theme-aware color mapping.

HLD INTEGRATION:
┌─ PRIVATE HELPER ─┐    ┌─ MARKUP PARSING ─┐    ┌─ OUTPUT ─┐
│ Convert-ToColored│◄──►│ <accent> tags    │───►│ Colored  │
│ Segments         │    │ <success><error> │    │ Text     │
│ • Parse Markup   │    │ Theme Mapping    │    │ Segments │
│ • Theme Colors   │    │ Tag Processing   │    │ Array    │
└──────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

# Convert-ToColoredSegments.ps1
function Convert-ToColoredSegments {
    param([string]$Text,[hashtable]$Theme=$script:Theme)

    $pattern = '<(/?)([a-zA-Z]+)>'
    $tagMatches = [regex]::Matches($Text, $pattern)

    $segments = @(); 
    $colorStack = New-Object System.Collections.Stack
    $styleStack = New-Object System.Collections.Stack
    $pos = 0

    function MapToken($tag,$theme) {
        switch ($tag.ToLower()) {
            'success'   { $theme.Success }
            'warning'   { $theme.Warning }
            'error'     { $theme.Error }
            'accent'    { $theme.Accent }
            'muted'     { $theme.Muted }
            'text'      { $theme.Text }
            'bold'      { 'BOLD' }
            'underline' { 'UNDER' }
            default     { if ([System.Enum]::GetNames([System.ConsoleColor]) -contains $tag) { $tag } else { $null } }
        }
    }

    foreach ($m in $tagMatches) {
        if ($m.Index -gt $pos) {
            $plain = $Text.Substring($pos, $m.Index - $pos)
            $curColor = if ($colorStack.Count -gt 0) { $colorStack.Peek() } else { $null }
            $curStyle = if ($styleStack.Count -gt 0) { $styleStack.Peek() } else { $null }
            $segments += [pscustomobject]@{ Text=$plain; Color=$curColor; Style=$curStyle }
        }

        $isClose = $m.Groups[1].Value -eq '/'
        $tag = $m.Groups[2].Value

        if ($isClose) {
            switch ($tag.ToLower()) {
                'bold'      { if ($styleStack.Count -gt 0 -and $styleStack.Peek() -eq 'BOLD') { $null=$styleStack.Pop() } }
                'underline' { if ($styleStack.Count -gt 0 -and $styleStack.Peek() -eq 'UNDER') { $null=$styleStack.Pop() } }
                default     { if ($colorStack.Count -gt 0) { $null=$colorStack.Pop() } }
            }
        }
        else {
            $mapped = MapToken $tag $Theme
            if ($mapped -eq 'BOLD' -or $mapped -eq 'UNDER') { $styleStack.Push($mapped) }
            elseif ($mapped) { $colorStack.Push($mapped) }
        }

        $pos = $m.Index + $m.Length
    }

    if ($pos -lt $Text.Length) {
        $plain = $Text.Substring($pos)
        $curColor = if ($colorStack.Count -gt 0) { $colorStack.Peek() } else { $null }
        $curStyle = if ($styleStack.Count -gt 0) { $styleStack.Peek() } else { $null }
        $segments += [pscustomobject]@{ Text=$plain; Color=$curColor; Style=$curStyle }
    }

    return $segments
}

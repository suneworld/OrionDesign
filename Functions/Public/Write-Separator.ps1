<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Separator Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
Category:      Layout & Formatting
Dependencies:  OrionDesign Theme System, Global Max Width

FUNCTION PURPOSE:
Creates visual section dividers with text labels and various line styles.
Essential layout component providing clear visual separation between content
sections with width-aware formatting and consistent styling.

HLD INTEGRATION:
┌─ LAYOUT FORMAT ─┐    ┌─ GLOBAL CONFIG ─┐    ┌─ OUTPUT ─┐
│ Write-Separator │◄──►│ MaxWidth Control│───►│ Section  │
│ • Single/Double │    │ • Auto Adjust   │    │ Divider  │
│ • Thick/Dotted  │    │ • Width Aware   │    │ Text     │
│ • Custom Text   │    │ • Theme Colors  │    │ Lines    │
└─────────────────┘    └─────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates styled section separators and dividers.

.DESCRIPTION
The Write-Separator function creates visual separators to divide sections of output. Supports various styles, lengths, and optional text labels.

.PARAMETER Text
Optional text to display in the separator.

.PARAMETER Style
The visual style of the separator. Available styles:
• Single: Clean single-line separator using standard horizontal line characters
• Double: Elegant double-line separator with enhanced visual weight and prominence
• Thick: Bold thick line separator for strong section divisions and major breaks
• Dotted: Subtle dotted line separator for gentle section divisions and soft breaks
• Custom: Flexible custom character separator allowing personalized visual elements

Valid values: Single, Double, Thick, Dotted, Custom

.PARAMETER Length
Length of the separator (default: terminal width).

.PARAMETER Character
Custom character for 'Custom' style.

.PARAMETER Color
Color of the separator. Accepts either:
- Semantic theme colors: Accent, Success, Warning, Error, Text, Muted
- Direct console colors: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, 
  DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

.PARAMETER Center
Centers the text in the separator.

.EXAMPLE
Write-Separator -Text "Phase 2: Testing" -Style Double

Creates a double-line separator with centered text.

.EXAMPLE
Write-Separator -Length 50 -Character "=" -Color Cyan

Creates a 50-character separator using equals signs in cyan.

.EXAMPLE
Write-Separator -Style Thick

Creates a thick line separator across the full terminal width.
#>
function Write-Separator {
    [CmdletBinding()]
    param(
        [string]$Text = "",
        [ValidateSet('Single', 'Double', 'Thick', 'Dotted', 'Custom')] [string]$Style = 'Single',
        [int]$Length = 0,
        [string]$Character = "-",
        [string]$Color = 'Accent',
        [switch]$Center,

        [Parameter()]
        [switch]$Demo
    )

    if ($Demo) {
        $renderCodeBlock = {
            param([string[]]$Lines)
            $innerWidth = ($Lines | Measure-Object -Property Length -Maximum).Maximum + 4
            $bar = '─' * $innerWidth
            Write-Host '  # Code' -ForegroundColor DarkGray
            Write-Host "  ┌$bar┐" -ForegroundColor DarkGray
            foreach ($line in $Lines) {
                $padded = ("  $line").PadRight($innerWidth)
                Write-Host "  │" -ForegroundColor DarkGray -NoNewline
                Write-Host $padded -ForegroundColor Green -NoNewline
                Write-Host '│' -ForegroundColor DarkGray
            }
            Write-Host "  └$bar┘" -ForegroundColor DarkGray
            Write-Host ''
        }

        Write-Host ''
        Write-Host '  Write-Separator Demo' -ForegroundColor Cyan
        Write-Host '  ====================' -ForegroundColor DarkGray
        Write-Host ''

        $styles = @(
            @{ Style='Single'; Text='Section One' },
            @{ Style='Double'; Text='Phase 2' },
            @{ Style='Thick';  Text='' },
            @{ Style='Dotted'; Text='Optional Details' }
        )
        foreach ($s in $styles) {
            Write-Host "  [Style: $($s.Style)]" -ForegroundColor Yellow
            Write-Host ''
            $textPart = if ($s.Text) { " -Text '$($s.Text)'" } else { '' }
            & $renderCodeBlock @("Write-Separator$textPart -Style $($s.Style)")
            if ($s.Text) {
                Write-Separator -Text $s.Text -Style $s.Style
            } else {
                Write-Separator -Style $s.Style
            }
            Write-Host ''
        }

        return
    }

    # Default theme
    if (-not $script:Theme) {
        $script:Theme = @{
            Accent   = 'Cyan'
            Success  = 'Green'
            Warning  = 'Yellow'
            Error    = 'Red'
            Text     = 'White'
            Muted    = 'DarkGray'
            Divider  = '─'
            UseAnsi  = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    # Determine length
    if ($Length -eq 0) {
        # Use global max width if available, otherwise fallback to terminal width
        if ($script:OrionMaxWidth) {
            $Length = $script:OrionMaxWidth
        } else {
            $Length = try { [Console]::WindowWidth } catch { 80 }
        }
    }
    
    # Ensure length doesn't exceed global max width
    if ($script:OrionMaxWidth -and $Length -gt $script:OrionMaxWidth) {
        $Length = $script:OrionMaxWidth
    }

    # Determine character based on style
    $sepChar = switch ($Style) {
        'Single' { '─' }
        'Double' { '═' }
        'Thick'  { '━' }
        'Dotted' { '·' }
        'Custom' { $Character }
    }

    # Get color - support both semantic theme colors and direct console colors
    $themeColors = @('Accent', 'Success', 'Warning', 'Error', 'Text', 'Muted')
    if ($themeColors -contains $Color) {
        $sepColor = $script:Theme[$Color]
    } else {
        # Try to use as direct console color
        $sepColor = $Color
    }

    Write-Host

    if ([string]::IsNullOrWhiteSpace($Text)) {
        # Simple separator without text
        Write-Host ($sepChar * $Length) -ForegroundColor $sepColor
    } else {
        # Separator with text
        if ($Center) {
            $textLength = $Text.Length + 2  # Add spaces around text
            $remainingLength = $Length - $textLength
            
            if ($remainingLength -gt 0) {
                $leftLength = [Math]::Floor($remainingLength / 2)
                $rightLength = $remainingLength - $leftLength
                
                Write-Host ($sepChar * $leftLength) -ForegroundColor $sepColor -NoNewline
                Write-Host " $Text " -ForegroundColor $script:Theme.Text -NoNewline
                Write-Host ($sepChar * $rightLength) -ForegroundColor $sepColor
            } else {
                # Text is too long, just display it
                Write-Host $Text -ForegroundColor $script:Theme.Text
            }
        } else {
            # Left-aligned text
            $prefixLength = 3  # "═══"
            $textLength = $Text.Length
            $spacesCount = 2  # Space before and after text: " Text "
            $suffixLength = $Length - $prefixLength - $textLength - $spacesCount
            
            if ($suffixLength -gt 0) {
                Write-Host ($sepChar * $prefixLength) -ForegroundColor $sepColor -NoNewline
                Write-Host " $Text " -ForegroundColor $script:Theme.Text -NoNewline
                Write-Host ($sepChar * $suffixLength) -ForegroundColor $sepColor
            } else {
                Write-Host ($sepChar * $prefixLength) -ForegroundColor $sepColor -NoNewline
                Write-Host " $Text" -ForegroundColor $script:Theme.Text
            }
        }
    }
}

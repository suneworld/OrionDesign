<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-MenuLine Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          February 5, 2026
Module:        OrionDesign v3.0.0
Category:      Interactive Display
Dependencies:  OrionDesign Theme System, Global Width Configuration

FUNCTION PURPOSE:
Writes a single menu line with optional right-aligned suffix information.
Designed for building custom menus with consistent styling and alignment.
Respects OrionMaxWidth and theme colors like Write-Action/Write-ActionResult.

USE CASES:
• Building custom interactive menus with count indicators
• Displaying numbered lists with statistics
• Creating navigation menus showing item counts
• Building dashboards with menu-style navigation

LAYOUT STRUCTURE:
┌────────────────────────────────────────────────────────────────────────────┐
│ [Indent] [Number]. [Title]                            [SuffixNumber] [Suffix] │
│    ↑         ↑        ↑                                     ↑            ↑       │
│  Margin   Accent   Text                                  Accent       Text     │
│  (1 sp)   Color    Color                                 Color        Color    │
└────────────────────────────────────────────────────────────────────────────┘

HLD INTEGRATION:
┌─ MENU LINE ─────────┐    ┌─ LINE DISPLAY ──┐    ┌─ OUTPUT ─┐
│ Write-MenuLine      │◄──►│ Left: Number+   │───►│ Single   │
│ • MenuNumber        │    │       Text      │    │ Styled   │
│ • Text              │    │ Right: Suffix+  │    │ Menu     │
│ • SuffixNumber      │    │        Number   │    │ Line     │
│ • Suffix            │    │ Width-aware     │    │          │
└─────────────────────┘    └─────────────────┘    └──────────┘

THEME INTEGRATION:
• MenuNumber uses theme 'Accent' color (Cyan in Default theme)
• Period "." uses theme 'Muted' color for subtle separation
• Text uses theme 'Text' color (White in Default theme)
• SuffixNumber uses theme 'Accent' color (matches MenuNumber)
• Suffix uses theme 'Text' color (matches Text)
• All colors can be overridden via parameters

WIDTH & ALIGNMENT:
• Respects OrionMaxWidth global setting (default: 100)
• Left margin controlled by -Indent parameter (default: 1)
• Right margin equals left margin for symmetry
• Suffix is right-aligned like Write-ActionResult
================================================================================
#>

<#
.SYNOPSIS
Writes a single styled menu line with optional right-aligned suffix.

.DESCRIPTION
The Write-MenuLine function outputs a single menu line with a number and title
on the left, and an optional suffix with number on the right (right-aligned).
If SuffixNumber is 0 or empty, only the MenuNumber and Text are displayed.

This function is designed for building custom menus where you need more control
than Write-Menu provides. It respects OrionMaxWidth for alignment and uses
theme colors for consistent styling across your application.

OUTPUT FORMAT:
 When SuffixNumber is provided and non-zero:
   [Indent][Number]. [Text]                          [SuffixNumber] [Suffix]

 When SuffixNumber is 0 or empty:
   [Indent][Number]. [Text]

THEME COLORS USED:
 - MenuNumber: Accent color (cyan by default)
 - Period (.): Muted color (dark gray)
 - Text: Text color (white by default)  
 - SuffixNumber: Accent color (matches MenuNumber)
 - Suffix: Text color (matches Text)

ALIGNMENT:
 - Left margin: Controlled by -Indent (default 1 space)
 - Right margin: Same as left margin for symmetry
 - Suffix: Right-aligned to (OrionMaxWidth - RightMargin)

.PARAMETER MenuNumber
The menu option number or identifier displayed on the left side.
Can be a number (1, 2, 3) or text (A, B, X).
Displayed in the theme's Accent color.

.PARAMETER Text  
The menu option text or description displayed after the number.
This is the main text the user sees for the menu option.
Displayed in the theme's Text color.

.PARAMETER SuffixNumber
Optional count or number to display on the right side.
If this is 0, empty, or not provided, no suffix is displayed.
Useful for showing item counts, statistics, or status numbers.
Displayed in the theme's Accent color (matches MenuNumber).

.PARAMETER Suffix
Optional text label displayed after SuffixNumber on the right.
Typically a unit or description like "users", "items", "pending".
Only displayed if SuffixNumber is provided and non-zero.
Displayed in the theme's Text color (matches Text).

.PARAMETER Indent
Number of spaces for left margin (and right margin for symmetry).
Defaults to 1, matching Write-Action's default behavior.
Set to 0 for no indentation.

.PARAMETER Muted
Switch to display the entire menu line in the theme's Muted color.
Useful for indicating disabled, unavailable, or inactive menu options.
When enabled, overrides all color settings (MenuNumberColor, TextColor, SuffixColor).

.PARAMETER MenuNumberColor
Override color for the MenuNumber.
Accepts any valid PowerShell console color.
Defaults to theme Accent color if not specified.

.PARAMETER TextColor
Override color for the Text.
Accepts any valid PowerShell console color.
Defaults to theme Text color if not specified.

.PARAMETER SuffixColor
Override color for both SuffixNumber and Suffix text.
Accepts any valid PowerShell console color.
Defaults to Accent for SuffixNumber and Text for Suffix if not specified.

.INPUTS
None. You cannot pipe objects to Write-MenuLine.

.OUTPUTS
None. Write-MenuLine writes directly to the host console.

.EXAMPLE
Write-MenuLine -MenuNumber 1 -Text "View Users"

Outputs a simple menu line without suffix:
 1. View Users

.EXAMPLE
Write-MenuLine -MenuNumber 1 -Text "View Users" -SuffixNumber 142 -Suffix "users"

Outputs a menu line with right-aligned count:
 1. View Users                                                        142 users

.EXAMPLE
Write-MenuLine -MenuNumber 2 -Text "Pending Approvals" -SuffixNumber 5 -Suffix "pending"

Outputs:
 2. Pending Approvals                                                 5 pending

.EXAMPLE
Write-MenuLine -MenuNumber 3 -Text "Archived Items" -SuffixNumber 0

When SuffixNumber is 0, no suffix is displayed:
 3. Archived Items

.EXAMPLE
Write-MenuLine -MenuNumber "X" -Text "Exit" -TextColor "DarkGray"

Using a letter instead of number, with custom color:
 X. Exit

.EXAMPLE
# Building a custom menu with counts
$menuItems = @(
    @{ Num = 1; Title = "Active Users"; Count = 142 },
    @{ Num = 2; Title = "Pending Requests"; Count = 5 },
    @{ Num = 3; Title = "Completed Tasks"; Count = 89 }
)

Write-Separator -Text "User Management" -Style Double
foreach ($item in $menuItems) {
    Write-MenuLine -MenuNumber $item.Num -Text $item.Title -SuffixNumber $item.Count
}
Write-MenuLine -MenuNumber "X" -Text "Exit" -TextColor DarkGray

Outputs:
═══ User Management ═══════════════════════════════════════════════════════════════
 1. Active Users                                                             142
 2. Pending Requests                                                           5
 3. Completed Tasks                                                           89
 X. Exit

.EXAMPLE
# Using with different themes
Set-OrionTheme -Preset Matrix
Write-MenuLine -MenuNumber 1 -Text "Decrypt Files" -SuffixNumber 50 -Suffix "files"

With Matrix theme, colors change to green/dark green aesthetic.

.EXAMPLE
# Custom indentation
Write-MenuLine -MenuNumber 1 -Text "Main Option" -Indent 0
Write-MenuLine -MenuNumber "1a" -Text "Sub Option" -Indent 4
Write-MenuLine -MenuNumber "1b" -Text "Sub Option" -Indent 4

Creates hierarchical menu structure:
1. Main Option
    1a. Sub Option
    1b. Sub Option

.EXAMPLE
# Using -Muted for disabled/unavailable options
Write-MenuLine -MenuNumber 1 -Text "Available Option" -SuffixNumber 10 -Suffix "items"
Write-MenuLine -MenuNumber 2 -Text "Disabled Option" -SuffixNumber 0 -Muted
Write-MenuLine -MenuNumber 3 -Text "Another Available" -SuffixNumber 5 -Suffix "items"

The muted line appears in dark gray, indicating it's unavailable:
 1. Available Option                                                   10 items
 2. Disabled Option
 3. Another Available                                                   5 items

.NOTES
DESIGN PHILOSOPHY:
This function is designed for building custom menus with consistent OrionDesign
styling. Use it in loops or custom menu builders where the interactive Write-Menu
function doesn't fit your use case.

COMPARISON WITH WRITE-MENU:
- Write-Menu: Full interactive menu with keyboard navigation and selection
- Write-MenuLine: Single line output for building custom non-interactive menus

ALIGNMENT SYSTEM:
Uses the same margin system as Write-Action/Write-ActionResult:
- Left margin controlled by -Indent (default 1)
- Right margin equals left margin for symmetry
- Suffix right-aligned to (OrionMaxWidth - RightMargin)

THEME CONSISTENCY:
All colors are pulled from the current theme:
- Accent: MenuNumber and SuffixNumber (eye-catching for numbers)
- Muted: Period separator (subtle, non-distracting)
- Text: Text and Suffix (primary readable content)

See Get-OrionTheme and Set-OrionTheme for theme customization.

.LINK
Write-Menu

.LINK
Write-Action

.LINK  
Write-ActionResult

.LINK
Set-OrionTheme
#>
function Write-MenuLine {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$MenuNumber,
        [Parameter(Mandatory)][string]$Text,
        [string]$SuffixNumber = "",
        [string]$Suffix = "",
        [int]$Indent = 1,
        [switch]$Muted,
        [string]$MenuNumberColor = "",
        [string]$TextColor = "",
        [string]$SuffixColor = ""
    )

    # Initialize theme if not set
    if (-not $script:Theme) {
        $script:Theme = @{
            Accent  = 'Cyan'
            Success = 'Green'
            Warning = 'Yellow'
            Error   = 'Red'
            Text    = 'White'
            Muted   = 'DarkGray'
            Action  = 'White'
            Result  = 'Cyan'
            UseAnsi = $true
        }
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    # Use global max width if not set
    if (-not $script:OrionMaxWidth) {
        $script:OrionMaxWidth = 100
    }

    # Determine colors from theme or parameters
    # If -Muted is enabled, override all colors with Muted
    if ($Muted) {
        $numColor = $script:Theme.Muted
        $textColor = $script:Theme.Muted
        $suffixNumColor = $script:Theme.Muted
        $suffixTxtColor = $script:Theme.Muted
    } else {
        $numColor = if ($MenuNumberColor) { $MenuNumberColor } else { $script:Theme.Accent }
        $textColor = if ($TextColor) { $TextColor } else { $script:Theme.Text }
        # SuffixNumber shares color with MenuNumber (Accent)
        # Suffix shares color with Text
        $suffixNumColor = if ($SuffixColor) { $SuffixColor } else { $script:Theme.Accent }
        $suffixTxtColor = if ($SuffixColor) { $SuffixColor } else { $script:Theme.Text }
    }

    # Build indentation string
    $indentString = if ($Indent -gt 0) { ' ' * $Indent } else { '' }

    # Build left side: "  1. Menu Text"
    $leftText = "$MenuNumber. $Text"
    $leftLength = $indentString.Length + $leftText.Length

    # Calculate effective width (respecting margins like Write-ActionResult)
    $rightMargin = $Indent
    $effectiveWidth = $script:OrionMaxWidth - $rightMargin

    # Check if we have suffix to display
    $hasSuffix = $false
    if ($SuffixNumber -and $SuffixNumber -ne "0" -and $SuffixNumber -ne "") {
        $hasSuffix = $true
    }

    # Output the line
    Write-Host $indentString -NoNewline
    Write-Host "$MenuNumber. " -ForegroundColor $numColor -NoNewline
    Write-Host $Text -ForegroundColor $textColor -NoNewline

    if ($hasSuffix) {
        # Build suffix text for length calculation
        $suffixText = if ($Suffix) { "$SuffixNumber $Suffix" } else { "$SuffixNumber" }
        
        # Calculate padding for right-alignment
        $padding = $effectiveWidth - $leftLength - $suffixText.Length
        
        if ($padding -gt 0) {
            Write-Host (" " * $padding) -NoNewline
        }
        
        # Output SuffixNumber in Accent color (or Muted), Suffix in Text color (or Muted)
        Write-Host $SuffixNumber -ForegroundColor $suffixNumColor -NoNewline
        if ($Suffix) {
            Write-Host " $Suffix" -ForegroundColor $suffixTxtColor
        } else {
            Write-Host
        }
    } else {
        # No suffix, just end the line
        Write-Host
    }
}

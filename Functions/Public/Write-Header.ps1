<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Header Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Information Display
Dependencies:  OrionDesign Theme System, ANSI Support

FUNCTION PURPOSE:
Creates formatted headers with underlines, numbering, and markup support.
Core information display component providing structured text headers with
rich formatting options including color markup and ANSI underlines.

HLD INTEGRATION:
┌─ INFORMATION ─┐    ┌─ FORMATTING ─┐    ┌─ OUTPUT ─┐
│ Write-Header  │◄──►│ ANSI Support │───►│ Styled   │
│ • Text/Number │    │ Color Markup │    │ Headers  │
│ • Underlines  │    │ Underline    │    │ Under-   │
│ • Markup Tags │    │ Auto/Manual  │    │ lined    │
└───────────────┘    └──────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates a formatted header with optional underlines and step numbering.

.DESCRIPTION
The Write-Header function displays styled text headers with customizable underlines and optional step numbering. It supports color markup tags for rich formatting and integrates with the OrionDesign theme system.

.PARAMETER Text
The header text to display. Supports markup tags for colored formatting:
- <accent>text</accent> - Displays text in theme accent color (cyan)
- <success>text</success> - Displays text in theme success color (green)  
- <warning>text</warning> - Displays text in theme warning color (yellow)
- <error>text</error> - Displays text in theme error color (red)
- <muted>text</muted> - Displays text in theme muted color (dark gray)
- <text>text</text> - Displays text in theme text color (white)
- <underline>text</underline> - Underlines specific portions of text using ANSI formatting

.PARAMETER Underline
Specifies the underline style for the header. Valid values:
- 'Auto' (default) - Creates an underline matching the text length
- 'Full' - Creates an underline spanning the full terminal width
- 'Ansi' - Uses ANSI formatting to underline the actual text
- 'None' - No underline

.PARAMETER Number
Optional step number to prepend to the header text. When specified, the header will display as "Step {Number}: {Text}".

.PARAMETER Width
Override the terminal width for underline calculations. If not specified, uses the current terminal width (default: 80 if detection fails).

.INPUTS
None. You cannot pipe objects to Write-Header.

.OUTPUTS
None. Write-Header displays formatted output to the console.

.EXAMPLE
Write-Header "Welcome to My Script"

Displays a header with "Welcome to My Script" and an auto-sized underline.

.EXAMPLE
Write-Header "Processing Data" -Underline Full

Displays a header with a full-width underline spanning the entire terminal.

.EXAMPLE
Write-Header "Initialize System" -Number 1

Displays "Step 1: Initialize System" with an auto-sized underline.

.EXAMPLE
Write-Header "<accent>Important:</accent> <warning>Check Configuration</warning>" -Underline Full

Displays a colorized header where "Important:" appears in cyan and "Check Configuration" appears in yellow, with a full-width underline.

.EXAMPLE
Write-Header "Phase Complete" -Number 3 -Underline None

Displays "Step 3: Phase Complete" without any underline.

.EXAMPLE
Write-Header "Custom Width Demo" -Width 50 -Underline Full

Displays a header with underline limited to 50 characters width instead of terminal width.

.EXAMPLE
Write-Header "Properly Underlined Text" -Underline Ansi

Displays a header with ANSI underline formatting applied directly to the text (not a separate line below).

.EXAMPLE
Write-Header "This is <underline>partially underlined</underline> text"

Displays a header where only the words "partially underlined" are underlined using ANSI formatting.

.EXAMPLE
Write-Header "<accent>Status:</accent> <underline><success>Processing Complete</success></underline>" -Underline None

Displays a colorized header where "Status:" is cyan, "Processing Complete" is green and underlined, with no additional underline below.

.NOTES
- The function integrates with the OrionDesign theme system
- Color markup is processed by the Convert-ToColoredSegments function
- ANSI formatting is automatically disabled in PowerShell ISE
- Default theme colors can be customized via the $script:Theme variable

.LINK
Write-Banner

.LINK
Convert-ToColoredSegments

.LINK
Write-Colored
#>
function Write-Header {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [ValidateSet('Auto','Full','Ansi','None')] [string]$Underline = 'Auto',
        [int]$Number,
        [int]$Width
    )

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

    $w = if ($Width) { $Width } else { try { [Console]::WindowWidth } catch { 80 } }

    if ($Number) { $Text = "Step $($Number): $Text" }

    # Handle ANSI underline differently - apply to segments before processing
    if ($Underline -eq 'Ansi' -and $script:Theme.UseAnsi) {
        # Add underline markup to the entire text
        $Text = "<underline>$Text</underline>"
    }

    $segments = Convert-ToColoredSegments -Text $Text -Theme $script:Theme
    Write-Colored -Segments $segments -Theme $script:Theme

    if ($Underline -ne 'None' -and $Underline -ne 'Ansi') {
        switch ($Underline) {
            'Auto' {
                $len = ($Text -replace '<[^>]+>','').Length
                Write-Host ($script:Theme.Divider * $len) -ForegroundColor $script:Theme.Accent
            }
            'Full' {
                Write-Host ($script:Theme.Divider * $w) -ForegroundColor $script:Theme.Accent
            }
        }
    }
}

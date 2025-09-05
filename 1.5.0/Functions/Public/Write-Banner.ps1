<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Banner Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Information Display
Dependencies:  OrionD    # Left padding
    Write-Host ($Indent2 + $Padding2[0]) -ForegroundColor $Theme.Accent -NoNewline
    # Content
    $PaddingSpaces2 = ' ' * $ContentPadding2
    Write-Host ($PaddingSpaces2 + $Content2 + $PaddingSpaces2) -ForegroundColor $Theme.Text -NoNewline
    # Right padding
    Write-Host ($Padding2[1] + $Indent2) -ForegroundColor $Theme.Accentheme System

FUNCTION PURPOSE:
Creates decorative banners for script headers with multiple design options.
Part of the OrionDesign framework's Information Display category, providing
professional script headers with consistent styling and branding.

HLD INTEGRATION:
┌─ INFORMATION DISPLAY ─┐    ┌─ GLOBAL CONFIG ─┐    ┌─ OUTPUT ─┐
│ Write-Banner          │◄──►│ $script:Theme    │───►│ ANSI     │
│ • Classic Design      │    │ • Colors         │    │ Terminal │
│ • Modern Design       │    │ • Compatibility  │    │ ISE      │
│ • Minimal Design      │    │ $script:MaxWidth │    │ Fallback │
└─────────────────────────┘    └──────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates decorative banners for script headers with multiple design options.

.DESCRIPTION
The Write-Banner function displays decorative banners with script information including name, author, date, and description. Multiple design styles are available including Wings, Classic, Modern, Minimal, Geometric, and Diamond patterns. The banner width can be specified for consistent centering with other script output.

.PARAMETER Theme
Optional hashtable containing color theme. Uses module default if not specified.
Available themes can be set using Set-OrionTheme with these presets:

Standard Themes: Default (Blue accent), Dark (Dark blue/gray), Light (Blue with white background)
Nature Themes: Ocean (Blue/teal marine colors), Forest (Green woodland colors)
Retro/Vintage Themes: OldSchool (Amber monochrome DOS-style), Vintage (Sepia warm tones), Retro80s (Magenta/cyan synthwave)
Tech/Futuristic Themes: Matrix (Green hacker aesthetic), Cyberpunk (Neon cyan/purple)
Artistic Themes: Sunset (Orange/purple gradients), Monochrome (Pure black/white contrast)

Use Get-OrionTheme to see current theme or Set-OrionTheme -Preset <ThemeName> to change.

.PARAMETER ScriptName
The name of the script to display in the banner.

.PARAMETER Author
Optional author name to display.

.PARAMETER AuthorDate
Optional date/timestamp to display.

.PARAMETER Description
Optional description text to display.

.PARAMETER Design
The design style for the banner. Available designs:
• Wings: Elegant banner with wing-like decorative elements extending from center
• Classic: Traditional banner with corner decorations and straight lines
• Modern: Clean, sleek banner with subtle accents and minimal decorations
• Minimal: Simple, understated banner with minimal decorative elements
• Geometric: Modern banner featuring geometric patterns and shapes
• Diamond: Decorative banner with diamond/rhombus shaped accents

Valid values: Wings, Classic, Modern, Minimal, Geometric, Diamond.

.PARAMETER Width
The width to use for centering the banner. If not specified, uses $script:OrionMaxWidth if set, otherwise the terminal width. This ensures banners are aligned with other script output.

.EXAMPLE
Write-Banner -ScriptName "Data Processor" -Author "John Doe" -Design Wings -Width 80

Creates a wings-style banner for a script called "Data Processor" by John Doe, centered to width 80.

.EXAMPLE
Write-Banner -ScriptName "System Monitor" -Description "Real-time system monitoring" -Design Diamond

Creates a diamond-style banner with script name and description, using the default width.

.EXAMPLE
Write-Banner -ScriptName "Backup Tool" -Author "Admin" -AuthorDate "2025-01-15" -Design Modern -Width 100

Creates a modern-style banner with full script information, centered to width 100.

.EXAMPLE
Write-Banner -ScriptName "Security Scanner" -Design Classic

Creates a classic-style banner with traditional corner decorations.

.EXAMPLE
Write-Banner -ScriptName "Quick Task" -Design Minimal

Creates a minimal-style banner with understated decorative elements.

.EXAMPLE
Write-Banner -ScriptName "Analytics Engine" -Design Geometric

Creates a geometric-style banner featuring modern patterns and shapes.

.EXAMPLE
Set-OrionTheme -Preset Matrix
Write-Banner -ScriptName "Security Audit" -Author "IT Team" -Design Modern

Sets Matrix theme (green hacker aesthetic) and creates a modern banner.

.EXAMPLE
Set-OrionTheme -Preset Sunset
Write-Banner -ScriptName "Data Analysis" -Description "Monthly reporting tool" -Design Wings

Uses Sunset theme (orange/purple) with wings design for an elegant banner.

.EXAMPLE
$customTheme = @{ Accent='Magenta'; Success='Green'; Warning='Yellow'; Error='Red'; Text='White'; Muted='Gray' }
Write-Banner -Theme $customTheme -ScriptName "Custom Script" -Design Classic -Width 70

Creates a banner using a custom color theme with classic design, centered to width 70.
#>
function Write-Banner {
    [CmdletBinding()]
    param(
        [hashtable]$Theme = $script:Theme,
        [Parameter(Mandatory)][string]$ScriptName,
        [string]$Author = "",
        [string]$AuthorDate = "",
        [string]$Description = "",
        [ValidateSet('Wings', 'Classic', 'Modern', 'Minimal', 'Geometric', 'Diamond')] [string]$Design = 'Wings',
        [int]$Width = $null
    )

    # Default theme if not provided
    if (-not $Theme) {
        $Theme = @{
            Accent   = 'Cyan'
            Success  = 'Green'
            Warning  = 'Yellow'
            Error    = 'Red'
            Text     = 'White'
            Muted    = 'DarkGray'
            Divider  = '─'
            UseAnsi  = $true
        }
        if ($psISE) { $Theme.UseAnsi = $false }
    }

    # Determine max width for centering
    if ($Width) {
        $maxWidth = $Width
    } elseif ($script:OrionMaxWidth) {
        $maxWidth = $script:OrionMaxWidth
    } else {
        $terminalWidth = try { [Console]::WindowWidth } catch { 80 }
        $maxWidth = $terminalWidth - 4
    }

    # Add spacing (removed Clear-Host as it's too aggressive)
    Write-Host

    switch ($Design) {
        'Wings' {
            Write-WingsDesign -ScriptName $ScriptName -Author $Author -AuthorDate $AuthorDate -Description $Description -Theme $Theme -MaxWidth $maxWidth
        }
        'Classic' {
            Write-ClassicDesign -ScriptName $ScriptName -Author $Author -AuthorDate $AuthorDate -Description $Description -Theme $Theme -MaxWidth $maxWidth
        }
        'Modern' {
            Write-ModernDesign -ScriptName $ScriptName -Author $Author -AuthorDate $AuthorDate -Description $Description -Theme $Theme -MaxWidth $maxWidth
        }
        'Minimal' {
            Write-MinimalDesign -ScriptName $ScriptName -Author $Author -AuthorDate $AuthorDate -Description $Description -Theme $Theme -MaxWidth $maxWidth
        }
        'Geometric' {
            Write-GeometricDesign -ScriptName $ScriptName -Author $Author -AuthorDate $AuthorDate -Description $Description -Theme $Theme -MaxWidth $maxWidth
        }
        'Diamond' {
            Write-DiamondDesign -ScriptName $ScriptName -Author $Author -AuthorDate $AuthorDate -Description $Description -Theme $Theme -MaxWidth $maxWidth
        }
    }

    Write-Host
}

# Wings Design - Beautiful wing-shaped pattern
function Write-WingsDesign {
    param($ScriptName, $Author, $AuthorDate, $Description, $Theme, $MaxWidth)
    
    $bannerWidth = $MaxWidth
    $centerPos = [Math]::Floor($bannerWidth / 2)
    $paddingSymbol = '█'
    
    # Wing pattern - creates expanding then contracting pattern
    $wingPattern = @(2, 4, 6, 8, 10, 12, 14, 16, 18, 16, 14, 12, 10, 8, 6, 4, 2)
    
    # Top wing
    foreach ($width in $wingPattern[0..8]) {
        $spaces = ' ' * ($centerPos - $width)
        $wing = $paddingSymbol * $width
        Write-Host ($spaces + $wing + (' ' * ($bannerWidth - ($centerPos - $width) - $width * 2)) + $wing) -ForegroundColor $Theme.Accent
    }
    
    # Script name line
    $nameWidth = $ScriptName.Length
    $nameSpaces = [Math]::Max(0, [Math]::Floor(($bannerWidth - $nameWidth) / 2))
    $nameLine = (' ' * $nameSpaces) + $ScriptName + (' ' * ($bannerWidth - $nameSpaces - $nameWidth))
    Write-Host $nameLine -ForegroundColor $Theme.Text -BackgroundColor $Theme.Success
    
    # Author and date line (if provided)
    if ($Author -or $AuthorDate) {
        $authorInfo = if ($Author -and $AuthorDate) { "$Author - $AuthorDate" } elseif ($Author) { $Author } else { $AuthorDate }
        $authorWidth = $authorInfo.Length
        $authorSpaces = [Math]::Max(0, [Math]::Floor(($bannerWidth - $authorWidth) / 2))
        $authorLine = (' ' * $authorSpaces) + $authorInfo + (' ' * ($bannerWidth - $authorSpaces - $authorWidth))
        Write-Host $authorLine -ForegroundColor $Theme.Muted
    }
    
    # Bottom wing
    foreach ($width in $wingPattern[9..16]) {
        $spaces = ' ' * ($centerPos - $width)
        $wing = $paddingSymbol * $width
        Write-Host ($spaces + $wing + (' ' * ($bannerWidth - ($centerPos - $width) - $width * 2)) + $wing) -ForegroundColor $Theme.Accent
    }
    
    # Description (if provided)
    if ($Description) {
        Write-Host
        $descLines = $Description -split "`n"
        foreach ($line in $descLines) {
            $line = $line.Trim()
            if ($line) {
                $lineSpaces = [Math]::Max(0, [Math]::Floor(($bannerWidth - $line.Length) / 2))
                Write-Host ((' ' * $lineSpaces) + $line) -ForegroundColor $Theme.Muted
            }
        }
    }
}

# Classic Design - Traditional rectangular banner
function Write-ClassicDesign {
    param($ScriptName, $Author, $AuthorDate, $Description, $Theme, $MaxWidth)
    
    $bannerWidth = $MaxWidth
    $border = '=' * $bannerWidth
    $paddingSymbol = '█'
    
    # Top border
    Write-Host $border -ForegroundColor $Theme.Accent
    
    # Empty line
    $emptyLine = $paddingSymbol + (' ' * ($bannerWidth - 2)) + $paddingSymbol
    Write-Host $emptyLine -ForegroundColor $Theme.Accent
    
    # Script name
    $nameSpaces = [Math]::Max(0, [Math]::Floor(($bannerWidth - 2 - $ScriptName.Length) / 2))
    $nameLine = $paddingSymbol + (' ' * $nameSpaces) + $ScriptName + (' ' * ($bannerWidth - 2 - $nameSpaces - $ScriptName.Length)) + $paddingSymbol
    Write-Host $nameLine -ForegroundColor $Theme.Text
    
    # Author info
    if ($Author -or $AuthorDate) {
        $authorInfo = if ($Author -and $AuthorDate) { "$Author - $AuthorDate" } elseif ($Author) { $Author } else { $AuthorDate }
        $authorSpaces = [Math]::Max(0, [Math]::Floor(($bannerWidth - 2 - $authorInfo.Length) / 2))
        $authorLine = $paddingSymbol + (' ' * $authorSpaces) + $authorInfo + (' ' * ($bannerWidth - 2 - $authorSpaces - $authorInfo.Length)) + $paddingSymbol
        Write-Host $authorLine -ForegroundColor $Theme.Muted
    }
    
    # Empty line
    Write-Host $emptyLine -ForegroundColor $Theme.Accent
    
    # Bottom border
    Write-Host $border -ForegroundColor $Theme.Accent
    
    # Description
    if ($Description) {
        Write-Host
        $descLines = $Description -split "`n"
        foreach ($line in $descLines) {
            $line = $line.Trim()
            if ($line) {
                Write-Host $line -ForegroundColor $Theme.Accent
            }
        }
    }
}

# Modern Design - Sleek with gradient effect
function Write-ModernDesign {
    param($ScriptName, $Author, $AuthorDate, $Description, $Theme, $MaxWidth)
    
    $bannerWidth = $MaxWidth
    
    # Modern header with gradient-like effect
    $chars = @('▓', '▒', '░')
    for ($i = 0; $i -lt 3; $i++) {
        Write-Host ($chars[$i] * $bannerWidth) -ForegroundColor $Theme.Accent
    }
    
    # Script name with modern styling
    Write-Host
    $segments = Convert-ToColoredSegments -Text "<accent>▶</accent> <text>$ScriptName</text> <accent>◀</accent>" -Theme $Theme
    Write-Colored -Segments $segments -Theme $Theme
    
    # Author info with modern bullets
    if ($Author -or $AuthorDate) {
        $authorInfo = if ($Author -and $AuthorDate) { "$Author • $AuthorDate" } elseif ($Author) { $Author } else { $AuthorDate }
        Write-Host "  $authorInfo" -ForegroundColor $Theme.Muted
    }
    
    # Modern footer
    Write-Host
    for ($i = 2; $i -ge 0; $i--) {
        Write-Host ($chars[$i] * $bannerWidth) -ForegroundColor $Theme.Accent
    }
    
    # Description
    if ($Description) {
        Write-Host
        $descLines = $Description -split "`n"
        foreach ($line in $descLines) {
            $line = $line.Trim()
            if ($line) {
                Write-Host "  ▸ $line" -ForegroundColor $Theme.Accent
            }
        }
    }
}

# Minimal Design - Clean and simple
function Write-MinimalDesign {
    param($ScriptName, $Author, $AuthorDate, $Description, $Theme, $MaxWidth)
    
    # Simple header line
    Write-Host ('─' * $MaxWidth) -ForegroundColor $Theme.Muted
    
    # Script name
    Write-Host $ScriptName.ToUpper() -ForegroundColor $Theme.Text
    
    # Author info
    if ($Author -or $AuthorDate) {
        $authorInfo = if ($Author -and $AuthorDate) { "$Author | $AuthorDate" } elseif ($Author) { $Author } else { $AuthorDate }
        Write-Host $authorInfo -ForegroundColor $Theme.Muted
    }
    
    # Simple footer line
    Write-Host ('─' * $MaxWidth) -ForegroundColor $Theme.Muted
    
    # Description
    if ($Description) {
        Write-Host
        $descLines = $Description -split "`n"
        foreach ($line in $descLines) {
            $line = $line.Trim()
            if ($line) {
                Write-Host $line -ForegroundColor $Theme.Accent
            }
        }
    }
}

# Geometric Design - Angular and modern
function Write-GeometricDesign {
    param($ScriptName, $Author, $AuthorDate, $Description, $Theme, $MaxWidth)
    
    $bannerWidth = $MaxWidth
    
    # Geometric top pattern
    for ($i = 1; $i -le 5; $i++) {
        $spaces = ' ' * (5 - $i)
        $pattern = '▲' * $i + ' ' + $ScriptName.ToUpper() + ' ' + '▲' * $i
        if ($i -eq 3) {
            # Middle line with script name
            $nameSpaces = [Math]::Max(0, [Math]::Floor(($bannerWidth - $pattern.Length) / 2))
            Write-Host ((' ' * $nameSpaces) + $pattern) -ForegroundColor $Theme.Text
        } else {
            $simplePattern = '▲' * $i + (' ' * ($bannerWidth - $i * 2)) + '▲' * $i
            Write-Host $simplePattern -ForegroundColor $Theme.Accent
        }
    }
    
    # Author info with geometric styling
    if ($Author -or $AuthorDate) {
        $authorInfo = if ($Author -and $AuthorDate) { "◆ $Author ◆ $AuthorDate ◆" } elseif ($Author) { "◆ $Author ◆" } else { "◆ $AuthorDate ◆" }
        $authorSpaces = [Math]::Max(0, [Math]::Floor(($bannerWidth - $authorInfo.Length) / 2))
        Write-Host ((' ' * $authorSpaces) + $authorInfo) -ForegroundColor $Theme.Muted
    }
    
    # Geometric bottom pattern
    for ($i = 5; $i -ge 1; $i--) {
        $pattern = '▼' * $i + (' ' * ($bannerWidth - $i * 2)) + '▼' * $i
        Write-Host $pattern -ForegroundColor $Theme.Accent
    }
    
    # Description
    if ($Description) {
        Write-Host
        $descLines = $Description -split "`n"
        foreach ($line in $descLines) {
            $line = $line.Trim()
            if ($line) {
                Write-Host "  ◈ $line" -ForegroundColor $Theme.Accent
            }
        }
    }
}

# Diamond Design - Progressive indentation creating diamond/pyramid shape
function Write-DiamondDesign {
    param($ScriptName, $Author, $AuthorDate, $Description, $Theme, $MaxWidth)
    
    $bannerWidth = $MaxWidth
    $paddingSymbol = '═'
    $indentationIncrement = 4  # How much to indent each level
    
    # Helper function to calculate padding 
    function Get-Padding {
        param (
            [int]$TotalWidth,
            [int]$LeftIndentLength,
            [int]$RightIndentLength,
            [string]$Content,
            [int]$ContentPadding
        )
        $ContentLength = $Content.Length + (2 * $ContentPadding)
        $PaddingWidth = $TotalWidth - $LeftIndentLength - $RightIndentLength - $ContentLength
        $PaddingEachSide = [math]::Floor($PaddingWidth / 2)
        $PaddingRemainder = $PaddingWidth % 2
        $LeftPadding = $paddingSymbol * $PaddingEachSide
        $RightPadding = $paddingSymbol * ($PaddingEachSide + $PaddingRemainder)
        return @($LeftPadding, $RightPadding)
    }
    
    # Helper function to center text
    function Center-Text {
        param([string]$Text, [int]$TotalWidth)
        $textLength = $Text.Length
        if ($textLength -ge $TotalWidth) { return $Text }
        $spaces = $TotalWidth - $textLength
        $leftSpaces = [Math]::Floor($spaces / 2)
        $rightSpaces = $spaces - $leftSpaces
        return (' ' * $leftSpaces) + $Text + (' ' * $rightSpaces)
    }

    # Calculate indentations (0, 4, 8, 12 spaces)
    $Indentations = @()
    for ($i = 0; $i -le 3; $i++) {
        $Indentations += ' ' * ($indentationIncrement * $i)
    }

    # Line 1: Indentation Level 0 (outermost)
    $Indent1 = $Indentations[0]
    $PaddingWidth1 = $bannerWidth - ($Indent1.Length * 2)
    $Line1Padding = $paddingSymbol * $PaddingWidth1
    Write-Host ($Indent1 + $Line1Padding + $Indent1) -ForegroundColor $Theme.Accent

    # Line 2: Indentation Level 1 (script name)
    $Indent2 = $Indentations[1]
    $Content2 = $ScriptName
    $ContentPadding2 = 4
    $Padding2 = Get-Padding -TotalWidth $bannerWidth -LeftIndentLength $Indent2.Length -RightIndentLength $Indent2.Length -Content $Content2 -ContentPadding $ContentPadding2
    
    # Left padding
    Write-Host ($Indent2 + $Padding2[0]) -ForegroundColor $Theme.Accent -NoNewline
    # Content
    $PaddingSpaces2 = ' ' * $ContentPadding2
    Write-Host ($PaddingSpaces2 + $Content2 + $PaddingSpaces2) -ForegroundColor $Theme.Text -NoNewline
    # Right padding
    Write-Host ($Padding2[1] + $Indent2) -ForegroundColor $Theme.Accent

    # Line 3: Indentation Level 2 (author and date)
    if ($Author -or $AuthorDate) {
        $Indent3 = $Indentations[2]
        $Content3 = if ($Author -and $AuthorDate) { "$Author - $AuthorDate" } elseif ($Author) { $Author } else { $AuthorDate }
        $ContentPadding3 = 3
        $Padding3 = Get-Padding -TotalWidth $bannerWidth -LeftIndentLength $Indent3.Length -RightIndentLength $Indent3.Length -Content $Content3 -ContentPadding $ContentPadding3
        
        # Left padding
        Write-Host ($Indent3 + $Padding3[0]) -ForegroundColor $Theme.Accent -NoNewline
        # Content
        $PaddingSpaces3 = ' ' * $ContentPadding3
        Write-Host ($PaddingSpaces3 + $Content3 + $PaddingSpaces3) -ForegroundColor $Theme.Text -NoNewline
        # Right padding
        Write-Host ($Padding3[1] + $Indent3) -ForegroundColor $Theme.Accent
    }

    # Line 4: Indentation Level 3 (innermost)
    $Indent4 = $Indentations[3]
    $PaddingWidth4 = $bannerWidth - ($Indent4.Length * 2)
    $Line4Padding = $paddingSymbol * $PaddingWidth4
    Write-Host ($Indent4 + $Line4Padding + $Indent4) -ForegroundColor $Theme.Accent

    # Description Lines (centered)
    if ($Description) {
        $DescriptionLines = $Description -split "`n"
        foreach ($line in $DescriptionLines) {
            $line = $line.Trim()
            if ($line) {
                $centeredLine = Center-Text -Text $line -TotalWidth $bannerWidth
                Write-Host $centeredLine -ForegroundColor DarkGray
            }
        }
    }
}

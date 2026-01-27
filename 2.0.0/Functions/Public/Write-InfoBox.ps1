<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-InfoBox Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
Category:      Information Display
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates bordered information boxes with titles and multiple styling options.
Versatile information display component providing highlighted content areas
with automatic width calculation and various visual styles.

HLD INTEGRATION:
┌─ INFORMATION ─┐    ┌─ BOX STYLES ─┐    ┌─ OUTPUT ─┐
│ Write-InfoBox │◄──►│ Classic/Modern│───►│ Bordered │
│ • Title/Content│    │ Simple/Accent │    │ Info     │
│ • Auto Width   │    │ Icon Support  │    │ Content  │
│ • Safety Checks│    │ Width Control │    │ Safe     │
└────────────────┘    └───────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Displays formatted information in styled boxes or panels.

.DESCRIPTION
The Write-InfoBox function creates visually appealing information displays with titles, key-value pairs, and different styling options.

.PARAMETER Title
The title of the information box.

.PARAMETER Content
Hashtable of key-value pairs to display, or array of strings.

.PARAMETER Style
The visual style of the box. Available styles:
• Classic: Traditional box with decorative borders and formal presentation
• Modern: Contemporary flat design with clean lines and subtle shadows
• Simple: Minimal styling with basic borders and understated formatting
• Accent: Highlighted presentation using theme accent colors for emphasis

Valid values: Classic, Modern, Simple, Accent

.PARAMETER Width
Width of the information box (default: auto-calculate).

.EXAMPLE
Write-InfoBox -Title "System Information" -Content @{
    "Server" = "SQL-01"
    "Database" = "Production" 
    "Version" = "2019 SP3"
}

Displays system information in a formatted box.

.EXAMPLE
Write-InfoBox -Title "Configuration" -Content @("Setting 1: Enabled", "Setting 2: Disabled") -Style Modern

Displays configuration information in modern style.
#>
function Write-InfoBox {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)]$Content,
        [ValidateSet('Classic', 'Modern', 'Simple', 'Accent')] [string]$Style = 'Classic',
        [int]$Width = 0,
        [switch]$WrapContent  # Enable word wrapping for long content lines
    )

    # Helper function for word wrapping
    function Wrap-Text {
        param([string]$Text, [int]$MaxWidth)
        if ($Text.Length -le $MaxWidth -or $MaxWidth -le 0) { return @($Text) }
        
        $words = $Text -split '\s+'
        $lines = @()
        $currentLine = ""
        
        foreach ($word in $words) {
            $testLine = if ($currentLine) { "$currentLine $word" } else { $word }
            if ($testLine.Length -le $MaxWidth) {
                $currentLine = $testLine
            } else {
                if ($currentLine) { $lines += $currentLine }
                $currentLine = $word
            }
        }
        if ($currentLine) { $lines += $currentLine }
        return $lines
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

    # Calculate width with proper content analysis
    $maxKeyLength = 0
    $maxValueLength = 0
    $maxContentWidth = 0
    $contentLines = @()

    if ($Content -is [hashtable]) {
        foreach ($key in $Content.Keys) {
            $value = $Content[$key]
            $contentLines += "$key`: $value"
            if ($key.Length -gt $maxKeyLength) { $maxKeyLength = $key.Length }
            if ($value.ToString().Length -gt $maxValueLength) { $maxValueLength = $value.ToString().Length }
            # Calculate total line width for hashtable content
            $totalLineWidth = $key.Length + 3 + $value.ToString().Length  # key + " : " + value
            if ($totalLineWidth -gt $maxContentWidth) { $maxContentWidth = $totalLineWidth }
        }
    } else {
        $contentLines = $Content
        foreach ($line in $contentLines) {
            if ($line.Length -gt $maxValueLength) { $maxValueLength = $line.Length }
            # For simple content, the line length IS the content width
            if ($line.Length -gt $maxContentWidth) { $maxContentWidth = $line.Length }
        }
    }

    if ($Width -eq 0) {
        # Use global max width if available
        $globalWidth = if ($script:OrionMaxWidth) { $script:OrionMaxWidth } else { 80 }
        
        # Calculate minimum width based on actual content requirements
        $titleWidthReq = $Title.Length + 10  # Title + decorative elements
        $contentWidthReq = $maxContentWidth + 4  # Content + border chars (│ + space + content + space + │)
        $minWidth = [Math]::Max($titleWidthReq, $contentWidthReq)
        
        # Respect global width while ensuring content fits
        $Width = [Math]::Max(40, [Math]::Min($globalWidth, $minWidth))
        
        # If content still doesn't fit within global limit, expand to accommodate it
        if ($minWidth -gt $globalWidth) {
            $Width = $minWidth
            Write-Verbose "Content width ($minWidth) exceeds global limit ($globalWidth), expanding to fit content"
        }
    }
    
    # Ensure minimum width to prevent negative values
    $Width = [Math]::Max($Width, $Title.Length + 6)

    Write-Host

    switch ($Style) {
        'Classic' {
            # Top border - ensure non-negative width
            Write-Host "┌─ " -ForegroundColor $script:Theme.Accent -NoNewline
            Write-Host $Title -ForegroundColor $script:Theme.Text -NoNewline
            $borderLength = [Math]::Max(0, $Width - $Title.Length - 5)
            Write-Host (" " + "─" * $borderLength + "┐") -ForegroundColor $script:Theme.Accent

            # Content
            foreach ($line in $contentLines) {
                if ($Content -is [hashtable] -and $line -match '^([^:]+): (.+)$') {
                    $key = $matches[1]
                    $value = $matches[2]
                    
                    if ($WrapContent -and $value.Length -gt ($Width - $maxKeyLength - 8)) {
                        # Wrap long values
                        $maxValueWidth = $Width - $maxKeyLength - 8
                        $wrappedLines = Wrap-Text -Text $value -MaxWidth $maxValueWidth
                        
                        # First line with key
                        Write-Host "│ " -ForegroundColor $script:Theme.Accent -NoNewline
                        Write-Host $key.PadRight($maxKeyLength) -ForegroundColor $script:Theme.Accent -NoNewline
                        Write-Host " : " -ForegroundColor $script:Theme.Muted -NoNewline
                        Write-Host $wrappedLines[0] -ForegroundColor $script:Theme.Text -NoNewline
                        
                        $contentLength = 2 + $maxKeyLength + 3 + $wrappedLines[0].Length + 1
                        $padding = [Math]::Max(0, $Width - $contentLength)
                        Write-Host (" " * $padding + "│") -ForegroundColor $script:Theme.Accent
                        
                        # Additional wrapped lines
                        for ($i = 1; $i -lt $wrappedLines.Count; $i++) {
                            Write-Host "│ " -ForegroundColor $script:Theme.Accent -NoNewline
                            Write-Host (" " * ($maxKeyLength + 3)) -NoNewline
                            Write-Host $wrappedLines[$i] -ForegroundColor $script:Theme.Text -NoNewline
                            
                            $contentLength = 2 + $maxKeyLength + 3 + $wrappedLines[$i].Length + 1
                            $padding = [Math]::Max(0, $Width - $contentLength)
                            Write-Host (" " * $padding + "│") -ForegroundColor $script:Theme.Accent
                        }
                    } else {
                        # Normal single-line display
                        Write-Host "│ " -ForegroundColor $script:Theme.Accent -NoNewline
                        Write-Host $key.PadRight($maxKeyLength) -ForegroundColor $script:Theme.Accent -NoNewline
                        Write-Host " : " -ForegroundColor $script:Theme.Muted -NoNewline
                        Write-Host $value -ForegroundColor $script:Theme.Text -NoNewline
                        
                        $contentLength = 2 + $maxKeyLength + 3 + $value.Length + 1
                        $padding = [Math]::Max(0, $Width - $contentLength)
                        Write-Host (" " * $padding + "│") -ForegroundColor $script:Theme.Accent
                    }
                } else {
                    if ($WrapContent -and $line.Length -gt ($Width - 4)) {
                        # Wrap long simple content
                        $wrappedLines = Wrap-Text -Text $line -MaxWidth ($Width - 4)
                        foreach ($wrappedLine in $wrappedLines) {
                            Write-Host "│ " -ForegroundColor $script:Theme.Accent -NoNewline
                            Write-Host $wrappedLine -ForegroundColor $script:Theme.Text -NoNewline
                            $contentLength = 2 + $wrappedLine.Length + 1
                            $padding = [Math]::Max(0, $Width - $contentLength)
                            Write-Host (" " * $padding + "│") -ForegroundColor $script:Theme.Accent
                        }
                    } else {
                        # Normal single-line display
                        Write-Host "│ " -ForegroundColor $script:Theme.Accent -NoNewline
                        Write-Host $line -ForegroundColor $script:Theme.Text -NoNewline
                        $contentLength = 2 + $line.Length + 1
                        $padding = [Math]::Max(0, $Width - $contentLength)
                        Write-Host (" " * $padding + "│") -ForegroundColor $script:Theme.Accent
                    }
                }
            }

            # Bottom border
            $bottomBorderLength = [Math]::Max(0, $Width - 2)
            Write-Host ("└" + "─" * $bottomBorderLength + "┘") -ForegroundColor $script:Theme.Accent
        }

        'Modern' {
            # Title with modern styling
            Write-Host "▌" -ForegroundColor $script:Theme.Accent -NoNewline
            Write-Host " $Title" -ForegroundColor $script:Theme.Text
            $modernBorderLength = [Math]::Max(0, $Width - 1)
            Write-Host ("▌" + "─" * $modernBorderLength) -ForegroundColor $script:Theme.Accent

            # Content
            foreach ($line in $contentLines) {
                if ($Content -is [hashtable] -and $line -match '^([^:]+): (.+)$') {
                    $key = $matches[1]
                    $value = $matches[2]
                    
                    Write-Host "▌ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host "● " -ForegroundColor $script:Theme.Success -NoNewline
                    Write-Host $key -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host ": " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $value -ForegroundColor $script:Theme.Text
                } else {
                    Write-Host "▌ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host "● " -ForegroundColor $script:Theme.Success -NoNewline
                    Write-Host $line -ForegroundColor $script:Theme.Text
                }
            }
        }

        'Simple' {
            # Simple title
            Write-Host $Title -ForegroundColor $script:Theme.Accent
            Write-Host ("-" * $Title.Length) -ForegroundColor $script:Theme.Muted

            # Content
            foreach ($line in $contentLines) {
                if ($Content -is [hashtable] -and $line -match '^([^:]+): (.+)$') {
                    $key = $matches[1]
                    $value = $matches[2]
                    
                    Write-Host "  $key" -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host ": " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $value -ForegroundColor $script:Theme.Text
                } else {
                    Write-Host "  $line" -ForegroundColor $script:Theme.Text
                }
            }
        }

        'Accent' {
            # Accent title - highlight only the title text, not full width
            Write-Host " " -NoNewline
            Write-Host $Title -BackgroundColor $script:Theme.Accent -ForegroundColor Black -NoNewline
            Write-Host " " # Just a space after the title

            # Content with accent bullets
            foreach ($line in $contentLines) {
                if ($Content -is [hashtable] -and $line -match '^([^:]+): (.+)$') {
                    $key = $matches[1]
                    $value = $matches[2]
                    
                    Write-Host " ◆ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host $key -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host ": " -ForegroundColor $script:Theme.Muted -NoNewline
                    Write-Host $value -ForegroundColor $script:Theme.Text
                } else {
                    Write-Host " ◆ " -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host $line -ForegroundColor $script:Theme.Text
                }
            }
        }
    }

    Write-Host
}

<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Progress Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Status & Results
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Displays visual progress indicators with customizable styling and formats.
Key status component providing real-time feedback for long-running operations
with bar charts, blocks, and percentage displays.

HLD INTEGRATION:
┌─ STATUS & RESULTS ─┐    ┌─ PROGRESS TYPES ─┐    ┌─ OUTPUT ─┐
│ Write-Progress     │◄──►│ Bar/Blocks/Dots   │───►│ Visual   │
│ • Current/Max      │    │ Percentage Show   │    │ Progress │
│ • Visual Styles    │    │ Text Labels       │    │ Real-time│
│ • Customizable     │    │ Color Coding      │    │ Updates  │
└───────────────────┘    └───────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates styled progress indicators and bars.

.DESCRIPTION
The Write-Progress function displays various types of progress indicators with customizable styling and animations.

.PARAMETER CurrentValue
Current progress value.

.PARAMETER MaxValue
Maximum progress value.

.PARAMETER Style
The visual style of the progress bar. Available styles:
• Bar: Traditional horizontal progress bar with filled/empty segments
• Blocks: Block-style progress using square characters for visual segments
• Dots: Animated dots that pulse and rotate to show ongoing activity
• Spinner: Spinning indicator with rotating characters for active processes
• Modern: Modern flat design with clean lines and subtle gradients

Valid values: Bar, Blocks, Dots, Spinner, Modern

.PARAMETER Width
Width of the progress bar.

.PARAMETER ShowPercentage
Show percentage value.

.PARAMETER Text
Optional text to display with progress.

.PARAMETER Color
Color for the progress indicator.

.PARAMETER Clear
Clear the current line before writing.

.EXAMPLE
Write-Progress -CurrentValue 75 -MaxValue 100 -Style Bar -ShowPercentage

Displays a 75% complete progress bar with percentage.

.EXAMPLE
Write-Progress -CurrentValue 3 -MaxValue 5 -Style Blocks -Text "Processing files"

Displays block-style progress with custom text.
#>
function Write-Progress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][int]$CurrentValue,
        [Parameter(Mandatory)][int]$MaxValue,
        [ValidateSet('Bar', 'Blocks', 'Dots', 'Spinner', 'Modern')] [string]$Style = 'Bar',
        [int]$Width = 40,
        [switch]$ShowPercentage,
        [string]$Text = "",
        [string]$Color = "",
        [switch]$Clear
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

    if (-not $Color) { $Color = $script:Theme.Accent }

    # Calculate percentage
    $percentage = [Math]::Round(($CurrentValue / $MaxValue) * 100, 1)
    $filledWidth = [Math]::Round(($CurrentValue / $MaxValue) * $Width)

    if ($Clear) {
        Write-Host "`r" -NoNewline
    }

    switch ($Style) {
        'Bar' {
            Write-Host "[" -ForegroundColor $script:Theme.Muted -NoNewline
            
            # Filled portion
            for ($i = 0; $i -lt $filledWidth; $i++) {
                Write-Host "█" -ForegroundColor $Color -NoNewline
            }
            
            # Empty portion
            for ($i = $filledWidth; $i -lt $Width; $i++) {
                Write-Host "░" -ForegroundColor $script:Theme.Muted -NoNewline
            }
            
            Write-Host "]" -ForegroundColor $script:Theme.Muted -NoNewline
            
            if ($ShowPercentage) {
                Write-Host " $percentage%" -ForegroundColor $script:Theme.Text -NoNewline
            }
            
            if ($Text) {
                Write-Host " $Text" -ForegroundColor $script:Theme.Text -NoNewline
            }
        }

        'Blocks' {
            $blockChars = @("▏","▎","▍","▌","▋","▊","▉","█")
            $fullBlocks = [Math]::Floor($filledWidth)
            $partialBlock = ($filledWidth - $fullBlocks) * 8
            
            # Full blocks
            for ($i = 0; $i -lt $fullBlocks; $i++) {
                Write-Host "█" -ForegroundColor $Color -NoNewline
            }
            
            # Partial block
            if ($partialBlock -gt 0 -and $fullBlocks -lt $Width) {
                $charIndex = [Math]::Floor($partialBlock)
                Write-Host $blockChars[$charIndex] -ForegroundColor $Color -NoNewline
                $fullBlocks++
            }
            
            # Empty blocks
            for ($i = $fullBlocks; $i -lt $Width; $i++) {
                Write-Host "░" -ForegroundColor $script:Theme.Muted -NoNewline
            }
            
            if ($ShowPercentage) {
                Write-Host " $percentage%" -ForegroundColor $script:Theme.Text -NoNewline
            }
            
            if ($Text) {
                Write-Host " $Text" -ForegroundColor $script:Theme.Text -NoNewline
            }
        }

        'Dots' {
            $dots = ""
            $numDots = ($CurrentValue % 4) + 1
            for ($i = 0; $i -lt $numDots; $i++) {
                $dots += "●"
            }
            $dots = $dots.PadRight(4)
            
            Write-Host "⟳ " -ForegroundColor $Color -NoNewline
            Write-Host "$dots" -ForegroundColor $script:Theme.Text -NoNewline
            
            if ($ShowPercentage) {
                Write-Host " $percentage%" -ForegroundColor $script:Theme.Text -NoNewline
            }
            
            if ($Text) {
                Write-Host " $Text" -ForegroundColor $script:Theme.Text -NoNewline
            }
        }

        'Spinner' {
            $spinnerChars = @("⠋","⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏")
            $spinnerIndex = $CurrentValue % $spinnerChars.Count
            
            Write-Host $spinnerChars[$spinnerIndex] -ForegroundColor $Color -NoNewline
            Write-Host " " -NoNewline
            
            if ($ShowPercentage) {
                Write-Host "$percentage% " -ForegroundColor $script:Theme.Text -NoNewline
            }
            
            if ($Text) {
                Write-Host "$Text" -ForegroundColor $script:Theme.Text -NoNewline
            }
        }

        'Modern' {
            # Modern progress with rounded ends
            Write-Host "●" -ForegroundColor $Color -NoNewline
            
            for ($i = 0; $i -lt $filledWidth - 1; $i++) {
                Write-Host "━" -ForegroundColor $Color -NoNewline
            }
            
            if ($filledWidth -gt 0) {
                Write-Host "●" -ForegroundColor $Color -NoNewline
            }
            
            for ($i = $filledWidth; $i -lt $Width; $i++) {
                Write-Host "┄" -ForegroundColor $script:Theme.Muted -NoNewline
            }
            
            if ($ShowPercentage) {
                Write-Host " $percentage%" -ForegroundColor $script:Theme.Text -NoNewline
            }
            
            if ($Text) {
                Write-Host " $Text" -ForegroundColor $script:Theme.Text -NoNewline
            }
        }
    }

    if (-not $Clear) {
        Write-Host
    }
}

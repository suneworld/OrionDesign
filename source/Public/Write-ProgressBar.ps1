<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-ProgressBar Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.6.0
Category:      Status & Results
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Displays visual progress indicators with customizable styling and formats.
Key status component providing real-time feedback for long-running operations
with bar charts, blocks, and percentage displays.

HLD INTEGRATION:
┌─ STATUS & RESULTS ─┐    ┌─ PROGRESS TYPES ─┐    ┌─ OUTPUT ─┐
│ Write-ProgressBar  │◄──►│ Bar/Blocks/Dots   │───►│ Visual   │
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
The Write-ProgressBar function displays various types of progress indicators with customizable styling and animations.

.PARAMETER CurrentValue
Current progress value.

.PARAMETER MaxValue
Maximum progress value.

.PARAMETER Style
The visual style of the progress bar. Available styles:
• Bar: Traditional horizontal progress bar with filled/empty segments and precise fractional progress
• Dots: Animated dots that pulse and rotate to show ongoing activity
• Spinner: Spinning indicator with rotating characters for active processes  
• Modern: Modern flat design with clean lines and subtle gradients

Valid values: Bar, Dots, Spinner, Modern

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
Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Style Bar -ShowPercentage

Displays a 75% complete progress bar with percentage.

.EXAMPLE
Write-ProgressBar -CurrentValue 3 -MaxValue 5 -Style Modern -Text "Processing files"

Displays modern-style progress with custom text.
#>
function Write-ProgressBar {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Default', Position = 0)][double]$CurrentValue,
        [Parameter(Mandatory, ParameterSetName = 'Default', Position = 1)][int]$MaxValue,
        [ValidateSet('Bar', 'Dots', 'Spinner', 'Modern')] [string]$Style = 'Bar',
        [int]$Width = 40,
        [switch]$ShowPercentage,
        [string]$Text = "",
        [string]$Color = "",
        [switch]$Clear,

        [Parameter(Mandatory, ParameterSetName = 'Demo')]
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
        Write-Host '  Write-ProgressBar Demo' -ForegroundColor Cyan
        Write-Host '  ======================' -ForegroundColor DarkGray
        Write-Host ''

        $examples = @(
            @{ Style='Bar';     Value=65; Text='Uploading files' },
            @{ Style='Modern';  Value=40; Text='Processing data' },
            @{ Style='Dots';    Value=80; Text='Connecting' },
            @{ Style='Spinner'; Value=55; Text='Waiting for response' }
        )
        foreach ($ex in $examples) {
            Write-Host "  [Style: $($ex.Style)]" -ForegroundColor Yellow
            Write-Host ''
            & $renderCodeBlock @("Write-ProgressBar -CurrentValue $($ex.Value) -MaxValue 100 -Style $($ex.Style) -Text '$($ex.Text)' -ShowPercentage")
            Write-ProgressBar -CurrentValue $ex.Value -MaxValue 100 -Style $ex.Style -Text $ex.Text -ShowPercentage
            Write-Host ''
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
            
            # Enhanced with fractional progress from former Blocks style
            $blockChars = @("▏","▎","▍","▌","▋","▊","▉","█")
            $fullBlocks = [Math]::Floor($filledWidth)
            $partialBlock = ($filledWidth - $fullBlocks) * 8
            
            # Full filled blocks
            for ($i = 0; $i -lt $fullBlocks; $i++) {
                Write-Host "█" -ForegroundColor $Color -NoNewline
            }
            
            # Partial block for precise progress
            if ($partialBlock -gt 0 -and $fullBlocks -lt $Width) {
                $charIndex = [Math]::Floor($partialBlock)
                Write-Host $blockChars[$charIndex] -ForegroundColor $Color -NoNewline
                $fullBlocks++
            }
            
            # Empty portion
            for ($i = $fullBlocks; $i -lt $Width; $i++) {
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

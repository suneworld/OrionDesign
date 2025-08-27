<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-CodeBlock Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.0.0
Category:      Layout & Formatting
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Displays code snippets with syntax highlighting and bordered formatting.
Specialized layout component for presenting code examples with language-aware
formatting, line numbers, and professional presentation styles.

HLD INTEGRATION:
┌─ LAYOUT FORMAT ─┐    ┌─ CODE FEATURES ─┐    ┌─ OUTPUT ─┐
│ Write-CodeBlock │◄──►│ Language Types  │───►│ Syntax   │
│ • Syntax Colors │    │ Line Numbers    │    │ Highlight│
│ • Borders       │    │ Title Support   │    │ Bordered │
│ • Languages     │    │ Auto Detect     │    │ Code     │
└─────────────────┘    └─────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Displays code blocks with syntax highlighting and line numbers.

.DESCRIPTION
The Write-CodeBlock function displays code with basic syntax highlighting, line numbers, and various styling options.

.PARAMETER Code
The code content to display (string or array of strings).

.PARAMETER Language
Programming language for syntax highlighting hints.

.PARAMETER ShowLineNumbers
Display line numbers.

.PARAMETER Title
Optional title for the code block.

.PARAMETER Theme
Color theme for syntax highlighting. Valid values:
- 'Default' - Standard theme
- 'Dark' - Dark theme
- 'Minimal' - Minimal coloring

.PARAMETER Width
Maximum width of the code block.

.PARAMETER Highlight
Array of line numbers to highlight.

.EXAMPLE
Write-CodeBlock -Code 'function Test { return "Hello" }' -Language PowerShell -ShowLineNumbers

Displays PowerShell code with line numbers.

.EXAMPLE
Write-CodeBlock -Code @('import os', 'print("Hello World")') -Language Python -Title "Python Example"

Displays Python code with a title.
#>
function Write-CodeBlock {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]$Code,
        [string]$Language = "Text",
        [switch]$ShowLineNumbers,
        [string]$Title = "",
        [ValidateSet('Default', 'Dark', 'Minimal')] [string]$Theme = 'Default',
        [int]$Width = 80,
        [array]$Highlight = @()
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

    # Set syntax colors based on theme
    switch ($Theme) {
        'Default' {
            $colors = @{
                Keyword = 'Magenta'
                String = 'Green'
                Comment = 'DarkGray'
                Number = 'Cyan'
                Operator = 'Yellow'
                Function = 'Blue'
                Variable = 'White'
            }
        }
        'Dark' {
            $colors = @{
                Keyword = 'Blue'
                String = 'DarkGreen'
                Comment = 'Gray'
                Number = 'DarkCyan'
                Operator = 'DarkYellow'
                Function = 'DarkBlue'
                Variable = 'Gray'
            }
        }
        'Minimal' {
            $colors = @{
                Keyword = 'White'
                String = 'White'
                Comment = 'DarkGray'
                Number = 'White'
                Operator = 'White'
                Function = 'White'
                Variable = 'White'
            }
        }
    }

    # Convert code to array of lines
    if ($Code -is [string]) {
        $lines = $Code -split "`r?`n"
    } else {
        $lines = $Code
    }

    Write-Host

    # Display title if provided
    if ($Title) {
        Write-Host "📄 $Title" -ForegroundColor $script:Theme.Accent
        Write-Host ("-" * ($Title.Length + 3)) -ForegroundColor $script:Theme.Muted
    }

    # Top border
    Write-Host "┌" -ForegroundColor $script:Theme.Muted -NoNewline
    if ($ShowLineNumbers) {
        $lineNumWidth = $lines.Count.ToString().Length + 1
        Write-Host ("─" * $lineNumWidth) -ForegroundColor $script:Theme.Muted -NoNewline
        Write-Host "┬" -ForegroundColor $script:Theme.Muted -NoNewline
    }
    Write-Host ("─" * ($Width - 2)) -ForegroundColor $script:Theme.Muted -NoNewline
    Write-Host "┐" -ForegroundColor $script:Theme.Muted

    # Display each line
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $lineNum = $i + 1
        $line = $lines[$i]
        $isHighlighted = $lineNum -in $Highlight

        Write-Host "│" -ForegroundColor $script:Theme.Muted -NoNewline

        # Line numbers
        if ($ShowLineNumbers) {
            $numColor = if ($isHighlighted) { $script:Theme.Warning } else { $script:Theme.Muted }
            Write-Host $lineNum.ToString().PadLeft($lineNumWidth - 1) -ForegroundColor $numColor -NoNewline
            Write-Host "│" -ForegroundColor $script:Theme.Muted -NoNewline
        }

        # Highlight background for highlighted lines
        if ($isHighlighted) {
            Write-Host $line.PadRight($Width - 2) -BackgroundColor DarkBlue -ForegroundColor White -NoNewline
        } else {
            # Basic syntax highlighting
            Write-SyntaxHighlightedLine -Line $line -Language $Language -Colors $colors -Width ($Width - 2)
        }

        Write-Host "│" -ForegroundColor $script:Theme.Muted
    }

    # Bottom border
    Write-Host "└" -ForegroundColor $script:Theme.Muted -NoNewline
    if ($ShowLineNumbers) {
        Write-Host ("─" * $lineNumWidth) -ForegroundColor $script:Theme.Muted -NoNewline
        Write-Host "┴" -ForegroundColor $script:Theme.Muted -NoNewline
    }
    Write-Host ("─" * ($Width - 2)) -ForegroundColor $script:Theme.Muted -NoNewline
    Write-Host "┘" -ForegroundColor $script:Theme.Muted

    Write-Host
}

# Helper function for syntax highlighting
function Write-SyntaxHighlightedLine {
    param($Line, $Language, $Colors, $Width)
    
    # Simple syntax highlighting patterns
    $script:keywords = @{
        'PowerShell' = @('function', 'param', 'if', 'else', 'foreach', 'while', 'return', 'try', 'catch', 'finally')
        'Python' = @('def', 'class', 'if', 'else', 'for', 'while', 'return', 'try', 'except', 'import', 'from')
        'JavaScript' = @('function', 'var', 'let', 'const', 'if', 'else', 'for', 'while', 'return', 'try', 'catch')
        'C#' = @('public', 'private', 'class', 'interface', 'if', 'else', 'for', 'while', 'return', 'try', 'catch')
    }

    $currentLine = $Line

    # Check for comments first
    if ($currentLine -match '^\s*#' -or $currentLine -match '^\s*//' -or $currentLine -match '^\s*/\*') {
        Write-Host $currentLine.PadRight($Width) -ForegroundColor $Colors.Comment -NoNewline
        return
    }

    # Check for strings
    if ($currentLine -match '".*"' -or $currentLine -match "'.*'") {
        # Simple string detection (not perfect but good enough for basic highlighting)
        $parts = $currentLine -split '["'']'
        $inString = $false
        
        foreach ($part in $parts) {
            if ($inString) {
                Write-Host $part -ForegroundColor $Colors.String -NoNewline
            } else {
                Write-HighlightedText -Text $part -Language $Language -Colors $Colors
            }
            $inString = -not $inString
        }
    } else {
        Write-HighlightedText -Text $currentLine -Language $Language -Colors $Colors
    }

    # Pad to width
    $remaining = $Width - $currentLine.Length
    if ($remaining -gt 0) {
        Write-Host (" " * $remaining) -NoNewline
    }
}

function Write-HighlightedText {
    param($Text, $Language, $Colors)
    
    $words = $Text -split '\s+'
    $isFirst = $true
    
    foreach ($word in $words) {
        if (-not $isFirst) { Write-Host " " -NoNewline }
        $isFirst = $false
        
        $cleanWord = $word -replace '[^\w]', ''
        
        # Check if it's a keyword
        if ($cleanWord -and $script:keywords[$Language] -contains $cleanWord.ToLower()) {
            Write-Host $word -ForegroundColor $Colors.Keyword -NoNewline
        }
        # Check if it's a number
        elseif ($word -match '^\d+\.?\d*$') {
            Write-Host $word -ForegroundColor $Colors.Number -NoNewline
        }
        # Check if it's a variable (starts with $)
        elseif ($word -match '^\$\w+') {
            Write-Host $word -ForegroundColor $Colors.Variable -NoNewline
        }
        # Check for operators
        elseif ($word -match '^[+\-*/=<>!&|]+$') {
            Write-Host $word -ForegroundColor $Colors.Operator -NoNewline
        }
        else {
            Write-Host $word -ForegroundColor $Colors.Variable -NoNewline
        }
    }
}

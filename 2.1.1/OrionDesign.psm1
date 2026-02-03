<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK
================================================================================

Author:        Sune Alexandersen Narud
Date:          January 27, 2026
Version:       2.0.0

HIGH LEVEL DESIGN (HLD):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PURPOSE:
OrionDesign is a comprehensive PowerShell UI framework that provides beautiful,
consistent, and professional terminal user interfaces. It enables developers 
and system administrators to create visually appealing command-line applications
with minimal effort.

ARCHITECTURE:
┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐
│ INFORMATION     │ STATUS &        │ DATA            │ INTERACTIVE     │
│ DISPLAY         │ RESULTS         │ PRESENTATION    │ ELEMENTS        │
├─────────────────┼─────────────────┼─────────────────┼─────────────────┤
│ Write-Banner    │ Write-ActionRes │ Write-Table     │ Write-Menu      │
│ Write-Header    │ Write-Progress  │ Write-Chart     │ Write-Question  │
│ Write-InfoBox   │ Write-Steps     │ Write-Comparison│                 │
│ Write-Alert     │ Write-Timeline  │ Write-Dashboard │                 │
└─────────────────┴─────────────────┴─────────────────┴─────────────────┘
┌─────────────────┬─────────────────┬─────────────────────────────────────┐
│ LAYOUT &        │ GLOBAL          │ DEMONSTRATION & UTILITIES           │
│ FORMATTING      │ CONFIGURATION   │                                     │
├─────────────────┼─────────────────┼─────────────────────────────────────┤
│ Write-Separator │ Get-OrionMax    │ Show-OrionDemo                      │
│ Write-Panel     │ Set-OrionMax    │   -Demo Basic/Themes/Interactive/All│
│ Write-CodeBlock │ $script:Theme   │ Export-OrionHelpers (Portability)   │
└─────────────────┴─────────────────┴─────────────────────────────────────┘

CORE FEATURES:
• 🎨 20 Beautiful UI Functions organized in logical categories
• 📏 Global Max Width Configuration (50-200 chars, default 100)
• 🎯 Consistent ANSI Styling with automatic ISE compatibility
• 📚 Complete Comment-Based Help documentation
• 🔧 Flexible Parameter Options with validation
• 💻 PowerShell ISE fallback support
• 🚀 Production-ready with comprehensive error handling

DESIGN PRINCIPLES:
1. CONSISTENCY    - Unified styling and parameter patterns
2. FLEXIBILITY    - Customizable through parameters and global config
3. COMPATIBILITY  - Works in PowerShell 5.1+, ISE, and modern terminals
4. USABILITY      - Intuitive function names and comprehensive help
5. PERFORMANCE    - Optimized for speed with minimal dependencies
6. EXTENSIBILITY  - Modular design for easy function additions

GLOBAL CONFIGURATION:
• $script:OrionMaxWidth (50-200): Controls output width for all functions
• $script:Theme: Color scheme and styling preferences
• ANSI Support: Automatic detection and graceful fallback

USAGE PATTERNS:
Import-Module OrionDesign
Write-Banner -ScriptName "MyApp" -Author "User" -Design Modern
Write-ActionResult -Action "Deploy" -Status Success -Details "Complete"
Set-OrionMaxWidth -Width 80  # Configure global width
Show-OrionDemo                # See all functions in action

================================================================================
#>

Write-Verbose "DEBUG: OrionDesign.psm1 loaded. PSScriptRoot = $PSScriptRoot"

$root = $PSScriptRoot

# --- Global OrionDesign Configuration ---
# Maximum width/length for functions to prevent overly long output
$script:OrionMaxWidth = 100

# Default theme configuration
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

# Detect PowerShell ISE and disable ANSI if needed
if ($psISE) { 
    $script:Theme.UseAnsi = $false 
}

# --- Load Private functions (internal only) ---
$privatePath = Join-Path $root 'Functions\Private'
if (Test-Path $privatePath) {
    Get-ChildItem -Path $privatePath -Filter *.ps1 | ForEach-Object {
        Write-Verbose "Loading private function: $($_.BaseName)"
        . $_.FullName
    }
}

# --- Load Public functions (to be exported) ---
$publicPath = Join-Path $root 'Functions\Public'
$publicFunctions = @()
if (Test-Path $publicPath) {
    Get-ChildItem -Path $publicPath -Filter *.ps1 | ForEach-Object {
        Write-Verbose "Loading public function: $($_.BaseName)"
        . $_.FullName
        $publicFunctions += $_.BaseName
    }
}

# --- Export only public functions ---
if ($publicFunctions.Count -gt 0) {
    Write-Verbose "Exporting functions: $($publicFunctions -join ', ')"
    Export-ModuleMember -Function $publicFunctions
}
else {
    Write-Warning "No public functions found to export from OrionDesign"
}

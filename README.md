# OrionDesign Module - Quick Reference Guide

## 🎨 OrionDesign PowerShell UI Framework

**Version 3.1.0** | A comprehensive collection of PowerShell functions for creating beautiful terminal user interfaces with consistent styling and configurable global settings.

Created and maintained by Sune Alexandersen Narud

[![PSGallery](https://img.shields.io/powershellgallery/v/OrionDesign?label=PSGallery&color=blue)](https://www.powershellgallery.com/packages/OrionDesign)
[![Downloads](https://img.shields.io/powershellgallery/dt/OrionDesign)](https://www.powershellgallery.com/packages/OrionDesign)
[![GitHub](https://img.shields.io/badge/GitHub-suneworld%2FOrionDesign-lightgrey?logo=github)](https://github.com/suneworld/OrionDesign)

---

## 🆕 What's New in v3.1.0

Every public function now includes a **`-Demo`** parameter. Run any function with `-Demo` to see a live, self-contained demonstration of all its modes and options — including the exact code that produced each example.

```powershell
# Examples
Write-Alert    -Demo   # Shows all 4 alert types
Write-Header   -Demo   # Shows all underline/numbering modes
Write-Chart    -Demo   # Bar chart and Pie chart examples
Write-Steps    -Demo   # All 4 step list styles
Set-OrionTheme -Demo   # All 13 available presets
# ... same for every public function
```

### 📦 Installation

**From PowerShell Gallery** (recommended):
```powershell
Install-Module -Name OrionDesign
# or with PSResourceGet:
Install-PSResource -Name OrionDesign
```

**From source** (clone the [GitHub repo](https://github.com/suneworld/OrionDesign)):
```powershell
Import-Module .\OrionDesign.psd1
```

### ⚙️ Global Configuration

#### Max Width Control
```powershell
# Check current max width
Get-OrionMaxWidth

# Set custom max width (50-200 characters)
Set-OrionMaxWidth -Width 80

# Reset to default (100 characters)  
Set-OrionMaxWidth -Reset
```

### 🎯 Core UI Functions

#### Information Display
| Function        | Purpose                                | Example                                                  |
|-----------------|----------------------------------------|----------------------------------------------------------|
| `Write-Banner`  | Script headers with decorative borders | `Write-Banner -ScriptName "MyScript" -Author "User"`     |
| `Write-Header`  | Section headers with underlines        | `Write-Header "Configuration"`                           |
| `Write-InfoBox` | Highlighted information panels         | `Write-InfoBox "Title" "Content goes here" -Style Modern` |
| `Write-Alert`   | Attention-grabbing alerts              | `Write-Alert "Warning!" -Type Warning`                   |
| `Write-Panel`   | Content containers with border styles  | `Write-Panel "Details here" -Type Info -Style Box`       |

#### Status & Results  
| Function                 | Purpose                              | Example                                                         |
|--------------------------|--------------------------------------|-----------------------------------------------------------------|
| `Write-Action`           | Action text (pairs with Result)      | `Write-Action "Processing files"`                               |
| `Write-Action -Complete` | Standalone result with icon/details  | `Write-Action "Deploy" -Complete -Status Success -ShowIcon`     |
| `Write-ActionResult`     | Right-aligned result (pairs w/ Action) | `Write-ActionResult "Done" -Status Success`                   |
| `Write-ProgressBar`      | Progress bar in various styles       | `Write-ProgressBar 75 100 -Style Bar`                           |
| `Write-Steps`            | Step-by-step process lists           | `Write-Steps @("Step 1", "Step 2") -CurrentStep 1`              |

#### Data Presentation
| Function      | Purpose              | Example                       |
|---------------|----------------------|-------------------------------|
| `Write-Chart` | Bar and pie charts   | `Write-Chart @{CPU=75; RAM=60}`|

#### Interactive Elements
| Function              | Purpose                             | Example                                           |
|-----------------------|-------------------------------------|---------------------------------------------------|
| `Show-OrionSmartMenu` | Arrow-key or numeric selection menu | `Show-OrionSmartMenu "Title" "Pick:" @("A","B")`  |
| `Write-Menu`          | Numeric selection menus             | `Write-Menu "Options" @("A", "B")`                |
| `Write-MenuLine`      | Single custom menu line             | `Write-MenuLine 1 "Option Name"`                  |
| `Write-Question`      | User prompts (text/YesNo/Choice)    | `Write-Question "Continue?" -Type YesNo`          |

> **Note:** `Write-Menu` automatically includes an Exit option (X) as the last item in every menu.

#### Layout & Formatting
| Function          | Purpose          | Example                                   |
|-------------------|------------------|-------------------------------------------|
| `Write-Separator` | Section dividers | `Write-Separator "Section" -Style Double` |

#### Utility Functions
| Function              | Purpose                          | Example                                            |
|-----------------------|----------------------------------|----------------------------------------------------|
| `Export-OrionHelpers` | Bundle functions for portability | `Export-OrionHelpers -ScriptPath ".\MyScript.ps1"` |

### 🎨 Design Themes

#### Theme System
OrionDesign includes a comprehensive theme system with 13 preset themes across 6 categories:

```powershell
# Apply a theme
Set-OrionTheme -Preset HighContrast

# View current theme
Get-OrionTheme

# See all themes in action
Show-OrionDemo

# List all 13 presets as a table
Set-OrionTheme -Demo
```

#### Available Themes

**Standard Themes:**
- `Default` - Standard cyan/green/yellow/red theme
- `Dark` - Dark theme with muted colors
- `Light` - Light theme with darker colors

**Nature Themes:**
- `Ocean` - Blue-based aquatic theme with wave dividers
- `Forest` - Green-based nature theme with tree-like elements

**Retro/Vintage Themes:**
- `OldSchool` - Classic amber terminal (DOS/Unix era)
- `Vintage` - Warm sepia/amber nostalgic feel
- `Retro80s` - Synthwave magenta/cyan neon pastels

**Tech/Futuristic Themes:**
- `Matrix` - Green-on-black digital rain aesthetic
- `Cyberpunk` - Futuristic cyan/purple tech aesthetic

**Artistic Themes:**
- `Sunset` - Orange/magenta warm evening colors
- `Monochrome` - Grayscale theme for high contrast

**Accessibility Themes:**
- `HighContrast` - Maximum contrast theme for accessibility (white on black)

### 📏 Width-Aware Functions

The following functions automatically respect the global max width setting:
- `Write-Action` / `Write-ActionResult` — Auto right-alignment to max width
- `Write-Action -Complete` — Truncates long details  
- `Write-Separator` — Adjusts separator length  
- `Write-Banner` — Adjusts border width
- `Write-Panel` — Wraps content appropriately

### ⚡ Real-Time Status Pattern

The `Write-Action` / `Write-ActionResult` pair provides elegant real-time status reporting with automatic alignment:

```powershell
# Basic usage - result auto right-aligns to OrionMaxWidth
Write-Action "Connecting to database"
Write-ActionResult "Connected" -Status Success
# Output: Connecting to database                                         Connected

# Multiple steps with consistent alignment
Write-Action "Loading configuration"
Write-ActionResult "OK" -Status Success
Write-Action "Validating credentials"
Write-ActionResult "Valid" -Status Success
Write-Action "Fetching user data"
Write-ActionResult "125 users" -Status Success

# Auto-detection of status (no -Status needed)
Write-Action "Processing items"
Write-ActionResult "42 items processed"  # Auto-detects as Success

# Standalone complete action with details (replaces old Write-ActionResult)
Write-Action "Deploy Database" -Complete -Status Success -Duration "00:02:15" -ShowIcon
# Output: ✅ Deploy Database in 00:02:15

Write-Action "142" -Complete -Status Success -Subtext "tables updated" -ShowIcon
# Output: ✅ 142 tables updated

# Overflow handling - when text is too long, result moves to new line
Write-Action "This is a very long action description"
Write-ActionResult "This is also a long result" -Status Success
# Output:
#   This is a very long action description
#                              This is also a long result
```

**Key Features:**
- `Write-Action` + `Write-ActionResult` for real-time paired output
- `Write-Action -Complete` for standalone rich results with icons, duration, details
- Result automatically right-aligns to OrionMaxWidth
- Intelligent overflow handling when combined text exceeds width
- Auto-detection of Success/Failed/Warning patterns

### 🔧 Advanced Features

#### ANSI Support
- Automatic detection of PowerShell ISE vs terminal
- Full color and formatting support in compatible terminals
- Graceful fallback for limited environments

#### Validation
- Input validation on all parameters
- Range checking (e.g., max width 50-200)
- Type validation for enums and objects

#### Error Handling
- Comprehensive error messages
- Parameter validation
- Fallback rendering for compatibility

### 📚 Getting Help

```powershell
# Get help for any function
Get-Help Write-Banner -Full
Get-Help Set-OrionMaxWidth -Examples

# Show all available functions
Get-Command -Module OrionDesign

# Run the built-in module showcase
Show-OrionDemo

# Run per-function demos (available on every public function)
Write-Alert      -Demo
Write-Banner     -Demo
Write-Chart      -Demo
Write-Header     -Demo
Write-InfoBox    -Demo
Write-Menu       -Demo
Write-MenuLine   -Demo
Write-Panel      -Demo
Write-ProgressBar -Demo
Write-Question   -Demo
Write-Separator  -Demo
Write-Steps      -Demo
Write-Action     -Demo
Write-ActionResult -Demo
Set-OrionTheme   -Demo   # Lists all 13 theme presets
Get-OrionTheme   -Demo
Set-OrionMaxWidth -Demo
Get-OrionMaxWidth -Demo
Export-OrionHelpers -Demo
Show-OrionSmartMenu -Demo
```

### 🚀 Quick Start Examples

```powershell
# Script header
Write-Banner -ScriptName "Data Migration" -Author "IT Team" -Design Modern

# Section dividers
Write-Separator "Configuration" -Style Double
Write-Separator "Results"       -Style Single

# Real-time action/result pattern
Write-Action "Connecting to database"
Write-ActionResult "Connected" -Status Success

Write-Action "Processing files"
Write-ActionResult "42 files processed"   # auto-detects Success

# Standalone complete action
Write-Action "Backup Database" -Complete -Status Success -Duration "00:02:15" -ShowIcon

# Step-by-step process
Write-Steps @("Connect", "Validate", "Deploy", "Verify") -CurrentStep 3 -CompletedSteps @(1,2) -Style Checklist

# Progress bar
Write-ProgressBar 45 100 -Style Bar -Label "Processing Files"

# Interactive smart menu (supports arrow-key navigation)
$choice = Show-OrionSmartMenu "Select Environment" "Choose:" @("Development", "Staging", "Production")

# Numeric menu (with automatic Exit option)
$choice = Write-Menu "Select Environment" @("Development", "Staging", "Production")
if ($choice.Exit) {
    Write-Host "User chose to exit"
} else {
    Write-Host "Selected: $($choice.Value)"
}

# Highlighted info panel
Write-InfoBox "Deployment Info" @{Server="prod-01"; Version="2.4.1"; Region="EU-West"} -Style Modern

# Alert messages
Write-Alert "Configuration updated successfully" -Type Success
Write-Alert "Low disk space on C:" -Type Warning

# Chart
Write-Chart @{CPU=75; Memory=60; Disk=90} -Style Bar -Title "Resource Usage"

# Custom width for specific output
Set-OrionMaxWidth -Width 80
Write-Separator "Narrow Layout" -Style Double
Set-OrionMaxWidth -Reset
```

### 📦 Making Scripts Portable (v2.0.0)

The `Export-OrionHelpers` function allows you to bundle OrionDesign functions directly into your script's project folder, making scripts portable without requiring the module to be installed.

```powershell
# Analyze a script and create a self-contained helper file
Export-OrionHelpers -ScriptPath "C:\Scripts\MyScript.ps1"

# Output to a specific directory
Export-OrionHelpers -ScriptPath ".\Deploy.ps1" -OutputPath ".\lib"

# Preview what would be exported without making changes
Export-OrionHelpers -ScriptPath ".\MyScript.ps1" -WhatIf

# Keep the Import-Module line (don't comment it out)
Export-OrionHelpers -ScriptPath ".\MyScript.ps1" -CommentOutImport:$false
```

**What it does:**
1. Analyzes your script to find all OrionDesign function calls
2. Resolves dependencies (including private helper functions)
3. Creates `OrionDesign-Helpers.ps1` with all required functions
4. Comments out the `Import-Module OrionDesign` line in your script

**After export, add this line to your script:**
```powershell
. "$PSScriptRoot\OrionDesign-Helpers.ps1"
```

---

**OrionDesign v3.1.0** | PowerShell UI Framework | 21 Functions | 13 Themes | Global Configuration | ANSI Support | -Demo on every function

🔗 [PSGallery](https://www.powershellgallery.com/packages/OrionDesign) · [GitHub](https://github.com/suneworld/OrionDesign)

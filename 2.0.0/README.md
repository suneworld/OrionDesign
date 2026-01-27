# OrionDesign Module - Quick Reference Guide

## 🎨 OrionDesign PowerShell UI Framework

A comprehensive collection of PowerShell functions for creating beautiful terminal user interfaces with consistent styling and configurable global settings.

Created and maintained by Sune Alexandersen Narud

### 📦 Installation
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
| Function        | Purpose                                | Example                                              |
|-----------------|----------------------------------------|------------------------------------------------------|
| `Write-Banner`  | Script headers with decorative borders | `Write-Banner -ScriptName "MyScript" -Author "User"` |
| `Write-Header`  | Section headers with underlines        | `Write-Header -Text "Configuration" -Level 1`        |
| `Write-InfoBox` | Highlighted information panels         | `Write-InfoBox -Message "Important info" -Type Info` |
| `Write-Alert`   | Attention-grabbing alerts              | `Write-Alert -Message "Warning!" -Type Warning`      |

#### Status & Results  
| Function             | Purpose                         | Example                                                |
|----------------------|---------------------------------|--------------------------------------------------------|
| `Write-Action`       | Action text (no newline)        | `Write-Action "Processing files"`                      |
| `Write-ActionStatus` | Status with auto right-align    | `Write-ActionStatus "Done" -Status Success`            |
| `Write-ActionResult` | Action outcomes with status     | `Write-ActionResult -Action "Deploy" -Status Success`  |
| `Write-Progress`     | Task progress indicators        | `Write-Progress -TaskName "Installing" -Percentage 75` |
| `Write-Steps`        | Step-by-step processes          | `Write-Steps -Steps @("Step 1", "Step 2")`             |
| `Write-Timeline`     | Chronological events            | `Write-Timeline -Events @{...}`                        |

#### Data Presentation
| Function           | Purpose                  | Example                                                     |
|--------------------|--------------------------|-------------------------------------------------------------|
| `Write-Table`      | Formatted data tables    | `Write-Table -Data $objects -Properties @("Name", "Value")` |
| `Write-Chart`      | Simple bar charts        | `Write-Chart -Data @{A=10; B=20}`                           |
| `Write-Comparison` | Side-by-side comparisons | `Write-Comparison -Left "Old" -Right "New"`                 |
| `Write-Dashboard`  | Multi-metric dashboards  | `Write-Dashboard -Title "Stats" -Metrics @{...}`            |

#### Interactive Elements
| Function         | Purpose         | Example                                          |
|------------------|-----------------|--------------------------------------------------|
| `Write-Menu`     | Selection menus | `Write-Menu -Title "Options" -Items @("A", "B")` |
| `Write-Question` | User prompts    | `Write-Question -Prompt "Continue?" -Type YesNo` |

#### Layout & Formatting
| Function          | Purpose            | Example                                                    |
|-------------------|--------------------|------------------------------------------------------------|
| `Write-Separator` | Section dividers   | `Write-Separator -Text "Section" -Style Double`            |
| `Write-Panel`     | Content containers | `Write-Panel -Title "Info" -Content "Details"`             |
| `Write-CodeBlock` | Code snippets      | `Write-CodeBlock -Code "Get-Process" -Language PowerShell` |

#### Utility Functions
| Function              | Purpose                         | Example                                           |
|-----------------------|---------------------------------|---------------------------------------------------|
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
Show-OrionDemo -Demo Themes
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
- `Write-Action` / `Write-ActionStatus` - Auto right-alignment to max width
- `Write-ActionResult` - Truncates long details
- `Write-Separator` - Adjusts separator length  
- `Write-Table` - Responsive column widths
- `Write-Dashboard` - Scales headers and content
- `Write-Banner` - Adjusts border width
- `Write-Panel` - Wraps content appropriately

### ⚡ Real-Time Status Pattern (v2.0.0)

The `Write-Action` / `Write-ActionStatus` pair provides elegant real-time status reporting with automatic alignment:

```powershell
# Basic usage - status auto right-aligns to OrionMaxWidth
Write-Action "Connecting to database"
Write-ActionStatus "Connected" -Status Success
# Output: Connecting to database                                         Connected

# Multiple steps with consistent alignment
Write-Action "Loading configuration"
Write-ActionStatus "OK" -Status Success
Write-Action "Validating credentials"
Write-ActionStatus "Valid" -Status Success
Write-Action "Fetching user data"
Write-ActionStatus "125 users" -Status Success

# Auto-detection of status (no -Status needed)
Write-Action "Processing items"
Write-ActionStatus "42 items processed"  # Auto-detects as Success

# Overflow handling - when text is too long, status moves to new line
Write-Action "This is a very long action description"
Write-ActionStatus "This is also a long status" -Status Success
# Output:
#   This is a very long action description
#                              This is also a long status
```

**Key Features:**
- No fixed width - action text displays naturally
- Status automatically right-aligns to OrionMaxWidth
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
Get-Help Write-Table -Parameter Data

# Show all available functions
Get-Command -Module OrionDesign

# View demos
Show-OrionDemo                      # Basic demo
Show-OrionDemo -Demo Themes         # Theme showcase
Show-OrionDemo -Demo Interactive    # Interactive demo
Show-OrionDemo -Demo All            # Comprehensive demo
```

### 🚀 Quick Start Examples

```powershell
# Basic script header
Write-Banner -ScriptName "Data Migration" -Author "IT Team" -Design Modern

# Progress tracking
Write-Progress -TaskName "Processing Files" -Percentage 45 -ShowBar

# Results display  
Write-ActionResult -Action "Backup Database" -Status Success -Details "Completed in 2.3 seconds"

# Data table
$data = @(
    [PSCustomObject]@{Name="Server1"; Status="Online"; CPU="15%"}
    [PSCustomObject]@{Name="Server2"; Status="Offline"; CPU="N/A"}
)
Write-Table -Data $data -Title "Server Status"

# Interactive menu
$choice = Write-Menu -Title "Select Environment" -Items @("Development", "Staging", "Production")

# Custom width for specific output
Set-OrionMaxWidth -Width 80
Write-Separator -Text "Narrow Layout" -Style Double
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

**OrionDesign v2.0.0** | PowerShell UI Framework | 20 Functions | 13 Themes | Global Configuration | ANSI Support

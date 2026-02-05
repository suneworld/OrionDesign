<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Export-OrionHelpers Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          January 27, 2026
Module:        OrionDesign v2.0.0
Category:      Utility / Bundling
Dependencies:  OrionDesign Module

FUNCTION PURPOSE:
Analyzes a script that uses OrionDesign functions and creates a self-contained
helper file with all required function definitions. Makes scripts portable
without requiring the OrionDesign module to be installed.

HLD INTEGRATION:
┌─ SCRIPT ANALYSIS ─┐    ┌─ DEPENDENCY RESOLUTION ─┐    ┌─ OUTPUT ─┐
│ Export-OrionHelpers│◄──►│ Parse Script           │───►│ Helper   │
│ • Script Path      │    │ Find Function Calls    │    │ File     │
│ • Output Path      │    │ Resolve Dependencies   │    │ Bundled  │
│ • Auto-Comment     │    │ Include Private Funcs  │    │ Portable │
└────────────────────┘    └────────────────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Exports used OrionDesign functions to a self-contained helper script.

.DESCRIPTION
The Export-OrionHelpers function analyzes a PowerShell script that imports
the OrionDesign module, identifies all OrionDesign functions used in the script,
and creates a consolidated helper file containing all required function definitions.

This makes scripts portable and self-contained without requiring the OrionDesign
module to be installed on target systems.

The function will:
1. Parse the target script to find all OrionDesign function calls
2. Resolve dependencies (including private helper functions)
3. Export all required functions to OrionDesign-Helpers.ps1
4. Optionally comment out the Import-Module OrionDesign line

.PARAMETER ScriptPath
The path to the PowerShell script to analyze.

.PARAMETER OutputPath
The directory where OrionDesign-Helpers.ps1 will be created.
Defaults to the same directory as the script.

.PARAMETER CommentOutImport
When specified, comments out the Import-Module OrionDesign line in the script.
Default is $true.

.PARAMETER IncludeTheme
When specified, includes a default theme initialization in the helper file.
Default is $true.

.PARAMETER WhatIf
Shows what would be done without making any changes.

.EXAMPLE
Export-OrionHelpers -ScriptPath "C:\Scripts\MyScript.ps1"

Analyzes MyScript.ps1, creates OrionDesign-Helpers.ps1 in C:\Scripts\,
and comments out the Import-Module line.

.EXAMPLE
Export-OrionHelpers -ScriptPath ".\Deploy.ps1" -OutputPath ".\lib"

Creates the helper file in a 'lib' subdirectory.

.EXAMPLE
Export-OrionHelpers -ScriptPath ".\MyScript.ps1" -CommentOutImport:$false

Creates helper file but leaves the Import-Module line unchanged.

.EXAMPLE
Export-OrionHelpers -ScriptPath ".\MyScript.ps1" -WhatIf

Shows which functions would be exported without creating any files.

.NOTES
After running this function, add the following line to your script (before using any OrionDesign functions):
. "$PSScriptRoot\OrionDesign-Helpers.ps1"

The helper file includes all necessary private functions that public functions depend on.
#>
function Export-OrionHelpers {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position = 0)]
        [string]$ScriptPath,

        [Parameter(Position = 1)]
        [string]$OutputPath = "",

        [bool]$CommentOutImport = $true,

        [bool]$IncludeTheme = $true
    )

    # If no ScriptPath provided, show interactive file selection
    if (-not $ScriptPath) {
        $currentDir = Get-Location
        $ps1Files = Get-ChildItem -Path $currentDir -Filter "*.ps1" -File -ErrorAction SilentlyContinue | 
                    Where-Object { $_.Name -ne "OrionDesign-Helpers.ps1" }
        
        if ($ps1Files.Count -eq 0) {
            Write-Host ""
            Write-Host "  ⚠️  No PowerShell scripts (.ps1) found in current directory" -ForegroundColor Yellow
            Write-Host "     Directory: $currentDir" -ForegroundColor Gray
            Write-Host ""
            Write-Host "  Usage: Export-OrionHelpers -ScriptPath <path-to-script>" -ForegroundColor Cyan
            Write-Host ""
            return
        }

        Write-Host ""
        Write-Host "  OrionDesign Helper Export" -ForegroundColor Cyan
        Write-Host "  ═════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host "  Select a PowerShell script to scan for OrionDesign functions:" -ForegroundColor White
        Write-Host ""

        $index = 1
        $fileList = @()
        foreach ($file in $ps1Files) {
            $fileList += $file
            $sizeKB = [math]::Round($file.Length / 1KB, 1)
            Write-Host "    [$index] " -NoNewline -ForegroundColor Yellow
            Write-Host $file.Name -NoNewline -ForegroundColor Green
            Write-Host " ($sizeKB KB)" -ForegroundColor DarkGray
            $index++
        }
        
        Write-Host ""
        Write-Host "    [0] " -NoNewline -ForegroundColor Yellow
        Write-Host "Cancel" -ForegroundColor Red
        Write-Host ""
        Write-Host "  ─────────────────────────────────────────────────────────────" -ForegroundColor DarkGray

        $selection = Read-Host "  Enter selection (1-$($ps1Files.Count))"
        
        if ($selection -eq "0" -or [string]::IsNullOrWhiteSpace($selection)) {
            Write-Host ""
            Write-Host "  ❌ Operation cancelled." -ForegroundColor Red
            Write-Host ""
            return
        }

        $selectedIndex = 0
        if (-not [int]::TryParse($selection, [ref]$selectedIndex) -or $selectedIndex -lt 1 -or $selectedIndex -gt $ps1Files.Count) {
            Write-Host ""
            Write-Host "  ❌ Invalid selection. Please enter a number between 1 and $($ps1Files.Count)" -ForegroundColor Red
            Write-Host ""
            return
        }

        $ScriptPath = $fileList[$selectedIndex - 1].FullName
        Write-Host ""
        Write-Host "  ✅ Selected: " -NoNewline -ForegroundColor Green
        Write-Host $fileList[$selectedIndex - 1].Name -ForegroundColor White
        Write-Host ""
    }

    # Validate the script path exists
    if (-not (Test-Path $ScriptPath -PathType Leaf)) {
        Write-Host ""
        Write-Host "  ❌ File not found: $ScriptPath" -ForegroundColor Red
        Write-Host ""
        return
    }

    # Resolve full paths
    $ScriptPath = Resolve-Path $ScriptPath | Select-Object -ExpandProperty Path
    $scriptDir = Split-Path $ScriptPath -Parent
    $scriptName = Split-Path $ScriptPath -Leaf

    if (-not $OutputPath) {
        $OutputPath = $scriptDir
    }
    if (-not (Test-Path $OutputPath)) {
        if ($PSCmdlet.ShouldProcess($OutputPath, "Create directory")) {
            New-Item -Path $OutputPath -ItemType Directory -Force | Out-Null
        }
    }
    $OutputPath = Resolve-Path $OutputPath | Select-Object -ExpandProperty Path

    # Get module path
    $modulePath = Split-Path $PSScriptRoot -Parent | Split-Path -Parent
    $publicPath = Join-Path $modulePath "Functions\Public"
    $privatePath = Join-Path $modulePath "Functions\Private"

    # Get all available OrionDesign functions
    $publicFunctions = Get-ChildItem -Path $publicPath -Filter "*.ps1" -ErrorAction SilentlyContinue | 
                       Where-Object { $_.BaseName -ne "Export-OrionHelpers" }
    $privateFunctions = Get-ChildItem -Path $privatePath -Filter "*.ps1" -ErrorAction SilentlyContinue

    $publicFuncNames = $publicFunctions | ForEach-Object { $_.BaseName }
    $privateFuncNames = $privateFunctions | ForEach-Object { $_.BaseName }
    $totalPublicAvailable = $publicFuncNames.Count
    $totalPrivateAvailable = $privateFuncNames.Count

    $allFunctionNames = @()
    $allFunctionNames += $publicFuncNames
    $allFunctionNames += $privateFuncNames

    # Read the target script
    $scriptContent = Get-Content -Path $ScriptPath -Raw

    # Find all OrionDesign functions used in the script
    $usedFunctions = @()
    foreach ($funcName in $allFunctionNames) {
        # Match function calls: FunctionName followed by space, newline, or parameters
        if ($scriptContent -match "\b$funcName\b") {
            $usedFunctions += $funcName
        }
    }

    # Remove duplicates and sort
    $usedFunctions = $usedFunctions | Sort-Object -Unique

    if ($usedFunctions.Count -eq 0) {
        Write-Warning "No OrionDesign functions found in '$scriptName'"
        return
    }

    # Resolve dependencies - check which private functions are needed
    $requiredPrivate = @()
    $privateFuncNames = $privateFunctions | ForEach-Object { $_.BaseName }

    foreach ($pubFunc in $usedFunctions) {
        $pubFuncPath = Join-Path $publicPath "$pubFunc.ps1"
        if (Test-Path $pubFuncPath) {
            $pubFuncContent = Get-Content -Path $pubFuncPath -Raw
            foreach ($privFunc in $privateFuncNames) {
                if ($pubFuncContent -match "\b$privFunc\b") {
                    $requiredPrivate += $privFunc
                }
            }
        }
    }

    # Also check if private functions call other private functions
    foreach ($privFunc in $requiredPrivate) {
        $privFuncPath = Join-Path $privatePath "$privFunc.ps1"
        if (Test-Path $privFuncPath) {
            $privFuncContent = Get-Content -Path $privFuncPath -Raw
            foreach ($otherPriv in $privateFuncNames) {
                if ($privFuncContent -match "\b$otherPriv\b" -and $otherPriv -ne $privFunc) {
                    $requiredPrivate += $otherPriv
                }
            }
        }
    }

    $requiredPrivate = $requiredPrivate | Sort-Object -Unique

    # Calculate usage statistics
    $usedPublicCount = ($usedFunctions | Where-Object { $_ -in $publicFuncNames }).Count
    $usagePercent = [math]::Round(($usedPublicCount / $totalPublicAvailable) * 100, 0)

    # Display what will be exported
    Write-Host ""
    Write-Host "OrionDesign Export Analysis" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  Script:        " -NoNewline -ForegroundColor Gray
    Write-Host $scriptName -ForegroundColor White
    Write-Host "  Output:        " -NoNewline -ForegroundColor Gray
    Write-Host (Join-Path $OutputPath "OrionDesign-Helpers.ps1") -ForegroundColor White
    Write-Host ""
    Write-Host "  Coverage:      " -NoNewline -ForegroundColor Gray
    Write-Host "$usedPublicCount" -NoNewline -ForegroundColor Cyan
    Write-Host " of " -NoNewline -ForegroundColor Gray
    Write-Host "$totalPublicAvailable" -NoNewline -ForegroundColor White
    Write-Host " public functions used (" -NoNewline -ForegroundColor Gray
    if ($usagePercent -ge 50) {
        Write-Host "$usagePercent%" -NoNewline -ForegroundColor Green
    } elseif ($usagePercent -ge 25) {
        Write-Host "$usagePercent%" -NoNewline -ForegroundColor Yellow
    } else {
        Write-Host "$usagePercent%" -NoNewline -ForegroundColor DarkGray
    }
    Write-Host ")" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Public Functions ($($usedFunctions.Count)):" -ForegroundColor Yellow
    foreach ($func in $usedFunctions) {
        Write-Host "    • $func" -ForegroundColor Green
    }
    if ($requiredPrivate.Count -gt 0) {
        Write-Host ""
        Write-Host "  Private Dependencies ($($requiredPrivate.Count)):" -ForegroundColor Yellow
        foreach ($func in $requiredPrivate) {
            Write-Host "    • $func" -ForegroundColor DarkGreen
        }
    }
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""

    if ($WhatIfPreference) {
        Write-Host "[WhatIf] Would create OrionDesign-Helpers.ps1 with $($usedFunctions.Count + $requiredPrivate.Count) functions" -ForegroundColor Yellow
        if ($CommentOutImport) {
            Write-Host "[WhatIf] Would comment out Import-Module OrionDesign in $scriptName" -ForegroundColor Yellow
        }
        return
    }

    # Build the helper file content
    $helperContent = @"
<#
================================================================================
ORION DESIGN - HELPER FUNCTIONS (Auto-generated)
================================================================================
Generated:     $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Source Script: $scriptName
Module:        OrionDesign v2.0.0
Author:        Sune Alexandersen Narud

This file contains OrionDesign functions extracted for portability.
Do not edit manually - regenerate using Export-OrionHelpers if needed.

Functions included:
$($usedFunctions | ForEach-Object { "  - $_" } | Out-String)
================================================================================
#>

"@

    # Add theme initialization if requested
    if ($IncludeTheme) {
        $helperContent += @"
#region Theme Initialization
# Initialize default theme (required for color functions)
if (-not `$script:Theme) {
    `$script:Theme = @{
        Primary   = 'Cyan'
        Secondary = 'DarkCyan'
        Success   = 'Green'
        Warning   = 'Yellow'
        Error     = 'Red'
        Accent    = 'Magenta'
        Text      = 'White'
        Muted     = 'DarkGray'
        Border    = '─'
        Corner    = '+'
        Divider   = '─'
        UseAnsi   = `$true
    }
    if (`$psISE) { `$script:Theme.UseAnsi = `$false }
}

# Initialize default max width
if (-not `$script:OrionMaxWidth) {
    `$script:OrionMaxWidth = 100
}
#endregion

"@
    }

    # Add private functions first (dependencies)
    if ($requiredPrivate.Count -gt 0) {
        $helperContent += @"
#region Private Helper Functions
"@
        foreach ($privFunc in $requiredPrivate) {
            $privFuncPath = Join-Path $privatePath "$privFunc.ps1"
            if (Test-Path $privFuncPath) {
                $funcContent = Get-Content -Path $privFuncPath -Raw
                # Extract just the function definition (skip header comments)
                if ($funcContent -match '(?s)(function\s+' + $privFunc + '\s*\{.+)') {
                    $helperContent += "`n# Private: $privFunc`n"
                    $helperContent += $Matches[1].Trim()
                    $helperContent += "`n"
                } else {
                    # Include entire file if pattern doesn't match
                    $helperContent += "`n# Private: $privFunc`n"
                    $helperContent += $funcContent
                    $helperContent += "`n"
                }
            }
        }
        $helperContent += @"
#endregion

"@
    }

    # Add public functions
    $helperContent += @"
#region Public Functions
"@
    foreach ($pubFunc in $usedFunctions) {
        $pubFuncPath = Join-Path $publicPath "$pubFunc.ps1"
        if (Test-Path $pubFuncPath) {
            $funcContent = Get-Content -Path $pubFuncPath -Raw
            # Extract just the function definition (skip header comments)
            if ($funcContent -match '(?s)(function\s+' + $pubFunc + '\s*\{.+)') {
                $helperContent += "`n# $pubFunc`n"
                $helperContent += $Matches[1].Trim()
                $helperContent += "`n"
            } else {
                # Include entire file if pattern doesn't match
                $helperContent += "`n# $pubFunc`n"
                $helperContent += $funcContent
                $helperContent += "`n"
            }
        }
    }
    $helperContent += @"
#endregion
"@

    # Write the helper file
    $helperFilePath = Join-Path $OutputPath "OrionDesign-Helpers.ps1"
    if ($PSCmdlet.ShouldProcess($helperFilePath, "Create helper file")) {
        Set-Content -Path $helperFilePath -Value $helperContent -Encoding UTF8
        Write-Host "✅ Created: " -NoNewline -ForegroundColor Green
        Write-Host $helperFilePath -ForegroundColor White
    }

    # Comment out the Import-Module line and add dot-source line
    if ($CommentOutImport) {
        $importPatterns = @(
            'Import-Module\s+OrionDesign',
            'Import-Module\s+[''"].*OrionDesign[''"]',
            'Import-Module\s+.*OrionDesign\.psd1',
            'Import-Module\s+.*OrionDesign\.psm1'
        )

        $modified = $false
        $newContent = $scriptContent
        $dotSourceLine = '. "$PSScriptRoot\OrionDesign-Helpers.ps1"'

        foreach ($pattern in $importPatterns) {
            if ($newContent -match "(?m)^(\s*)($pattern.*)$") {
                $fullMatch = $Matches[0]
                $indent = $Matches[1]
                if ($fullMatch -notmatch '^\s*#') {
                    # Comment out old line and add dot-source line
                    $replacement = "$indent# $($Matches[2]) # Commented by Export-OrionHelpers`n$indent$dotSourceLine"
                    $newContent = $newContent -replace [regex]::Escape($fullMatch), $replacement
                    $modified = $true
                }
            }
        }

        if ($modified) {
            if ($PSCmdlet.ShouldProcess($ScriptPath, "Comment out Import-Module and add dot-source")) {
                Set-Content -Path $ScriptPath -Value $newContent -Encoding UTF8 -NoNewline
                Write-Host "✅ Updated: " -NoNewline -ForegroundColor Green
                Write-Host $scriptName -ForegroundColor White
                Write-Host "   • Commented out Import-Module OrionDesign" -ForegroundColor Gray
                Write-Host "   • Added: $dotSourceLine" -ForegroundColor Gray
            }
        } else {
            Write-Host "ℹ️  No Import-Module OrionDesign line found to comment out" -ForegroundColor Yellow
            Write-Host "   Add this line manually: $dotSourceLine" -ForegroundColor Yellow
        }
    }

    # Show completion message
    Write-Host ""
    Write-Host "✅ Export complete!" -ForegroundColor Green
    Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  The script is now portable and doesn't require OrionDesign module." -ForegroundColor Gray
    Write-Host "───────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host ""

    # Return summary object
    [PSCustomObject]@{
        HelperFile       = $helperFilePath
        PublicFunctions  = $usedFunctions
        PrivateFunctions = $requiredPrivate
        TotalFunctions   = $usedFunctions.Count + $requiredPrivate.Count
        ScriptModified   = $modified
    }
}

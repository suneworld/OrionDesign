@{
    RootModule        = 'OrionDesign.psm1'
    ModuleVersion     = '3.1.0'
    GUID              = 'f827a4ef-a736-449b-b684-dfeba0fdadc3'
    Author            = 'Sune Alexandersen Narud'
    Copyright         = '(c) 2026 Sune Alexandersen Narud. All rights reserved.'
    Description       = 'Orion Design Framework – Beautiful PowerShell UI functions for creating rich terminal interfaces. Includes themed output, progress bars, menus, banners, charts, alerts, panels and more. Every function includes a built-in -Demo parameter.'
    PowerShellVersion = '5.1'

    # Functions to export from this module
    FunctionsToExport = @(
        'Export-OrionHelpers',
        'Get-OrionMaxWidth',
        'Get-OrionTheme',
        'Set-OrionMaxWidth',
        'Set-OrionTheme',
        'Show-OrionDemo',
        'Show-OrionSmartMenu',
        'Write-Action',
        'Write-ActionResult',
        'Write-Alert',
        'Write-Banner',
        'Write-Chart',
        'Write-Header',
        'Write-InfoBox',
        'Write-Menu',
        'Write-MenuLine',
        'Write-Panel',
        'Write-ProgressBar',
        'Write-Question',
        'Write-Separator',
        'Write-Steps'
    )

    PrivateData = @{
        PSData = @{
            Tags         = @('UI', 'Terminal', 'Console', 'Output', 'Formatting', 'Theme', 'Menu', 'Banner', 'Chart', 'ProgressBar', 'Colors', 'TUI', 'PowerShell5', 'PSCore')
            ProjectUri   = 'https://github.com/suneworld/OrionDesign'
            LicenseUri   = 'https://github.com/suneworld/OrionDesign/blob/master/LICENSE'
            ReleaseNotes = @'
## v3.1.0
- Added -Demo parameter to all 21 public functions
- Each demo shows live output with exact code that produced it
- Dynamic code box width (auto-sizes to content)
- Added Show-OrionSmartMenu with arrow-key and numeric navigation modes

## v3.0.0
- Restructured module to flat layout
- Renamed Write-MenuLine parameter MenuTitle to Text
- Fixed theme color pairings throughout

## v2.1.4
- Added Write-MenuLine with -Muted parameter
- Enhanced Write-Action/Write-ActionResult alignment
'@
        }
    }
}
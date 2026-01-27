@{
    RootModule        = 'OrionDesign.psm1'
    ModuleVersion     = '2.0.0'  # Major release: Better line length spacing and design improvements
    GUID              = '7e6a0c07-1b71-4e11-8d7c-123456789abc'
    Author            = 'Sune Alexandersen Narud'
    Description       = 'Orion Design Framework – Beautiful PowerShell UI functions with global configuration'
    PowerShellVersion = '5.1'
    
    # Functions to export from this module
    FunctionsToExport = @(
        'Export-OrionHelpers',
        'Get-OrionMaxWidth',
        'Get-OrionTheme',
        'Set-OrionMaxWidth',
        'Set-OrionTheme',
        'Show-OrionDemo',
        'Write-Action',
        'Write-ActionResult',
        'Write-ActionStatus',
        'Write-Alert',
        'Write-Banner', 
        'Write-Chart',
        'Write-Header',
        'Write-InfoBox',
        'Write-Menu',
        'Write-Panel',
        'Write-ProgressBar',
        'Write-Question',
        'Write-Separator',
        'Write-Steps'
    )
}
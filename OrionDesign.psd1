@{
    RootModule        = 'OrionDesign.psm1'
    ModuleVersion     = '1.0.0'  # Initial Release
    GUID              = '7e6a0c07-1b71-4e11-8d7c-123456789abc'
    Author            = 'Sune Alexandersen Narud'
    Description       = 'Orion Design Framework – Beautiful PowerShell UI functions with global configuration'
    PowerShellVersion = '5.1'
    
    # Functions to export from this module
    FunctionsToExport = @(
        'Get-OrionMaxWidth',
        'Set-OrionMaxWidth',
        'Show-OrionDemo',
        'Write-Action',
        'Write-ActionResult',
        'Write-ActionStatus',
        'Write-Alert',
        'Write-Banner', 
        'Write-Chart',
        'Write-CodeBlock',
        'Write-Comparison',
        'Write-Dashboard',
        'Write-Header',
        'Write-InfoBox',
        'Write-Menu',
        'Write-Panel',
        'Write-Progress',
        'Write-Question',
        'Write-Separator',
        'Write-Steps',
        'Write-Table',
        'Write-Timeline'
    )
}
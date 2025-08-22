# Orion.Design.psm1
$root = $PSScriptRoot
#$root = "C:\Users\snarud\OneDrive - TOMRA\Documents\WindowsPowerShell\Modules\Orion.Design"

# Load public functions
$publicPath = Join-Path $root 'Functions\Public'
if (Test-Path $publicPath) {
    Get-ChildItem -Path $publicPath -Filter *.ps1 | ForEach-Object {
        . $_.FullName
    }
}

# Export functions by filename (must match function names)
if ($ExecutionContext.SessionState.Module) {
    $publicFunctions = (Get-ChildItem "$publicPath\*.ps1").BaseName
    Export-ModuleMember -Function $publicFunctions
}

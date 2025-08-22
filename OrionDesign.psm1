Write-Verbose "DEBUG: OrionDesign.psm1 loaded. PSScriptRoot = $PSScriptRoot"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path  # safer than $PSScriptRoot

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
if (Test-Path $publicPath) {
    Get-ChildItem -Path $publicPath -Filter *.ps1 | ForEach-Object {
        Write-Verbose "Loading public function file: $($_.BaseName)"
        . $_.FullName
    }

    # find functions actually defined in memory that match the public filenames
    $publicFunctions = Get-ChildItem function:\ | Where-Object {
        $_.Name -in (Get-ChildItem "$publicPath\*.ps1").BaseName
    } | Select-Object -ExpandProperty Name
}

# --- Export only public functions ---
if ($publicFunctions.Count -gt 0) {
    Write-Verbose "Exporting functions: $($publicFunctions -join ', ')"
    Export-ModuleMember -Function $publicFunctions
}
else {
    Write-Warning "No public functions found to export from OrionDesign"
}

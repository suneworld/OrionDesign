# Write-Colored.ps1
function Write-Colored {
    param([array]$Segments,[hashtable]$Theme=$script:Theme)

    foreach ($seg in $Segments) {
        $text = $seg.Text
        if ($Theme.UseAnsi) {
            if ($seg.Style -eq 'BOLD')       { $text = "`e[1m$text`e[22m" }
            elseif ($seg.Style -eq 'UNDER') { $text = "`e[4m$text`e[24m" }
        }
        if ($seg.Color) { Write-Host -NoNewline $text -ForegroundColor $seg.Color }
        else            { Write-Host -NoNewline $text }
    }
    Write-Host
}

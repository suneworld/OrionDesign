# Fix Write-Banner to use proper semantic colors
$content = Get-Content ".\Functions\Public\Write-Banner.ps1" -Raw

# Replace structural elements (borders, frames) with Accent color
$content = $content -replace '(\$Theme\.Success)(?=.*(-ForegroundColor|\s+-NoNewline))', '$Theme.Accent'

# But keep description text as Muted (more appropriate than Accent for text)
$content = $content -replace '(\$Theme\.Accent)(?=.*Write-Host.*line.*ForegroundColor)', '$Theme.Muted'

# Save the corrected content
$content | Set-Content ".\Functions\Public\Write-Banner.ps1" -NoNewline

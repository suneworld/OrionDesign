# ================================================================================
# OrionDesign Write-ProgressBar - Quick Demo
# ================================================================================

# Clear screen and show header
Clear-Host
Write-Host "OrionDesign Write-ProgressBar Function Demo" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor DarkGray
Write-Host ""

# Import module functions directly
. .\Functions\Public\Write-ProgressBar.ps1
. .\Functions\Public\Write-Header.ps1
. .\Functions\Public\Write-InfoBox.ps1

# Ensure theme is loaded
if (-not $script:Theme) {
    $script:Theme = @{
        Accent   = 'Cyan'
        Success  = 'Green'
        Warning  = 'Yellow'
        Error    = 'Red'
        Text     = 'White'
        Muted    = 'DarkGray'
        Divider  = '─'
        UseAnsi  = $true
    }
}

Write-InfoBox -Title "Write-ProgressBar Function" -Message @(
    "The Write-ProgressBar function creates visual progress indicators.",
    "Parameters: -CurrentValue, -MaxValue, -Style, -ShowPercentage, -Text"
    "Styles available: Bar, Blocks, Dots, Spinner, Modern"
) -Width 60

Write-Host ""

# Demo 1: Basic progress animation
Write-Host "Demo 1: Basic Progress Animation (Bar Style)" -ForegroundColor Yellow
Write-Host ""

for ($i = 0; $i -le 100; $i += 2) {
    Write-Host "`rLoading: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue $i -MaxValue 100 -Style Bar -ShowPercentage -Clear
    Start-Sleep -Milliseconds 50
}
Write-Host ""
Write-Host "✓ Complete!" -ForegroundColor Green
Write-Host ""

# Demo 2: File processing
Write-Host "Demo 2: File Processing (Modern Style)" -ForegroundColor Yellow
Write-Host ""

$files = @("config.json", "data.csv", "report.pdf", "image.png", "script.ps1")
for ($i = 0; $i -lt $files.Count; $i++) {
    Write-Host "`rProcessing: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue ($i + 1) -MaxValue $files.Count -Style Modern -ShowPercentage -Text $files[$i] -Clear
    Start-Sleep -Milliseconds 800
}
Write-Host ""
Write-Host "✓ All files processed!" -ForegroundColor Green
Write-Host ""

# Demo 3: Style comparison at 60%
Write-Host "Demo 3: Different Styles at 60% Progress" -ForegroundColor Yellow
Write-Host ""

$current = 60
$max = 100

Write-Host "Bar:     " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Bar -ShowPercentage

Write-Host "Blocks:  " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Blocks -ShowPercentage

Write-Host "Modern:  " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Modern -ShowPercentage

Write-Host "Dots:    " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Dots -ShowPercentage

Write-Host "Spinner: " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Spinner -ShowPercentage

Write-Host ""
Write-Host "✓ Demo complete!" -ForegroundColor Green
Write-Host ""

# Usage examples
Write-Host "Usage Examples:" -ForegroundColor Cyan
Write-Host "Write-ProgressBar -CurrentValue 50 -MaxValue 100 -Style Bar -ShowPercentage" -ForegroundColor Gray
Write-Host "Write-ProgressBar -CurrentValue 3 -MaxValue 5 -Style Modern -Text 'Processing...' -Clear" -ForegroundColor Gray

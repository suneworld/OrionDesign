# ================================================================================
# Simple Write-Progress Increasing Demo
# ================================================================================

Clear-Host
Write-Host "OrionDesign Write-Progress - Increasing Progress Demo" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor DarkGray
Write-Host ""

# Import the module
Import-Module .\OrionDesign.psd1 -Force | Out-Null

Write-Host "Understanding Write-Progress:" -ForegroundColor Yellow
Write-Host "• Creates visual progress bars and indicators" -ForegroundColor White
Write-Host "• Shows increasing progress from 0 to maximum value" -ForegroundColor White
Write-Host "• Multiple styles: Bar, Blocks, Modern, Dots, Spinner" -ForegroundColor White
Write-Host "• Can display percentages and custom text" -ForegroundColor White
Write-Host ""

# Demo 1: Basic increasing progress
Write-Host "Demo 1: Basic Increasing Progress (0-100%)" -ForegroundColor Green
Write-Host ""

for ($i = 0; $i -le 100; $i += 5) {
    Write-Host "`rProgress: " -NoNewline
    Write-ProgressBar -CurrentValue $i -MaxValue 100 -Style Bar -ShowPercentage -Clear
    Start-Sleep -Milliseconds 150
}
Write-Host ""
Write-Host "✓ Complete!" -ForegroundColor Green
Write-Host ""

# Demo 2: Processing items with increasing progress
Write-Host "Demo 2: Processing Items (Modern Style)" -ForegroundColor Green
Write-Host ""

$items = @("Initialize system", "Load configuration", "Connect database", "Process data", "Generate report")
for ($i = 0; $i -lt $items.Count; $i++) {
    Write-Host "`rTask: " -NoNewline
    Write-ProgressBar -CurrentValue ($i + 1) -MaxValue $items.Count -Style Modern -ShowPercentage -Text $items[$i] -Clear
    Start-Sleep -Milliseconds 1000
}
Write-Host ""
Write-Host "✓ All tasks completed!" -ForegroundColor Green
Write-Host ""

# Demo 3: Different styles at same progress level
Write-Host "Demo 3: Style Comparison at 60% Progress" -ForegroundColor Green
Write-Host ""

$progress = 60
$max = 100

Write-Host "Bar Style:     " -NoNewline
Write-ProgressBar -CurrentValue $progress -MaxValue $max -Style Bar -ShowPercentage

Write-Host "Blocks Style:  " -NoNewline  
Write-ProgressBar -CurrentValue $progress -MaxValue $max -Style Blocks -ShowPercentage

Write-Host "Modern Style:  " -NoNewline
Write-ProgressBar -CurrentValue $progress -MaxValue $max -Style Modern -ShowPercentage

Write-Host ""

# Key parameters explanation
Write-Host "Key Write-Progress Parameters:" -ForegroundColor Yellow
Write-Host "• -CurrentValue: Current progress (required)" -ForegroundColor White
Write-Host "• -MaxValue: Maximum value (required)" -ForegroundColor White  
Write-Host "• -Style: Visual style (Bar, Blocks, Modern, Dots, Spinner)" -ForegroundColor White
Write-Host "• -ShowPercentage: Display percentage" -ForegroundColor White
Write-Host "• -Text: Optional descriptive text" -ForegroundColor White
Write-Host "• -Clear: Clear line for smooth animation" -ForegroundColor White
Write-Host ""

Write-Host "Example Usage:" -ForegroundColor Cyan
Write-Host "Write-ProgressBar -CurrentValue 50 -MaxValue 100 -Style Bar -ShowPercentage" -ForegroundColor Gray

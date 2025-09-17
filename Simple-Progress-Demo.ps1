# ================================================================================
# Simple Write-ProgressBar Example - Increasing Progress
# ================================================================================
# This script demonstrates how to create a progress bar that increases over time

# Import the OrionDesign module and make sure we're using the right Write-ProgressBar function
Import-Module .\OrionDesign.psd1 -Force

# Get reference to OrionDesign's Write-ProgressBar function
$OrionProgress = Get-Command Write-ProgressBar -Module OrionDesign

Clear-Host
Write-Host "Write-ProgressBar - Increasing Progress Example" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor DarkGray
Write-Host ""

# Example 1: Simple counting progress
Write-Host "Example 1: Simple Progress Bar (0-100)" -ForegroundColor Yellow
Write-Host ""

for ($i = 0; $i -le 100; $i += 5) {
    Write-Host "`rProgress: " -NoNewline -ForegroundColor White
    & $OrionProgress -CurrentValue $i -MaxValue 100 -Style Bar -ShowPercentage -Clear
    Start-Sleep -Milliseconds 100
}

Write-Host ""
Write-Host "Complete!" -ForegroundColor Green
Write-Host ""

# Example 2: File processing with custom text
Write-Host "Example 2: Processing Files (with custom text)" -ForegroundColor Yellow
Write-Host ""

$files = 1..15
foreach ($fileNum in $files) {
    $fileName = "document_$fileNum.pdf"
    
    Write-Host "`rProcessing: " -NoNewline -ForegroundColor White
    & $OrionProgress -CurrentValue $fileNum -MaxValue $files.Count -Style Modern -ShowPercentage -Text $fileName -Clear
    
    Start-Sleep -Milliseconds 300
}

Write-Host ""
Write-Host "All files processed!" -ForegroundColor Green
Write-Host ""

# Example 3: Different styles comparison
Write-Host "Example 3: Different Styles at 60% Progress" -ForegroundColor Yellow
Write-Host ""

$current = 60
$max = 100

Write-Host "Bar Style:    " -NoNewline
& $OrionProgress -CurrentValue $current -MaxValue $max -Style Bar -ShowPercentage

Write-Host "Blocks Style: " -NoNewline
& $OrionProgress -CurrentValue $current -MaxValue $max -Style Blocks -ShowPercentage

Write-Host "Modern Style: " -NoNewline
& $OrionProgress -CurrentValue $current -MaxValue $max -Style Modern -ShowPercentage

Write-Host ""
Write-Host "Demo complete! Try modifying the values to see different progress levels." -ForegroundColor Cyan

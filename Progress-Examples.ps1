# ================================================================================
# Write-ProgressBar - Practical Examples for Increasing Progress
# ================================================================================

# Import OrionDesign module
Import-Module .\OrionDesign.psd1 -Force | Out-Null

Clear-Host
Write-Host "Write-ProgressBar - Practical Examples" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor DarkGray
Write-Host ""

# Example 1: Simple counter (0 to 100)
Write-Host "Example 1: Simple Counter Progress" -ForegroundColor Yellow
for ($i = 0; $i -le 100; $i += 10) {
    Write-Host "`rCounting: " -NoNewline
    OrionDesign\Write-ProgressBar -CurrentValue $i -MaxValue 100 -Style Bar -ShowPercentage -Clear
    Start-Sleep -Milliseconds 200
}
Write-Host "`nDone!" -ForegroundColor Green
Write-Host ""

# Example 2: File processing simulation
Write-Host "Example 2: File Processing" -ForegroundColor Yellow
$files = 1..10
foreach ($fileNum in $files) {
    Write-Host "`rProcessing file $fileNum of $($files.Count): " -NoNewline
    OrionDesign\Write-ProgressBar -CurrentValue $fileNum -MaxValue $files.Count -Style Modern -ShowPercentage -Text "file_$fileNum.txt" -Clear
    Start-Sleep -Milliseconds 300
}
Write-Host "`nAll files processed!" -ForegroundColor Green
Write-Host ""

# Example 3: Download progress
Write-Host "Example 3: Download Progress" -ForegroundColor Yellow
$totalMB = 50
for ($downloaded = 0; $downloaded -le $totalMB; $downloaded += 2) {
    if ($downloaded -gt $totalMB) { $downloaded = $totalMB }
    Write-Host "`rDownloading: " -NoNewline
    OrionDesign\Write-ProgressBar -CurrentValue $downloaded -MaxValue $totalMB -Style Blocks -ShowPercentage -Text "${downloaded}MB / ${totalMB}MB" -Clear
    Start-Sleep -Milliseconds 100
}
Write-Host "`nDownload complete!" -ForegroundColor Green
Write-Host ""

# Example 4: Task completion
Write-Host "Example 4: Task Completion" -ForegroundColor Yellow
$tasks = @(
    "Initialize application",
    "Load configuration", 
    "Connect to database",
    "Process user data",
    "Generate reports",
    "Send notifications",
    "Cleanup resources"
)

for ($i = 0; $i -lt $tasks.Count; $i++) {
    $taskName = $tasks[$i]
    Write-Host "`r$($i+1)/$($tasks.Count): " -NoNewline
    OrionDesign\Write-ProgressBar -CurrentValue ($i + 1) -MaxValue $tasks.Count -Style Modern -ShowPercentage -Text $taskName -Clear
    Start-Sleep -Milliseconds 500
}
Write-Host "`nAll tasks completed!" -ForegroundColor Green

Write-Host ""
Write-Host "Key Points for Increasing Progress:" -ForegroundColor Cyan
Write-Host "• Use a loop to increment CurrentValue" -ForegroundColor White
Write-Host "• MaxValue stays constant (your target)" -ForegroundColor White
Write-Host "• Use -Clear for smooth animation" -ForegroundColor White
Write-Host "• Add Start-Sleep for visible progress" -ForegroundColor White
Write-Host "• Use `r to overwrite the same line" -ForegroundColor White

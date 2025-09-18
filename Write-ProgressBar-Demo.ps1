# ================================================================================
# OrionDesign Write-ProgressBar - Complete Demonstration
# ================================================================================
# This script combines all progress demo examples to show comprehensive progress
# bar functionality with different styles, animations, and practical use cases


    function Demo-Separator {
        param (
            [string]$Text = "",
            [string]$Style = "Single"
        )
        Write-Host
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host "         $Text " -ForegroundColor DarkGray
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host
    }


# Import the OrionDesign module and load required functions
Import-Module .\OrionDesign.psd1 -Force | Out-Null

# Also import functions directly for enhanced functionality
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

Clear-Host
Write-Host "OrionDesign Write-ProgressBar - Complete Demonstration" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor DarkGray
Write-Host

Write-InfoBox -Title "Write-ProgressBar Function" -Content @(
    "The Write-ProgressBar function creates visual progress indicators.",
    "Parameters: -CurrentValue, -MaxValue, -Style, -ShowPercentage, -Text, -Clear"
    "Styles available: Bar, Modern, Dots, Spinner"
)

# Demo 1: Basic increasing progress
Demo-Separator "Basic Increasing Progress (0-100%) -Style Bar"

for ($i = 0; $i -le 100; $i += 2) {
    Write-Host "`rLoading: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue $i -MaxValue 100 -Style Bar -ShowPercentage -Clear
    Start-Sleep -Milliseconds 5
}

Write-Host
Write-Host "✓ Complete!" -ForegroundColor Green
Write-Host ""

# Demo 2: File processing with custom text
Demo-Separator "File Processing with Custom Text -Style Modern"

$files = @("config.json", "data.csv", "report.pdf", "image.png", "script.ps1", "backup.zip", "settings.xml", "log.txt")
for ($i = 0; $i -lt $files.Count; $i++) {
    Write-Host "`rProcessing: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue ($i + 1) -MaxValue $files.Count -Style Modern -ShowPercentage -Text $files[$i] -Clear
    Start-Sleep -Milliseconds 50
}

Write-Host ""
Write-Host "✓ All files processed!" -ForegroundColor Green
Write-Host ""

# Demo 3: Processing items with task descriptions
Demo-Separator "System Tasks (Modern Style with Descriptions) -Style Modern"

$tasks = @("Initialize system", "Load configuration", "Connect database", "Process data", "Generate report")
for ($i = 0; $i -lt $tasks.Count; $i++) {
    Write-Host "`rTask: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue ($i + 1) -MaxValue $tasks.Count -Style Modern -ShowPercentage -Text $tasks[$i] -Clear
    Start-Sleep -Milliseconds 50
}
Write-Host ""
Write-Host "✓ All tasks completed!" -ForegroundColor Green
Write-Host ""

# Demo 4: Different styles comparison at same progress level
Demo-Separator "Complete Style Comparison at 60% Progress"

$current = 60
$max = 100

Write-Host "Bar:     " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Bar -ShowPercentage

Write-Host "Modern:  " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Modern -ShowPercentage

Write-Host "Modern:  " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Modern -ShowPercentage

Write-Host "Dots:    " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Dots -ShowPercentage

Write-Host "Spinner: " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Spinner -ShowPercentage

Write-Host ""

# Demo 5: Download Progress Simulation
Demo-Separator "Download Progress Simulation -Style Bar"

$totalMB = 50
for ($downloaded = 0; $downloaded -le $totalMB; $downloaded += 2) {
    if ($downloaded -gt $totalMB) { $downloaded = $totalMB }
    Write-Host "`rDownloading: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue $downloaded -MaxValue $totalMB -Style Bar -ShowPercentage -Text "${downloaded}MB / ${totalMB}MB" -Clear
    Start-Sleep -Milliseconds 60
}
Write-Host ""
Write-Host "✓ Download complete!" -ForegroundColor Green
Write-Host ""

# Demo 6: Extended Task Completion
Demo-Separator "Extended Application Workflow -Style Modern"

$extendedTasks = @(
    "Initialize application",
    "Load configuration", 
    "Connect to database",
    "Process user data",
    "Generate reports",
    "Send notifications",
    "Cleanup resources"
)

for ($i = 0; $i -lt $extendedTasks.Count; $i++) {
    $taskName = $extendedTasks[$i]
    Write-Host "`r$($i+1)/$($extendedTasks.Count): " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue ($i + 1) -MaxValue $extendedTasks.Count -Style Modern -ShowPercentage -Text $taskName -Clear
    Start-Sleep -Milliseconds 50
}
Write-Host ""
Write-Host "✓ All application tasks completed!" -ForegroundColor Green
Write-Host ""

# Demo 7: Individual Style Animations
Demo-Separator "Individual Style Animations"

# Bar Style Animation
Write-Host "Bar Style Animation:" -ForegroundColor Yellow
for ($i = 0; $i -le 100; $i += 5) {
    Write-Host "`rBar Style: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue $i -MaxValue 100 -Style Bar -ShowPercentage -Clear
    Start-Sleep -Milliseconds 50
}
Write-Host ""

# Modern Style Animation
Write-Host "Modern Style Animation:" -ForegroundColor Yellow
for ($i = 0; $i -le 100; $i += 5) {
    Write-Host "`rModern Style: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue $i -MaxValue 100 -Style Modern -ShowPercentage -Clear
    Start-Sleep -Milliseconds 50
}
Write-Host ""

# Dots Style Animation
Write-Host "Dots Style Animation:" -ForegroundColor Yellow
for ($i = 0; $i -le 100; $i += 5) {
    Write-Host "`rDots Style: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue $i -MaxValue 100 -Style Dots -ShowPercentage -Clear
    Start-Sleep -Milliseconds 50
}
Write-Host ""

# Spinner Style Animation
Write-Host "Spinner Style Animation:" -ForegroundColor Yellow
for ($i = 0; $i -le 100; $i += 5) {
    Write-Host "`rSpinner Style: " -NoNewline -ForegroundColor White
    Write-ProgressBar -CurrentValue $i -MaxValue 100 -Style Spinner -ShowPercentage -Clear
    Start-Sleep -Milliseconds 50
}
Write-Host ""

Write-Host "✓ All style animations completed!" -ForegroundColor Green
Write-Host ""

# Demo 8: Different Progress Levels (Static Display)
Demo-Separator "Comparing all styles at different progress levels"
Write-Host

$progressLevels = @(25, 50, 75, 100)
$allStyles = @('Bar', 'Modern', 'Dots', 'Spinner')

foreach ($level in $progressLevels) {
    Write-Host "$level% Progress:" -ForegroundColor Cyan
    foreach ($style in $allStyles) {
        Write-Host "  $style".PadRight(10) -NoNewline -ForegroundColor White
        Write-ProgressBar -CurrentValue $level -MaxValue 100 -Style $style -ShowPercentage
    }
    Write-Host
}

Write-Host

# Parameter explanation and practical tips
Write-Host "Key Write-ProgressBar Parameters:" -ForegroundColor Yellow
Write-Host "• -CurrentValue: Current progress value (required)" -ForegroundColor White
Write-Host "• -MaxValue: Maximum value for progress calculation (required)" -ForegroundColor White
Write-Host "• -Style: Visual style (Bar, Modern, Dots, Spinner)" -ForegroundColor White
Write-Host "• -ShowPercentage: Display percentage alongside progress bar" -ForegroundColor White
Write-Host "• -Text: Optional descriptive text to show with progress" -ForegroundColor White
Write-Host "• -Clear: Clear line for smooth animation in loops" -ForegroundColor White
Write-Host

Write-Host "Key Points for Increasing Progress:" -ForegroundColor Yellow
Write-Host "• Use a loop to increment CurrentValue" -ForegroundColor White
Write-Host "• MaxValue stays constant (your target)" -ForegroundColor White
Write-Host "• Use -Clear for smooth animation" -ForegroundColor White
Write-Host "• Add Start-Sleep for visible progress" -ForegroundColor White
Write-Host "• Use `r to overwrite the same line" -ForegroundColor White
Write-Host

Write-Host "Usage Examples:" -ForegroundColor Cyan
Write-Host "Write-ProgressBar -CurrentValue 50 -MaxValue 100 -Style Bar -ShowPercentage" -ForegroundColor Gray
Write-Host "Write-ProgressBar -CurrentValue 3 -MaxValue 5 -Style Modern -Text 'Processing...' -Clear" -ForegroundColor Gray
Write-Host "Write-ProgressBar -CurrentValue 25 -MaxValue 50 -Style Bar -Text '25MB / 50MB'" -ForegroundColor Gray

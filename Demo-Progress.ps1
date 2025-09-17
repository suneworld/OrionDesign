# ================================================================================
# ORION DESIGN - Write-ProgressBar Demonstration Script
# ================================================================================
# This script demonstrates the Write-ProgressBar function's capabilities and shows
# how to create dynamic progress indicators with increasing values.

# Import the OrionDesign module
Import-Module .\OrionDesign.psd1 -Force

Clear-Host

# Display header
Write-Banner -Text "OrionDesign Write-ProgressBar Demonstration" -Color "Cyan"
Write-Host ""

# ================================================================================
# UNDERSTANDING Write-ProgressBar
# ================================================================================

Write-Header -Text "Understanding Write-ProgressBar Function" -Level 2

Write-InfoBox -Title "Write-ProgressBar Overview" -Message @(
    "Write-ProgressBar creates visual progress indicators with multiple styles:",
    "• Bar: Traditional horizontal progress bar (█░░░)",
    "• Blocks: Block-style with partial segments (▏▎▍▌▋▊▉█)", 
    "• Dots: Animated rotating dots (⟳ ●●●●)",
    "• Spinner: Spinning character animation (⠋⠙⠹⠸)",
    "• Modern: Clean modern design with rounded ends (●━━┄)"
) -Width 70

Write-Host ""

# ================================================================================
# BASIC PROGRESS EXAMPLES
# ================================================================================

Write-Header -Text "Basic Progress Examples" -Level 2

Write-Host "Static Progress Examples:" -ForegroundColor Green
Write-Host ""

# Bar style examples
Write-Host "Bar Style (25%):" -ForegroundColor Yellow
Write-ProgressBar -CurrentValue 25 -MaxValue 100 -Style Bar -ShowPercentage

Write-Host "Bar Style (50%):" -ForegroundColor Yellow  
Write-ProgressBar -CurrentValue 50 -MaxValue 100 -Style Bar -ShowPercentage

Write-Host "Bar Style (75%):" -ForegroundColor Yellow
Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Style Bar -ShowPercentage

Write-Host ""

# Blocks style examples
Write-Host "Blocks Style (60%):" -ForegroundColor Cyan
Write-ProgressBar -CurrentValue 60 -MaxValue 100 -Style Blocks -ShowPercentage -Text "Processing files"

Write-Host ""

# Modern style example
Write-Host "Modern Style (80%):" -ForegroundColor Magenta
Write-ProgressBar -CurrentValue 80 -MaxValue 100 -Style Modern -ShowPercentage -Text "Download complete"

Write-Host ""
Write-Host "Press any key to see dynamic progress demonstrations..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Clear-Host

# ================================================================================
# DYNAMIC PROGRESS DEMONSTRATIONS  
# ================================================================================

Write-Header -Text "Dynamic Progress Demonstrations" -Level 1

# Demo 1: File Processing Simulation
Write-Header -Text "Demo 1: File Processing Simulation" -Level 2
Write-Host ""

$totalFiles = 20
Write-Host "Processing $totalFiles files..." -ForegroundColor Green
Write-Host ""

for ($i = 1; $i -le $totalFiles; $i++) {
    $fileName = "file_$('{0:D3}' -f $i).txt"
    
    # Show progress with filename
    Write-Host "`rProcessing: " -NoNewline -ForegroundColor Yellow
    Write-ProgressBar -CurrentValue $i -MaxValue $totalFiles -Style Bar -ShowPercentage -Text $fileName -Clear
    
    # Simulate processing time
    Start-Sleep -Milliseconds 200
}

Write-Host ""
Write-ActionStatus -Status "Success" -Message "All files processed successfully"
Write-Host ""

# Demo 2: Download Progress Simulation
Write-Header -Text "Demo 2: Download Progress Simulation" -Level 2
Write-Host ""

$totalSize = 100
Write-Host "Downloading large file..." -ForegroundColor Green
Write-Host ""

for ($downloaded = 0; $downloaded -le $totalSize; $downloaded += 3) {
    if ($downloaded -gt $totalSize) { $downloaded = $totalSize }
    
    $speed = Get-Random -Minimum 50 -Maximum 150
    $eta = [Math]::Round(($totalSize - $downloaded) / 3 * 0.2, 1)
    
    Write-Host "`rDownload: " -NoNewline -ForegroundColor Cyan
    Write-ProgressBar -CurrentValue $downloaded -MaxValue $totalSize -Style Modern -ShowPercentage -Text "[$speed KB/s] ETA: ${eta}s" -Clear
    
    Start-Sleep -Milliseconds 150
}

Write-Host ""
Write-ActionStatus -Status "Success" -Message "Download completed"  
Write-Host ""

# Demo 3: Multi-Style Progress Comparison
Write-Header -Text "Demo 3: Multi-Style Progress Comparison" -Level 2
Write-Host ""

Write-Host "Comparing all progress styles at 67%:" -ForegroundColor Green
Write-Host ""

$current = 67
$max = 100

Write-Host "Bar Style:     " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Bar -ShowPercentage

Write-Host "Blocks Style:  " -NoNewline -ForegroundColor White  
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Blocks -ShowPercentage

Write-Host "Modern Style:  " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Modern -ShowPercentage

Write-Host "Dots Style:    " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Dots -ShowPercentage

Write-Host "Spinner Style: " -NoNewline -ForegroundColor White
Write-ProgressBar -CurrentValue $current -MaxValue $max -Style Spinner -ShowPercentage

Write-Host ""

# Demo 4: Database Migration Simulation
Write-Header -Text "Demo 4: Database Migration Simulation" -Level 2
Write-Host ""

$tables = @("users", "products", "orders", "inventory", "customers", "analytics", "logs", "settings")
Write-Host "Migrating database tables..." -ForegroundColor Green
Write-Host ""

for ($i = 0; $i -lt $tables.Count; $i++) {
    $tableName = $tables[$i]
    $recordCount = Get-Random -Minimum 1000 -Maximum 50000
    
    Write-Host "`rMigrating table '$tableName' ($recordCount records): " -NoNewline -ForegroundColor Yellow
    
    # Simulate record processing
    for ($record = 0; $record -le $recordCount; $record += [Math]::Max(1, [Math]::Floor($recordCount / 20))) {
        if ($record -gt $recordCount) { $record = $recordCount }
        
        Write-ProgressBar -CurrentValue $record -MaxValue $recordCount -Style Blocks -ShowPercentage -Clear
        Start-Sleep -Milliseconds 50
    }
    
    Write-Host ""
    Write-ActionStatus -Status "Success" -Message "Table '$tableName' migrated ($recordCount records)"
}

Write-Host ""

# Demo 5: Animated Spinner and Dots
Write-Header -Text "Demo 5: Animated Indicators" -Level 2
Write-Host ""

Write-Host "Animated Spinner (10 seconds):" -ForegroundColor Cyan
for ($i = 1; $i -le 50; $i++) {
    Write-Host "`rConnecting to server: " -NoNewline -ForegroundColor Yellow
    Write-ProgressBar -CurrentValue $i -MaxValue 50 -Style Spinner -Text "Establishing connection..." -Clear
    Start-Sleep -Milliseconds 200
}
Write-Host ""
Write-ActionStatus -Status "Success" -Message "Connected to server"

Write-Host ""
Write-Host "Animated Dots (5 seconds):" -ForegroundColor Magenta
for ($i = 1; $i -le 25; $i++) {
    Write-Host "`rProcessing data: " -NoNewline -ForegroundColor Yellow  
    Write-ProgressBar -CurrentValue $i -MaxValue 25 -Style Dots -Text "Analyzing results..." -Clear
    Start-Sleep -Milliseconds 200
}
Write-Host ""
Write-ActionStatus -Status "Success" -Message "Data processing complete"

Write-Host ""

# ================================================================================
# ADVANCED USAGE EXAMPLES
# ================================================================================

Write-Header -Text "Advanced Usage Examples" -Level 1

Write-InfoBox -Title "Key Write-ProgressBar Parameters" -Message @(
    "• CurrentValue: Current progress value (required)",
    "• MaxValue: Maximum progress value (required)", 
    "• Style: Visual style (Bar, Blocks, Dots, Spinner, Modern)",
    "• Width: Width of progress bar (default: 40)",
    "• ShowPercentage: Display percentage value",
    "• Text: Optional descriptive text",
    "• Color: Custom color for progress indicator", 
    "• Clear: Clear current line for smooth updates"
) -Width 70

Write-Host ""

Write-Header -Text "Custom Width and Color Examples" -Level 2

# Different widths
Write-Host "Narrow Progress (Width: 20):" -ForegroundColor Yellow
Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Style Bar -Width 20 -ShowPercentage

Write-Host "Wide Progress (Width: 60):" -ForegroundColor Yellow
Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Style Bar -Width 60 -ShowPercentage

# Custom colors  
Write-Host ""
Write-Host "Custom Colors:" -ForegroundColor Green
Write-Host "Red Progress:    " -NoNewline
Write-ProgressBar -CurrentValue 30 -MaxValue 100 -Style Modern -Color Red -ShowPercentage

Write-Host "Green Progress:  " -NoNewline
Write-ProgressBar -CurrentValue 75 -MaxValue 100 -Style Modern -Color Green -ShowPercentage

Write-Host "Yellow Progress: " -NoNewline  
Write-ProgressBar -CurrentValue 50 -MaxValue 100 -Style Modern -Color Yellow -ShowPercentage

Write-Host ""

# ================================================================================
# PRACTICAL USAGE PATTERNS
# ================================================================================

Write-Header -Text "Practical Usage Patterns" -Level 1

Write-InfoBox -Title "Best Practices" -Message @(
    "1. Use -Clear parameter for smooth animations",
    "2. Add descriptive -Text for user context", 
    "3. Choose appropriate -Style for your use case:",
    "   • Bar: General purpose, clean appearance",
    "   • Blocks: Precise progress with partial segments",
    "   • Modern: Contemporary, professional look",
    "   • Spinner: Indeterminate progress",
    "   • Dots: Lightweight activity indicator",
    "4. Include -ShowPercentage for exact progress",
    "5. Use consistent Width for multiple progress bars"
) -Width 70

Write-Host ""
Write-Host "Demonstration completed!" -ForegroundColor Green
Write-Host "You can now use Write-ProgressBar in your own scripts." -ForegroundColor Cyan

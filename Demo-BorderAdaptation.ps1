# Demo: Border Adaptation in OrionDesign Write-InfoBox
# This script demonstrates how borders automatically adapt to content length

Import-Module .\OrionDesign.psd1 -Force

Write-Host "`n=== BORDER ADAPTATION DEMONSTRATION ===" -ForegroundColor Cyan
Write-Host "The Write-InfoBox function automatically adapts borders to content length`n" -ForegroundColor Yellow

# 1. Minimal Content - Border shrinks to minimum size
Write-Host "1. Minimal Content:" -ForegroundColor Green
Write-InfoBox -Title "Min" -Content @{"A"="B"}

# 2. Medium Content - Border expands to accommodate
Write-Host "2. Medium Content:" -ForegroundColor Green  
Write-InfoBox -Title "Server Status" -Content @{
    "Server Name" = "PROD-WEB-01"
    "Status" = "Online"
    "Uptime" = "45 days, 12 hours"
}

# 3. Long Content - Border adapts to longest line
Write-Host "3. Long Content:" -ForegroundColor Green
Write-InfoBox -Title "System Configuration Details" -Content @{
    "Application Server" = "PRODUCTION-APPLICATION-SERVER-01"
    "Database Connection" = "Server=sql.company.com;Database=Production;Integrated Security=true"
    "Status" = "Operational and processing requests normally"
}

# 4. Different Styles - All adapt borders
Write-Host "4. Different Styles (all adaptive):" -ForegroundColor Green
Write-InfoBox -Title "Modern Adaptive" -Content @{"Feature"="Auto-sizing borders"} -Style Modern
Write-InfoBox -Title "Simple Adaptive" -Content @{"Demonstration"="Border grows with content"} -Style Simple
Write-InfoBox -Title "Accent Adaptive" -Content @{"Capability"="Dynamic width calculation"} -Style Accent

# 5. Width Controls
Write-Host "5. Width Control Options:" -ForegroundColor Green
Write-Host "   a) Explicit Width:" -ForegroundColor Yellow
Write-InfoBox -Title "Fixed 80 chars" -Content @{"Setting"="Explicit width override"} -Width 80

Write-Host "   b) Global Width Setting:" -ForegroundColor Yellow
Set-OrionMaxWidth -Width 60
Write-InfoBox -Title "Global Limit" -Content @{"Constraint"="Respects global maximum width setting"}

# Reset to default
Set-OrionMaxWidth -Reset

Write-Host "`n=== KEY ADAPTATION FEATURES ===" -ForegroundColor Cyan
Write-Host "✓ Automatic width calculation based on content" -ForegroundColor Green
Write-Host "✓ Minimum width constraints for readability" -ForegroundColor Green  
Write-Host "✓ Maximum width limits to prevent overly wide boxes" -ForegroundColor Green
Write-Host "✓ Global width configuration via Set-OrionMaxWidth" -ForegroundColor Green
Write-Host "✓ Manual width override with -Width parameter" -ForegroundColor Green
Write-Host "✓ Consistent adaptation across all visual styles" -ForegroundColor Green
Write-Host "✓ Perfect alignment maintained regardless of content length" -ForegroundColor Green
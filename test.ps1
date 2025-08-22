<#
================================================================================
TEST SCRIPT - Write-Action and Write-ActionStatus Demonstration
================================================================================
This script demonstrates the two-part action pattern:
1. Write-Action: Shows what we're doing (no newline)
2. Write-ActionStatus: Shows the result on the same line

The pattern simulates real-world scenarios where you start an action,
do some work, and then report success or failure.
================================================================================
#>

Write-Host "🧪 Testing Write-Action + Write-ActionStatus Pattern" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor DarkCyan
Write-Host

Write-Host "📋 Test Scenarios:" -ForegroundColor Yellow
Write-Host

# TEST 1: Success Scenario
Write-Host "1️⃣  SUCCESS SCENARIO:" -ForegroundColor Green
Write-Action "Connecting to database"
Start-Sleep 1  # Simulate some work
Write-ActionStatus "Connected" -Status Success

Write-Action "Loading user data"
Start-Sleep 1  # Simulate some work  
Write-ActionStatus "125 users found"  # Auto-detects as success

Write-Action "Processing records"
Start-Sleep 1  # Simulate some work
Write-ActionStatus "OK!" -Status Success

Write-Host

# TEST 2: Error Scenario  
Write-Host "2️⃣  ERROR SCENARIO:" -ForegroundColor Red
Write-Action "Connecting to remote server"
Start-Sleep 1  # Simulate some work
Write-ActionStatus "Connection failed" -Status Failed

Write-Action "Reading configuration file"
Start-Sleep 1  # Simulate some work
Write-ActionStatus "File not found"  # Auto-detects as error

Write-Action "Validating credentials"
Start-Sleep 1  # Simulate some work
Write-ActionStatus "Access denied" -Status Failed

Write-Host

# TEST 3: Mixed Scenario (Real-world example)
Write-Host "3️⃣  MIXED SCENARIO (Real-world example):" -ForegroundColor Cyan
Write-Action "Checking system requirements"
Start-Sleep 1
Write-ActionStatus "All requirements met" -Status Success

Write-Action "Starting backup process"
Start-Sleep 2  # Longer simulation
Write-ActionStatus "Backup completed" -Status Success

Write-Action "Sending notification email"
Start-Sleep 1
Write-ActionStatus "SMTP server unavailable" -Status Failed

Write-Action "Cleaning up temporary files"
Start-Sleep 1
Write-ActionStatus "Cleanup completed" -Status Success

Write-Host

# TEST 4: Different Status Types
Write-Host "4️⃣  DIFFERENT STATUS TYPES:" -ForegroundColor Magenta
Write-Action "Memory usage check"
Write-ActionStatus "Warning: 85% used" -Status Warning

Write-Action "Update availability check"
Write-ActionStatus "Updates pending" -Status Pending

Write-Action "Service status check"
Write-ActionStatus "Service is running" -Status Running

Write-Action "System information"
Write-ActionStatus "Windows 11 Pro" -Status Info

Write-Host
Write-Host "✅ Test completed! Notice how:" -ForegroundColor Green
Write-Host "   • Actions start on the left and wait" -ForegroundColor White
Write-Host "   • Results appear on the same line with colors/icons" -ForegroundColor White
Write-Host "   • Different status types have different colors" -ForegroundColor White
Write-Host "   • Auto-detection works for common patterns" -ForegroundColor White 
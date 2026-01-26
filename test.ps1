<#
================================================================================
OrionDesign Action Functions Demonstration
================================================================================
Demonstrates: Write-Action, Write-ActionStatus, Write-ActionResult
================================================================================
#>

Import-Module .\OrionDesign.psd1 -Force

# ══════════════════════════════════════════════════════════════════════════════
# Write-Action + Write-ActionStatus (Paired Pattern)
# ══════════════════════════════════════════════════════════════════════════════

# --- All Status Types ---
Write-Host 'Write-Action "Standard with no parameters"; Write-ActionStatus "No parameters"' -ForegroundColor DarkGray
Write-Action "Standard with no parameters"
Write-ActionStatus "Ganske lang tekst som demonstrerer standard oppførsel uten parametere"




Write-Host 'Write-Action "Success status example"; Write-ActionStatus "Connected successfully" -Status Success' -ForegroundColor DarkGray
Write-Action "Success status example"
Write-ActionStatus "Connected successfully" -Status Success

Write-Host 'Write-Action "Failed status example"; Write-ActionStatus "Connection refused" -Status Failed' -ForegroundColor DarkGray
Write-Action "Failed status example"  
Write-ActionStatus "Connection refused" -Status Failed

Write-Host 'Write-Action "Warning status example"; Write-ActionStatus "Timeout detected" -Status Warning' -ForegroundColor DarkGray
Write-Action "Warning status example"
Write-ActionStatus "Timeout detected" -Status Warning

Write-Host 'Write-Action "Info status example"; Write-ActionStatus "Processing started" -Status Info' -ForegroundColor DarkGray
Write-Action "Info status example"
Write-ActionStatus "Processing started" -Status Info

Write-Host 'Write-Action "Running status example"; Write-ActionStatus "Task in progress" -Status Running' -ForegroundColor DarkGray
Write-Action "Running status example"
Write-ActionStatus "Task in progress" -Status Running

Write-Host 'Write-Action "Pending status example"; Write-ActionStatus "Waiting in queue" -Status Pending' -ForegroundColor DarkGray
Write-Action "Pending status example"
Write-ActionStatus "Waiting in queue" -Status Pending

# --- Auto-Detection (no -Status specified) ---
Write-Host 'Write-Action "Auto-detect: Success patterns"; Write-ActionStatus "OK"' -ForegroundColor DarkGray
Write-Action "Auto-detect: Success patterns"
Write-ActionStatus "OK"

Write-Host 'Write-Action "Auto-detect: User count"; Write-ActionStatus "847 users synchronized"' -ForegroundColor DarkGray
Write-Action "Auto-detect: User count"
Write-ActionStatus "847 users synchronized"

Write-Host 'Write-Action "Auto-detect: Connected"; Write-ActionStatus "Connected to server"' -ForegroundColor DarkGray
Write-Action "Auto-detect: Connected"
Write-ActionStatus "Connected to server"

Write-Host 'Write-Action "Auto-detect: Failure patterns"; Write-ActionStatus "Error: Access denied"' -ForegroundColor DarkGray
Write-Action "Auto-detect: Failure patterns"
Write-ActionStatus "Error: Access denied"

Write-Host 'Write-Action "Auto-detect: Not found"; Write-ActionStatus "File not found"' -ForegroundColor DarkGray
Write-Action "Auto-detect: Not found"
Write-ActionStatus "File not found"

Write-Host 'Write-Action "Auto-detect: Warning patterns"; Write-ActionStatus "Warning: Slow response"' -ForegroundColor DarkGray
Write-Action "Auto-detect: Warning patterns"
Write-ActionStatus "Warning: Slow response"

Write-Host 'Write-Action "Auto-detect: Running patterns"; Write-ActionStatus "Processing data..."' -ForegroundColor DarkGray
Write-Action "Auto-detect: Running patterns"
Write-ActionStatus "Processing data..."

Write-Host 'Write-Action "Auto-detect: Pending patterns"; Write-ActionStatus "Queued for execution"' -ForegroundColor DarkGray
Write-Action "Auto-detect: Pending patterns"
Write-ActionStatus "Queued for execution"

# --- Realistic Scenario with delays ---
Write-Host 'Write-Action "Connecting to Azure subscription"; Write-ActionStatus "Connected to SUB-PROD-01" -Status Success' -ForegroundColor DarkGray
Write-Action "Connecting to Azure subscription"
Start-Sleep -Milliseconds 200
Write-ActionStatus "Connected to SUB-PROD-01" -Status Success

Write-Host 'Write-Action "Validating Terraform configuration"; Write-ActionStatus "12 resources validated" -Status Success' -ForegroundColor DarkGray
Write-Action "Validating Terraform configuration"
Start-Sleep -Milliseconds 150
Write-ActionStatus "12 resources validated" -Status Success

Write-Host 'Write-Action "Checking existing infrastructure"; Write-ActionStatus "3 drift detections" -Status Warning' -ForegroundColor DarkGray
Write-Action "Checking existing infrastructure"
Start-Sleep -Milliseconds 180
Write-ActionStatus "3 drift detections" -Status Warning

Write-Host 'Write-Action "Applying infrastructure changes"; Write-ActionStatus "8 resources updated" -Status Success' -ForegroundColor DarkGray
Write-Action "Applying infrastructure changes"
Start-Sleep -Milliseconds 250
Write-ActionStatus "8 resources updated" -Status Success

Write-Host 'Write-Action "Running smoke tests"; Write-ActionStatus "Test suite failed" -Status Failed' -ForegroundColor DarkGray
Write-Action "Running smoke tests"
Start-Sleep -Milliseconds 200
Write-ActionStatus "Test suite failed" -Status Failed

Write-Host 'Write-Action "Initiating rollback procedure"; Write-ActionStatus "Rollback complete" -Status Success' -ForegroundColor DarkGray
Write-Action "Initiating rollback procedure"
Start-Sleep -Milliseconds 150
Write-ActionStatus "Rollback complete" -Status Success

# --- Width Control ---
Write-Host 'Write-Action "Short task" -Width 30; Write-ActionStatus "Done" -Status Success' -ForegroundColor DarkGray
Write-Action "Short task" -Width 30
Write-ActionStatus "Done" -Status Success

Write-Host 'Write-Action "A much longer action description..." -Width 40; Write-ActionStatus "Completed" -Status Success' -ForegroundColor DarkGray
Write-Action "A much longer action description that demonstrates truncation" -Width 40
Write-ActionStatus "Completed" -Status Success

Write-Host 'Write-Action "Compact" -Width 25; Write-ActionStatus "OK" -Status Success' -ForegroundColor DarkGray
Write-Action "Compact" -Width 25
Write-ActionStatus "OK" -Status Success

# ══════════════════════════════════════════════════════════════════════════════
# Write-ActionResult (Standalone)
# ══════════════════════════════════════════════════════════════════════════════

# --- All Status Types with Icons ---
Write-Host 'Write-ActionResult -Action "Deploy Application" -Status Success -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Deploy Application" -Status Success -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "Connect to Database" -Status Failed -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Connect to Database" -Status Failed -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "Validate Configuration" -Status Warning -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Validate Configuration" -Status Warning -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "Fetch Remote Data" -Status Info -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Fetch Remote Data" -Status Info -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "Background Sync" -Status Running -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Background Sync" -Status Running -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "Scheduled Task" -Status Pending -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Scheduled Task" -Status Pending -ShowIcon -ShowStatus

# --- Minimal Output (No Icons/Status) ---
Write-Host 'Write-ActionResult -Action "File uploaded successfully" -Status Success' -ForegroundColor DarkGray
Write-ActionResult -Action "File uploaded successfully" -Status Success

Write-Host 'Write-ActionResult -Action "Permission denied" -Status Failed' -ForegroundColor DarkGray
Write-ActionResult -Action "Permission denied" -Status Failed

Write-Host 'Write-ActionResult -Action "Disk space low" -Status Warning' -ForegroundColor DarkGray
Write-ActionResult -Action "Disk space low" -Status Warning

Write-Host 'Write-ActionResult -Action "Processing batch 5 of 10" -Status Info' -ForegroundColor DarkGray
Write-ActionResult -Action "Processing batch 5 of 10" -Status Info

# --- With Details ---
Write-Host 'Write-ActionResult -Action "Database Migration" -Status Success -Details "142 tables migrated, 0 errors" -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "Database Migration" -Status Success -Details "142 tables migrated, 0 errors" -ShowIcon

Write-Host 'Write-ActionResult -Action "API Integration" -Status Warning -Details "3 endpoints deprecated..." -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "API Integration" -Status Warning -Details "3 endpoints deprecated, update recommended" -ShowIcon

Write-Host 'Write-ActionResult -Action "Security Scan" -Status Info -Details "Scanned 1,247 files in 12 seconds" -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "Security Scan" -Status Info -Details "Scanned 1,247 files in 12 seconds" -ShowIcon

# --- With Duration ---
Write-Host 'Write-ActionResult -Action "Build Solution" -Status Success -Duration "00:02:45" -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Build Solution" -Status Success -Duration "00:02:45" -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "Run Test Suite" -Status Success -Duration "00:15:32" -Details "847 tests passed" -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "Run Test Suite" -Status Success -Duration "00:15:32" -Details "847 tests passed" -ShowIcon

Write-Host 'Write-ActionResult -Action "Deploy to Production" -Status Success -Duration "00:05:12" -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Deploy to Production" -Status Success -Duration "00:05:12" -ShowIcon -ShowStatus

# --- With Subtext ---
Write-Host 'Write-ActionResult -Action "1,247" -Status Success -Subtext "users synchronized" -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "1,247" -Status Success -Subtext "users synchronized" -ShowIcon

Write-Host 'Write-ActionResult -Action "89" -Status Warning -Subtext "devices offline" -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "89" -Status Warning -Subtext "devices offline" -ShowIcon

Write-Host 'Write-ActionResult -Action "12,459" -Status Success -Subtext "records processed" -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "12,459" -Status Success -Subtext "records processed" -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "3" -Status Failed -Subtext "connections failed" -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "3" -Status Failed -Subtext "connections failed" -ShowIcon

# --- Failure with FailureReason and Suggestion ---
Write-Host 'Write-ActionResult -Action "Connect to SMTP Server" -Status Failed -FailureReason "..." -Suggestion "..." -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Connect to SMTP Server" -Status Failed `
    -FailureReason "Connection timeout after 30 seconds" `
    -Suggestion "Check firewall rules and SMTP server availability" `
    -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "Authenticate User" -Status Failed -FailureReason "..." -Suggestion "..." -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Authenticate User" -Status Failed `
    -FailureReason "Invalid credentials provided" `
    -Suggestion "Verify username and password, check account lockout status" `
    -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "Load Configuration" -Status Failed -FailureReason "..." -Suggestion "..." -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Load Configuration" -Status Failed `
    -FailureReason "Config file not found at C:\App\config.json" `
    -Suggestion "Ensure config file exists or run initialization script" `
    -ShowIcon -ShowStatus

# --- Indentation for nested operations ---
Write-Host 'Write-ActionResult -Action "Deploy Microservices" -Status Success -ShowIcon -ShowStatus' -ForegroundColor DarkGray
Write-ActionResult -Action "Deploy Microservices" -Status Success -ShowIcon -ShowStatus

Write-Host 'Write-ActionResult -Action "API Gateway" -Status Success -Indent 4 -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "API Gateway" -Status Success -Indent 4 -ShowIcon

Write-Host 'Write-ActionResult -Action "Auth Service" -Status Success -Indent 4 -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "Auth Service" -Status Success -Indent 4 -ShowIcon

Write-Host 'Write-ActionResult -Action "User Service" -Status Warning -Indent 4 -Details "Memory optimization needed" -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "User Service" -Status Warning -Indent 4 -Details "Memory optimization needed" -ShowIcon

Write-Host 'Write-ActionResult -Action "Payment Service" -Status Success -Indent 4 -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "Payment Service" -Status Success -Indent 4 -ShowIcon

Write-Host 'Write-ActionResult -Action "Notification Service" -Status Failed -Indent 4 -FailureReason "Missing env variables" -ShowIcon' -ForegroundColor DarkGray
Write-ActionResult -Action "Notification Service" -Status Failed -Indent 4 -FailureReason "Missing env variables" -ShowIcon

# --- NoNewLine for custom continuation ---
Write-Host 'Write-ActionResult -Action "Processing" -Status Running -ShowIcon -NoNewLine; Write-Host " - Please wait..."' -ForegroundColor DarkGray
Write-ActionResult -Action "Processing" -Status Running -ShowIcon -NoNewLine
Write-Host " - Please wait..." -ForegroundColor Gray

Write-Host 'Write-ActionResult -Action "847" -Status Success -Subtext "items" -ShowIcon -NoNewLine; Write-Host " in queue..."' -ForegroundColor DarkGray
Write-ActionResult -Action "847" -Status Success -Subtext "items" -ShowIcon -NoNewLine
Write-Host " in queue ready for export" -ForegroundColor Gray

Write-Host 'Write-ActionResult -Action "COMPLETED" -Status Success -ShowIcon -NoNewLine; Write-Host " - All tasks finished!"' -ForegroundColor DarkGray
Write-ActionResult -Action "COMPLETED" -Status Success -ShowIcon -NoNewLine
Write-Host " - All tasks finished successfully!" -ForegroundColor Green


Write-Separator "Test"
Write-Action "Write-Action etterfulgt av Write-ActionStatus"
Write-ActionStatus "Dette er en test på lang Result"

Write-Separator "Test"
Write-Action "Write-Action etterfulgt av Write-ActionResult"
Write-ActionResult "Dette er en test på lang Result" -Status Success



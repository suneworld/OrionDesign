function Show-OrionDemoInteractiveFunctions {
    <#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Interactive Functions Demo
================================================================================
Author:        Sune Alexandersen Narud  
Date:          September 17, 2025
Module:        OrionDesign v1.5.0
Category:      Interactive Demonstration
Dependencies:  OrionDesign Interactive Functions

FUNCTION PURPOSE:
Interactive demonstration of Write-Menu and Write-Question functions.
Showcases user input capabilities, validation, and interactive UI elements
with real user interaction and response handling.

HLD INTEGRATION:
┌─ INTERACTIVE DEMO ─┐    ┌─ USER INPUT ─┐    ┌─ OUTPUT ─┐
│ Write-Menu        │◄──►│ Selection    │───►│ Results  │
│ Write-Question    │    │ Validation   │    │ Feedback │
│ • All Types       │    │ Navigation   │    │ Live     │
│ • All Styles      │    │ Error Handle │    │ Demo     │
└───────────────────┘    └──────────────┘    └──────────┘
================================================================================
#>

    <#
    .SYNOPSIS
    Interactive demonstration of OrionDesign input functions (Write-Menu and Write-Question).

    .DESCRIPTION
    Show-OrionDemoInteractiveFunctions provides hands-on demonstration of the interactive
    functions in the OrionDesign module. Users can experience real menu navigation,
    question prompts, and input validation.

    .EXAMPLE
    Show-OrionDemoInteractiveFunctions
    Runs the interactive demonstration with user input.

    .NOTES
    Author: OrionDesign Module
    Version: 1.0.0
    This demo requires user interaction and cannot be run in automated mode.
    #>
    [CmdletBinding()]
    param()

    function Demo-Separator {
        param (
            [string]$Text = "",
            [string]$Style = "Single"
        )
        Write-Host
        Write-Host
        Write-Host
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host "         $Text " -ForegroundColor DarkGray
        Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    }

    # Demo header
    Clear-Host
    Write-Banner -ScriptName "OrionDesign Interactive Demo" -Author "Sune A Narud" -Design Modern -Description "Interactive demonstration of Write-Menu and Write-Question functions"

    Write-Host "🎮 " -NoNewline -ForegroundColor Cyan
    Write-Host "Welcome to the Interactive Functions Demo!" -ForegroundColor White
    Write-Host "This demonstration requires your participation to show the interactive capabilities." -ForegroundColor Gray
    Write-Host

    $continue = Write-Question -Text "Ready to start the interactive demo?" -Type YesNo -Default Yes
    if (-not $continue) {
        Write-Host "👋 Demo cancelled. Run again when you're ready!" -ForegroundColor Yellow
        return
    }

    # === WRITE-MENU DEMONSTRATIONS ===
    
    Demo-Separator "Write-Menu -Style Simple"
    Write-Host "🔹 Demonstrating Simple menu style:" -ForegroundColor Cyan
    $menuResult = Write-Menu -Title "Development Environment" -Options @("Development", "Testing", "Staging", "Production") -Style Simple
    Write-Host "✅ You selected: $($menuResult.Value) (Index: $($menuResult.Index))" -ForegroundColor Green

    Demo-Separator "Write-Menu -Style Modern"
    Write-Host "🔹 Demonstrating Modern menu style with default selection:" -ForegroundColor Cyan
    $menuResult = Write-Menu -Title "Deployment Action" -Options @("Deploy Application", "Run Tests", "View Logs", "Rollback", "Exit") -Style Modern -DefaultSelection 1
    Write-Host "✅ You selected: $($menuResult.Value)" -ForegroundColor Green

    Demo-Separator "Write-Menu -Style Boxed"
    Write-Host "🔹 Demonstrating Boxed menu style:" -ForegroundColor Cyan
    $menuResult = Write-Menu -Title "Server Management" -Options @("Start Services", "Stop Services", "Restart Services", "Check Status") -Style Boxed
    Write-Host "✅ You selected: $($menuResult.Value)" -ForegroundColor Green

    Demo-Separator "Write-Menu -Style Compact"
    Write-Host "🔹 Demonstrating Compact menu style:" -ForegroundColor Cyan
    $menuResult = Write-Menu -Title "Quick Actions" -Options @("Save", "Load", "Reset", "Exit") -Style Compact
    Write-Host "✅ You selected: $($menuResult.Value)" -ForegroundColor Green

    # === WRITE-QUESTION DEMONSTRATIONS ===

    Demo-Separator "Write-Question -Type Text"
    Write-Host "🔹 Demonstrating Text question type:" -ForegroundColor Cyan
    $name = Write-Question -Text "What is your name?" -Default "Developer"
    Write-Host "✅ Hello, $name!" -ForegroundColor Green

    Demo-Separator "Write-Question -Type YesNo"
    Write-Host "🔹 Demonstrating Yes/No question type:" -ForegroundColor Cyan
    $confirm = Write-Question -Text "Do you want to continue with deployment?" -Type YesNo -Default Yes
    $result = if ($confirm) { "proceeding" } else { "cancelled" }
    Write-Host "✅ Deployment $result based on your choice." -ForegroundColor Green

    Demo-Separator "Write-Question -Type Choice"
    Write-Host "🔹 Demonstrating Choice question type:" -ForegroundColor Cyan
    $priority = Write-Question -Text "Select priority level" -Type Choice -Options @("Low", "Medium", "High", "Critical") -Required
    Write-Host "✅ Priority set to: $priority" -ForegroundColor Green
<#
    Demo-Separator "Write-Question -Type Number"
    Write-Host "🔹 Demonstrating Number question type with validation:" -ForegroundColor Cyan
    $port = Write-Question -Text "Enter port number" -Type Number -Validation { $_ -gt 0 -and $_ -lt 65536 } -ValidationMessage "Port must be between 1 and 65535" -Default 8080
    Write-Host "✅ Port configured: $port" -ForegroundColor Green
#>

    Demo-Separator "Write-Question -Type Secure"
    Write-Host "🔹 Demonstrating Secure password input:" -ForegroundColor Cyan
    Write-Host "Note: Your input will be masked for security" -ForegroundColor Yellow
    $password = Write-Question -Text "Enter a password" -Type Secure -Required
    Write-Host "✅ Password captured securely (length: $($password.Length) characters)" -ForegroundColor Green
<#
    Demo-Separator "Write-Question with Custom Validation"
    Write-Host "🔹 Demonstrating custom validation (email format):" -ForegroundColor Cyan
    $email = Write-Question -Text "Enter your email address" -Validation { $_ -match "^[^@]+@[^@]+\.[^@]+$" } -ValidationMessage "Please enter a valid email address" -Required
    Write-Host "✅ Email registered: $email" -ForegroundColor Green

#>
    # === COMBINED DEMONSTRATION ===
    
    Demo-Separator "Combined Menu and Question Demo"
    Write-Host "🔹 Realistic workflow combining menu selection and questions:" -ForegroundColor Cyan
    
    $action = Write-Menu -Title "System Administration" -Options @("Create User", "Delete User", "Modify User", "List Users") -Style Modern
    
    switch ($action.Value) {
        "Create User" {
            $username = Write-Question -Text "Enter username" -Required -Validation { $_ -match "^[a-zA-Z0-9_]{3,20}$" } -ValidationMessage "Username must be 3-20 alphanumeric characters or underscores"
            $isAdmin = Write-Question -Text "Grant admin privileges?" -Type YesNo -Default No
            $email = Write-Question -Text "Enter email address" -Validation { $_ -match "^[^@]+@[^@]+\.[^@]+$" } -ValidationMessage "Please enter a valid email address"
            
            Write-Host "✅ User creation configured:" -ForegroundColor Green
            Write-Host "   Username: $username" -ForegroundColor White
            Write-Host "   Admin: $(if($isAdmin){'Yes'}else{'No'})" -ForegroundColor White
            Write-Host "   Email: $email" -ForegroundColor White
        }
        "Delete User" {
            $username = Write-Question -Text "Enter username to delete" -Required
            $confirm = Write-Question -Text "Are you sure you want to delete user '$username'? This cannot be undone!" -Type YesNo -Default No
            
            if ($confirm) {
                Write-Host "✅ User '$username' would be deleted." -ForegroundColor Red
            } else {
                Write-Host "✅ Delete operation cancelled." -ForegroundColor Yellow
            }
        }
        default {
            Write-Host "✅ You selected: $($action.Value) - feature would be implemented here." -ForegroundColor Green
        }
    }

    # === DEMO COMPLETION ===
    
    Demo-Separator "Interactive Demo Complete"
    Write-Host "🎉 " -NoNewline -ForegroundColor Green
    Write-Host "Interactive Functions Demo Complete!" -ForegroundColor White
    Write-Host
    Write-Host "You've experienced all the interactive capabilities of OrionDesign:" -ForegroundColor Gray
    Write-Host "  • Write-Menu with 4 different styles" -ForegroundColor White
    Write-Host "  • Write-Question with 5 input types" -ForegroundColor White  
    Write-Host "  • Custom validation and error handling" -ForegroundColor White
    Write-Host "  • Realistic workflow combinations" -ForegroundColor White
    Write-Host
    Write-Host "📖 For more information:" -ForegroundColor Cyan
    Write-Host "  • Get-Help Write-Menu -Full" -ForegroundColor White
    Write-Host "  • Get-Help Write-Question -Full" -ForegroundColor White
    Write-Host "  • Show-OrionDemo (non-interactive demo)" -ForegroundColor White
    Write-Host "  • Show-OrionDemoThemes (theme showcase)" -ForegroundColor White
}
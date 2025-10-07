<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Question Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Interactive Elements
Dependencies:  OrionDesign Theme System

FUNCTION PURPOSE:
Creates interactive prompts for user input with validation and type safety.
Essential interactive component providing various question types including
text input, yes/no prompts, choice selection, and secure password entry.

HLD INTEGRATION:
┌─ INTERACTIVE ─┐    ┌─ INPUT TYPES ─┐    ┌─ OUTPUT ─┐
│ Write-Question│◄──►│ Text/YesNo    │───►│ Validated│
│ • Validation  │    │ Choice/Secure │    │ Input    │
│ • Defaults    │    │ Number Types  │    │ Type Safe│
│ • Security    │    │ Custom Valid  │    │ Result   │
└───────────────┘    └───────────────┘    └──────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates styled interactive prompts for user input with validation and formatting.

.DESCRIPTION
The Write-Question function provides a consistent, themed approach to gathering user input. Supports various question types including Yes/No, multiple choice, secure input, and custom validation.

.PARAMETER Text
The question text to display to the user.

.PARAMETER Type
The type of question. Valid values:
- 'Text' (default) - Free text input
- 'YesNo' - Yes/No question with Y/N options
- 'Choice' - Multiple choice selection
- 'Secure' - Secure password input
- 'Number' - Numeric input with validation

.PARAMETER Options
Array of options for Choice type questions.

.PARAMETER Default
Default value if user presses Enter without input.

.PARAMETER Required
Makes the question mandatory (cannot be empty).

.PARAMETER Validation
Script block for custom validation of input.

.PARAMETER ValidationMessage
Custom message to display when validation fails.

.EXAMPLE
Write-Question "What is your name?"

Simple text input question.

.EXAMPLE
Write-Question "Continue with deployment?" -Type YesNo -Default Yes

Yes/No question with default value.

.EXAMPLE
Write-Question "Select environment" -Type Choice -Options @("Dev","Test","Prod") -Required

Multiple choice question that's required.

.EXAMPLE
Write-Question "Enter password" -Type Secure

Secure password input that masks characters.

.EXAMPLE
Write-Question "Enter port number" -Type Number -Validation { $_ -gt 0 -and $_ -lt 65536 } -ValidationMessage "Port must be between 1 and 65535"

Numeric input with custom validation.
#>
function Write-Question {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Text,
        [ValidateSet('Text', 'YesNo', 'Choice', 'Secure', 'Number')] [string]$Type = 'Text',
        [array]$Options = @(),
        [string]$Default = "",
        [switch]$Required,
        [scriptblock]$Validation,
        [string]$ValidationMessage = "Invalid input. Please try again."
    )

    # Default theme
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
        if ($psISE) { $script:Theme.UseAnsi = $false }
    }

    do {
        $validInput = $true
        $userInput = ""

        # Display the question
        Write-Host
        Write-Host $Text -ForegroundColor $script:Theme.Text -NoNewline

        # Add type-specific prompts
        switch ($Type) {
            'YesNo' {
                $promptText = if ($Default) { " [Y/n]" } else { " [y/N]" }
                Write-Host $promptText -ForegroundColor $script:Theme.Muted -NoNewline
            }
            'Choice' {
                Write-Host "`n" -NoNewline
                for ($i = 0; $i -lt $Options.Count; $i++) {
                    $prefix = "  $($i + 1). "
                    Write-Host $prefix -ForegroundColor $script:Theme.Accent -NoNewline
                    Write-Host $Options[$i] -ForegroundColor $script:Theme.Text
                }
                Write-Host "Select (1-$($Options.Count))" -ForegroundColor $script:Theme.Muted -NoNewline
                if ($Default) {
                    Write-Host " [default: $Default]" -ForegroundColor $script:Theme.Muted -NoNewline
                }
            }
            'Number' {
                Write-Host " (number)" -ForegroundColor $script:Theme.Muted -NoNewline
                if ($Default) {
                    Write-Host " [default: $Default]" -ForegroundColor $script:Theme.Muted -NoNewline
                }
            }
            'Secure' {
                Write-Host " (password will be hidden)" -ForegroundColor $script:Theme.Muted -NoNewline
            }
            default {
                if ($Default) {
                    Write-Host " [default: $Default]" -ForegroundColor $script:Theme.Muted -NoNewline
                }
            }
        }

        Write-Host ": " -ForegroundColor $script:Theme.Text -NoNewline

        # Get user input based on type
        switch ($Type) {
            'Secure' {
                $secureInput = Read-Host -AsSecureString
                $userInput = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureInput))
            }
            default {
                $userInput = Read-Host
            }
        }

        # Apply default if input is empty
        if ([string]::IsNullOrWhiteSpace($userInput) -and $Default) {
            $userInput = $Default
        }

        # Validate input based on type
        switch ($Type) {
            'YesNo' {
                if ([string]::IsNullOrWhiteSpace($userInput)) {
                    $userInput = if ($Default -eq 'Yes') { 'Y' } else { 'N' }
                }
                if ($userInput -match '^[Yy]') { 
                    return $true 
                } elseif ($userInput -match '^[Nn]') { 
                    return $false 
                } else {
                    Write-Host "  ❌ Please enter Y for Yes or N for No" -ForegroundColor $script:Theme.Error
                    $validInput = $false
                }
            }
            'Choice' {
                if ([string]::IsNullOrWhiteSpace($userInput)) {
                    if ($Required) {
                        Write-Host "  ❌ Selection is required" -ForegroundColor $script:Theme.Error
                        $validInput = $false
                    } elseif ($Default) {
                        return $Default
                    }
                } else {
                    $selection = 0
                    if ([int]::TryParse($userInput, [ref]$selection) -and $selection -ge 1 -and $selection -le $Options.Count) {
                        return $Options[$selection - 1]
                    } else {
                        Write-Host "  ❌ Please enter a number between 1 and $($Options.Count)" -ForegroundColor $script:Theme.Error
                        $validInput = $false
                    }
                }
            }
            'Number' {
                if ([string]::IsNullOrWhiteSpace($userInput)) {
                    if ($Required) {
                        Write-Host "  ❌ Number is required" -ForegroundColor $script:Theme.Error
                        $validInput = $false
                    } elseif ($Default) {
                        $userInput = $Default
                    } else {
                        # No input and no default, but not required - allow empty
                        return $null
                    }
                }
                
                # Validate the number (whether from input or default)
                if (-not [string]::IsNullOrWhiteSpace($userInput)) {
                    $number = 0
                    if (-not [double]::TryParse($userInput, [ref]$number)) {
                        Write-Host "  ❌ Please enter a valid number" -ForegroundColor $script:Theme.Error
                        $validInput = $false
                    } else {
                        $userInput = $number
                    }
                }
            }
            default {
                if ([string]::IsNullOrWhiteSpace($userInput) -and $Required) {
                    Write-Host "  ❌ Input is required" -ForegroundColor $script:Theme.Error
                    $validInput = $false
                }
            }
        }

        # Apply custom validation if provided and input is valid so far
        if ($validInput -and $Validation -and $userInput -ne $null -and $userInput -ne "") {
            try {
                # Debug output (remove after fixing)
                Write-Host "  [DEBUG] Validating value: '$userInput' (Type: $($userInput.GetType().Name))" -ForegroundColor DarkGray
                $validationResult = & $Validation $userInput
                Write-Host "  [DEBUG] Validation result: $validationResult" -ForegroundColor DarkGray
                if (-not $validationResult) {
                    Write-Host "  ❌ $ValidationMessage" -ForegroundColor $script:Theme.Error
                    $validInput = $false
                }
            } catch {
                Write-Host "  [DEBUG] Validation error: $($_.Exception.Message)" -ForegroundColor DarkRed
                Write-Host "  ❌ $ValidationMessage" -ForegroundColor $script:Theme.Error
                $validInput = $false
            }
        }

    } while (-not $validInput)

    return $userInput
}

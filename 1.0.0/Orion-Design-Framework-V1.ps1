<#
Orion Design Framework

Version 1.0 2025-08
Sune Alexandersen Narud

This module provides a set of functions and tools for designing and implementing user interfaces in PowerShell.
It includes features for creating menus, prompts, and other UI elements with a consistent look and feel.

Functions:
- Show-OrionDemo: Displays a demo of the Orion Design Module in action.
- Write-Banner: Writes a custom header with a title, author, date, and description.
- Write-SectionHeader: Writes a section header with a title and optional description.
- Write-ActionRow: Writes an action row with a title, description, and optional icon.
- Write-Question: Writes a question prompt with a title and optional default answer.
- Write-Step: Writes a step in a process with a title and optional description.

Examples:
```powershell
Show-OrionDemo
```
```powershell
Write-Banner -Title "My Script" -Author "John Doe" -Date "2025-08-01" -Description "This is a demo script."
```
```powershell
Write-SectionHeader -Title "Introduction" -Description "This section introduces the main concepts."
```
```powershell
Write-ActionRow -Title "Run Script" -Description "Runs the selected script." -Icon "play"
```
```powershell
Write-Question -Title "Continue?" -DefaultAnswer "Yes"
```
```powershell
Write-Step -Title "Step 1" -Description "This is the first step."
```

Put the following in your script and define settings:



############################################   Orion-Design-Framework v1 Variables  ###############################################
# Heading
$Banner_Width = 100
$Banner_PaddingSymbol = "#"
$Banner_IndentationIncrement = 4
$Banner_PaddingSymbolColor = "Cyan"
$Banner_TitleColor = "White"
$Banner_AuthorDateColor = "Gray"
$Banner_DescriptionColor = "DarkGray"
$Banner_ScriptName = "Tenant Explorer 3"
$Banner_TitleContentPadding = 2
$Banner_ScriptAuthorAndDate = " Sune Alexandersen Narud · 2025-08"
$Banner_AuthorDateContentPadding = 2
$Banner_ScriptDescription = @"
Explores tenant information via Microsoft Graph API
Exports data to Excel and CSV files
Includes functions for data retrieval, merging, and reporting
"@.Trim()


# Colors
$TextColor_Fail = "Red"
$TextColor_Warning = "Yellow"
$TextColor_Success = "Green"
$TextColor_MenuChoices = "Yellow"
$TextColor_Question = "Yellow"
$TextColor_Demo = "DarkGray"
$TextColor_DemoIntro = "DarkGray"


# Step
$TextColor_Step = "Cyan"
$DividerType_Step = "-"
$DividerColor_Step = "Cyan"

# Width
$Console_Width = "100"
$Write_Action_Width = "70"
###############################################################################################################################







#>


function Show-OrionDemo {
    
    Clear-Host

    # ---- Safe defaults for variables the writers expect ----
    # Colors (respect existing if already set)
  
    if (-not $script:BarTitleColor) { $script:BarTitleColor = "Blue" }

    if (-not $script:ActionBar_Color) { $script:ActionBar_Color = "White" }
    if (-not $script:ActionBar_Length) { $script:ActionBar_Length = 50 }
    if (-not $script:ActionText_Length) { $script:ActionText_Length = 60 }

    if (-not $script:SectionStep_color) { $script:SectionStep_color = "Green" }
    if (-not $script:sectionStep_DividerType) { $script:sectionStep_DividerType = "-" }
    if (-not $script:sectionStep_DividerColor) { $script:sectionStep_DividerColor = "Blue" }

    if (-not $script:sectionAction_dividerType) { $script:sectionAction_dividerType = "-" }
    if (-not $script:sectionAction_DividerColor) { $script:sectionAction_DividerColor = "Blue" }

    # Console width
    if (-not $script:ConsoleWidth) { 
        try { $script:ConsoleWidth = [Console]::WindowWidth } catch { $script:ConsoleWidth = 80 }
    }

    # Header engine variables used by Write-CustomHeader
    if (-not $script:PaddingSymbol) { $script:PaddingSymbol = "#" }
    if (-not $script:PaddingSymbolColor) { $script:PaddingSymbolColor = "DarkBlue" }
    if (-not $script:HeadingWidth) { $script:HeadingWidth = [int]$script:ConsoleWidth }
    if (-not $script:IndentationIncrement) { $script:IndentationIncrement = 2 }
    if (-not $script:TitleColor) { $script:TitleColor = $script:textColorTitle }
    if (-not $script:TitleContentPadding) { $script:TitleContentPadding = 2 }
    if (-not $script:AuthorDateColor) { $script:AuthorDateColor = $script:textColorIntro }
    if (-not $script:AuthorDateContentPadding) { $script:AuthorDateContentPadding = 1 }
    if (-not $script:DescriptionColor) { $script:DescriptionColor = $script:textColorIntro }
    if (-not $script:ScriptName) { $script:ScriptName = "Orion Design Framework – UI Demo" }
    if (-not $script:scriptAuthorAndDate) { $script:scriptAuthorAndDate = "Sune Alexandersen Narud · 2025-08" }
    if (-not $script:ScriptDescription) { 
        $script:ScriptDescription = @"
This is a quick visual tour of the UI design helpers.
We’ll render a header, a section menu, action rows with results,
questions, steps, and a centered-line sample.
"@.Trim()
    }

    # NOTE: A couple of your writers reference misspelled variable names.
    # Define those too so the demo doesn't error (maps to the intended ones).
    $script:sectionActiondividerType = $script:sectionAction_dividerType
    $script:sectionStepDividerColor = $script:sectionStep_DividerColor

    # ---- Demo starts here ----
    Write-DemoHeader "Write-Banner"
    Write-Banner

    Write-DemoHeader "Write-Section"
    Write-Section "Section"

    Write-DemoHeader "Write-MenuChoices"
    Write-MenuChoices "1) MenuChoice 1"
    Write-MenuChoices "2) Settings"
    Write-MenuChoices "q) Exit"

    Write-DemoHeader "Write-Question"
    Write-Question "Your choice (1/2/q)?"
    Write-Host " Y (Sample choice)"
    

    Write-DemoHeader "Write-Action with Write-ActionResult" -ForegroundColor Cyan
    Write-Action "Write Action --> Result OK"
    Write-ActionResult "OK!"
    Write-Action "Write Action --> Result Warning"
    Write-ActionResult "Warning"
    Write-Action "Write Action --> Result Fail"
    Write-ActionResult "Fail"

    Write-Action "Write Action --> Counting users"
    Write-ActionResult "42 users"
    Write-Action "Write Action --> Result Something"
    Write-ActionResult "Something"
    Write-Action "Write Action --> Result Activated"
    Write-ActionResult "Activated"

    Write-DemoHeader "Write-ActionResultNoNewLine"
    Write-Action "Write Action --> Counting users"
    Write-ActionResultNoNewline "Action Result No Newline"
    Write-Host " normal text"

    Write-DemoHeader "Write-Step"
    Write-Step "Step 1: Connect to Graph"

    Write-Host
    Write-Host "End of demo" -ForegroundColor Yellow

}

#Show-OrionDemo

# Functions for text-formatting
function Write-Action {
    param (
        [string]$Text
    )

    # Old name: Write-Host-Action

    # Pad or truncate the string to the desired length
    $paddedText = $Text.PadRight($Write_Action_Width).Substring(0, $Write_Action_Width)

    # Output the result
    Write-Host $paddedText -NoNewline
}

function Write-ActionResult {
    param (
        [string]$Text,
        [string]$Foregroundcolor
    )

    # Ensure the text is 15 characters wide and right-justified
    $Text = $Text.PadLeft(15)

    if ($Foregroundcolor) {
        Write-Host $Text -ForegroundColor $Foregroundcolor
    }
    else {
        
        if ($Text -match "Fail") {
            Write-Host $Text -ForegroundColor $TextColor_Fail
        }
        elseif ($Text -match "OK!" -OR $Text -match "(?i)activated" -OR $Text -match "(?i)devices" -OR $Text -match "(?i)users" -OR $Text -match "(?i)embers") {
            Write-Host $Text -ForegroundColor $TextColor_Success
        }
        else {
            Write-Host $Text -ForegroundColor $TextColor_Warning
        }
    }
}

function Write-ActionResultNoNewLine {
    param (
        [string]$Text,
        [string]$Foregroundcolor
    )

    # Ensure the text is 15 characters wide and right-justified
    $Text = $Text.PadLeft(15)

    if ($Foregroundcolor) {
        Write-Host $Text -ForegroundColor $Foregroundcolor -NoNewline
    }
    else {
        
        if ($Text -match "Fail") {
            Write-Host $Text -ForegroundColor $TextColor_Fail -NoNewline
        }
        elseif ($Text -match "OK!" -OR $Text -match "(?i)activated" -OR $Text -match "(?i)devices" -OR $Text -match "(?i)users" -OR $Text -match "(?i)embers") {
            Write-Host $Text -ForegroundColor $TextColor_Success -NoNewline
        }
        else {
            Write-Host $Text -ForegroundColor $TextColor_Warning -NoNewline
        }
    }
}

function Center-Text {
    param (
        [string]$Text,
        [int]$TotalWidth
    )
    $Text = $Text.Trim()
    $PaddingTotal = $TotalWidth - $Text.Length
    if ($PaddingTotal -lt 0) { $PaddingTotal = 0 }  # Ensure no negative padding
    $PaddingLeft = [math]::Floor($PaddingTotal / 2)
    $PaddingRight = [math]::Ceiling($PaddingTotal / 2)
    return (' ' * $PaddingLeft) + $Text + (' ' * $PaddingRight)
}
function Write-Banner {
    Clear-Host
    # Helper function to calculate equal padding with indentation on both sides
    function Get-Padding {
        param (
            [int]$TotalWidth,
            [int]$LeftIndentLength,
            [int]$RightIndentLength,
            [string]$Content,
            [int]$ContentPadding
        )
        $ContentLength = $Content.Length + (2 * $ContentPadding)  # Adjust for content padding
        $PaddingWidth = $TotalWidth - $LeftIndentLength - $RightIndentLength - $ContentLength
        $PaddingEachSide = [math]::Floor($PaddingWidth / 2)
        $PaddingRemainder = $PaddingWidth % 2
        $LeftPadding = $Banner_PaddingSymbol * $PaddingEachSide
        $RightPadding = $Banner_PaddingSymbol * ($PaddingEachSide + $PaddingRemainder)
        return @($LeftPadding, $RightPadding)
    }

    # Calculate indentations based on the Indentation Increment
    $Indentations = @()
    for ($i = 0; $i -le 3; $i++) {
        $Indentations += ' ' * ($Banner_IndentationIncrement * $i)
    }

    # Line 1: Indentation Level 0
    $Indent1 = $Indentations[0]
    $PaddingWidth1 = $Banner_Width - ($Indent1.Length * 2)
    $Line1Padding = $Banner_PaddingSymbol * $PaddingWidth1
    Write-Host ($Indent1 + $Line1Padding + $Indent1) -ForegroundColor $Banner_PaddingSymbolColor

    # Line 2: Indentation Level 1
    $Indent2 = $Indentations[1]
    $Content2 = $Banner_ScriptName
    $Content2Color = $Banner_TitleColor
    $ContentPadding2 = $Banner_TitleContentPadding
    $Padding2 = Get-Padding -TotalWidth $Banner_Width -LeftIndentLength $Indent2.Length -RightIndentLength $Indent2.Length -Content $Content2 -ContentPadding $ContentPadding2
    # Left padding
    Write-Host ($Indent2 + $Padding2[0]) -ForegroundColor $Banner_PaddingSymbolColor -NoNewline
    # Content
    $PaddingSpaces2 = ' ' * $ContentPadding2
    Write-Host ($PaddingSpaces2 + $Content2 + $PaddingSpaces2) -ForegroundColor $Content2Color -NoNewline
    # Right padding
    Write-Host ($Padding2[1] + $Indent2) -ForegroundColor $Banner_PaddingSymbolColor

    # Line 3: Indentation Level 2
    $Indent3 = $Indentations[2]
    $Content3 = $Banner_ScriptAuthorAndDate
    $Content3Color = $Banner_AuthorDateColor
    $ContentPadding3 = $Banner_AuthorDateContentPadding
    $Padding3 = Get-Padding -TotalWidth $Banner_Width -LeftIndentLength $Indent3.Length -RightIndentLength $Indent3.Length -Content $Content3 -ContentPadding $ContentPadding3
    # Left padding
    Write-Host ($Indent3 + $Padding3[0]) -ForegroundColor $Banner_PaddingSymbolColor -NoNewline
    # Content
    $PaddingSpaces3 = ' ' * $ContentPadding3
    Write-Host ($PaddingSpaces3 + $Content3 + $PaddingSpaces3) -ForegroundColor $Content3Color -NoNewline
    # Right padding
    Write-Host ($Padding3[1] + $Indent3) -ForegroundColor $Banner_PaddingSymbolColor

    # Line 4: Indentation Level 3
    $Indent4 = $Indentations[3]
    $PaddingWidth4 = $Banner_Width - ($Indent4.Length * 2)
    $Line4Padding = $Banner_PaddingSymbol * $PaddingWidth4
    Write-Host ($Indent4 + $Line4Padding + $Indent4) -ForegroundColor $Banner_PaddingSymbolColor

    # Description Lines
    $DescriptionLines = $Banner_ScriptDescription -split "`r?`n"
    foreach ($line in $DescriptionLines) {
        $centeredLine = Center-Text -Text $line.Trim() -TotalWidth $Banner_Width
        Write-Host $centeredLine -ForegroundColor $Banner_DescriptionColor
    }
    Write-Host
}

function Write-DemoHeader {
    param (
        [string]$Text
    )

    $Text = $Text + "  |"
    $Text_Intro = "This is a demo of "
    $Text_Length = $Text.Length + $Text_Intro.Length + 3

    # Output the result
    Write-Host
    Write-Host
    Write-Host ("-" * $Text_Length) -ForegroundColor $TextColor_Demo
    Write-Host "|  " -ForegroundColor $TextColor_Demo -NoNewline
    Write-Host $Text_Intro -NoNewline -ForegroundColor $TextColor_DemoIntro
    Write-Host $Text -ForegroundColor $TextColor_Demo
    Write-Host ("-" * $Text_Length) -ForegroundColor $TextColor_Demo
    Write-Host
}

function Write-MenuChoices {
    param (
        [string]$Text,
        [int]$Length = 60
    )

    # Output a headline
    Write-Host "$Text" -foregroundcolor $TextColor_MenuChoices 
}

function Write-Question {
    param (
        [string]$Text
    )

    # Output a headline
    Write-Host
    Write-Host "$Text " -nonewline -ForegroundColor $TextColor_Question
}
function Write-Section {
    param (
        [string]$Text
    )
    # Get the length of the text
    $charCount = $Text.Length

    # Calculate the padding needed on both sides
    $padding = [math]::Max(0, ($Console_Width - $charCount) / 2)

    # Create the padded text
    $paddedText = (' ' * $padding) + $Text + (' ' * $padding)

    # Adjust in case of odd console width and text length
    if (($Console_Width - $charCount) % 2 -ne 0) {
        $paddedText += ' '
    }

    # Output the centered text
    Write-Host ("$sectionActiondividerType" * $Console_Width) -ForegroundColor  $DividerColor_Step
    Write-Host "`e[1m$paddedText`e[0m" -ForegroundColor  $TextColor_Step
    Write-Host ("$sectionActiondividerType" * $Console_Width) -ForegroundColor  $DividerColor_Step
}
Function Write-Step {
    param (
        [string]$Text
    )
    $Char_Count = $Text.Length
    Write-Host
    Write-Host $Text -ForegroundColor $TextColor_Step
    Write-Host ("$DividerType_Step" * $Char_Count + "-" ) -ForegroundColor $DividerColor_Step
}
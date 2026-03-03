function Show-OrionSmartMenu {
    <#
    .SYNOPSIS
        Displays a reusable interactive menu with smart input mode selection.

    .DESCRIPTION
        Show-OrionSmartMenu automatically chooses between arrow-key navigation and
        numeric input mode based on the number of options.

        Arrow mode is used when option count is less than or equal to ArrowThreshold.
        Numeric mode is used when option count is greater than ArrowThreshold.

        If a rich console host is unavailable for arrow-key input, the function
        falls back to numeric mode automatically.

    .PARAMETER Title
        Title displayed at the top of the menu.

    .PARAMETER Prompt
        Prompt text displayed above options.

    .PARAMETER Options
        Menu options to display.

    .PARAMETER ArrowThreshold
        Maximum option count for arrow mode. Default is 5.

    .PARAMETER ReturnObject
        Returns a rich object with SelectedIndex, SelectedOption, and Mode.
        By default, only the selected option text is returned.

    .PARAMETER Demo
        Renders a static demonstration of both Arrow mode and Numeric mode without
        requiring any user input. Useful for previewing the menu appearance.

    .OUTPUTS
        System.String by default.
        System.Management.Automation.PSCustomObject when -ReturnObject is specified.

    .EXAMPLE
        Show-OrionSmartMenu -Demo

    .EXAMPLE
        Show-OrionSmartMenu -Title 'Main Menu' -Prompt 'Choose an action:' -Options @('Run','Exit')

    .EXAMPLE
        Show-OrionSmartMenu -Title 'Tenant Explorer' -Prompt 'Choose an action:' -Options $menuOptions -ReturnObject

    .NOTES
        Author:  Sune Alexandersen Narud
        Version: 1.0.0
        Date:    February 2026
    #>

    [CmdletBinding(DefaultParameterSetName = 'Interactive')]
    [OutputType([string])]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Interactive')]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(Mandatory, ParameterSetName = 'Interactive')]
        [ValidateNotNullOrEmpty()]
        [string]$Prompt,

        [Parameter(Mandatory, ParameterSetName = 'Interactive')]
        [ValidateNotNullOrEmpty()]
        [string[]]$Options,

        [Parameter(ParameterSetName = 'Interactive')]
        [ValidateRange(1, 50)]
        [int]$ArrowThreshold = 5,

        [Parameter(ParameterSetName = 'Interactive')]
        [switch]$ReturnObject,

        [Parameter(Mandatory, ParameterSetName = 'Demo')]
        [switch]$Demo
    )

    if ($Demo) {
        $demoArrowOptions = @('Start Service', 'Stop Service', 'Restart Service')
        $demoNumericOptions = @('Create User', 'Delete User', 'Modify User', 'List Users', 'Reset Password', 'Assign Role', 'Revoke Role')

        Write-Host ''
        Write-Host '  Show-OrionSmartMenu Demo' -ForegroundColor Cyan
        Write-Host '  ========================' -ForegroundColor DarkGray
        Write-Host ''

        $demoCodeArrow = @(
            '$options = @(''Start Service'', ''Stop Service'', ''Restart Service'')'
            'Show-OrionSmartMenu -Title ''Service Manager'' -Prompt ''Choose an action:'' -Options $options'
        )
        $demoCodeNumeric = @(
            '$options = @(''Create User'', ''Delete User'', ''Modify User'', ''List Users'', ''Reset Password'', ''Assign Role'', ''Revoke Role'')'
            'Show-OrionSmartMenu -Title ''User Management'' -Prompt ''Choose an action:'' -Options $options'
        )

        $renderCodeBlock = {
            param([string[]]$Lines)
            $innerWidth = ($Lines | Measure-Object -Property Length -Maximum).Maximum + 2
            $bar = '─' * $innerWidth
            Write-Host '  # Code' -ForegroundColor DarkGray
            Write-Host "  ┌$bar┐" -ForegroundColor DarkGray
            foreach ($line in $Lines) {
                $padded = "  $line".PadRight($innerWidth)
                Write-Host "  │" -ForegroundColor DarkGray -NoNewline
                Write-Host $padded -ForegroundColor Green -NoNewline
                Write-Host '│' -ForegroundColor DarkGray
            }
            Write-Host "  └$bar┘" -ForegroundColor DarkGray
            Write-Host ''
        }

        # Arrow mode demo
        Write-Host '  [Arrow Mode]  (triggered when options <= ArrowThreshold)' -ForegroundColor Yellow
        Write-Host ''
        & $renderCodeBlock -Lines $demoCodeArrow
        if (Get-Command -Name 'Write-Separator' -ErrorAction SilentlyContinue) {
            try { Write-Separator 'Service Manager' -Style Thick } catch { Write-Host '=== Service Manager ===' }
        } else {
            Write-Host '=== Service Manager ==='
        }
        Write-Host 'Choose an action:'
        Write-Host 'Use Up/Down arrows and Enter.' -ForegroundColor DarkGray
        Write-Host ''
        for ($i = 0; $i -lt $demoArrowOptions.Count; $i++) {
            if ($i -eq 1) {
                Write-Host "> $($demoArrowOptions[$i])" -ForegroundColor Cyan
            } else {
                Write-Host "  $($demoArrowOptions[$i])"
            }
        }

        Write-Host ''
        Write-Host '  [Numeric Mode]  (triggered when options > ArrowThreshold)' -ForegroundColor Yellow
        Write-Host ''
        & $renderCodeBlock -Lines $demoCodeNumeric
        if (Get-Command -Name 'Write-Separator' -ErrorAction SilentlyContinue) {
            try { Write-Separator 'User Management' -Style Thick } catch { Write-Host '=== User Management ===' }
        } else {
            Write-Host '=== User Management ==='
        }
        Write-Host 'Choose an action:'
        Write-Host ''
        for ($i = 0; $i -lt $demoNumericOptions.Count; $i++) {
            Write-Host ('{0}. {1}' -f ($i + 1), $demoNumericOptions[$i])
        }
        Write-Host "Choose 1-$($demoNumericOptions.Count): " -NoNewline -ForegroundColor Gray
        Write-Host '(demo - no input required)' -ForegroundColor DarkGray
        Write-Host ''
        return
    }

    $normalizedOptions = @($Options | ForEach-Object {
            if ($null -eq $_) { '' } else { $_.Trim() }
        })

    if ($normalizedOptions.Count -eq 0) {
        throw 'Options cannot be empty.'
    }

    if (($normalizedOptions | Where-Object { [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) {
        throw 'Options cannot contain null, empty, or whitespace-only values.'
    }

    $canReadArrowKeys = $true
    try {
        $null = [Console]::KeyAvailable
    }
    catch {
        $canReadArrowKeys = $false
    }

    $mode = if ($normalizedOptions.Count -le $ArrowThreshold -and $canReadArrowKeys) { 'Arrow' } else { 'Numeric' }

    $renderHeader = {
        param(
            [string]$MenuTitle,
            [string]$MenuPrompt,
            [string]$CurrentMode
        )

        if (Get-Command -Name 'Write-Separator' -ErrorAction SilentlyContinue) {
            try {
                Write-Separator $MenuTitle -Style Thick
            }
            catch {
                Write-Host "=== $MenuTitle ==="
            }
        }
        else {
            Write-Host "=== $MenuTitle ==="
        }

        Write-Host $MenuPrompt
        if ($CurrentMode -eq 'Arrow') {
            Write-Host 'Use Up/Down arrows and Enter.' -ForegroundColor DarkGray
        }

        Write-Host ''
    }

    if ($mode -eq 'Arrow') {
        $selectedIndex = 0

        while ($true) {
            Clear-Host
            & $renderHeader -MenuTitle $Title -MenuPrompt $Prompt -CurrentMode $mode

            for ($optionIndex = 0; $optionIndex -lt $normalizedOptions.Count; $optionIndex++) {
                if ($optionIndex -eq $selectedIndex) {
                    Write-Host "> $($normalizedOptions[$optionIndex])" -ForegroundColor Cyan
                }
                else {
                    Write-Host "  $($normalizedOptions[$optionIndex])"
                }
            }

            $keyInfo = [Console]::ReadKey($true)
            switch ($keyInfo.Key) {
                'UpArrow' {
                    if ($selectedIndex -le 0) {
                        $selectedIndex = $normalizedOptions.Count - 1
                    }
                    else {
                        $selectedIndex--
                    }
                }
                'DownArrow' {
                    if ($selectedIndex -ge ($normalizedOptions.Count - 1)) {
                        $selectedIndex = 0
                    }
                    else {
                        $selectedIndex++
                    }
                }
                'Enter' {
                    break
                }
            }
        }
    }
    else {
        $menuNumber = 0

        Clear-Host
        & $renderHeader -MenuTitle $Title -MenuPrompt $Prompt -CurrentMode $mode

        for ($optionIndex = 0; $optionIndex -lt $normalizedOptions.Count; $optionIndex++) {
            Write-Host ('{0}. {1}' -f ($optionIndex + 1), $normalizedOptions[$optionIndex])
        }

        do {
            $rawInput = Read-Host "Choose 1-$($normalizedOptions.Count)"
            $isNumber = [int]::TryParse($rawInput, [ref]$menuNumber)
            $isInRange = $isNumber -and $menuNumber -ge 1 -and $menuNumber -le $normalizedOptions.Count

            if (-not $isInRange) {
                Write-Host "Invalid selection. Enter a number from 1 to $($normalizedOptions.Count)." -ForegroundColor Yellow
            }
        }
        until ($isInRange)

        $selectedIndex = $menuNumber - 1
    }

    $selectedOption = $normalizedOptions[$selectedIndex]

    if ($ReturnObject) {
        [pscustomobject]@{
            SelectedIndex  = $selectedIndex
            SelectedOption = $selectedOption
            Mode           = $mode
        }
    }
    else {
        $selectedOption
    }
}

<#
================================================================================
ORION DESIGN - POWERSHELL UI FRAMEWORK | Write-Dashboard Function
================================================================================
Author:        Sune Alexandersen Narud  
Date:          August 22, 2025
Module:        OrionDesign v1.5.0
Category:      Data Presentation
Dependencies:  OrionDesign Theme System, Helper Functions

FUNCTION PURPOSE:
Creates multi-section dashboards with metrics, progress bars, and data panels.
Advanced component of OrionDesign's Data Presentation category, providing
comprehensive system monitoring and status overview displays.

HLD INTEGRATION:
┌─ DATA PRESENTATION ─┐    ┌─ HELPER FUNCTIONS ─┐   ┌─ OUTPUT ─┐
│ Write-Dashboard     │◄──►│ Write-DashboardRow │──►│ Metrics  │
│ • Multi-Column      │    │ Render-Section     │   │ Progress │
│ • Metrics Display   │    │ Get-DefaultSections│   │ Lists    │
│ • Progress Bars     │    │ Theming Support    │   │ Layout   │
│ • List Content      │    └────────────────────┘   └──────────┘
└─────────────────────┘
================================================================================
#>

<#
.SYNOPSIS
Creates a comprehensive system dashboard with multiple information panels.

.DESCRIPTION
The Write-Dashboard function displays a comprehensive dashboard with system information, metrics, and status indicators in a beautiful layout.

.PARAMETER Sections
Array of section objects to display on the dashboard.

.PARAMETER Title
Title for the dashboard.

.PARAMETER Columns
Number of columns for layout (1-3).

.PARAMETER RefreshInterval
Auto-refresh interval in seconds (0 = no refresh).

.PARAMETER Theme
Color theme for the dashboard.

.PARAMETER ShowTimestamp
Show timestamp on the dashboard.

.EXAMPLE
Write-Dashboard -Title "System Status" -Sections @(
    @{Title="CPU Usage"; Content="75%"; Type="Metric"; Value=75},
    @{Title="Memory"; Content="8.2GB / 16GB"; Type="Progress"; Value=51},
    @{Title="Services"; Content=@("IIS: Running", "SQL: Running"); Type="List"}
)

Displays a system dashboard with CPU, memory, and services information.

.EXAMPLE
Write-Dashboard -Title "Project Status" -Columns 2 -ShowTimestamp

Displays a project status dashboard in 2-column layout with timestamp.
#>
function Write-Dashboard {
    [CmdletBinding()]
    param(
        [array]$Sections = @(),
        [string]$Title = "Dashboard",
        [ValidateRange(1,3)][int]$Columns = 2,
        [int]$RefreshInterval = 0,
        [ValidateSet('Default', 'Dark', 'Bright', 'Minimal')] [string]$Theme = 'Default',
        [switch]$ShowTimestamp
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

    # Apply theme variations
    switch ($Theme) {
        'Dark' {
            $script:Theme.Accent = 'DarkCyan'
            $script:Theme.Text = 'Gray'
            $script:Theme.Muted = 'DarkGray'
        }
        'Bright' {
            $script:Theme.Accent = 'Yellow'
            $script:Theme.Success = 'Green'
            $script:Theme.Warning = 'Red'
        }
        'Minimal' {
            $script:Theme.Accent = 'White'
            $script:Theme.Success = 'White'
            $script:Theme.Warning = 'White'
            $script:Theme.Error = 'White'
        }
    }

    # If no sections provided, create default system dashboard
    if ($Sections.Count -eq 0) {
        $Sections = Get-DefaultSystemSections
    }

    Clear-Host

    # Dashboard header - use global max width if available
    $headerWidth = if ($script:OrionMaxWidth) { $script:OrionMaxWidth } else { 80 }
    Write-Host
    Write-Host ("═" * $headerWidth) -ForegroundColor $script:Theme.Accent
    
    # Title line
    $titleLine = "  📊 $Title  "
    if ($ShowTimestamp) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $titleLine += "[$timestamp]"
    }
    $padding = $headerWidth - $titleLine.Length - 2
    $leftPad = [Math]::Floor($padding / 2)
    $rightPad = $padding - $leftPad

    Write-Host "║" -ForegroundColor $script:Theme.Accent -NoNewline
    Write-Host (" " * $leftPad) -NoNewline
    Write-Host $titleLine -ForegroundColor $script:Theme.Accent -NoNewline
    Write-Host (" " * $rightPad) -NoNewline
    Write-Host "║" -ForegroundColor $script:Theme.Accent

    Write-Host ("═" * $headerWidth) -ForegroundColor $script:Theme.Accent
    Write-Host

    # Layout sections in columns
    $sectionWidth = [Math]::Floor(($headerWidth - 2 - ($Columns - 1) * 2) / $Columns)
    $sectionsPerColumn = [Math]::Ceiling($Sections.Count / $Columns)

    for ($row = 0; $row -lt $sectionsPerColumn; $row++) {
        $rowSections = @()
        
        for ($col = 0; $col -lt $Columns; $col++) {
            $sectionIndex = $col * $sectionsPerColumn + $row
            if ($sectionIndex -lt $Sections.Count) {
                $rowSections += $Sections[$sectionIndex]
            } else {
                $rowSections += $null
            }
        }

        Write-DashboardRow -Sections $rowSections -Width $sectionWidth
        if ($row -lt $sectionsPerColumn - 1) {
            Write-Host
        }
    }

    # Dashboard footer
    Write-Host
    Write-Host ("═" * $headerWidth) -ForegroundColor $script:Theme.Accent

    # Auto-refresh
    if ($RefreshInterval -gt 0) {
        Write-Host "🔄 Auto-refresh every $RefreshInterval seconds (Press Ctrl+C to stop)" -ForegroundColor $script:Theme.Muted
        Start-Sleep -Seconds $RefreshInterval
        Write-Dashboard -Sections $Sections -Title $Title -Columns $Columns -RefreshInterval $RefreshInterval -Theme $Theme -ShowTimestamp:$ShowTimestamp
    }
}

# Helper function to create dashboard row
function Write-DashboardRow {
    param([array]$Sections, [int]$Width)
    
    $maxHeight = 0
    $sectionOutputs = @()

    # Pre-render all sections to determine max height
    foreach ($section in $Sections) {
        if ($section) {
            $output = Render-DashboardSection -Section $section -Width $Width
            $sectionOutputs += $output
            if ($output.Count -gt $maxHeight) { $maxHeight = $output.Count }
        } else {
            $sectionOutputs += $null
        }
    }

    # Output each line of the row
    for ($line = 0; $line -lt $maxHeight; $line++) {
        for ($i = 0; $i -lt $Sections.Count; $i++) {
            if ($sectionOutputs[$i] -and $line -lt $sectionOutputs[$i].Count) {
                Write-Host $sectionOutputs[$i][$line] -NoNewline
            } elseif ($sectionOutputs[$i]) {
                Write-Host (" " * $Width) -NoNewline
            }
            
            if ($i -lt $Sections.Count - 1) {
                Write-Host "  " -NoNewline  # Column separator
            }
        }
        Write-Host
    }
}

# Helper function to render individual dashboard section
function Render-DashboardSection {
    param($Section, [int]$Width)
    
    $output = @()
    
    # Section header
    $output += "┌" + ("─" * ($Width - 2)) + "┐"
    
    # Title
    $title = " $($Section.Title) "
    $titlePadding = $Width - $title.Length - 2
    $output += "│$title" + (" " * $titlePadding) + "│"
    
    # Separator
    $output += "├" + ("─" * ($Width - 2)) + "┤"

    # Content based on type
    switch ($Section.Type) {
        'Metric' {
            $value = if ($Section.Value) { $Section.Value } else { 0 }
            $barLength = [Math]::Round(($value / 100) * ($Width - 6))
            
            $metricLine = "│ "
            for ($i = 0; $i -lt $barLength; $i++) { $metricLine += "█" }
            for ($i = $barLength; $i -lt ($Width - 6); $i++) { $metricLine += "░" }
            $metricLine += " │"
            $output += $metricLine
            
            $valueLine = "│ $($Section.Content)".PadRight($Width - 1) + "│"
            $output += $valueLine
        }
        
        'Progress' {
            $value = if ($Section.Value) { $Section.Value } else { 0 }
            $progressLine = "│ Progress: $value%".PadRight($Width - 1) + "│"
            $output += $progressLine
            
            $barLength = [Math]::Round(($value / 100) * ($Width - 4))
            $barLine = "│ "
            for ($i = 0; $i -lt $barLength; $i++) { $barLine += "▰" }
            for ($i = $barLength; $i -lt ($Width - 4); $i++) { $barLine += "▱" }
            $barLine += "│"
            $output += $barLine
        }
        
        'List' {
            if ($Section.Content -is [array]) {
                foreach ($item in $Section.Content) {
                    $itemLine = "│ • $item".PadRight($Width - 1) + "│"
                    if ($itemLine.Length -gt $Width) {
                        $itemLine = $itemLine.Substring(0, $Width - 4) + "...│"
                    }
                    $output += $itemLine
                }
            } else {
                $contentLine = "│ $($Section.Content)".PadRight($Width - 1) + "│"
                $output += $contentLine
            }
        }
        
        'Status' {
            $statusIcon = switch ($Section.Status) {
                'Good' { "✅" }
                'Warning' { "⚠️" }
                'Error' { "❌" }
                default { "ℹ️" }
            }
            $statusLine = "│ $statusIcon $($Section.Content)".PadRight($Width - 1) + "│"
            $output += $statusLine
        }
        
        default {
            $contentLine = "│ $($Section.Content)".PadRight($Width - 1) + "│"
            $output += $contentLine
        }
    }

    # Footer
    $output += "└" + ("─" * ($Width - 2)) + "┘"
    
    return $output
}

# Helper function to get default system sections
function Get-DefaultSystemSections {
    $sections = @()
    
    try {
        # CPU Usage
        $cpu = Get-WmiObject -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average
        $cpuUsage = [Math]::Round($cpu.Average, 1)
        $sections += @{Title="CPU Usage"; Content="$cpuUsage%"; Type="Metric"; Value=$cpuUsage}
        
        # Memory Usage
        $memory = Get-WmiObject -Class Win32_OperatingSystem
        $totalRAM = [Math]::Round($memory.TotalVisibleMemorySize / 1MB, 1)
        $freeRAM = [Math]::Round($memory.FreePhysicalMemory / 1MB, 1)
        $usedRAM = $totalRAM - $freeRAM
        $memoryPercent = [Math]::Round(($usedRAM / $totalRAM) * 100, 1)
        $sections += @{Title="Memory"; Content="$usedRAM GB / $totalRAM GB"; Type="Progress"; Value=$memoryPercent}
        
        # Disk Usage
        $disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | Select-Object -First 1
        $diskTotal = [Math]::Round($disk.Size / 1GB, 1)
        $diskFree = [Math]::Round($disk.FreeSpace / 1GB, 1)
        $diskUsed = $diskTotal - $diskFree
        $diskPercent = [Math]::Round(($diskUsed / $diskTotal) * 100, 1)
        $sections += @{Title="Disk C:"; Content="$diskUsed GB / $diskTotal GB"; Type="Progress"; Value=$diskPercent}
        
        # System Info
        $computerInfo = Get-ComputerInfo
        $uptime = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
        $uptimeText = "$($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m"
        $sections += @{Title="System Info"; Content=@($computerInfo.WindowsProductName, "Uptime: $uptimeText"); Type="List"}
        
        # Network Status
        $networkAdapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and $_.Virtual -eq $false}
        $networkInfo = $networkAdapters | ForEach-Object { "$($_.Name): Connected" }
        $sections += @{Title="Network"; Content=$networkInfo; Type="List"}
        
        # Services Status
        $services = @("Themes", "Winmgmt", "EventLog") | ForEach-Object {
            $service = Get-Service -Name $_ -ErrorAction SilentlyContinue
            if ($service) { "$($_.Name): $($service.Status)" }
        }
        $sections += @{Title="Key Services"; Content=$services; Type="List"}
        
    } catch {
        $sections += @{Title="System Info"; Content="Unable to gather system information"; Type="Status"; Status="Error"}
    }
    
    return $sections
}

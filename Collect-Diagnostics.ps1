# Save as: Collect-Diagnostics.ps1

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logDir = "$env:USERPROFILE\Desktop\Diagnostics_$timestamp"
New-Item -Path $logDir -ItemType Directory -Force

# System Information
Get-ComputerInfo | Out-File "$logDir\SystemInfo.txt"

# Disk Usage
Get-PSDrive -PSProvider 'FileSystem' | Select Name, Used, Free, @{Name="Used(GB)";Expression={[math]::round($_.Used / 1GB, 2)}}, @{Name="Free(GB)";Expression={[math]::round($_.Free / 1GB, 2)}} | Out-File "$logDir\DiskUsage.txt"

# Recent Critical and Error Events
Get-EventLog -LogName System -EntryType Error -Newest 50 | Out-File "$logDir\SystemErrors.txt"
Get-EventLog -LogName Application -EntryType Error -Newest 50 | Out-File "$logDir\AppErrors.txt"

# Windows Updates
Get-WindowsUpdateLog -LogPath "$logDir\WindowsUpdate.log"

Write-Host "Diagnostics collected in $logDir"

# === Dynamic Backup Target Detection ===
$backupSource = "$env:USERPROFILE"
$username = $env:USERNAME
$date = Get-Date -Format "yyyyMMdd_HHmm"

# Default fallback
$backupTarget = "C:\ITTools\Backups\$username"

# Try OneDrive first
if ($env:OneDrive -and (Test-Path $env:OneDrive)) {
    $backupTarget = "$env:OneDrive\Backups\$username"
}
else {
    # Look for SharePoint sync folder
    $sharePointBase = "C:\Users\$username"
    $sharePointMatch = Get-ChildItem $sharePointBase -Directory | Where-Object {
        $_.Name -match ".* - .*" -and (Test-Path "$($_.FullName)\Documents")
    } | Select-Object -First 1

    if ($sharePointMatch) {
        $backupTarget = "$($sharePointMatch.FullName)\Backups\$username"
    }
}

$backupTargetFinal = "$backupTarget\Backup_$date"

# Create destination if it doesn't exist
if (!(Test-Path $backupTargetFinal)) {
    try {
        New-Item -Path $backupTargetFinal -ItemType Directory -Force | Out-Null
    } catch {
        Write-Host "ERROR: Could not create backup directory $backupTargetFinal"
        exit 1
    }
}

# === Backup Operation ===
$foldersToBackup = @("Documents", "Desktop", "Pictures", "Downloads")

foreach ($folder in $foldersToBackup) {
    $sourcePath = Join-Path $backupSource $folder
    $destPath = Join-Path $backupTargetFinal $folder

    if (Test-Path $sourcePath) {
        New-Item -Path $destPath -ItemType Directory -Force | Out-Null
        Robocopy $sourcePath $destPath /MIR /R:2 /W:5 /NFL /NDL /NP /LOG:"$backupTargetFinal\BackupLog.txt"
    }
}

Write-Host "Backup completed to $backupTargetFinal"
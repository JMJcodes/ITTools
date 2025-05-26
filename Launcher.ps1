# Save as: Launcher.ps1

Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "IT Tools Launcher"
$form.Size = New-Object System.Drawing.Size(300,200)

$btnDiagnostics = New-Object System.Windows.Forms.Button
$btnDiagnostics.Text = "Run Diagnostics"
$btnDiagnostics.Size = New-Object System.Drawing.Size(250,30)
$btnDiagnostics.Location = New-Object System.Drawing.Point(20,30)
$btnDiagnostics.Add_Click({
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File C:\ITTools\Collect-Diagnostics.ps1"
})

$btnBackup = New-Object System.Windows.Forms.Button
$btnBackup.Text = "Run Backup"
$btnBackup.Size = New-Object System.Drawing.Size(250,30)
$btnBackup.Location = New-Object System.Drawing.Point(20,70)
$btnBackup.Add_Click({
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File C:\ITTools\Backup-UserData.ps1"
})

$form.Controls.Add($btnDiagnostics)
$form.Controls.Add($btnBackup)
$form.Topmost = $true
$form.ShowDialog()

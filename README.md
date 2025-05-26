# 🛠️ IT Tools Launcher

A GUI-powered Windows diagnostics and backup launcher built for support teams, freelancers, and helpdesk professionals.

---

##  Features

- Run custom PowerShell scripts via a modern GUI
- Backup local folders to OneDrive, SharePoint, or local storage
- View real-time output and logs from backup and diagnostics
- Designed for Windows 10/11, including Windows 365 cloud PCs

---

##  Included Scripts

- `Collect-Diagnostics.ps1` — Collects system info, disk usage, errors, and update logs
- `Backup-UserData.ps1` — Backs up Desktop, Downloads, Pictures, Documents intelligently to the best available storage

---

##  Security & Trust

- Code-signed executable (self-signed for development purposes)
- [VirusTotal Scan](https://www.virustotal.com/) results available
- All source code is open and auditable
- Files do **not** access or transmit any data over the internet

---

## Usage

1. Run `ITToolsLauncher.exe`
2. Click “Run Diagnostics” or “Run Backup”
3. Logs and results will appear in real time
4. Logs are saved with timestamps to your Documents or OneDrive

---

##  Requirements

- Windows 10 or 11
- PowerShell 5.1+
- Python 3.11+ and `pyqt5` for development only

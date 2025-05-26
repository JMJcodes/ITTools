# IT Tools Launcher - PyQt5 GUI Wrapper
# This Python script provides a GUI to launch PowerShell automation scripts

import sys
import subprocess
from PyQt5.QtWidgets import (
    QApplication, QWidget, QPushButton, QVBoxLayout,
    QLabel, QProgressBar, QTextEdit, QHBoxLayout
)
from PyQt5.QtCore import Qt, QThread, pyqtSignal


class ScriptRunner(QThread):
    progress = pyqtSignal(int)
    output = pyqtSignal(str)
    finished = pyqtSignal()

    def __init__(self, script_path):
        super().__init__()
        self.script_path = script_path

    def run(self):
        try:
            proc = subprocess.Popen([
                "powershell.exe", "-ExecutionPolicy", "Bypass", "-File", self.script_path
            ], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)

            for i, line in enumerate(proc.stdout):
                self.output.emit(line.strip())
                if i % 5 == 0:
                    self.progress.emit(min(i, 100))

            self.finished.emit()
        except Exception as e:
            self.output.emit(f"Error: {str(e)}")
            self.finished.emit()


class ITToolsApp(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("IT Tools Launcher")
        self.setFixedSize(500, 350)

        self.layout = QVBoxLayout()

        self.title = QLabel("IT Automation Toolkit")
        self.title.setAlignment(Qt.AlignCenter)
        self.layout.addWidget(self.title)

        # Buttons
        button_layout = QHBoxLayout()

        self.diagnostics_btn = QPushButton("Run Diagnostics")
        self.diagnostics_btn.clicked.connect(self.run_diagnostics)
        button_layout.addWidget(self.diagnostics_btn)

        self.backup_btn = QPushButton("Run Backup")
        self.backup_btn.clicked.connect(self.run_backup)
        button_layout.addWidget(self.backup_btn)

        self.layout.addLayout(button_layout)

        # Progress Bar
        self.progress = QProgressBar()
        self.progress.setValue(0)
        self.layout.addWidget(self.progress)

        # Output Log
        self.output_log = QTextEdit()
        self.output_log.setReadOnly(True)
        self.layout.addWidget(self.output_log)

        self.setLayout(self.layout)

    def run_diagnostics(self):
        self.run_script("C:/ITTools/Collect-Diagnostics.ps1")

    def run_backup(self):
        self.run_script("C:/ITTools/Backup-UserData.ps1")

    def run_script(self, path):
        self.output_log.clear()
        self.progress.setValue(0)
        self.runner = ScriptRunner(path)
        self.runner.progress.connect(self.progress.setValue)
        self.runner.output.connect(self.output_log.append)
        self.runner.finished.connect(lambda: self.output_log.append("\nFinished."))
        self.runner.start()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = ITToolsApp()
    window.show()
    sys.exit(app.exec_())

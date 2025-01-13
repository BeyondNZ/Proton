# Proton app download links
$apps = @(
    @{
        Name = "Proton Mail"
        Check = "ProtonMail.exe"
        URL = "https://proton.me/download/mail/windows/ProtonMail-desktop.exe"
    },
    @{
        Name = "Proton Calendar"
        Check = "ProtonMail.exe"
        URL = "https://proton.me/download/mail/windows/ProtonMail-desktop.exe"
    },
    @{
        Name = "Proton Drive (x64)"
        Check = "Proton Drive.exe"
        URL = "https://proton.me/download/drive/windows/1.8.1/x64/Proton%20Drive%20Setup%201.8.1.exe"
    },
    @{
        Name = "Proton Drive (ARM64)"
        Check = "Proton Drive.exe"
        URL = "https://proton.me/download/drive/windows/1.8.1/arm64/Proton%20Drive%20Setup%201.8.1.exe"
    },
    @{
        Name = "Proton VPN"
        Check = "ProtonVPN.exe"
        URL = "https://protonvpn.com/download-windows/"
    },
    @{
        Name = "Proton Pass"
        Check = "ProtonPass.exe"
        URL = "https://proton.me/download/PassDesktop/win32/x64/ProtonPass_Setup.exe"
    }
)

# Function to check if a file exists
Function IsInstalled($appName) {
    $filePath = Join-Path $env:ProgramFiles $appName
    return Test-Path $filePath
}

# Download and install each app if not installed
foreach ($app in $apps) {
    if (-not (IsInstalled $app.Check)) {
        Write-Host "$($app.Name) not installed. Downloading..."
        $outputPath = Join-Path $env:TEMP ([IO.Path]::GetFileName($app.URL))
        Invoke-WebRequest -Uri $app.URL -OutFile $outputPath
        Start-Process -FilePath $outputPath -ArgumentList "/SILENT" -Wait
        Write-Host "$($app.Name) installed."
    } else {
        Write-Host "$($app.Name) is already installed."
    }
}

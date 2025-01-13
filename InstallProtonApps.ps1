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
        Name = "Proton Drive"
        Check = "Proton Drive.exe"
        URLs = @{
            x64 = "https://proton.me/download/drive/windows/1.8.1/x64/Proton%20Drive%20Setup%201.8.1.exe"
            ARM64 = "https://proton.me/download/drive/windows/1.8.1/arm64/Proton%20Drive%20Setup%201.8.1.exe"
        }
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

# Function to get system architecture
Function Get-Architecture {
    $arch = [Environment]::Is64BitOperatingSystem
    if ($arch -and ([System.Environment]::OSVersion.Platform -eq "Win32NT")) {
        if ([System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture -eq "Arm64") {
            return "ARM64"
        } else {
            return "x64"
        }
    }
    return "Unknown"
}

# Detect architecture
$arch = Get-Architecture
if ($arch -eq "Unknown") {
    Write-Host "Unknown system architecture. Aborting."
    exit
}

# Download and install each app if not installed
foreach ($app in $apps) {
    if (-not (IsInstalled $app.Check)) {
        Write-Host "$($app.Name) not installed. Downloading..."
        if ($app.Name -eq "Proton Drive") {
            # Use appropriate URL based on architecture
            $url = $app.URLs.$arch
        } else {
            $url = $app.URL
        }

        $outputPath = Join-Path $env:TEMP ([IO.Path]::GetFileName($url))
        Invoke-WebRequest -Uri $url -OutFile $outputPath
        Start-Process -FilePath $outputPath -ArgumentList "/SILENT" -Wait
        Write-Host "$($app.Name) installed."
    } else {
        Write-Host "$($app.Name) is already installed."
    }
}

#!/bin/bash

# 1. Detect the Distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
else
    echo "Error: Could not detect the operating system."
    exit 1
fi

# 2. Map Derivative Distros (Mint/Pop/Zorin)
case "$OS" in
    linuxmint)
        OS="ubuntu"
        if [[ "$VER" == "22"* ]]; then VER="24.04"; fi
        if [[ "$VER" == "21"* ]]; then VER="22.04"; fi
        if [[ "$VER" == "20"* ]]; then VER="20.04"; fi
        ;;
    pop|zorin)
        OS="ubuntu"
        ;;
esac

# 3. Installation Logic
install_powershell() {
    case "$OS" in
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y wget apt-transport-https software-properties-common
            wget -q "https://packages.microsoft.com/config/$OS/$VER/packages-microsoft-prod.deb" -O packages-microsoft-prod.deb
            sudo dpkg -i packages-microsoft-prod.deb
            rm packages-microsoft-prod.deb
            sudo apt-get update
            sudo apt-get install -y powershell
            ;;
        fedora|rhel|centos|almalinux|rocky)
            MAJOR_VER=$(echo $VER | cut -d. -f1)
            sudo rpm -Uvh "https://packages.microsoft.com/config/rhel/$MAJOR_VER/packages-microsoft-prod.rpm"
            sudo dnf install -y powershell
            ;;
        arch|manjaro)
            if command -v yay >/dev/null 2>&1; then
                yay -S powershell-bin --noconfirm
            else
                echo "Arch-based system detected but 'yay' not found. Please install manually."
                exit 1
            fi
            ;;
        *)
            echo "Distribution '$OS' not supported."
            exit 1
            ;;
    esac
}

install_powershell

# 4. Post-Install: Update PSReadLine and Set Profile
if command -v pwsh >/dev/null 2>&1; then
    echo "Updating PowerShell modules and adding functions..."
    
    pwsh -NoProfile -Command "
        Install-Module -Name PSReadLine -AllowClobber -Force;
        if (!(Test-Path -Path \$PROFILE)) { New-Item -ItemType File -Path \$PROFILE -Force };
        
        # Adding your specific functions and settings
        Add-Content -Path \$PROFILE -Value 'Set-PSReadLineOption -PredictionSource History'
        Add-Content -Path \$PROFILE -Value 'Set-PSReadLineOption -PredictionViewStyle ListView'
        Add-Content -Path \$PROFILE -Value 'Function C {CLS}'
        Add-Content -Path \$PROFILE -Value 'Function CC {CD / ; If (\$IsLinux) {CD ~} ; CLS}'
        Add-Content -Path \$PROFILE -Value 'Function LL {Get-ChildItem -Force \$args}'
    "
    
    echo "------------------------------------------------"
    echo "Installation Complete!"
    echo "Functions C, CC, and LL are now in your profile."
    pwsh -v
else
    echo "Installation failed."
    exit 1
fi

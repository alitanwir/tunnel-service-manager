# Tunnel Service Script - ngrok and pinggy.io
# Author: Ali Tanwir
# Description: Interactive PowerShell script to expose localhost using ngrok or pinggy.io

# Set console title
$Host.UI.RawUI.WindowTitle = "Tunnel Service Manager"

# Color functions for better output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-OK {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

# Service Selection Menu
function Show-Menu {
    Write-Host "Select tunneling service:" -ForegroundColor White
    Write-Host "1. ngrok (ngrok.com)" -ForegroundColor White
    Write-Host "2. pinggy.io" -ForegroundColor White
    Write-Host "3. Exit" -ForegroundColor White
    Write-Host ""
}

# ngrok Setup and Configuration
function Start-NgrokSetup {
    Write-Host ""
    Write-Host "=== NGROK CONFIGURATION ===" -ForegroundColor Magenta
    
    Write-Info "Checking ngrok authentication..."
    
    # Check if ngrok config file exists and has authtoken
    $ngrokConfigPath = "$env:USERPROFILE\AppData\Local\ngrok\ngrok.yml"
    $ngrokConfigFound = $false
    
    if (Test-Path $ngrokConfigPath) {
        Write-Info "Found ngrok config file, checking for authtoken..."
        $configContent = Get-Content $ngrokConfigPath -Raw
        if ($configContent -match "authtoken:") {
            Write-OK "Found authtoken in ngrok config file"
            $ngrokConfigFound = $true
        }
    }
    
    # Check if ngrok is authenticated via config check
    try {
        $null = & ngrok config check 2>$null
        Write-OK "ngrok is already authenticated"
        Show-NgrokTunnelType
        return
    } catch {
        Write-Info "ngrok is not authenticated"
        
        # If config file has authtoken but ngrok check failed, try to use it
        if ($ngrokConfigFound) {
            Write-Info "Attempting to use authtoken from config file..."
            $configContent = Get-Content $ngrokConfigPath
            $tokenLine = $configContent | Where-Object { $_ -match "authtoken:" }
            if ($tokenLine) {
                $configToken = ($tokenLine -split ":")[1].Trim()
                try {
                    & ngrok config add-authtoken $configToken
                    Write-OK "ngrok authenticated using config file token"
                    Show-NgrokTunnelType
                    return
                } catch {
                    Write-Warning "Failed to use config file token"
                }
            }
        }
        
        # Check for NGROK_AUTHTOKEN environment variable
        if ($env:NGROK_AUTHTOKEN) {
            Write-OK "Found NGROK_AUTHTOKEN environment variable"
            Write-Info "Authenticating ngrok..."
            try {
                & ngrok config add-authtoken $env:NGROK_AUTHTOKEN
                Write-OK "ngrok authenticated successfully"
                Show-NgrokTunnelType
                return
            } catch {
                Write-Error "Failed to authenticate ngrok with provided token"
                Read-Host "Press Enter to continue"
                return
            }
        } else {
            Write-Warning "No ngrok authtoken found"
            Write-Host "Please set your ngrok authtoken using one of these methods:" -ForegroundColor White
            Write-Host "  1. Set environment variable: `$env:NGROK_AUTHTOKEN='your_token_here'" -ForegroundColor White
            Write-Host "  2. Add to config file: $ngrokConfigPath" -ForegroundColor White
            Write-Host "  3. Run manually: ngrok config add-authtoken YOUR_TOKEN" -ForegroundColor White
            Write-Host ""
            Read-Host "Press Enter to continue"
            return
        }
    }
}

function Show-NgrokTunnelType {
    Write-Host ""
    Write-Host "Select tunnel type for ngrok:" -ForegroundColor White
    Write-Host "1. HTTP/HTTPS (web traffic)" -ForegroundColor White
    Write-Host "2. TCP (raw TCP traffic)" -ForegroundColor White
    Write-Host ""
    
    do {
        $ngrokType = Read-Host "Enter your choice (1-2)"
        switch ($ngrokType) {
            "1" { 
                Start-NgrokHttp
                break
            }
            "2" { 
                Start-NgrokTcp
                break
            }
            default { 
                Write-Error "Invalid choice. Please try again."
            }
        }
    } while ($ngrokType -notin @("1", "2"))
}

function Start-NgrokHttp {
    Write-Host ""
    $port = Read-Host "Enter local port to tunnel (default: 80)"
    if ([string]::IsNullOrEmpty($port)) { $port = "80" }
    
    # Check for custom domain
    $ngrokCmd = "ngrok http $port"
    if ($env:NGROK_CUSTOM_DOMAIN) {
        Write-Info "Using custom domain: $($env:NGROK_CUSTOM_DOMAIN)"
        $ngrokCmd = "ngrok http --hostname=$($env:NGROK_CUSTOM_DOMAIN) $port"
    }
    
    Write-Info "Starting ngrok HTTP tunnel on port $port..."
    Write-Info "Press Ctrl+C to stop the tunnel"
    Write-Host ""
    
    try {
        Invoke-Expression $ngrokCmd
    } catch {
        Write-Error "Failed to start ngrok tunnel"
    }
}

function Start-NgrokTcp {
    Write-Host ""
    do {
        $port = Read-Host "Enter local port to tunnel"
        if ([string]::IsNullOrEmpty($port)) {
            Write-Error "Port is required for TCP tunnel"
        }
    } while ([string]::IsNullOrEmpty($port))
    
    # Note: Custom domains are not supported for TCP tunnels in ngrok
    $ngrokCmd = "ngrok tcp $port"
    if ($env:NGROK_CUSTOM_DOMAIN) {
        Write-Warning "Custom domains are not supported for TCP tunnels in ngrok"
        Write-Info "Using default TCP tunnel (custom domain ignored)"
    }
    
    Write-Info "Starting ngrok TCP tunnel on port $port..."
    Write-Info "Press Ctrl+C to stop the tunnel"
    Write-Host ""
    
    try {
        Invoke-Expression $ngrokCmd
    } catch {
        Write-Error "Failed to start ngrok tunnel"
    }
}

# pinggy.io Setup and Configuration
function Start-PinggySetup {
    Write-Host ""
    Write-Host "=== PINGGY.IO CONFIGURATION ===" -ForegroundColor Magenta
    
    # Check for PINGGY_TOKEN environment variable
    if ($env:PINGGY_TOKEN) {
        Write-OK "Found PINGGY_TOKEN environment variable"
        $pinggyUser = $env:PINGGY_TOKEN
    } else {
        Write-Warning "PINGGY_TOKEN environment variable not found"
        Write-Info "Using anonymous access (limited features)"
        $pinggyUser = "a"
    }
    
    Write-Host ""
    Write-Host "Select tunnel type for pinggy.io:" -ForegroundColor White
    Write-Host "1. HTTP/HTTPS (web traffic)" -ForegroundColor White
    Write-Host "2. TCP (raw TCP traffic)" -ForegroundColor White
    Write-Host ""
    
    do {
        $pinggyType = Read-Host "Enter your choice (1-2)"
        switch ($pinggyType) {
            "1" { 
                Start-PinggyHttp -User $pinggyUser
                break
            }
            "2" { 
                Start-PinggyTcp -User $pinggyUser
                break
            }
            default { 
                Write-Error "Invalid choice. Please try again."
            }
        }
    } while ($pinggyType -notin @("1", "2"))
}

function Start-PinggyHttp {
    param([string]$User)
    
    Write-Host ""
    $port = Read-Host "Enter local port to tunnel (default: 80)"
    if ([string]::IsNullOrEmpty($port)) { $port = "80" }
    
    Write-Info "Starting pinggy.io HTTP tunnel on port $port..."
    Write-Info "Press Ctrl+C to stop the tunnel"
    Write-Host ""
    
    try {
        & ssh -p 443 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R0:localhost:$port "$User+force@free.pinggy.io"
    } catch {
        Write-Error "Failed to start pinggy.io tunnel"
    }
}

function Start-PinggyTcp {
    param([string]$User)
    
    Write-Host ""
    do {
        $port = Read-Host "Enter local port to tunnel"
        if ([string]::IsNullOrEmpty($port)) {
            Write-Error "Port is required for TCP tunnel"
        }
    } while ([string]::IsNullOrEmpty($port))
    
    Write-Info "Starting pinggy.io TCP tunnel on port $port..."
    Write-Info "Press Ctrl+C to stop the tunnel"
    Write-Host ""
    
    try {
        & ssh -p 443 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R0:localhost:$port "$User+force+tcp@free.pinggy.io"
    } catch {
        Write-Error "Failed to start pinggy.io tunnel"
    }
}

function Show-ExitMessage {
    Write-Host ""
    Write-Success "Thank you for using Tunnel Service Manager!"
    Write-Info "Remember to set your environment variables:"
    Write-Host "  NGROK_AUTHTOKEN=your_ngrok_token" -ForegroundColor White
    Write-Host "  NGROK_CUSTOM_DOMAIN=your_custom_domain.ngrok.io" -ForegroundColor White
    Write-Host "  PINGGY_TOKEN=your_pinggy_token" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
}

# Main header
Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "     Tunnel Service Manager" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

# Check if required tools are installed
Write-Info "Checking for required tools..."

# Check for ngrok
try {
    $null = Get-Command ngrok -ErrorAction Stop
    Write-OK "ngrok found"
} catch {
    Write-Error "ngrok is not installed or not in PATH"
    Write-Info "Please install ngrok from https://ngrok.com/download"
    Read-Host "Press Enter to exit"
    exit 1
}

# Check for ssh (needed for pinggy)
try {
    $null = Get-Command ssh -ErrorAction Stop
    Write-OK "SSH client found"
} catch {
    Write-Error "SSH client is not installed or not in PATH"
    Write-Info "Please install OpenSSH client or use Windows 10/11 built-in version"
    Write-Info "You can install it via: Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0"
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""

# Main menu loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-3)"
    
    switch ($choice) {
        "1" { 
            Start-NgrokSetup
            break
        }
        "2" { 
            Start-PinggySetup
            break
        }
        "3" { 
            Show-ExitMessage
            exit 0
        }
        default { 
            Write-Error "Invalid choice. Please try again."
            Write-Host ""
        }
    }
} while ($true)
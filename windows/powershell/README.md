# 🚇 Tunnel Service Manager (PowerShell)

A beautiful, color-coded PowerShell script that provides an interactive interface to expose your localhost using either **ngrok** or **pinggy.io** tunneling services.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- 🎨 **Color-coded output** with beautiful console colors
- 🔄 **Interactive menu system** with easy navigation
- 🌐 **Dual tunneling services** - ngrok and pinggy.io support
- 🔐 **Smart authentication** - automatic token detection
- 🚀 **HTTP/HTTPS and TCP tunnels** support
- ⚡ **Real-time status updates** with colored messages
- 🛡️ **Comprehensive error handling** and validation
- 📱 **Custom domain support** for ngrok (HTTP only)
- 🔧 **Environment variable integration**

## 🎯 Quick Start

1. **Download the script:**
   ```powershell
   # Clone or download tunnel.ps1
   ```

2. **Run the script:**
   ```powershell
   .\tunnel.ps1
   ```

3. **Follow the interactive menu:**
   - Choose your tunneling service (ngrok or pinggy.io)
   - Select tunnel type (HTTP/HTTPS or TCP)
   - Enter your local port
   - Enjoy your public tunnel! 🎉

## 📋 Prerequisites

### Required Tools
- **PowerShell 5.1+** (Windows 10/11 built-in)
- **ngrok** - Download from [ngrok.com/download](https://ngrok.com/download)
- **SSH Client** - Usually pre-installed on Windows 10/11

### Optional Tools
- **jq** - For enhanced JSON parsing with pinggy.io

## 🔧 Installation & Setup

### 1. Install ngrok
```powershell
# Download from https://ngrok.com/download
# Extract to a folder in your PATH or add to PATH
```

### 2. Install SSH Client (if needed)
```powershell
# Install OpenSSH client via PowerShell
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

### 3. Set up Environment Variables

#### For ngrok:
```powershell
# PowerShell (temporary)
$env:NGROK_AUTHTOKEN="your_ngrok_authtoken_here"
$env:NGROK_CUSTOM_DOMAIN="your_custom_domain.ngrok.io"  # Optional

# PowerShell (permanent)
[Environment]::SetEnvironmentVariable("NGROK_AUTHTOKEN", "your_token", "User")
[Environment]::SetEnvironmentVariable("NGROK_CUSTOM_DOMAIN", "your_domain", "User")
```

#### For pinggy.io:
```powershell
# PowerShell (temporary)
$env:PINGGY_TOKEN="your_pinggy_token_here"

# PowerShell (permanent)
[Environment]::SetEnvironmentVariable("PINGGY_TOKEN", "your_token", "User")
```

## 🎨 Color-Coded Output

The script uses beautiful colors to enhance user experience:

- 🔵 **Cyan** - Information messages (`[INFO]`)
- 🟢 **Green** - Success messages (`[SUCCESS]`, `[OK]`)
- 🟡 **Yellow** - Warning messages (`[WARNING]`)
- 🔴 **Red** - Error messages (`[ERROR]`)
- 🟣 **Magenta** - Section headers and menu titles
- ⚪ **White** - Regular text and menu options

## 🚀 Usage Examples

### Basic Usage
```powershell
# Run the script
.\tunnel.ps1

# Follow the interactive prompts:
# 1. Select tunneling service (1 for ngrok, 2 for pinggy.io)
# 2. Choose tunnel type (1 for HTTP/HTTPS, 2 for TCP)
# 3. Enter local port (e.g., 3000, 8080, 3306)
```

### Common Use Cases

#### Web Development
```powershell
# Expose a local web server on port 3000
# Choose: ngrok → HTTP/HTTPS → Port 3000
# Result: https://abc123.ngrok.io → localhost:3000
```

#### Database Access
```powershell
# Expose MySQL on port 3306
# Choose: ngrok → TCP → Port 3306
# Result: tcp://0.tcp.ngrok.io:12345 → localhost:3306
```

#### API Testing
```powershell
# Expose REST API on port 8080
# Choose: pinggy.io → HTTP/HTTPS → Port 8080
# Result: https://abc123.free.pinggy.io → localhost:8080
```

## 🔐 Authentication Setup

### ngrok Authentication

#### Method 1: Environment Variable (Recommended)
```powershell
$env:NGROK_AUTHTOKEN="your_authtoken_here"
```

#### Method 2: Config File
Create/edit `%USERPROFILE%\AppData\Local\ngrok\ngrok.yml`:
```yaml
authtoken: your_authtoken_here
```

#### Method 3: Manual Command
```powershell
ngrok config add-authtoken your_authtoken_here
```

### pinggy.io Authentication
```powershell
$env:PINGGY_TOKEN="your_pinggy_token_here"
```

## 🎛️ Advanced Configuration

### Custom Domains (ngrok HTTP only)
```powershell
# Set custom domain for HTTP tunnels
$env:NGROK_CUSTOM_DOMAIN="myapp.ngrok.io"

# Note: Custom domains are NOT supported for TCP tunnels
```

### SSH Options (pinggy.io)
The script automatically uses optimized SSH options:
- `-p 443` - Use port 443 for better firewall compatibility
- `-o ServerAliveInterval=30` - Keep connection alive
- `-o ServerAliveCountMax=3` - Retry connection
- `-o ExitOnForwardFailure=yes` - Exit on tunnel failure

## 🛠️ Troubleshooting

### Common Issues

#### "ngrok is not installed or not in PATH"
```powershell
# Solution: Add ngrok to your PATH or run from ngrok directory
# Check if ngrok is accessible:
Get-Command ngrok
```

#### "SSH client is not installed"
```powershell
# Solution: Install OpenSSH client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

#### "Failed to authenticate ngrok"
```powershell
# Solution: Set your authtoken
$env:NGROK_AUTHTOKEN="your_token_here"
# Or manually authenticate:
ngrok config add-authtoken your_token_here
```

#### "Custom domains are not supported for TCP tunnels"
```powershell
# This is expected behavior - custom domains only work with HTTP tunnels
# The script will show a warning and use default TCP tunnel
```

### Debug Mode
```powershell
# Run with verbose output to see detailed information
$VerbosePreference = "Continue"
.\tunnel.ps1
```

## 📊 Service Comparison

| Feature | ngrok | pinggy.io |
|---------|-------|-----------|
| **Free Plan** | 1 tunnel, random subdomain | Multiple tunnels, custom subdomain |
| **HTTP/HTTPS** | ✅ Full support | ✅ Full support |
| **TCP Tunnels** | ✅ Full support | ✅ Full support |
| **Custom Domains** | ✅ (HTTP only) | ✅ (with account) |
| **Authentication** | Required | Optional |
| **Connection Limits** | 40/min | Higher limits |

## 🔒 Security Best Practices

- 🔐 **Never share your API tokens** publicly
- 🛡️ **Use environment variables** instead of hardcoding tokens
- ⚠️ **Be cautious** when exposing local services to the internet
- 🔑 **Add authentication** to your local services when possible
- 🚫 **Don't expose sensitive services** (databases, admin panels) without proper security

## 📝 Script Functions

The script includes these PowerShell functions:

- `Write-Info` - Cyan colored information messages
- `Write-Success` - Green colored success messages
- `Write-Warning` - Yellow colored warning messages
- `Write-Error` - Red colored error messages
- `Write-OK` - Green colored OK messages
- `Show-Menu` - Interactive menu display
- `Start-NgrokSetup` - ngrok configuration and setup
- `Start-PinggySetup` - pinggy.io configuration and setup
- `Show-ExitMessage` - Exit message display

## 🤝 Contributing

Feel free to contribute to this project by:
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 📝 Improving documentation
- 🔧 Submitting pull requests

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](/LICENSE) file for details.

## 🙏 Acknowledgments

- [ngrok](https://ngrok.com) - For providing excellent tunneling services
- [pinggy.io](https://pinggy.io) - For providing free SSH tunneling
- PowerShell Community - For the amazing scripting environment

---

**Made with ❤️ by [Ali Tanwir](https://alitanwir.com) for developers who need quick and easy localhost tunneling!**

For MacOS/Linux users, see the Shell version: [tunnel.sh](/unix/shell/tunnel.sh) and [README.md](/unix/shell/README.md)
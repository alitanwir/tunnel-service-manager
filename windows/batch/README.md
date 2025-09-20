# Tunnel Service Manager - Setup Guide

This batch script allows you to expose your localhost using either ngrok or pinggy.io services with an interactive interface.

## Prerequisites

1. **ngrok**: Download and install from [https://ngrok.com/download](https://ngrok.com/download)
2. **SSH Client**: Usually pre-installed on Windows 10/11, or install OpenSSH client
3. **jq** (optional): For better JSON parsing with pinggy.io. Download from [https://stedolan.github.io/jq/download/](https://stedolan.github.io/jq/download/)

## Environment Variables Setup

### For ngrok:
1. Sign up for a free account at [https://ngrok.com](https://ngrok.com)
2. Get your authtoken from the dashboard
3. Set up authentication using one of these methods:

**Method 1: Environment Variable**
```cmd
set NGROK_AUTHTOKEN=your_ngrok_authtoken_here
```

**Method 2: Config File (Recommended)**
Create or edit `%USERPROFILE%\AppData\Local\ngrok\ngrok.yml`:
```yaml
authtoken: your_ngrok_authtoken_here
```

**Method 3: Manual Authentication**
```cmd
ngrok config add-authtoken your_ngrok_authtoken_here
```

**Custom Domain (Optional):**
If you have a custom domain with ngrok:
```cmd
set NGROK_CUSTOM_DOMAIN=your_custom_domain.ngrok.io
```

**Permanent setup (System Environment Variables):**
1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Click "Environment Variables"
3. Under "User variables" or "System variables", click "New"
4. Variable name: `NGROK_AUTHTOKEN` (and optionally `NGROK_CUSTOM_DOMAIN`)
5. Variable value: `your_ngrok_authtoken_here`

### For pinggy.io:
1. Sign up for a free account at [https://pinggy.io](https://pinggy.io)
2. Get your API token from the dashboard
3. Set the environment variable:

**Windows Command Prompt:**
```cmd
set PINGGY_TOKEN=your_pinggy_token_here
```

**Windows PowerShell:**
```powershell
$env:PINGGY_TOKEN="your_pinggy_token_here"
```

**Permanent setup (System Environment Variables):**
1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Click "Environment Variables"
3. Under "User variables" or "System variables", click "New"
4. Variable name: `PINGGY_TOKEN`
5. Variable value: `your_pinggy_token_here`

## Usage

1. Run `tunnel.bat` from Command Prompt or PowerShell
2. Choose your tunneling service (ngrok or pinggy.io)
3. Select tunnel type (HTTP/HTTPS or TCP)
4. Enter the local port you want to expose
5. The script will start the tunnel and display the public URL

## Features

- **Interactive Menu**: Choose between ngrok and pinggy.io
- **Smart Authentication**: Automatically checks ngrok config file, environment variables, and manual setup
- **Custom Domain Support**: Uses custom domains for ngrok when available
- **Environment Variables**: Uses secure environment variables for API tokens
- **Tunnel Types**: Support for both HTTP/HTTPS and TCP tunnels
- **SSH Integration**: Uses SSH commands for pinggy.io tunneling with keep-alive and force-close options
- **Error Handling**: Comprehensive error checking and user feedback
- **Clear Output**: Easy-to-read console output with status prefixes

## Troubleshooting

### ngrok Issues:
- If ngrok authentication fails, manually run: `ngrok config add-authtoken YOUR_TOKEN`
- Ensure ngrok is in your system PATH
- Check your internet connection
- The script automatically checks for authtoken in `%USERPROFILE%\AppData\Local\ngrok\ngrok.yml`
- Custom domains require a paid ngrok plan
- Set `NGROK_CUSTOM_DOMAIN` environment variable for custom domain support

### pinggy.io Issues:
- The script works without authentication but with limited features
- For full features, set the `PINGGY_TOKEN` environment variable
- Ensure SSH client is installed and accessible
- If SSH is not available, install OpenSSH client via PowerShell: `Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0`
- Uses `free.pinggy.io` domain with keep-alive packets for stable connections
- Automatically closes existing tunnels before establishing new ones

### General Issues:
- Make sure all required tools (ngrok, SSH client) are installed
- Check that your local service is running on the specified port
- Verify your firewall settings allow the connections

## Free Account Limits

### ngrok:
- 1 simultaneous tunnel
- Random subdomain names
- 40 connections per minute

### pinggy.io:
- Multiple simultaneous tunnels
- Custom subdomain names (with account)
- Higher connection limits

## Security Notes

- Never share your API tokens
- Use environment variables instead of hardcoding tokens
- Be cautious when exposing local services to the internet
- Consider using authentication on your local services

---

**Made with ❤️ by [Ali Tanwir](https://alitanwir.com) for developers who need quick and easy localhost tunneling!**

For MacOS/Linux users, see the Shell version: [tunnel.sh](/unix/shell/tunnel.sh) and [README.md](/unix/shell/README.md)
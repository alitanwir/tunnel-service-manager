# 🚇 Tunnel Service Manager (Shell Script)

A beautiful, color-coded shell script that provides an interactive interface to expose your localhost using either **ngrok** or **pinggy.io** tunneling services. Compatible with **macOS** and **Linux** terminals.

![Shell](https://img.shields.io/badge/Shell-Bash-blue.svg)
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- 🎨 **Color-coded output** with beautiful terminal colors
- 🔄 **Interactive menu system** with easy navigation
- 🌐 **Dual tunneling services** - ngrok and pinggy.io support
- 🔐 **Smart authentication** - automatic token detection
- 🚀 **HTTP/HTTPS and TCP tunnels** support
- ⚡ **Real-time status updates** with colored messages
- 🛡️ **Comprehensive error handling** and validation
- 📱 **Custom domain support** for ngrok (HTTP only)
- 🔧 **Environment variable integration**
- 🍎 **macOS and Linux compatible**

## 🎯 Quick Start

1. **Download the script:**
   ```bash
   # Clone or download tunnel.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x tunnel.sh
   ```

3. **Run the script:**
   ```bash
   ./tunnel.sh
   ```

4. **Follow the interactive menu:**
   - Choose your tunneling service (ngrok or pinggy.io)
   - Select tunnel type (HTTP/HTTPS or TCP)
   - Enter your local port
   - Enjoy your public tunnel! 🎉

## 📋 Prerequisites

### Required Tools
- **Bash 4.0+** (usually pre-installed on macOS and Linux)
- **ngrok** - Download from [ngrok.com/download](https://ngrok.com/download)
- **SSH Client** - Usually pre-installed on macOS and Linux

### Installation Commands

#### macOS (using Homebrew)
```bash
# Install ngrok
brew install ngrok/ngrok/ngrok

# Install SSH client (if needed)
brew install openssh
```

#### Ubuntu/Debian
```bash
# Install ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xzf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin/

# Install SSH client (if needed)
sudo apt-get update
sudo apt-get install openssh-client
```

#### CentOS/RHEL/Fedora
```bash
# Install ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xzf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin/

# Install SSH client (if needed)
sudo yum install openssh-clients
# or for newer versions:
sudo dnf install openssh-clients
```

## 🔧 Environment Variables Setup

### For ngrok:
```bash
# Temporary (current session)
export NGROK_AUTHTOKEN="your_ngrok_authtoken_here"
export NGROK_CUSTOM_DOMAIN="your_custom_domain.ngrok.io"  # Optional

# Permanent (add to ~/.bashrc, ~/.zshrc, or ~/.profile)
echo 'export NGROK_AUTHTOKEN="your_ngrok_authtoken_here"' >> ~/.bashrc
echo 'export NGROK_CUSTOM_DOMAIN="your_custom_domain.ngrok.io"' >> ~/.bashrc
source ~/.bashrc
```

### For pinggy.io:
```bash
# Temporary (current session)
export PINGGY_TOKEN="your_pinggy_token_here"

# Permanent (add to ~/.bashrc, ~/.zshrc, or ~/.profile)
echo 'export PINGGY_TOKEN="your_pinggy_token_here"' >> ~/.bashrc
source ~/.bashrc
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
```bash
# Run the script
./tunnel.sh

# Follow the interactive prompts:
# 1. Select tunneling service (1 for ngrok, 2 for pinggy.io)
# 2. Choose tunnel type (1 for HTTP/HTTPS, 2 for TCP)
# 3. Enter local port (e.g., 3000, 8080, 3306)
```

### Common Use Cases

#### Web Development
```bash
# Expose a local web server on port 3000
# Choose: ngrok → HTTP/HTTPS → Port 3000
# Result: https://abc123.ngrok.io → localhost:3000
```

#### Database Access
```bash
# Expose MySQL on port 3306
# Choose: ngrok → TCP → Port 3306
# Result: tcp://0.tcp.ngrok.io:12345 → localhost:3306
```

#### API Testing
```bash
# Expose REST API on port 8080
# Choose: pinggy.io → HTTP/HTTPS → Port 8080
# Result: https://abc123.free.pinggy.io → localhost:8080
```

## 🔐 Authentication Setup

### ngrok Authentication

#### Method 1: Environment Variable (Recommended)
```bash
export NGROK_AUTHTOKEN="your_authtoken_here"
```

#### Method 2: Config File
Create/edit `~/.config/ngrok/ngrok.yml`:
```yaml
authtoken: your_authtoken_here
```

#### Method 3: Manual Command
```bash
ngrok config add-authtoken your_authtoken_here
```

### pinggy.io Authentication
```bash
export PINGGY_TOKEN="your_pinggy_token_here"
```

## 🎛️ Advanced Configuration

### Custom Domains (ngrok HTTP only)
```bash
# Set custom domain for HTTP tunnels
export NGROK_CUSTOM_DOMAIN="myapp.ngrok.io"

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
```bash
# Solution: Add ngrok to your PATH or install it
# Check if ngrok is accessible:
which ngrok
# or
command -v ngrok
```

#### "SSH client is not installed"
```bash
# macOS Solution:
brew install openssh

# Ubuntu/Debian Solution:
sudo apt-get install openssh-client

# CentOS/RHEL Solution:
sudo yum install openssh-clients
```

#### "Failed to authenticate ngrok"
```bash
# Solution: Set your authtoken
export NGROK_AUTHTOKEN="your_token_here"
# Or manually authenticate:
ngrok config add-authtoken your_token_here
```

#### "Custom domains are not supported for TCP tunnels"
```bash
# This is expected behavior - custom domains only work with HTTP tunnels
# The script will show a warning and use default TCP tunnel
```

#### "Permission denied" when running script
```bash
# Solution: Make the script executable
chmod +x tunnel.sh
```

### Debug Mode
```bash
# Run with verbose output to see detailed information
bash -x ./tunnel.sh
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
- 🔒 **Use HTTPS** when possible for web services

## 📝 Script Functions

The script includes these shell functions:

- `write_info()` - Cyan colored information messages
- `write_success()` - Green colored success messages
- `write_warning()` - Yellow colored warning messages
- `write_error()` - Red colored error messages
- `write_ok()` - Green colored OK messages
- `show_menu()` - Interactive menu display
- `start_ngrok_setup()` - ngrok configuration and setup
- `start_pinggy_setup()` - pinggy.io configuration and setup
- `show_exit_message()` - Exit message display

## 🍎 macOS Specific Notes

### Homebrew Installation
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install ngrok via Homebrew
brew install ngrok/ngrok/ngrok
```

### Shell Compatibility
- The script is compatible with both **Bash** and **Zsh**
- For Zsh users, add the environment variables to `~/.zshrc` instead of `~/.bashrc`

## 🐧 Linux Specific Notes

### Distribution-Specific Installation

#### Arch Linux
```bash
# Install ngrok
yay -S ngrok
# or
sudo pacman -S ngrok

# Install SSH client
sudo pacman -S openssh
```

#### openSUSE
```bash
# Install ngrok (download from official site)
# Install SSH client
sudo zypper install openssh
```

### Systemd Service (Optional)
You can create a systemd service to run the tunnel script automatically:

```bash
# Create service file
sudo nano /etc/systemd/system/tunnel.service

# Add the following content:
[Unit]
Description=Tunnel Service Manager
After=network.target

[Service]
Type=simple
User=your_username
WorkingDirectory=/path/to/script
ExecStart=/path/to/script/tunnel.sh
Restart=always

[Install]
WantedBy=multi-user.target

# Enable and start the service
sudo systemctl enable tunnel.service
sudo systemctl start tunnel.service
```

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
- Shell Scripting Community - For the amazing scripting environment

---

**Made with ❤️ by [Ali Tanwir](https://alitanwir.com) for developers who need quick and easy localhost tunneling on macOS and Linux!**

For Windows users, see the PowerShell version: [tunnel.ps1](/windows/powershell/tunnel.ps1) and [README.md](/windows/powershell/README.md)

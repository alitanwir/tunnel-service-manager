# 🚇 Tunnel Service Manager

Tunnel Service Manager lets you expose your localhost to the internet using either **ngrok** or **pinggy.io** tunneling services. It provides interactive scripts for **Windows (PowerShell & Batch)** and **Unix (Shell)** environments.

---

## ✨ Features

- 🎨 Color-coded output for easy readability
- 🔄 Interactive menu system
- 🌐 Dual tunneling services: ngrok and pinggy.io
- 🔐 Smart authentication (automatic token/config detection)
- 🚀 HTTP/HTTPS and TCP tunnel support
- ⚡ Real-time status updates
- 🛡️ Comprehensive error handling
- 📱 Custom domain support (ngrok HTTP only)
- 🔧 Environment variable integration
- 🍎 macOS, Linux, and Windows compatibility

---

## 📋 Prerequisites

### Required Tools

- **ngrok** ([Download](https://ngrok.com/download))
- **SSH Client** (OpenSSH, usually pre-installed)
- **jq** (optional, for pinggy.io JSON parsing)

### Platform Requirements

- **Windows:** PowerShell 5.1+ or Command Prompt
- **macOS/Linux:** Bash 4.0+ or Zsh

---

## 🔧 Installation & Setup

### ngrok Authentication

1. **Sign up** at [ngrok.com](https://ngrok.com) and get your authtoken.
2. **Authenticate ngrok** using one of these methods:

   - **Environment Variable:**
     - Windows (PowerShell):  
       `$env:NGROK_AUTHTOKEN="your_token"`
     - Windows (Batch):  
       `set NGROK_AUTHTOKEN=your_token`
     - Unix/Shell:  
       `export NGROK_AUTHTOKEN="your_token"`

   - **Config File:**  
     - Windows: `%USERPROFILE%\AppData\Local\ngrok\ngrok.yml`
     - Unix: `~/.config/ngrok/ngrok.yml`
     ```yaml
     authtoken: your_token
     ```

   - **Manual Command:**  
     `ngrok config add-authtoken your_token`

   - **Custom Domain (HTTP only):**
     - Windows (PowerShell):  
       `$env:NGROK_CUSTOM_DOMAIN="your_custom_domain.ngrok.io"`
     - Windows (Batch):  
       `set NGROK_CUSTOM_DOMAIN=your_custom_domain.ngrok.io`
     - Unix/Shell:  
       `export NGROK_CUSTOM_DOMAIN="your_custom_domain.ngrok.io"`

### pinggy.io Authentication

1. **Sign up** at [pinggy.io](https://pinggy.io) and get your API token.
2. **Set environment variable:**
   - Windows (PowerShell):  
     `$env:PINGGY_TOKEN="your_token"`
   - Windows (Batch):  
     `set PINGGY_TOKEN=your_token`
   - Unix/Shell:  
     `export PINGGY_TOKEN="your_token"`

---

## 🚀 Usage

1. **Windows PowerShell:**  
   Run [tunnel.ps1](/windows/powershell/tunnel.ps1)
2. **Windows Batch:**  
   Run [tunnel.bat](/windows/batch/tunnel.bat)
3. **Unix Shell:**  
   Make executable and run [tunnel.sh](/unix/shell/tunnel.sh)

Follow the interactive prompts to select service, tunnel type, and port.

---

## 📊 Service Comparison

| Feature            | ngrok                | pinggy.io                |
|--------------------|----------------------|--------------------------|
| Free Plan          | 1 tunnel, random subdomain | Multiple tunnels, custom subdomain |
| HTTP/HTTPS         | ✅                   | ✅                       |
| TCP Tunnels        | ✅                   | ✅                       |
| Custom Domains     | ✅ (HTTP only)       | ✅ (with account)        |
| Authentication     | Required             | Optional                 |
| Connection Limits  | 40/min               | Higher limits            |

---

## 🛠️ Troubleshooting

- **ngrok not found:** Add ngrok to your PATH.
- **SSH not found:** Install OpenSSH client.
- **Authentication issues:** Ensure tokens are set via environment or config.
- **Custom domains:** Only supported for ngrok HTTP tunnels.
- **Permission denied (shell):** Run `chmod +x tunnel.sh`.

---

## 🔒 Security Best Practices

- Never share your API tokens publicly.
- Use environment variables instead of hardcoding tokens.
- Be cautious when exposing local services.
- Add authentication to your local services.

---

## 🤝 Contributing

- Report bugs
- Suggest features
- Improve documentation
- Submit pull requests

---

## 📄 License

MIT License. See [LICENSE](LICENSE).

---

**Made with ❤️ by [Ali Tanwir](https://alitanwir.com) for developers who need quick and easy localhost tunneling!**

Platform-specific guides:
- Windows PowerShell
- Windows Batch
- Unix Shell
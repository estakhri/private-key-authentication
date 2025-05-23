# 🔐 SSH Key Setup & Password Authentication Disable Tool

This tool automates secure SSH access setup to a remote Linux server by:

- Generating a public/private key pair (if not already present)
- Copying the public key to the server using the provided credentials
- Disabling password-based authentication on the server
- Supporting both **Linux/macOS** and **Windows**

---

## 📦 Features

✅ Cross-platform support  
✅ Automatic dependency checks (sshpass, PuTTY)  
✅ Non-interactive setup using `ssh-copy-id` or `pscp/plink`  
✅ Password authentication disabled after key installation  
✅ Private key path printed after completion  

---

## 🖥️ Supported Platforms

- ✅ Linux
- ✅ macOS
- ✅ Windows (PowerShell + PuTTY)

---

## 📂 File Structure

```
setup_ssh_access/
├── setup_ssh_access         # Cross-platform launcher script
├── linux_mac_setup.sh       # Linux/macOS Bash script
└── windows_setup.ps1        # Windows PowerShell script
```

---

## 🚀 How to Use

### 🐧 Linux/macOS

```bash
chmod +x setup_ssh_access
./setup_ssh_access
```

### 🪟 Windows (PowerShell)

```powershell
.\setup_ssh_access
```

> 🔒 You will be prompted for server address, username, and password.

---

## 🔧 Prerequisites

### Linux/macOS

- `sshpass` (will be installed if not found)
- `ssh`, `ssh-keygen`, `ssh-copy-id`

### Windows

- PowerShell (included by default)
- PuTTY (automatically downloaded and added to PATH if missing)
  - `plink.exe`
  - `pscp.exe`
- `ssh-keygen` (requires Git Bash or OpenSSH from Windows features)

---

## 📌 Output

After successful setup:

```text
✅ SSH key setup complete and password authentication disabled.
🔐 Your private key is located at: /path/to/id_rsa
```

---

## ⚠️ Security Notice

This tool temporarily handles plaintext passwords for automation purposes. Use in secure environments only and consider:

- Using SSH agent or encrypted keys
- Removing passwords immediately after use
- Vaulting secrets for production use

---

## 📄 License

MIT License
